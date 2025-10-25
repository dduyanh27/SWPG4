package dal;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import model.Admin;
import model.JobSeeker;
import model.Recruiter;
import util.MD5Util;

public class DAO extends DBContext {
    public void addAdmin(Admin admin) {
        String sql = "INSERT INTO Admins (Email, Password, FullName, Phone, Gender, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            st.setString(1, admin.getEmail());

            // 🔑 Hash mật khẩu trước khi lưu
            String hashedPassword = MD5Util.getMD5Hash(admin.getPassword());
            st.setString(2, hashedPassword);

            st.setString(3, admin.getFullName());
            st.setString(4, admin.getPhone());
            st.setString(5, admin.getGender());
            st.setString(6, admin.getStatus());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void addJobSeeker(JobSeeker js) {
        String sql = "INSERT INTO JobSeeker (Email, Password, FullName, Phone, Gender, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            st.setString(1, js.getEmail());

            // 🔑 Hash mật khẩu trước khi lưu
            String hashedPassword = MD5Util.getMD5Hash(js.getPassword());
            st.setString(2, hashedPassword);

            st.setString(3, js.getFullName());
            st.setString(4, js.getPhone());
            st.setString(5, js.getGender());
            st.setString(6, js.getStatus());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void addRecruiter(Recruiter re) {
        String sql = "INSERT INTO Recruiter (Email, Password, Phone, CompanyName, Gender, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            st.setString(1, re.getEmail());

            // 🔑 Hash mật khẩu trước khi lưu
            String hashedPassword = MD5Util.getMD5Hash(re.getPassword());
            st.setString(2, hashedPassword);

            st.setString(3, re.getPhone());
            st.setString(4, re.getCompanyName());
            st.setString(6, re.getStatus());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
