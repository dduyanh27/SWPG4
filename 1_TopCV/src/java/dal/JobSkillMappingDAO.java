package dal;

import model.JobSkillMapping;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JobSkillMappingDAO extends DBContext {
    
    // Thêm mapping giữa Job và Skill
    public boolean addMapping(int jobID, int skillID) {
        // Kiểm tra xem mapping đã tồn tại chưa
        if (mappingExists(jobID, skillID)) {
            return true; // Đã tồn tại, không cần insert lại
        }
        
        String sql = "INSERT INTO JobSkillMapping (JobID, SkillID) VALUES (?, ?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobID);
            ps.setInt(2, skillID);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Kiểm tra mapping đã tồn tại chưa
    public boolean mappingExists(int jobID, int skillID) {
        String sql = "SELECT COUNT(*) FROM JobSkillMapping WHERE JobID = ? AND SkillID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobID);
            ps.setInt(2, skillID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy tất cả skills của một job
    public List<Integer> getSkillIDsByJobID(int jobID) {
        List<Integer> skillIDs = new ArrayList<>();
        String sql = "SELECT SkillID FROM JobSkillMapping WHERE JobID = ?";
        
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
    
    // Xóa mapping theo JobID
    public boolean deleteMappingsByJobID(int jobID) {
        String sql = "DELETE FROM JobSkillMapping WHERE JobID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Xóa một mapping cụ thể
    public boolean deleteMapping(int jobID, int skillID) {
        String sql = "DELETE FROM JobSkillMapping WHERE JobID = ? AND SkillID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobID);
            ps.setInt(2, skillID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

