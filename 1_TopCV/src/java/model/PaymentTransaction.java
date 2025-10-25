package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PaymentTransaction {
    private int transactionID;
    private int paymentID;
    private String transactionType;
    private BigDecimal amount;
    private LocalDateTime transactionDate;
    private String description;

    public PaymentTransaction() {}

    public PaymentTransaction(int transactionID, int paymentID, String transactionType, BigDecimal amount,
                              LocalDateTime transactionDate, String description) {
        this.transactionID = transactionID;
        this.paymentID = paymentID;
        this.transactionType = transactionType;
        this.amount = amount;
        this.transactionDate = transactionDate;
        this.description = description;
    }

    public int getTransactionID() {
        return transactionID;
    }

    public void setTransactionID(int transactionID) {
        this.transactionID = transactionID;
    }

    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public LocalDateTime getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(LocalDateTime transactionDate) {
        this.transactionDate = transactionDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "PaymentTransaction{" +
                "transactionID=" + transactionID +
                ", paymentID=" + paymentID +
                ", transactionType='" + transactionType + '\'' +
                ", amount=" + amount +
                '}';
    }
}


