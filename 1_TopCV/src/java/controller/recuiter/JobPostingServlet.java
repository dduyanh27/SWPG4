package controller.recuiter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.List;
import dal.JobDAO;
import dal.TypeDAO;
import dal.LocationDAO;
import dal.CategoryDAO;
import dal.SkillDAO;
import dal.JobSkillMappingDAO;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import model.Job;
import model.Type;
import model.Location;
import model.Category;
import model.Skill;
import model.Recruiter;

@WebServlet(name = "JobPostingServlet", urlPatterns = {"/jobposting"})
public class JobPostingServlet extends HttpServlet {

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        TypeDAO type1 = new TypeDAO();
        LocationDAO location1 = new LocationDAO();
        CategoryDAO categoty1 = new CategoryDAO();
        SkillDAO skill1 = new SkillDAO();

        List<Type> listJobLevel = type1.getJobLevels();
        List<Type> listJobType = type1.getJobTypes();
        List<Type> listCertificates = type1.getTypesByCategory("certificates");
        List<Location> listLocation = location1.getAllLocations();
        List<Category> listCategory = categoty1.getAllCategories();
        List<Skill> listSkill = skill1.getAllSkills();

        request.setAttribute("jobLevels", listJobLevel);
        request.setAttribute("jobTypes", listJobType);
        request.setAttribute("certificates", listCertificates);
        request.setAttribute("locations", listLocation);
        request.setAttribute("categories", listCategory);
        request.setAttribute("skills", listSkill);

