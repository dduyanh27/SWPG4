package dal;

import static java.nio.file.Files.list;
import model.Application;
import model.ApplicationView;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.*;

public class ApplicationDAO extends DBContext {

    public boolean insertApplication(Application app) {
        String sql = "INSERT INTO Applications (JobID, CVID, ApplicationDate, Status) "
                + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, app.getJobID());
            ps.setInt(2, app.getCvID());
            ps.setTimestamp(3, Timestamp.valueOf(app.getApplicationDate() != null ? app.getApplicationDate() : LocalDateTime.now()));
            ps.setString(4, app.getStatus() != null ? app.getStatus() : "Pending"); // mặc định Pending

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasApplied(int jobId, int jobSeekerId) {
        String sql = "SELECT COUNT(*) FROM Applications a "
                + "JOIN CVs c ON a.CVID = c.CVID "
                + "WHERE a.JobID = ? AND c.JobSeekerID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            ps.setInt(2, jobSeekerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Application getApplicationById(int applicationId) {
        String sql = "SELECT ApplicationID, JobID, CVID, ApplicationDate, Status "
                + "FROM Applications WHERE ApplicationID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, applicationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Application app = new Application();
                app.setApplicationID(rs.getInt("ApplicationID"));
                app.setJobID(rs.getInt("JobID"));
                app.setCvID(rs.getInt("CVID"));
                app.setApplicationDate(rs.getTimestamp("ApplicationDate").toLocalDateTime());
                app.setStatus(rs.getString("Status"));
                return app;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all applications by job seeker ID with full details
     */
    public List<ApplicationView> getApplicationsByJobSeeker(int jobSeekerId) {
        List<ApplicationView> applications = new ArrayList<>();
        String sql = "SELECT "
                + "a.ApplicationID, a.JobID, a.CVID, a.ApplicationDate, a.Status, "
                + "j.JobTitle, t.TypeName as JobType, j.SalaryRange, j.RecruiterID, "
                + "r.CompanyName, COALESCE(c.CategoryName, 'Công nghệ') as Industry, "
                + "l.LocationName, "
                + "cv.CVTitle "
                + "FROM Applications a "
                + "JOIN CVs cv ON a.CVID = cv.CVID "
                + "JOIN Jobs j ON a.JobID = j.JobID "
                + "JOIN Recruiter r ON j.RecruiterID = r.RecruiterID "
                + "JOIN Locations l ON j.LocationID = l.LocationID "
                + "LEFT JOIN Types t ON j.JobTypeID = t.TypeID "
                + "LEFT JOIN Categories c ON r.CategoryID = c.CategoryID "
                + "WHERE cv.JobSeekerID = ? "
                + "ORDER BY a.ApplicationDate DESC";

        System.out.println("ApplicationDAO: Executing query for jobSeekerId=" + jobSeekerId);
        System.out.println("SQL: " + sql);

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobSeekerId);
            ResultSet rs = ps.executeQuery();

            int count = 0;
            while (rs.next()) {
                count++;
                ApplicationView app = new ApplicationView();
                app.setApplicationID(rs.getInt("ApplicationID"));
                app.setJobID(rs.getInt("JobID"));
                app.setCvID(rs.getInt("CVID"));
                app.setApplicationDate(rs.getTimestamp("ApplicationDate").toLocalDateTime());
                app.setStatus(rs.getString("Status"));
                app.setJobTitle(rs.getString("JobTitle"));
                app.setJobType(rs.getString("JobType"));
                app.setSalaryRange(rs.getString("SalaryRange"));
                app.setRecruiterID(rs.getInt("RecruiterID"));
                app.setCompanyName(rs.getString("CompanyName"));
                app.setIndustry(rs.getString("Industry"));
                app.setLocationName(rs.getString("LocationName"));
                app.setCvTitle(rs.getString("CVTitle"));

                applications.add(app);
                System.out.println("Found application: " + app.getJobTitle() + " at " + app.getCompanyName());
            }

            System.out.println("ApplicationDAO: Found " + count + " applications");

        } catch (SQLException e) {
            System.out.println("ApplicationDAO: SQL Error - " + e.getMessage());
            e.printStackTrace();
        }

