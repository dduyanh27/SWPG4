package controller.jobseeker;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dal.ApplicationDAO;
import model.ApplicationView;
import model.JobSeeker;
import util.SessionHelper;

/**
 * Servlet for handling applied jobs page
 */
public class AppliedJobsServlet extends HttpServlet {
    
    private ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("AppliedJobsServlet: doGet called");
        
        JobSeeker jobSeeker = SessionHelper.getCurrentJobSeeker(request);
        System.out.println("JobSeeker from session: " + jobSeeker);
        
        // Check if user is logged in
        if (jobSeeker == null) {
            System.out.println("No jobSeeker in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/JobSeeker/jobseeker-login.jsp");
            return;
        }
        
        try {
            int jobSeekerId = jobSeeker.getJobSeekerId();
            System.out.println("JobSeeker ID: " + jobSeekerId);
            
            // Get filter parameters
            String statusFilter = request.getParameter("status");
            String dateRangeParam = request.getParameter("dateRange");
            System.out.println("Filters - Status: " + statusFilter + ", DateRange: " + dateRangeParam);
            
            Integer dateRange = null;
            if (dateRangeParam != null && !dateRangeParam.trim().isEmpty()) {
                try {
                    dateRange = Integer.parseInt(dateRangeParam);
                } catch (NumberFormatException e) {
                    // Invalid date range, ignore
                }
            }
            
            // Get applications with filters
            List<ApplicationView> applications;
            if (statusFilter != null || dateRange != null) {
                System.out.println("Getting applications with filters");
                applications = applicationDAO.getApplicationsByJobSeekerWithFilters(
                    jobSeekerId, statusFilter, dateRange);
            } else {
                System.out.println("Getting all applications");
                applications = applicationDAO.getApplicationsByJobSeeker(jobSeekerId);
            }
            
            System.out.println("Found " + applications.size() + " applications");
            
            // Get statistics
            ApplicationDAO.ApplicationStatistics stats = 
                applicationDAO.getApplicationStatistics(jobSeekerId);
            
            System.out.println("Statistics - Total: " + stats.getTotalApplications() + 
                             ", Pending: " + stats.getPendingApplications() +
                             ", Approved: " + stats.getApprovedApplications() +
                             ", Interviewed: " + stats.getInterviewedApplications());
            
            // Set attributes for JSP
            request.setAttribute("applications", applications);
            request.setAttribute("totalApplications", stats.getTotalApplications());
            request.setAttribute("pendingApplications", stats.getPendingApplications());
            request.setAttribute("approvedApplications", stats.getApprovedApplications());
            request.setAttribute("interviewedApplications", stats.getInterviewedApplications());
            
            // Set filter parameters back for form
            request.setAttribute("selectedStatus", statusFilter);
            request.setAttribute("selectedDateRange", dateRangeParam);
            
            System.out.println("Forwarding to JSP");
            // Forward to JSP
            request.getRequestDispatcher("/JobSeeker/applied-jobs.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error in AppliedJobsServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(500, "An error occurred while retrieving your applications.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // POST requests are handled the same way as GET for filtering
        doGet(request, response);
    }
}