package dal;

import model.*;
import java.sql.*;

public class JobDetailDAO extends DBContext {
    
    /**
     * Lấy thông tin chi tiết job với tất cả thông tin liên quan
     * JOIN với các bảng: Recruiter, Locations, Categories, Types
     */
    public JobDetail getJobDetailById(int jobId) {
        String sql = """
            SELECT 
                j.JobID, j.JobTitle, j.Description, j.Requirements, j.SalaryRange,
                j.PostingDate, j.ExpirationDate, j.AgeRequirement, j.HiringCount, j.Status,
                
                -- Recruiter info
                r.RecruiterID, r.CompanyName, r.CompanyDescription, r.CompanyLogoURL,
                r.Website, r.CompanyAddress, r.CompanySize, r.ContactPerson, 
                r.CompanyBenefits, r.CompanyVideoURL,
                
                -- Location info
                l.LocationID, l.LocationName,
                
                -- Category info
                c.CategoryID, c.CategoryName,
                
                -- Job Level info
                jlevel.TypeID as JobLevelID, jlevel.TypeName as JobLevelName,
                
                -- Job Type info
                jtype.TypeID as JobTypeID, jtype.TypeName as JobTypeName,
                
                -- Certificate info
                cert.TypeID as CertificateID, cert.TypeName as CertificateName
                
            FROM Jobs j
            LEFT JOIN Recruiter r ON j.RecruiterID = r.RecruiterID
            LEFT JOIN Locations l ON j.LocationID = l.LocationID
            LEFT JOIN Categories c ON j.CategoryID = c.CategoryID
            LEFT JOIN Types jlevel ON j.JobLevelID = jlevel.TypeID AND jlevel.TypeCategory = 'JobLevel'
            LEFT JOIN Types jtype ON j.JobTypeID = jtype.TypeID AND jtype.TypeCategory = 'JobType'
            LEFT JOIN Types cert ON j.CertificatesID = cert.TypeID AND cert.TypeCategory = 'Certificate'
            
            WHERE j.JobID = ?
        """;
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToJobDetail(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Map ResultSet thành JobDetail object
     */
    private JobDetail mapResultSetToJobDetail(ResultSet rs) throws SQLException {
        JobDetail jobDetail = new JobDetail();
        
        // Job basic info
        jobDetail.setJobID(rs.getInt("JobID"));
        jobDetail.setJobTitle(rs.getString("JobTitle"));
        jobDetail.setDescription(rs.getString("Description"));
        jobDetail.setRequirements(rs.getString("Requirements"));
        jobDetail.setSalaryRange(rs.getString("SalaryRange"));
        jobDetail.setAgeRequirement(rs.getInt("AgeRequirement"));
        jobDetail.setHiringCount(rs.getInt("HiringCount"));
        jobDetail.setStatus(rs.getString("Status"));
        
        // Dates
        Timestamp postingDate = rs.getTimestamp("PostingDate");
        if (postingDate != null) {
            jobDetail.setPostingDate(postingDate);
        }
        
        Timestamp expirationDate = rs.getTimestamp("ExpirationDate");
        if (expirationDate != null) {
            jobDetail.setExpirationDate(expirationDate);
        }
        
        // Recruiter info
        Recruiter recruiter = new Recruiter();
        recruiter.setRecruiterID(rs.getInt("RecruiterID"));
        recruiter.setCompanyName(rs.getString("CompanyName"));
        recruiter.setCompanyDescription(rs.getString("CompanyDescription"));
        recruiter.setCompanyLogoURL(rs.getString("CompanyLogoURL"));
        recruiter.setWebsite(rs.getString("Website"));
        recruiter.setCompanyAddress(rs.getString("CompanyAddress"));
        recruiter.setCompanySize(rs.getString("CompanySize"));
        recruiter.setContactPerson(rs.getString("ContactPerson"));
        recruiter.setCompanyBenefits(rs.getString("CompanyBenefits"));
        recruiter.setCompanyVideoURL(rs.getString("CompanyVideoURL"));
        jobDetail.setRecruiter(recruiter);
        
        // Location info
        Location location = new Location();
        location.setLocationID(rs.getInt("LocationID"));
        location.setLocationName(rs.getString("LocationName"));
        jobDetail.setLocation(location);
        
        // Category info
        Category category = new Category();
        category.setCategoryID(rs.getInt("CategoryID"));
        category.setCategoryName(rs.getString("CategoryName"));
        jobDetail.setCategory(category);
        
        // Job Level info
        Type jobLevel = new Type();
        jobLevel.setTypeID(rs.getInt("JobLevelID"));
        jobLevel.setTypeName(rs.getString("JobLevelName"));
        jobLevel.setTypeCategory("JobLevel");
        jobDetail.setJobLevel(jobLevel);
        
        // Job Type info
        Type jobType = new Type();
        jobType.setTypeID(rs.getInt("JobTypeID"));
        jobType.setTypeName(rs.getString("JobTypeName"));
        jobType.setTypeCategory("JobType");
        jobDetail.setJobType(jobType);
        
        // Certificate info
        Type certificate = new Type();
        certificate.setTypeID(rs.getInt("CertificateID"));
        certificate.setTypeName(rs.getString("CertificateName"));
        certificate.setTypeCategory("Certificate");
        jobDetail.setCertificates(certificate);
        
        return jobDetail;
    }
}