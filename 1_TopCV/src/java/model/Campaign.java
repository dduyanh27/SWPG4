package model;

import java.sql.Date;
import java.sql.Timestamp;
import java.math.BigDecimal;

public class Campaign {
    private int campaignID;
    private String campaignName;
    private String targetType;
    private String platform;
    private BigDecimal budget;
    private Date startDate;
    private Date endDate;
    private String status;
    private String description;
    private int createdBy;
    private Timestamp createdAt;
    
    // For display purposes
    private String creatorName;

    // Default constructor
    public Campaign() {
    }

    // Constructor with all fields
    public Campaign(int campaignID, String campaignName, String targetType, String platform,
                   BigDecimal budget, Date startDate, Date endDate, String status, 
                   String description, int createdBy, Timestamp createdAt) {
        this.campaignID = campaignID;
        this.campaignName = campaignName;
        this.targetType = targetType;
        this.platform = platform;
        this.budget = budget;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.description = description;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getCampaignID() {
        return campaignID;
    }

    public void setCampaignID(int campaignID) {
        this.campaignID = campaignID;
    }

    public String getCampaignName() {
        return campaignName;
    }

    public void setCampaignName(String campaignName) {
        this.campaignName = campaignName;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public BigDecimal getBudget() {
        return budget;
    }

    public void setBudget(BigDecimal budget) {
        this.budget = budget;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCreatorName() {
        return creatorName;
    }

    public void setCreatorName(String creatorName) {
        this.creatorName = creatorName;
    }

    @Override
    public String toString() {
        return "Campaign{" +
                "campaignID=" + campaignID +
                ", campaignName='" + campaignName + '\'' +
                ", targetType='" + targetType + '\'' +
                ", platform='" + platform + '\'' +
                ", budget=" + budget +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", status='" + status + '\'' +
                ", description='" + description + '\'' +
                ", createdBy=" + createdBy +
                ", createdAt=" + createdAt +
                ", creatorName='" + creatorName + '\'' +
                '}';
    }
}