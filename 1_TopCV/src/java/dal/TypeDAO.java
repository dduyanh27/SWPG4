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

    // Lấy tất cả types theo category
    public List<Type> getTypesByCategory(String typeCategory) {
        List<Type> types = new ArrayList<>();
        String sql = "SELECT * FROM Types WHERE TypeCategory = ? ORDER BY TypeName";
        
        try {
            if (c == null) {
                System.out.println("ERROR: Connection is null in TypeDAO.getTypesByCategory");
                return types;
            }
            System.out.println("DEBUG: Querying Types with TypeCategory = '" + typeCategory + "'");
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, typeCategory);
            ResultSet rs = ps.executeQuery();
            
            int count = 0;
            while (rs.next()) {
                Type type = new Type();
                type.setTypeID(rs.getInt("TypeID"));
                type.setTypeCategory(rs.getString("TypeCategory"));
                type.setTypeName(rs.getString("TypeName"));
                types.add(type);
                count++;
                System.out.println("DEBUG: Found Type - ID: " + type.getTypeID() + ", Name: " + type.getTypeName());
            }
            System.out.println("DEBUG: Total types found for category '" + typeCategory + "': " + count);
            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.out.println("ERROR in getTypesByCategory: " + e.getMessage());
            e.printStackTrace();
        }
        return types;
    }
    
    // Lấy type theo ID
    public Type getTypeById(int typeId) {
        String sql = "SELECT * FROM Types WHERE TypeID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, typeId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Type type = new Type();
                type.setTypeID(rs.getInt("TypeID"));
                type.setTypeCategory(rs.getString("TypeCategory"));
                type.setTypeName(rs.getString("TypeName"));
                return type;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy tất cả job levels (TypeCategory = 'Level')
    public List<Type> getJobLevels() {
        return getTypesByCategory("Level");
    }
    
    // Lấy tất cả job types (TypeCategory = 'JobType')
    public List<Type> getJobTypes() {
        return getTypesByCategory("JobType");
    }
    
    // Lấy tất cả application statuses
    public List<Type> getApplicationStatuses() {
        return getTypesByCategory("ApplicationStatus");
    }
    
    // Lấy tất cả job statuses
    public List<Type> getJobStatuses() {
        return getTypesByCategory("JobStatus");
    }
    
    // Thêm type mới
    public boolean addType(Type type) {
        String sql = "INSERT INTO Types (TypeCategory, TypeName) VALUES (?, ?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, type.getTypeCategory());
            ps.setString(2, type.getTypeName());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Cập nhật type
    public boolean updateType(Type type) {
        String sql = "UPDATE Types SET TypeCategory = ?, TypeName = ? WHERE TypeID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, type.getTypeCategory());
            ps.setString(2, type.getTypeName());
            ps.setInt(3, type.getTypeID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xóa type
    public boolean deleteType(int typeId) {
        String sql = "DELETE FROM Types WHERE TypeID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, typeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public String getTypeNameByCurrentLevelId(int currentLevelId) {
        String sql = "SELECT TypeName FROM Types WHERE TypeID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, currentLevelId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("TypeName");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
}
