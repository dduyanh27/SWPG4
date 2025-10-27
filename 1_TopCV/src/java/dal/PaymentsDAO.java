package dal;

import model.Payments;
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
    
    // Get all payments with recruiter information for admin
    public List<java.util.Map<String, Object>> getAllPaymentsWithRecruiterInfo() {
        List<java.util.Map<String, Object>> paymentList = new ArrayList<>();
        String sql = "SELECT p.*, r.CompanyName, r.Email, r.ContactPerson " +
                    "FROM Payments p " +
                    "LEFT JOIN Recruiter r ON p.RecruiterID = r.RecruiterID " +
                    "ORDER BY p.PaymentDate DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> payment = new java.util.HashMap<>();
                    payment.put("id", "PAY" + String.format("%03d", rs.getInt("PaymentID")));
                    payment.put("paymentID", rs.getInt("PaymentID"));
                    payment.put("recruiterName", rs.getString("CompanyName"));
                    payment.put("recruiterEmail", rs.getString("Email"));
                    payment.put("contactPerson", rs.getString("ContactPerson"));
                    payment.put("amount", rs.getBigDecimal("Amount"));
                    payment.put("currency", "VND");
                    payment.put("paymentMethod", rs.getString("PaymentMethod"));
                    payment.put("status", rs.getString("PaymentStatus"));
                    payment.put("transactionDate", rs.getTimestamp("PaymentDate").toString());
                    payment.put("description", rs.getString("Notes"));
                    payment.put("invoiceNumber", "INV-" + rs.getString("TransactionCode"));
                    payment.put("transactionCode", rs.getString("TransactionCode"));
                    paymentList.add(payment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return paymentList;
    }
    
    // Get payment statistics for admin dashboard
    public java.util.Map<String, Object> getPaymentStatistics() {
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        String sql = "SELECT " +
                    "COUNT(*) as totalPayments, " +
                    "SUM(CASE WHEN PaymentStatus = 'success' THEN 1 ELSE 0 END) as completedPayments, " +
                    "SUM(CASE WHEN PaymentStatus = 'pending' THEN 1 ELSE 0 END) as pendingPayments, " +
                    "SUM(CASE WHEN PaymentStatus = 'failed' THEN 1 ELSE 0 END) as failedPayments, " +
                    "SUM(CASE WHEN PaymentStatus = 'success' THEN Amount ELSE 0 END) as totalRevenue " +
                    "FROM Payments";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalPayments", rs.getInt("totalPayments"));
                    stats.put("completedPayments", rs.getInt("completedPayments"));
                    stats.put("pendingPayments", rs.getInt("pendingPayments"));
                    stats.put("failedPayments", rs.getInt("failedPayments"));
                    stats.put("totalRevenue", rs.getBigDecimal("totalRevenue"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    //duy anh
}