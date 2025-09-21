package model;

import java.time.LocalDateTime;

public class CV {
    private int cvID;
    private int jobSeekerID;
    private String cvTitle;
    private String cvContent;
    private String cvURL;
    private boolean isActive;
    private LocalDateTime creationDate;

    public CV() {}

    public CV(int cvID, int jobSeekerID, String cvTitle, String cvContent, 
              String cvURL, boolean isActive, LocalDateTime creationDate) {
        this.cvID = cvID;
        this.jobSeekerID = jobSeekerID;
        this.cvTitle = cvTitle;
        this.cvContent = cvContent;
        this.cvURL = cvURL;
        this.isActive = isActive;
        this.creationDate = creationDate;
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

    public String getCvTitle() {
        return cvTitle;
    }

    public void setCvTitle(String cvTitle) {
        this.cvTitle = cvTitle;
    }

    public String getCvContent() {
        return cvContent;
    }

    public void setCvContent(String cvContent) {
        this.cvContent = cvContent;
    }

    public String getCvURL() {
        return cvURL;
    }

    public void setCvURL(String cvURL) {
        this.cvURL = cvURL;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public LocalDateTime getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(LocalDateTime creationDate) {
        this.creationDate = creationDate;
    }

    @Override
    public String toString() {
        return "CV{" +
                "cvID=" + cvID +
                ", jobSeekerID=" + jobSeekerID +
                ", cvTitle='" + cvTitle + '\'' +
                ", cvContent='" + cvContent + '\'' +
                ", cvURL='" + cvURL + '\'' +
                ", isActive=" + isActive +
                ", creationDate=" + creationDate +
                '}';
    }
}
