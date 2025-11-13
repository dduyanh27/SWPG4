package model;

public class Recruiter {
    private int recruiterID;
    private String email;
    private String password;
    private String phone;
    private String companyName;
    private String companyDescription;
    private String companyLogoURL;
    private String website;
    private String img;
    private int categoryID;
    private String status;
    private String companyAddress;
    private String companySize;
    private String contactPerson;
    private String companyBenefits;
    private String companyVideoURL;
    private String taxcode;
    private String registrationCert;
    private int jobCount; // Số lượng job đang tuyển

    public Recruiter() {
    }

    public Recruiter(int recruiterID, String companyName) {
        this.recruiterID = recruiterID;
        this.companyName = companyName;
    }
    
    

    public Recruiter(int recruiterID, String email, String password, String phone, 
                     String companyName, String companyDescription, 
                     String companyLogoURL, String website, String img, int categoryID, 
                     String status, String companyAddress, String companySize, 
                     String contactPerson, String companyBenefits, String companyVideoURL,
                     String taxcode, String registrationCert) {
        this.recruiterID = recruiterID;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.companyName = companyName;
        this.companyDescription = companyDescription;
        this.companyLogoURL = companyLogoURL;
        this.website = website;
        this.img = img;
        this.categoryID = categoryID;
        this.status = status;
        this.companyAddress = companyAddress;
        this.companySize = companySize;
        this.contactPerson = contactPerson;
        this.companyBenefits = companyBenefits;
        this.companyVideoURL = companyVideoURL;
        this.taxcode = taxcode;
        this.registrationCert = registrationCert;
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
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

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getCompanyAddress() {
        return companyAddress;
    }

    public void setCompanyAddress(String companyAddress) {
        this.companyAddress = companyAddress;
    }

    public String getCompanySize() {
        return companySize;
    }

    public void setCompanySize(String companySize) {
        this.companySize = companySize;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public String getCompanyBenefits() {
        return companyBenefits;
    }

    public void setCompanyBenefits(String companyBenefits) {
        this.companyBenefits = companyBenefits;
    }

    public String getCompanyVideoURL() {
        return companyVideoURL;
    }

    public void setCompanyVideoURL(String companyVideoURL) {
        this.companyVideoURL = companyVideoURL;
    }

    public String getTaxcode() {
        return taxcode;
    }

    public void setTaxcode(String taxcode) {
        this.taxcode = taxcode;
    }

    public String getRegistrationCert() {
        return registrationCert;
    }

    public void setRegistrationCert(String registrationCert) {
        this.registrationCert = registrationCert;
    }

    public int getJobCount() {
        return jobCount;
    }

    public void setJobCount(int jobCount) {
        this.jobCount = jobCount;
    }

    @Override
    public String toString() {
        return "Recruiter{" +
                "recruiterID=" + recruiterID +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", companyName='" + companyName + '\'' +
                ", companyDescription='" + companyDescription + '\'' +
                ", companyLogoURL='" + companyLogoURL + '\'' +
                ", website='" + website + '\'' +
                ", img='" + img + '\'' +
                ", categoryID=" + categoryID +
                ", status='" + status + '\'' +
                ", companyAddress='" + companyAddress + '\'' +
                ", companySize='" + companySize + '\'' +
                ", contactPerson='" + contactPerson + '\'' +
                ", companyBenefits='" + companyBenefits + '\'' +
                ", companyVideoURL='" + companyVideoURL + '\'' +
                ", taxcode='" + taxcode + '\'' +
                ", registrationCert='" + registrationCert + '\'' +
                '}';
    }
}
