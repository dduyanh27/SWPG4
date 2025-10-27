package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Admin;
import model.JobSeeker;
import model.Recruiter;
import model.Role;

/**
 * Enhanced Session Manager để quản lý session isolation và role conflict
 * Giải quyết vấn đề khi đăng nhập nhiều role trong cùng một trình duyệt
 */
public class SessionManager {
    
    // Private constructor to prevent instantiation
    private SessionManager() {
        throw new UnsupportedOperationException("Utility class");
    }
    
    // Session attribute keys
    private static final String USER_TYPE_KEY = "userType";
    private static final String USER_KEY = "user";
    private static final String USER_ID_KEY = "userID";
    private static final String USER_NAME_KEY = "userName";
    private static final String ADMIN_KEY = "admin";
    private static final String ADMIN_ROLE_KEY = "adminRole";
    private static final String JOBSEEKER_KEY = "jobseeker";
    private static final String RECRUITER_KEY = "recruiter";
    private static final String SESSION_IDENTIFIER_KEY = "sessionIdentifier";
    
    // Role constants
    private static final String ADMIN_ROLE = "Admin";
    private static final String MARKETING_STAFF_ROLE = "Marketing Staff";
    private static final String SALES_ROLE = "Sales";
    private static final String JOBSEEKER_LOGIN_PATH = "/JobSeeker/jobseeker-login.jsp";
    private static final String ACCESS_DENIED_MESSAGE_KEY = "accessDeniedMessage";
    private static final String CURRENT_ROLE_PREFIX = "Vai trò hiện tại: ";
    
    /**
     * Tạo session mới với role cụ thể và xóa các session cũ của role khác
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param userType Loại user ("admin", "jobseeker", "recruiter")
     * @param user Object user
     * @param additionalData Dữ liệu bổ sung (role cho admin, etc.)
     */
    public static void createIsolatedSession(HttpServletRequest request, HttpServletResponse response, 
                                           String userType, Object user, Object... additionalData) throws IOException {
        
        // Invalidate existing session để tránh conflict
        HttpSession existingSession = request.getSession(false);
        if (existingSession != null) {
            String existingUserType = (String) existingSession.getAttribute(USER_TYPE_KEY);
            if (existingUserType != null && !existingUserType.equals(userType)) {
                // Log session conflict
                System.out.println("SESSION CONFLICT DETECTED: Switching from " + existingUserType + " to " + userType);
                existingSession.invalidate();
            }
        }
        
        // Tạo session mới
        HttpSession session = request.getSession(true);
        
        // Set session identifier để track
        session.setAttribute(SESSION_IDENTIFIER_KEY, userType + "_" + System.currentTimeMillis());
        
        // Set basic user info
        session.setAttribute(USER_KEY, user);
        session.setAttribute(USER_TYPE_KEY, userType);
        
        // Set specific user data based on type
        switch (userType) {
            case "admin":
                Admin admin = (Admin) user;
                session.setAttribute(ADMIN_KEY, admin);
                session.setAttribute(USER_ID_KEY, admin.getAdminId());
                session.setAttribute(USER_NAME_KEY, admin.getFullName());
                
                // Set role if provided
                if (additionalData.length > 0 && additionalData[0] instanceof Role) {
                    Role role = (Role) additionalData[0];
                    session.setAttribute(ADMIN_ROLE_KEY, role);
                }
                break;
                
            case "jobseeker":
                JobSeeker jobSeeker = (JobSeeker) user;
                session.setAttribute(JOBSEEKER_KEY, jobSeeker);
                session.setAttribute(USER_ID_KEY, jobSeeker.getJobSeekerId());
                session.setAttribute(USER_NAME_KEY, jobSeeker.getFullName());
                break;
                
            case "recruiter":
                Recruiter recruiter = (Recruiter) user;
                session.setAttribute(RECRUITER_KEY, recruiter);
                session.setAttribute(USER_ID_KEY, recruiter.getRecruiterID());
                session.setAttribute(USER_NAME_KEY, recruiter.getCompanyName());
                break;
        }
        
        // Set session timeout (30 minutes)
        session.setMaxInactiveInterval(30 * 60);
    }
    
    /**
     * Kiểm tra xem user có đúng role để truy cập path không
     * @param request HttpServletRequest
     * @param path Path cần kiểm tra
     * @return true nếu có quyền truy cập
     */
    public static boolean hasAccessToPath(HttpServletRequest request, String path) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        String userType = (String) session.getAttribute(USER_TYPE_KEY);
        if (userType == null) {
            return false;
        }
        
