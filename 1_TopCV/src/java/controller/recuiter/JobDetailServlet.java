package controller.recuiter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import dal.JobDAO;
import dal.TypeDAO;
import dal.LocationDAO;
import dal.CategoryDAO;
import dal.JobSkillMappingDAO;
import dal.SkillDAO;
import java.time.LocalDate;
import java.time.ZoneId;
import model.Job;
import model.Type;
import model.Location;
import model.Category;
import model.Skill;
import model.Recruiter;

@WebServlet(name = "JobDetailServlet", urlPatterns = {"/jobdetails"})
public class JobDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object userObject = session.getAttribute("user");
        String userType = (String) session.getAttribute("userType");

        if (userObject == null || !"recruiter".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/Recruiter/recruiter-login.jsp");
            return;
        }

        String jobIDStr = request.getParameter("jobID");
        int jobID = 0;

        try {
            if (jobIDStr != null) {
                jobID = Integer.parseInt(jobIDStr);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số Job ID.");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Job ID không hợp lệ.");
            return;
        }

        JobDAO jobDAO = new JobDAO();
        Job job = jobDAO.getJobById(jobID);

        TypeDAO typeDAO = new TypeDAO();
        LocationDAO locationDAO = new LocationDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        SkillDAO skillDAO = new SkillDAO();
        JobSkillMappingDAO jsmDAO = new JobSkillMappingDAO();

        if (job != null) {

            if (job.getExpirationDate() != null) {
                java.time.LocalDateTime localDateTime = job.getExpirationDate();
                java.time.LocalDate localDate = localDateTime.atZone(ZoneId.systemDefault())
                        .toLocalDate();
                request.setAttribute("expirationLocalDate", localDate);
            }

            List<Type> allJobLevels = typeDAO.getJobLevels();
            List<Type> allJobTypes = typeDAO.getJobTypes();
            List<Location> allLocations = locationDAO.getAllLocations();
            List<Category> allCategories = categoryDAO.getAllCategories();
            List<Type> allCertificates = typeDAO.getTypesByCategory("certificates");
            List<Skill> allSkills = skillDAO.getAllSkills();
            List<Skill> selectedSkills = jsmDAO.getSkillsByJobID(jobID);

            request.setAttribute("job", job);
            request.setAttribute("jobLevels", allJobLevels);
            request.setAttribute("jobTypes", allJobTypes);
            request.setAttribute("locations", allLocations);
            request.setAttribute("categories", allCategories);
            request.setAttribute("certificates", allCertificates);
            request.setAttribute("allSkills", allSkills);
            request.setAttribute("skills", selectedSkills);

            request.getRequestDispatcher("Recruiter/viewDetailJobposting.jsp").forward(request, response);

        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy công việc với ID: " + jobID);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Job Detail Servlet for Recruiter";
    }

}
