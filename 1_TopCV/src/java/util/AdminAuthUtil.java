package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Role;

/**
 * Utility class for Admin authentication and authorization
 */
public class AdminAuthUtil {
    
    /**
     * Check if current user has Admin role
     * @param request HttpServletRequest
     * @return true if user has Admin role, false otherwise
     */
    public static boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        Object adminRole = session.getAttribute("adminRole");
        if (adminRole == null) {
            return false;
        }
        
        String roleName = ((Role) adminRole).getName();
        return "Admin".equals(roleName);
    }
    
    /**
     * Check if current user is authenticated (has any admin role)
     * @param request HttpServletRequest
     * @return true if user is authenticated, false otherwise
     */
    public static boolean isAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        Object admin = session.getAttribute("admin");
        return admin != null;
    }
    
    /**
     * Check Admin access and redirect if not authorized
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @return true if access is allowed, false if redirected
     * @throws IOException
     */
    public static boolean checkAdminAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Check if user is authenticated
        if (!isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
            return false;
        }
        
        // Check if user has Admin role
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return false;
        }
        
        return true;
    }
    
    /**
     * Get current user's role name
     * @param request HttpServletRequest
     * @return role name or null if not authenticated
     */
    public static String getCurrentUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        
        Object adminRole = session.getAttribute("adminRole");
        if (adminRole == null) {
            return null;
        }
        
        return ((Role) adminRole).getName();
    }
    
    /**
     * Check if user has specific role
     * @param request HttpServletRequest
     * @param roleName role name to check
     * @return true if user has the specified role
     */
    public static boolean hasRole(HttpServletRequest request, String roleName) {
        String currentRole = getCurrentUserRole(request);
        return roleName.equals(currentRole);
    }
}
