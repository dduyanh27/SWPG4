package model;

import java.time.LocalDateTime;

public class RecruiterPackage {
    private int recruiterPackageID;
    private int recruiterID;
    private int packageID;
    private Integer quantity;
    private Integer usedQuantity;
    private LocalDateTime purchaseDate;
    private LocalDateTime expiryDate;
    private Boolean isUsed;

    public RecruiterPackage() {}

    public RecruiterPackage(int recruiterPackageID, int recruiterID, int packageID, Integer quantity,
                            Integer usedQuantity, LocalDateTime purchaseDate, LocalDateTime expiryDate,
                            Boolean isUsed) {
        this.recruiterPackageID = recruiterPackageID;
        this.recruiterID = recruiterID;
        this.packageID = packageID;
        this.quantity = quantity;
        this.usedQuantity = usedQuantity;
        this.purchaseDate = purchaseDate;
        this.expiryDate = expiryDate;
        this.isUsed = isUsed;
    }

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

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Integer getUsedQuantity() {
        return usedQuantity;
    }

    public void setUsedQuantity(Integer usedQuantity) {
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

    public Boolean getIsUsed() {
        return isUsed;
    }

    public void setIsUsed(Boolean isUsed) {
        this.isUsed = isUsed;
    }

    @Override
    public String toString() {
        return "RecruiterPackage{" +
                "recruiterPackageID=" + recruiterPackageID +
                ", recruiterID=" + recruiterID +
                ", packageID=" + packageID +
                ", quantity=" + quantity +
                ", usedQuantity=" + usedQuantity +
                '}';
    }
}


