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
    
    /**
     * Get Featured Jobs from recruiters with GOLD packages
     * Only shows jobs from valid (non-expired) gold packages
     * Sorted by PostedDate DESC, ViewCount DESC
     * 
     * @param limit Maximum number of jobs to return (default 8)
     * @return List of featured gold jobs
     */
    public List<JobList> getFeaturedJobsGold(int limit) {
        List<JobList> jobs = new ArrayList<>();
        
        // Use CTE with ROW_NUMBER to limit 5 jobs per company, then sort by ViewCount
        String sql = "WITH RankedJobs AS ( " +
                     "  SELECT " +
                     "    j.JobID, j.RecruiterID, j.JobTitle, j.Description, j.Requirements, " +
                     "    j.JobLevelID, j.LocationID, j.SalaryRange, j.PostingDate, j.ExpirationDate, " +
                     "    j.CategoryID, j.AgeRequirement, j.Status, j.ViewCount, " +
                     "    r.CompanyName, r.CompanyLogoURL, " +
                     "    l.LocationName, " +
                     "    pkg.PackageName, pkg.PackageType, pkg.Features, " +
                     "    rp.ExpiryDate, rp.UsedQuantity, rp.Quantity, " +
                     "    ROW_NUMBER() OVER (PARTITION BY j.RecruiterID ORDER BY j.ViewCount DESC, j.PostingDate DESC) as CompanyRank " +
                     "  FROM Jobs j " +
                     "  INNER JOIN Recruiter r ON j.RecruiterID = r.RecruiterID " +
                     "  INNER JOIN Locations l ON j.LocationID = l.LocationID " +
                     "  INNER JOIN RecruiterPackages rp ON r.RecruiterID = rp.RecruiterID " +
                     "  INNER JOIN JobPackages pkg ON rp.PackageID = pkg.PackageID " +
                     "  WHERE j.Status = 'Published' " +
                     "    AND j.ExpirationDate > GETDATE() " +
                     "    AND rp.ExpiryDate > GETDATE() " +
                     "    AND rp.UsedQuantity < rp.Quantity " +
                     "    AND pkg.Features LIKE '%\"level\": \"gold\"%' " +
                     "    AND pkg.Features LIKE '%\"featured\": true%' " +
                     "    AND pkg.IsActive = 1 " +
                     ") " +
                     "SELECT TOP (?) " +
                     "  JobID, RecruiterID, JobTitle, Description, Requirements, " +
                     "  JobLevelID, LocationID, SalaryRange, PostingDate, ExpirationDate, " +
                     "  CategoryID, AgeRequirement, Status, ViewCount, " +
                     "  CompanyName, CompanyLogoURL, LocationName, " +
                     "  PackageName, PackageType, Features, ExpiryDate, UsedQuantity, Quantity " +
                     "FROM RankedJobs " +
                     "WHERE CompanyRank <= 5 " +
                     "ORDER BY ViewCount DESC, PostingDate DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
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
                    job.setCompanyLogo(rs.getString("CompanyLogoURL"));
                    job.setLocationName(rs.getString("LocationName"));
                    
                    // Store package level for badge display
                    job.setPackageLevel("gold");
                    
                    jobs.add(job);
                }
            }
        } catch (SQLException e) {
            // Silent error handling - log if needed
        }
        
        return jobs;
    }
    
    /**
     * Overloaded method with default limit of 8 jobs
     */
    public List<JobList> getFeaturedJobsGold() {
        return getFeaturedJobsGold(8);
    }
    
    /**
     * Get featured jobs for Silver package (highlight in sidebar)
     * Silver jobs appear in job-list sidebar
     * Sorted by ViewCount DESC (most viewed first), then PostingDate DESC
     * Limited to maximum 5 jobs per company for diversity
     */
    public List<JobList> getFeaturedJobsSilver(int limit) {
        List<JobList> jobs = new ArrayList<>();
        
        // Use CTE with ROW_NUMBER to limit 5 jobs per company, then sort by ViewCount
        String sql = "WITH RankedJobs AS ( " +
                     "  SELECT " +
                     "    j.JobID, j.RecruiterID, j.JobTitle, j.SalaryRange, j.ViewCount, j.PostingDate, " +
                     "    r.CompanyName, " +
                     "    l.LocationName, " +
                     "    ROW_NUMBER() OVER (PARTITION BY j.RecruiterID ORDER BY j.ViewCount DESC, j.PostingDate DESC) as CompanyRank " +
                     "  FROM Jobs j " +
                     "  INNER JOIN Recruiter r ON j.RecruiterID = r.RecruiterID " +
                     "  INNER JOIN Locations l ON j.LocationID = l.LocationID " +
                     "  INNER JOIN RecruiterPackages rp ON r.RecruiterID = rp.RecruiterID " +
                     "  INNER JOIN JobPackages pkg ON rp.PackageID = pkg.PackageID " +
                     "  WHERE j.Status = 'Published' " +
                     "    AND rp.ExpiryDate > GETDATE() " +
                     "    AND rp.UsedQuantity < rp.Quantity " +
                     "    AND pkg.Features LIKE '%\"level\": \"silver\"%' " +
                     "    AND pkg.Features LIKE '%\"highlight\": true%' " +
                     "    AND pkg.IsActive = 1 " +
                     ") " +
                     "SELECT TOP (?) JobID, RecruiterID, JobTitle, SalaryRange, ViewCount, CompanyName, LocationName " +
                     "FROM RankedJobs " +
                     "WHERE CompanyRank <= 5 " +
                     "ORDER BY ViewCount DESC, PostingDate DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    JobList job = new JobList();
                    job.setJobID(rs.getInt("JobID"));
                    job.setRecruiterID(rs.getInt("RecruiterID"));
                    job.setJobTitle(rs.getString("JobTitle"));
                    job.setSalaryRange(rs.getString("SalaryRange"));
                    job.setCompanyName(rs.getString("CompanyName"));
                    job.setLocationName(rs.getString("LocationName"));
                    job.setPackageLevel("silver");
                    
                    jobs.add(job);
                }
            }
        } catch (SQLException e) {
            // Silent error handling
        }
        
        return jobs;
    }
    
    /**
     * Overloaded method with default limit of 12 jobs for Silver
     */
    public List<JobList> getFeaturedJobsSilver() {
        return getFeaturedJobsSilver(12);
    }
    
    /**
     * Debug method to test each condition separately
     */
    public void debugGoldJobsQuery() {
        System.out.println("\n=== GOLD JOBS DEBUG START ===");
        
        // Test 1: Check Jobs table
        try (PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) as cnt FROM Jobs WHERE Status = 'Published'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                System.out.println("1. Published Jobs: " + rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            System.err.println("Error checking Jobs: " + e.getMessage());
        }
        
        // Test 2: Check RecruiterPackages
        try (PreparedStatement ps = c.prepareStatement(
                "SELECT rp.RecruiterPackageID, rp.RecruiterID, rp.PackageID, rp.ExpiryDate, rp.UsedQuantity, rp.Quantity, " +
                "pkg.PackageName, pkg.Features " +
                "FROM RecruiterPackages rp " +
                "INNER JOIN JobPackages pkg ON rp.PackageID = pkg.PackageID " +
                "WHERE rp.ExpiryDate > GETDATE() AND rp.UsedQuantity < rp.Quantity");
             ResultSet rs = ps.executeQuery()) {
            System.out.println("\n2. Valid RecruiterPackages:");
            int count = 0;
            while (rs.next()) {
                count++;
                System.out.println("  Package #" + count + ": " + rs.getString("PackageName"));
                System.out.println("    RecruiterID: " + rs.getInt("RecruiterID"));
                System.out.println("    Features: " + rs.getString("Features"));
                System.out.println("    Expiry: " + rs.getTimestamp("ExpiryDate"));
                System.out.println("    Used/Total: " + rs.getInt("UsedQuantity") + "/" + rs.getInt("Quantity"));
            }
            System.out.println("  Total valid packages: " + count);
        } catch (SQLException e) {
            System.err.println("Error checking packages: " + e.getMessage());
        }
        
        // Test 3: Check Gold packages specifically
        try (PreparedStatement ps = c.prepareStatement(
                "SELECT * FROM JobPackages WHERE Features LIKE '%\"level\": \"gold\"%' AND IsActive = 1");
             ResultSet rs = ps.executeQuery()) {
            System.out.println("\n3. Gold Packages in JobPackages:");
            int count = 0;
            while (rs.next()) {
                count++;
                System.out.println("  Package #" + count + ": " + rs.getString("PackageName"));
                System.out.println("    PackageID: " + rs.getInt("PackageID"));
                System.out.println("    Features: " + rs.getString("Features"));
            }
            System.out.println("  Total gold packages: " + count);
        } catch (SQLException e) {
            System.err.println("Error checking gold packages: " + e.getMessage());
        }
        
        // Test 4: Full query without filters
        try (PreparedStatement ps = c.prepareStatement(
                "SELECT j.JobID, j.JobTitle, j.Status, r.CompanyName, pkg.PackageName, pkg.Features, " +
                "rp.ExpiryDate, rp.UsedQuantity, rp.Quantity " +
                "FROM Jobs j " +
                "INNER JOIN Recruiter r ON j.RecruiterID = r.RecruiterID " +
                "INNER JOIN RecruiterPackages rp ON r.RecruiterID = rp.RecruiterID " +
                "INNER JOIN JobPackages pkg ON rp.PackageID = pkg.PackageID");
             ResultSet rs = ps.executeQuery()) {
            System.out.println("\n4. All Jobs with Packages (no filters):");
            int count = 0;
            while (rs.next()) {
                count++;
                System.out.println("  Job #" + count + ": " + rs.getString("JobTitle"));
                System.out.println("    Company: " + rs.getString("CompanyName"));
                System.out.println("    Status: " + rs.getString("Status"));
                System.out.println("    Package: " + rs.getString("PackageName"));
                System.out.println("    Features: " + rs.getString("Features"));
                System.out.println("    Expiry: " + rs.getTimestamp("ExpiryDate"));
            }
            System.out.println("  Total jobs with packages: " + count);
        } catch (SQLException e) {
            System.err.println("Error in full query: " + e.getMessage());
        }
        
        System.out.println("\n=== GOLD JOBS DEBUG END ===\n");
    }
    
    /**
     * Get jobs by LocationID for JobSeeker profile sidebar
     * Lấy các công việc cùng khu vực với JobSeeker
     */
    public List<JobList> getJobsByLocation(int locationID, int limit) {
        List<JobList> jobs = new ArrayList<>();
        RecruiterDAO recruiterDAO = new RecruiterDAO();
        LocationDAO locationDAO = new LocationDAO();
        
        String sql = "SELECT TOP (?) JobID, RecruiterID, JobTitle, Description, Requirements, " +
                     "JobLevelID, LocationID, SalaryRange, PostingDate, ExpirationDate, " +
                     "CategoryID, AgeRequirement, Status " +
                     "FROM Jobs " +
                     "WHERE Status = 'Published' AND LocationID = ? " +
                     "ORDER BY PostingDate DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, locationID);
            
            try (ResultSet rs = ps.executeQuery()) {
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
                    
                    // Get company name
                    Recruiter r = recruiterDAO.getRecruiterById(job.getRecruiterID());
                    if (r != null) {
                        job.setCompanyName(r.getCompanyName());
                    }
                    
                    // Get location name
                    Location l = locationDAO.getLocationById(job.getLocationID());
                    if (l != null) {
                        job.setLocationName(l.getLocationName());
                    }
                    
                    jobs.add(job);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting jobs by location: " + e.getMessage());
            e.printStackTrace();
        }
        
        return jobs;
    }

}
