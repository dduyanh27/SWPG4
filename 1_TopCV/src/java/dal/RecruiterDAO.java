package dal;

import model.Recruiter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RecruiterDAO extends DBContext {
    
    // Thêm recruiter mới
    public boolean addRecruiter(Recruiter recruiter) {
        String sql = "INSERT INTO Recruiter (Email, Password, Phone, Gender, CompanyName, " +
                    "CompanyDescription, CompanyLogoURL, Website, Img, CategoryID, Status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, recruiter.getEmail());
            ps.setString(2, recruiter.getPassword());
            ps.setString(3, recruiter.getPhone());
            ps.setString(4, recruiter.getGender());
            ps.setString(5, recruiter.getCompanyName());
            ps.setString(6, recruiter.getCompanyDescription());
            ps.setString(7, recruiter.getCompanyLogoURL());
            ps.setString(8, recruiter.getWebsite());
            ps.setString(9, recruiter.getImg());
            ps.setInt(10, recruiter.getCategoryID());
            ps.setString(11, recruiter.getStatus());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy recruiter theo ID
    public Recruiter getRecruiterById(int recruiterId) {
        String sql = "SELECT * FROM Recruiter WHERE RecruiterID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToRecruiter(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy recruiter theo email
    public Recruiter getRecruiterByEmail(String email) {
        String sql = "SELECT * FROM Recruiter WHERE Email = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToRecruiter(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Xác thực đăng nhập
    public Recruiter authenticate(String email, String password) {
        String sql = "SELECT * FROM Recruiter WHERE Email = ? AND Password = ? AND Status = 'Active'";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToRecruiter(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Cập nhật recruiter
    public boolean updateRecruiter(Recruiter recruiter) {
        String sql = "UPDATE Recruiter SET Phone = ?, Gender = ?, CompanyName = ?, " +
                    "CompanyDescription = ?, CompanyLogoURL = ?, Website = ?, Img = ?, " +
                    "CategoryID = ?, Status = ? WHERE RecruiterID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, recruiter.getPhone());
            ps.setString(2, recruiter.getGender());
            ps.setString(3, recruiter.getCompanyName());
            ps.setString(4, recruiter.getCompanyDescription());
            ps.setString(5, recruiter.getCompanyLogoURL());
            ps.setString(6, recruiter.getWebsite());
            ps.setString(7, recruiter.getImg());
            ps.setInt(8, recruiter.getCategoryID());
            ps.setString(9, recruiter.getStatus());
            ps.setInt(10, recruiter.getRecruiterID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xóa recruiter
    public boolean deleteRecruiter(int recruiterId) {
        String sql = "DELETE FROM Recruiter WHERE RecruiterID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy tất cả recruiters
    public List<Recruiter> getAllRecruiters() {
        List<Recruiter> recruiters = new ArrayList<>();
        String sql = "SELECT * FROM Recruiter ORDER BY CompanyName";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                recruiters.add(mapResultSetToRecruiter(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recruiters;
    }
    
    // Helper method để map ResultSet thành Recruiter object
    private Recruiter mapResultSetToRecruiter(ResultSet rs) throws SQLException {
        Recruiter recruiter = new Recruiter();
        recruiter.setRecruiterID(rs.getInt("RecruiterID"));
        recruiter.setEmail(rs.getString("Email"));
        recruiter.setPassword(rs.getString("Password"));
        recruiter.setPhone(rs.getString("Phone"));
        recruiter.setGender(rs.getString("Gender"));
        recruiter.setCompanyName(rs.getString("CompanyName"));
        recruiter.setCompanyDescription(rs.getString("CompanyDescription"));
        recruiter.setCompanyLogoURL(rs.getString("CompanyLogoURL"));
        recruiter.setWebsite(rs.getString("Website"));
        recruiter.setImg(rs.getString("Img"));
        recruiter.setCategoryID(rs.getInt("CategoryID"));
        recruiter.setStatus(rs.getString("Status"));
        
        return recruiter;
    }
}
