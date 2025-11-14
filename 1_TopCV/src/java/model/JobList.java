package model;

import java.util.Date;

public class JobList {
    private int jobID;
    private int recruiterID;
    private String jobTitle;
    private String description;
    private String requirements;
    private int jobLevelID;
    private int locationID;
    private String salaryRange;
    private Date postingDate;
    private Date expirationDate;
    private int categoryID;
    private int ageRequirement;
    private String status;
    private String companyName;  // lấy từ Recruiter
    private String companyLogo;  // Company logo URL from Recruiter
    private String locationName; // lấy từ Location
    private String packageLevel; // "gold", "silver", "bronze" for premium jobs

    // Constructor rỗng
    public JobList() {
    }

    // Constructor đầy đủ
    public JobList(int jobID, int recruiterID, String jobTitle, String description, String requirements,
               int jobLevelID, int locationID, String salaryRange, Date postingDate,
               Date expirationDate, int categoryID, int ageRequirement, String status) {
        this.jobID = jobID;
        this.recruiterID = recruiterID;
        this.jobTitle = jobTitle;
        this.description = description;
        this.requirements = requirements;
        this.jobLevelID = jobLevelID;
        this.locationID = locationID;
        this.salaryRange = salaryRange;
        this.postingDate = postingDate;
        this.expirationDate = expirationDate;
        this.categoryID = categoryID;
        this.ageRequirement = ageRequirement;
        this.status = status;
    }

    // Getter & Setter
    public int getJobID() {
        return jobID;
    }

    public void setJobID(int jobID) {
        this.jobID = jobID;
    }

    public int getRecruiterID() {
        return recruiterID;
    }

    public void setRecruiterID(int recruiterID) {
        this.recruiterID = recruiterID;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRequirements() {
        return requirements;
    }

    public void setRequirements(String requirements) {
        this.requirements = requirements;
    }

    public int getJobLevelID() {
        return jobLevelID;
    }

    public void setJobLevelID(int jobLevelID) {
        this.jobLevelID = jobLevelID;
    }

    public int getLocationID() {
        return locationID;
    }

    public void setLocationID(int locationID) {
        this.locationID = locationID;
    }

    public String getSalaryRange() {
        return salaryRange;
    }

    public void setSalaryRange(String salaryRange) {
        this.salaryRange = salaryRange;
    }

    public Date getPostingDate() {
        return postingDate;
    }

    public void setPostingDate(Date postingDate) {
        this.postingDate = postingDate;
    }

    public Date getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(Date expirationDate) {
        this.expirationDate = expirationDate;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public int getAgeRequirement() {
        return ageRequirement;
    }

    public void setAgeRequirement(int ageRequirement) {
        this.ageRequirement = ageRequirement;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getCompanyName() {
    return companyName;
}

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
    
    public String getCompanyLogo() {
        return companyLogo;
    }

    public void setCompanyLogo(String companyLogo) {
        this.companyLogo = companyLogo;
    }

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }
    
    public String getPackageLevel() {
        return packageLevel;
    }
    
    public void setPackageLevel(String packageLevel) {
        this.packageLevel = packageLevel;
    }
}