package dal;

import model.Location;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LocationDAO extends DBContext {
    
    // Lấy tất cả locations
    public List<Location> getAllLocations() {
        List<Location> locations = new ArrayList<>();
        String sql = "SELECT * FROM Locations ORDER BY LocationName";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Location location = new Location();
                location.setLocationID(rs.getInt("LocationID"));
                location.setLocationName(rs.getString("LocationName"));
                locations.add(location);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return locations;
    }
    
    // Lấy location theo ID
    public Location getLocationById(int locationId) {
        String sql = "SELECT * FROM Locations WHERE LocationID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, locationId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Location location = new Location();
                location.setLocationID(rs.getInt("LocationID"));
                location.setLocationName(rs.getString("LocationName"));
                return location;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Thêm location mới
    public boolean addLocation(Location location) {
        String sql = "INSERT INTO Locations (LocationName) VALUES (?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, location.getLocationName());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Cập nhật location
    public boolean updateLocation(Location location) {
        String sql = "UPDATE Locations SET LocationName = ? WHERE LocationID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, location.getLocationName());
            ps.setInt(2, location.getLocationID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xóa location
    public boolean deleteLocation(int locationId) {
        String sql = "DELETE FROM Locations WHERE LocationID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, locationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
