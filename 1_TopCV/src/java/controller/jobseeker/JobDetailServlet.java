package controller.jobseeker;

import dal.JobDetailDAO;
import dal.CVDAO;
import model.JobDetail;
import model.JobSeeker;
import model.CV;
import util.SessionHelper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/job-detail")
public class JobDetailServlet extends HttpServlet {
    
    private JobDetailDAO jobDetailDAO;
    private CVDAO cvDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        jobDetailDAO = new JobDetailDAO();
        cvDAO = new CVDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String jobIdStr = request.getParameter("jobId");
            
            if (jobIdStr == null || jobIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/job-list");
                return;
            }
            
            int jobId;
            try {
                jobId = Integer.parseInt(jobIdStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/job-list");
                return;
            }
            
            JobDetail job = jobDetailDAO.getJobDetailById(jobId);
            
            if (job == null) {
                // Nếu không tìm thấy job, có thể hiển thị trang 404 hoặc redirect
                request.setAttribute("errorMessage", "Không tìm thấy công việc với ID: " + jobId);
                request.getRequestDispatcher("/error-job-detail.jsp").forward(request, response);
                return;
            }

            // Tăng số lượt xem
            jobDetailDAO.incrementJobViewCount(jobId);
            
            // Check JobSeeker có trong session và load CV list
            JobSeeker currentJobSeeker = SessionHelper.getCurrentJobSeeker(request);
            if (currentJobSeeker != null) {
                List<CV> cvList = cvDAO.getCVsByJobSeekerId(currentJobSeeker.getJobSeekerId());
                request.setAttribute("cvList", cvList);
                request.setAttribute("isLoggedIn", true);
            } else {
                request.setAttribute("isLoggedIn", false);
            }
            
            request.setAttribute("job", job);
            request.getRequestDispatcher("/JobSeeker/job-detail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải thông tin công việc: " + e.getMessage());
            request.getRequestDispatcher("/error-job-detail.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}