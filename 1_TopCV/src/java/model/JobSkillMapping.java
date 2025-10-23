package model;

public class JobSkillMapping {
    private int jobID;
    private int skillID;

    public JobSkillMapping() {}

    public JobSkillMapping(int jobID, int skillID) {
        this.jobID = jobID;
        this.skillID = skillID;
    }

    public int getJobID() {
        return jobID;
    }

    public void setJobID(int jobID) {
        this.jobID = jobID;
    }

    public int getSkillID() {
        return skillID;
    }

    public void setSkillID(int skillID) {
        this.skillID = skillID;
    }

    @Override
    public String toString() {
        return "JobSkillMapping{" +
                "jobID=" + jobID +
                ", skillID=" + skillID +
                '}';
    }
}
