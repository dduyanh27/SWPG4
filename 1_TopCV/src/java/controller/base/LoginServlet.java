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
import util.SessionManager;

/**
 * Servlet for handling user authentication
 * @author ADMIN
 */
//@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
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
            // Sử dụng SessionManager để tạo session isolated
            try {
                switch (result.getUserType()) {
                    case "admin":
                        model.AdminWithRole adminWithRole = (model.AdminWithRole) result.getUser();
                        model.Admin admin = adminWithRole.getAdmin();
                        model.Role role = adminWithRole.getRole();
                        
                        // Tạo session isolated với role
                        SessionManager.createIsolatedSession(request, response, "admin", admin, role);
                        
                        // Redirect dựa trên role
                        String roleName = (role != null) ? role.getName() : null;
                        String redirectPath = getRedirectPathByRole(roleName);
                        System.out.println("DEBUG: Admin role = " + roleName + ", redirect to = " + redirectPath);
                        response.sendRedirect(request.getContextPath() + redirectPath);
                        break;
                        
                    case "jobseeker":
                        model.JobSeeker jobSeeker = (model.JobSeeker) result.getUser();
                        SessionManager.createIsolatedSession(request, response, "jobseeker", jobSeeker);
                        response.sendRedirect(request.getContextPath() + "/JobSeeker/index.jsp");
                        break;
                        
                    case "recruiter":
                        model.Recruiter recruiter = (model.Recruiter) result.getUser();
                        SessionManager.createIsolatedSession(request, response, "recruiter", recruiter);
                        response.sendRedirect(request.getContextPath() + "/Recruiter/index.jsp");
                        break;
                        
                    default:
                        request.setAttribute("error", "Unknown user type");
                        forwardToLoginPage(request, response, loginType);
                        break;
                }
            } catch (IOException e) {
                System.err.println("Error creating isolated session: " + e.getMessage());
                request.setAttribute("error", "Lỗi hệ thống khi tạo session. Vui lòng thử lại.");
                forwardToLoginPage(request, response, loginType);
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
    
    private String getRedirectPathByRole(String roleName) {
        if (roleName == null) {
            System.out.println("DEBUG: Role name is null, using default dashboard");
            return "/Admin/admin-dashboard.jsp"; // Default fallback
        }
        
        System.out.println("DEBUG: Checking role name: '" + roleName + "'");
        
        String lowerRoleName = roleName.toLowerCase().trim();
        System.out.println("DEBUG: Lowercase role name: '" + lowerRoleName + "'");
        
        return switch (lowerRoleName) {
            case "admin" -> {
                System.out.println("DEBUG: Matched Admin role");
                yield "/Admin/admin-dashboard.jsp";
            }
            case "marketing staff", "marketing" -> {
                System.out.println("DEBUG: Matched Marketing Staff role");
                yield "/Staff/marketinghome.jsp";
            }
            case "sale", "sales" -> {
                System.out.println("DEBUG: Matched Sale role");
                yield "/Staff/salehome.jsp";
            }
            default -> {
                System.out.println("DEBUG: No match found, using default dashboard");
                yield "/Admin/admin-dashboard.jsp"; // Default fallback
            }
        };
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
