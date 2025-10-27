package dal;

import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Admin;
import model.AdminWithRole;
import model.Role;
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
                            rs.getString("Gender"),
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

    // Lấy tất cả admin đang active
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

    // Lấy tất cả staff (loại trừ Admin)
    public List<Admin> getAllStaff() {
        String sql = "SELECT a.* "
                + "FROM Admins a "
                + "JOIN Role_Staff rs ON a.AdminID = rs.AdminID "
                + "JOIN Roles r ON rs.RoleID = r.RoleID "
                + "WHERE r.Name <> 'Admin' AND a.Status = 'Active'";

        List<Admin> staffList = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Admin staff = new Admin(
                        rs.getInt("AdminID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("FullName"),
                        rs.getString("AvatarUrl"),
                        rs.getString("Phone"),
                        rs.getString("Gender"),
                        rs.getString("Address"),
                        rs.getDate("DateOfBirth"),
                        rs.getString("Bio"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getTimestamp("UpdatedAt"),
                        rs.getString("Status")
                );
                staffList.add(staff);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return staffList;
    }

    //lay moi admin
    public List<Admin> getAdminsOnly() {
        String sql = "SELECT a.* "
                + "FROM Admins a "
                + "JOIN Role_Staff rs ON a.AdminID = rs.AdminID "
                + "JOIN Roles r ON rs.RoleID = r.RoleID "
                + "WHERE r.Name = 'Admin' AND a.Status = 'Active'";

        List<Admin> adminList = new ArrayList<>();

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Admin a = new Admin(
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
                adminList.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return adminList;
    }

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
            ps.setString(1, MD5Util.getMD5Hash(newPassword));
            ps.setInt(2, adminId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public void assignRole(int roleId, int adminId) {
        String sql = "update Role_Staff\n"
                + "set RoleId =? \n"
                + "where AdminId =?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ps.setInt(2, adminId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //add new staff
    public Admin addStaff(Admin staff) {
        String sql = "INSERT INTO Admins (Email, Password, FullName, Phone, Gender, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            st.setString(1, staff.getEmail());
            String hashedPassword = MD5Util.getMD5Hash(staff.getPassword());
            st.setString(2, hashedPassword);
            st.setString(3, staff.getFullName());
            st.setString(4, staff.getPhone());
            st.setString(5, staff.getGender());
            st.setString(6, staff.getStatus() != null ? staff.getStatus() : "Active");

            int rows = st.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = st.getGeneratedKeys()) {
                    if (rs.next()) {
                        staff.setAdminId(rs.getInt(1));
                        return staff;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staff;
    }

    public void assignRoleToStaff(int roleId, int adminId) {
        String sql = "INSERT INTO Role_Staff (RoleID, AdminID) VALUES (?, ?)";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            st.setInt(1, roleId);
            st.setInt(2, adminId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //search
    public List<AdminWithRole> searchAdminWithRole(String keyword) {
        List<AdminWithRole> result = new ArrayList<>();
        String sql = """
        SELECT a.*, r.RoleID, r.Name AS RoleName
        FROM Admins a
        LEFT JOIN Role_Staff rs ON a.AdminID = rs.AdminID
        LEFT JOIN Roles r ON rs.RoleID = r.RoleID
        WHERE a.Status = 'Active' AND (a.FullName LIKE ? OR a.Phone LIKE ?)
    """;
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            String kw = "%" + keyword.trim() + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ResultSet rs = ps.executeQuery();
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

                Role role = null;
                if (rs.getInt("RoleID") != 0) {
                    role = new Role(rs.getInt("RoleID"), rs.getString("RoleName"));
                }
                result.add(new AdminWithRole(admin, role));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    //search với filter theo role
    public List<AdminWithRole> searchAdminWithRole(String keyword, String roleFilter) {
        List<AdminWithRole> result = new ArrayList<>();
        String sql = """
        SELECT a.*, r.RoleID, r.Name AS RoleName
        FROM Admins a
        LEFT JOIN Role_Staff rs ON a.AdminID = rs.AdminID
        LEFT JOIN Roles r ON rs.RoleID = r.RoleID
        WHERE a.Status = 'Active' AND (a.FullName LIKE ? OR a.Phone LIKE ?)
    """;

        // Thêm filter theo role nếu cần
        if (roleFilter != null && !roleFilter.isEmpty()) {
            if ("admin".equals(roleFilter)) {
                sql += " AND r.Name = 'Admin'";
            } else if ("other".equals(roleFilter)) {
                sql += " AND (r.Name IS NULL OR r.Name != 'Admin')";
            }
        }

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            String kw = "%" + keyword.trim() + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ResultSet rs = ps.executeQuery();
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

                Role role = null;
                if (rs.getInt("RoleID") != 0) {
                    role = new Role(rs.getInt("RoleID"), rs.getString("RoleName"));
                }
                result.add(new AdminWithRole(admin, role));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    // Lấy tất cả Admin với Role của họ
    public List<AdminWithRole> getAllAdminWithRole() {
        String sql = "SELECT a.*, r.RoleId, r.Name as RoleName "
                + "FROM Admins a "
                + "LEFT JOIN Role_Staff rs ON a.AdminID = rs.AdminID "
                + "LEFT JOIN Roles r ON rs.RoleID = r.RoleID "
                + "WHERE a.Status = 'Active'";

        List<AdminWithRole> adminWithRoleList = new ArrayList<>();

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
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

                Role role = null;
                if (rs.getInt("RoleId") != 0) {
                    role = new Role(
                            rs.getInt("RoleId"),
                            rs.getString("RoleName")
                    );
                }

                adminWithRoleList.add(new AdminWithRole(admin, role));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return adminWithRoleList;
    }

    // Lấy Admin theo Role cụ thể
    public List<AdminWithRole> getAdminByRole(String roleName) {
        String sql = "SELECT a.*, r.RoleId, r.Name as RoleName "
                + "FROM Admins a "
                + "JOIN Role_Staff rs ON a.AdminID = rs.AdminID "
                + "JOIN Roles r ON rs.RoleID = r.RoleID "
                + "WHERE r.Name = ? AND a.Status = 'Active'";

        List<AdminWithRole> adminWithRoleList = new ArrayList<>();

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, roleName);
            ResultSet rs = ps.executeQuery();
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

                Role role = new Role(
                        rs.getInt("RoleId"),
                        rs.getString("RoleName")
                );

                adminWithRoleList.add(new AdminWithRole(admin, role));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return adminWithRoleList;
    }

    // Lấy tất cả các Role có trong hệ thống
    public List<Role> getAllRoles() {
        String sql = "SELECT * FROM Roles ORDER BY Name";
        List<Role> roleList = new ArrayList<>();

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Role role = new Role(
                        rs.getInt("RoleId"),
                        rs.getString("Name")
                );
                roleList.add(role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return roleList;
    }

    public void updateAvatar(int adminId, String avatarFile) {
        String sql = "UPDATE Admins SET AvatarUrl = ? WHERE AdminID = ?";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            st.setString(1, avatarFile);
            st.setInt(2, adminId);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean updateAdminPassword(int adminId, String newPassword) {
        String sql = "UPDATE Admins SET Password = ? WHERE AdminID = ?";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            st.setString(1, newPassword);
            st.setInt(2, adminId);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
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

    // Lấy role của admin cụ thể
    public Role getAdminRole(int adminId) {
        String sql = "SELECT r.RoleId, r.Name as RoleName " +
                    "FROM Roles r " +
                    "JOIN Role_Staff rs ON r.RoleId = rs.RoleId " +
                    "WHERE rs.AdminId = ?";
        
        System.out.println("DEBUG: Getting role for adminId: " + adminId);
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Role role = new Role(
                        rs.getInt("RoleId"),
                        rs.getString("RoleName")
                    );
                    System.out.println("DEBUG: Found role: " + role.getName());
                    return role;
                } else {
                    System.out.println("DEBUG: No role found for adminId: " + adminId);
                }
            }
        } catch (SQLException e) {
            System.out.println("DEBUG: SQL Error getting role: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
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
