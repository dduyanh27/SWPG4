package model;

public class JobSeeker {
    private int jobSeekerId;
    private String email;
    private String password;
    private String fullName;
    private String phone;
    private String gender;
    private String headline;
    private String contactInfo;
    private String address;
    private int locationId;
    private String img;
    private int currentLevelId;
    private String status;

    public JobSeeker() {
    }

    public JobSeeker(int jobSeekerId, String email, String password, String fullName, String phone, String gender, String headline, String contactInfo, String address, int locationId, String img, int currentLevelId, String status) {
        this.jobSeekerId = jobSeekerId;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.gender = gender;
        this.headline = headline;
        this.contactInfo = contactInfo;
        this.address = address;
        this.locationId = locationId;
        this.img = img;
        this.currentLevelId = currentLevelId;
        this.status = status;
    }
    
    // Constructor without ID (for new records)
    public JobSeeker(String email, String password, String fullName, String phone, 
                    String gender, String headline, String contactInfo, String address, 
                    Integer locationId, String img, Integer currentLevelId, String status) {
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.gender = gender;
        this.headline = headline;
        this.contactInfo = contactInfo;
        this.address = address;
        this.locationId = locationId;
        this.img = img;
        this.currentLevelId = currentLevelId;
        this.status = status;
    }

    public int getJobSeekerId() {
        return jobSeekerId;
    }

    public void setJobSeekerId(int jobSeekerId) {
        this.jobSeekerId = jobSeekerId;
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getHeadline() {
        return headline;
    }

    public void setHeadline(String headline) {
        this.headline = headline;
    }

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getLocationId() {
        return locationId;
    }

    public void setLocationId(int locationId) {
        this.locationId = locationId;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public int getCurrentLevelId() {
        return currentLevelId;
    }

    public void setCurrentLevelId(int currentLevelId) {
        this.currentLevelId = currentLevelId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    
    
}    