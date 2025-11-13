package dal;

import model.Skill;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SkillDAO extends DAO {
    
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
    /**
     * Lấy tất cả skills từ bảng Skills
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
            System.err.println("Error getting all skills: " + e.getMessage());
            e.printStackTrace();
        }
        return skills;
    }
    
    /**
     * Lấy skill theo ID
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
            System.err.println("Error getting skill by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy danh sách skills của một JobSeeker
     */
    public List<Skill> getSkillsByJobSeekerId(int jobSeekerId) {
        List<Skill> skills = new ArrayList<>();
        String sql = "SELECT s.SkillID, s.SkillName " +
                     "FROM Skills s " +
                     "INNER JOIN ProfileSkills ps ON s.SkillID = ps.SkillID " +
                     "WHERE ps.JobSeekerID = ? " +
                     "ORDER BY s.SkillName";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobSeekerId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Skill skill = new Skill();
                skill.setSkillID(rs.getInt("SkillID"));
                skill.setSkillName(rs.getString("SkillName"));
                skills.add(skill);
            }
        } catch (SQLException e) {
            System.err.println("Error getting skills for JobSeeker: " + e.getMessage());
            e.printStackTrace();
        }
        return skills;
    }
    
    /**
     * Thêm skill cho JobSeeker
     */
    public boolean addSkillToJobSeeker(int jobSeekerId, int skillId) {
        String sql = "INSERT INTO ProfileSkills (JobSeekerID, SkillID) VALUES (?, ?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobSeekerId);
            ps.setInt(2, skillId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            // Check if it's a duplicate key error
            if (e.getMessage().contains("duplicate key") || e.getMessage().contains("PRIMARY KEY")) {
                System.out.println("Skill already exists for this JobSeeker");
                return false;
            }
            System.err.println("Error adding skill to JobSeeker: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Xóa skill khỏi profile của JobSeeker
     */
    public boolean removeSkillFromJobSeeker(int jobSeekerId, int skillId) {
        String sql = "DELETE FROM ProfileSkills WHERE JobSeekerID = ? AND SkillID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobSeekerId);
            ps.setInt(2, skillId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error removing skill from JobSeeker: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Thêm skill mới vào bảng Skills (cho admin)
     */
    public int addNewSkill(String skillName) {
        String sql = "INSERT INTO Skills (SkillName) VALUES (?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, skillName);
            int result = ps.executeUpdate();
            
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding new skill: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
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
    /**
     * Kiểm tra xem JobSeeker đã có skill này chưa
     */
    public boolean hasSkill(int jobSeekerId, int skillId) {
        String sql = "SELECT COUNT(*) FROM ProfileSkills WHERE JobSeekerID = ? AND SkillID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobSeekerId);
            ps.setInt(2, skillId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking skill existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Tìm kiếm skills theo tên
     */
    public List<Skill> searchSkills(String keyword) {
        List<Skill> skills = new ArrayList<>();
        String sql = "SELECT SkillID, SkillName FROM Skills WHERE SkillName LIKE ? ORDER BY SkillName";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Skill skill = new Skill();
                skill.setSkillID(rs.getInt("SkillID"));
                skill.setSkillName(rs.getString("SkillName"));
                skills.add(skill);
            }
        } catch (SQLException e) {
            System.err.println("Error searching skills: " + e.getMessage());
            e.printStackTrace();
        }
        return skills;
    }
}
