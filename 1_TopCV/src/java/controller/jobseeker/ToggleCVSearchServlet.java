package controller.jobseeker;

import dal.CVDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.JobSeeker;
import util.SessionHelper;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/ToggleCVSearchServlet")
public class ToggleCVSearchServlet extends HttpServlet {
    
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
            // Kiểm tra người dùng đã đăng nhập
            JobSeeker currentJobSeeker = SessionHelper.getCurrentJobSeeker(request);
            Integer userId = SessionHelper.getCurrentUserId(request);
            
            if (currentJobSeeker == null || userId == null || !SessionHelper.isJobSeeker(request)) {
                out.print("{\"success\":false,\"message\":\"Vui lòng đăng nhập để thực hiện thao tác này\"}");
                return;
            }
            
            // Lấy tham số từ request
            String cvIDStr = request.getParameter("cvID");
            String isActiveStr = request.getParameter("isActive");
            
            if (cvIDStr == null || isActiveStr == null) {
                out.print("{\"success\":false,\"message\":\"Thiếu thông tin cvID hoặc isActive\"}");
                return;
            }
            
            int cvID = Integer.parseInt(cvIDStr);
            int isActive = Integer.parseInt(isActiveStr);
            
            // Validate isActive chỉ có thể là 0 hoặc 1
            if (isActive != 0 && isActive != 1) {
                out.print("{\"success\":false,\"message\":\"Giá trị isActive không hợp lệ\"}");
                return;
            }
            
            // Kiểm tra CV có thuộc về JobSeeker hiện tại không
            boolean cvBelongsToUser = cvDAO.checkCVBelongsToJobSeeker(cvID, currentJobSeeker.getJobSeekerId());
            if (!cvBelongsToUser) {
                out.print("{\"success\":false,\"message\":\"CV không thuộc về bạn\"}");
                return;
            }
            
            // Cập nhật isActive
            boolean updated = cvDAO.updateCVIsActive(cvID, isActive);
            
            if (updated) {
                out.print("{\"success\":true,\"message\":\"Cập nhật thành công\",\"cvID\":" + cvID + ",\"isActive\":" + isActive + "}");
            } else {
                out.print("{\"success\":false,\"message\":\"Không thể cập nhật CV\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Định dạng số không hợp lệ\"}");
            e.printStackTrace();
        } catch (Exception e) {
            out.print("{\"success\":false,\"message\":\"Có lỗi xảy ra: " + e.getMessage() + "\"}");
            e.printStackTrace();
        } finally {
            out.flush();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported.");
    }
}
