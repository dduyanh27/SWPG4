package model;

import java.time.LocalDateTime;

public class JobFeatureMappings {
    private int jobFeatureMapID;
    private int jobID;
    private int recruiterPackageID;
    private String featureType;
    private LocalDateTime appliedDate;
    private LocalDateTime expireDate;

    public JobFeatureMappings() {}

    public JobFeatureMappings(int jobFeatureMapID, int jobID, int recruiterPackageID,
                             String featureType, LocalDateTime appliedDate, LocalDateTime expireDate) {
        this.jobFeatureMapID = jobFeatureMapID;
        this.jobID = jobID;
        this.recruiterPackageID = recruiterPackageID;
        this.featureType = featureType;
        this.appliedDate = appliedDate;
        this.expireDate = expireDate;
    }

    // Getters and Setters
    public int getJobFeatureMapID() {
        return jobFeatureMapID;
    }

    public void setJobFeatureMapID(int jobFeatureMapID) {
        this.jobFeatureMapID = jobFeatureMapID;
    }

    public int getJobID() {
        return jobID;
    }

    public void setJobID(int jobID) {
        this.jobID = jobID;
    }

    public int getRecruiterPackageID() {
        return recruiterPackageID;
    }

    public void setRecruiterPackageID(int recruiterPackageID) {
        this.recruiterPackageID = recruiterPackageID;
    }

    public String getFeatureType() {
        return featureType;
    }

    public void setFeatureType(String featureType) {
        this.featureType = featureType;
    }

    public LocalDateTime getAppliedDate() {
        return appliedDate;
    }

    public void setAppliedDate(LocalDateTime appliedDate) {
        this.appliedDate = appliedDate;
    }

    public LocalDateTime getExpireDate() {
        return expireDate;
    }

    public void setExpireDate(LocalDateTime expireDate) {
        this.expireDate = expireDate;
    }

    @Override
    public String toString() {
        return "JobFeatureMappings{" +
                "jobFeatureMapID=" + jobFeatureMapID +
                ", jobID=" + jobID +
                ", recruiterPackageID=" + recruiterPackageID +
                ", featureType='" + featureType + '\'' +
                ", appliedDate=" + appliedDate +
                ", expireDate=" + expireDate +
                '}';
    }
}
