package model;

public class JobSeeker {
    private int jobSeekerID;
    private String email;
    private String password;
    private String status;

    public JobSeeker() {
    }

    public JobSeeker(int jobSeekerID, String email, String password, String status) {
        this.jobSeekerID = jobSeekerID;
        this.email = email;
        this.password = password;
        this.status = status;
    }

    public int getJobSeekerID() {
        return jobSeekerID;
    }

    public void setJobSeekerID(int jobSeekerID) {
        this.jobSeekerID = jobSeekerID;
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
        return "JobSeeker{" +
                "jobSeekerID=" + jobSeekerID +
                ", email='" + email + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
