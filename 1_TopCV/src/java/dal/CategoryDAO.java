package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Category;

public class CategoryDAO extends DBContext {
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryName, ParentCategoryID FROM Categories";
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Category(
                        rs.getInt("CategoryID"),
                        rs.getString("CategoryName"),
                        rs.getObject("ParentCategoryID") != null ? rs.getInt("ParentCategoryID") : null
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
