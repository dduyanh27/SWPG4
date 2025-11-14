package controller.jobseeker;

import dal.JobListDAO;
import dal.ContentDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.JobList;
import model.MarketingContent;

/**
 * Servlet for JobSeeker Index/Home Page
 * Loads featured GOLD jobs and marketing content
 */
@WebServlet(name = "IndexServlet", urlPatterns = {"/JobSeeker/index"})
public class IndexServlet extends HttpServlet {
    
    private JobListDAO jobListDAO;
    private ContentDAO contentDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        jobListDAO = new JobListDAO();
        contentDAO = new ContentDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check authentication status
        Integer jobSeekerID = (Integer) session.getAttribute("jobSeekerID");
        boolean isLoggedIn = (jobSeekerID != null);
        boolean isJobSeeker = isLoggedIn;
        
        // Set session attributes for JSP
        request.setAttribute("isLoggedIn", isLoggedIn);
        request.setAttribute("isJobSeeker", isJobSeeker);
        
        try {
            // Load Featured GOLD Jobs (Load all, pagination handled by JavaScript)
            List<JobList> featuredGoldJobs = jobListDAO.getFeaturedJobsGold(100); // Load up to 100 jobs
            request.setAttribute("featuredGoldJobs", featuredGoldJobs);
            
            // Load Marketing Content
            List<MarketingContent> marketingContents = contentDAO.getPublishedContentForWebsite();
            // Limit to 6 items
            if (marketingContents.size() > 6) {
                marketingContents = marketingContents.subList(0, 6);
            }
            request.setAttribute("marketingContents", marketingContents);
            
        } catch (Exception e) {
            // Set empty lists to avoid null pointer exceptions
            request.setAttribute("featuredGoldJobs", new java.util.ArrayList<>());
            request.setAttribute("marketingContents", new java.util.ArrayList<>());
        }
        
        // Forward to JSP
        request.getRequestDispatcher("/JobSeeker/index.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "JobSeeker Index/Home Page Servlet";
    }
}
