package controller.base;

import dal.AdminDAO;
import dal.JobSeekerDAO;
import dal.RecruiterDAO;
import dal.TokenDAO;
import model.Admin;
import model.JobSeeker;
import model.Recruiter;
import model.Token;
import util.MD5Util;
import util.ResetService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Universal controller for password reset (all user types)
 *
 * @author ADMIN
 */
@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/resetPassword"})
public class ResetPasswordServlet extends HttpServlet {

    TokenDAO tokenDAO = new TokenDAO();
    AdminDAO adminDAO = new AdminDAO();
    JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();
    RecruiterDAO recruiterDAO = new RecruiterDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        HttpSession session = request.getSession();

        if (token != null) {
            Token tokenForgetPassword = tokenDAO.getTokenPassword(token);
            ResetService service = new ResetService();

            if (tokenForgetPassword == null) {
                request.setAttribute("mess", "Token không hợp lệ");
                request.getRequestDispatcher("/requestPassword").forward(request, response);
                return;
            }

            if (tokenForgetPassword.isUsed()) {
                request.setAttribute("mess", "Token đã được sử dụng");
                request.getRequestDispatcher("/requestPassword").forward(request, response);
                return;
            }

            if (service.isExpireTime(tokenForgetPassword.getExpiryTime())) {
                request.setAttribute("mess", "Token đã hết hạn");
                request.getRequestDispatcher("/requestPassword").forward(request, response);
                return;
            }

            // Get user email based on type
            String email = "";
            String userType = tokenForgetPassword.getUserType();
            System.out.println(">>> [DEBUG] Token UserType: " + tokenForgetPassword.getUserType());
            switch (userType.toLowerCase()) {
                case "admin":
                    Admin admin = adminDAO.getAdminById(tokenForgetPassword.getUserId());
                    if (admin != null) {
                        email = admin.getEmail();
                    }
                    break;
                case "jobseeker":
                    System.out.println(">>> [DEBUG] Token UserId: " + tokenForgetPassword.getUserId());
                    
                    JobSeeker jobSeeker = jobSeekerDAO.getJobSeekerById(tokenForgetPassword.getUserId());
                    System.out.println(">>> [DEBUG] Kết quả jobSeeker: " + (jobSeeker != null ? jobSeeker.getEmail() : "null"));
                    if (jobSeeker != null) {
                        email = jobSeeker.getEmail();
                    }
                    break;
                case "recruiter":
                    Recruiter recruiter = recruiterDAO.getRecruiterById(tokenForgetPassword.getUserId());
                    if (recruiter != null) {
                        email = recruiter.getEmail();
                    }
                    break;
            }

            request.setAttribute("email", email);
            request.setAttribute("userType", userType);
            session.setAttribute("token", tokenForgetPassword.getToken());

            // Forward to appropriate reset page
            String forwardPath = "/" + getCorrectFolderName(userType) + "/reset-password.jsp";
            request.getRequestDispatcher(forwardPath).forward(request, response);
        } else {
            request.getRequestDispatcher("/requestPassword").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String userType = request.getParameter("userType");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("mess", "Xác nhận mật khẩu không khớp");
            request.setAttribute("email", email);
            request.setAttribute("userType", userType);
            String forwardPath = "/" + getCorrectFolderName(userType) + "/reset-password.jsp";
            request.getRequestDispatcher(forwardPath).forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        String tokenStr = (String) session.getAttribute("token");
        Token tokenForgetPassword = tokenDAO.getTokenPassword(tokenStr);
        ResetService service = new ResetService();

        if (tokenForgetPassword == null) {
            request.setAttribute("mess", "Token không hợp lệ");
            request.getRequestDispatcher("/requestPassword").forward(request, response);
            return;
        }

        if (tokenForgetPassword.isUsed()) {
            request.setAttribute("mess", "Token đã được sử dụng");
            request.getRequestDispatcher("/requestPassword").forward(request, response);
            return;
        }

        if (service.isExpireTime(tokenForgetPassword.getExpiryTime())) {
            request.setAttribute("mess", "Token đã hết hạn");
            request.getRequestDispatcher("/requestPassword").forward(request, response);
            return;
        }

        // Verify userType matches
        if (!userType.equals(tokenForgetPassword.getUserType())) {
            request.setAttribute("mess", "Token không đúng loại người dùng");
            request.getRequestDispatcher("/requestPassword").forward(request, response);
            return;
        }

        // Check if new password is different from current password
        String currentPassword = "";
        switch (userType.toLowerCase()) {
            case "admin":
                Admin admin = adminDAO.getAdminById(tokenForgetPassword.getUserId());
                if (admin != null) {
                    currentPassword = admin.getPassword();
                }
                break;
            case "jobseeker":
                JobSeeker jobSeeker = jobSeekerDAO.getJobSeekerById(tokenForgetPassword.getUserId());
                if (jobSeeker != null) {
                    currentPassword = jobSeeker.getPassword();
                }
                break;
            case "recruiter":
                Recruiter recruiter = recruiterDAO.getRecruiterById(tokenForgetPassword.getUserId());
                if (recruiter != null) {
                    currentPassword = recruiter.getPassword();
                }
                break;
        }

        String hashedNewPassword = MD5Util.getMD5Hash(password);
        if (hashedNewPassword.equalsIgnoreCase(currentPassword)) {
            request.setAttribute("mess", "Mật khẩu mới không được trùng với mật khẩu hiện tại");
            request.setAttribute("email", email);
            request.setAttribute("userType", userType);
            String forwardPath = "/" + getCorrectFolderName(userType) + "/reset-password.jsp";
            request.getRequestDispatcher(forwardPath).forward(request, response);
            return;
        }

        // Update based on user type (DAOs will hash to MD5, lowercase)
        tokenForgetPassword.setUsed(true);

        switch (userType.toLowerCase()) {
            case "admin":
                adminDAO.updatePassword(tokenForgetPassword.getUserId(), password);
                break;
            case "jobseeker":
                jobSeekerDAO.updatePassword(tokenForgetPassword.getUserId(), password);
                break;
            case "recruiter":
                recruiterDAO.updatePassword(tokenForgetPassword.getUserId(), password);
                break;
        }

        tokenDAO.updateStatus(tokenForgetPassword);

        request.setAttribute("mess", "Đặt lại mật khẩu thành công");
        request.setAttribute("email", email);
        request.setAttribute("userType", userType);

        // Forward back to reset-password page to show success modal
        String forwardPath = "/" + getCorrectFolderName(userType) + "/reset-password.jsp";
        request.getRequestDispatcher(forwardPath).forward(request, response);
    }

    private String getCorrectFolderName(String userType) {
        switch (userType.toLowerCase()) {
            case "admin":
                return "Admin";
            case "jobseeker":
                return "JobSeeker";
            case "recruiter":
                return "Recruiter";
            default:
                return "Admin";
        }
    }

    @Override
    public String getServletInfo() {
        return "Universal Reset Password Servlet";
    }
}
