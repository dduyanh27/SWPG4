package controller.staff;

import dal.ContentDAO;
import dal.CampaignDAO;
import model.MarketingContent;
import model.Campaign;
import model.Admin;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UpdateContent", urlPatterns = {"/Staff/UpdateContent"})
public class UpdateContent extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Check if user is logged in
            HttpSession session = request.getSession();
            Admin admin = (Admin) session.getAttribute("admin");
            
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
                return;
            }
            
            // Get content ID from request parameter
            String contentIdStr = request.getParameter("id");
            
            if (contentIdStr == null || contentIdStr.trim().isEmpty()) {
                request.setAttribute("error", "ID nội dung không hợp lệ");
                request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
                return;
            }
            
            // Parse content ID
            int contentId;
            try {
                contentId = Integer.parseInt(contentIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID nội dung không hợp lệ");
                request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
                return;
            }
            
            // Get content details from database
            ContentDAO contentDAO = new ContentDAO();
            MarketingContent content = contentDAO.getContentById(contentId);
            
            if (content == null) {
                request.setAttribute("error", "Không tìm thấy nội dung");
                request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
                return;
            }
            
            // Get all active campaigns for dropdown
            CampaignDAO campaignDAO = new CampaignDAO();
            List<Campaign> campaigns = campaignDAO.getAllActiveCampaigns();
            
            // Set attributes for JSP
            request.setAttribute("content", content);
            request.setAttribute("campaigns", campaigns);
            
            // Forward to update page
            request.getRequestDispatcher("/Staff/UpdateContent.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== UpdateContent POST method called ===");
        
        try {
            // Check if user is logged in
            HttpSession session = request.getSession();
            Admin admin = (Admin) session.getAttribute("admin");
            
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
                return;
            }
            
            // Get content ID from request parameter
            String contentIdStr = request.getParameter("contentID");
            
            if (contentIdStr == null || contentIdStr.trim().isEmpty()) {
                request.setAttribute("error", "ID nội dung không hợp lệ");
                request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
                return;
            }
            
            // Parse content ID
            int contentId;
            try {
                contentId = Integer.parseInt(contentIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID nội dung không hợp lệ");
                request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
                return;
            }
            
            // Get form parameters
            String campaignIDStr = request.getParameter("campaignID");
            String title = request.getParameter("title");
            String contentText = request.getParameter("contentText");
            String mediaURL = request.getParameter("mediaURL");
            String platform = request.getParameter("platform");
            String status = request.getParameter("status");
            String postDateStr = request.getParameter("postDate");
            
            System.out.println("Form parameters received:");
            System.out.println("contentID: " + contentIdStr);
            System.out.println("title: " + title);
            System.out.println("platform: " + platform);
            System.out.println("status: " + status);
            
            // Validate required fields
            if (campaignIDStr == null || campaignIDStr.trim().isEmpty() ||
                title == null || title.trim().isEmpty() ||
                platform == null || platform.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ các trường bắt buộc");
                request.getRequestDispatcher("/Staff/UpdateContent?id=" + contentId).forward(request, response);
                return;
            }
            
            // Parse campaign ID
            int campaignID;
            try {
                campaignID = Integer.parseInt(campaignIDStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID chiến dịch không hợp lệ");
                request.getRequestDispatcher("/Staff/UpdateContent?id=" + contentId).forward(request, response);
                return;
            }
            
            // Parse post date
            Timestamp postDate = null;
            if (postDateStr != null && !postDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                    Date date = sdf.parse(postDateStr);
                    postDate = new Timestamp(date.getTime());
                } catch (ParseException e) {
                    request.setAttribute("error", "Định dạng ngày không hợp lệ. Sử dụng: yyyy-MM-ddTHH:mm");
                    request.getRequestDispatcher("/Staff/UpdateContent?id=" + contentId).forward(request, response);
                    return;
                }
            }
            
            // Create MarketingContent object
            MarketingContent content = new MarketingContent();
            content.setContentID(contentId);
            content.setCampaignID(campaignID);
            content.setTitle(title.trim());
            content.setContentText(contentText != null ? contentText.trim() : "");
            content.setMediaURL(mediaURL != null ? mediaURL.trim() : "");
            content.setPostDate(postDate);
            content.setPlatform(platform.trim());
            content.setStatus(status != null ? status.trim() : "Draft");
            content.setCreatedBy(admin.getAdminId());
            
            // Update content in database
            ContentDAO contentDAO = new ContentDAO();
            System.out.println("Attempting to update content with ID: " + contentId);
            boolean success = contentDAO.updateContent(content);
            System.out.println("Update result: " + success);
            
            if (success) {
                session.setAttribute("success", "Cập nhật nội dung thành công!");
                response.sendRedirect(request.getContextPath() + "/loadcontentpage");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật nội dung");
                request.getRequestDispatcher("/Staff/UpdateContent?id=" + contentId).forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
        }
    }
}


