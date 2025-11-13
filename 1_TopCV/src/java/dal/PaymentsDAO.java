package dal;

import model.Payments;
import model.PaymentWithRecruiterInfo;
import model.PaymentStatistics;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PaymentsDAO extends DBContext {
    
    // Create new payment record
    public int createPayment(Payments payment) {
        // Insert only the columns that are guaranteed to exist
        String sql = "INSERT INTO Payments (RecruiterID, Amount, PaymentMethod, PaymentStatus, TransactionCode, PaymentDate, Notes) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getRecruiterID());
            ps.setBigDecimal(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getPaymentStatus());
            ps.setString(5, payment.getTransactionCode());
            ps.setTimestamp(6, Timestamp.valueOf(payment.getPaymentDate()));
            ps.setString(7, payment.getNotes());
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
            return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }
    
    // Update payment status
    public boolean updatePaymentStatus(int paymentID, String status, String transactionCode) {
        String sql = "UPDATE Payments SET PaymentStatus = ?, TransactionCode = ?, PaymentDate = ? WHERE PaymentID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, transactionCode);
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(4, paymentID);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get payment by ID
    public Payments getPaymentById(int paymentID) {
        String sql = "SELECT * FROM Payments WHERE PaymentID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, paymentID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Payments payment = new Payments();
                    payment.setPaymentID(rs.getInt("PaymentID"));
                    payment.setRecruiterID(rs.getInt("RecruiterID"));
                    payment.setAmount(rs.getBigDecimal("Amount"));
                    payment.setPaymentMethod(rs.getString("PaymentMethod"));
                    payment.setPaymentStatus(rs.getString("PaymentStatus"));
                    payment.setTransactionCode(rs.getString("TransactionCode"));
                    payment.setPaymentDate(rs.getTimestamp("PaymentDate").toLocalDateTime());
                    payment.setNotes(rs.getString("Notes"));
                    return payment;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get payment by transaction code
    public Payments getPaymentByTransactionCode(String transactionCode) {
        String sql = "SELECT * FROM Payments WHERE TransactionCode = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, transactionCode);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Payments payment = new Payments();
                    payment.setPaymentID(rs.getInt("PaymentID"));
                    payment.setRecruiterID(rs.getInt("RecruiterID"));
                    payment.setAmount(rs.getBigDecimal("Amount"));
                    payment.setPaymentMethod(rs.getString("PaymentMethod"));
                    payment.setPaymentStatus(rs.getString("PaymentStatus"));
                    payment.setTransactionCode(rs.getString("TransactionCode"));
                    payment.setPaymentDate(rs.getTimestamp("PaymentDate").toLocalDateTime());
                    payment.setNotes(rs.getString("Notes"));
                    return payment;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get payments by recruiter ID
    public List<Payments> getPaymentsByRecruiterId(int recruiterID) {
        List<Payments> payments = new ArrayList<>();
        String sql = "SELECT * FROM Payments WHERE RecruiterID = ? ORDER BY PaymentDate DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterID);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payments payment = new Payments();
                    payment.setPaymentID(rs.getInt("PaymentID"));
                    payment.setRecruiterID(rs.getInt("RecruiterID"));
                    payment.setAmount(rs.getBigDecimal("Amount"));
                    payment.setPaymentMethod(rs.getString("PaymentMethod"));
                    payment.setPaymentStatus(rs.getString("PaymentStatus"));
                    payment.setTransactionCode(rs.getString("TransactionCode"));
                    payment.setPaymentDate(rs.getTimestamp("PaymentDate").toLocalDateTime());
                    payment.setNotes(rs.getString("Notes"));
                    payments.add(payment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }
    //duy anh
    
    // Get all payments with recruiter information for admin - Traditional DAO approach
    public List<PaymentWithRecruiterInfo> getAllPaymentsWithRecruiterInfo() {
        List<PaymentWithRecruiterInfo> paymentList = new ArrayList<>();
        String sql = "SELECT p.*, r.CompanyName, r.Email, r.ContactPerson " +
                    "FROM Payments p " +
                    "LEFT JOIN Recruiter r ON p.RecruiterID = r.RecruiterID " +
                    "ORDER BY p.PaymentDate DESC";
        
        System.out.println("=== DEBUG: getAllPaymentsWithRecruiterInfo() ===");
        System.out.println("SQL Query: " + sql);
        System.out.println("Connection status: " + (c != null ? "Connected" : "NULL"));
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    count++;
                    System.out.println("Processing payment #" + count);
                    
                    PaymentWithRecruiterInfo payment = new PaymentWithRecruiterInfo();
                    payment.setPaymentID(rs.getInt("PaymentID"));
                    payment.setRecruiterID(rs.getInt("RecruiterID"));
                    payment.setAmount(rs.getBigDecimal("Amount"));
                    payment.setPaymentMethod(rs.getString("PaymentMethod"));
                    payment.setPaymentStatus(rs.getString("PaymentStatus"));
                    payment.setTransactionCode(rs.getString("TransactionCode"));
                    payment.setPaymentDate(rs.getTimestamp("PaymentDate").toLocalDateTime());
                    payment.setNotes(rs.getString("Notes"));
                    payment.setCompanyName(rs.getString("CompanyName"));
                    payment.setRecruiterEmail(rs.getString("Email"));
                    payment.setContactPerson(rs.getString("ContactPerson"));
                    paymentList.add(payment);
                    
                    System.out.println("Added payment: " + payment.getPaymentID() + " - " + payment.getCompanyName());
                }
                System.out.println("Total payments loaded: " + count);
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in getAllPaymentsWithRecruiterInfo: " + e.getMessage());
            e.printStackTrace();
        }
        return paymentList;
    }
    
    // Get payment statistics for admin dashboard - Traditional DAO approach
    public PaymentStatistics getPaymentStatistics() {
        String sql = "SELECT " +
                    "COUNT(*) as totalPayments, " +
                    "SUM(CASE WHEN LOWER(PaymentStatus) IN ('success', 'completed') THEN 1 ELSE 0 END) as completedPayments, " +
                    "SUM(CASE WHEN LOWER(PaymentStatus) = 'pending' THEN 1 ELSE 0 END) as pendingPayments, " +
                    "SUM(CASE WHEN LOWER(PaymentStatus) = 'failed' THEN 1 ELSE 0 END) as failedPayments, " +
                    "SUM(CASE WHEN LOWER(PaymentStatus) IN ('success', 'completed') THEN Amount ELSE 0 END) as totalRevenue " +
                    "FROM Payments";
        
        System.out.println("=== DEBUG: getPaymentStatistics() ===");
        System.out.println("SQL Query: " + sql);
        System.out.println("Connection status: " + (c != null ? "Connected" : "NULL"));
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PaymentStatistics stats = new PaymentStatistics();
                    stats.setTotalPayments(rs.getInt("totalPayments"));
                    stats.setCompletedPayments(rs.getInt("completedPayments"));
                    stats.setPendingPayments(rs.getInt("pendingPayments"));
                    stats.setFailedPayments(rs.getInt("failedPayments"));
                    java.math.BigDecimal revenue = rs.getBigDecimal("totalRevenue");
                    stats.setTotalRevenue(revenue != null ? revenue : java.math.BigDecimal.ZERO);
                    
                    System.out.println("Statistics loaded: " + stats.getTotalPayments() + " total, " + 
                                     stats.getCompletedPayments() + " completed, " + 
                                     stats.getTotalRevenue() + " revenue");
                    return stats;
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in getPaymentStatistics: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("Returning empty statistics");
        PaymentStatistics emptyStats = new PaymentStatistics();
        emptyStats.setTotalRevenue(java.math.BigDecimal.ZERO);
        return emptyStats; // Return empty stats if error
    }
    //duy anh
}