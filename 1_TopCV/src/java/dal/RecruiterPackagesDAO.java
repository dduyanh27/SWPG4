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
    
    // Update UsedQuantity - tăng số lượng đã sử dụng
    public boolean incrementUsedQuantity(int recruiterPackageID) {
        String sql = "UPDATE RecruiterPackages SET UsedQuantity = UsedQuantity + 1 " +
                    "WHERE RecruiterPackageID = ? AND (Quantity - UsedQuantity) > 0";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterPackageID);
            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG RecruiterPackagesDAO: Incremented UsedQuantity for package " + recruiterPackageID + ", rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("DEBUG RecruiterPackagesDAO: Error incrementing UsedQuantity: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Bổ sung: tăng UsedQuantity không ràng điều kiện (đã kiểm tra remaining ở tầng service)
    public boolean incrementUsedQuantityForce(int recruiterPackageID) {
        String sql = "UPDATE RecruiterPackages SET UsedQuantity = UsedQuantity + 1 WHERE RecruiterPackageID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterPackageID);
            int rows = ps.executeUpdate();
            System.out.println("DEBUG RecruiterPackagesDAO: Force increment UsedQuantity for package " + recruiterPackageID + ", rows=" + rows);
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("DEBUG RecruiterPackagesDAO: Error force increment UsedQuantity: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Get recruiter package by ID
    public RecruiterPackages getRecruiterPackageById(int recruiterPackageID) {
        String sql = "SELECT * FROM RecruiterPackages WHERE RecruiterPackageID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterPackageID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                RecruiterPackages rp = new RecruiterPackages();
                rp.setRecruiterPackageID(rs.getInt("RecruiterPackageID"));
                rp.setRecruiterID(rs.getInt("RecruiterID"));
                rp.setPackageID(rs.getInt("PackageID"));
                rp.setQuantity(rs.getInt("Quantity"));
                rp.setUsedQuantity(rs.getInt("UsedQuantity"));
                rp.setPurchaseDate(rs.getTimestamp("PurchaseDate").toLocalDateTime());
                rp.setExpiryDate(rs.getTimestamp("ExpiryDate").toLocalDateTime());
                rp.setIsUsed(rs.getBoolean("IsUsed"));
                return rp;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get recruiter packages with full package details (JOIN with JobPackages)
    // Only get packages with PackageType = 'DANG_TUYEN'
    public List<RecruiterPackagesWithDetails> getRecruiterPackagesWithDetails(int recruiterID) {
        List<RecruiterPackagesWithDetails> result = new ArrayList<>();
        String sql = "SELECT rp.*, jp.PackageName, jp.PackageType, jp.Description, jp.Duration " +
                    "FROM RecruiterPackages rp " +
                    "INNER JOIN JobPackages jp ON rp.PackageID = jp.PackageID " +
                    "WHERE rp.RecruiterID = ? AND rp.ExpiryDate > ? AND (rp.Quantity - rp.UsedQuantity) > 0 " +
                    "AND jp.PackageType = 'DANG_TUYEN' " +
                    "ORDER BY rp.PurchaseDate DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterID);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecruiterPackagesWithDetails item = new RecruiterPackagesWithDetails();
                    
                    // RecruiterPackages fields
                    item.recruiterPackageID = rs.getInt("RecruiterPackageID");
                    item.recruiterID = rs.getInt("RecruiterID");
                    item.packageID = rs.getInt("PackageID");
                    item.quantity = rs.getInt("Quantity");
                    item.usedQuantity = rs.getInt("UsedQuantity");
                    item.purchaseDate = rs.getTimestamp("PurchaseDate").toLocalDateTime();
                    item.expiryDate = rs.getTimestamp("ExpiryDate").toLocalDateTime();
                    item.isUsed = rs.getBoolean("IsUsed");
                    
                    // JobPackages fields
                    item.packageName = rs.getString("PackageName");
                    item.packageType = rs.getString("PackageType");
                    item.description = rs.getString("Description");
                    item.duration = rs.getInt("Duration");
                    
                    result.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // Inner class to hold combined data
    public static class RecruiterPackagesWithDetails {
        public int recruiterPackageID;
        public int recruiterID;
        public int packageID;
        public int quantity;
        public int usedQuantity;
        public LocalDateTime purchaseDate;
        public LocalDateTime expiryDate;
        public boolean isUsed;
        public String packageName;
        public String packageType;
        public String description;
        public int duration;
        public java.math.BigDecimal price;
        
        public int getRemainingQuantity() {
            return quantity - usedQuantity;
        }
    }

    // Lịch sử mua hàng đầy đủ (bao gồm cả đã hết hạn/đã dùng hết)
    public List<RecruiterPackagesWithDetails> getPurchaseHistoryWithDetails(int recruiterID) {
        List<RecruiterPackagesWithDetails> result = new ArrayList<>();
        String sql = "SELECT rp.*, jp.PackageName, jp.PackageType, jp.Description, jp.Duration, jp.Price " +
                     "FROM RecruiterPackages rp " +
                     "INNER JOIN JobPackages jp ON rp.PackageID = jp.PackageID " +
                     "WHERE rp.RecruiterID = ? " +
                     "ORDER BY rp.PurchaseDate DESC";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecruiterPackagesWithDetails item = new RecruiterPackagesWithDetails();

                    // RecruiterPackages
                    item.recruiterPackageID = rs.getInt("RecruiterPackageID");
                    item.recruiterID = rs.getInt("RecruiterID");
                    item.packageID = rs.getInt("PackageID");
                    item.quantity = rs.getInt("Quantity");
                    item.usedQuantity = rs.getInt("UsedQuantity");
                    item.purchaseDate = rs.getTimestamp("PurchaseDate").toLocalDateTime();
                    item.expiryDate = rs.getTimestamp("ExpiryDate").toLocalDateTime();
                    item.isUsed = rs.getBoolean("IsUsed");

                    // JobPackages
                    item.packageName = rs.getString("PackageName");
                    item.packageType = rs.getString("PackageType");
                    item.description = rs.getString("Description");
                    item.duration = rs.getInt("Duration");
                    try { item.price = rs.getBigDecimal("Price"); } catch (Exception ignore) {}

                    result.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}