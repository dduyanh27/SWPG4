package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.JobPackages;

public class JobPackagesDAO extends DBContext {

    public List<JobPackages> getAllActivePackages() {
        List<JobPackages> packages = new ArrayList<>();
        String sql = "SELECT PackageID, PackageName, PackageType, Description, Price, Duration, Points, Features, IsActive, CreatedAt, UpdatedAt FROM JobPackages WHERE IsActive = 1";
        
        System.out.println("=== DEBUG: getAllActivePackages() ===");
        System.out.println("SQL Query: " + sql);
        System.out.println("Connection status: " + (c != null ? "Connected" : "NULL"));
        
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            int count = 0;
            while (rs.next()) {
                count++;
                JobPackages pkg = new JobPackages();
                pkg.setPackageID(rs.getInt("PackageID"));
                pkg.setPackageName(rs.getString("PackageName"));
                pkg.setPackageType(rs.getString("PackageType"));
                pkg.setDescription(rs.getString("Description"));
                pkg.setPrice(rs.getBigDecimal("Price"));
                pkg.setDuration(rs.getInt("Duration"));
                pkg.setPoints(rs.getInt("Points"));
                pkg.setFeatures(rs.getString("Features"));
                pkg.setIsActive(rs.getBoolean("IsActive"));
                if (rs.getTimestamp("CreatedAt") != null) {
                    pkg.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                }
                if (rs.getTimestamp("UpdatedAt") != null) {
                    pkg.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
                }
                
                System.out.println("Package " + count + ": " + pkg.getPackageName() + " - " + pkg.getPackageType() + " - " + pkg.getPrice());
                packages.add(pkg);
            }
            
            System.out.println("Total packages found: " + count);
        } catch (SQLException e) {
            System.out.println("SQL Error in getAllActivePackages: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("=== END DEBUG: getAllActivePackages() ===");
        return packages;
    }


    public List<JobPackages> getPackagesByType(String packageType) {
        List<JobPackages> packages = new ArrayList<>();
        
        // Convert package type from frontend format to database format
        String dbPackageType = convertPackageTypeToDbFormat(packageType);
        
        String sql = "SELECT PackageID, PackageName, PackageType, Description, Price, Duration, Points, Features, IsActive, CreatedAt, UpdatedAt FROM JobPackages WHERE PackageType = ? AND IsActive = 1 ORDER BY Price ASC";
        
        System.out.println("=== DEBUG: getPackagesByType() ===");
        System.out.println("Original Package Type: " + packageType);
        System.out.println("Converted Package Type: " + dbPackageType);
        System.out.println("SQL Query: " + sql);
        System.out.println("Connection status: " + (c != null ? "Connected" : "NULL"));
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, dbPackageType);
            try (ResultSet rs = ps.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    count++;
                    JobPackages pkg = new JobPackages();
                    pkg.setPackageID(rs.getInt("PackageID"));
                    pkg.setPackageName(rs.getString("PackageName"));
                    pkg.setPackageType(rs.getString("PackageType"));
                    pkg.setDescription(rs.getString("Description"));
                    pkg.setPrice(rs.getBigDecimal("Price"));
                    pkg.setDuration(rs.getInt("Duration"));
                    pkg.setPoints(rs.getInt("Points"));
                    pkg.setFeatures(rs.getString("Features"));
                    pkg.setIsActive(rs.getBoolean("IsActive"));
                    if (rs.getTimestamp("CreatedAt") != null) {
                        pkg.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    }
                    if (rs.getTimestamp("UpdatedAt") != null) {
                        pkg.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
                    }
                    
                    System.out.println("Package " + count + ": " + pkg.getPackageName() + " - " + pkg.getPackageType() + " - " + pkg.getPrice());
                    packages.add(pkg);
                }
                System.out.println("Total packages found for type '" + packageType + "': " + count);
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in getPackagesByType: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("=== END DEBUG: getPackagesByType() ===");
        return packages;
    }

    public List<String> getAllPackageTypes() {
        List<String> types = new ArrayList<>();
        String sql = "SELECT DISTINCT PackageType FROM JobPackages WHERE IsActive = 1 ORDER BY PackageType";
        
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                types.add(rs.getString("PackageType"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return types;
    }
    
    /**
     * Convert package type from frontend format to database format
     * Frontend: dang-tuyen, tim-ho-so, ai-premium
     * Database: DANG_TUYEN, TIM_HO_SO, AI_PREMIUM
     */
    private String convertPackageTypeToDbFormat(String frontendType) {
        if (frontendType == null) {
            return null;
        }
        
        switch (frontendType.toLowerCase()) {
            case "dang-tuyen":
                return "DANG_TUYEN";
            case "tim-ho-so":
                return "TIM_HO_SO";
            case "ai-premium":
                return "AI_PREMIUM";
            case "dich-vu-ho-tro":
                return "DICH_VU_HO_TRO";
            default:
                // If it's already in database format or unknown, return as is
                return frontendType.toUpperCase();
        }
    }
    
    public List<JobPackages> getAllPackages() {
        List<JobPackages> packages = new ArrayList<>();
        String sql = "SELECT PackageID, PackageName, PackageType, Description, Price, Duration, Points, Features, IsActive, CreatedAt, UpdatedAt FROM JobPackages";
        
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                JobPackages pkg = new JobPackages();
                pkg.setPackageID(rs.getInt("PackageID"));
                pkg.setPackageName(rs.getString("PackageName"));
                pkg.setPackageType(rs.getString("PackageType"));
                pkg.setDescription(rs.getString("Description"));
                pkg.setPrice(rs.getBigDecimal("Price"));
                pkg.setDuration(rs.getInt("Duration"));
                pkg.setPoints(rs.getInt("Points"));
                pkg.setFeatures(rs.getString("Features"));
                pkg.setIsActive(rs.getBoolean("IsActive"));
                if (rs.getTimestamp("CreatedAt") != null) {
                    pkg.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                }
                if (rs.getTimestamp("UpdatedAt") != null) {
                    pkg.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
                }
                packages.add(pkg);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return packages;
    }
    
    public JobPackages getPackageById(int packageID) {
        String sql = "SELECT PackageID, PackageName, PackageType, Description, Price, Duration, Points, Features, IsActive, CreatedAt, UpdatedAt FROM JobPackages WHERE PackageID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, packageID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    JobPackages pkg = new JobPackages();
                    pkg.setPackageID(rs.getInt("PackageID"));
                    pkg.setPackageName(rs.getString("PackageName"));
                    pkg.setPackageType(rs.getString("PackageType"));
                    pkg.setDescription(rs.getString("Description"));
                    pkg.setPrice(rs.getBigDecimal("Price"));
                    pkg.setDuration(rs.getInt("Duration"));
                    pkg.setPoints(rs.getInt("Points"));
                    pkg.setFeatures(rs.getString("Features"));
                    pkg.setIsActive(rs.getBoolean("IsActive"));
                    if (rs.getTimestamp("CreatedAt") != null) {
                        pkg.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    }
                    if (rs.getTimestamp("UpdatedAt") != null) {
                        pkg.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
                    }
                    return pkg;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Find PackageID by package name (case-insensitive, fuzzy). Return 0 if not found
    public int getPackageIdByName(String packageName) {
        if (packageName == null || packageName.trim().isEmpty()) return 0;
        String sql = "SELECT TOP 1 PackageID FROM JobPackages WHERE LOWER(PackageName) LIKE LOWER(?)";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, "%" + packageName.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("PackageID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
