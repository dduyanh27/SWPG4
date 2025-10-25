package model;

import java.sql.Timestamp;

public class MarketingContent {
    private int contentID;
    private int campaignID;
    private String title;
    private String contentText;
    private String mediaURL;
    private Timestamp postDate;
    private String platform;
    private String status;
    private int createdBy;
    private int viewCount;
    
    // For display purposes - joining with other tables
    private String campaignName;
    private String creatorName;

    // Default constructor
    public MarketingContent() {
    }

    // Constructor with all fields
    public MarketingContent(int contentID, int campaignID, String title, String contentText, 
                           String mediaURL, Timestamp postDate, String platform, 
                           String status, int createdBy, int viewCount) {
        this.contentID = contentID;
        this.campaignID = campaignID;
        this.title = title;
        this.contentText = contentText;
        this.mediaURL = mediaURL;
        this.postDate = postDate;
        this.platform = platform;
        this.status = status;
        this.createdBy = createdBy;
        this.viewCount = viewCount;
    }

    // Constructor without contentID (for insert)
    public MarketingContent(int campaignID, String title, String contentText, 
                           String mediaURL, Timestamp postDate, String platform, 
                           String status, int createdBy) {
        this.campaignID = campaignID;
        this.title = title;
        this.contentText = contentText;
        this.mediaURL = mediaURL;
        this.postDate = postDate;
        this.platform = platform;
        this.status = status;
        this.createdBy = createdBy;
        this.viewCount = 0;
    }

    // Getters and Setters
    public int getContentID() {
        return contentID;
    }

    public void setContentID(int contentID) {
        this.contentID = contentID;
    }

    public int getCampaignID() {
        return campaignID;
    }

    public void setCampaignID(int campaignID) {
        this.campaignID = campaignID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContentText() {
        return contentText;
    }

    public void setContentText(String contentText) {
        this.contentText = contentText;
    }

    public String getMediaURL() {
        return mediaURL;
    }

    public void setMediaURL(String mediaURL) {
        this.mediaURL = mediaURL;
    }

    public Timestamp getPostDate() {
        return postDate;
    }

    public void setPostDate(Timestamp postDate) {
        this.postDate = postDate;
    }

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

    public String getCampaignName() {
        return campaignName;
    }

    public void setCampaignName(String campaignName) {
        this.campaignName = campaignName;
    }

    public String getCreatorName() {
        return creatorName;
    }

    public void setCreatorName(String creatorName) {
        this.creatorName = creatorName;
    }

    @Override
    public String toString() {
        return "MarketingContent{" +
                "contentID=" + contentID +
                ", campaignID=" + campaignID +
                ", title='" + title + '\'' +
                ", contentText='" + contentText + '\'' +
                ", mediaURL='" + mediaURL + '\'' +
                ", postDate=" + postDate +
                ", platform='" + platform + '\'' +
                ", status='" + status + '\'' +
                ", createdBy=" + createdBy +
                ", viewCount=" + viewCount +
                ", campaignName='" + campaignName + '\'' +
                ", creatorName='" + creatorName + '\'' +
                '}';
    }
}