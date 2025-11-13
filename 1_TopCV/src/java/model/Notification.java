package model;

import java.time.LocalDateTime;

public class Notification {
    private int notificationID;
    private int userID;
    private String userType; // jobseeker, recruiter, admin, staff
    private String notificationType; // application, profile, job, chat, system, payment
    private String title;
    private String message;
    private Integer relatedID;
    private String relatedType; // job, application, user, payment, etc.
    private boolean isRead;
    private LocalDateTime createdAt;
    private LocalDateTime readAt;
    private String iconType; // application, profile, system, chat
    private int priority; // 0=low, 1=medium, 2=high
    private String actionURL;

    // Constructors
    public Notification() {
    }

    public Notification(int notificationID, int userID, String userType, String notificationType,
                       String title, String message, Integer relatedID, String relatedType,
                       boolean isRead, LocalDateTime createdAt, LocalDateTime readAt,
                       String iconType, int priority, String actionURL) {
        this.notificationID = notificationID;
        this.userID = userID;
        this.userType = userType;
        this.notificationType = notificationType;
        this.title = title;
        this.message = message;
        this.relatedID = relatedID;
        this.relatedType = relatedType;
        this.isRead = isRead;
        this.createdAt = createdAt;
        this.readAt = readAt;
        this.iconType = iconType;
        this.priority = priority;
        this.actionURL = actionURL;
    }

    // Getters and Setters
    public int getNotificationID() {
        return notificationID;
    }

    public void setNotificationID(int notificationID) {
        this.notificationID = notificationID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getNotificationType() {
        return notificationType;
    }

    public void setNotificationType(String notificationType) {
        this.notificationType = notificationType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Integer getRelatedID() {
        return relatedID;
    }

    public void setRelatedID(Integer relatedID) {
        this.relatedID = relatedID;
    }

    public String getRelatedType() {
        return relatedType;
    }

    public void setRelatedType(String relatedType) {
        this.relatedType = relatedType;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getReadAt() {
        return readAt;
    }

    public void setReadAt(LocalDateTime readAt) {
        this.readAt = readAt;
    }

    public String getIconType() {
        return iconType;
    }

    public void setIconType(String iconType) {
        this.iconType = iconType;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public String getActionURL() {
        return actionURL;
    }

    public void setActionURL(String actionURL) {
        this.actionURL = actionURL;
    }

    @Override
    public String toString() {
        return "Notification{" +
                "notificationID=" + notificationID +
                ", userID=" + userID +
                ", userType='" + userType + '\'' +
                ", notificationType='" + notificationType + '\'' +
                ", title='" + title + '\'' +
                ", isRead=" + isRead +
                ", createdAt=" + createdAt +
                '}';
    }
}
