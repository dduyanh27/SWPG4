package model;

public class ProfileSkill {
    private int jobSeekerID;
    private int skillID;

    public ProfileSkill() {}

    public ProfileSkill(int jobSeekerID, int skillID) {
        this.jobSeekerID = jobSeekerID;
        this.skillID = skillID;
    }

    public int getJobSeekerID() {
        return jobSeekerID;
    }

    public void setJobSeekerID(int jobSeekerID) {
        this.jobSeekerID = jobSeekerID;
    }

    public int getSkillID() {
        return skillID;
    }

    public void setSkillID(int skillID) {
        this.skillID = skillID;
    }

    @Override
    public String toString() {
        return "ProfileSkill{" +
                "jobSeekerID=" + jobSeekerID +
                ", skillID=" + skillID +
                '}';
    }
}
