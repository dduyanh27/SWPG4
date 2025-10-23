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
}