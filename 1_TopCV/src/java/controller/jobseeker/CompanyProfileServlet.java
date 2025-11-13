package controller.jobseeker;

import dal.RecruiterDAO;
import dal.JobDAO;
import dal.LocationDAO;
import dal.CategoryDAO;
import model.Recruiter;
import model.Job;
import model.Location;
import model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet(name = "CompanyProfileServlet", urlPatterns = {"/company-profile"})
public class CompanyProfileServlet extends HttpServlet {
    
    private RecruiterDAO recruiterDAO;
    private JobDAO jobDAO;
    private LocationDAO locationDAO;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() throws ServletException {
        recruiterDAO = new RecruiterDAO();
        jobDAO = new JobDAO();
        locationDAO = new LocationDAO();
        categoryDAO = new CategoryDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy recruiterId từ parameter
            String recruiterIdParam = request.getParameter("id");
            if (recruiterIdParam == null || recruiterIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/404.jsp");
                return;
            }
            
            int recruiterId = Integer.parseInt(recruiterIdParam);
            
            // Lấy thông tin công ty
            Recruiter company = recruiterDAO.getRecruiterById(recruiterId);
            if (company == null) {
                response.sendRedirect(request.getContextPath() + "/404.jsp");
                return;
            }
            
            // Lấy danh sách jobs của công ty (đang active)
            List<Job> allJobs = jobDAO.getJobsByRecruiterId(recruiterId);
            
            // Filter chỉ lấy jobs Published
            List<Job> activeJobs = new java.util.ArrayList<>();
            for (Job job : allJobs) {
                if ("Published".equals(job.getStatus())) {
                    activeJobs.add(job);
                }
            }
            
            // Lấy thông tin location và category cho mỗi job
            Map<Integer, String> locationMap = new HashMap<>();
            Map<Integer, String> categoryMap = new HashMap<>();
            
            for (Job job : activeJobs) {
                // Get location name
                if (!locationMap.containsKey(job.getLocationID())) {
                    Location location = locationDAO.getLocationById(job.getLocationID());
                    if (location != null) {
                        locationMap.put(job.getLocationID(), location.getLocationName());
                    }
                }
                
                // Get category name
                if (!categoryMap.containsKey(job.getCategoryID())) {
                    Category category = categoryDAO.getCategoryById(job.getCategoryID());
                    if (category != null) {
                        categoryMap.put(job.getCategoryID(), category.getCategoryName());
                    }
                }
            }
            
            // Get company logo abbreviation (3 first letters)
            String logoText = "";
            if (company.getCompanyName() != null && company.getCompanyName().length() >= 3) {
                logoText = company.getCompanyName().substring(0, 3).toUpperCase();
            } else if (company.getCompanyName() != null) {
                logoText = company.getCompanyName().toUpperCase();
            }
            
            // Parse company benefits
            String[] benefits = null;
            if (company.getCompanyBenefits() != null && !company.getCompanyBenefits().isEmpty()) {
                benefits = company.getCompanyBenefits().split("\\|");
            }
            
            // Set attributes
            request.setAttribute("company", company);
            request.setAttribute("companyLogoText", logoText);
            request.setAttribute("companyName", company.getCompanyName());
            request.setAttribute("companyDescription", company.getCompanyDescription());
            request.setAttribute("companyWebsite", company.getWebsite());
            request.setAttribute("companyVideoURL", company.getCompanyVideoURL());
            request.setAttribute("companyBenefits", benefits);
            request.setAttribute("jobs", activeJobs);
            request.setAttribute("jobCount", activeJobs.size());
            request.setAttribute("locationMap", locationMap);
            request.setAttribute("categoryMap", categoryMap);
            
            // Forward to JSP
            request.getRequestDispatcher("/JobSeeker/company.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/404.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
