package model;

import java.time.LocalDateTime;

/**
 * Token entity for password reset functionality
 * @author ADMIN
 */
public class Token {
    private int id;
    private int userId;
    private String userType; // "admin", "jobseeker", "recruiter"
    private boolean isUsed;
    private String token;
    private LocalDateTime expiryTime;

    public Token() {
    }

    public Token(int id, int userId, String userType, boolean isUsed, String token, LocalDateTime expiryTime) {
        this.id = id;
        this.userId = userId;
        this.userType = userType;
        this.isUsed = isUsed;
        this.token = token;
        this.expiryTime = expiryTime;
    }

    public Token(int userId, String userType, boolean isUsed, String token, LocalDateTime expiryTime) {
        this.userId = userId;
        this.userType = userType;
        this.isUsed = isUsed;
        this.token = token;
        this.expiryTime = expiryTime;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public boolean isUsed() {
        return isUsed;
    }

    public void setUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public LocalDateTime getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(LocalDateTime expiryTime) {
        this.expiryTime = expiryTime;
    }

    @Override
    public String toString() {
        return "Token{" + 
                "id=" + id + 
                ", userId=" + userId + 
                ", userType='" + userType + '\'' +
                ", isUsed=" + isUsed + 
                ", token='" + token + '\'' + 
                ", expiryTime=" + expiryTime + 
                '}';
    }
}
