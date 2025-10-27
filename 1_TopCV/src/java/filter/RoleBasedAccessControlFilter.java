package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import util.SessionManager;

/**
 * Enhanced Role-Based Access Control Filter
 * Kiểm tra quyền truy cập chi tiết dựa trên role và path
 * Forward các role không phù hợp sang trang access-denied
 */
public class RoleBasedAccessControlFilter implements Filter {
    
    // Paths that require specific role access
    private static final String[] ADMIN_ONLY_PATHS = {
        "/Admin/admin-dashboard.jsp",
        "/Admin/admin-manage-account.jsp",
        "/Admin/admin-add-account.jsp",
        "/Admin/admin-add-staff.jsp",
        "/Admin/admin-cv-management.jsp",
        "/Admin/admin-jobposting-management.jsp",
        "/Admin/admin-job-detail.jsp",
        "/Admin/ad-payment.jsp",
        "/Admin/ad-staff.jsp",
        "/Admin/payment.css",
        "/Admin/mana-acc.css",
        "/Admin/admin-cv-management.css",
        "/Admin/admin-profile.css",
        "/Admin/dashboard.css"
    };
    
    private static final String[] MARKETING_STAFF_PATHS = {
        "/Staff/marketinghome.jsp",
        "/Staff/add-campaign.jsp",
        "/Staff/campaign.jsp",
        "/Staff/content-stats.jsp",
        "/Staff/content.jsp",
        "/Staff/ContentDetail.jsp",
        "/Staff/edit-campaign.jsp",
        "/Staff/marketing-dashboard.css"
    };
    
    private static final String[] SALES_PATHS = {
        "/Staff/salehome.jsp",
        "/Staff/cus-service.jsp",
        "/Staff/order-service.jsp",
        "/Staff/sale.css"
    };
    
    private static final String[] JOBSEEKER_PATHS = {
        "/JobSeeker/index.jsp",
        "/JobSeeker/profile.jsp",
        "/JobSeeker/profile-overview.jsp",
        "/JobSeeker/job-list.jsp",
        "/JobSeeker/job-detail.jsp",
        "/JobSeeker/applied-jobs.jsp",
        "/JobSeeker/saved-jobs.jsp",
        "/JobSeeker/account-management.jsp",
        "/JobSeeker/company.jsp",
        "/JobSeeker/content-details-foruser.jsp"
    };
    
