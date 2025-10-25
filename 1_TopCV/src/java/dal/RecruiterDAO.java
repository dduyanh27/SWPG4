package dal;

import model.Recruiter;
import util.MD5Util;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object (DAO) cho bảng Recruiter.
 * Chứa các phương thức CRUD và tiện ích hỗ trợ xác thực, kiểm tra dữ liệu.
 */
public class RecruiterDAO extends DBContext {

    //=============================
    // HELPER METHOD
    //=============================

    /**
     * Chuyển đổi một dòng ResultSet thành đối tượng Recruiter.
     */
    private Recruiter mapResultSetToRecruiter(ResultSet rs) throws SQLException {
        Recruiter r = new Recruiter();
        r.setRecruiterID(rs.getInt("RecruiterID"));
        r.setEmail(rs.getString("Email"));
        r.setPassword(rs.getString("Password"));
        r.setPhone(rs.getString("Phone"));
        r.setCompanyName(rs.getString("CompanyName"));
        r.setCompanyDescription(rs.getString("CompanyDescription"));
        r.setCompanyLogoURL(rs.getString("CompanyLogoURL"));
        r.setWebsite(rs.getString("Website"));
        r.setImg(rs.getString("Img"));
        r.setCategoryID(rs.getInt("CategoryID"));
        r.setStatus(rs.getString("Status"));
        r.setCompanyAddress(rs.getString("CompanyAddress"));
        r.setCompanySize(rs.getString("CompanySize"));
        r.setContactPerson(rs.getString("ContactPerson"));
        r.setCompanyBenefits(rs.getString("CompanyBenefits"));
        r.setCompanyVideoURL(rs.getString("CompanyVideoURL"));
        r.setTaxcode(rs.getString("Taxcode"));
        r.setRegistrationCert(rs.getString("RegistrationCert"));
        return r;
    }

    //=============================
    // CREATE
    //=============================