        return applications;
    }

    /**
     * Get applications by job seeker with filters
     */
    public List<ApplicationView> getApplicationsByJobSeekerWithFilters(int jobSeekerId, String status, Integer dayRange) {
        List<ApplicationView> applications = new ArrayList<>();
        StringBuilder sql = new StringBuilder();

        sql.append("SELECT ");
        sql.append("a.ApplicationID, a.JobID, a.CVID, a.ApplicationDate, a.Status, ");
        sql.append("j.JobTitle, t.TypeName as JobType, j.SalaryRange, j.RecruiterID, ");
        sql.append("r.CompanyName, COALESCE(c.CategoryName, 'Công nghệ') as Industry, ");
        sql.append("l.LocationName, ");
        sql.append("cv.CVTitle ");
        sql.append("FROM Applications a ");
        sql.append("JOIN CVs cv ON a.CVID = cv.CVID ");
        sql.append("JOIN Jobs j ON a.JobID = j.JobID ");
        sql.append("JOIN Recruiter r ON j.RecruiterID = r.RecruiterID ");
        sql.append("JOIN Locations l ON j.LocationID = l.LocationID ");
        sql.append("LEFT JOIN Types t ON j.JobTypeID = t.TypeID ");
        sql.append("LEFT JOIN Categories c ON r.CategoryID = c.CategoryID ");
        sql.append("WHERE cv.JobSeekerID = ? ");

        // Add status filter
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND a.Status = ? ");
        }

        // Add date range filter
        if (dayRange != null && dayRange > 0) {
            sql.append("AND a.ApplicationDate >= DATEADD(day, ?, GETDATE()) ");
        }

        sql.append("ORDER BY a.ApplicationDate DESC");

        try (PreparedStatement ps = c.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, jobSeekerId);

            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status);
            }

            if (dayRange != null && dayRange > 0) {
                ps.setInt(paramIndex++, -dayRange);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ApplicationView app = new ApplicationView();
                app.setApplicationID(rs.getInt("ApplicationID"));
                app.setJobID(rs.getInt("JobID"));
                app.setCvID(rs.getInt("CVID"));
                app.setApplicationDate(rs.getTimestamp("ApplicationDate").toLocalDateTime());
                app.setStatus(rs.getString("Status"));
                app.setJobTitle(rs.getString("JobTitle"));
                app.setJobType(rs.getString("JobType"));
                app.setSalaryRange(rs.getString("SalaryRange"));
                app.setRecruiterID(rs.getInt("RecruiterID"));
                app.setCompanyName(rs.getString("CompanyName"));
                app.setIndustry(rs.getString("Industry"));
                app.setLocationName(rs.getString("LocationName"));
                app.setCvTitle(rs.getString("CVTitle"));

                applications.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return applications;
    }

    /**
     * Get application statistics by job seeker
     */
    public ApplicationStatistics getApplicationStatistics(int jobSeekerId) {
        ApplicationStatistics stats = new ApplicationStatistics();
//<<<<<<< HEAD
        String sql = "SELECT " +
                    "COUNT(*) as total, " +
                    "SUM(CASE WHEN a.Status = 'Pending' THEN 1 ELSE 0 END) as pending, " +
                    "SUM(CASE WHEN a.Status = 'Accepted' THEN 1 ELSE 0 END) as accepted, " +
                    "SUM(CASE WHEN a.Status = 'Rejected' THEN 1 ELSE 0 END) as rejected, " +
                    "SUM(CASE WHEN a.Status = 'Interviewed' THEN 1 ELSE 0 END) as interviewed " +
                    "FROM Applications a " +
                    "JOIN CVs cv ON a.CVID = cv.CVID " +
                    "WHERE cv.JobSeekerID = ?";
        
//=======
//        String sql = "SELECT "
//                + "COUNT(*) as total, "
//                + "SUM(CASE WHEN a.Status = 'pending' THEN 1 ELSE 0 END) as pending, "
//                + "SUM(CASE WHEN a.Status = 'approved' THEN 1 ELSE 0 END) as approved, "
//                + "SUM(CASE WHEN a.Status = 'interviewed' THEN 1 ELSE 0 END) as interviewed "
//                + "FROM Applications a "
//                + "JOIN CVs cv ON a.CVID = cv.CVID "
//                + "WHERE cv.JobSeekerID = ?";
//
//>>>>>>> origin/main
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobSeekerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                stats.setTotalApplications(rs.getInt("total"));
                stats.setPendingApplications(rs.getInt("pending"));
                stats.setAcceptedApplications(rs.getInt("accepted"));
                stats.setRejectedApplications(rs.getInt("rejected"));
                stats.setInterviewedApplications(rs.getInt("interviewed"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    /**
     * Delete application by ID with JobSeeker verification and Pending status check
     * @param applicationId The application ID to delete
     * @param jobSeekerId The JobSeeker ID for verification
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteApplication(int applicationId, int jobSeekerId) {
        // First check if the application exists, belongs to the user, and has Pending status
        String checkSql = "SELECT a.Status FROM Applications a " +
                         "JOIN CVs cv ON a.CVID = cv.CVID " +
                         "WHERE a.ApplicationID = ? AND cv.JobSeekerID = ?";
        
        try (PreparedStatement checkPs = c.prepareStatement(checkSql)) {
            checkPs.setInt(1, applicationId);
            checkPs.setInt(2, jobSeekerId);
            ResultSet rs = checkPs.executeQuery();
            
            if (!rs.next()) {
                System.out.println("ApplicationDAO: Application not found or doesn't belong to user");
                return false;
            }
            
            String status = rs.getString("Status");
            if (!"Pending".equals(status)) {
                System.out.println("ApplicationDAO: Cannot delete application with status: " + status);
                return false;
            }
            
        } catch (SQLException e) {
            System.out.println("ApplicationDAO: Error checking application status - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
        
        // If checks pass, proceed with deletion
        String deleteSql = "DELETE FROM Applications " +
                          "WHERE ApplicationID = ? AND Status = 'Pending' AND CVID IN (" +
                          "SELECT CVID FROM CVs WHERE JobSeekerID = ?)";
        
        try (PreparedStatement deletePs = c.prepareStatement(deleteSql)) {
            deletePs.setInt(1, applicationId);
            deletePs.setInt(2, jobSeekerId);
            
            int rowsAffected = deletePs.executeUpdate();
            System.out.println("ApplicationDAO: Deleted application ID " + applicationId + 
                             " for JobSeeker " + jobSeekerId + ". Rows affected: " + rowsAffected);
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("ApplicationDAO: Error deleting application - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Inner class for application statistics
     */
    public static class ApplicationStatistics {

        private int totalApplications;
        private int pendingApplications;
        private int acceptedApplications;
        private int rejectedApplications;
        private int interviewedApplications;

        public ApplicationStatistics() {
        }

        // Getters and setters
        public int getTotalApplications() {
            return totalApplications;
        }

        public void setTotalApplications(int totalApplications) {
            this.totalApplications = totalApplications;
        }

        public int getPendingApplications() {
            return pendingApplications;
        }

        public void setPendingApplications(int pendingApplications) {
            this.pendingApplications = pendingApplications;
        }
//<<<<<<< HEAD
        
        public int getAcceptedApplications() {
            return acceptedApplications;
        }
        
        public void setAcceptedApplications(int acceptedApplications) {
            this.acceptedApplications = acceptedApplications;
        }
        
        public int getRejectedApplications() {
            return rejectedApplications;
        }
        
        public void setRejectedApplications(int rejectedApplications) {
            this.rejectedApplications = rejectedApplications;
//=======
//
//        public int getApprovedApplications() {
//            return approvedApplications;
//        }
//
//        public void setApprovedApplications(int approvedApplications) {
//            this.approvedApplications = approvedApplications;
//>>>>>>> origin/main
        }

        public int getInterviewedApplications() {
            return interviewedApplications;
        }

        public void setInterviewedApplications(int interviewedApplications) {
            this.interviewedApplications = interviewedApplications;
        }
    }

    //duy anh
    public List<Application> getAllApplications() {
        List<Application> appList = new ArrayList<>();
        String sql = "SELECT * FROM Applications";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Application app = new Application(
                        rs.getInt("applicationID"),
                        rs.getInt("jobID"),
                        rs.getInt("cvID"),
                        rs.getTimestamp("applicationDate").toLocalDateTime(),
                        rs.getString("status")
                );
                appList.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appList;
    }
  
    /**
     * Update application status (for recruiter) and send notification to jobseeker
     * @param applicationId
     * @param newStatus - "Pending", "Accepted", "Rejected"
     * @return true if success
     */
    public boolean updateApplicationStatus(int applicationId, String newStatus) {
        String sql = "UPDATE Applications SET Status = ? WHERE ApplicationID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, applicationId);
            
            boolean success = ps.executeUpdate() > 0;
            
            if (success) {
                // Get jobseeker info to send notification
                String getSql = "SELECT c.JobSeekerID, a.JobID FROM Applications a " +
                               "JOIN CVs c ON a.CVID = c.CVID " +
                               "WHERE a.ApplicationID = ?";
                try (PreparedStatement getPs = c.prepareStatement(getSql)) {
                    getPs.setInt(1, applicationId);
                    ResultSet rs = getPs.executeQuery();
                    if (rs.next()) {
                        int jobSeekerId = rs.getInt("JobSeekerID");
                        int jobId = rs.getInt("JobID");
                        
                        // Send notification
                        String title = "";
                        String message = "";
                        int priority = 2; // High priority
                        
                        if ("Accepted".equalsIgnoreCase(newStatus)) {
                            title = "Chúc mừng! Đơn ứng tuyển được chấp nhận";
                            message = "Đơn ứng tuyển của bạn đã được nhà tuyển dụng chấp nhận. Họ sẽ liên hệ với bạn sớm nhất.";
                        } else if ("Rejected".equalsIgnoreCase(newStatus)) {
                            title = "Đơn ứng tuyển không được chấp nhận";
                            message = "Rất tiếc, đơn ứng tuyển của bạn chưa phù hợp với yêu cầu tuyển dụng lần này. Đừng nản chí, hãy tiếp tục cố gắng!";
                            priority = 1;
                        } else if ("Pending".equalsIgnoreCase(newStatus)) {
                            title = "Đơn ứng tuyển đang chờ xử lý";
                            message = "Đơn ứng tuyển của bạn đang được xem xét. Vui lòng kiên nhẫn chờ đợi.";
                            priority = 0;
                        }
                        
                        if (!title.isEmpty()) {
                            NotificationDAO.sendNotification(
                                jobSeekerId,
                                "jobseeker",
                                "application",
                                title,
                                message,
                                applicationId,
                                "application",
                                "/JobSeeker/applied-jobs.jsp",
                                priority
                            );
                        }
                    }
                }
            }
            
            return success;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    /**
     * Get all applications for a specific job (for recruiter to view candidates)
     * Joins with JobSeeker, CV, Job to get full candidate information
     */
    public List<model.CandidateApplication> getApplicationsByJobID(int jobID, int recruiterID) {
        List<model.CandidateApplication> candidates = new ArrayList<>();
        // Simplified query - bỏ DateOfBirth và Ratings table (có thể không tồn tại)
        String sql = "SELECT " +
                    "a.ApplicationID, a.JobID, a.CVID, a.ApplicationDate, a.Status, " +
                    "js.JobSeekerID, js.FullName as CandidateName, js.Email as CandidateEmail, " +
                    "js.Phone as CandidatePhone, " +
                    "cv.CVTitle, " +
                    "j.JobTitle, " +
                    "0 as ExperienceYears, " +
                    "0.0 as Rating " +
                    "FROM Applications a " +
                    "INNER JOIN CVs cv ON a.CVID = cv.CVID " +
                    "INNER JOIN JobSeeker js ON cv.JobSeekerID = js.JobSeekerID " +
                    "INNER JOIN Jobs j ON a.JobID = j.JobID " +
                    "WHERE a.JobID = ? AND j.RecruiterID = ? " +
                    "ORDER BY a.ApplicationDate DESC";
        
        System.out.println("DEBUG ApplicationDAO: Getting applications for JobID: " + jobID + ", RecruiterID: " + recruiterID);
        System.out.println("DEBUG ApplicationDAO: SQL: " + sql);
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobID);
            ps.setInt(2, recruiterID);
            ResultSet rs = ps.executeQuery();
            
            int count = 0;
            while (rs.next()) {
                count++;
                model.CandidateApplication candidate = new model.CandidateApplication();
                
                candidate.setApplicationID(rs.getInt("ApplicationID"));
                candidate.setJobID(rs.getInt("JobID"));
                candidate.setCvID(rs.getInt("CVID"));
                candidate.setJobSeekerID(rs.getInt("JobSeekerID"));
                
                Timestamp appDate = rs.getTimestamp("ApplicationDate");
                if (appDate != null) {
                    candidate.setApplicationDate(appDate.toLocalDateTime());
                } else {
                    System.out.println("DEBUG ApplicationDAO: Warning - ApplicationDate is null for ApplicationID: " + candidate.getApplicationID());
                }
                
                candidate.setStatus(rs.getString("Status"));
                candidate.setCandidateName(rs.getString("CandidateName"));
                candidate.setCandidateEmail(rs.getString("CandidateEmail"));
                candidate.setCandidatePhone(rs.getString("CandidatePhone"));
                candidate.setCvTitle(rs.getString("CVTitle"));
                candidate.setJobTitle(rs.getString("JobTitle"));
                
                // Experience years - set default 0
                candidate.setExperienceYears(0);
                
                // Rating - set default 0.0
                candidate.setRating(0.0);
                
                candidates.add(candidate);
                System.out.println("DEBUG ApplicationDAO: Found candidate #" + count + 
                                 " - Name: " + candidate.getCandidateName() + 
                                 ", ApplicationID: " + candidate.getApplicationID() +
                                 ", Status: " + candidate.getStatus());
            }
            
            System.out.println("DEBUG ApplicationDAO: Total candidates found: " + candidates.size());
            
            if (candidates.isEmpty()) {
                System.out.println("DEBUG ApplicationDAO: WARNING - No candidates found for JobID: " + jobID + ", RecruiterID: " + recruiterID);
            }
            
        } catch (SQLException e) {
            System.out.println("DEBUG ApplicationDAO: SQL Error getting applications by jobID!");
            System.out.println("DEBUG ApplicationDAO: Error Message: " + e.getMessage());
            System.out.println("DEBUG ApplicationDAO: SQL State: " + e.getSQLState());
            System.out.println("DEBUG ApplicationDAO: Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("DEBUG ApplicationDAO: General Error getting applications by jobID!");
            System.out.println("DEBUG ApplicationDAO: Error Message: " + e.getMessage());
            e.printStackTrace();
        }
        
        return candidates;
    }

    /**
     * Update application status (Accept or Reject)
     */
    public boolean updateApplicationStatus(int applicationID, int jobID, int recruiterID, String newStatus) {
        // Verify that the application belongs to the recruiter's job
        String verifySql = "SELECT COUNT(*) FROM Applications a " +
                          "INNER JOIN Jobs j ON a.JobID = j.JobID " +
                          "WHERE a.ApplicationID = ? AND a.JobID = ? AND j.RecruiterID = ?";
        
        try (PreparedStatement verifyPs = c.prepareStatement(verifySql)) {
            verifyPs.setInt(1, applicationID);
            verifyPs.setInt(2, jobID);
            verifyPs.setInt(3, recruiterID);
            
            ResultSet rs = verifyPs.executeQuery();
            if (rs.next() && rs.getInt(1) == 0) {
                System.out.println("DEBUG ApplicationDAO: Application does not belong to recruiter");
                return false;
            }
        } catch (SQLException e) {
            System.out.println("DEBUG ApplicationDAO: Error verifying application: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
        
        // Update status
        String updateSql = "UPDATE Applications SET Status = ? WHERE ApplicationID = ?";
        
        System.out.println("DEBUG ApplicationDAO: Updating ApplicationID: " + applicationID + " to Status: '" + newStatus + "'");
        System.out.println("DEBUG ApplicationDAO: SQL: " + updateSql);
        
        try (PreparedStatement ps = c.prepareStatement(updateSql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, applicationID);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG ApplicationDAO: Updated application " + applicationID + 
                             " status to '" + newStatus + "', rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                System.out.println("DEBUG ApplicationDAO: SUCCESS - Application status updated to: '" + newStatus + "'");
            } else {
                System.out.println("DEBUG ApplicationDAO: WARNING - No rows affected! ApplicationID might not exist: " + applicationID);
            }
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("DEBUG ApplicationDAO: SQL Error updating application status!");
            System.out.println("DEBUG ApplicationDAO: Error Message: " + e.getMessage());
            System.out.println("DEBUG ApplicationDAO: SQL State: " + e.getSQLState());
            System.out.println("DEBUG ApplicationDAO: Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get application count for a specific job
     * @param jobID The job ID
     * @return The number of applications for this job
     */
    public int getApplicationCountByJobId(int jobID) {
        String sql = "SELECT COUNT(*) FROM Applications WHERE JobID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
