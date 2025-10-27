package controller.admin;

import dal.JobDetailDAO;
import model.JobDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/adminviewjob")
public class AdminViewJobServlet extends HttpServlet {
    
    private JobDetailDAO jobDetailDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        jobDetailDAO = new JobDetailDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set headers to prevent caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        try {
            String jobIdStr = request.getParameter("jobId");
            
            if (jobIdStr == null || jobIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/Admin/admin-jobposting-management.jsp");
                return;
            }
            
            int jobId;
            try {
                jobId = Integer.parseInt(jobIdStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/Admin/admin-jobposting-management.jsp");
                return;
            }
            
            JobDetail job = jobDetailDAO.getJobDetailById(jobId);
            
            if (job == null) {
                // Nếu không tìm thấy job, redirect về trang quản lý
                response.sendRedirect(request.getContextPath() + "/Admin/admin-jobposting-management.jsp");
                return;
            }
            
            // Set job detail vào request
            request.setAttribute("job", job);
            
            // Set isLoggedIn = false cho Admin (vì Admin không cần đăng nhập như JobSeeker)
            request.setAttribute("isLoggedIn", false);
            
            // Set empty cvList để tránh lỗi
            request.setAttribute("cvList", new java.util.ArrayList<>());
            
            // Forward đến trang job-detail.jsp
            request.getRequestDispatcher("/JobSeeker/job-detail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Admin/admin-jobposting-management.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to GET method
        doGet(request, response);
    }
}


