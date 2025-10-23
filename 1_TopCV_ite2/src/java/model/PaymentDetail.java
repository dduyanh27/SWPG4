package model;

import java.math.BigDecimal;

public class PaymentDetail {
    private int paymentDetailID;
    private int paymentID;
    private int packageID;
    private Integer quantity;
    private BigDecimal unitPrice;

    public PaymentDetail() {}

    public PaymentDetail(int paymentDetailID, int paymentID, int packageID, Integer quantity, BigDecimal unitPrice) {
        this.paymentDetailID = paymentDetailID;
        this.paymentID = paymentID;
        this.packageID = packageID;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

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

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
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
        return "PaymentDetail{" +
                "paymentDetailID=" + paymentDetailID +
                ", paymentID=" + paymentID +
                ", packageID=" + packageID +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                '}';
    }
}


