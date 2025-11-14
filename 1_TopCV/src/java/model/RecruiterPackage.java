package model;

import java.sql.Timestamp;

/**
 * Model class representing a Recruiter's purchased package
 */
public class RecruiterPackage {
    private int recruiterPackageID;
    private int recruiterID;
    private int packageID;
    private int quantity;
    private int usedQuantity;
    private Timestamp purchaseDate;
    private Timestamp expiryDate;
    private boolean isUsed;
    
    // Joined data from related tables
    private JobPackage jobPackage;  // Package details
    
    // Constructors
    public RecruiterPackage() {
    }
    
    public RecruiterPackage(int recruiterPackageID, int recruiterID, int packageID, 
                           int quantity, int usedQuantity, Timestamp purchaseDate, 
                           Timestamp expiryDate, boolean isUsed) {
        this.recruiterPackageID = recruiterPackageID;
        this.recruiterID = recruiterID;
        this.packageID = packageID;
        this.quantity = quantity;
        this.usedQuantity = usedQuantity;
        this.purchaseDate = purchaseDate;
        this.expiryDate = expiryDate;
        this.isUsed = isUsed;
    }
    
    // Business logic methods
    
    /**
     * Check if package is still valid (not expired and has remaining quantity)
     */
    public boolean isValid() {
        if (expiryDate == null) {
            return false;
        }
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return expiryDate.after(now) && usedQuantity < quantity;
    }
    
    /**
     * Check if package is expired
     */
    public boolean isExpired() {
        if (expiryDate == null) {
            return false;
        }
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return expiryDate.before(now);
    }
    
    /**
     * Get remaining quantity
     */
    public int getRemainingQuantity() {
        return quantity - usedQuantity;
    }
    
    /**
     * Check if package has been fully used
     */
    public boolean isFullyUsed() {
        return usedQuantity >= quantity;
    }
    
    // Getters and Setters
    public int getRecruiterPackageID() {
        return recruiterPackageID;
    }
    
    public void setRecruiterPackageID(int recruiterPackageID) {
        this.recruiterPackageID = recruiterPackageID;
    }
    
    public int getRecruiterID() {
        return recruiterID;
    }
    
    public void setRecruiterID(int recruiterID) {
        this.recruiterID = recruiterID;
    }
    
    public int getPackageID() {
        return packageID;
    }
    
    public void setPackageID(int packageID) {
        this.packageID = packageID;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public int getUsedQuantity() {
        return usedQuantity;
    }
    
    public void setUsedQuantity(int usedQuantity) {
        this.usedQuantity = usedQuantity;
    }
    
    public Timestamp getPurchaseDate() {
        return purchaseDate;
    }
    
    public void setPurchaseDate(Timestamp purchaseDate) {
        this.purchaseDate = purchaseDate;
    }
    
    public Timestamp getExpiryDate() {
        return expiryDate;
    }
    
    public void setExpiryDate(Timestamp expiryDate) {
        this.expiryDate = expiryDate;
    }
    
    public boolean isUsed() {
        return isUsed;
    }
    
    public void setUsed(boolean used) {
        isUsed = used;
    }
    
    public JobPackage getJobPackage() {
        return jobPackage;
    }
    
    public void setJobPackage(JobPackage jobPackage) {
        this.jobPackage = jobPackage;
    }
    
    @Override
    public String toString() {
        return "RecruiterPackage{" +
                "recruiterPackageID=" + recruiterPackageID +
                ", recruiterID=" + recruiterID +
                ", packageID=" + packageID +
                ", quantity=" + quantity +
                ", usedQuantity=" + usedQuantity +
                ", expiryDate=" + expiryDate +
                ", isValid=" + isValid() +
                '}';
    }
}
