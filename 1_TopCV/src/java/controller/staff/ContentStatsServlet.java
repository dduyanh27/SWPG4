package controller.staff;

import dal.ContentDAO;
import model.MarketingContent;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ContentStatsServlet", urlPatterns = {"/Staff/content-stats"})
public class ContentStatsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in as admin/staff
        HttpSession session = request.getSession();
        Object adminObj = session.getAttribute("admin");
        
        if (adminObj == null) {
            response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
            return;
        }
        
        try {
            ContentDAO contentDAO = new ContentDAO();
            
            // Get current admin/staff info
            model.Admin currentAdmin = (model.Admin) adminObj;
            int currentStaffId = currentAdmin.getAdminId();
            
            // Get all content with view counts
            List<MarketingContent> allContent = contentDAO.getAllContent();
            
            // Get content by status for different views
            List<MarketingContent> publishedContent = contentDAO.getContentByStatus("Published");
            List<MarketingContent> draftContent = contentDAO.getContentByStatus("Draft");
            List<MarketingContent> archivedContent = contentDAO.getContentByStatus("Archived");
            
            // Calculate total views for current staff
            int totalViews = contentDAO.countView(currentStaffId);
            int publishedViews = contentDAO.countView(currentStaffId, "Published");
            int draftViews = contentDAO.countView(currentStaffId, "Draft");
            int archivedViews = contentDAO.countView(currentStaffId, "Archived");
            
            // Filter content by current staff
            List<MarketingContent> myContent = allContent.stream()
                    .filter(content -> content.getCreatedBy() == currentStaffId)
                    .collect(java.util.stream.Collectors.toList());
            
            List<MarketingContent> myPublishedContent = publishedContent.stream()
                    .filter(content -> content.getCreatedBy() == currentStaffId)
                    .collect(java.util.stream.Collectors.toList());
            
            List<MarketingContent> myDraftContent = draftContent.stream()
                    .filter(content -> content.getCreatedBy() == currentStaffId)
                    .collect(java.util.stream.Collectors.toList());
            
            List<MarketingContent> myArchivedContent = archivedContent.stream()
                    .filter(content -> content.getCreatedBy() == currentStaffId)
                    .collect(java.util.stream.Collectors.toList());
            
            // Set attributes for JSP
            request.setAttribute("allContent", myContent);
            request.setAttribute("publishedContent", myPublishedContent);
            request.setAttribute("draftContent", myDraftContent);
            request.setAttribute("archivedContent", myArchivedContent);
            request.setAttribute("totalViews", totalViews);
            request.setAttribute("publishedViews", publishedViews);
            request.setAttribute("draftViews", draftViews);
            request.setAttribute("archivedViews", archivedViews);
            request.setAttribute("totalContent", myContent.size());
            request.setAttribute("publishedCount", myPublishedContent.size());
            request.setAttribute("draftCount", myDraftContent.size());
            request.setAttribute("archivedCount", myArchivedContent.size());
            request.setAttribute("currentStaffName", currentAdmin.getFullName());
            
            // Forward to JSP
            request.getRequestDispatcher("/Staff/content-stats.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải thống kê: " + e.getMessage());
            request.getRequestDispatcher("/Staff/content-stats.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}


