package dal;

import model.Notification;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO extends DBContext {
    
    // Get notifications by user
    public List<Notification> getNotificationsByUser(int userID, String userType) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE userID = ? AND userType = ? ORDER BY createdAt DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setString(2, userType);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                notifications.add(extractNotificationFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return notifications;
    }
    
    // Get unread count
    public int getUnreadCount(int userID, String userType) {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE userID = ? AND userType = ? AND isRead = 0";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setString(2, userType);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Get recent notifications with limit
    public List<Notification> getRecentNotifications(int userID, String userType, int limit) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM Notifications WHERE userID = ? AND userType = ? ORDER BY createdAt DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, userID);
            ps.setString(3, userType);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                notifications.add(extractNotificationFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return notifications;
    }
    
    // Get notifications by status (read/unread)
    public List<Notification> getNotificationsByStatus(int userID, String userType, boolean isRead) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE userID = ? AND userType = ? AND isRead = ? ORDER BY createdAt DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setString(2, userType);
            ps.setBoolean(3, isRead);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                notifications.add(extractNotificationFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return notifications;
    }
    
    // Mark as read
    public boolean markAsRead(int notificationID) {
        String sql = "UPDATE Notifications SET isRead = 1, readAt = GETDATE() WHERE notificationID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, notificationID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Mark all as read for a user
    public boolean markAllAsRead(int userID, String userType) {
        String sql = "UPDATE Notifications SET isRead = 1, readAt = GETDATE() WHERE userID = ? AND userType = ? AND isRead = 0";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setString(2, userType);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Create new notification
    public boolean createNotification(Notification notification) {
        String sql = "INSERT INTO Notifications (userID, userType, notificationType, title, message, " +
                    "relatedID, relatedType, isRead, createdAt, iconType, priority, actionURL) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, 0, GETDATE(), ?, ?, ?)";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, notification.getUserID());
            ps.setString(2, notification.getUserType());
            ps.setString(3, notification.getNotificationType());
            ps.setString(4, notification.getTitle());
            ps.setString(5, notification.getMessage());
            
            if (notification.getRelatedID() != null) {
                ps.setInt(6, notification.getRelatedID());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            
            ps.setString(7, notification.getRelatedType());
            ps.setString(8, notification.getIconType());
            ps.setInt(9, notification.getPriority());
            ps.setString(10, notification.getActionURL());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Delete notification
    public boolean deleteNotification(int notificationID) {
        String sql = "DELETE FROM Notifications WHERE notificationID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, notificationID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Helper method to extract Notification from ResultSet
    private Notification extractNotificationFromResultSet(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setNotificationID(rs.getInt("notificationID"));
        notification.setUserID(rs.getInt("userID"));
        notification.setUserType(rs.getString("userType"));
        notification.setNotificationType(rs.getString("notificationType"));
        notification.setTitle(rs.getString("title"));
        notification.setMessage(rs.getString("message"));
        
        int relatedID = rs.getInt("relatedID");
        if (!rs.wasNull()) {
            notification.setRelatedID(relatedID);
        }
        
        notification.setRelatedType(rs.getString("relatedType"));
        notification.setRead(rs.getBoolean("isRead"));
        
        Timestamp createdAt = rs.getTimestamp("createdAt");
        if (createdAt != null) {
            notification.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp readAt = rs.getTimestamp("readAt");
        if (readAt != null) {
            notification.setReadAt(readAt.toLocalDateTime());
        }
        
        notification.setIconType(rs.getString("iconType"));
        notification.setPriority(rs.getInt("priority"));
        notification.setActionURL(rs.getString("actionURL"));
        
        return notification;
    }
    
    // Static helper method to send notification (used by other servlets)
    public static void sendNotification(int userID, String userType, String notificationType,
                                       String title, String message, Integer relatedID,
                                       String relatedType, String actionURL, int priority) {
        try {
            NotificationDAO dao = new NotificationDAO();
            Notification notification = new Notification();
            notification.setUserID(userID);
            notification.setUserType(userType);
            notification.setNotificationType(notificationType);
            notification.setTitle(title);
            notification.setMessage(message);
            notification.setRelatedID(relatedID);
            notification.setRelatedType(relatedType);
            notification.setActionURL(actionURL);
            notification.setPriority(priority);
            
            // Set icon type based on notification type
            String iconType = "system";
            if ("application".equals(notificationType)) {
                iconType = "application";
            } else if ("profile".equals(notificationType)) {
                iconType = "profile";
            } else if ("chat".equals(notificationType)) {
                iconType = "chat";
            }
            notification.setIconType(iconType);
            
            dao.createNotification(notification);
        } catch (Exception e) {
            System.err.println("Error sending notification: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
