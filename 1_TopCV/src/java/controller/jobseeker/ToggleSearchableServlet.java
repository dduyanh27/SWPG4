package controller.jobseeker;

import dal.CVDAO;
import model.CV;
import model.JobSeeker;
import util.SessionHelper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet để xử lý bật/tắt chức năng cho phép tìm kiếm CV
 * IsActive = 1 (true) : Cho phép tìm kiếm
 * IsActive = 0 (false): Không cho phép tìm kiếm
 */
@WebServlet("/ToggleSearchableServlet")
public class ToggleSearchableServlet extends HttpServlet {
    
    private CVDAO cvDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        cvDAO = new CVDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            System.out.println("=== ToggleSearchableServlet: Request received ===");
            
            // Kiểm tra đăng nhập
            JobSeeker jobSeeker = SessionHelper.getCurrentJobSeeker(request);
            System.out.println("JobSeeker from session: " + (jobSeeker != null ? jobSeeker.getJobSeekerId() : "null"));
            
            if (jobSeeker == null) {
                System.out.println("ERROR: JobSeeker not logged in");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"success\": false, \"message\": \"Vui lòng đăng nhập\"}");
                return;
            }
            
            // Lấy parameters từ query string hoặc form data
            String cvIdStr = request.getParameter("cvId");
            String searchableStr = request.getParameter("searchable");
            System.out.println("Parameters received:");
            System.out.println("  - cvId: " + cvIdStr);
            System.out.println("  - searchable: " + searchableStr);
            System.out.println("  - Query String: " + request.getQueryString());
            System.out.println("  - Content Type: " + request.getContentType());
            
            if (cvIdStr == null || cvIdStr.trim().isEmpty()) {
                System.out.println("ERROR: Missing cvId parameter");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"Thiếu thông tin cvId\"}");
                return;
            }
            
            if (searchableStr == null || searchableStr.trim().isEmpty()) {
                System.out.println("ERROR: Missing searchable parameter");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"Thiếu thông tin searchable\"}");
                return;
            }
            
            int cvId = Integer.parseInt(cvIdStr);
            boolean isActive = Boolean.parseBoolean(searchableStr);
            System.out.println("Parsed: cvId=" + cvId + ", isActive=" + isActive);
            
            // Kiểm tra CV có thuộc về JobSeeker hiện tại không
            CV cv = cvDAO.getCVById(cvId);
            System.out.println("CV from database: " + (cv != null ? "Found (JobSeekerId=" + cv.getJobSeekerId() + ")" : "null"));
            
            if (cv == null) {
                System.out.println("ERROR: CV not found");
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"success\": false, \"message\": \"Không tìm thấy CV\"}");
                return;
            }
            
            if (cv.getJobSeekerId() != jobSeeker.getJobSeekerId()) {
                System.out.println("ERROR: CV does not belong to current JobSeeker");
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.print("{\"success\": false, \"message\": \"Bạn không có quyền cập nhật CV này\"}");
                return;
            }
            
            // Cập nhật trạng thái IsActive
            System.out.println("Updating CV IsActive to: " + isActive);
            boolean success = cvDAO.updateIsActive(cvId, isActive);
            System.out.println("Update result: " + success);
            
            if (success) {
                String statusText = isActive ? "cho phép" : "không cho phép";
                System.out.println("SUCCESS: CV updated successfully");
                out.print("{\"success\": true, \"message\": \"Đã cập nhật CV " + statusText + " tìm kiếm\"}");
            } else {
                System.out.println("ERROR: Failed to update CV in database");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\": false, \"message\": \"Không thể cập nhật trạng thái CV\"}");
            }
            
        } catch (NumberFormatException e) {
            System.out.println("ERROR: NumberFormatException - " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ\"}");
        } catch (Exception e) {
            System.out.println("ERROR: Exception - " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
        } finally {
            out.flush();
            System.out.println("=== ToggleSearchableServlet: Request completed ===\n");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}
