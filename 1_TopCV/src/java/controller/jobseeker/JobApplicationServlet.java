package controller.jobseeker;

import dal.ApplicationDAO;
import dal.CVDAO;
import dal.NotificationDAO;
import model.Application;
import model.CV;
import model.JobSeeker;
import util.SessionHelper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/job-application")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 10,   // 10MB
    maxRequestSize = 1024 * 1024 * 50  // 50MB
)
public class JobApplicationServlet extends HttpServlet {
    
    private ApplicationDAO applicationDAO;
    private CVDAO cvDAO;
    private NotificationDAO notificationDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        applicationDAO = new ApplicationDAO();
        cvDAO = new CVDAO();
        notificationDAO = new NotificationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Lấy thông tin JobSeeker từ session
        JobSeeker jobSeeker = SessionHelper.getCurrentJobSeeker(request);
        if (jobSeeker == null) {
            response.sendRedirect(request.getContextPath() + "/JobSeeker/jobseeker-login.jsp");
            return;
        }
        
        // Lấy danh sách CV của JobSeeker
        List<CV> cvList = cvDAO.getCVsByJobSeekerId(jobSeeker.getJobSeekerId());
        request.setAttribute("cvList", cvList);
        
        // Forward về trang job-detail (hoặc có thể return JSON nếu là AJAX)
        String jobId = request.getParameter("jobId");
        if (jobId != null) {
            response.sendRedirect(request.getContextPath() + "/job-detail?jobId=" + jobId);
        } else {
            response.sendRedirect(request.getContextPath() + "/job-list");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Lấy thông tin JobSeeker từ session
        JobSeeker jobSeeker = SessionHelper.getCurrentJobSeeker(request);
        if (jobSeeker == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập để ứng tuyển\"}");
            return;
        }
        
        try {
            String jobIdStr = request.getParameter("jobId");
            String cvIdStr = request.getParameter("cvId");
            
            if (jobIdStr == null || jobIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin công việc\"}");
                return;
            }
            
            int jobId = Integer.parseInt(jobIdStr);
            int cvId = 0;
            
            // Kiểm tra xem có upload CV mới không (ưu tiên CV mới)
            Part filePart = request.getPart("newCV");
            boolean hasNewCV = (filePart != null && filePart.getSize() > 0);
            boolean hasSelectedCV = (cvIdStr != null && !cvIdStr.trim().isEmpty());
            
            if (hasNewCV) {
                // Ưu tiên sử dụng CV mới được upload
                cvId = handleFileUpload(filePart, jobSeeker.getJobSeekerId());
                if (cvId == 0) {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"success\": false, \"message\": \"Lỗi khi tải lên CV\"}");
                    return;
                }
            } else if (hasSelectedCV) {
                // Sử dụng CV có sẵn nếu không có CV mới
                cvId = Integer.parseInt(cvIdStr);
                
                // Kiểm tra CV có thuộc về JobSeeker này không
                CV selectedCV = cvDAO.getCVById(cvId);
                if (selectedCV == null || selectedCV.getJobSeekerId() != jobSeeker.getJobSeekerId()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\": false, \"message\": \"CV không hợp lệ\"}");
                    return;
                }
            } else {
                // Không có CV nào được chọn hoặc upload
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng chọn CV để ứng tuyển\"}");
                return;
            }
            
            // Kiểm tra xem đã ứng tuyển job này chưa
            if (applicationDAO.hasApplied(jobId, jobSeeker.getJobSeekerId())) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                response.getWriter().write("{\"success\": false, \"message\": \"Bạn đã ứng tuyển vào công việc này rồi\"}");
                return;
            }
            
            // Tạo Application mới
            Application application = new Application();
            application.setJobID(jobId);
            application.setCvID(cvId);
            application.setApplicationDate(LocalDateTime.now());
            application.setStatus("Pending");
            
            // Lưu vào database
            boolean success = applicationDAO.insertApplication(application);
            
            if (success) {
                // Tạo thông báo ứng tuyển thành công
                NotificationDAO.sendNotification(
                    jobSeeker.getJobSeekerId(),
                    "jobseeker",
                    "application",
                    "Ứng tuyển thành công",
                    "Đơn ứng tuyển của bạn đã được gửi thành công. Nhà tuyển dụng sẽ xem xét trong thời gian sớm nhất.",
                    jobId,
                    "job",
                    "/JobSeeker/applied-jobs.jsp",
                    1
                );
                
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"Ứng tuyển thành công!\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"Lỗi khi gửi đơn ứng tuyển\"}");
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Thông tin không hợp lệ\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Đã xảy ra lỗi: " + e.getMessage() + "\"}");
        }
    }
    
    private int handleFileUpload(Part filePart, int jobSeekerId) throws IOException {
        try {
            String fileName = filePart.getSubmittedFileName();
            if (fileName == null || fileName.trim().isEmpty()) {
                return 0;
            }
            
            // Kiểm tra định dạng file
            String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            if (!fileExtension.equals(".pdf") && !fileExtension.equals(".doc") && !fileExtension.equals(".docx")) {
                return 0;
            }
            
            // Tạo tên file unique
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            
            // Đường dẫn lưu file
            String uploadPath = getServletContext().getRealPath("/uploads/cvs/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);
            
            // Tạo CV record mới
            CV newCV = new CV();
            newCV.setJobSeekerId(jobSeekerId);
            newCV.setCvTitle(fileName);
            newCV.setCvURL("/uploads/cvs/" + uniqueFileName);
            newCV.setActive(true);
            newCV.setCreationDate(new java.util.Date());
            
            // Lưu vào database và trả về CV ID
            return cvDAO.insertCV(newCV);
            
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}