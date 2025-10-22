package model;

import java.util.Date;

/**
 * Model class để hiển thị thông tin CV kèm thông tin JobSeeker
 * Sử dụng cho trang admin-cv-management.jsp
 */
public class CVDetail {
    private int cvId;
    private int jobSeekerId;
    private String cvTitle;
    private String cvContent;
    private String cvFileURL;
    private String status;
    private Date createdAt;
    private int views;
    
    // Thông tin JobSeeker
    private String fullName;
    private String email;
    private String phone;
    private String avatarURL;
    private String desiredPosition;
    private String experience;
    private String location;
    private String skills;

    public CVDetail() {
    }

    public CVDetail(int cvId, int jobSeekerId, String cvTitle, String cvContent, 
                   String cvFileURL, String status, Date createdAt, int views,
                   String fullName, String email, String phone, String avatarURL,
                   String desiredPosition, String experience, String location, String skills) {
        this.cvId = cvId;
        this.jobSeekerId = jobSeekerId;
        this.cvTitle = cvTitle;
        this.cvContent = cvContent;
        this.cvFileURL = cvFileURL;
        this.status = status;
        this.createdAt = createdAt;
        this.views = views;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.avatarURL = avatarURL;
        this.desiredPosition = desiredPosition;
        this.experience = experience;
        this.location = location;
        this.skills = skills;
    }

    // Getters and Setters
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

    public String getCvFileURL() {
        return cvFileURL;
    }

    public void setCvFileURL(String cvFileURL) {
        this.cvFileURL = cvFileURL;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatarURL() {
        return avatarURL;
    }

    public void setAvatarURL(String avatarURL) {
        this.avatarURL = avatarURL;
    }

    public String getDesiredPosition() {
        return desiredPosition;
    }

    public void setDesiredPosition(String desiredPosition) {
        this.desiredPosition = desiredPosition;
    }

    public String getExperience() {
        return experience;
    }

    public void setExperience(String experience) {
        this.experience = experience;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getSkills() {
        return skills;
    }

    public void setSkills(String skills) {
        this.skills = skills;
    }

    @Override
    public String toString() {
        return "CVDetail{" +
                "cvId=" + cvId +
                ", jobSeekerId=" + jobSeekerId +
                ", cvTitle='" + cvTitle + '\'' +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
