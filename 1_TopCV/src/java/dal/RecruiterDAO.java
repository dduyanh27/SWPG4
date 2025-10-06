package dal;

import model.Recruiter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.MD5Util;

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
    
    //DUY ANH
    // Lấy Recruiter theo email & password
    public Recruiter getRecruiterAccount(String email, String password) {
        String sql = "SELECT * FROM Recruiter WHERE Email = ? AND Password = ?";
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
//                return new Recruiter(
//                        rs.getInt("RecruiterID"),
//                        rs.getString("Email"),
//                        rs.getString("Password"),
//                        rs.getString("Phone"),
//                        rs.getString("Gender"),
//                        rs.getString("CompanyName"),
//                        rs.getString("CompanyDescription"),
//                        rs.getString("CompanyLogoURL"),
//                        rs.getString("Website"),
//                        rs.getString("Img"),
//                        rs.getInt("CategoryID"),
//                        rs.getString("Status")
//                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Đếm số lượng Recruiter
    public int countRecruiter() {
        String sql = "SELECT COUNT(*) FROM Recruiter";
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

    // Lấy tất cả Recruiter đang Active
//    public List<Recruiter> getAllRecruiters() {
//        List<Recruiter> list = new ArrayList<>();
//        String sql = "SELECT * FROM Recruiter WHERE Status = 'Active'";
//        try {
//            PreparedStatement ps = c.prepareStatement(sql);
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                list.add(new Recruiter(
//                        rs.getInt("RecruiterID"),
//                        rs.getString("Email"),
//                        rs.getString("Password"),
//                        rs.getString("Phone"),
//                        rs.getString("Gender"),
//                        rs.getString("CompanyName"),
//                        rs.getString("CompanyDescription"),
//                        rs.getString("CompanyLogoURL"),
//                        rs.getString("Website"),
//                        rs.getString("Img"),
//                        rs.getInt("CategoryID"),
//                        rs.getString("Status")
//                ));
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return list;
//    }

    public boolean deleteRecruiterById(int id) {
        String sql = "UPDATE Recruiter SET Status = 'Inactive' WHERE RecruiterID = ?";
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
    public Recruiter getRecruiterByEmail1(String email) {
        Recruiter recruiter = null;
        String sql = "SELECT * FROM Recruiter WHERE Email = ?";
        
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, email);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                recruiter = new Recruiter(
                    rs.getInt("RecruiterID"),
                    rs.getString("Email"),
                    rs.getString("Password"),
                    rs.getString("Phone"),
                    rs.getString("Gender"),
                    rs.getString("CompanyName"),
                    rs.getString("CompanyDescription"),
                    rs.getString("CompanyLogoURL"),
                    rs.getString("Website"),
                    rs.getString("Img"),
                    rs.getInt("CategoryID"),
                    rs.getString("Status"),
                    rs.getString("CompanyAddress"),
                    rs.getString("CompanySize"),
                    rs.getString("ContactPerson"),
                    rs.getString("CompanyBenefits"),
                    rs.getString("CompanyVideoURL")
                );
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return recruiter;
    }
    
    public Recruiter login(String email, String password) {
        Recruiter recruiter = null;
        String sql = "SELECT * FROM Recruiter WHERE Email = ? AND Password = ? AND Status = 'Active'";
        
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, email);
            // Mã hóa mật khẩu bằng MD5 trước khi so sánh
            ps.setString(2, MD5Util.getMD5Hash(password));
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                recruiter = new Recruiter(
                    rs.getInt("RecruiterID"),
                    rs.getString("Email"),
                    rs.getString("Password"),
                    rs.getString("Phone"),
                    rs.getString("Gender"),
                    rs.getString("CompanyName"),
                    rs.getString("CompanyDescription"),
                    rs.getString("CompanyLogoURL"),
                    rs.getString("Website"),
                    rs.getString("Img"),
                    rs.getInt("CategoryID"),
                    rs.getString("Status"),
                    rs.getString("CompanyAddress"),
                    rs.getString("CompanySize"),
                    rs.getString("ContactPerson"),
                    rs.getString("CompanyBenefits"),
                    rs.getString("CompanyVideoURL")
                );
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return recruiter;
    }
    
    // Update company information
    public boolean updateCompanyInfo(int recruiterId, String companyName, String phone, 
                                   String companyAddress, String companySize, String contactPerson,
                                   String industry, String companyBenefits, String companyDescription,
                                   String companyVideoURL, String website, String logoPath, 
                                   String companyImagesPath) {
        String sql = "UPDATE Recruiter SET CompanyName = ?, Phone = ?, CompanyAddress = ?, " +
                    "CompanySize = ?, ContactPerson = ?, CompanyBenefits = ?, " +
                    "CompanyDescription = ?, CompanyVideoURL = ?, Website = ?, " +
                    "CompanyLogoURL = ?, Img = ? WHERE RecruiterID = ?";
        
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, companyName);
            ps.setString(2, phone);
            ps.setString(3, companyAddress);
            ps.setString(4, companySize);
            ps.setString(5, contactPerson);
            ps.setString(6, companyBenefits);
            ps.setString(7, companyDescription);
            ps.setString(8, companyVideoURL);
            ps.setString(9, website);
            ps.setString(10, logoPath);
            ps.setString(11, companyImagesPath);
            ps.setInt(12, recruiterId);
            
            int affectedRows = ps.executeUpdate();
            ps.close();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Update password for recruiter
    public boolean updatePassword(int recruiterId, String newPassword) {
        if (c == null) {
            System.err.println("Database connection is null in RecruiterDAO.updatePassword");
            return false;
        }
        
        String sql = "UPDATE Recruiter SET Password = ? WHERE RecruiterID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, MD5Util.getMD5Hash(newPassword));
            ps.setInt(2, recruiterId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean isEmailExistsInAllTables(String email) {
        try {
            // Check Recruiter table
            if (checkEmailInTable("Recruiter", email)) {
                return true;
            }
            
            // Check JobSeeker table
//            if (checkEmailInTable("JobSeeker", email)) {
//                return true;
//            }
//            
//            // Check Admin table (with error handling)
//            try {
//                if (checkEmailInTable("Admin", email)) {
//                    return true;
//                }
//            } catch (SQLException e) {
//                // Admin table might not exist, continue
//            }
            
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // Return true to be safe (prevent registration if error)
        }
    }
    
    private boolean checkEmailInTable(String tableName, String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM " + tableName + " WHERE Email = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }
    
    public Recruiter insertRecruiter(String email, String password, String fullName, String phone, 
                                   String companyName, String industry, String address, String status) {
        // Try with CategoryID first
        String sql = "INSERT INTO Recruiter (Email, Password, Phone, CompanyName, CompanyAddress, Status, ContactPerson, CategoryID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, phone);
            ps.setString(4, companyName);
            ps.setString(5, address);
            ps.setString(6, status);
            ps.setString(7, fullName);
            ps.setInt(8, 1); // Default category
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int recruiterID = generatedKeys.getInt(1);
                    
                    Recruiter recruiter = new Recruiter();
                    recruiter.setRecruiterID(recruiterID);
                    recruiter.setEmail(email);
                    recruiter.setPassword(password);
                    recruiter.setPhone(phone);
                    recruiter.setCompanyName(companyName);
                    recruiter.setCompanyAddress(address);
                    recruiter.setStatus(status);
                    recruiter.setContactPerson(fullName);
                    recruiter.setCategoryID(1); // Default category
                    return recruiter;
                }
            }
        } catch (SQLException e) {
            // If CategoryID fails, try without it
            try {
                String sqlWithoutCategory = "INSERT INTO Recruiter (Email, Password, Phone, CompanyName, CompanyAddress, Status, ContactPerson) VALUES (?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement ps2 = c.prepareStatement(sqlWithoutCategory, PreparedStatement.RETURN_GENERATED_KEYS);
                ps2.setString(1, email);
                ps2.setString(2, password);
                ps2.setString(3, phone);
                ps2.setString(4, companyName);
                ps2.setString(5, address);
                ps2.setString(6, status);
                ps2.setString(7, fullName);
                
                int affectedRows2 = ps2.executeUpdate();
                
                if (affectedRows2 > 0) {
                    ResultSet generatedKeys2 = ps2.getGeneratedKeys();
                    if (generatedKeys2.next()) {
                        int recruiterID = generatedKeys2.getInt(1);
                        
                        Recruiter recruiter = new Recruiter();
                        recruiter.setRecruiterID(recruiterID);
                        recruiter.setEmail(email);
                        recruiter.setPassword(password);
                        recruiter.setPhone(phone);
                        recruiter.setCompanyName(companyName);
                        recruiter.setCompanyAddress(address);
                        recruiter.setStatus(status);
                        recruiter.setContactPerson(fullName);
                        recruiter.setCategoryID(1); // Default category
                        return recruiter;
                    }
                }
                ps2.close();
            } catch (SQLException e2) {
                e2.printStackTrace();
            }
        }
        return null;
    }
    
    public boolean updateCompanyImages(int recruiterId, String companyImagesPath) {
        String sql = "UPDATE Recruiter SET Img = ? WHERE RecruiterID = ?";
        
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, companyImagesPath);
            ps.setInt(2, recruiterId);
            
            int affectedRows = ps.executeUpdate();
            ps.close();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateCompanyInfo(int recruiterId, String companyName, String phone, 
                                   String companyAddress, String companySize, String contactPerson,
                                   String companyBenefits, String companyDescription,
                                   String companyVideoURL, String website, String logoPath, 
                                   String companyImagesPath) {
        String sql = "UPDATE Recruiter SET CompanyName = ?, Phone = ?, CompanyAddress = ?, " +
                    "CompanySize = ?, ContactPerson = ?, CompanyBenefits = ?, " +
                    "CompanyDescription = ?, CompanyVideoURL = ?, Website = ?, " +
                    "CompanyLogoURL = ?, Img = ? WHERE RecruiterID = ?";
        
        
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, companyName);
            ps.setString(2, phone);
            ps.setString(3, companyAddress);
            ps.setString(4, companySize);
            ps.setString(5, contactPerson);
            ps.setString(6, companyBenefits);
            ps.setString(7, companyDescription);
            ps.setString(8, companyVideoURL);
            ps.setString(9, website);
            ps.setString(10, logoPath);
            ps.setString(11, companyImagesPath);
            ps.setInt(12, recruiterId);
            
            int affectedRows = ps.executeUpdate();
            ps.close();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    //MINH
}
