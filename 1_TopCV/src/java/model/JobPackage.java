package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model class representing a Job Package (Gói dịch vụ)
 */
public class JobPackage {
    private int packageID;
    private String packageName;
    private String packageType;  // 'DANG_TUYEN', 'TIM_HO_SO', etc.
    private String description;
    private BigDecimal price;
    private Integer duration;    // Số ngày hiệu lực
    private Integer points;      // Dành cho gói tìm hồ sơ
    private String features;     // JSON string
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Parsed fields from JSON features
    private String level;        // "gold", "silver", "bronze"
    private boolean featured;
    private boolean highlight;
    private boolean webPriority;
    private int posts;
    
    // Constructors
    public JobPackage() {
    }
    
    public JobPackage(int packageID, String packageName, String packageType, 
                      String description, BigDecimal price, Integer duration, 
                      Integer points, String features, boolean isActive) {
        this.packageID = packageID;
        this.packageName = packageName;
        this.packageType = packageType;
        this.description = description;
        this.price = price;
        this.duration = duration;
        this.points = points;
        this.features = features;
        this.isActive = isActive;
        parseFeatures();
    }
    
    /**
     * Parse JSON features string to extract key properties
     */
    private void parseFeatures() {
        if (features != null && !features.isEmpty()) {
            // Simple JSON parsing (for production, consider using a JSON library)
            this.level = extractJsonValue(features, "level");
            this.featured = features.contains("\"featured\": true");
            this.highlight = features.contains("\"highlight\": true");
            this.webPriority = features.contains("\"web_priority\": true");
            
            String postsStr = extractJsonValue(features, "posts");
            this.posts = postsStr != null ? Integer.parseInt(postsStr) : 0;
        }
    }
    
    /**
     * Extract value from simple JSON string
     */
    private String extractJsonValue(String json, String key) {
        String pattern = "\"" + key + "\":\\s*\"?([^,}\"]+)\"?";
        java.util.regex.Pattern p = java.util.regex.Pattern.compile(pattern);
        java.util.regex.Matcher m = p.matcher(json);
        if (m.find()) {
            return m.group(1).trim();
        }
        return null;
    }
    
    // Getters and Setters
    public int getPackageID() {
        return packageID;
    }
    
    public void setPackageID(int packageID) {
        this.packageID = packageID;
    }
    
    public String getPackageName() {
        return packageName;
    }
    
    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }
    
    public String getPackageType() {
        return packageType;
    }
    
    public void setPackageType(String packageType) {
        this.packageType = packageType;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public Integer getDuration() {
        return duration;
    }
    
    public void setDuration(Integer duration) {
        this.duration = duration;
    }
    
    public Integer getPoints() {
        return points;
    }
    
    public void setPoints(Integer points) {
        this.points = points;
    }
    
    public String getFeatures() {
        return features;
    }
    
    public void setFeatures(String features) {
        this.features = features;
        parseFeatures(); // Re-parse when features are updated
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Parsed feature getters
    public String getLevel() {
        return level;
    }
    
    public void setLevel(String level) {
        this.level = level;
    }
    
    public boolean isFeatured() {
        return featured;
    }
    
    public void setFeatured(boolean featured) {
        this.featured = featured;
    }
    
    public boolean isHighlight() {
        return highlight;
    }
    
    public void setHighlight(boolean highlight) {
        this.highlight = highlight;
    }
    
    public boolean isWebPriority() {
        return webPriority;
    }
    
    public void setWebPriority(boolean webPriority) {
        this.webPriority = webPriority;
    }
    
    public int getPosts() {
        return posts;
    }
    
    public void setPosts(int posts) {
        this.posts = posts;
    }
    
    @Override
    public String toString() {
        return "JobPackage{" +
                "packageID=" + packageID +
                ", packageName='" + packageName + '\'' +
                ", level='" + level + '\'' +
                ", price=" + price +
                ", duration=" + duration +
                ", featured=" + featured +
                '}';
    }
}