        // Admin area access
        if (path.startsWith("/Admin/")) {
            if (!"admin".equals(userType)) {
                return false;
            }
            
            // Kiểm tra role cụ thể cho admin
            Role adminRole = (Role) session.getAttribute(ADMIN_ROLE_KEY);
            if (adminRole == null) {
                return false;
            }
            
            String roleName = adminRole.getName();
            
            // Admin role có thể truy cập tất cả
            if ("Admin".equals(roleName)) {
                return true;
            }
            
            // Marketing Staff chỉ truy cập marketing pages
            if ("Marketing Staff".equals(roleName)) {
                return path.contains("marketing") || path.contains("campaign") || 
                       path.contains("content") || path.contains("stats");
            }
            
            // Sales chỉ truy cập sales pages
            if ("Sales".equals(roleName)) {
                return path.contains("sale") || path.contains("order") || 
                       path.contains("cus-service");
            }
            
            return false;
        }
        
        // JobSeeker area access
        if (path.startsWith("/JobSeeker/")) {
            return "jobseeker".equals(userType);
        }
        
        // Recruiter area access
        if (path.startsWith("/Recruiter/")) {
            return "recruiter".equals(userType);
        }
        
        // Staff area access (for Marketing Staff and Sales)
        if (path.startsWith("/Staff/")) {
            if (!"admin".equals(userType)) {
                return false;
            }
            
            Role adminRole = (Role) session.getAttribute(ADMIN_ROLE_KEY);
            if (adminRole == null) {
                return false;
            }
            
            String roleName = adminRole.getName();
            return "Marketing Staff".equals(roleName) || "Sales".equals(roleName);
        }
        
