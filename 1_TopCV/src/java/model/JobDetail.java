package model;

import java.sql.Timestamp;

/**
 * JobDetail class chứa đầy đủ thông tin job với các đối tượng liên quan
 * Sử dụng cho trang job-detail.jsp
 */
public class JobDetail {
    // Job basic info
    private int jobID;
    private String jobTitle;
    private String description;
    private String requirements;
    private String salaryRange;
    private Timestamp postingDate;
    private Timestamp expirationDate;
    private int ageRequirement;
    private int hiringCount;
    private String status;
    private Integer views;
    
    // Related objects
    private Recruiter recruiter;
    private Location location;
    private Category category;
    private Type jobLevel;
    private Type jobType;
    private Type certificates;
    
    // Constructors
    public JobDetail() {}
    
    // Getters and Setters
    public int getJobID() {
        return jobID;
    }
    
    public void setJobID(int jobID) {
        this.jobID = jobID;
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
    
    public String getSalaryRange() {
        return salaryRange;
    }
    
    public void setSalaryRange(String salaryRange) {
        this.salaryRange = salaryRange;
    }
    
    public Timestamp getPostingDate() {
        return postingDate;
    }
    
    public void setPostingDate(Timestamp postingDate) {
        this.postingDate = postingDate;
    }
    
    public Timestamp getExpirationDate() {
        return expirationDate;
    }
    
    public void setExpirationDate(Timestamp expirationDate) {
        this.expirationDate = expirationDate;
    }
    
    public int getAgeRequirement() {
        return ageRequirement;
    }
    
    public void setAgeRequirement(int ageRequirement) {
        this.ageRequirement = ageRequirement;
    }
    
    public int getHiringCount() {
        return hiringCount;
    }
    
    public void setHiringCount(int hiringCount) {
        this.hiringCount = hiringCount;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Integer getViews() {
        return views;
    }
    
    public void setViews(Integer views) {
        this.views = views;
    }
    
    public Recruiter getRecruiter() {
        return recruiter;
    }
    
    public void setRecruiter(Recruiter recruiter) {
        this.recruiter = recruiter;
    }
    
    public Location getLocation() {
        return location;
    }
    
    public void setLocation(Location location) {
        this.location = location;
    }
    
    public Category getCategory() {
        return category;
    }
    
    public void setCategory(Category category) {
        this.category = category;
    }
    
    public Type getJobLevel() {
        return jobLevel;
    }
    
    public void setJobLevel(Type jobLevel) {
        this.jobLevel = jobLevel;
    }
    
    public Type getJobType() {
        return jobType;
    }
    
    public void setJobType(Type jobType) {
        this.jobType = jobType;
    }
    
    public Type getCertificates() {
        return certificates;
    }
    
    public void setCertificates(Type certificates) {
        this.certificates = certificates;
    }
    
    @Override
    public String toString() {
        return "JobDetail{" +
                "jobID=" + jobID +
                ", jobTitle='" + jobTitle + '\'' +
                ", salaryRange='" + salaryRange + '\'' +
                ", recruiter=" + (recruiter != null ? recruiter.getCompanyName() : "null") +
                ", location=" + (location != null ? location.getLocationName() : "null") +
                '}';
    }
}