package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.JobPackage;

public class JobPackageDAO extends DBContext {

    public List<JobPackage> listAllActive() {
        String sql = "SELECT PackageID, PackageName, PackageType, Description, Price, Duration, Points, Features, IsActive, CreatedAt, UpdatedAt "
                   + "FROM dbo.JobPackages WHERE (IsActive = 1 OR IsActive IS NULL) ORDER BY PackageType, Price";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                List<JobPackage> result = new ArrayList<>();
                while (rs.next()) {
                    result.add(mapRow(rs));
                }
                System.out.println("[JobPackageDAO] listAllActive size=" + result.size());
                return result;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<JobPackage> listByType(String packageType) {
        String sql = "SELECT PackageID, PackageName, PackageType, Description, Price, Duration, Points, Features, IsActive, CreatedAt, UpdatedAt "
                   + "FROM dbo.JobPackages WHERE (IsActive = 1 OR IsActive IS NULL) AND PackageType = ? ORDER BY Price";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, packageType);
            try (ResultSet rs = ps.executeQuery()) {
                List<JobPackage> result = new ArrayList<>();
                while (rs.next()) {
                    result.add(mapRow(rs));
                }
                System.out.println("[JobPackageDAO] listByType(" + packageType + ") size=" + result.size());
                return result;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    private JobPackage mapRow(ResultSet rs) throws SQLException {
        JobPackage p = new JobPackage();
        p.setPackageID(rs.getInt("PackageID"));
        p.setPackageName(rs.getString("PackageName"));
        p.setPackageType(rs.getString("PackageType"));
        p.setDescription(rs.getString("Description"));
        p.setPrice(rs.getBigDecimal("Price"));
        int duration = rs.getInt("Duration");
        p.setDuration(rs.wasNull() ? null : duration);
        int points = rs.getInt("Points");
        p.setPoints(rs.wasNull() ? null : points);
        p.setFeatures(rs.getString("Features"));
        boolean isActive = rs.getBoolean("IsActive");
        p.setIsActive(rs.wasNull() ? null : isActive);
        p.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        p.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
        return p;
    }
}


