package dal;

import model.Skill;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SkillDAO extends DBContext {

    /**
     * Retrieves all skills from the Skills table.
     * @return a List of Skill objects, or an empty list if no skills are found.
     */
    public List<Skill> getAllSkills() {
        List<Skill> skills = new ArrayList<>();
        String sql = "SELECT SkillID, SkillName FROM Skills ORDER BY SkillName";

        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Skill skill = new Skill();
                skill.setSkillID(rs.getInt("SkillID"));
                skill.setSkillName(rs.getString("SkillName"));
                skills.add(skill);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return skills;
    }

    /**
     * Retrieves a single skill by its ID.
     * @param skillId The ID of the skill to retrieve.
     * @return The Skill object, or null if not found.
     */
    public Skill getSkillById(int skillId) {
        String sql = "SELECT SkillID, SkillName FROM Skills WHERE SkillID = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, skillId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Skill skill = new Skill();
                skill.setSkillID(rs.getInt("SkillID"));
                skill.setSkillName(rs.getString("SkillName"));
                return skill;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Adds a new skill to the Skills table.
     * @param skill The Skill object to add.
     * @return true if the skill was added successfully, false otherwise.
     */
    public boolean addSkill(Skill skill) {
        String sql = "INSERT INTO Skills (SkillName) VALUES (?)";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, skill.getSkillName());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates an existing skill in the Skills table.
     * @param skill The Skill object with the updated information.
     * @return true if the skill was updated successfully, false otherwise.
     */
    public boolean updateSkill(Skill skill) {
        String sql = "UPDATE Skills SET SkillName = ? WHERE SkillID = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, skill.getSkillName());
            ps.setInt(2, skill.getSkillID());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deletes a skill from the Skills table by its ID.
     * @param skillId The ID of the skill to delete.
     * @return true if the skill was deleted successfully, false otherwise.
     */
    public boolean deleteSkill(int skillId) {
        String sql = "DELETE FROM Skills WHERE SkillID = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, skillId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}