package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Admin;
import util.MD5Util;

public class AdminDAO extends DBContext {

    public Admin getAdminAccount(String email, String password) {
        String sql = "SELECT * FROM Admins WHERE Email = ? AND Password = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Admin(
                            rs.getInt("AdminID"),
                            rs.getString("Email"),
                            rs.getString("Password"),
                            rs.getString("FullName"),
                            rs.getString("AvatarURL"),
                            rs.getString("Phone"),
                            rs.getString("Gender"), // ✅ thêm Gender
                            rs.getString("Address"),
                            rs.getDate("DateOfBirth"),
                            rs.getString("Bio"),
                            rs.getTimestamp("CreatedAt"),
                            rs.getTimestamp("UpdatedAt"),
                            rs.getString("Status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Admin> getAllAdmin() {
        String sql = "SELECT * FROM Admins WHERE Status = 'Active'";
        List<Admin> adminList = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Admin admin = new Admin(
                        rs.getInt("AdminID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("FullName"),
                        rs.getString("AvatarURL"),
                        rs.getString("Phone"),
                        rs.getString("Gender"),
                        rs.getString("Address"),
                        rs.getDate("DateOfBirth"),
                        rs.getString("Bio"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getTimestamp("UpdatedAt"),
                        rs.getString("Status")
                );
                adminList.add(admin);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return adminList;
    }

//    public boolean deleteAdminById(int id) {
//        String sql = "DELETE FROM Admins WHERE AdminID = ?";
//        try (PreparedStatement ps = c.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            int rows = ps.executeUpdate();
//            return rows > 0;
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
    public boolean deleteAdminById(int adminId) {
        String sql = "UPDATE Admins\n"
                + "SET Status = 'Inactive'\n"
                + "WHERE AdminID = ?;";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getActiveDays(int adminId) {
        String sql = "SELECT DATEDIFF(DAY, CreatedAt, GETDATE()) AS ActiveDays "
                + "FROM Admins WHERE AdminID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("ActiveDays");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public Admin getAdminById(int adminId) {
        String sql = "SELECT * FROM Admins WHERE adminId=?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Admin(
                        rs.getInt("adminId"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("fullName"),
                        rs.getString("avatarURL"),
                        rs.getString("phone"),
                        rs.getString("gender"),
                        rs.getString("address"),
                        rs.getDate("dateOfBirth"),
                        rs.getString("bio"),
                        rs.getTimestamp("createdAt"),
                        rs.getTimestamp("updatedAt"),
                        rs.getString("status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public void updateAdmin(Admin admin) {
        String sql = "UPDATE Admins SET phone=?, gender=?, address=?, bio=?, updatedAt=GETDATE() WHERE adminId=?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, admin.getPhone());
            ps.setString(2, admin.getGender());
            ps.setString(3, admin.getAddress());
            ps.setString(4, admin.getBio());
            ps.setInt(5, admin.getAdminId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void updatePassword(int adminId, String newPassword) {
    String sql = "UPDATE Admins SET password=?, updatedAt=GETDATE() WHERE adminId=?";
    try (PreparedStatement ps = c.prepareStatement(sql)) {
        ps.setString(1, newPassword);
        ps.setInt(2, adminId);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }  
}
    //Minh
  public Admin login(String email, String password) {
        Admin admin = null;
        String sql = "SELECT * FROM Admins WHERE Email = ? AND Password = ? AND Status = 'Active'";
        
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, email);
            // Mã hóa mật khẩu bằng MD5 trước khi so sánh
            ps.setString(2, MD5Util.getMD5Hash(password));
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                admin = new Admin(
                    rs.getInt("AdminID"),
                    rs.getString("Email"),
                    rs.getString("Password"),
                    rs.getString("FullName"),
                    rs.getString("AvatarURL"),
                    rs.getString("Phone"),
                    rs.getString("Gender"),
                    rs.getString("Address"),
                    rs.getDate("DateOfBirth"),
                    rs.getString("Bio"),
                    rs.getTimestamp("CreatedAt"),
                    rs.getTimestamp("UpdatedAt"),
                    rs.getString("Status")
                );
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return admin;
    }
    
    public Admin getAdminByEmail(String email) {
        Admin admin = null;
        String sql = "SELECT * FROM Admins WHERE Email = ?";
        
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, email);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                admin = new Admin(
                    rs.getInt("AdminID"),
                    rs.getString("Email"),
                    rs.getString("Password"),
                    rs.getString("FullName"),
                    rs.getString("AvatarURL"),
                    rs.getString("Phone"),
                    rs.getString("Gender"),
                    rs.getString("Address"),
                    rs.getDate("DateOfBirth"),
                    rs.getString("Bio"),
                    rs.getTimestamp("CreatedAt"),
                    rs.getTimestamp("UpdatedAt"),
                    rs.getString("Status")
                );
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return admin;
    }      
 //MINH
}
