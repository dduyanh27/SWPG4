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

    //=============================
    // READ
    //=============================

    public Recruiter getRecruiterById(int id) {
        String sql = "SELECT * FROM Recruiter WHERE RecruiterID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToRecruiter(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Recruiter getRecruiterByEmail(String email) {
        String sql = "SELECT * FROM Recruiter WHERE Email = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToRecruiter(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Recruiter> getAllRecruiters() {
        List<Recruiter> list = new ArrayList<>();
        String sql = "SELECT * FROM Recruiter ORDER BY CompanyName";
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSetToRecruiter(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Recruiter> searchRecruitersByName(String companyName) {
        List<Recruiter> list = new ArrayList<>();
        String sql = "SELECT * FROM Recruiter WHERE CompanyName LIKE ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, "%" + companyName + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToRecruiter(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //=============================
    // UPDATE
    //=============================

    public boolean updateCompanyInfo(Recruiter r) {
        String sql = """
            UPDATE Recruiter
            SET Phone=?, CompanyName=?, CompanyDescription=?, CompanyLogoURL=?, Website=?, Img=?, CategoryID=?,
                CompanyAddress=?, CompanySize=?, ContactPerson=?, CompanyBenefits=?, CompanyVideoURL=?,
                Taxcode=?, RegistrationCert=?
            WHERE RecruiterID=?
        """;
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, r.getPhone());
            ps.setString(2, r.getCompanyName());
            ps.setString(3, r.getCompanyDescription());
            ps.setString(4, r.getCompanyLogoURL());
            ps.setString(5, r.getWebsite());
            ps.setString(6, r.getImg());
            ps.setInt(7, r.getCategoryID());
            ps.setString(8, r.getCompanyAddress());
            ps.setString(9, r.getCompanySize());
            ps.setString(10, r.getContactPerson());
            ps.setString(11, r.getCompanyBenefits());
            ps.setString(12, r.getCompanyVideoURL());
            ps.setString(13, r.getTaxcode());
            ps.setString(14, r.getRegistrationCert());
            ps.setInt(15, r.getRecruiterID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(int recruiterId, String newPassword) {
        String sql = "UPDATE Recruiter SET Password = ? WHERE RecruiterID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, MD5Util.getMD5Hash(newPassword));
            ps.setInt(2, recruiterId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatus(int recruiterId, String newStatus) {
        String sql = "UPDATE Recruiter SET Status = ? WHERE RecruiterID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, recruiterId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //=============================
    // DELETE
    //=============================

    public boolean deactivateRecruiter(int recruiterId) {
        return updateStatus(recruiterId, "Inactive");
    }

    public boolean deleteRecruiterPermanently(int recruiterId) {
        String sql = "DELETE FROM Recruiter WHERE RecruiterID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean isEmailExistsInAllTables(String email) {
    String[] tables = {"Admins", "Recruiters", "JobSeekers"};
    String queryTemplate = "SELECT COUNT(*) FROM %s WHERE Email = ?";
    
    try {
        for (String table : tables) {
            String query = String.format(queryTemplate, table);
            PreparedStatement ps = c.prepareStatement(query);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true; // Email đã tồn tại trong 1 trong các bảng
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false; // Không tồn tại trong bảng nào
}


    //=============================
    // AUTH & UTILITIES
    //=============================

    public Recruiter login(String email, String password) {
        String sql = "SELECT * FROM Recruiter WHERE Email = ? AND Password = ? AND Status = 'Active'";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, MD5Util.getMD5Hash(password));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToRecruiter(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Recruiter WHERE Email = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // chặn đăng ký khi có lỗi
        }
    }

    public int countRecruiters() {
        String sql = "SELECT COUNT(*) FROM Recruiter";
        try (Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
