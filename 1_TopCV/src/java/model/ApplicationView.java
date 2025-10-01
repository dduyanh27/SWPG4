package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Model for displaying job application information with joined data
 */
public class ApplicationView {
    private int applicationID;
    private int jobID;
    private int cvID;
    private LocalDateTime applicationDate;
    private String status;
    
    // Job information
    private String jobTitle;
    private String jobType;
    private String salaryRange;
    private int recruiterID;
    
    // Company information
    private String companyName;
    private String industry;
    
    // Location information
    private String locationName;
    
    // CV information
    private String cvTitle;
    
    public ApplicationView() {}

    public ApplicationView(int applicationID, int jobID, int cvID, LocalDateTime applicationDate, 
                          String status, String jobTitle, String jobType, String salaryRange, 
                          int recruiterID, String companyName, String industry, 
                          String locationName, String cvTitle) {
        this.applicationID = applicationID;
        this.jobID = jobID;
        this.cvID = cvID;
        this.applicationDate = applicationDate;
        this.status = status;
        this.jobTitle = jobTitle;
        this.jobType = jobType;
        this.salaryRange = salaryRange;
        this.recruiterID = recruiterID;
        this.companyName = companyName;
        this.industry = industry;
        this.locationName = locationName;
        this.cvTitle = cvTitle;
    }

    // Getters and Setters
    public int getApplicationID() {
        return applicationID;
    }

    public void setApplicationID(int applicationID) {
        this.applicationID = applicationID;
    }

    public int getJobID() {
        return jobID;
    }

    public void setJobID(int jobID) {
        this.jobID = jobID;
    }

    public int getCvID() {
        return cvID;
    }

    public void setCvID(int cvID) {
        this.cvID = cvID;
    }

    public LocalDateTime getApplicationDate() {
        return applicationDate;
    }

    public void setApplicationDate(LocalDateTime applicationDate) {
        this.applicationDate = applicationDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getJobType() {
        return jobType;
    }

    public void setJobType(String jobType) {
        this.jobType = jobType;
    }

    public String getSalaryRange() {
        return salaryRange;
    }

    public void setSalaryRange(String salaryRange) {
        this.salaryRange = salaryRange;
    }

    public int getRecruiterID() {
        return recruiterID;
    }

    public void setRecruiterID(int recruiterID) {
        this.recruiterID = recruiterID;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getIndustry() {
        return industry;
    }

    public void setIndustry(String industry) {
        this.industry = industry;
    }

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }

    public String getCvTitle() {
        return cvTitle;
    }

    public void setCvTitle(String cvTitle) {
        this.cvTitle = cvTitle;
    }
    
    /**
     * Get formatted application date
     */
    public String getFormattedApplicationDate() {
        if (applicationDate != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            return applicationDate.format(formatter);
        }
        return "";
    }

    @Override
    public String toString() {
        return "ApplicationView{" +
                "applicationID=" + applicationID +
                ", jobID=" + jobID +
                ", cvID=" + cvID +
                ", applicationDate=" + applicationDate +
                ", status='" + status + '\'' +
                ", jobTitle='" + jobTitle + '\'' +
                ", jobType='" + jobType + '\'' +
                ", salaryRange='" + salaryRange + '\'' +
                ", recruiterID=" + recruiterID +
                ", companyName='" + companyName + '\'' +
                ", industry='" + industry + '\'' +
                ", locationName='" + locationName + '\'' +
                ", cvTitle='" + cvTitle + '\'' +
                '}';
    }
}