package controller.base;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import util.SessionManager;

/**
 * Servlet để xử lý việc clear session và redirect
 * Được gọi khi người dùng ấn "Quay lại" từ access-denied
 */
@WebServlet(name = "ClearSessionServlet", urlPatterns = {"/ClearSessionServlet"})
public class ClearSessionServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processClearSession(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processClearSession(request, response);
    }
    
    private void processClearSession(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Clear session hoàn toàn
        HttpSession session = request.getSession(false);
        if (session != null) {
            System.out.println("CLEARING SESSION COMPLETELY from ClearSessionServlet");
            
            // Clear tất cả attributes
            session.removeAttribute("user");
            session.removeAttribute("userType");
            session.removeAttribute("userID");
            session.removeAttribute("userName");
            session.removeAttribute("admin");
            session.removeAttribute("adminRole");
            session.removeAttribute("jobseeker");
            session.removeAttribute("recruiter");
            session.removeAttribute("staffType");
            session.removeAttribute("sessionIdentifier");
            session.removeAttribute("accessDeniedMessage");
            
            // Invalidate session
            session.invalidate();
        }
        
        // Redirect về trang chủ
        response.sendRedirect(request.getContextPath() + "/index.html");
    }
}
