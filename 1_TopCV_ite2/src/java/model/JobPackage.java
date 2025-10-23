package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class JobPackage {
    private int packageID;
    private String packageName;
    private String packageType;
    private String description;
    private BigDecimal price;
    private Integer duration;
    private Integer points;
    private String features;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public JobPackage() {}

    public JobPackage(int packageID, String packageName, String packageType, String description,
                      BigDecimal price, Integer duration, Integer points, String features,
                      Boolean isActive, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.packageID = packageID;
        this.packageName = packageName;
        this.packageType = packageType;
        this.description = description;
        this.price = price;
        this.duration = duration;
        this.points = points;
        this.features = features;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

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
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "JobPackage{" +
                "packageID=" + packageID +
                ", packageName='" + packageName + '\'' +
                ", packageType='" + packageType + '\'' +
                ", price=" + price +
                '}';
    }
}


