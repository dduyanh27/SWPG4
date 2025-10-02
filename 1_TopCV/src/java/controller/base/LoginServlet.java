package controller.base;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.LoginService;
import util.LoginService.LoginResult;

/**
 * Servlet for handling user authentication
 * @author ADMIN
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String loginType = request.getParameter("loginType"); // "admin", "jobseeker", "recruiter"
        
        // Validate input
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ email và mật khẩu.");
            forwardToLoginPage(request, response, loginType);
            return;
        }
        
        // Sử dụng LoginService để xác thực
        LoginService loginService = LoginService.getInstance();
        LoginResult result = loginService.authenticateUser(email, password, loginType);
        
        if (result.isSuccess()) {
            // Tạo session và lưu thông tin user
            HttpSession session = request.getSession();
            session.setAttribute("user", result.getUser());
            session.setAttribute("userType", result.getUserType());
            
            // Lưu thông tin cụ thể theo loại user
            switch (result.getUserType()) {
                case "admin":
                    model.Admin admin = (model.Admin) result.getUser();
                    // Store admin object for JSPs that check sessionScope.admin
                    session.setAttribute("admin", admin);
                    session.setAttribute("userID", admin.getAdminId());
                    session.setAttribute("userName", admin.getFullName());
                    response.sendRedirect(request.getContextPath() + "/Admin/admin-dashboard.jsp");
                    break;
                    
                case "jobseeker":
                    model.JobSeeker jobSeeker = (model.JobSeeker) result.getUser();
                    session.setAttribute("jobseeker", jobSeeker);
                    session.setAttribute("userID", jobSeeker.getJobSeekerId());
                    session.setAttribute("userName", jobSeeker.getFullName());
                    response.sendRedirect(request.getContextPath() + "/JobSeeker/index.jsp");
                    break;
                    
                case "recruiter":
                    model.Recruiter recruiter = (model.Recruiter) result.getUser();
                    session.setAttribute("recruiter", recruiter);
                    session.setAttribute("userID", recruiter.getRecruiterID());
                    session.setAttribute("userName", recruiter.getCompanyName());
                    response.sendRedirect(request.getContextPath() + "/homerecuiter");
                    break;
                    
                default:
                    request.setAttribute("error", "Unknown user type");
                    forwardToLoginPage(request, response, loginType);
                    break;
            }
        } else {
            // Đăng nhập thất bại
            request.setAttribute("error", result.getMessage());
            forwardToLoginPage(request, response, loginType);
        }
    }
    
    private void forwardToLoginPage(HttpServletRequest request, HttpServletResponse response, String loginType)
            throws ServletException, IOException {
        
        String loginPage = switch (loginType) {
            case "admin" -> "/Admin/admin-login.jsp";
            case "jobseeker" -> "/JobSeeker/jobseeker-login.jsp";
            case "recruiter" -> "/Recruiter/recruiter-login.jsp";
            default -> "/Admin/admin-login.jsp"; // Default fallback
        };
        
        request.getRequestDispatcher(loginPage).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
