package util;

import dal.AdminDAO;
import dal.JobSeekerDAO;
import dal.RecruiterDAO;
import model.Admin;
import model.AdminWithRole;
import model.JobSeeker;
import model.Recruiter;
import model.Role;

/**
 * Centralized authentication service for all user types
 * @author ADMIN
 */
public class LoginService {
    private static LoginService instance;
    private final AdminDAO adminDAO;
    private final JobSeekerDAO jobSeekerDAO;
    private final RecruiterDAO recruiterDAO;
    
    private LoginService() {
        this.adminDAO = new AdminDAO();
        this.jobSeekerDAO = new JobSeekerDAO();
        this.recruiterDAO = new RecruiterDAO();
    }
    
    public static synchronized LoginService getInstance() {
        if (instance == null) {
            instance = new LoginService();
        }
        return instance;
    }
    
    // ========================================
    // PUBLIC METHODS
    // ========================================
    
    public LoginResult authenticateUser(String email, String password, String loginType) {
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            return new LoginResult(false, "Vui lòng nhập đầy đủ email và mật khẩu.", null, null);
        }
        
        switch (loginType) {
            case "admin":
                return authenticateAdmin(email, password);
            case "jobseeker":
                return authenticateJobSeeker(email, password);
            case "recruiter":
                return authenticateRecruiter(email, password);
            default:
                return new LoginResult(false, "Loại đăng nhập không hợp lệ.", null, null);
        }
    }
    
    // ========================================
    // PRIVATE AUTHENTICATION METHODS
    // ========================================
    
    private LoginResult authenticateAdmin(String email, String password) {
        Admin admin = adminDAO.login(email, password);
        if (admin != null) {
            // Get the role for this admin
            Role role = adminDAO.getAdminRole(admin.getAdminId());
            AdminWithRole adminWithRole = new AdminWithRole(admin, role);
            return new LoginResult(true, "Admin login successful", "admin", adminWithRole);
        }
        
        return new LoginResult(false, "Email hoặc mật khẩu không đúng. Vui lòng kiểm tra lại thông tin đăng nhập.", null, null);
    }
    
    private LoginResult authenticateJobSeeker(String email, String password) {
        JobSeeker jobSeeker = jobSeekerDAO.login(email, password);
        if (jobSeeker != null) {
            return new LoginResult(true, "JobSeeker login successful", "jobseeker", jobSeeker);
        }
        
        return new LoginResult(false, "Email hoặc mật khẩu không đúng. Vui lòng kiểm tra lại thông tin đăng nhập.", null, null);
    }
    
    private LoginResult authenticateRecruiter(String email, String password) {
        Recruiter recruiter = recruiterDAO.login(email, password);
        if (recruiter != null) {
            return new LoginResult(true, "Recruiter login successful", "recruiter", recruiter);
        }
        
        return new LoginResult(false, "Email hoặc mật khẩu không đúng. Vui lòng kiểm tra lại thông tin đăng nhập.", null, null);
    }
    
    // ========================================
    // INNER CLASSES
    // ========================================
    
    public static class LoginResult {
        private final boolean success;
        private final String message;
        private final String userType;
        private final Object user;
        
        public LoginResult(boolean success, String message, String userType, Object user) {
            this.success = success;
            this.message = message;
            this.userType = userType;
            this.user = user;
        }
        
        public boolean isSuccess() {
            return success;
        }
        
        public String getMessage() {
            return message;
        }
        
        public String getUserType() {
            return userType;
        }
        
        public Object getUser() {
            return user;
        }
    }
}
