package controller.jobseeker;

import dal.SkillDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.JobSeeker;
import util.SessionHelper;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ManageSkillsServlet", urlPatterns = {"/manage-skills"})
public class ManageSkillsServlet extends HttpServlet {
    
    private SkillDAO skillDAO;
    
    public ManageSkillsServlet() {
        try {
            this.skillDAO = new SkillDAO();
        } catch (Exception e) {
            System.err.println("Error initializing SkillDAO: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        StringBuilder jsonResponse = new StringBuilder();
        
        // Check authentication
        JobSeeker currentJobSeeker = SessionHelper.getCurrentJobSeeker(request);
        Integer userId = SessionHelper.getCurrentUserId(request);
        
        if (currentJobSeeker == null || userId == null || !SessionHelper.isJobSeeker(request)) {
            jsonResponse.append("{\"success\":false,\"message\":\"Unauthorized access\"}");
            out.print(jsonResponse.toString());
            out.flush();
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                // Add skill to profile
                int skillId = Integer.parseInt(request.getParameter("skillId"));
                
                // Check if skill already exists
                if (skillDAO.hasSkill(userId, skillId)) {
                    jsonResponse.append("{\"success\":false,\"message\":\"Kỹ năng này đã có trong hồ sơ của bạn\"}");
                } else {
                    boolean success = skillDAO.addSkillToJobSeeker(userId, skillId);
                    if (success) {
                        jsonResponse.append("{\"success\":true,\"message\":\"Thêm kỹ năng thành công\"}");
                    } else {
                        jsonResponse.append("{\"success\":false,\"message\":\"Không thể thêm kỹ năng. Vui lòng thử lại.\"}");
                    }
                }
                
            } else if ("remove".equals(action)) {
                // Remove skill from profile
                int skillId = Integer.parseInt(request.getParameter("skillId"));
                boolean success = skillDAO.removeSkillFromJobSeeker(userId, skillId);
                
                if (success) {
                    jsonResponse.append("{\"success\":true,\"message\":\"Xóa kỹ năng thành công\"}");
                } else {
                    jsonResponse.append("{\"success\":false,\"message\":\"Không thể xóa kỹ năng. Vui lòng thử lại.\"}");
                }
                
            } else {
                jsonResponse.append("{\"success\":false,\"message\":\"Invalid action\"}");
            }
            
        } catch (NumberFormatException e) {
            jsonResponse.append("{\"success\":false,\"message\":\"Invalid skill ID\"}");
        } catch (Exception e) {
            jsonResponse.append("{\"success\":false,\"message\":\"Đã có lỗi xảy ra: ").append(escapeJson(e.getMessage())).append("\"}");
            e.printStackTrace();
        }
        
        out.print(jsonResponse.toString());
        out.flush();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
    
    /**
     * Escape special characters for JSON string
     */
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
