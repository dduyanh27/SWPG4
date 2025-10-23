package controller.jobseeker;

import dal.CVDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.CV;
import model.JobSeeker;
import util.SessionHelper;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Date;
import java.util.UUID;

@WebServlet("/UploadCVServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1MB
    maxFileSize = 1024 * 1024 * 5,        // 5MB
    maxRequestSize = 1024 * 1024 * 10     // 10MB
)
public class UploadCVServlet extends HttpServlet {
    
    private CVDAO cvDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        cvDAO = new CVDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra người dùng đã đăng nhập
        JobSeeker currentJobSeeker = SessionHelper.getCurrentJobSeeker(request);
        Integer userId = SessionHelper.getCurrentUserId(request);
        
        if (currentJobSeeker == null || userId == null || !SessionHelper.isJobSeeker(request)) {
            response.sendRedirect(request.getContextPath() + "/JobSeeker/jobseeker-login.jsp");
            return;
        }
        
        try {
            // Lấy file từ request
            Part filePart = request.getPart("cvFile");
            
            if (filePart == null || filePart.getSize() == 0) {
                request.setAttribute("errorMessage", "Vui lòng chọn file để tải lên");
                request.getRequestDispatcher("jobseekerprofile").forward(request, response);
                return;
            }
            
            // Lấy tên file gốc
            String fileName = getFileName(filePart);
            
            // Kiểm tra định dạng file
            if (!isValidFileType(fileName)) {
                request.setAttribute("errorMessage", "Chỉ chấp nhận file .doc, .docx hoặc .pdf");
                request.getRequestDispatcher("jobseekerprofile").forward(request, response);
                return;
            }
            
            // Tạo tên file unique
            String fileExtension = fileName.substring(fileName.lastIndexOf("."));
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            
            // Đường dẫn lưu file
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "cvs";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Lưu file vào thư mục
            String filePath = uploadPath + File.separator + uniqueFileName;
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
            }
            
            // Tạo bản ghi CV trong database
            CV newCV = new CV();
            newCV.setJobSeekerId(userId);
            newCV.setCvTitle(fileName);  // Tên file gốc
            newCV.setCvContent(null);    // Không cần nội dung text
            newCV.setCvURL("/uploads/cvs/" + uniqueFileName);  // Đường dẫn relative
            newCV.setActive(true);
            newCV.setCreationDate(new Date());
            
            // Insert vào database
            int cvId = cvDAO.insertCV(newCV);
            
            if (cvId > 0) {
                request.setAttribute("successMessage", "Tải lên hồ sơ thành công!");
            } else {
                request.setAttribute("errorMessage", "Có lỗi khi lưu hồ sơ vào database");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Redirect về trang profile
        response.sendRedirect(request.getContextPath() + "/jobseekerprofile");
    }
    
    /**
     * Lấy tên file từ Part header
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
    
    /**
     * Kiểm tra định dạng file có hợp lệ không
     */
    private boolean isValidFileType(String fileName) {
        String lowerFileName = fileName.toLowerCase();
        return lowerFileName.endsWith(".pdf") || 
               lowerFileName.endsWith(".doc") || 
               lowerFileName.endsWith(".docx");
    }
}
