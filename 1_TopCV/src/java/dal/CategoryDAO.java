package dal;

import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DBContext {
    
    // Lấy tất cả categories
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM Categories ORDER BY CategoryName";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryID(rs.getInt("CategoryID"));
                category.setCategoryName(rs.getString("CategoryName"));
                category.setParentCategoryID(rs.getInt("ParentCategoryID"));
                if (rs.wasNull()) {
                    category.setParentCategoryID(null);
                }
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    // Lấy categories cha (parent categories)
    public List<Category> getParentCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM Categories WHERE ParentCategoryID IS NULL ORDER BY CategoryName";
        
        System.out.println("=== CategoryDAO.getParentCategories() DEBUG ===");
        System.out.println("SQL: " + sql);
        System.out.println("Connection status: " + (c != null ? "Connected" : "NULL"));
        
        if (c != null) {
            try {
                System.out.println("Database URL: " + c.getMetaData().getURL());
                System.out.println("Database Product: " + c.getMetaData().getDatabaseProductName());
            } catch (SQLException e) {
                System.out.println("Error getting database metadata: " + e.getMessage());
            }
        }
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            System.out.println("PreparedStatement created successfully");
            ResultSet rs = ps.executeQuery();
            System.out.println("Query executed successfully");
            
            int count = 0;
            while (rs.next()) {
                count++;
                Category category = new Category();
                category.setCategoryID(rs.getInt("CategoryID"));
                category.setCategoryName(rs.getString("CategoryName"));
                category.setParentCategoryID(null);
                categories.add(category);
                
                System.out.println("Found category " + count + ": ID=" + category.getCategoryID() + 
                                 ", Name=" + category.getCategoryName() + ", ParentID=" + category.getParentCategoryID());
            }
            System.out.println("Total categories found: " + count);
            
        } catch (SQLException e) {
            System.err.println("SQL Error in getParentCategories: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General Error in getParentCategories: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Returning " + categories.size() + " categories");
        System.out.println("=== END CategoryDAO.getParentCategories() DEBUG ===");
        return categories;
    }
    
    // Lấy subcategories theo parent category ID
    public List<Category> getSubCategories(int parentCategoryId) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM Categories WHERE ParentCategoryID = ? ORDER BY CategoryName";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, parentCategoryId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryID(rs.getInt("CategoryID"));
                category.setCategoryName(rs.getString("CategoryName"));
                category.setParentCategoryID(rs.getInt("ParentCategoryID"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    // Lấy category theo ID
    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM Categories WHERE CategoryID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Category category = new Category();
                category.setCategoryID(rs.getInt("CategoryID"));
                category.setCategoryName(rs.getString("CategoryName"));
                category.setParentCategoryID(rs.getInt("ParentCategoryID"));
                if (rs.wasNull()) {
                    category.setParentCategoryID(null);
                }
                return category;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Thêm category mới
    public boolean addCategory(Category category) {
        String sql = "INSERT INTO Categories (CategoryName, ParentCategoryID) VALUES (?, ?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            if (category.getParentCategoryID() != null) {
                ps.setInt(2, category.getParentCategoryID());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        return false;
        }
    }
    
    // Cập nhật category
    public boolean updateCategory(Category category) {
        String sql = "UPDATE Categories SET CategoryName = ?, ParentCategoryID = ? WHERE CategoryID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            if (category.getParentCategoryID() != null) {
                ps.setInt(2, category.getParentCategoryID());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setInt(3, category.getCategoryID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xóa category
    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM Categories WHERE CategoryID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
}
