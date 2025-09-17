package model;

public class Recruiter {
    private int recruiterID;
    private String email;
    private String password;
    private String status;

    public Recruiter() {
    }

    public Recruiter(int recruiterID, String email, String password, String status) {
        this.recruiterID = recruiterID;
        this.email = email;
        this.password = password;
        this.status = status;
    }

    public int getRecruiterID() {
        return recruiterID;
    }

    public void setRecruiterID(int recruiterID) {
        this.recruiterID = recruiterID;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Recruiter{" +
                "recruiterID=" + recruiterID +
                ", email='" + email + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
