package controller.staff;

import dal.ContentDAO;
import dal.CampaignDAO;
import model.MarketingContent;
import model.Campaign;
import model.Admin;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ContentDetail", urlPatterns = {"/Staff/ContentDetail"})
public class ContentDetail extends HttpServlet {

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
            
            // Get campaign details
            CampaignDAO campaignDAO = new CampaignDAO();
            Campaign campaign = campaignDAO.getCampaignById(content.getCampaignID());
            
            // Set attributes for JSP
            request.setAttribute("content", content);
            request.setAttribute("campaign", campaign);
            
            // Forward to detail page
            request.getRequestDispatcher("/Staff/ContentDetail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to GET method
        doGet(request, response);
    }
}


