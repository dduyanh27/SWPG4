package model;

import java.time.LocalDateTime;

public class Job {
    private int jobID;
    private int recruiterID;
    private String jobTitle;
    private String description;
    private String requirements;
    private int jobLevelID; 
    private int locationID;
    private String salaryRange;
    private LocalDateTime postingDate;
    private LocalDateTime expirationDate;
    private int categoryID;
    private int ageRequirement; 
    private String status;
    private int jobTypeID; 
    private int certificatesID; 
    private int hiringCount;

    public Job() {}

    public Job(int jobID, int recruiterID, String jobTitle, String description, String requirements,
               int jobLevelID, int locationID, String salaryRange, LocalDateTime postingDate,
               LocalDateTime expirationDate, int categoryID, int ageRequirement, String status,
               int jobTypeID, int certificatesID, int hiringCount) {
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
        this.jobTypeID = jobTypeID;
        this.certificatesID = certificatesID;
        this.hiringCount = hiringCount;
    }

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

    public LocalDateTime getPostingDate() {
        return postingDate;
    }

    public void setPostingDate(LocalDateTime postingDate) {
        this.postingDate = postingDate;
    }

    public LocalDateTime getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(LocalDateTime expirationDate) {
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

    public int getJobTypeID() { 
        return jobTypeID;
    }

    public void setJobTypeID(int jobTypeID) { 
        this.jobTypeID = jobTypeID;
    }

    public int getCertificatesID() { 
        return certificatesID;
    }

    public void setCertificatesID(int certificatesID) { 
        this.certificatesID = certificatesID;
    }
    
    public int getHiringCount() {
        return hiringCount;
    }

    public void setHiringCount(int hiringCount) {
        this.hiringCount = hiringCount;
    }

    @Override
    public String toString() {
        return "Job{" +
                "jobID=" + jobID +
                ", recruiterID=" + recruiterID +
                ", jobTitle='" + jobTitle + '\'' +
                ", description='" + description + '\'' +
                ", requirements='" + requirements + '\'' +
                ", jobLevelID=" + jobLevelID +
                ", locationID=" + locationID +
                ", salaryRange='" + salaryRange + '\'' +
                ", postingDate=" + postingDate +
                ", expirationDate=" + expirationDate +
                ", categoryID=" + categoryID +
                ", ageRequirement=" + ageRequirement +
                ", status='" + status + '\'' +
                ", jobTypeID=" + jobTypeID +
                ", certificatesID=" + certificatesID + 
                ", hiringCount=" + hiringCount +
                '}';
    }
}
