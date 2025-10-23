package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.Admin;
import model.JobSeeker;
import model.Recruiter;

/**
 * Utility class để hỗ trợ làm việc với Session trong ứng dụng
 */
public class SessionHelper {
    
    /**
     * Lấy JobSeeker hiện tại từ session
     * @param request HttpServletRequest
     * @return JobSeeker object hoặc null nếu không có trong session
     */
    public static JobSeeker getCurrentJobSeeker(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (JobSeeker) session.getAttribute("jobseeker");
        }
        return null;
    }
    
    /**
     * Lấy Recruiter hiện tại từ session
     * @param request HttpServletRequest
     * @return Recruiter object hoặc null nếu không có trong session
     */
    public static Recruiter getCurrentRecruiter(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (Recruiter) session.getAttribute("recruiter");
        }
        return null;
    }
    
    /**
     * Lấy Admin hiện tại từ session
     * @param request HttpServletRequest
     * @return Admin object hoặc null nếu không có trong session
     */
    public static Admin getCurrentAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (Admin) session.getAttribute("admin");
        }
        return null;
    }
    
    /**
     * Lấy User ID hiện tại từ session hoặc request attributes
     * @param request HttpServletRequest  
     * @return User ID hoặc null nếu không tìm thấy
     */
    public static Integer getCurrentUserId(HttpServletRequest request) {
        // Thử lấy từ request attributes trước (đã được set bởi AuthenticationFilter)
        Object userID = request.getAttribute("userID");
        if (userID instanceof Integer) {
            return (Integer) userID;
        }
        
        // Thử lấy từ session
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object sessionUserID = session.getAttribute("userID");
            if (sessionUserID instanceof Integer) {
                return (Integer) sessionUserID;
            }
        }
        
        return null;
    }
    
    /**
     * Lấy User Type hiện tại từ session hoặc request attributes
     * @param request HttpServletRequest  
     * @return User Type ("admin", "jobseeker", "recruiter") hoặc null
     */
    public static String getCurrentUserType(HttpServletRequest request) {
        // Thử lấy từ request attributes trước (đã được set bởi AuthenticationFilter)
        Object userType = request.getAttribute("userType");
        if (userType instanceof String) {
            return (String) userType;
        }
        
        // Thử lấy từ session
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object sessionUserType = session.getAttribute("userType");
            if (sessionUserType instanceof String) {
                return (String) sessionUserType;
            }
        }
        
        return null;
    }
    
    /**
     * Kiểm tra xem user hiện tại có phải JobSeeker không
     * @param request HttpServletRequest
     * @return true nếu là JobSeeker, false nếu không
     */
    public static boolean isJobSeeker(HttpServletRequest request) {
        return "jobseeker".equals(getCurrentUserType(request));
    }
    
    /**
     * Kiểm tra xem user hiện tại có phải Recruiter không
     * @param request HttpServletRequest
     * @return true nếu là Recruiter, false nếu không
     */
    public static boolean isRecruiter(HttpServletRequest request) {
        return "recruiter".equals(getCurrentUserType(request));
    }
    
    /**
     * Kiểm tra xem user hiện tại có phải Admin không
     * @param request HttpServletRequest
     * @return true nếu là Admin, false nếu không
     */
    public static boolean isAdmin(HttpServletRequest request) {
        return "admin".equals(getCurrentUserType(request));
    }
    
    /**
     * Cập nhật JobSeeker trong session sau khi update thông tin
     * @param request HttpServletRequest
     * @param jobSeeker JobSeeker object đã được cập nhật
     */
    public static void updateJobSeekerInSession(HttpServletRequest request, JobSeeker jobSeeker) {
        HttpSession session = request.getSession();
        session.setAttribute("jobseeker", jobSeeker);
        session.setAttribute("userName", jobSeeker.getFullName());
        // Đồng bộ user object chung
        session.setAttribute("user", jobSeeker);
    }
    
    /**
     * Cập nhật Recruiter trong session sau khi update thông tin
     * @param request HttpServletRequest
     * @param recruiter Recruiter object đã được cập nhật
     */
    public static void updateRecruiterInSession(HttpServletRequest request, Recruiter recruiter) {
        HttpSession session = request.getSession();
        session.setAttribute("recruiter", recruiter);
        session.setAttribute("userName", recruiter.getCompanyName());
        // Đồng bộ user object chung
        session.setAttribute("user", recruiter);
    }
    
    /**
     * Cập nhật Admin trong session sau khi update thông tin
     * @param request HttpServletRequest
     * @param admin Admin object đã được cập nhật
     */
    public static void updateAdminInSession(HttpServletRequest request, Admin admin) {
        HttpSession session = request.getSession();
        session.setAttribute("admin", admin);
        session.setAttribute("userName", admin.getFullName());
        // Đồng bộ user object chung
        session.setAttribute("user", admin);
    }
}