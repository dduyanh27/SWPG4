package controller.jobseeker;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dal.ApplicationDAO;
import dal.NotificationDAO;
import model.JobSeeker;
import util.SessionHelper;

/**
 * Servlet for handling application cancellation
 */
@WebServlet("/cancel-application")
public class CancelApplicationServlet extends HttpServlet {
    
    private ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Check if user is logged in
            JobSeeker jobSeeker = SessionHelper.getCurrentJobSeeker(request);
            if (jobSeeker == null) {
                out.print("{\"success\":false,\"message\":\"Bạn cần đăng nhập để thực hiện hành động này\"}");
                return;
            }
            
            // Get application ID from request
            String applicationIdParam = request.getParameter("applicationId");
            if (applicationIdParam == null || applicationIdParam.trim().isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Thiếu thông tin applicationId\"}");
                return;
            }
            
            int applicationId;
            try {
                applicationId = Integer.parseInt(applicationIdParam);
            } catch (NumberFormatException e) {
                out.print("{\"success\":false,\"message\":\"ApplicationId không hợp lệ\"}");
                return;
            }
            
            int jobSeekerId = jobSeeker.getJobSeekerId();
            
            System.out.println("CancelApplicationServlet: Attempting to cancel application " + 
                             applicationId + " for JobSeeker " + jobSeekerId);
            
            // Delete the application with comprehensive security checks
            boolean deleted = applicationDAO.deleteApplication(applicationId, jobSeekerId);
            
            if (deleted) {
                // Tạo thông báo hủy đơn thành công
                NotificationDAO.sendNotification(
                    jobSeekerId,
                    "jobseeker",
                    "application",
                    "Đã hủy đơn ứng tuyển",
                    "Bạn đã hủy đơn ứng tuyển thành công. Bạn có thể ứng tuyển lại bất kỳ lúc nào.",
                    applicationId,
                    "application",
                    "/JobSeeker/applied-jobs.jsp",
                    0
                );
                
                out.print("{\"success\":true,\"message\":\"Đã hủy nộp đơn thành công\"}");
                System.out.println("CancelApplicationServlet: Successfully cancelled application " + applicationId);
            } else {
                out.print("{\"success\":false,\"message\":\"Không thể hủy nộp đơn. Chỉ có thể hủy đơn ứng tuyển đang ở trạng thái Pending.\"}");
                System.out.println("CancelApplicationServlet: Failed to cancel application " + applicationId + " - may not be Pending status");
            }
            
        } catch (Exception e) {
            System.out.println("CancelApplicationServlet: Error - " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"Có lỗi xảy ra trên server\"}");
        }
        
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect GET requests to POST
        doPost(request, response);
    }
}