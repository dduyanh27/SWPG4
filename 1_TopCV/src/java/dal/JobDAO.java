package dal;

import model.Job;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class JobDAO extends DBContext {
    
    // Thêm job mới
  public List<Job> getAllJobs() {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT JobID, RecruiterID, JobTitle, Description, Requirements, "
                + "JobLevelID, LocationID, SalaryRange, PostingDate, ExpirationDate, "
                + "CategoryID, AgeRequirement, Status, JobTypeID, CertificatesID, HiringCount "
                + "FROM Jobs";
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Timestamp postTs = rs.getTimestamp("PostingDate");
                LocalDateTime postingDate = postTs != null ? postTs.toLocalDateTime() : null;
                Timestamp expTs = rs.getTimestamp("ExpirationDate");
                LocalDateTime expirationDate = expTs != null ? expTs.toLocalDateTime() : null;

                Job job = new Job(
                        rs.getInt("JobID"),
                        rs.getInt("RecruiterID"),
                        rs.getString("JobTitle"),
                        rs.getString("Description"),
                        rs.getString("Requirements"),
                        rs.getInt("JobLevelID"),
                        rs.getInt("LocationID"),
                        rs.getString("SalaryRange"),
                        postingDate,
                        expirationDate,
                        rs.getInt("CategoryID"),
                        rs.getInt("AgeRequirement"),
                        rs.getString("Status"),      // <-- CHÚ Ý: status ở vị trí này (String)
                        rs.getInt("JobTypeID"),
                        rs.getInt("CertificatesID"),
                        rs.getInt("HiringCount")
                );
                list.add(job);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy job theo ID
    public Job getJobById(int id) {
        String sql = "SELECT * FROM Jobs WHERE JobID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Timestamp postTs = rs.getTimestamp("PostingDate");
                    LocalDateTime postingDate = postTs != null ? postTs.toLocalDateTime() : null;
                    Timestamp expTs = rs.getTimestamp("ExpirationDate");
                    LocalDateTime expirationDate = expTs != null ? expTs.toLocalDateTime() : null;

                    return new Job(
                            rs.getInt("JobID"),
                            rs.getInt("RecruiterID"),
                            rs.getString("JobTitle"),
                            rs.getString("Description"),
                            rs.getString("Requirements"),
                            rs.getInt("JobLevelID"),
                            rs.getInt("LocationID"),
                            rs.getString("SalaryRange"),
                            postingDate,
                            expirationDate,
                            rs.getInt("CategoryID"),
                            rs.getInt("AgeRequirement"),
                            rs.getString("Status"),
                            rs.getInt("JobTypeID"),
                            rs.getInt("CertificatesID"),
                            rs.getInt("HiringCount")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm job (trả về jobId tạo được, -1 nếu lỗi)
    public int addJob(Job job) {
        String sql = "INSERT INTO Jobs (RecruiterID, JobTitle, Description, Requirements, "
                + "JobLevelID, LocationID, SalaryRange, ExpirationDate, CategoryID, "
                + "AgeRequirement, JobTypeID, CertificatesID, HiringCount, Status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int newId = -1;
        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, job.getRecruiterID());
            ps.setString(2, job.getJobTitle());
            ps.setString(3, job.getDescription());
            ps.setString(4, job.getRequirements());
            ps.setInt(5, job.getJobLevelID());
            ps.setInt(6, job.getLocationID());
            ps.setString(7, job.getSalaryRange());
            // expirationDate có thể null — xử lý an toàn
            if (job.getExpirationDate() != null) {
                ps.setTimestamp(8, Timestamp.valueOf(job.getExpirationDate()));
            } else {
                ps.setNull(8, Types.TIMESTAMP);
            }
            ps.setInt(9, job.getCategoryID());
            ps.setInt(10, job.getAgeRequirement());
            ps.setInt(11, job.getJobTypeID());
            ps.setInt(12, job.getCertificatesID());
            ps.setInt(13, job.getHiringCount());
            ps.setString(14, "Draft");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet gk = ps.getGeneratedKeys()) {
                    if (gk.next()) newId = gk.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newId;
    }

    // Cập nhật job
    public boolean updateJob(Job job) {
        String sql = "UPDATE Jobs SET JobTitle=?, Description=?, Requirements=?, "
                + "JobLevelID=?, LocationID=?, SalaryRange=?, ExpirationDate=?, "
                + "CategoryID=?, AgeRequirement=?, JobTypeID=?, CertificatesID=?, "
                + "HiringCount=?, Status=? WHERE JobID=?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, job.getJobTitle());
            ps.setString(2, job.getDescription());
            ps.setString(3, job.getRequirements());
            ps.setInt(4, job.getJobLevelID());
            ps.setInt(5, job.getLocationID());
            ps.setString(6, job.getSalaryRange());
            if (job.getExpirationDate() != null) {
                ps.setTimestamp(7, Timestamp.valueOf(job.getExpirationDate()));
            } else {
                ps.setNull(7, Types.TIMESTAMP);
            }
            ps.setInt(8, job.getCategoryID());
            ps.setInt(9, job.getAgeRequirement());
            ps.setInt(10, job.getJobTypeID());
            ps.setInt(11, job.getCertificatesID());
            ps.setInt(12, job.getHiringCount());
            ps.setString(13, job.getStatus());
            ps.setInt(14, job.getJobID());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa job
    public boolean deleteJob(int id) {
        String sql = "DELETE FROM Jobs WHERE JobID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy jobs theo recruiter
    public List<Job> getJobsByRecruiterId(int recruiterId) {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT * FROM Jobs WHERE RecruiterID = ? ORDER BY PostingDate DESC";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Timestamp postTs = rs.getTimestamp("PostingDate");
                    LocalDateTime postingDate = postTs != null ? postTs.toLocalDateTime() : null;
                    Timestamp expTs = rs.getTimestamp("ExpirationDate");
                    LocalDateTime expirationDate = expTs != null ? expTs.toLocalDateTime() : null;

                    Job job = new Job(
                            rs.getInt("JobID"),
                            rs.getInt("RecruiterID"),
                            rs.getString("JobTitle"),
                            rs.getString("Description"),
                            rs.getString("Requirements"),
                            rs.getInt("JobLevelID"),
                            rs.getInt("LocationID"),
                            rs.getString("SalaryRange"),
                            postingDate,
                            expirationDate,
                            rs.getInt("CategoryID"),
                            rs.getInt("AgeRequirement"),
                            rs.getString("Status"),
                            rs.getInt("JobTypeID"),
                            rs.getInt("CertificatesID"),
                            rs.getInt("HiringCount")
                    );
                    list.add(job);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
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
