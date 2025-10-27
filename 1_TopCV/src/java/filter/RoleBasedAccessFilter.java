package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import util.AdminAuthUtil;

/**
 * Filter to control access to Admin area based on user roles
 * Only users with "Admin" role can access /Admin/* paths
 */
public class RoleBasedAccessFilter implements Filter {
    
    // Public Admin paths that don't require authentication
    private static final String[] ADMIN_PUBLIC_PATHS = {
        "/Admin/admin-login.jsp",
        "/Admin/admin-register.jsp"
    };
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestPath = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String relativePath = requestPath.substring(contextPath.length());
        
        // Check if this is a public Admin path
        if (isAdminPublicPath(relativePath)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is authenticated
        if (!AdminAuthUtil.isAuthenticated(httpRequest)) {
            httpResponse.sendRedirect(contextPath + "/Admin/admin-login.jsp");
            return;
        }
        
        // Check if user has Admin role
        if (!AdminAuthUtil.isAdmin(httpRequest)) {
            // Get user's current role for better error message
            String currentRole = AdminAuthUtil.getCurrentUserRole(httpRequest);
            String roleDisplay = (currentRole != null) ? currentRole : "Unknown";
            
            // Set error message in session
            HttpSession session = httpRequest.getSession();
            session.setAttribute("accessDeniedMessage", 
                "Bạn không có quyền truy cập vào khu vực Admin. " +
                "Vai trò hiện tại: " + roleDisplay + ". " +
                "Chỉ có Admin mới có thể truy cập khu vực này.");
            
            httpResponse.sendRedirect(contextPath + "/access-denied.jsp");
            return;
        }
        
        // User has Admin role, allow access
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
    
    /**
     * Check if the given path is a public Admin path
     * @param path the path to check
     * @return true if it's a public path, false otherwise
     */
    private boolean isAdminPublicPath(String path) {
        for (String publicPath : ADMIN_PUBLIC_PATHS) {
            if (path.equals(publicPath)) {
                return true;
            }
        }
        return false;
    }
}