    /**
     * Thêm mới Recruiter (đăng ký).
     * @return Recruiter có ID mới nếu thành công, ngược lại null.
     */
    public Recruiter insertRecruiter(Recruiter recruiter) {
        String sql = """
            INSERT INTO Recruiter (Email, Password, CompanyName, ContactPerson, Phone, Status, CategoryID)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, recruiter.getEmail());
            ps.setString(2, MD5Util.getMD5Hash(recruiter.getPassword()));
            ps.setString(3, recruiter.getCompanyName());
            ps.setString(4, recruiter.getContactPerson());
            ps.setString(5, recruiter.getPhone());
            ps.setString(6, "Active");
            ps.setInt(7, 1);

            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        recruiter.setRecruiterID(rs.getInt(1));
                        return recruiter;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
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
        return list;
    }

    // Cập nhật recruiter
    public boolean updateRecruiter(Recruiter recruiter) {
        String sql = "UPDATE Recruiter SET Phone = ?, CompanyName = ?, "
                + "CompanyDescription = ?, CompanyLogoURL = ?, Website = ?, Img = ?, "
                + "CategoryID = ?, Status = ?, CompanyAddress = ?, CompanySize = ?, "
                + "ContactPerson = ?, CompanyBenefits = ?, CompanyVideoURL = ?, "
                + "Taxcode = ?, RegistrationCert = ? WHERE RecruiterID = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, recruiter.getPhone());
            ps.setString(2, recruiter.getCompanyName());
            ps.setString(3, recruiter.getCompanyDescription());
            ps.setString(4, recruiter.getCompanyLogoURL());
            ps.setString(5, recruiter.getWebsite());
            ps.setString(6, recruiter.getImg());
            ps.setInt(7, recruiter.getCategoryID());
            ps.setString(8, recruiter.getStatus());
            ps.setString(9, recruiter.getCompanyAddress());
            ps.setString(10, recruiter.getCompanySize());
            ps.setString(11, recruiter.getContactPerson());
            ps.setString(12, recruiter.getCompanyBenefits());
            ps.setString(13, recruiter.getCompanyVideoURL());
            ps.setString(14, recruiter.getTaxcode());
            ps.setString(15, recruiter.getRegistrationCert());
            ps.setInt(16, recruiter.getRecruiterID());

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
            ps.setString(1, MD5Util.getMD5Hash(newPassword));
            ps.setInt(2, recruiterId);
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
            return false;
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
        recruiter.setCompanyName(rs.getString("CompanyName"));
        recruiter.setCompanyDescription(rs.getString("CompanyDescription"));
        recruiter.setCompanyLogoURL(rs.getString("CompanyLogoURL"));
        recruiter.setWebsite(rs.getString("Website"));
        recruiter.setImg(rs.getString("Img"));
        recruiter.setCategoryID(rs.getInt("CategoryID"));
        recruiter.setStatus(rs.getString("Status"));
        recruiter.setCompanyAddress(rs.getString("CompanyAddress"));
        recruiter.setCompanySize(rs.getString("CompanySize"));
        recruiter.setContactPerson(rs.getString("ContactPerson"));
        recruiter.setCompanyBenefits(rs.getString("CompanyBenefits"));
        recruiter.setCompanyVideoURL(rs.getString("CompanyVideoURL"));
        recruiter.setTaxcode(rs.getString("Taxcode"));
        recruiter.setRegistrationCert(rs.getString("RegistrationCert"));

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

    //=============================
    // DELETE
    //=============================

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
            ps.setInt(1, recruiterId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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
                        rs.getString("CompanyVideoURL"),
                        rs.getString("Taxcode"),
                        rs.getString("RegistrationCert")
                );
            }
        }

        return recruiter;
    }

    public Recruiter login(String email, String password) {
        String sql = "SELECT * FROM Recruiter WHERE Email = ? AND Password = ? AND Status = 'Active'";

        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, MD5Util.getMD5Hash(password));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                recruiter = new Recruiter(
                        rs.getInt("RecruiterID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("Phone"),
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
                        rs.getString("CompanyVideoURL"),
                        rs.getString("Taxcode"),
                        rs.getString("RegistrationCert")
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
        String sql = "UPDATE Recruiter SET CompanyName = ?, Phone = ?, CompanyAddress = ?, "
                + "CompanySize = ?, ContactPerson = ?, CompanyBenefits = ?, "
                + "CompanyDescription = ?, CompanyVideoURL = ?, Website = ?, "
                + "CompanyLogoURL = ?, Img = ? WHERE RecruiterID = ?";

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
            try {
                if (checkEmailInTable("Admin", email)) {
                    return true;
                }
            } catch (SQLException e) {
                // Admin table might not exist, continue
            }

            return false;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
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
            String companyName, String industry, String address, String status,
            String taxcode, String registrationCert, int categoryId) {
        // Try with CategoryID first
        String sql = "INSERT INTO Recruiter (Email, Password, Phone, CompanyName, CompanyAddress, Status, ContactPerson, CategoryID, Taxcode, RegistrationCert) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = c.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, phone);
            ps.setString(4, companyName);
            ps.setString(5, address);
            ps.setString(6, status);
            ps.setString(7, fullName);
            ps.setInt(8, categoryId); // Use provided categoryId
            ps.setString(9, taxcode);
            ps.setString(10, registrationCert);

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
                    recruiter.setCategoryID(categoryId);
                    recruiter.setTaxcode(taxcode);
                    recruiter.setRegistrationCert(registrationCert);
                    return recruiter;
                }
            }
        } catch (SQLException e) {
            // If CategoryID fails, try without it
            try {
                String sqlWithoutCategory = "INSERT INTO Recruiter (Email, Password, Phone, CompanyName, CompanyAddress, Status, ContactPerson, CategoryID, Taxcode, RegistrationCert) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement ps2 = c.prepareStatement(sqlWithoutCategory, PreparedStatement.RETURN_GENERATED_KEYS);
                ps2.setString(1, email);
                ps2.setString(2, password);
                ps2.setString(3, phone);
                ps2.setString(4, companyName);
                ps2.setString(5, address);
                ps2.setString(6, status);
                ps2.setString(7, fullName);
                ps2.setInt(8, categoryId);
                ps2.setString(9, taxcode);
                ps2.setString(10, registrationCert);

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
                        recruiter.setCategoryID(categoryId);
                        recruiter.setTaxcode(taxcode);
                        recruiter.setRegistrationCert(registrationCert);
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
            return true; // chặn đăng ký khi có lỗi
        }
    }

    public boolean updateCompanyInfo(int recruiterId, String companyName, String phone,
            String companyAddress, String companySize, String contactPerson,
            String companyBenefits, String companyDescription,
            String companyVideoURL, String website, String logoPath,
            String companyImagesPath) {
        String sql = "UPDATE Recruiter SET CompanyName = ?, Phone = ?, CompanyAddress = ?, "
                + "CompanySize = ?, ContactPerson = ?, CompanyBenefits = ?, "
                + "CompanyDescription = ?, CompanyVideoURL = ?, Website = ?, "
                + "CompanyLogoURL = ?, Img = ? WHERE RecruiterID = ?";

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
        }
        return 0;
    }

    public boolean isPhoneExists(String phone) {
        try {

            // Check Recruiter table
            if (checkPhoneInTable("Recruiter", phone)) {
                return true;
            }

            // Check Admin table (with error handling)
            try {
                if (checkPhoneInTable("Admin", phone)) {
                    return true;
                }
            } catch (SQLException e) {
                // Admin table check failed - continue
            }

            return false;
        } catch (SQLException e) {
            System.err.println("Phone exists check error:");
            e.printStackTrace();
            return true; // Return true to be safe (prevent registration if error)
        }
    }

    private boolean checkPhoneInTable(String tableName, String phone) throws SQLException {
        if (c == null) {
            System.err.println("Database connection is null in checkPhoneInTable");
            throw new SQLException("Database connection is null");
        }

        String sql = "SELECT COUNT(*) FROM " + tableName + " WHERE Phone = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, phone);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    return count > 0;
                }
                return false;
            }
        }
    }
    //MINH
}
