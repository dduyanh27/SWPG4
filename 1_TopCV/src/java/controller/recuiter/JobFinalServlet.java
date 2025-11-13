/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.recuiter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import dal.JobDAO;
import dal.RecruiterPackagesDAO;
import dal.JobFeatureMappingsDAO;
import model.Job;
import model.Recruiter;
import model.JobFeatureMappings;
import java.util.List;
import java.time.format.DateTimeFormatter;
import java.time.LocalDateTime;

/**
 *
 * @author Admin
 */
@WebServlet(name = "JobFinalServlet", urlPatterns = {"/jobfinal"})
public class JobFinalServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet JobFinalServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet JobFinalServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("DEBUG JobFinalServlet: doGet() called");
        System.out.println("DEBUG JobFinalServlet: Context Path: " + request.getContextPath());
        
        try {
            // Lấy jobID từ session
            Integer jobID = (Integer) request.getSession().getAttribute("newJobID");
            System.out.println("DEBUG JobFinalServlet: JobID from session: " + jobID);
            
            // Lấy recruiter từ session
            Recruiter recruiter = (Recruiter) request.getSession().getAttribute("recruiter");
            
            if (jobID != null && jobID > 0) {
                // Lấy thông tin job từ database
                JobDAO jobDAO = new JobDAO();
                Job job = jobDAO.getJobById(jobID);
                
                if (job != null) {
                    request.setAttribute("job", job);
                    System.out.println("DEBUG JobFinalServlet: Job found - " + job.getJobTitle());
                } else {
                    System.out.println("DEBUG JobFinalServlet: Job not found with ID: " + jobID);
                    request.setAttribute("error", "Không tìm thấy thông tin công việc!");
                }
            }
            
            // Lấy danh sách packages của recruiter từ database
            if (recruiter != null) {
                RecruiterPackagesDAO recruiterPackagesDAO = new RecruiterPackagesDAO();
                List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> packages = 
                    recruiterPackagesDAO.getRecruiterPackagesWithDetails(recruiter.getRecruiterID());
                
                System.out.println("DEBUG JobFinalServlet: Found " + packages.size() + " total available packages");
                
                // Log tất cả packages để debug
                for (RecruiterPackagesDAO.RecruiterPackagesWithDetails pkg : packages) {
                    System.out.println("DEBUG JobFinalServlet: Package - ID: " + pkg.recruiterPackageID + 
                                     ", Name: " + pkg.packageName + 
                                     ", Type: " + pkg.packageType +
                                     ", Remaining: " + pkg.getRemainingQuantity());
                }
                
                // Filter packages - chỉ lấy packages có PackageType = 'DANG_TUYEN'
                // (Đã filter trong SQL query, nhưng vẫn giữ logic này để an toàn)
                List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> postingPackages = new java.util.ArrayList<>();
                
                for (RecruiterPackagesDAO.RecruiterPackagesWithDetails pkg : packages) {
                    // PackageType phải là "DANG_TUYEN"
                    if (pkg.packageType != null && pkg.packageType.equalsIgnoreCase("DANG_TUYEN")) {
                        postingPackages.add(pkg);
                    }
                }
                
                request.setAttribute("postingPackages", postingPackages);
                
                System.out.println("DEBUG JobFinalServlet: DANG_TUYEN packages found: " + postingPackages.size());
            }
            
        } catch (Exception e) {
            System.out.println("DEBUG JobFinalServlet: Exception occurred: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu: " + e.getMessage());
        }
        
        request.getRequestDispatcher("Recruiter/job-posting-final.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("==========================================");
        System.out.println("DEBUG JobFinalServlet: doPost() called - Processing job posting");
        System.out.println("==========================================");
        
        try {
            // Lấy jobID từ form
            String jobIDStr = request.getParameter("jobID");
            String recruiterPackageIDStr = request.getParameter("package");
            
            if (jobIDStr == null || jobIDStr.isEmpty() || recruiterPackageIDStr == null || recruiterPackageIDStr.isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn gói dịch vụ!");
                doGet(request, response);
                return;
            }
            
            int jobID = Integer.parseInt(jobIDStr);
            int recruiterPackageID = Integer.parseInt(recruiterPackageIDStr);
            
            System.out.println("DEBUG JobFinalServlet: JobID: " + jobID + ", RecruiterPackageID: " + recruiterPackageID);
            
            // Lấy recruiter từ session
            Recruiter recruiter = (Recruiter) request.getSession().getAttribute("recruiter");
            if (recruiter == null) {
                request.setAttribute("error", "Vui lòng đăng nhập!");
                doGet(request, response);
                return;
            }
            
            // Kiểm tra job thuộc về recruiter này
            JobDAO jobDAO = new JobDAO();
            Job job = jobDAO.getJobById(jobID);
            
            if (job == null || job.getRecruiterID() != recruiter.getRecruiterID()) {
                request.setAttribute("error", "Không tìm thấy công việc hoặc bạn không có quyền!");
                doGet(request, response);
                return;
            }
            
            // Lấy thông tin package
            RecruiterPackagesDAO recruiterPackagesDAO = new RecruiterPackagesDAO();
            RecruiterPackagesDAO.RecruiterPackagesWithDetails packageDetails = null;
            List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> allPackages = 
                recruiterPackagesDAO.getRecruiterPackagesWithDetails(recruiter.getRecruiterID());
            
            for (RecruiterPackagesDAO.RecruiterPackagesWithDetails pkg : allPackages) {
                if (pkg.recruiterPackageID == recruiterPackageID) {
                    packageDetails = pkg;
                    break;
                }
            }
            
            if (packageDetails == null) {
                request.setAttribute("error", "Gói dịch vụ không tồn tại hoặc đã hết hạn!");
                doGet(request, response);
                return;
            }
            
            // Kiểm tra số lượng còn lại
            if (packageDetails.getRemainingQuantity() <= 0) {
                request.setAttribute("error", "Gói dịch vụ đã hết số lượng!");
                doGet(request, response);
                return;
            }
            
            System.out.println("DEBUG JobFinalServlet: Package found - " + packageDetails.packageName + ", Duration: " + packageDetails.duration);
            
            // Bắt đầu transaction logic
            boolean success = true;
            String errorMessage = "";
            
            // 1. Cập nhật Job status = "Pending"
            boolean jobUpdated = jobDAO.updateJobStatus(jobID, "Pending");
            if (!jobUpdated) {
                success = false;
                errorMessage = "Không thể cập nhật trạng thái công việc!";
            }
            
            // 2. Cập nhật RecruiterPackages - tăng UsedQuantity
            if (success) {
                boolean packageUpdated = recruiterPackagesDAO.incrementUsedQuantity(recruiterPackageID);
                if (!packageUpdated) {
                    success = false;
                    errorMessage = "Không thể cập nhật số lượng gói dịch vụ!";
                }
            }
            
            // 3. Insert vào JobFeatureMappings
            if (success) {
                JobFeatureMappingsDAO featureMappingDAO = new JobFeatureMappingsDAO();
                JobFeatureMappings mapping = new JobFeatureMappings();
                mapping.setJobID(jobID);
                mapping.setRecruiterPackageID(recruiterPackageID);
                mapping.setFeatureType("DANG_TUYEN"); // FeatureType cho đăng tuyển
                mapping.setAppliedDate(LocalDateTime.now());
                
                // Tính expireDate: AppliedDate + Duration (ngày)
                if (packageDetails.duration > 0) {
                    LocalDateTime expireDate = mapping.getAppliedDate().plusDays(packageDetails.duration);
                    mapping.setExpireDate(expireDate);
                } else {
                    // Nếu không có duration, set null hoặc giá trị mặc định
                    mapping.setExpireDate(null);
                }
                
                boolean mappingAdded = featureMappingDAO.addJobFeatureMapping(mapping);
                if (!mappingAdded) {
                    success = false;
                    errorMessage = "Không thể lưu lịch sử sử dụng gói!";
                }
            }
            
            if (success) {
                System.out.println("DEBUG JobFinalServlet: Job posting successful!");
                // Xóa jobID khỏi session
                request.getSession().removeAttribute("newJobID");
                
                // Set success message
                request.getSession().setAttribute("successMessage", "Đăng tuyển dụng thành công! Tin tuyển dụng của bạn đang được xử lý.");
                
                // Redirect về index
                response.sendRedirect(request.getContextPath() + "/Recruiter/index.jsp");
            } else {
                System.out.println("DEBUG JobFinalServlet: Job posting failed: " + errorMessage);
                request.setAttribute("error", errorMessage);
                doGet(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("DEBUG JobFinalServlet: Exception in doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            doGet(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
