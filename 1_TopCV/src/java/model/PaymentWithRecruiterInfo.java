package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PaymentWithRecruiterInfo {
    private int paymentID;
    private int recruiterID;
    private BigDecimal amount;
    private String paymentMethod;
    private String paymentStatus;
    private String transactionCode;
    private LocalDateTime paymentDate;
    private String notes;
    
    // Recruiter information
    private String companyName;
    private String recruiterEmail;
    private String contactPerson;
    
    public PaymentWithRecruiterInfo() {}

    public PaymentWithRecruiterInfo(int paymentID, int recruiterID, BigDecimal amount, 
                                  String paymentMethod, String paymentStatus, String transactionCode, 
                                  LocalDateTime paymentDate, String notes, String companyName, 
                                  String recruiterEmail, String contactPerson) {
        this.paymentID = paymentID;
        this.recruiterID = recruiterID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.transactionCode = transactionCode;
        this.paymentDate = paymentDate;
        this.notes = notes;
        this.companyName = companyName;
        this.recruiterEmail = recruiterEmail;
        this.contactPerson = contactPerson;
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

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getRecruiterEmail() {
        return recruiterEmail;
    }

    public void setRecruiterEmail(String recruiterEmail) {
        this.recruiterEmail = recruiterEmail;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    @Override
    public String toString() {
        return "PaymentWithRecruiterInfo{" +
                "paymentID=" + paymentID +
                ", recruiterID=" + recruiterID +
                ", amount=" + amount +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", transactionCode='" + transactionCode + '\'' +
                ", paymentDate=" + paymentDate +
                ", notes='" + notes + '\'' +
                ", companyName='" + companyName + '\'' +
                ", recruiterEmail='" + recruiterEmail + '\'' +
                ", contactPerson='" + contactPerson + '\'' +
                '}';
    }
}
