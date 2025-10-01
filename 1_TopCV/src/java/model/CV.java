package model;

import java.util.Date;

public class CV {
    private int cvId;
    private int jobSeekerId;
    private String cvTitle;
    private String cvContent;
    private String cvURL;
    private boolean isActive;
    private Date creationDate;

    public CV() {
    }

    public CV(int cvId, int jobSeekerId, String cvTitle, String cvContent, String cvURL, boolean isActive, Date creationDate) {
        this.cvId = cvId;
        this.jobSeekerId = jobSeekerId;
        this.cvTitle = cvTitle;
        this.cvContent = cvContent;
        this.cvURL = cvURL;
        this.isActive = isActive;
        this.creationDate = creationDate;
    }

    public int getCvId() {
        return cvId;
    }

    public void setCvId(int cvId) {
        this.cvId = cvId;
    }

    public int getJobSeekerId() {
        return jobSeekerId;
    }

    public void setJobSeekerId(int jobSeekerId) {
        this.jobSeekerId = jobSeekerId;
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

    public Date getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(Date creationDate) {
        this.creationDate = creationDate;
    }

    @Override
    public String toString() {
        return "CV{" +
                "cvId=" + cvId +
                ", jobSeekerId=" + jobSeekerId +
                ", cvTitle='" + cvTitle + '\'' +
                ", cvContent='" + cvContent + '\'' +
                ", cvURL='" + cvURL + '\'' +
                ", isActive=" + isActive +
                ", creationDate=" + creationDate +
                '}';
    }
}
