package dal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Location;

public class LocationDAO extends DBContext {

    public List<Location> getAllLocations() {
        List<Location> list = new ArrayList<>();
        String sql = "SELECT LocationID, LocationName FROM Locations";
        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Location(rs.getInt("LocationID"), rs.getString("LocationName")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Location getLocationById(int id) {
        String sql = "SELECT LocationID, LocationName FROM Locations WHERE LocationID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Location(rs.getInt("LocationID"), rs.getString("LocationName"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