    private static final String[] RECRUITER_PATHS = {
        "/Recruiter/index.jsp",
        "/Recruiter/job-management.jsp",
        "/Recruiter/job-posting.jsp",
        "/Recruiter/job-posting-final.jsp",
        "/Recruiter/candidate-search.jsp",
        "/Recruiter/candidate-search-profile.jsp",
        "/Recruiter/candidate-profile.jsp",
        "/Recruiter/candidate-folder.jsp",
        "/Recruiter/candidate-tags.html",
        "/Recruiter/application-invitations.html",
        "/Recruiter/recruitment-process.jsp",
        "/Recruiter/company-info.jsp",
        "/Recruiter/account-management.jsp",
        "/Recruiter/job-package.jsp",
        "/Recruiter/shop-cart.jsp",
        "/Recruiter/payment_success.jsp",
        "/Recruiter/payment_failure.jsp"
    };
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("RoleBasedAccessControlFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestPath = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String relativePath = requestPath.substring(contextPath.length());
        
        // Skip public paths and static resources
        if (isPublicPath(relativePath) || isStaticResource(relativePath)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check session conflicts and invalid sessions first
        if (SessionManager.checkAndClearSessionIfNeeded(httpRequest)) {
            System.out.println("SESSION CLEARED in RoleBasedAccessControlFilter - Redirecting to login");
            httpResponse.sendRedirect(contextPath + "/JobSeeker/jobseeker-login.jsp");
            return;
        }
        
        // Get current user info
        String userType = SessionManager.getCurrentUserType(httpRequest);
        String currentRole = SessionManager.getCurrentRoleName(httpRequest);
        
        // Check access based on path and role
        if (!hasAccessToPath(httpRequest, relativePath, userType, currentRole)) {
            String errorMessage = generateAccessDeniedMessage(relativePath, userType, currentRole);
            redirectToAccessDenied(httpRequest, httpResponse, errorMessage);
            return;
        }
        
        // User has access, continue
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        System.out.println("RoleBasedAccessControlFilter destroyed");
    }
    
    /**
     * Kiểm tra xem user có quyền truy cập path không
     */
    private boolean hasAccessToPath(HttpServletRequest request, String path, String userType, String currentRole) {
        // Admin-only paths
        if (isAdminOnlyPath(path)) {
            return "admin".equals(userType) && "Admin".equals(currentRole);
        }
        
        // Marketing Staff paths
        if (isMarketingStaffPath(path)) {
            return "admin".equals(userType) && "Marketing Staff".equals(currentRole);
        }
        
        // Sales paths
        if (isSalesPath(path)) {
            return "admin".equals(userType) && "Sales".equals(currentRole);
        }
        
        // JobSeeker paths
        if (isJobSeekerPath(path)) {
            return "jobseeker".equals(userType);
        }
        
        // Recruiter paths
        if (isRecruiterPath(path)) {
            return "recruiter".equals(userType);
        }
        
        // General Admin area (any admin role)
        if (path.startsWith("/Admin/")) {
            return "admin".equals(userType);
        }
        
        // General Staff area (Marketing Staff or Sales)
        if (path.startsWith("/Staff/")) {
            return "admin".equals(userType) && 
                   ("Marketing Staff".equals(currentRole) || "Sales".equals(currentRole));
        }
        
        // General JobSeeker area
        if (path.startsWith("/JobSeeker/")) {
            return "jobseeker".equals(userType);
        }
        
        // General Recruiter area
        if (path.startsWith("/Recruiter/")) {
            return "recruiter".equals(userType);
        }
        
        // Default allow for other paths
        return true;
    }
    
    /**
     * Kiểm tra xem path có phải là admin-only không
     */
    private boolean isAdminOnlyPath(String path) {
        for (String adminPath : ADMIN_ONLY_PATHS) {
            if (path.equals(adminPath) || path.startsWith(adminPath)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Kiểm tra xem path có phải là marketing staff không
     */
    private boolean isMarketingStaffPath(String path) {
        for (String marketingPath : MARKETING_STAFF_PATHS) {
            if (path.equals(marketingPath) || path.startsWith(marketingPath)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Kiểm tra xem path có phải là sales không
     */
    private boolean isSalesPath(String path) {
        for (String salesPath : SALES_PATHS) {
            if (path.equals(salesPath) || path.startsWith(salesPath)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Kiểm tra xem path có phải là jobseeker không
     */
    private boolean isJobSeekerPath(String path) {
        for (String jobSeekerPath : JOBSEEKER_PATHS) {
            if (path.equals(jobSeekerPath) || path.startsWith(jobSeekerPath)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Kiểm tra xem path có phải là recruiter không
     */
    private boolean isRecruiterPath(String path) {
        for (String recruiterPath : RECRUITER_PATHS) {
            if (path.equals(recruiterPath) || path.startsWith(recruiterPath)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Kiểm tra xem path có phải là public không
     */
    private boolean isPublicPath(String path) {
        String[] publicPaths = {
            "/index.jsp",
            "/Admin/admin-login.jsp",
            "/JobSeeker/jobseeker-login.jsp",
            "/Recruiter/recruiter-login.jsp",
            "/Recruiter/registration.jsp",
            "/LoginServlet",
            "/LogoutServlet",
            "/access-denied.jsp",
            "/forgotpassword.html",
            "/resetpassword.html",
            "/signup.html",
            "/login.html",
            "/recruiter_login.html",
            "/recruiter_signup.html",
            "/contact.html",
            "/blog.html",
            "/single-blog.html",
            "/about.html",
            "/elements.html"
        };
        
        for (String publicPath : publicPaths) {
            if (path.equals(publicPath) || path.startsWith(publicPath)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Kiểm tra xem path có phải là static resource không
     */
    private boolean isStaticResource(String path) {
        String lower = path.toLowerCase();
        return lower.endsWith(".css") || lower.endsWith(".js") || lower.endsWith(".png") ||
               lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".gif") ||
               lower.endsWith(".svg") || lower.endsWith(".ico") || lower.endsWith(".woff") ||
               lower.endsWith(".woff2") || lower.endsWith(".ttf") || lower.endsWith(".map") ||
               lower.startsWith("/assets/") || lower.startsWith("/css/") || 
               lower.startsWith("/js/") || lower.startsWith("/images/");
    }
    
    /**
     * Tạo thông báo lỗi chi tiết
     */
    private String generateAccessDeniedMessage(String path, String userType, String currentRole) {
        String roleDisplay = (currentRole != null) ? currentRole : "Unknown";
        
        if (isAdminOnlyPath(path)) {
            return "Bạn không có quyền truy cập vào trang này. " +
                   "Vai trò hiện tại: " + roleDisplay + ". " +
                   "Chỉ có Admin mới có thể truy cập trang này.";
        }
        
        if (isMarketingStaffPath(path)) {
            return "Bạn không có quyền truy cập vào trang Marketing. " +
                   "Vai trò hiện tại: " + roleDisplay + ". " +
                   "Chỉ có Marketing Staff mới có thể truy cập trang này.";
        }
        
        if (isSalesPath(path)) {
            return "Bạn không có quyền truy cập vào trang Sales. " +
                   "Vai trò hiện tại: " + roleDisplay + ". " +
                   "Chỉ có Sales mới có thể truy cập trang này.";
        }
        
        if (isJobSeekerPath(path)) {
            return "Bạn không có quyền truy cập vào khu vực JobSeeker. " +
                   "Vai trò hiện tại: " + roleDisplay + ". " +
                   "Chỉ có JobSeeker mới có thể truy cập khu vực này.";
        }
        
        if (isRecruiterPath(path)) {
            return "Bạn không có quyền truy cập vào khu vực Recruiter. " +
                   "Vai trò hiện tại: " + roleDisplay + ". " +
                   "Chỉ có Recruiter mới có thể truy cập khu vực này.";
        }
        
        return "Bạn không có quyền truy cập vào trang này. " +
               "Vai trò hiện tại: " + roleDisplay + ".";
    }
    
    /**
     * Redirect đến trang access-denied với thông báo lỗi
     */
    private void redirectToAccessDenied(HttpServletRequest request, HttpServletResponse response, String message) 
            throws IOException {
        HttpSession session = request.getSession();
        session.setAttribute("accessDeniedMessage", message);
        response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
    }
}
