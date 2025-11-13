package dal;

import model.Skill;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SkillDAO extends DBContext {
    
    // Lấy skill theo tên (case-insensitive)
    public Skill getSkillByName(String skillName) {
        String sql = "SELECT * FROM Skills WHERE LOWER(SkillName) = LOWER(?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, skillName.trim());
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
    
    // Thêm skill mới và trả về SkillID
    public int addSkill(String skillName) {
        // Kiểm tra xem skill đã tồn tại chưa
        Skill existingSkill = getSkillByName(skillName);
        if (existingSkill != null) {
            return existingSkill.getSkillID();
        }
        
        // Nếu chưa tồn tại, thêm mới
        String sql = "INSERT INTO Skills (SkillName) VALUES (?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, skillName.trim());
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    // Lấy skill theo ID
    public Skill getSkillById(int skillId) {
        String sql = "SELECT * FROM Skills WHERE SkillID = ?";
        
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
    
    // Lấy tất cả skills
    public List<Skill> getAllSkills() {
        List<Skill> skills = new ArrayList<>();
        String sql = "SELECT * FROM Skills ORDER BY SkillName";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            
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
}

