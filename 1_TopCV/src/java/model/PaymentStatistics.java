package model;

import java.math.BigDecimal;

public class PaymentStatistics {
    private int totalPayments;
    private int completedPayments;
    private int pendingPayments;
    private int failedPayments;
    private BigDecimal totalRevenue;

    public PaymentStatistics() {}

    public PaymentStatistics(int totalPayments, int completedPayments, int pendingPayments, 
                           int failedPayments, BigDecimal totalRevenue) {
        this.totalPayments = totalPayments;
        this.completedPayments = completedPayments;
        this.pendingPayments = pendingPayments;
        this.failedPayments = failedPayments;
        this.totalRevenue = totalRevenue;
    }

    // Getters and Setters
    public int getTotalPayments() {
        return totalPayments;
    }

    public void setTotalPayments(int totalPayments) {
        this.totalPayments = totalPayments;
    }

    public int getCompletedPayments() {
        return completedPayments;
    }

    public void setCompletedPayments(int completedPayments) {
        this.completedPayments = completedPayments;
    }

    public int getPendingPayments() {
        return pendingPayments;
    }

    public void setPendingPayments(int pendingPayments) {
        this.pendingPayments = pendingPayments;
    }

    public int getFailedPayments() {
        return failedPayments;
    }

    public void setFailedPayments(int failedPayments) {
        this.failedPayments = failedPayments;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    @Override
    public String toString() {
        return "PaymentStatistics{" +
                "totalPayments=" + totalPayments +
                ", completedPayments=" + completedPayments +
                ", pendingPayments=" + pendingPayments +
                ", failedPayments=" + failedPayments +
                ", totalRevenue=" + totalRevenue +
                '}';
    }
}
