package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import model.JobList;
import model.Location;
import model.Recruiter;

public class JobListDAO extends DBContext {

    public List<JobList> getAllJobs() {
        List<JobList> list = new ArrayList<>();
        RecruiterDAO recruiterDAO = new RecruiterDAO();
        LocationDAO locationDAO = new LocationDAO();
        String sql = "SELECT JobID, RecruiterID, JobTitle, Description, Requirements, "
                + "JobLevelID, LocationID, SalaryRange, PostingDate, ExpirationDate, "
                + "CategoryID, AgeRequirement, Status "
                + "FROM Jobs WHERE Status = 'Published'";

        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                JobList job = new JobList();
                job.setJobID(rs.getInt("JobID"));
                job.setRecruiterID(rs.getInt("RecruiterID"));
                job.setJobTitle(rs.getString("JobTitle"));
                job.setDescription(rs.getString("Description"));
                job.setRequirements(rs.getString("Requirements"));
                job.setJobLevelID(rs.getInt("JobLevelID"));
                job.setLocationID(rs.getInt("LocationID"));
                job.setSalaryRange(rs.getString("SalaryRange"));
                job.setPostingDate(rs.getDate("PostingDate"));
                job.setExpirationDate(rs.getDate("ExpirationDate"));
                job.setCategoryID(rs.getInt("CategoryID"));
                job.setAgeRequirement(rs.getInt("AgeRequirement"));
                job.setStatus(rs.getString("Status"));
                // Lấy tên công ty
                Recruiter r = recruiterDAO.getRecruiterById(job.getRecruiterID());
                if (r != null) {
                    job.setCompanyName(r.getCompanyName());
                }

                // Lấy tên location
                Location l = locationDAO.getLocationById(job.getLocationID());
                if (l != null) {
                    job.setLocationName(l.getLocationName());
                }
                list.add(job);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalJobs() {
        String sql = "SELECT COUNT(*) FROM Jobs WHERE Status = 'Published'";
        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<JobList> searchJobs(String keyword, List<Integer> categoryIds, Integer locationId) {
        List<JobList> jobs = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT j.JobID, j.RecruiterID, j.JobTitle, j.Description, j.Requirements, j.JobLevelID, "
                    + "j.LocationID, j.SalaryRange, j.PostingDate, j.ExpirationDate, j.CategoryID, j.AgeRequirement, j.Status, "
                    + "r.CompanyName, l.LocationName "
                    + "FROM Jobs j "
                    + "JOIN Recruiter r ON j.RecruiterID = r.RecruiterID "
                    + "JOIN Locations l ON j.LocationID = l.LocationID "
                    + "WHERE j.Status = 'Published'"
            );

            List<Object> params = new ArrayList<>();

            // Search theo keyword
            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append(" AND (j.JobTitle LIKE ? OR r.CompanyName LIKE ?)");
                String kw = "%" + keyword.trim() + "%";
                params.add(kw);
                params.add(kw);
            }

            // Filter theo categoryIds
            if (categoryIds != null && !categoryIds.isEmpty()) {
                sql.append(" AND j.CategoryID IN (");
                sql.append(categoryIds.stream().map(id -> "?").collect(Collectors.joining(",")));
                sql.append(")");
                params.addAll(categoryIds);
            }

            // Filter theo locationId
            if (locationId != null) {
                sql.append(" AND j.LocationID = ?");
                params.add(locationId);
            }

            //sql.append(" ORDER BY j.PostingDate DESC");

            ps = c.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                JobList job = new JobList();
                job.setJobID(rs.getInt("JobID"));
                job.setRecruiterID(rs.getInt("RecruiterID"));
                job.setJobTitle(rs.getString("JobTitle"));
                job.setDescription(rs.getString("Description"));
                job.setRequirements(rs.getString("Requirements"));
                job.setJobLevelID(rs.getInt("JobLevelID"));
                job.setLocationID(rs.getInt("LocationID"));
                job.setSalaryRange(rs.getString("SalaryRange"));
                job.setPostingDate(rs.getDate("PostingDate"));
                job.setExpirationDate(rs.getDate("ExpirationDate"));
                job.setCategoryID(rs.getInt("CategoryID"));
                job.setAgeRequirement(rs.getInt("AgeRequirement"));
                job.setStatus(rs.getString("Status"));
                job.setCompanyName(rs.getString("CompanyName"));
                job.setLocationName(rs.getString("LocationName"));
                jobs.add(job);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception ignored) {
            }
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception ignored) {
            }
        }

        return jobs;
    }

}
