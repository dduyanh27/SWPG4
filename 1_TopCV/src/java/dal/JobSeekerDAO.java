package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.JobSeeker;
import util.MD5Util;

public class JobSeekerDAO extends DBContext {

    // Đăng nhập JobSeeker
    public JobSeeker getJobSeekerAccount(String email, String password) {
        String sql = "SELECT * FROM JobSeeker WHERE Email = ? AND Password = ?";
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new JobSeeker(
                        rs.getInt("JobSeekerID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("FullName"),
                        rs.getString("Phone"),
                        rs.getString("Gender"),
                        rs.getString("Headline"),
                        rs.getString("ContactInfo"),
                        rs.getString("Address"),
                        rs.getInt("LocationID"),
                        rs.getString("Img"),
                        rs.getInt("CurrentLevelID"),
                        rs.getString("Status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy danh sách JobSeeker đang Active
    public List<JobSeeker> getAllJobSeekers() {
        List<JobSeeker> list = new ArrayList<>();
        String sql = "SELECT * FROM JobSeeker WHERE Status = 'Active'";
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new JobSeeker(
                        rs.getInt("JobSeekerID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("FullName"),
                        rs.getString("Phone"),
                        rs.getString("Gender"),
                        rs.getString("Headline"),
                        rs.getString("ContactInfo"),
                        rs.getString("Address"),
                        rs.getInt("LocationID"),
                        rs.getString("Img"),
                        rs.getInt("CurrentLevelID"),
                        rs.getString("Status")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm số lượng JobSeeker
    public int countJobSeeker() {
        String sql = "SELECT COUNT(*) FROM JobSeeker";
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public boolean deleteJobSeekerById(int id) {
        String sql = "UPDATE JobSeeker SET Status = 'Inactive' WHERE JobSeekerID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    //MINH
    public JobSeeker login(String email, String password) {
        JobSeeker jobSeeker = null;
        String sql = "SELECT * FROM JobSeeker WHERE Email = ? AND Password = ? AND Status = 'Active'";
        
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, email);
            // Mã hóa mật khẩu bằng MD5 trước khi so sánh
            ps.setString(2, MD5Util.getMD5Hash(password));
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                jobSeeker = new JobSeeker(
                    rs.getInt("JobSeekerID"),
                    rs.getString("Email"),
                    rs.getString("Password"),
                    rs.getString("FullName"),
                    rs.getString("Phone"),
                    rs.getString("Gender"),
                    rs.getString("Headline"),
                    rs.getString("ContactInfo"),
                    rs.getString("Address"),
                    rs.getInt("LocationID"),
                    rs.getString("Img"),
                    rs.getInt("CurrentLevelID"),
                    rs.getString("Status")
                );
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return jobSeeker;
    }

    public JobSeeker getJobSeekerByEmail(String email) {
        JobSeeker jobSeeker = null;
        String sql = "SELECT * FROM JobSeeker WHERE Email = ?";
        
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, email);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                jobSeeker = new JobSeeker(
                    rs.getInt("JobSeekerID"),
                    rs.getString("Email"),
                    rs.getString("Password"),
                    rs.getString("FullName"),
                    rs.getString("Phone"),
                    rs.getString("Gender"),
                    rs.getString("Headline"),
                    rs.getString("ContactInfo"),
                    rs.getString("Address"),
                    rs.getInt("LocationID"),
                    rs.getString("Img"),
                    rs.getInt("CurrentLevelID"),
                    rs.getString("Status")
                );
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return jobSeeker;
    }
    
    // Kiểm tra email đã tồn tại trong tất cả các bảng (JobSeeker, Admin, Recruiter)
    public boolean isEmailExistsInAllTables(String email) {
        try {
            // Kiểm tra trong bảng JobSeeker
            String jobseekerSql = "SELECT COUNT(*) FROM JobSeeker WHERE Email = ?";
            PreparedStatement jobseekerPs = c.prepareStatement(jobseekerSql);
            jobseekerPs.setString(1, email);
            ResultSet jobseekerRs = jobseekerPs.executeQuery();
            if (jobseekerRs.next() && jobseekerRs.getInt(1) > 0) {
                jobseekerRs.close();
                jobseekerPs.close();
                return true;
            }
            jobseekerRs.close();
            jobseekerPs.close();
            
            // Kiểm tra trong bảng Recruiter
            String recruiterSql = "SELECT COUNT(*) FROM Recruiter WHERE Email = ?";
            PreparedStatement recruiterPs = c.prepareStatement(recruiterSql);
            recruiterPs.setString(1, email);
            ResultSet recruiterRs = recruiterPs.executeQuery();
            if (recruiterRs.next() && recruiterRs.getInt(1) > 0) {
                recruiterRs.close();
                recruiterPs.close();
                return true;
            }
            recruiterRs.close();
            recruiterPs.close();
            
            // Kiểm tra trong bảng Admin
            String adminSql = "SELECT COUNT(*) FROM Admin WHERE Email = ?";
            PreparedStatement adminPs = c.prepareStatement(adminSql);
            adminPs.setString(1, email);
            ResultSet adminRs = adminPs.executeQuery();
            if (adminRs.next() && adminRs.getInt(1) > 0) {
                adminRs.close();
                adminPs.close();
                return true;
            }
            adminRs.close();
            adminPs.close();
            
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // Return true to be safe (prevent registration if error)
        }
    }

    public JobSeeker insertJobSeeker(String email, String password, String status) {
        String sql = "INSERT INTO JobSeeker (Email, Password, Status) VALUES (?, ?, ?)";
        try {
            PreparedStatement ps = c.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, status);
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int jobSeekerID = generatedKeys.getInt(1);
                    JobSeeker jobSeeker = new JobSeeker(
                        jobSeekerID,
                        email,
                        password,
                        null, // FullName
                        null, // Phone
                        null, // Gender
                        null, // Headline
                        null, // ContactInfo
                        null, // Address
                        0,    // LocationID
                        null, // Img
                        0,    // CurrentLevelID
                        status
                    );
                    generatedKeys.close();
                    ps.close();
                    return jobSeeker;
                }
                generatedKeys.close();
            }
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    //Minh
}
