package model;

import java.time.LocalDateTime;

public class Application {
    private int applicationID;
    private int jobID;
    private int cvID;
    private LocalDateTime applicationDate;
    private String status;

    public Application() {}

    public Application(int applicationID, int jobID, int cvID, LocalDateTime applicationDate, String status) {
        this.applicationID = applicationID;
        this.jobID = jobID;
        this.cvID = cvID;
        this.applicationDate = applicationDate;
        this.status = status;
    }

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

    @Override
    public String toString() {
        return "Application{" +
                "applicationID=" + applicationID +
                ", jobID=" + jobID +
                ", cvID=" + cvID +
                ", applicationDate=" + applicationDate +
                ", status='" + status + '\'' +
                '}';
    }
}
