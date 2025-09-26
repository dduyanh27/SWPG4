package model;

public class TopcvUser {
    private int topcvId;
    private String fullName;
    private String phoneNumber;
    private String password;
    private int createdByAdminId;
    private String status;

    public TopcvUser() {}

    public TopcvUser(int topcvId, String fullName, String phoneNumber, String password,
                     int createdByAdminId, String status) {
        this.topcvId = topcvId;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.createdByAdminId = createdByAdminId;
        this.status = status;
    }

    // Getters & Setters
    public int getTopcvId() {
        return topcvId;
    }

    public void setTopcvId(int topcvId) {
        this.topcvId = topcvId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getCreatedByAdminId() {
        return createdByAdminId;
    }

    public void setCreatedByAdminId(int createdByAdminId) {
        this.createdByAdminId = createdByAdminId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "TopcvUser{" +
                "topcvId=" + topcvId +
                ", fullName='" + fullName + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
