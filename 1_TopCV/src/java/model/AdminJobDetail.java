package model;

public class AdminJobDetail {
    private int jobId;
    private String jobTitle;
    private String requirements;
    private String salaryRange;
    private String recruiterName;
    private String categoryName;
    private String locationName;
    private String status;

    public AdminJobDetail() {
    }
    
    

    public AdminJobDetail(int jobId, String jobTitle, String requirements, String salaryRange,
                          String recruiterName, String categoryName, String locationName, String status) {
        this.jobId = jobId;
        this.jobTitle = jobTitle;
        this.requirements = requirements;
        this.salaryRange = salaryRange;
        this.recruiterName = recruiterName;
        this.categoryName = categoryName;
        this.locationName = locationName;
        this.status = status;
    }

    // Getter & Setter
    public int getJobId() { return jobId; }
    public void setJobId(int jobId) { this.jobId = jobId; }

    public String getJobTitle() { return jobTitle; }
    public void setJobTitle(String jobTitle) { this.jobTitle = jobTitle; }

    public String getRequirements() { return requirements; }
    public void setRequirements(String requirements) { this.requirements = requirements; }

    public String getSalaryRange() { return salaryRange; }
    public void setSalaryRange(String salaryRange) { this.salaryRange = salaryRange; }

    public String getRecruiterName() { return recruiterName; }
    public void setRecruiterName(String recruiterName) { this.recruiterName = recruiterName; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getLocationName() { return locationName; }
    public void setLocationName(String locationName) { this.locationName = locationName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
