package dal;

import model.RecruiterPackages;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class RecruiterPackagesDAO extends DBContext {
    
    // Create new recruiter package record
    public boolean createRecruiterPackage(RecruiterPackages recruiterPackage) {
        String sql = "INSERT INTO RecruiterPackages (RecruiterID, PackageID, Quantity, UsedQuantity, PurchaseDate, ExpiryDate, IsUsed) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterPackage.getRecruiterID());
            ps.setInt(2, recruiterPackage.getPackageID());
            ps.setInt(3, recruiterPackage.getQuantity());
            ps.setInt(4, recruiterPackage.getUsedQuantity());
            ps.setTimestamp(5, Timestamp.valueOf(recruiterPackage.getPurchaseDate()));
            ps.setTimestamp(6, Timestamp.valueOf(recruiterPackage.getExpiryDate()));
            ps.setBoolean(7, recruiterPackage.isIsUsed());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Create multiple recruiter packages
    public boolean createRecruiterPackages(List<RecruiterPackages> recruiterPackages) {
        String sql = "INSERT INTO RecruiterPackages (RecruiterID, PackageID, Quantity, UsedQuantity, PurchaseDate, ExpiryDate, IsUsed) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        System.out.println("RecruiterPackagesDAO: Creating " + recruiterPackages.size() + " recruiter packages");
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            for (RecruiterPackages rp : recruiterPackages) {
                System.out.println("Adding batch: RecruiterID=" + rp.getRecruiterID() + 
                                 ", PackageID=" + rp.getPackageID() + 
                                 ", Quantity=" + rp.getQuantity());
                ps.setInt(1, rp.getRecruiterID());
                ps.setInt(2, rp.getPackageID());
                ps.setInt(3, rp.getQuantity());
                ps.setInt(4, rp.getUsedQuantity());
                ps.setTimestamp(5, Timestamp.valueOf(rp.getPurchaseDate()));
                ps.setTimestamp(6, Timestamp.valueOf(rp.getExpiryDate()));
                ps.setBoolean(7, rp.isIsUsed());
                ps.addBatch();
            }
            
            int[] results = ps.executeBatch();
            System.out.println("RecruiterPackages batch execution results: " + java.util.Arrays.toString(results));
            
            for (int result : results) {
                if (result <= 0) {
                    System.out.println("Failed to insert recruiter package, result: " + result);
                    return false;
                }
            }
            System.out.println("Successfully created all recruiter packages");
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQLException in createRecruiterPackages: " + e.getMessage());
            return false;
        }
    }
    
    // Get recruiter packages by recruiter ID
    public List<RecruiterPackages> getRecruiterPackagesByRecruiterId(int recruiterID) {
        List<RecruiterPackages> packages = new ArrayList<>();
        String sql = "SELECT * FROM RecruiterPackages WHERE RecruiterID = ? ORDER BY PurchaseDate DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterID);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecruiterPackages rp = new RecruiterPackages();
                    rp.setRecruiterPackageID(rs.getInt("RecruiterPackageID"));
                    rp.setRecruiterID(rs.getInt("RecruiterID"));
                    rp.setPackageID(rs.getInt("PackageID"));
                    rp.setQuantity(rs.getInt("Quantity"));
                    rp.setUsedQuantity(rs.getInt("UsedQuantity"));
                    rp.setPurchaseDate(rs.getTimestamp("PurchaseDate").toLocalDateTime());
                    rp.setExpiryDate(rs.getTimestamp("ExpiryDate").toLocalDateTime());
                    rp.setIsUsed(rs.getBoolean("IsUsed"));
                    packages.add(rp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return packages;
    }
    
    // Get available packages for recruiter (not expired and has remaining quantity)
    public List<RecruiterPackages> getAvailablePackagesByRecruiterId(int recruiterID) {
        List<RecruiterPackages> packages = new ArrayList<>();
        String sql = "SELECT * FROM RecruiterPackages WHERE RecruiterID = ? AND ExpiryDate > ? AND (Quantity - UsedQuantity) > 0 ORDER BY PurchaseDate DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterID);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecruiterPackages rp = new RecruiterPackages();
                    rp.setRecruiterPackageID(rs.getInt("RecruiterPackageID"));
                    rp.setRecruiterID(rs.getInt("RecruiterID"));
                    rp.setPackageID(rs.getInt("PackageID"));
                    rp.setQuantity(rs.getInt("Quantity"));
                    rp.setUsedQuantity(rs.getInt("UsedQuantity"));
                    rp.setPurchaseDate(rs.getTimestamp("PurchaseDate").toLocalDateTime());
                    rp.setExpiryDate(rs.getTimestamp("ExpiryDate").toLocalDateTime());
                    rp.setIsUsed(rs.getBoolean("IsUsed"));
                    packages.add(rp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return packages;
    }
}