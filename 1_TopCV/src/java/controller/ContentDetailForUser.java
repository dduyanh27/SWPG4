package controller;

import dal.ContentDAO;
import dal.CampaignDAO;
import model.MarketingContent;
import model.Campaign;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ContentDetailForUser", urlPatterns = {"/content-detail"})
public class ContentDetailForUser extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get content ID from request parameter
            String contentIdStr = request.getParameter("id");
            
            if (contentIdStr == null || contentIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/JobSeeker/index.jsp");
                return;
            }
            
            // Parse content ID
            int contentId;
            try {
                contentId = Integer.parseInt(contentIdStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/JobSeeker/index.jsp");
                return;
            }
            
            // Get content details from database
            ContentDAO contentDAO = new ContentDAO();
            MarketingContent content = contentDAO.getContentById(contentId);
            
            if (content == null || !"Published".equals(content.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/JobSeeker/index.jsp");
                return;
            }
            
            // Get campaign details
            CampaignDAO campaignDAO = new CampaignDAO();
            Campaign campaign = campaignDAO.getCampaignById(content.getCampaignID());
            
            // Set attributes for JSP
            request.setAttribute("content", content);
            request.setAttribute("campaign", campaign);
            
            // Forward to detail page
            request.getRequestDispatcher("/JobSeeker/content-details-foruser.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/JobSeeker/index.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to GET method
        doGet(request, response);
    }
}
