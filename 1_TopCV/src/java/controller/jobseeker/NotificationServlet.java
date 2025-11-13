package controller.jobseeker;

import dal.NotificationDAO;
import model.Notification;
import model.JobSeeker;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notifications"})
public class NotificationServlet extends HttpServlet {
    
    private NotificationDAO notificationDAO;
    
    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            out.print("{\"success\":false,\"message\":\"Not logged in\"}");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "getRecent";
        
        try {
            switch (action) {
                case "getRecent":
                    handleGetRecent(request, session, out);
                    break;
                case "getUnreadCount":
                    handleGetUnreadCount(session, out);
                    break;
                case "getByStatus":
                    handleGetByStatus(request, session, out);
                    break;
                default:
                    out.print("{\"success\":false}");
            }
        } catch (Exception e) {
            out.print("{\"success\":false,\"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            out.print("{\"success\":false}");
            return;
        }
        
        String action = request.getParameter("action");
        try {
            if ("markAsRead".equals(action)) {
                handleMarkAsRead(request, out);
            } else if ("markAllAsRead".equals(action)) {
                handleMarkAllAsRead(session, out);
            } else {
                out.print("{\"success\":false}");
            }
        } catch (Exception e) {
            out.print("{\"success\":false}");
        }
    }
    
    private void handleGetRecent(HttpServletRequest request, HttpSession session, PrintWriter out) {
        int userID = getUserID(session);
        String userType = getUserType(session);
        int limit = 20;
        try {
            limit = Integer.parseInt(request.getParameter("limit"));
        } catch (Exception e) {}
        
        List<Notification> notifications = notificationDAO.getRecentNotifications(userID, userType, limit);
        out.print("{\"success\":true,\"count\":" + notifications.size() + ",\"notifications\":[");
        for (int i = 0; i < notifications.size(); i++) {
            if (i > 0) out.print(",");
            out.print(notificationToJson(notifications.get(i)));
        }
        out.print("]}");
    }
    
    private void handleGetUnreadCount(HttpSession session, PrintWriter out) {
        int count = notificationDAO.getUnreadCount(getUserID(session), getUserType(session));
        out.print("{\"success\":true,\"unreadCount\":" + count + "}");
    }
    
    private void handleGetByStatus(HttpServletRequest request, HttpSession session, PrintWriter out) {
        String status = request.getParameter("status");
        if (status == null) {
            out.print("{\"success\":false}");
            return;
        }
        
        boolean isRead = "read".equalsIgnoreCase(status);
        List<Notification> notifications = notificationDAO.getNotificationsByStatus(
            getUserID(session), getUserType(session), isRead);
        
        out.print("{\"success\":true,\"count\":" + notifications.size() + ",\"notifications\":[");
        for (int i = 0; i < notifications.size(); i++) {
            if (i > 0) out.print(",");
            out.print(notificationToJson(notifications.get(i)));
        }
        out.print("]}");
    }
    
    private void handleMarkAsRead(HttpServletRequest request, PrintWriter out) {
        try {
            String notificationIDStr = request.getParameter("notificationID");
            if (notificationIDStr == null || notificationIDStr.isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Missing notificationID\"}");
                return;
            }
            
            int id = Integer.parseInt(notificationIDStr);
            boolean success = notificationDAO.markAsRead(id);
            out.print("{\"success\":" + success + "}");
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Invalid notificationID format\"}");
        } catch (Exception e) {
            out.print("{\"success\":false,\"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }
    
    private void handleMarkAllAsRead(HttpSession session, PrintWriter out) {
        boolean success = notificationDAO.markAllAsRead(getUserID(session), getUserType(session));
        out.print("{\"success\":" + success + "}");
    }
    
    private String notificationToJson(Notification n) {
        StringBuilder json = new StringBuilder();
        json.append("{\"notificationID\":").append(n.getNotificationID());
        json.append(",\"title\":\"").append(escapeJson(n.getTitle())).append("\"");
        json.append(",\"message\":\"").append(escapeJson(n.getMessage())).append("\"");
        json.append(",\"notificationType\":\"").append(n.getNotificationType()).append("\"");
        json.append(",\"iconType\":\"").append(n.getIconType()).append("\"");
        json.append(",\"isRead\":").append(n.isRead());
        json.append(",\"priority\":").append(n.getPriority());
        json.append(",\"actionURL\":\"").append(n.getActionURL() != null ? escapeJson(n.getActionURL()) : "").append("\"");
        if (n.getCreatedAt() != null) {
            json.append(",\"timeAgo\":\"").append(getTimeAgo(n.getCreatedAt())).append("\"");
        }
        json.append("}");
        return json.toString();
    }
    
    private String getTimeAgo(LocalDateTime dateTime) {
        long seconds = Duration.between(dateTime, LocalDateTime.now()).getSeconds();
        if (seconds < 60) return "Vừa xong";
        if (seconds < 3600) return (seconds / 60) + " phút trước";
        if (seconds < 86400) return (seconds / 3600) + " giờ trước";
        if (seconds < 604800) return (seconds / 86400) + " ngày trước";
        if (seconds < 2592000) return (seconds / 604800) + " tuần trước";
        return (seconds / 2592000) + " tháng trước";
    }
    
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n");
    }
    
    private int getUserID(HttpSession session) {
        Object user = session.getAttribute("user");
        return (user instanceof JobSeeker) ? ((JobSeeker) user).getJobSeekerId() : 0;
    }
    
    private String getUserType(HttpSession session) {
        String type = (String) session.getAttribute("userType");
        return type != null ? type : "jobseeker";
    }
}
