package model;

import java.math.BigDecimal;

public class PaymentDetails {
    private int paymentDetailID;
    private int paymentID;
    private int packageID;
    private int quantity;
    private BigDecimal unitPrice;

    public PaymentDetails() {}

    public PaymentDetails(int paymentDetailID, int paymentID, int packageID,
                         int quantity, BigDecimal unitPrice) {
        this.paymentDetailID = paymentDetailID;
        this.paymentID = paymentID;
        this.packageID = packageID;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    // Getters and Setters
    public int getPaymentDetailID() {
        return paymentDetailID;
    }

    public void setPaymentDetailID(int paymentDetailID) {
        this.paymentDetailID = paymentDetailID;
    }

    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
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

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    @Override
    public String toString() {
        return "PaymentDetails{" +
                "paymentDetailID=" + paymentDetailID +
                ", paymentID=" + paymentID +
                ", packageID=" + packageID +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                '}';
    }
}
