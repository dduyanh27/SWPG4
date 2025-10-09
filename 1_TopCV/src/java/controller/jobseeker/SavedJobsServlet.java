package controller.jobseeker;

import dal.SavedJobDAO;
import model.JobSeeker;
import model.SavedJob;
import util.SessionHelper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Servlet for handling saved jobs functionality
 */
public class SavedJobsServlet extends HttpServlet {
    
    private SavedJobDAO savedJobDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        savedJobDAO = new SavedJobDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("SavedJobsServlet: doGet called");
        
        // Get current job seeker from session
        JobSeeker jobSeeker = SessionHelper.getCurrentJobSeeker(request);
        
        if (jobSeeker == null) {
            System.out.println("SavedJobsServlet: JobSeeker is null, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/JobSeeker/jobseeker-login.jsp");
            return;
        }
        
        int jobSeekerId = jobSeeker.getJobSeekerId();
        System.out.println("SavedJobsServlet: JobSeekerId = " + jobSeekerId);
        
        // Get all saved jobs for this job seeker
        List<SavedJob> savedJobs = savedJobDAO.getSavedJobsByJobSeeker(jobSeekerId);
        System.out.println("SavedJobsServlet: Found " + savedJobs.size() + " saved jobs");
        
        // Set attributes and forward to JSP
        request.setAttribute("savedJobs", savedJobs);
        request.setAttribute("totalSavedJobs", savedJobs.size());
        
        request.getRequestDispatcher("/JobSeeker/saved-jobs.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("SavedJobsServlet: doPost called");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        // Get current job seeker from session
        JobSeeker jobSeeker = SessionHelper.getCurrentJobSeeker(request);
        
        if (jobSeeker == null) {
            System.out.println("SavedJobsServlet: JobSeeker is null in POST");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\": false, \"message\": \"Vui lòng đăng nhập\"}");
            return;
        }
        
        try {
            String action = request.getParameter("action");
            String jobIdStr = request.getParameter("jobId");
            System.out.println("SavedJobsServlet: action=" + action + ", jobId=" + jobIdStr);
            
            if (jobIdStr == null || jobIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"success\": false, \"message\": \"Thiếu thông tin công việc\"}");
                return;
            }
            
            int jobId = Integer.parseInt(jobIdStr);
            int jobSeekerId = jobSeeker.getJobSeekerId();
            
            if ("save".equals(action)) {
                // Save job
                boolean saved = savedJobDAO.saveJob(jobSeekerId, jobId);
                
                if (saved) {
                    out.write("{\"success\": true, \"message\": \"Đã lưu công việc\", \"action\": \"saved\"}");
                } else {
                    out.write("{\"success\": false, \"message\": \"Công việc đã được lưu trước đó\"}");
                }
                
            } else if ("unsave".equals(action)) {
                // Unsave job
                boolean unsaved = savedJobDAO.unsaveJob(jobSeekerId, jobId);
                
                if (unsaved) {
                    out.write("{\"success\": true, \"message\": \"Đã bỏ lưu công việc\", \"action\": \"unsaved\"}");
                } else {
                    out.write("{\"success\": false, \"message\": \"Không thể bỏ lưu công việc\"}");
                }
                
            } else if ("check".equals(action)) {
                // Check if job is saved
                boolean isSaved = savedJobDAO.isJobSaved(jobSeekerId, jobId);
                out.write("{\"success\": true, \"isSaved\": " + isSaved + "}");
                
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"success\": false, \"message\": \"Hành động không hợp lệ\"}");
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"message\": \"ID công việc không hợp lệ\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"success\": false, \"message\": \"Có lỗi xảy ra: " + e.getMessage() + "\"}");
        }
    }
}
