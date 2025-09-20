package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Admin;

public class AdminDAO extends DBContext {

    // Đăng nhập (check email + password)
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
                            rs.getString("Gender"),       // ✅ thêm Gender
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

    // Lấy danh sách toàn bộ admin
    public List<Admin> getAllAdmin() {
        String sql = "SELECT * FROM Admins";
        List<Admin> adminList = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Admin admin = new Admin(
                        rs.getInt("AdminID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("FullName"),
                        rs.getString("AvatarURL"),
                        rs.getString("Phone"),
                        rs.getString("Gender"),       // ✅ thêm Gender
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
}
