package controller.jobseeker;

import dal.CVDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.CV;
import model.JobSeeker;
import util.SessionHelper;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/DeleteCVServlet")
public class DeleteCVServlet extends HttpServlet {
    
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
            
            if (cvIDStr == null || cvIDStr.isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Thiếu thông tin cvID\"}");
                return;
            }
            
            int cvID = Integer.parseInt(cvIDStr);
            
            // Kiểm tra CV có tồn tại không
            CV cv = cvDAO.getCVById(cvID);
            if (cv == null) {
                out.print("{\"success\":false,\"message\":\"CV không tồn tại\"}");
                return;
            }
            
            // Kiểm tra CV có thuộc về JobSeeker hiện tại không
            boolean cvBelongsToUser = cvDAO.checkCVBelongsToJobSeeker(cvID, currentJobSeeker.getJobSeekerId());
            if (!cvBelongsToUser) {
                out.print("{\"success\":false,\"message\":\"Bạn không có quyền xóa CV này\"}");
                return;
            }
            
            // Lấy đường dẫn file để xóa file vật lý
            String cvURL = cv.getCvURL();
            
            // Xóa CV khỏi database
            boolean deleted = cvDAO.deleteCV(cvID);
            
            if (deleted) {
                // Xóa file vật lý nếu tồn tại
                if (cvURL != null && !cvURL.isEmpty()) {
                    try {
                        // Lấy đường dẫn thực tế của file
                        String realPath = getServletContext().getRealPath(cvURL);
                        File file = new File(realPath);
                        
                        if (file.exists()) {
                            boolean fileDeleted = file.delete();
                            if (fileDeleted) {
                                System.out.println("File deleted successfully: " + realPath);
                            } else {
                                System.out.println("Failed to delete file: " + realPath);
                            }
                        } else {
                            System.out.println("File does not exist: " + realPath);
                        }
                    } catch (Exception e) {
                        System.err.println("Error deleting file: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
                
                out.print("{\"success\":true,\"message\":\"Xóa CV thành công\",\"cvID\":" + cvID + "}");
            } else {
                out.print("{\"success\":false,\"message\":\"Không thể xóa CV khỏi database\"}");
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