        return true; // Default allow for other paths
    }
    
    /**
     * Kiểm tra role conflict và redirect nếu cần
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param targetPath Path đang cố gắng truy cập
     * @return true nếu có thể tiếp tục, false nếu đã redirect
     */
    public static boolean checkRoleConflict(HttpServletRequest request, HttpServletResponse response, String targetPath) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return true; // No session, no conflict
        }
        
        String userType = (String) session.getAttribute(USER_TYPE_KEY);
        if (userType == null) {
            return true; // No user type, no conflict
        }
        
        // Kiểm tra xem user có quyền truy cập path này không
        if (!hasAccessToPath(request, targetPath)) {
            // Set error message
            String currentRole = getCurrentRoleName(request);
            String roleDisplay = (currentRole != null) ? currentRole : "Unknown";
            
            session.setAttribute("accessDeniedMessage", 
                "Bạn không có quyền truy cập vào khu vực này. " +
                "Vai trò hiện tại: " + roleDisplay + ". " +
                "Vui lòng đăng nhập với tài khoản phù hợp.");
            
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return false;
        }
        
        return true;
    }
    
    /**
     * Lấy tên role hiện tại
     * @param request HttpServletRequest
     * @return Tên role hoặc null
     */
    public static String getCurrentRoleName(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        
        String userType = (String) session.getAttribute(USER_TYPE_KEY);
        if ("admin".equals(userType)) {
            Role adminRole = (Role) session.getAttribute(ADMIN_ROLE_KEY);
            return adminRole != null ? adminRole.getName() : "Admin";
        }
        
        return userType; // jobseeker, recruiter
    }
    
    /**
     * Lấy user type hiện tại
     * @param request HttpServletRequest
     * @return User type hoặc null
     */
    public static String getCurrentUserType(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        
        return (String) session.getAttribute(USER_TYPE_KEY);
    }
    
    /**
     * Kiểm tra xem có session conflict không
     * @param request HttpServletRequest
     * @return true nếu có conflict
     */
    public static boolean hasSessionConflict(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        // Kiểm tra xem có nhiều user type trong session không
        String userType = (String) session.getAttribute(USER_TYPE_KEY);
        if (userType == null) {
            return false;
        }
        
        // Kiểm tra conflict dựa trên user type và các attribute khác
        switch (userType) {
            case "admin":
                // Admin không nên có jobseeker hoặc recruiter data
                return session.getAttribute(JOBSEEKER_KEY) != null || 
                       session.getAttribute(RECRUITER_KEY) != null;
                       
            case "jobseeker":
                // JobSeeker không nên có admin hoặc recruiter data
                return session.getAttribute(ADMIN_KEY) != null || 
                       session.getAttribute(RECRUITER_KEY) != null;
                       
            case "recruiter":
                // Recruiter không nên có admin hoặc jobseeker data
                return session.getAttribute(ADMIN_KEY) != null || 
                       session.getAttribute(JOBSEEKER_KEY) != null;
        }
        
        return false;
    }
    
    /**
     * Clear session conflict bằng cách invalidate session
     * @param request HttpServletRequest
     */
    public static void clearSessionConflict(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            System.out.println("CLEARING SESSION CONFLICT");
            session.invalidate();
        }
    }
    
    /**
     * Clear session hoàn toàn - xóa tất cả dữ liệu session
     * @param request HttpServletRequest
     */
    public static void clearSessionCompletely(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            System.out.println("CLEARING SESSION COMPLETELY");
            
            // Clear tất cả attributes
            session.removeAttribute(USER_KEY);
            session.removeAttribute(USER_TYPE_KEY);
            session.removeAttribute(USER_ID_KEY);
            session.removeAttribute(USER_NAME_KEY);
            session.removeAttribute(ADMIN_KEY);
            session.removeAttribute(ADMIN_ROLE_KEY);
            session.removeAttribute(JOBSEEKER_KEY);
            session.removeAttribute(RECRUITER_KEY);
            session.removeAttribute(SESSION_IDENTIFIER_KEY);
            session.removeAttribute(ACCESS_DENIED_MESSAGE_KEY);
            
            // Invalidate session
            session.invalidate();
        }
    }
    
    /**
     * Kiểm tra và clear session nếu có conflict
     * @param request HttpServletRequest
     * @return true nếu session đã được clear
     */
    public static boolean checkAndClearSessionIfNeeded(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        // Kiểm tra xem có session conflict không
        if (hasSessionConflict(request)) {
            System.out.println("SESSION CONFLICT DETECTED - Clearing session completely");
            clearSessionCompletely(request);
            return true;
        }
        
        // Kiểm tra xem có dữ liệu không hợp lệ không
        String userType = (String) session.getAttribute(USER_TYPE_KEY);
        if (userType == null) {
            // Session không có userType - có thể là session cũ
            System.out.println("INVALID SESSION - No userType found, clearing session");
            clearSessionCompletely(request);
            return true;
        }
        
        // Kiểm tra tính nhất quán của session
        if (!isSessionConsistent(session, userType)) {
            System.out.println("INCONSISTENT SESSION - Clearing session completely");
            clearSessionCompletely(request);
            return true;
        }
        
        return false;
    }
    
    /**
     * Kiểm tra tính nhất quán của session
     * @param session HttpSession
     * @param userType String
     * @return true nếu session nhất quán
     */
    private static boolean isSessionConsistent(HttpSession session, String userType) {
        switch (userType) {
            case "admin":
                // Admin session phải có admin object và adminRole
                return session.getAttribute(ADMIN_KEY) != null && 
                       session.getAttribute(ADMIN_ROLE_KEY) != null &&
                       session.getAttribute(JOBSEEKER_KEY) == null &&
                       session.getAttribute(RECRUITER_KEY) == null;
                       
            case "jobseeker":
                // JobSeeker session phải có jobseeker object
                return session.getAttribute(JOBSEEKER_KEY) != null &&
                       session.getAttribute(ADMIN_KEY) == null &&
                       session.getAttribute(RECRUITER_KEY) == null;
                       
            case "recruiter":
                // Recruiter session phải có recruiter object
                return session.getAttribute(RECRUITER_KEY) != null &&
                       session.getAttribute(ADMIN_KEY) == null &&
                       session.getAttribute(JOBSEEKER_KEY) == null;
                       
            default:
                return false;
        }
    }
    
    /**
     * Lấy redirect path dựa trên role
     * @param request HttpServletRequest
     * @return Redirect path
     */
    public static String getRedirectPathByRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return "/JobSeeker/jobseeker-login.jsp";
        }
        
        String userType = (String) session.getAttribute(USER_TYPE_KEY);
        if (userType == null) {
            return "/JobSeeker/jobseeker-login.jsp";
        }
        
        switch (userType) {
            case "admin":
                Role adminRole = (Role) session.getAttribute(ADMIN_ROLE_KEY);
                if (adminRole != null) {
                    String roleName = adminRole.getName();
                    if ("Marketing Staff".equals(roleName)) {
                        return "/Staff/marketinghome.jsp";
                    } else if ("Sales".equals(roleName)) {
                        return "/Staff/salehome.jsp";
                    }
                }
                return "/Admin/admin-dashboard.jsp";
                
            case "jobseeker":
                return "/JobSeeker/index.jsp";
                
            case "recruiter":
                return "/Recruiter/index.jsp";
                
            default:
                return "/JobSeeker/jobseeker-login.jsp";
        }
    }
}
