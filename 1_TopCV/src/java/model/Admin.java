package model;

public class Admin {
    private int adminID;
    private String email;
    private String password;
    private String fullName;
    private String status;

    public Admin() {
    }

    public Admin(int adminID, String email, String password, String fullName, String status) {
        this.adminID = adminID;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.status = status;
    }

    public int getAdminID() {
        return adminID;
    }

    public void setAdminID(int adminID) {
        this.adminID = adminID;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Admin{" +
                "adminID=" + adminID +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
