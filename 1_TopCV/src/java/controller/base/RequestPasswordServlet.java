package controller.base;

import dal.AdminDAO;
import dal.JobSeekerDAO;
import dal.RecruiterDAO;
import dal.TokenDAO;
import model.Admin;
import model.JobSeeker;
import model.Recruiter;
import model.Token;
import util.ResetService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Universal controller for password reset request (all user types)
 * @author ADMIN
 */
@WebServlet(name = "RequestPasswordServlet", urlPatterns = {"/requestPassword"})
public class RequestPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to appropriate request page based on user type
        String userType = request.getParameter("type");
        if (userType == null) {
            // Default to admin if no type specified
            userType = "admin";
        }
        
        String forwardPath = "/" + getCorrectFolderName(userType) + "/request-password.jsp";
        request.getRequestDispatcher(forwardPath).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String userType = request.getParameter("userType");
        
        if (email == null || userType == null) {
            request.setAttribute("mess", "Thiếu thông tin cần thiết");
            String forwardPath = "/" + getCorrectFolderName(userType) + "/request-password.jsp";
            request.getRequestDispatcher(forwardPath).forward(request, response);
            return;
        }

        String userName = "";
        int userId = 0;
        boolean userExists = false;

        // Check user existence based on type
        switch (userType.toLowerCase()) {
            case "admin":
                AdminDAO adminDAO = new AdminDAO();
                Admin admin = adminDAO.getAdminByEmail(email);
                if (admin != null) {
                    userExists = true;
                    userId = admin.getAdminId();
                    userName = admin.getFullName();
                }
                break;
                
            case "jobseeker":
                JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();
                JobSeeker jobSeeker = jobSeekerDAO.getJobSeekerByEmail(email);
                if (jobSeeker != null) {
                    // Kiểm tra xem có phải tài khoản Google không
                    if (jobSeekerDAO.isGoogleAccount(email)) {
                        request.setAttribute("mess", "Tài khoản này được đăng nhập bằng Google. Vui lòng đăng nhập bằng Google thay vì reset mật khẩu.");
                        String forwardPath = "/" + getCorrectFolderName(userType) + "/request-password.jsp";
                        request.getRequestDispatcher(forwardPath).forward(request, response);
                        return;
                    }
                    userExists = true;
                    userId = jobSeeker.getJobSeekerId();
                    userName = jobSeeker.getFullName();
                }
                break;
                
            case "recruiter":
                RecruiterDAO recruiterDAO = new RecruiterDAO();
                Recruiter recruiter = recruiterDAO.getRecruiterByEmail(email);
                if (recruiter != null) {
                    userExists = true;
                    userId = recruiter.getRecruiterID();
                    userName = recruiter.getCompanyName();
                }
                break;
        }

        if (!userExists) {
            request.setAttribute("mess", "Email không tồn tại trong hệ thống");
            String forwardPath = "/" + getCorrectFolderName(userType) + "/request-password.jsp";
            request.getRequestDispatcher(forwardPath).forward(request, response);
            return;
        }

        ResetService service = new ResetService();
        String token = service.generateToken();
        
        // Create reset link
        String linkReset = "http://localhost:9999/1_TopCV/resetPassword?token=" + token;
        
        Token newToken = new Token(
                userId,
                userType,
                false,
                token,
                service.expireDateTime()
        );
        
        // Insert token into database
        TokenDAO tokenDAO = new TokenDAO();
        
        // Delete existing tokens for this user first
        tokenDAO.deleteExistingTokens(userId, userType);
        
        boolean isInsert = tokenDAO.insertTokenForget(newToken);
        if (!isInsert) {
            request.setAttribute("mess", "Có lỗi trong server");
            String forwardPath = "/" + getCorrectFolderName(userType) + "/request-password.jsp";
            request.getRequestDispatcher(forwardPath).forward(request, response);
            return;
        }

        // Send email
        boolean isSend = service.sendEmail(email, linkReset, userName, userType);
        if (!isSend) {
            request.setAttribute("mess", "Không thể gửi yêu cầu");
            String forwardPath = "/" + getCorrectFolderName(userType) + "/request-password.jsp";
            request.getRequestDispatcher(forwardPath).forward(request, response);
            return;
        }

               // Forward to check-email page
               String forwardPath = "/" + getCorrectFolderName(userType) + "/check-email.jsp";
               request.setAttribute("email", email);
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
        return "Universal Request Password Servlet";
    }
}
