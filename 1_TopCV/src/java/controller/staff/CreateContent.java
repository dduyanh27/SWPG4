package controller.staff;

import dal.ContentDAO;
import model.MarketingContent;
import model.Admin;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CreateContent", urlPatterns = {"/Staff/CreateContent"})
public class CreateContent extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Check if user is logged in
            HttpSession session = request.getSession();
            Admin admin = (Admin) session.getAttribute("admin");
            
            if (admin == null) {
                request.setAttribute("error", "Bạn cần đăng nhập để thực hiện chức năng này");
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
            
            // Validate required fields
            if (campaignIDStr == null || campaignIDStr.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn chiến dịch");
                request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
                return;
            }
            
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập tiêu đề");
                request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
                return;
            }
            
            if (platform == null || platform.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn nền tảng");
                request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
                return;
            }
            
            // Parse campaign ID
            int campaignID;
            try {
                campaignID = Integer.parseInt(campaignIDStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID chiến dịch không hợp lệ");
                request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
                return;
            }
            
            // Parse post date
            Timestamp postDate;
            if (postDateStr != null && !postDateStr.trim().isEmpty()) {
                try {
                    // Parse datetime-local format (YYYY-MM-DDTHH:mm)
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                    Date date = sdf.parse(postDateStr);
                    postDate = new Timestamp(date.getTime());
                } catch (ParseException e) {
                    request.setAttribute("error", "Định dạng ngày không hợp lệ");
                    request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
                    return;
                }
            } else {
                // If no date specified, use current time
                postDate = new Timestamp(System.currentTimeMillis());
            }
            
            // Create MarketingContent object
            MarketingContent content = new MarketingContent();
            content.setCampaignID(campaignID);
            content.setTitle(title.trim());
            content.setContentText(contentText != null ? contentText.trim() : "");
            content.setMediaURL(mediaURL != null ? mediaURL.trim() : "");
            content.setPostDate(postDate);
            content.setPlatform(platform);
            content.setStatus(status != null ? status : "Draft");
            content.setCreatedBy(admin.getAdminId());
            
            // Insert content into database
            ContentDAO contentDAO = new ContentDAO();
            boolean success = contentDAO.insertContent(content);
            
            if (success) {
                request.setAttribute("success", "Tạo nội dung thành công!");
                response.sendRedirect(request.getContextPath() + "/Staff/content.jsp");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi tạo nội dung. Vui lòng thử lại.");
                request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to content management page
        response.sendRedirect(request.getContextPath() + "/Staff/content.jsp");
    }
}

