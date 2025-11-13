package model;

import java.time.LocalDateTime;

/**
 * Model for candidate application view in recruiter's candidate management page
 */
public class CandidateApplication {
    private int applicationID;
    private int jobID;
    private int cvID;
    private int jobSeekerID;
    private LocalDateTime applicationDate;
    private String status;
    
    // Candidate information
    private String candidateName;
    private String candidateEmail;
    private String candidatePhone;
    private int experienceYears; // Năm kinh nghiệm
    private double rating; // Rating của ứng viên
    
    // CV information
    private String cvTitle;
    
    // Job information
    private String jobTitle;
    
    // Additional tags (có thể parse từ CV hoặc Job requirements)
    private String tags; // JSON string hoặc comma-separated
    
    public CandidateApplication() {}

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

    public int getJobSeekerID() {
        return jobSeekerID;
    }

    public void setJobSeekerID(int jobSeekerID) {
        this.jobSeekerID = jobSeekerID;
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

    public String getCandidateName() {
        return candidateName;
    }

    public void setCandidateName(String candidateName) {
        this.candidateName = candidateName;
    }

    public String getCandidateEmail() {
        return candidateEmail;
    }

    public void setCandidateEmail(String candidateEmail) {
        this.candidateEmail = candidateEmail;
    }

    public String getCandidatePhone() {
        return candidatePhone;
    }

    public void setCandidatePhone(String candidatePhone) {
        this.candidatePhone = candidatePhone;
    }

    public int getExperienceYears() {
        return experienceYears;
    }

    public void setExperienceYears(int experienceYears) {
        this.experienceYears = experienceYears;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getCvTitle() {
        return cvTitle;
    }

    public void setCvTitle(String cvTitle) {
        this.cvTitle = cvTitle;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }
    
    /**
     * Get formatted application date
     */
    public String getFormattedApplicationDate() {
        if (applicationDate != null) {
            return applicationDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return "";
    }
}

