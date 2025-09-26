package model;

import java.sql.Date;
import java.sql.Timestamp;

public class Admin {
    private int adminId;
    private String email;
    private String password;
    private String fullName;
    private String avatarURL;
    private String phone;
    private String gender;
    private String address;
    private Date dateOfBirth;           // tương ứng với DATE trong DB
    private String bio;
    private Timestamp createdAt;       // tương ứng với DATETIME trong DB
    private Timestamp updatedAt;
    private String status;

    public Admin() {}

    public Admin(String email, String password, String fullName, String phone) {
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
    }
    
    

    // Constructor đầy đủ (phù hợp với AdminDAO)
    public Admin(int adminId, String email, String password, String fullName,
                 String avatarURL, String phone, String gender, String address,
                 Date dateOfBirth, String bio, Timestamp createdAt,
                 Timestamp updatedAt, String status) {
        this.adminId = adminId;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.avatarURL = avatarURL;
        this.phone = phone;
        this.gender = gender;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
        this.bio = bio;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.status = status;
    }

    // Optional: constructor rút gọn dùng cho login/list
    public Admin(int adminId, String email, String password, String fullName, String status) {
        this.adminId = adminId;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.status = status;
    }

    // Getters & setters
    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }

    // helper duplicate getter to be safe in JSPs using 'id'
    public int getId() { return adminId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getAvatarURL() { return avatarURL; }
    public void setAvatarURL(String avatarURL) { this.avatarURL = avatarURL; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Admin{" +
                "adminId=" + adminId +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", phone='" + phone + '\'' +
                ", gender='" + gender + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
