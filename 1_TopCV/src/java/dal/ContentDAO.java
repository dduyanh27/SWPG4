package dal;

import model.MarketingContent;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContentDAO extends DBContext {

    // Insert new content
    public boolean insertContent(MarketingContent content) {
        String sql = "INSERT INTO MarketingContents (CampaignID, Title, ContentText, MediaURL, PostDate, Platform, Status, CreatedBy) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, content.getCampaignID());
            ps.setString(2, content.getTitle());
            ps.setString(3, content.getContentText());
            ps.setString(4, content.getMediaURL());
            ps.setTimestamp(5, content.getPostDate());
            ps.setString(6, content.getPlatform());
            ps.setString(7, content.getStatus());
            ps.setInt(8, content.getCreatedBy());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all content with campaign name and creator name
    public List<MarketingContent> getAllContent() {
        List<MarketingContent> list = new ArrayList<>();
        String sql = "SELECT mc.*, c.CampaignName, a.FullName as CreatorName "
                + "FROM MarketingContents mc "
                + "LEFT JOIN Campaigns c ON mc.CampaignID = c.CampaignID "
                + "LEFT JOIN Admins a ON mc.CreatedBy = a.AdminID "
                + "ORDER BY mc.PostDate DESC";

        try (Statement st = c.createStatement(); ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                MarketingContent content = new MarketingContent(
                        rs.getInt("ContentID"),
                        rs.getInt("CampaignID"),
                        rs.getString("Title"),
                        rs.getString("ContentText"),
                        rs.getString("MediaURL"),
                        rs.getTimestamp("PostDate"),
                        rs.getString("Platform"),
                        rs.getString("Status"),
                        rs.getInt("CreatedBy"),
                        rs.getInt("ViewCount")
                );
                content.setCampaignName(rs.getString("CampaignName"));
                content.setCreatorName(rs.getString("CreatorName"));
                list.add(content);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Get content by ID
    public MarketingContent getContentById(int contentID) {
        String sql = "SELECT mc.*, c.CampaignName, a.FullName as CreatorName "
                + "FROM MarketingContents mc "
                + "LEFT JOIN Campaigns c ON mc.CampaignID = c.CampaignID "
                + "LEFT JOIN Admins a ON mc.CreatedBy = a.AdminID "
                + "WHERE mc.ContentID = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, contentID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MarketingContent content = new MarketingContent(
                            rs.getInt("ContentID"),
                            rs.getInt("CampaignID"),
                            rs.getString("Title"),
                            rs.getString("ContentText"),
                            rs.getString("MediaURL"),
                            rs.getTimestamp("PostDate"),
                            rs.getString("Platform"),
                            rs.getString("Status"),
                            rs.getInt("CreatedBy"),
                            rs.getInt("ViewCount")
                    );
                    content.setCampaignName(rs.getString("CampaignName"));
                    content.setCreatorName(rs.getString("CreatorName"));
                    return content;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Update content
    public boolean updateContent(MarketingContent content) {
        String sql = "UPDATE MarketingContents SET CampaignID = ?, Title = ?, ContentText = ?, "
                + "MediaURL = ?, PostDate = ?, Platform = ?, Status = ? WHERE ContentID = ?";

        System.out.println("ContentDAO.updateContent called for ID: " + content.getContentID());
        System.out.println("SQL: " + sql);

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, content.getCampaignID());
            ps.setString(2, content.getTitle());
            ps.setString(3, content.getContentText());
            ps.setString(4, content.getMediaURL());
            ps.setTimestamp(5, content.getPostDate());
            ps.setString(6, content.getPlatform());
            ps.setString(7, content.getStatus());
            ps.setInt(8, content.getContentID());

            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("SQL Exception in updateContent: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Delete content
    public boolean deleteContent(int contentID) {
        String sql = "DELETE FROM MarketingContents WHERE ContentID = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, contentID);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get content by status
    public List<MarketingContent> getContentByStatus(String status) {
        List<MarketingContent> list = new ArrayList<>();
        String sql = "SELECT mc.*, c.CampaignName, a.FullName as CreatorName "
                + "FROM MarketingContents mc "
                + "LEFT JOIN Campaigns c ON mc.CampaignID = c.CampaignID "
                + "LEFT JOIN Admins a ON mc.CreatedBy = a.AdminID "
                + "WHERE mc.Status = ? ORDER BY mc.PostDate DESC";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MarketingContent content = new MarketingContent(
                            rs.getInt("ContentID"),
                            rs.getInt("CampaignID"),
                            rs.getString("Title"),
                            rs.getString("ContentText"),
                            rs.getString("MediaURL"),
                            rs.getTimestamp("PostDate"),
                            rs.getString("Platform"),
                            rs.getString("Status"),
                            rs.getInt("CreatedBy"),
                            rs.getInt("ViewCount")
                    );
                    content.setCampaignName(rs.getString("CampaignName"));
                    content.setCreatorName(rs.getString("CreatorName"));
                    list.add(content);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Get content by campaign
    public List<MarketingContent> getContentByCampaign(int campaignID) {
        List<MarketingContent> list = new ArrayList<>();
        String sql = "SELECT mc.*, c.CampaignName, a.FullName as CreatorName "
                + "FROM MarketingContents mc "
                + "LEFT JOIN Campaigns c ON mc.CampaignID = c.CampaignID "
                + "LEFT JOIN Admins a ON mc.CreatedBy = a.AdminID "
                + "WHERE mc.CampaignID = ? ORDER BY mc.PostDate DESC";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, campaignID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MarketingContent content = new MarketingContent(
                            rs.getInt("ContentID"),
                            rs.getInt("CampaignID"),
                            rs.getString("Title"),
                            rs.getString("ContentText"),
                            rs.getString("MediaURL"),
                            rs.getTimestamp("PostDate"),
                            rs.getString("Platform"),
                            rs.getString("Status"),
                            rs.getInt("CreatedBy"),
                            rs.getInt("ViewCount")
                    );
                    content.setCampaignName(rs.getString("CampaignName"));
                    content.setCreatorName(rs.getString("CreatorName"));
                    list.add(content);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Get content statistics
    public int getContentCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM MarketingContents WHERE Status = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public void publishContent(int contentID) {
        String sql = """
        UPDATE MarketingContents
        SET 
            Status = 'Published',
            PostDate = GETDATE()
        WHERE ContentID = ?
    """;

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, contentID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<MarketingContent> getAllDraftContent() {
        List<MarketingContent> list = new ArrayList<>();
        String sql = "SELECT mc.*, c.CampaignName, a.FullName as CreatorName "
                + "FROM MarketingContents mc "
                + "LEFT JOIN Campaigns c ON mc.CampaignID = c.CampaignID "
                + "LEFT JOIN Admins a ON mc.CreatedBy = a.AdminID "
                + "where Status ='Draft'"
                + "ORDER BY mc.PostDate DESC";

        try (Statement st = c.createStatement(); ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                MarketingContent content = new MarketingContent(
                        rs.getInt("ContentID"),
                        rs.getInt("CampaignID"),
                        rs.getString("Title"),
                        rs.getString("ContentText"),
                        rs.getString("MediaURL"),
                        rs.getTimestamp("PostDate"),
                        rs.getString("Platform"),
                        rs.getString("Status"),
                        rs.getInt("CreatedBy"),
                        rs.getInt("ViewCount")
                );
                content.setCampaignName(rs.getString("CampaignName"));
                content.setCreatorName(rs.getString("CreatorName"));
                list.add(content);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<MarketingContent> getAllArchivedContent() {
        List<MarketingContent> list = new ArrayList<>();
        String sql = "SELECT mc.*, c.CampaignName, a.FullName as CreatorName "
                + "FROM MarketingContents mc "
                + "LEFT JOIN Campaigns c ON mc.CampaignID = c.CampaignID "
                + "LEFT JOIN Admins a ON mc.CreatedBy = a.AdminID "
                + "where Status ='Archived'"
                + "ORDER BY mc.PostDate DESC";

        try (Statement st = c.createStatement(); ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                MarketingContent content = new MarketingContent(
                        rs.getInt("ContentID"),
                        rs.getInt("CampaignID"),
                        rs.getString("Title"),
                        rs.getString("ContentText"),
                        rs.getString("MediaURL"),
                        rs.getTimestamp("PostDate"),
                        rs.getString("Platform"),
                        rs.getString("Status"),
                        rs.getInt("CreatedBy"),
                        rs.getInt("ViewCount")
                );
                content.setCampaignName(rs.getString("CampaignName"));
                content.setCreatorName(rs.getString("CreatorName"));
                list.add(content);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
    // Increment view count for a content
    public boolean incrementViewCount(int contentID) {
        String sql = "UPDATE MarketingContents SET ViewCount = ViewCount + 1 WHERE ContentID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, contentID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Count total views for content created by a specific staff member
    public int countView(int createdBy) {
        String sql = "SELECT SUM(ViewCount) FROM MarketingContents WHERE CreatedBy = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, createdBy);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int totalViews = rs.getInt(1);
                    return rs.wasNull() ? 0 : totalViews; // Return 0 if NULL
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Count total views for content created by a specific staff member with status filter
    public int countView(int createdBy, String status) {
        String sql = "SELECT SUM(ViewCount) FROM MarketingContents WHERE CreatedBy = ? AND Status = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, createdBy);
            ps.setString(2, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int totalViews = rs.getInt(1);
                    return rs.wasNull() ? 0 : totalViews; // Return 0 if NULL
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
}