        request.getRequestDispatcher("Recruiter/job-posting.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Object userObject = session.getAttribute("user");
        String userType = (String) session.getAttribute("userType");

        if (userObject == null || !"recruiter".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/Recruiter/recruiter-login.jsp");
            return;
        }

        Recruiter recruiter = (Recruiter) userObject;
        int recruiterID = recruiter.getRecruiterID();
        String jobTitle = request.getParameter("job-title");
        String description = request.getParameter("job-description");
        String requirements = request.getParameter("requirements");
        String jobLevelIDStr = request.getParameter("job-level");
        String locationIDStr = request.getParameter("work-location");
        String salaryMinStr = request.getParameter("salary-min");
        String salaryMaxStr = request.getParameter("salary-max");
        String expirationDateStr = request.getParameter("expiration-date");
        String categoryIDStr = request.getParameter("job-field");
        String ageRequirementStr = request.getParameter("age-requirement");
        String jobTypeIDStr = request.getParameter("job-type");
        String hiringCountStr = request.getParameter("hiring-count");
        String minQualificationIDStr = request.getParameter("min-qualification");
        String[] skillIDsStr = request.getParameterValues("job-skills");

        String errorMessage = "";

      
       //validation
        int jobLevelID = 0, locationID = 0, categoryID = 0, ageRequirement = 0, jobTypeID = 0, hiringCount = 0, certificatesID = 0;
        double salaryMin = 0, salaryMax = 0;

        try {
            if (errorMessage.isEmpty() && jobLevelIDStr != null) {
                jobLevelID = Integer.parseInt(jobLevelIDStr);
            }
            if (errorMessage.isEmpty() && locationIDStr != null) {
                locationID = Integer.parseInt(locationIDStr);
            }
            if (errorMessage.isEmpty() && categoryIDStr != null) {
                categoryID = Integer.parseInt(categoryIDStr);
            }
            if (errorMessage.isEmpty() && jobTypeIDStr != null) {
                jobTypeID = Integer.parseInt(jobTypeIDStr);
            }
            // Ánh xạ 'min-qualification' sang 'certificatesID'
            if (errorMessage.isEmpty() && minQualificationIDStr != null) {
                certificatesID = Integer.parseInt(minQualificationIDStr);
            }
            
            

            if (errorMessage.isEmpty()) {
                if (salaryMinStr != null && !salaryMinStr.isEmpty()) {
                    salaryMin = Double.parseDouble(salaryMinStr);
                }
                if (salaryMaxStr != null && !salaryMaxStr.isEmpty()) {
                    salaryMax = Double.parseDouble(salaryMaxStr);
                }

                if (salaryMin > 0 && salaryMax > 0 && salaryMin > salaryMax) {
                    errorMessage = "Mức lương tối thiểu không được lớn hơn mức lương tối đa.";
                }
            }

        } catch (NumberFormatException e) {
            errorMessage = "Dữ liệu nhập vào không hợp lệ (cần là số nguyên/số thực).";
        }

        // 3. Kiểm tra Ngày hết hạn phải là ngày trong tương lai (Ngày hết hạn là NOT NULL)
        LocalDateTime expirationDate = null;
        if (errorMessage.isEmpty() && expirationDateStr != null && !expirationDateStr.isEmpty()) {
            try {
                // Tạo LocalDateTime từ ngày và đặt giờ là 23:59:59 để bao gồm cả ngày đó
                expirationDate = LocalDate.parse(expirationDateStr).atTime(23, 59, 59);
                if (expirationDate.isBefore(LocalDateTime.now())) {
                    errorMessage = "Ngày hết hạn phải là một ngày trong tương lai.";
                }
            } catch (DateTimeParseException e) {
                errorMessage = "Định dạng ngày hết hạn không hợp lệ.";
            }
        }

        if (!errorMessage.isEmpty()) {
            request.setAttribute("error", errorMessage);
            request.setAttribute("jobTitle", jobTitle);
            request.setAttribute("description", description);
            request.setAttribute("requirements", requirements); // Re-populate requirements if available
            request.setAttribute("salaryMin", salaryMinStr);
            request.setAttribute("salaryMax", salaryMaxStr);
            request.setAttribute("expirationDate", expirationDateStr);
            request.setAttribute("ageRequirement", ageRequirementStr);
            request.setAttribute("hiringCount", hiringCountStr);
            request.setAttribute("selectedJobLevelID", jobLevelIDStr);
            request.setAttribute("selectedLocationID", locationIDStr);
            request.setAttribute("selectedCategoryID", categoryIDStr);
            request.setAttribute("selectedJobTypeID", jobTypeIDStr);
            request.setAttribute("selectedQualificationID", minQualificationIDStr);
            request.setAttribute("selectedSkillIDs", skillIDsStr);

            doGet(request, response);
            return;
        }

        try {

            // Xây dựng chuỗi SalaryRange
            String salaryRange = (salaryMinStr != null && !salaryMinStr.isEmpty() ? salaryMinStr : "0")
                    + "-"
                    + (salaryMaxStr != null && !salaryMaxStr.isEmpty() ? salaryMaxStr : "0");

            Job job = new Job();
            job.setRecruiterID(recruiterID);
            job.setJobTitle(jobTitle.trim());
            job.setDescription(description.trim());
            job.setRequirements(requirements.trim());
            job.setJobLevelID(jobLevelID);
            job.setLocationID(locationID);
            job.setSalaryRange(salaryRange);
            job.setExpirationDate(expirationDate);
            job.setCategoryID(categoryID);
            job.setAgeRequirement(ageRequirement);
            job.setJobTypeID(jobTypeID);
            job.setHiringCount(hiringCount);
            job.setCertificatesID(certificatesID);
            job.setStatus("Draft");

            JobDAO jobDAO = new JobDAO();
            int newJobID = jobDAO.addJob(job);

            if (newJobID > 0) {
                // Lưu các kỹ năng đã chọn
                if (skillIDsStr != null && skillIDsStr.length > 0) {
                    JobSkillMappingDAO jobSkillMappingDAO = new JobSkillMappingDAO();
                    for (String skillIDStr : skillIDsStr) {
                        try {
                            int skillID = Integer.parseInt(skillIDStr);
                            jobSkillMappingDAO.addJobSkillMapping(newJobID, skillID);
                        } catch (NumberFormatException e) {

                        }
                    }
                }
                response.sendRedirect(request.getContextPath() + "/jobposting?success=true");
            } else { //lỗi db khi add
                request.setAttribute("error", "Lỗi CSDL: Không thể thêm tin tuyển dụng. Vui lòng kiểm tra lại dữ liệu và ràng buộc DB.");
                request.getRequestDispatcher("Recruiter/job-posting.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("Recruiter/job-posting.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Job Posting Servlet";
    }
}
