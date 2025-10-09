package dal;

import model.SavedJob;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class SavedJobDAO extends DBContext {
    
    /**
     * Save a job for a job seeker
     * @param jobSeekerID
     * @param jobID
     * @return true if saved successfully, false otherwise
     */
    public boolean saveJob(int jobSeekerID, int jobID) {
        String checkSql = "SELECT SavedJobID FROM SavedJobs WHERE JobSeekerID = ? AND JobID = ?";
        String insertSql = "INSERT INTO SavedJobs (JobSeekerID, JobID, SavedDate) VALUES (?, ?, ?)";
        
        try {
            // Check if already saved
            PreparedStatement checkStmt = c.prepareStatement(checkSql);
            checkStmt.setInt(1, jobSeekerID);
            checkStmt.setInt(2, jobID);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                // Already saved
                return false;
            }
            
            // Save the job
            PreparedStatement insertStmt = c.prepareStatement(insertSql);
            insertStmt.setInt(1, jobSeekerID);
            insertStmt.setInt(2, jobID);
            insertStmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            
            int result = insertStmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Unsave a job for a job seeker
     * @param jobSeekerID
     * @param jobID
     * @return true if unsaved successfully, false otherwise
     */
    public boolean unsaveJob(int jobSeekerID, int jobID) {
        String sql = "DELETE FROM SavedJobs WHERE JobSeekerID = ? AND JobID = ?";
        
        try {
            PreparedStatement stmt = c.prepareStatement(sql);
            stmt.setInt(1, jobSeekerID);
            stmt.setInt(2, jobID);
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if a job is saved by a job seeker
     * @param jobSeekerID
     * @param jobID
     * @return true if saved, false otherwise
     */
    public boolean isJobSaved(int jobSeekerID, int jobID) {
        String sql = "SELECT SavedJobID FROM SavedJobs WHERE JobSeekerID = ? AND JobID = ?";
        
        try {
            PreparedStatement stmt = c.prepareStatement(sql);
            stmt.setInt(1, jobSeekerID);
            stmt.setInt(2, jobID);
            
            ResultSet rs = stmt.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get all saved jobs for a job seeker with full details
     * @param jobSeekerID
     * @return List of SavedJob objects
     */
    public List<SavedJob> getSavedJobsByJobSeeker(int jobSeekerID) {
        List<SavedJob> savedJobs = new ArrayList<>();
        
        String sql = "SELECT sj.SavedJobID, sj.JobSeekerID, sj.JobID, sj.SavedDate, " +
                     "j.JobTitle, r.CompanyName, l.LocationName, j.SalaryRange, " +
                     "c.CategoryName as Industry, j.PostingDate " +
                     "FROM SavedJobs sj " +
                     "JOIN Jobs j ON sj.JobID = j.JobID " +
                     "JOIN Recruiter r ON j.RecruiterID = r.RecruiterID " +
                     "JOIN Locations l ON j.LocationID = l.LocationID " +
                     "JOIN Categories c ON j.CategoryID = c.CategoryID " +
                     "WHERE sj.JobSeekerID = ? " +
                     "ORDER BY sj.SavedDate DESC";
        
        try {
            PreparedStatement stmt = c.prepareStatement(sql);
            stmt.setInt(1, jobSeekerID);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                SavedJob savedJob = new SavedJob();
                savedJob.setSavedJobID(rs.getInt("SavedJobID"));
                savedJob.setJobSeekerID(rs.getInt("JobSeekerID"));
                savedJob.setJobID(rs.getInt("JobID"));
                
                Timestamp timestamp = rs.getTimestamp("SavedDate");
                if (timestamp != null) {
                    savedJob.setSavedDate(timestamp.toLocalDateTime());
                }
                
                savedJob.setJobTitle(rs.getString("JobTitle"));
                savedJob.setCompanyName(rs.getString("CompanyName"));
                savedJob.setLocationName(rs.getString("LocationName"));
                savedJob.setSalaryRange(rs.getString("SalaryRange"));
                savedJob.setIndustry(rs.getString("Industry"));
                
                Date postingDate = rs.getDate("PostingDate");
                if (postingDate != null) {
                    savedJob.setPostingDate(postingDate.toString());
                }
                
                savedJobs.add(savedJob);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return savedJobs;
    }
    
    /**
     * Get count of saved jobs for a job seeker
     * @param jobSeekerID
     * @return count of saved jobs
     */
    public int getSavedJobsCount(int jobSeekerID) {
        String sql = "SELECT COUNT(*) as count FROM SavedJobs WHERE JobSeekerID = ?";
        
        try {
            PreparedStatement stmt = c.prepareStatement(sql);
            stmt.setInt(1, jobSeekerID);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
}
