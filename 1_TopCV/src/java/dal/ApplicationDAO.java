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
        String sql = "SELECT "
                + "COUNT(*) as total, "
                + "SUM(CASE WHEN a.Status = 'pending' THEN 1 ELSE 0 END) as pending, "
                + "SUM(CASE WHEN a.Status = 'approved' THEN 1 ELSE 0 END) as approved, "
                + "SUM(CASE WHEN a.Status = 'interviewed' THEN 1 ELSE 0 END) as interviewed "
                + "FROM Applications a "
                + "JOIN CVs cv ON a.CVID = cv.CVID "
                + "WHERE cv.JobSeekerID = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobSeekerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                stats.setTotalApplications(rs.getInt("total"));
                stats.setPendingApplications(rs.getInt("pending"));
                stats.setApprovedApplications(rs.getInt("approved"));
                stats.setInterviewedApplications(rs.getInt("interviewed"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    /**
     * Inner class for application statistics
     */
    public static class ApplicationStatistics {

        private int totalApplications;
        private int pendingApplications;
        private int approvedApplications;
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

        public int getApprovedApplications() {
            return approvedApplications;
        }

        public void setApprovedApplications(int approvedApplications) {
            this.approvedApplications = approvedApplications;
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
}
