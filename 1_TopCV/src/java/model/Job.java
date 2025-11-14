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
    private int hiringCount;
    private int viewCount;
    private boolean isUrgent;
    private boolean isPriority;
    private LocalDateTime priorityExpiryDate;
    private String contactPerson;
    private String applicationEmail;
    private Integer minExperience;
    private String minQualification;
    private String nationality;
    private String gender;
    private String maritalStatus;
    private Integer ageMin;
    private Integer ageMax;
    private String jobCode;
    private Integer certificatesID;

    public Job() {}

    public Job(int jobID, int recruiterID, String jobTitle, String description, String requirements, int jobLevelID, int locationID, String salaryRange, LocalDateTime postingDate, LocalDateTime expirationDate, int categoryID, int ageRequirement, String status, int jobTypeID, int hiringCount) {
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
        this.hiringCount = hiringCount;
    }
    
    

    public Job(int jobID, int recruiterID, String jobTitle, String description, String requirements,
               int jobLevelID, String salaryRange, LocalDateTime postingDate,
               LocalDateTime expirationDate, int categoryID, int ageRequirement, String status,
               int jobTypeID, int hiringCount) {
        this.jobID = jobID;
        this.recruiterID = recruiterID;
        this.jobTitle = jobTitle;
        this.description = description;
        this.requirements = requirements;
        this.jobLevelID = jobLevelID;
        this.salaryRange = salaryRange;
        this.postingDate = postingDate;
        this.expirationDate = expirationDate;
        this.categoryID = categoryID;
        this.ageRequirement = ageRequirement;
        this.status = status;
        this.jobTypeID = jobTypeID;
        this.hiringCount = hiringCount;
    }

    // Getters and Setters
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

    public int getHiringCount() {
        return hiringCount;
    }

    public void setHiringCount(int hiringCount) {
        this.hiringCount = hiringCount;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

    public boolean isIsUrgent() {
        return isUrgent;
    }

    public void setIsUrgent(boolean isUrgent) {
        this.isUrgent = isUrgent;
    }

    public boolean isIsPriority() {
        return isPriority;
    }

    public void setIsPriority(boolean isPriority) {
        this.isPriority = isPriority;
    }

    public LocalDateTime getPriorityExpiryDate() {
        return priorityExpiryDate;
    }

    public void setPriorityExpiryDate(LocalDateTime priorityExpiryDate) {
        this.priorityExpiryDate = priorityExpiryDate;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public String getApplicationEmail() {
        return applicationEmail;
    }

    public void setApplicationEmail(String applicationEmail) {
        this.applicationEmail = applicationEmail;
    }

    public Integer getMinExperience() {
        return minExperience;
    }

    public void setMinExperience(Integer minExperience) {
        this.minExperience = minExperience;
    }

    public String getMinQualification() {
        return minQualification;
    }

    public void setMinQualification(String minQualification) {
        this.minQualification = minQualification;
    }

    public String getNationality() {
        return nationality;
    }

    public void setNationality(String nationality) {
        this.nationality = nationality;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getMaritalStatus() {
        return maritalStatus;
    }

    public void setMaritalStatus(String maritalStatus) {
        this.maritalStatus = maritalStatus;
    }

    public Integer getAgeMin() {
        return ageMin;
    }

    public void setAgeMin(Integer ageMin) {
        this.ageMin = ageMin;
    }

    public Integer getAgeMax() {
        return ageMax;
    }

    public void setAgeMax(Integer ageMax) {
        this.ageMax = ageMax;
    }

    public String getJobCode() {
        return jobCode;
    }

    public void setJobCode(String jobCode) {
        this.jobCode = jobCode;
    }

    public Integer getCertificatesID() {
        return certificatesID;
    }

    public void setCertificatesID(Integer certificatesID) {
        this.certificatesID = certificatesID;
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
                ", salaryRange='" + salaryRange + '\'' +
                ", postingDate=" + postingDate +
                ", expirationDate=" + expirationDate +
                ", categoryID=" + categoryID +
                ", ageRequirement=" + ageRequirement +
                ", status='" + status + '\'' +
                ", jobTypeID=" + jobTypeID +
                ", hiringCount=" + hiringCount +
                ", viewCount=" + viewCount +
                ", isUrgent=" + isUrgent +
                ", isPriority=" + isPriority +
                ", priorityExpiryDate=" + priorityExpiryDate +
                ", contactPerson='" + contactPerson + '\'' +
                ", applicationEmail='" + applicationEmail + '\'' +
                ", minExperience=" + minExperience +
                ", minQualification='" + minQualification + '\'' +
                ", nationality='" + nationality + '\'' +
                ", gender='" + gender + '\'' +
                ", maritalStatus='" + maritalStatus + '\'' +
                ", ageMin=" + ageMin +
                ", ageMax=" + ageMax +
                ", jobCode='" + jobCode + '\'' +
                '}';
    }
}
