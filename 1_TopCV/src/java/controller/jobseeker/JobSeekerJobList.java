package controller.jobseeker;

import dal.JobListDAO;
import dal.LocationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import model.JobList;

@WebServlet(name = "JobSeekerJobList", urlPatterns = {"/job-list"})
public class JobSeekerJobList extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        JobListDAO dao = new JobListDAO();

        String keyword = request.getParameter("keyword");
        if (keyword != null && keyword.trim().isEmpty()) {
            keyword = null;
        }
        if (keyword != null) {
            keyword = keyword.trim().replaceAll("\\s+", " ");
        }

        String[] categoryIdsParam = request.getParameterValues("categoryIds");
        List<Integer> categoryIds = new ArrayList<>();
        if (categoryIdsParam != null) {
            categoryIds = Arrays.stream(categoryIdsParam)
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());
        }
        String locationIdParam = request.getParameter("locationId");
        Integer locationId = null;
        if (locationIdParam != null && !locationIdParam.isEmpty()) {
            try {
                locationId = Integer.parseInt(locationIdParam);
            } catch (NumberFormatException e) {
            }
        }

        List<JobList> jobs = dao.searchJobs(keyword, categoryIds, locationId);

        int totalJobs = jobs.size();
        
        // Load Silver package jobs for sidebar (up to 50 jobs)
        List<JobList> featuredSilverJobs = dao.getFeaturedJobsSilver(50);

        request.setAttribute("jobList", jobs);
        request.setAttribute("totalJobs", totalJobs);
        request.setAttribute("featuredSilverJobs", featuredSilverJobs);
        request.getRequestDispatcher("JobSeeker/job-list.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}
