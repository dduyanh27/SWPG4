package dal;

import model.Job;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class JobDAO extends DBContext {
    
    // Thêm job mới và trả về jobID
    public int addJob(Job job) {
        String sql = "INSERT INTO Jobs (RecruiterID, JobTitle, Description, Requirements, " +
                    "JobLevelID, LocationID, SalaryRange, PostingDate, ExpirationDate, CategoryID, " +
                    "AgeRequirement, Status, JobTypeID, HiringCount, ViewCount, IsUrgent, " +
                    "IsPriority, PriorityExpiryDate, ContactPerson, ApplicationEmail, " +
                    "MinExperience, Nationality, Gender, MaritalStatus, " +
                    "AgeMin, AgeMax, JobCode, CertificatesID) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, job.getRecruiterID());
            ps.setString(paramIndex++, job.getJobTitle());
            ps.setString(paramIndex++, job.getDescription());
            ps.setString(paramIndex++, job.getRequirements());
            ps.setInt(paramIndex++, job.getJobLevelID());
            ps.setInt(paramIndex++, job.getLocationID());
            ps.setString(paramIndex++, job.getSalaryRange());
            
            // PostingDate - set current time if null
            if (job.getPostingDate() != null) {
                ps.setTimestamp(paramIndex++, Timestamp.valueOf(job.getPostingDate()));
            } else {
                ps.setTimestamp(paramIndex++, Timestamp.valueOf(LocalDateTime.now()));
            }
            
            ps.setTimestamp(paramIndex++, job.getExpirationDate() != null ? 
                Timestamp.valueOf(job.getExpirationDate()) : null);
            ps.setInt(paramIndex++, job.getCategoryID());
            ps.setInt(paramIndex++, job.getAgeRequirement());
            ps.setString(paramIndex++, job.getStatus());
            ps.setInt(paramIndex++, job.getJobTypeID());
            ps.setInt(paramIndex++, job.getHiringCount());
            ps.setInt(paramIndex++, job.getViewCount());
            ps.setBoolean(paramIndex++, job.isIsUrgent());
            ps.setBoolean(paramIndex++, job.isIsPriority());
            
            ps.setTimestamp(paramIndex++, job.getPriorityExpiryDate() != null ? 
                Timestamp.valueOf(job.getPriorityExpiryDate()) : null);
            
            ps.setString(paramIndex++, job.getContactPerson());
            ps.setString(paramIndex++, job.getApplicationEmail());
            
            if (job.getMinExperience() != null) {
                ps.setInt(paramIndex++, job.getMinExperience());
            } else {
                ps.setNull(paramIndex++, java.sql.Types.INTEGER);
            }
            
            ps.setString(paramIndex++, job.getNationality());
            ps.setString(paramIndex++, job.getGender());
            ps.setString(paramIndex++, job.getMaritalStatus());
            
            if (job.getAgeMin() != null) {
                ps.setInt(paramIndex++, job.getAgeMin());
            } else {
                ps.setNull(paramIndex++, java.sql.Types.INTEGER);
            }
            
            if (job.getAgeMax() != null) {
                ps.setInt(paramIndex++, job.getAgeMax());
            } else {
                ps.setNull(paramIndex++, java.sql.Types.INTEGER);
            }
            
            ps.setString(paramIndex++, job.getJobCode());
            
            if (job.getCertificatesID() != null) {
                ps.setInt(paramIndex++, job.getCertificatesID());
            } else {
                ps.setNull(paramIndex++, java.sql.Types.INTEGER);
            }
            
            System.out.println("DEBUG JobDAO: Executing INSERT statement...");
            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG JobDAO: Rows affected: " + rowsAffected);
            if (rowsAffected > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int jobID = generatedKeys.getInt(1);
                    System.out.println("DEBUG JobDAO: Generated JobID: " + jobID);
                    return jobID;
                }
            }
            System.out.println("DEBUG JobDAO: Failed to get generated keys");
            return -1;
        } catch (SQLException e) {
            System.out.println("DEBUG JobDAO: SQL Exception occurred!");
            System.out.println("DEBUG JobDAO: Error Code: " + e.getErrorCode());
            System.out.println("DEBUG JobDAO: SQL State: " + e.getSQLState());
            System.out.println("DEBUG JobDAO: Message: " + e.getMessage());
            e.printStackTrace();
            return -1;
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
    
    // Lấy tất cả jobs có status = 'Active' của một recruiter
    public List<Job> getActiveJobsByRecruiterId(int recruiterId) {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT * FROM Jobs WHERE RecruiterID = ? AND Status = 'Active' ORDER BY PostingDate DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            
            System.out.println("DEBUG JobDAO: Executing query for recruiterID: " + recruiterId);
            System.out.println("DEBUG JobDAO: SQL: " + sql);
            
            while (rs.next()) {
                Job job = mapResultSetToJob(rs);
                jobs.add(job);
                System.out.println("DEBUG JobDAO: Found Active job - ID: " + job.getJobID() + 
                                 ", Title: " + job.getJobTitle() + 
                                 ", Status: '" + job.getStatus() + "'");
            }
            
            System.out.println("DEBUG JobDAO: Total found: " + jobs.size() + " Active jobs for recruiterID: " + recruiterId);
        } catch (SQLException e) {
            System.out.println("DEBUG JobDAO: Error getting active jobs: " + e.getMessage());
            System.out.println("DEBUG JobDAO: SQL State: " + e.getSQLState());
            System.out.println("DEBUG JobDAO: Error Code: " + e.getErrorCode());
            e.printStackTrace();
        }
        return jobs;
    }
    
    // Lấy tất cả jobs có status = 'Published' của một recruiter
    public List<Job> getPublishedJobsByRecruiterId(int recruiterId) {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT * FROM Jobs WHERE RecruiterID = ? AND Status = 'Published' ORDER BY PostingDate DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            
            System.out.println("DEBUG JobDAO: Executing query for recruiterID: " + recruiterId);
            System.out.println("DEBUG JobDAO: SQL: " + sql);
            
            while (rs.next()) {
                Job job = mapResultSetToJob(rs);
                jobs.add(job);
                System.out.println("DEBUG JobDAO: Found Published job - ID: " + job.getJobID() + 
                                 ", Title: " + job.getJobTitle() + 
                                 ", Status: '" + job.getStatus() + "'");
            }
            
            System.out.println("DEBUG JobDAO: Total found: " + jobs.size() + " Published jobs for recruiterID: " + recruiterId);
        } catch (SQLException e) {
            System.out.println("DEBUG JobDAO: Error getting published jobs: " + e.getMessage());
            System.out.println("DEBUG JobDAO: SQL State: " + e.getSQLState());
            System.out.println("DEBUG JobDAO: Error Code: " + e.getErrorCode());
            e.printStackTrace();
        }
        return jobs;
    }
    
    // Lấy jobs: status = 'Active' và chưa hết hạn theo recruiter
    public List<Job> getActiveNotExpiredByRecruiterId(int recruiterId) {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT * FROM Jobs WHERE RecruiterID = ? "
                + "AND (LOWER(Status) = 'active' OR LOWER(Status) = 'published') "
                + "AND (ExpirationDate IS NULL OR ExpirationDate > GETDATE()) "
                + "ORDER BY PostingDate DESC";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            System.out.println("[JobDAO] getActiveNotExpiredByRecruiterId recruiterId=" + recruiterId);
            System.out.println("[JobDAO] SQL=" + sql);
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                jobs.add(mapResultSetToJob(rs));
            }
            System.out.println("[JobDAO] activeNotExpired size=" + jobs.size());
        } catch (SQLException e) {
            System.out.println("[JobDAO] ERROR getActiveNotExpiredByRecruiterId: " + e.getMessage());
            e.printStackTrace();
        }
        return jobs;
    }

    // Lấy jobs: status = 'Active' nhưng đã hết hạn theo recruiter
    public List<Job> getExpiredActiveByRecruiterId(int recruiterId) {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT * FROM Jobs WHERE RecruiterID = ? "
                + "AND (LOWER(Status) = 'active' OR LOWER(Status) = 'published') "
                + "AND ExpirationDate IS NOT NULL AND ExpirationDate <= GETDATE() "
                + "ORDER BY ExpirationDate DESC";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            System.out.println("[JobDAO] getExpiredActiveByRecruiterId recruiterId=" + recruiterId);
            System.out.println("[JobDAO] SQL=" + sql);
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                jobs.add(mapResultSetToJob(rs));
            }
            System.out.println("[JobDAO] expiredActive size=" + jobs.size());
        } catch (SQLException e) {
            System.out.println("[JobDAO] ERROR getExpiredActiveByRecruiterId: " + e.getMessage());
            e.printStackTrace();
        }
        return jobs;
    }

    // Lấy jobs nháp theo recruiter (status = 'Draft' hoặc 'Draw')
    public List<Job> getDraftJobsByRecruiterId(int recruiterId) {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT * FROM Jobs WHERE RecruiterID = ? "
                + "AND LOWER(Status) IN ('draft','draw') "
                + "ORDER BY PostingDate DESC";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            System.out.println("[JobDAO] getDraftJobsByRecruiterId recruiterId=" + recruiterId);
            System.out.println("[JobDAO] SQL=" + sql);
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                jobs.add(mapResultSetToJob(rs));
            }
            System.out.println("[JobDAO] draft size=" + jobs.size());
        } catch (SQLException e) {
            System.out.println("[JobDAO] ERROR getDraftJobsByRecruiterId: " + e.getMessage());
            e.printStackTrace();
        }
        return jobs;
    }

    // Lấy jobs chờ duyệt theo recruiter (status = 'Pending')
    public List<Job> getPendingJobsByRecruiterId(int recruiterId) {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT * FROM Jobs WHERE RecruiterID = ? AND LOWER(Status) = 'pending' ORDER BY PostingDate DESC";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            System.out.println("[JobDAO] getPendingJobsByRecruiterId recruiterId=" + recruiterId);
            System.out.println("[JobDAO] SQL=" + sql);
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                jobs.add(mapResultSetToJob(rs));
            }
            System.out.println("[JobDAO] pending size=" + jobs.size());
        } catch (SQLException e) {
            System.out.println("[JobDAO] ERROR getPendingJobsByRecruiterId: " + e.getMessage());
            e.printStackTrace();
        }
        return jobs;
    }
    
    // Cập nhật status của job
    public boolean updateJobStatus(int jobID, String status) {
        String sql = "UPDATE Jobs SET Status = ? WHERE JobID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, jobID);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG JobDAO: Updated job status to '" + status + "' for JobID: " + jobID + ", rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("DEBUG JobDAO: Error updating job status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Cập nhật job
    public boolean updateJob(Job job) {
        String sql = "UPDATE Jobs SET JobTitle = ?, Description = ?, Requirements = ?, " +
                    "JobLevelID = ?, LocationID = ?, SalaryRange = ?, ExpirationDate = ?, " +
                    "CategoryID = ?, AgeRequirement = ?, Status = ?, JobTypeID = ?, " +
                    "HiringCount = ?, ContactPerson = ?, ApplicationEmail = ?, " +
                    "MinExperience = ?, Nationality = ?, Gender = ?, MaritalStatus = ?, " +
                    "AgeMin = ?, AgeMax = ?, CertificatesID = ? WHERE JobID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            int paramIndex = 1;
            ps.setString(paramIndex++, job.getJobTitle());
            ps.setString(paramIndex++, job.getDescription());
            ps.setString(paramIndex++, job.getRequirements());
            ps.setInt(paramIndex++, job.getJobLevelID());
            ps.setInt(paramIndex++, job.getLocationID());
            ps.setString(paramIndex++, job.getSalaryRange());
            ps.setTimestamp(paramIndex++, job.getExpirationDate() != null ? 
                Timestamp.valueOf(job.getExpirationDate()) : null);
            ps.setInt(paramIndex++, job.getCategoryID());
            ps.setInt(paramIndex++, job.getAgeRequirement());
            ps.setString(paramIndex++, job.getStatus());
            ps.setInt(paramIndex++, job.getJobTypeID());
            ps.setInt(paramIndex++, job.getHiringCount());
            ps.setString(paramIndex++, job.getContactPerson());
            ps.setString(paramIndex++, job.getApplicationEmail());
            
            if (job.getMinExperience() != null) {
                ps.setInt(paramIndex++, job.getMinExperience());
            } else {
                ps.setNull(paramIndex++, java.sql.Types.INTEGER);
            }
            
            ps.setString(paramIndex++, job.getNationality());
            ps.setString(paramIndex++, job.getGender());
            ps.setString(paramIndex++, job.getMaritalStatus());
            
            if (job.getAgeMin() != null) {
                ps.setInt(paramIndex++, job.getAgeMin());
            } else {
                ps.setNull(paramIndex++, java.sql.Types.INTEGER);
            }
            
            if (job.getAgeMax() != null) {
                ps.setInt(paramIndex++, job.getAgeMax());
            } else {
                ps.setNull(paramIndex++, java.sql.Types.INTEGER);
            }
            
            if (job.getCertificatesID() != null) {
                ps.setInt(paramIndex++, job.getCertificatesID());
            } else {
                ps.setNull(paramIndex++, java.sql.Types.INTEGER);
            }
            
            ps.setInt(paramIndex++, job.getJobID());
            
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
        
        // Map additional fields
        job.setViewCount(rs.getInt("ViewCount"));
        job.setIsUrgent(rs.getBoolean("IsUrgent"));
        job.setIsPriority(rs.getBoolean("IsPriority"));
        
        Timestamp priorityExpiryDate = rs.getTimestamp("PriorityExpiryDate");
        if (priorityExpiryDate != null) {
            job.setPriorityExpiryDate(priorityExpiryDate.toLocalDateTime());
        }
        
        job.setContactPerson(rs.getString("ContactPerson"));
        job.setApplicationEmail(rs.getString("ApplicationEmail"));
        
        int minExp = rs.getInt("MinExperience");
        if (!rs.wasNull()) {
            job.setMinExperience(minExp);
        }
        
        job.setNationality(rs.getString("Nationality"));
        job.setGender(rs.getString("Gender"));
        job.setMaritalStatus(rs.getString("MaritalStatus"));
        
        int ageMin = rs.getInt("AgeMin");
        if (!rs.wasNull()) {
            job.setAgeMin(ageMin);
        }
        
        int ageMax = rs.getInt("AgeMax");
        if (!rs.wasNull()) {
            job.setAgeMax(ageMax);
        }
        
        job.setJobCode(rs.getString("JobCode"));
        
        int certificatesID = rs.getInt("CertificatesID");
        if (!rs.wasNull()) {
            job.setCertificatesID(certificatesID);
        }
        
        return job;
    }
}
