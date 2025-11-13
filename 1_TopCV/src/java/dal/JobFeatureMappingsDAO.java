package dal;

import model.JobFeatureMappings;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class JobFeatureMappingsDAO extends DBContext {
    
    // Thêm job feature mapping mới
    // Lưu ý: JobFeatureMapID là auto-increment, không cần insert
    public boolean addJobFeatureMapping(JobFeatureMappings mapping) {
        String sql = "INSERT INTO JobFeatureMappings (JobID, RecruiterPackageID, FeatureType, AppliedDate, ExpireDate) " +
                    "VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, mapping.getJobID());
            ps.setInt(2, mapping.getRecruiterPackageID());
            ps.setString(3, mapping.getFeatureType());
            
            // AppliedDate không được null
            if (mapping.getAppliedDate() == null) {
                System.out.println("DEBUG JobFeatureMappingsDAO: AppliedDate is null, setting to current time");
                ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            } else {
                ps.setTimestamp(4, Timestamp.valueOf(mapping.getAppliedDate()));
            }
            
            // ExpireDate có thể null
            if (mapping.getExpireDate() != null) {
                ps.setTimestamp(5, Timestamp.valueOf(mapping.getExpireDate()));
            } else {
                ps.setNull(5, java.sql.Types.TIMESTAMP);
            }
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                // Lấy generated JobFeatureMapID nếu cần
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int generatedID = generatedKeys.getInt(1);
                    System.out.println("DEBUG JobFeatureMappingsDAO: Inserted mapping with ID: " + generatedID);
                    mapping.setJobFeatureMapID(generatedID);
                }
            }
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("DEBUG JobFeatureMappingsDAO: Error adding mapping: " + e.getMessage());
            System.out.println("DEBUG JobFeatureMappingsDAO: SQL State: " + e.getSQLState());
            System.out.println("DEBUG JobFeatureMappingsDAO: Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy tất cả mappings của một job
    public List<JobFeatureMappings> getMappingsByJobID(int jobID) {
        List<JobFeatureMappings> mappings = new ArrayList<>();
        String sql = "SELECT JobFeatureMapID, JobID, RecruiterPackageID, FeatureType, AppliedDate, ExpireDate " +
                    "FROM JobFeatureMappings WHERE JobID = ? ORDER BY AppliedDate DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                JobFeatureMappings mapping = new JobFeatureMappings();
                
                // Map tất cả các cột theo đúng thứ tự trong database
                mapping.setJobFeatureMapID(rs.getInt("JobFeatureMapID"));
                mapping.setJobID(rs.getInt("JobID"));
                mapping.setRecruiterPackageID(rs.getInt("RecruiterPackageID"));
                mapping.setFeatureType(rs.getString("FeatureType"));
                
                // AppliedDate - có thể null nhưng thường không null
                Timestamp appliedDate = rs.getTimestamp("AppliedDate");
                if (!rs.wasNull() && appliedDate != null) {
                    mapping.setAppliedDate(appliedDate.toLocalDateTime());
                }
                
                // ExpireDate - có thể null
                Timestamp expireDate = rs.getTimestamp("ExpireDate");
                if (!rs.wasNull() && expireDate != null) {
                    mapping.setExpireDate(expireDate.toLocalDateTime());
                }
                
                mappings.add(mapping);
            }
        } catch (SQLException e) {
            System.out.println("DEBUG JobFeatureMappingsDAO: Error getting mappings: " + e.getMessage());
            e.printStackTrace();
        }
        return mappings;
    }
    
    // Lấy mapping theo ID
    public JobFeatureMappings getMappingByID(int jobFeatureMapID) {
        String sql = "SELECT JobFeatureMapID, JobID, RecruiterPackageID, FeatureType, AppliedDate, ExpireDate " +
                    "FROM JobFeatureMappings WHERE JobFeatureMapID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobFeatureMapID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                JobFeatureMappings mapping = new JobFeatureMappings();
                mapping.setJobFeatureMapID(rs.getInt("JobFeatureMapID"));
                mapping.setJobID(rs.getInt("JobID"));
                mapping.setRecruiterPackageID(rs.getInt("RecruiterPackageID"));
                mapping.setFeatureType(rs.getString("FeatureType"));
                
                Timestamp appliedDate = rs.getTimestamp("AppliedDate");
                if (!rs.wasNull() && appliedDate != null) {
                    mapping.setAppliedDate(appliedDate.toLocalDateTime());
                }
                
                Timestamp expireDate = rs.getTimestamp("ExpireDate");
                if (!rs.wasNull() && expireDate != null) {
                    mapping.setExpireDate(expireDate.toLocalDateTime());
                }
                
                return mapping;
            }
        } catch (SQLException e) {
            System.out.println("DEBUG JobFeatureMappingsDAO: Error getting mapping by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Get JobIDs by RecruiterPackageID (only for posting feature)
    public java.util.List<Integer> getJobIdsByRecruiterPackageId(int recruiterPackageID) {
        java.util.List<Integer> jobIds = new java.util.ArrayList<>();
        String sql = "SELECT DISTINCT JobID FROM JobFeatureMappings WHERE RecruiterPackageID = ? AND FeatureType = 'DANG_TUYEN'";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterPackageID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    jobIds.add(rs.getInt("JobID"));
                }
            }
        } catch (SQLException e) {
            System.out.println("DEBUG JobFeatureMappingsDAO: Error getJobIdsByRecruiterPackageId: " + e.getMessage());
            e.printStackTrace();
        }
        return jobIds;
    }
}

