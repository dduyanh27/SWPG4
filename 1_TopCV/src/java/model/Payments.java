package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Payments {
    private int paymentID;
    private int recruiterID;
    private Integer packageID;           // nullable
    private Integer recruiterPackageID;  // nullable
    private BigDecimal amount;
    private String paymentMethod;
    private String paymentStatus;
    private String transactionCode;
    private LocalDateTime paymentDate;
    private String notes;

    public Payments() {}

    public Payments(int paymentID, int recruiterID, Integer packageID, Integer recruiterPackageID,
                   BigDecimal amount, String paymentMethod,
                   String paymentStatus, String transactionCode, LocalDateTime paymentDate, String notes) {
        this.paymentID = paymentID;
        this.recruiterID = recruiterID;
        this.packageID = packageID;
        this.recruiterPackageID = recruiterPackageID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.transactionCode = transactionCode;
        this.paymentDate = paymentDate;
        this.notes = notes;
    }

    // Getters and Setters
    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getRecruiterID() {
        return recruiterID;
    }

    public void setRecruiterID(int recruiterID) {
        this.recruiterID = recruiterID;
    }

    public Integer getPackageID() {
        return packageID;
    }

    public void setPackageID(Integer packageID) {
        this.packageID = packageID;
    }

    public Integer getRecruiterPackageID() {
        return recruiterPackageID;
    }

    public void setRecruiterPackageID(Integer recruiterPackageID) {
        this.recruiterPackageID = recruiterPackageID;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getTransactionCode() {
        return transactionCode;
    }

    public void setTransactionCode(String transactionCode) {
        this.transactionCode = transactionCode;
    }

    public LocalDateTime getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDateTime paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    @Override
    public String toString() {
        return "Payments{" +
                "paymentID=" + paymentID +
                ", recruiterID=" + recruiterID +
                ", packageID=" + packageID +
                ", recruiterPackageID=" + recruiterPackageID +
                ", amount=" + amount +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", transactionCode='" + transactionCode + '\'' +
                ", paymentDate=" + paymentDate +
                ", notes='" + notes + '\'' +
                '}';
    }
}
