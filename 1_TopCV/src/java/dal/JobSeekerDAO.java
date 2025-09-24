package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.JobSeeker;

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
}
