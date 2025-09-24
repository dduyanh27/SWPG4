/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import dal.AdminDAO;
import dal.JobSeekerDAO;
import dal.RecruiterDAO;
import model.Admin;
import model.JobSeeker;
import model.Recruiter;
/**
 *
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
    
    public LoginResult authenticateUser(String email, String password, String loginType) {
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            return new LoginResult(false, "Email and password are required", null, null);
        }
        
        if ("admin".equals(loginType)) {
            return authenticateAdmin(email, password);
        } else if ("jobseeker".equals(loginType)) {
            return authenticateJobSeeker(email, password);
        } else if ("recruiter".equals(loginType)) {
            return authenticateRecruiter(email, password);
        } else {
            // Auto-detect user type
            return authenticateAutoDetect(email, password);
        }
    }
    
    private LoginResult authenticateAdmin(String email, String password) {
        Admin admin = adminDAO.login(email, password);
        if (admin != null) {
            return new LoginResult(true, "Admin login successful", "admin", admin);
        }
        
        return new LoginResult(false, "Invalid admin credentials", null, null);
    }
    
    private LoginResult authenticateJobSeeker(String email, String password) {
        JobSeeker jobSeeker = jobSeekerDAO.login(email, password);
        if (jobSeeker != null) {
            return new LoginResult(true, "JobSeeker login successful", "jobseeker", jobSeeker);
        }
        
        return new LoginResult(false, "Invalid jobseeker credentials", null, null);
    }
    
    private LoginResult authenticateRecruiter(String email, String password) {
        Recruiter recruiter = recruiterDAO.login(email, password);
        if (recruiter != null) {
            return new LoginResult(true, "Recruiter login successful", "recruiter", recruiter);
        }
        
        return new LoginResult(false, "Invalid recruiter credentials", null, null);
    }
    
    private LoginResult authenticateAutoDetect(String email, String password) {
        // Thử tất cả các loại user theo thứ tự ưu tiên
        // Admin -> JobSeeker -> Recruiter
        
        Admin admin = adminDAO.login(email, password);
        if (admin != null) {
            return new LoginResult(true, "Admin login successful", "admin", admin);
        }
        
        JobSeeker jobSeeker = jobSeekerDAO.login(email, password);
        if (jobSeeker != null) {
            return new LoginResult(true, "JobSeeker login successful", "jobseeker", jobSeeker);
        }
        
        Recruiter recruiter = recruiterDAO.login(email, password);
        if (recruiter != null) {
            return new LoginResult(true, "Recruiter login successful", "recruiter", recruiter);
        }
        
        return new LoginResult(false, "Invalid credentials", null, null);
    }
    
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
