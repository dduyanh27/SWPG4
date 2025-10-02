package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class JobSkillMappingDAO extends DBContext {

    
    public boolean addJobSkillMapping(int jobID, int skillID) {
        String sql = "INSERT INTO JobSkillMappings (JobID, SkillID) VALUES (?, ?)";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobID);
            ps.setInt(2, skillID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
           
            e.printStackTrace();
            return false;
        }
    }

   
    public List<Integer> getSkillIDsByJobID(int jobID) {
        List<Integer> skillIDs = new ArrayList<>();
        String sql = "SELECT SkillID FROM JobSkillMappings WHERE JobID = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                skillIDs.add(rs.getInt("SkillID"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return skillIDs;
    }

   
    public boolean deleteJobSkillMapping(int jobID, int skillID) {
        String sql = "DELETE FROM JobSkillMappings WHERE JobID = ? AND SkillID = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobID);
            ps.setInt(2, skillID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteJobSkillMappingByJobID(int jobID) {
        String sql = "DELETE FROM JobSkillMappings WHERE JobID = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobID);
            ps.executeUpdate();
           
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<model.Skill> getSkillsByJobID(int jobID) {
    List<model.Skill> skills = new ArrayList<>();
    SkillDAO skillDAO = new SkillDAO(); // Cần một instance của SkillDAO

    // Lấy danh sách ID của skills
    List<Integer> skillIDs = getSkillIDsByJobID(jobID);

    // Lấy từng đối tượng Skill dựa trên ID
    for (int skillID : skillIDs) {
        model.Skill skill = skillDAO.getSkillById(skillID);
        if (skill != null) {
            skills.add(skill);
        }
    }
    return skills;
}

}
