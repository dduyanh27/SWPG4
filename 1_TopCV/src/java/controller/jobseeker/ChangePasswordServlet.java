package controller.jobseeker;

import dal.JobSeekerDAO;
import dal.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import model.JobSeeker;
import util.SessionHelper;
import util.MD5Util;
import com.google.gson.JsonObject;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/change-password"})
public class ChangePasswordServlet extends HttpServlet {
    private JobSeekerDAO dao;
    
    public ChangePasswordServlet() {
        try {
            this.dao = new JobSeekerDAO();
        } catch (Exception e) {
            System.err.println("Error initializing DAO in ChangePasswordServlet: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            // Kiểm tra xem DAOs đã được khởi tạo thành công chưa
            if (dao == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Lỗi hệ thống. Vui lòng thử lại sau.");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Lấy thông tin người dùng hiện tại từ session
            JobSeeker currentJobSeeker = SessionHelper.getCurrentJobSeeker(request);
            Integer userId = SessionHelper.getCurrentUserId(request);
            
            // Kiểm tra xem người dùng đã login chưa và có phải JobSeeker không
            if (currentJobSeeker == null || userId == null || !SessionHelper.isJobSeeker(request)) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng đăng nhập để thay đổi mật khẩu.");
                jsonResponse.addProperty("redirect", request.getContextPath() + "/JobSeeker/jobseeker-login.jsp");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Lấy tham số từ request
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Validate đầu vào
            if (currentPassword == null || currentPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng điền đầy đủ thông tin.");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Kiểm tra mật khẩu mới và xác nhận mật khẩu có khớp không
            if (!newPassword.equals(confirmPassword)) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Kiểm tra độ dài mật khẩu mới
            if (newPassword.length() < 6) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Mật khẩu mới phải có ít nhất 6 ký tự.");
                out.print(jsonResponse.toString());
                return;
            }
            
            if (newPassword.length() > 50) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Mật khẩu mới không được vượt quá 50 ký tự.");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Kiểm tra mật khẩu mới có khác mật khẩu cũ không
            if (currentPassword.equals(newPassword)) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Mật khẩu mới phải khác mật khẩu hiện tại.");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Lấy thông tin JobSeeker từ database
            JobSeeker jobSeeker = dao.getJobSeekerById(userId);
            
            if (jobSeeker == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy thông tin người dùng.");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Kiểm tra nếu là tài khoản Google
            if ("GOOGLE_LOGIN".equals(jobSeeker.getPassword())) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Tài khoản đăng nhập bằng Google không thể thay đổi mật khẩu.");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Kiểm tra mật khẩu hiện tại có đúng không
            String hashedCurrentPassword = MD5Util.getMD5Hash(currentPassword);
            if (!hashedCurrentPassword.equalsIgnoreCase(jobSeeker.getPassword())) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Mật khẩu hiện tại không đúng.");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Cập nhật mật khẩu mới
            boolean success = dao.updatePassword(userId, newPassword);
            
            if (success) {
                // Tạo thông báo đổi mật khẩu thành công
                NotificationDAO.sendNotification(
                    userId,
                    "jobseeker",
                    "system",
                    "Đổi mật khẩu thành công",
                    "Mật khẩu của bạn đã được thay đổi thành công. Nếu bạn không thực hiện hành động này, vui lòng liên hệ với chúng tôi ngay lập tức.",
                    userId,
                    "user",
                    "/JobSeeker/profile.jsp",
                    1
                );
                
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Thay đổi mật khẩu thành công!");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Có lỗi xảy ra khi thay đổi mật khẩu. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            System.err.println("Error in ChangePasswordServlet: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi hệ thống. Vui lòng thử lại sau.");
        }
        
        out.print(jsonResponse.toString());
        out.flush();
    }

    @Override
    public String getServletInfo() {
        return "Servlet for changing job seeker password";
    }
}
