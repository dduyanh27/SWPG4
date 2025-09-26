package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Recruiter;

public class RecruiterDAO extends DBContext {
    
    public Recruiter getRecruiterById(int id) {
        String sql = "SELECT RecruiterID, CompanyName FROM Recruiter WHERE RecruiterID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Recruiter(rs.getInt("RecruiterID"), rs.getString("CompanyName"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
