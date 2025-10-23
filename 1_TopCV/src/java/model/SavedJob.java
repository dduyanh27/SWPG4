package model;

import java.time.LocalDateTime;

/**
 * Model class for saved jobs
 */
public class SavedJob {
    private int savedJobID;
    private int jobSeekerID;
    private int jobID;
    private LocalDateTime savedDate;
    
    // Extended fields for display
    private String jobTitle;
    private String companyName;
    private String locationName;
    private String salaryRange;
    private String industry;
    private String postingDate;
    
    // Constructors
    public SavedJob() {
    }
    
    public SavedJob(int savedJobID, int jobSeekerID, int jobID, LocalDateTime savedDate) {
        this.savedJobID = savedJobID;
        this.jobSeekerID = jobSeekerID;
        this.jobID = jobID;
        this.savedDate = savedDate;
    }
    
    // Getters and Setters
    public int getSavedJobID() {
        return savedJobID;
    }
    
    public void setSavedJobID(int savedJobID) {
        this.savedJobID = savedJobID;
    }
    
    public int getJobSeekerID() {
        return jobSeekerID;
    }
    
    public void setJobSeekerID(int jobSeekerID) {
        this.jobSeekerID = jobSeekerID;
    }
    
    public int getJobID() {
        return jobID;
    }
    
    public void setJobID(int jobID) {
        this.jobID = jobID;
    }
    
    public LocalDateTime getSavedDate() {
        return savedDate;
    }
    
    public void setSavedDate(LocalDateTime savedDate) {
        this.savedDate = savedDate;
    }
    
    public String getJobTitle() {
        return jobTitle;
    }
    
    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }
    
    public String getCompanyName() {
        return companyName;
    }
    
    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
    
    public String getLocationName() {
        return locationName;
    }
    
    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }
    
    public String getSalaryRange() {
        return salaryRange;
    }
    
    public void setSalaryRange(String salaryRange) {
        this.salaryRange = salaryRange;
    }
    
    public String getIndustry() {
        return industry;
    }
    
    public void setIndustry(String industry) {
        this.industry = industry;
    }
    
    public String getPostingDate() {
        return postingDate;
    }
    
    public void setPostingDate(String postingDate) {
        this.postingDate = postingDate;
    }
    
    public String getFormattedSavedDate() {
        if (savedDate == null) return "";
        
        java.time.format.DateTimeFormatter formatter = 
            java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return savedDate.format(formatter);
    }
}
