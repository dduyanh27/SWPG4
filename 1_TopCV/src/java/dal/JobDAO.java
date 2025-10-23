package dal;

import model.Job;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class JobDAO extends DBContext {
    
    // Thêm job mới
    public boolean addJob(Job job) {
        String sql = "INSERT INTO Jobs (RecruiterID, JobTitle, Description, Requirements, " +
                    "JobLevelID, LocationID, SalaryRange, ExpirationDate, CategoryID, " +
                    "AgeRequirement, Status, JobTypeID, HiringCount) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, job.getRecruiterID());
            ps.setString(2, job.getJobTitle());
            ps.setString(3, job.getDescription());
            ps.setString(4, job.getRequirements());
            ps.setInt(5, job.getJobLevelID());
            ps.setInt(6, job.getLocationID());
            ps.setString(7, job.getSalaryRange());
            ps.setTimestamp(8, job.getExpirationDate() != null ? 
                Timestamp.valueOf(job.getExpirationDate()) : null);
            ps.setInt(9, job.getCategoryID());
            ps.setInt(10, job.getAgeRequirement());
            ps.setString(11, job.getStatus());
            ps.setInt(12, job.getJobTypeID());
            ps.setInt(13, job.getHiringCount());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy job theo ID
    public Job getJobById(int jobId) {
        String sql = "SELECT * FROM Jobs WHERE JobID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToJob(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy tất cả jobs của một recruiter
    public List<Job> getJobsByRecruiterId(int recruiterId) {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT * FROM Jobs WHERE RecruiterID = ? ORDER BY PostingDate DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                jobs.add(mapResultSetToJob(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jobs;
    }
    
    // Lấy tất cả jobs đang active
    public List<Job> getActiveJobs() {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT * FROM Jobs WHERE Status = 'Published' AND ExpirationDate > GETDATE() ORDER BY PostingDate DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                jobs.add(mapResultSetToJob(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jobs;
    }
    
    // Cập nhật job
    public boolean updateJob(Job job) {
        String sql = "UPDATE Jobs SET JobTitle = ?, Description = ?, Requirements = ?, " +
                    "JobLevelID = ?, LocationID = ?, SalaryRange = ?, ExpirationDate = ?, " +
                    "CategoryID = ?, AgeRequirement = ?, Status = ?, JobTypeID = ?, " +
                    "HiringCount = ? WHERE JobID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, job.getJobTitle());
            ps.setString(2, job.getDescription());
            ps.setString(3, job.getRequirements());
            ps.setInt(4, job.getJobLevelID());
            ps.setInt(5, job.getLocationID());
            ps.setString(6, job.getSalaryRange());
            ps.setTimestamp(7, job.getExpirationDate() != null ? 
                Timestamp.valueOf(job.getExpirationDate()) : null);
            ps.setInt(8, job.getCategoryID());
            ps.setInt(9, job.getAgeRequirement());
            ps.setString(10, job.getStatus());
            ps.setInt(11, job.getJobTypeID());
            ps.setInt(12, job.getHiringCount());
            ps.setInt(13, job.getJobID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xóa job
    public boolean deleteJob(int jobId) {
        String sql = "DELETE FROM Jobs WHERE JobID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Tìm kiếm jobs
    public List<Job> searchJobs(String keyword, int categoryId, int locationId, int jobLevelId) {
        List<Job> jobs = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Jobs WHERE Status = 'Published' AND ExpirationDate > GETDATE()");
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (JobTitle LIKE ? OR Description LIKE ?)");
        }
        if (categoryId > 0) {
            sql.append(" AND CategoryID = ?");
        }
        if (locationId > 0) {
            sql.append(" AND LocationID = ?");
        }
        if (jobLevelId > 0) {
            sql.append(" AND JobLevelID = ?");
        }
        
        sql.append(" ORDER BY PostingDate DESC");
        
        try (PreparedStatement ps = c.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            if (categoryId > 0) {
                ps.setInt(paramIndex++, categoryId);
            }
            if (locationId > 0) {
                ps.setInt(paramIndex++, locationId);
            }
            if (jobLevelId > 0) {
                ps.setInt(paramIndex++, jobLevelId);
            }
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                jobs.add(mapResultSetToJob(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jobs;
    }
    
    // Helper method để map ResultSet thành Job object
    private Job mapResultSetToJob(ResultSet rs) throws SQLException {
        Job job = new Job();
        job.setJobID(rs.getInt("JobID"));
        job.setRecruiterID(rs.getInt("RecruiterID"));
        job.setJobTitle(rs.getString("JobTitle"));
        job.setDescription(rs.getString("Description"));
        job.setRequirements(rs.getString("Requirements"));
        job.setJobLevelID(rs.getInt("JobLevelID"));
        job.setLocationID(rs.getInt("LocationID"));
        job.setSalaryRange(rs.getString("SalaryRange"));
        
        Timestamp postingDate = rs.getTimestamp("PostingDate");
        if (postingDate != null) {
            job.setPostingDate(postingDate.toLocalDateTime());
        }
        
        Timestamp expirationDate = rs.getTimestamp("ExpirationDate");
        if (expirationDate != null) {
            job.setExpirationDate(expirationDate.toLocalDateTime());
        }
        
        job.setCategoryID(rs.getInt("CategoryID"));
        job.setAgeRequirement(rs.getInt("AgeRequirement"));
        job.setStatus(rs.getString("Status"));
        job.setJobTypeID(rs.getInt("JobTypeID"));
        job.setHiringCount(rs.getInt("HiringCount"));
        
        return job;
    }
}
