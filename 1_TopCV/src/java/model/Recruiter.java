package model;

public class Recruiter {
    private int recruiterId;
    private String email;
    private String password;
    private String phone;
    private String gender;
    private String companyName;
    private String companyDescription;
    private String companyLogoURL;
    private String website;
    private String img;
    private int categoryId;
    private String status;

    // Constructor
    public Recruiter() {}

    public Recruiter(String email, String password, String phone, String companyName) {
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.companyName = companyName;
    }
    
    

    public Recruiter(int recruiterId, String email, String password, String phone, String gender,
                     String companyName, String companyDescription, String companyLogoURL,
                     String website, String img, int categoryId, String status) {
        this.recruiterId = recruiterId;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.gender = gender;
        this.companyName = companyName;
        this.companyDescription = companyDescription;
        this.companyLogoURL = companyLogoURL;
        this.website = website;
        this.img = img;
        this.categoryId = categoryId;
        this.status = status;
    }

    public int getRecruiterId() {
        return recruiterId;
    }

    public void setRecruiterId(int recruiterId) {
        this.recruiterId = recruiterId;
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

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyDescription() {
        return companyDescription;
    }

    public void setCompanyDescription(String companyDescription) {
        this.companyDescription = companyDescription;
    }

    public String getCompanyLogoURL() {
        return companyLogoURL;
    }

    public void setCompanyLogoURL(String companyLogoURL) {
        this.companyLogoURL = companyLogoURL;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Recruiter{" + "recruiterId=" + recruiterId + ", email=" + email + ", password=" + password + ", phone=" + phone + ", gender=" + gender + ", companyName=" + companyName + ", companyDescription=" + companyDescription + ", companyLogoURL=" + companyLogoURL + ", website=" + website + ", img=" + img + ", categoryId=" + categoryId + ", status=" + status + '}';
    }

    
}
