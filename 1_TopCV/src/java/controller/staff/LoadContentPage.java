
package controller.staff;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import dal.CampaignDAO;
import dal.ContentDAO;
import jakarta.servlet.http.HttpSession;
import model.Campaign;
import model.MarketingContent;
import model.Admin;


@WebServlet(name="LoadContentPage", urlPatterns={"/loadcontentpage"})
public class LoadContentPage extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoadContentPage</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoadContentPage at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");
        
        // Check if admin is logged in
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
            return;
        }
        
        try {
            // Fix content display issues first
            ContentDAO contentDAO = new ContentDAO();
            
            // Update PostDate to current date for published content with future dates
            contentDAO.updatePostDateToCurrent();
            
            // Publish draft content for website platform
            try {
                java.sql.Connection conn = contentDAO.getConnection();
                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                    "UPDATE MarketingContents " +
                    "SET Status = 'Published', PostDate = GETDATE() " +
                    "WHERE Status = 'Draft' " +
                    "AND Platform = 'Website'")) {
                    int rowsAffected = ps.executeUpdate();
                    System.out.println("Published " + rowsAffected + " draft content items for Website platform");
                }
            } catch (Exception e) {
                System.out.println("Error publishing draft content: " + e.getMessage());
            }
            
            // Load campaigns for dropdown
            CampaignDAO campaignDAO = new CampaignDAO();
            List<Campaign> campaigns = campaignDAO.getAllActiveCampaigns();
            request.setAttribute("campaigns", campaigns);
            
            // Load all content for table
            List<MarketingContent> contents = contentDAO.getAllContent();
            request.setAttribute("contents", contents);
            
            // Load statistics
            int publishedCount = contentDAO.getContentCountByStatus("Published");
            int draftCount = contentDAO.getContentCountByStatus("Draft");
            int archivedCount = contentDAO.getContentCountByStatus("Archived");
            
            request.setAttribute("publishedCount", publishedCount);
            request.setAttribute("draftCount", draftCount);
            request.setAttribute("archivedCount", archivedCount);
            request.setAttribute("totalCount", contents.size());
            
            // Check for success message in session
            String successMessage = (String) session.getAttribute("success");
            if (successMessage != null) {
                request.setAttribute("success", successMessage);
                session.removeAttribute("success"); // Remove after displaying
            }
            
            // Add fix content message
            request.setAttribute("fixMessage", "Content display issues have been automatically fixed!");
            
            // Forward to JSP
            request.getRequestDispatcher("/Staff/content.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Staff/marketinghome.jsp");
        }
    } 


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}


