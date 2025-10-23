/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.recuiter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import dal.JobDAO;
import dal.TypeDAO;
import dal.LocationDAO;
import dal.CategoryDAO;
import model.Job;
import model.Type;
import model.Location;
import model.Category;
import java.util.List;

/**
 *
 * @author Admin
 */
@WebServlet(name = "JobPostingServlet", urlPatterns = {"/jobposting"})
public class JobPostingServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
     
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet JopPostingServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet JopPostingServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            TypeDAO typeDAO = new TypeDAO();
            LocationDAO locationDAO = new LocationDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            List<Type> jobLevels = typeDAO.getJobLevels();
            List<Type> jobTypes = typeDAO.getJobTypes();
            List<Location> locations = locationDAO.getAllLocations();
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("jobLevels", jobLevels);
            request.setAttribute("jobTypes", jobTypes);
            request.setAttribute("locations", locations);
            request.setAttribute("categories", categories);
            
            request.getRequestDispatcher("Recruiter/job-posting.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("Recruiter/job-posting.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String jobTitle = request.getParameter("job-title");
            String description = request.getParameter("job-description");
            String requirements = request.getParameter("job-requirements");
            int jobLevelID = Integer.parseInt(request.getParameter("job-level"));
            int locationID = Integer.parseInt(request.getParameter("work-location"));
            String salaryRange = request.getParameter("salary-min") + "-" + request.getParameter("salary-max");
            String expirationDateStr = request.getParameter("expiration-date");
            int categoryID = Integer.parseInt(request.getParameter("job-field"));
            int ageRequirement = Integer.parseInt(request.getParameter("age-requirement"));
            int jobTypeID = Integer.parseInt(request.getParameter("job-type"));
            int hiringCount = Integer.parseInt(request.getParameter("hiring-count"));
            
            // Tạo Job object
            Job job = new Job();
            job.setRecruiterID(1); 
            job.setJobTitle(jobTitle);
            job.setDescription(description);
            job.setRequirements(requirements);
            job.setJobLevelID(jobLevelID);
            job.setLocationID(locationID);
            job.setSalaryRange(salaryRange);
            
            // Parse expiration date
            if (expirationDateStr != null && !expirationDateStr.isEmpty()) {
                LocalDateTime expirationDate = LocalDateTime.parse(expirationDateStr + "T23:59:59");
                job.setExpirationDate(expirationDate);
            }
            
            job.setCategoryID(categoryID);
            job.setAgeRequirement(ageRequirement);
            job.setStatus("Draft"); 
            job.setJobTypeID(jobTypeID);
            job.setHiringCount(hiringCount);
            
            JobDAO jobDAO = new JobDAO();
            boolean success = jobDAO.addJob(job);
            
            if (success) {
                request.setAttribute("success", "Tin tuyển dụng đã được lưu thành công!");
                
                response.sendRedirect(request.getContextPath() + "/jobposting?success=true");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi lưu tin tuyển dụng!");

                doGet(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            doGet(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
