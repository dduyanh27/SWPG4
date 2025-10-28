package dal;

import model.PaymentDetails;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDetailsDAO extends DBContext {
    
    // Create new payment detail record
    public boolean createPaymentDetail(PaymentDetails paymentDetail) {
        String sql = "INSERT INTO PaymentDetails (PaymentID, PackageID, Quantity, UnitPrice) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, paymentDetail.getPaymentID());
            ps.setInt(2, paymentDetail.getPackageID());
            ps.setInt(3, paymentDetail.getQuantity());
            ps.setBigDecimal(4, paymentDetail.getUnitPrice());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Create multiple payment details
    public boolean createPaymentDetails(List<PaymentDetails> paymentDetails) {
        String sql = "INSERT INTO PaymentDetails (PaymentID, PackageID, Quantity, UnitPrice) VALUES (?, ?, ?, ?)";
        
        System.out.println("PaymentDetailsDAO: Creating " + paymentDetails.size() + " payment details");
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            for (PaymentDetails detail : paymentDetails) {
                System.out.println("Adding batch: PaymentID=" + detail.getPaymentID() + 
                                 ", PackageID=" + detail.getPackageID() + 
                                 ", Quantity=" + detail.getQuantity() +
                                 ", UnitPrice=" + detail.getUnitPrice());
                ps.setInt(1, detail.getPaymentID());
                ps.setInt(2, detail.getPackageID());
                ps.setInt(3, detail.getQuantity());
                ps.setBigDecimal(4, detail.getUnitPrice());
                ps.addBatch();
            }
            
            int[] results = ps.executeBatch();
            System.out.println("Batch execution results: " + java.util.Arrays.toString(results));
            
            for (int result : results) {
                if (result <= 0) {
                    System.out.println("Failed to insert payment detail, result: " + result);
                    return false;
                }
            }
            System.out.println("Successfully created all payment details");
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQLException in createPaymentDetails: " + e.getMessage());
            return false;
        }
    }
    
    // Get payment details by payment ID
    public List<PaymentDetails> getPaymentDetailsByPaymentId(int paymentID) {
        List<PaymentDetails> details = new ArrayList<>();
        String sql = "SELECT * FROM PaymentDetails WHERE PaymentID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, paymentID);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PaymentDetails detail = new PaymentDetails();
                    detail.setPaymentDetailID(rs.getInt("PaymentDetailID"));
                    detail.setPaymentID(rs.getInt("PaymentID"));
                    detail.setPackageID(rs.getInt("PackageID"));
                    detail.setQuantity(rs.getInt("Quantity"));
                    // UnitPrice may not exist; ignore when not present
                    try { detail.setUnitPrice(rs.getBigDecimal("UnitPrice")); } catch (SQLException ignore) {}
                    details.add(detail);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }
}