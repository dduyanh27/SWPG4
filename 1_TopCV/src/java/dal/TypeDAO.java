package dal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Type;

public class TypeDAO extends DBContext {
    public List<Type> getAllType() {
        List<Type> list = new ArrayList<>();
        String sql = "SELECT TypeID, TypeCategory, TypeName FROM Types";
        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Type(rs.getInt("TypeID"), rs.getString("TypeCategory"), rs.getString("TypeName")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

