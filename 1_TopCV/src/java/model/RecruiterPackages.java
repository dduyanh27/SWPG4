package model;

import java.time.LocalDateTime;

public class RecruiterPackages {
    private int recruiterPackageID;
    private int recruiterID;
    private int packageID;
    private int quantity;
    private int usedQuantity;
    private LocalDateTime purchaseDate;
    private LocalDateTime expiryDate;
    private boolean isUsed;

    public RecruiterPackages() {}

    public RecruiterPackages(int recruiterPackageID, int recruiterID, int packageID,
                            int quantity, int usedQuantity, LocalDateTime purchaseDate,
                            LocalDateTime expiryDate, boolean isUsed) {
        this.recruiterPackageID = recruiterPackageID;
        this.recruiterID = recruiterID;
        this.packageID = packageID;
        this.quantity = quantity;
        this.usedQuantity = usedQuantity;
        this.purchaseDate = purchaseDate;
        this.expiryDate = expiryDate;
        this.isUsed = isUsed;
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

    public LocalDateTime getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(LocalDateTime purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public LocalDateTime getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDateTime expiryDate) {
        this.expiryDate = expiryDate;
    }

    public boolean isIsUsed() {
        return isUsed;
    }

    public void setIsUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    @Override
    public String toString() {
        return "RecruiterPackages{" +
                "recruiterPackageID=" + recruiterPackageID +
                ", recruiterID=" + recruiterID +
                ", packageID=" + packageID +
                ", quantity=" + quantity +
                ", usedQuantity=" + usedQuantity +
                ", purchaseDate=" + purchaseDate +
                ", expiryDate=" + expiryDate +
                ", isUsed=" + isUsed +
                '}';
    }
}
