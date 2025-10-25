package controller;

import dal.ContentDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ViewCountServlet", urlPatterns = {"/view-count"})
public class ViewCountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Get content ID from request parameter
            String contentIdParam = request.getParameter("id");
            
            if (contentIdParam == null || contentIdParam.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Content ID is required\"}");
                return;
            }
            
            int contentID = Integer.parseInt(contentIdParam);
            
            // Increment view count
            ContentDAO contentDAO = new ContentDAO();
            boolean success = contentDAO.incrementViewCount(contentID);
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"View count updated\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to update view count\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid content ID format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Internal server error\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
