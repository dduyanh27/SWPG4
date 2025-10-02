package controller.recuiter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import dal.JobDAO;
import dal.TypeDAO;
import dal.LocationDAO;
import dal.CategoryDAO;
import dal.SkillDAO;
import dal.JobSkillMappingDAO;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import model.Job;
import model.Recruiter;

/**
 * Servlet đã sửa đổi để khớp tên biến Dropdown và thêm try-catch cơ bản cho doGet.
 */
@WebServlet(name = "EditJobPostingServlet", urlPatterns = {"/edit-jobposting"})
public class EditJobPostingServlet extends HttpServlet {

    // Helper method không có throw Exception để đơn giản hóa
    private void loadDropDownData(HttpServletRequest request) {
        TypeDAO typeDAO = new TypeDAO();
        LocationDAO locationDAO = new LocationDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        SkillDAO skillDAO = new SkillDAO();

        request.setAttribute("jobLevels", typeDAO.getJobLevels());
        request.setAttribute("jobTypes", typeDAO.getJobTypes());
        request.setAttribute("locations", locationDAO.getAllLocations());
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("certificates", typeDAO.getTypesByCategory("certificates"));
        request.setAttribute("skills", skillDAO.getAllSkills()); // Danh sách tất cả skills
    }

    /**
     * Tải dữ liệu cần thiết và hiển thị form chỉnh sửa.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String jobIDStr = request.getParameter("id");
        int jobID = 0;
        Job jobToEdit = null;
        List<Integer> selectedSkillIDs = null;
        
        // Định nghĩa hằng số cho đường dẫn chuyển hướng về HomeRecruiterServlet
        final String REDIRECT_HOME = request.getContextPath() + "/homerecuiter";

        try {
            // 1ID bị thiếu
            if (jobIDStr == null || jobIDStr.trim().isEmpty()) {
                response.sendRedirect(REDIRECT_HOME + "?error=missingID");
                return;
            }
            
            jobID = Integer.parseInt(jobIDStr); 
            System.out.println("DEBUG: Job ID parsed successfully: " + jobID);

            JobDAO jobDAO = new JobDAO();
            jobToEdit = jobDAO.getJobById(jobID);
            System.out.println("DEBUG: Job to edit loaded: " + (jobToEdit != null));
            if (jobToEdit == null) {
                response.sendRedirect(REDIRECT_HOME + "?error=notfound");
                return;
            }
            JobSkillMappingDAO jobSkillMappingDAO = new JobSkillMappingDAO();
            selectedSkillIDs = jobSkillMappingDAO.getSkillIDsByJobID(jobID);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(REDIRECT_HOME + "?error=invalidID");
            return;
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(REDIRECT_HOME + "?error=dbfail");
            return;
        }
        loadDropDownData(request);
        request.setAttribute("jobToEdit", jobToEdit);
        request.setAttribute("selectedSkillIDs", selectedSkillIDs); 
        request.getRequestDispatcher("/Recruiter/edit-jobposting.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        final String REDIRECT_HOME = request.getContextPath() + "/homerecuiter";
        
        try {
            String jobIDStr = request.getParameter("jobID");
            int jobID = Integer.parseInt(jobIDStr); 

            JobDAO jobDAO = new JobDAO();
            Job jobToEdit = jobDAO.getJobById(jobID);
            
            if (jobToEdit == null) {
                response.sendRedirect(REDIRECT_HOME + "?error=JobNotFound");
                return;
            }
            
            int recruiterID = jobToEdit.getRecruiterID(); 

            String jobTitle = request.getParameter("jobTitle");
            String description = request.getParameter("description");
            String requirements = request.getParameter("requirements");
            
            String categoryIDStr = request.getParameter("categoryID");
            String jobLevelIDStr = request.getParameter("jobLevelID");
            String locationIDStr = request.getParameter("locationID");
            String jobTypeIDStr = request.getParameter("jobTypeID");
            String certificatesIDStr = request.getParameter("certificatesID");
            
            String hiringCountStr = request.getParameter("hiringCount");
            String ageRequirementStr = request.getParameter("ageRequirement");
            String expirationDateStr = request.getParameter("expirationDate");
            
            String salaryMin = request.getParameter("salaryMin");
            String salaryMax = request.getParameter("salaryMax");
            
            String[] skillIDsStr = request.getParameterValues("job-skills"); 
            
            String errorMessage = "";
            LocalDateTime expirationDate = null;
            
            if (expirationDateStr != null && !expirationDateStr.isEmpty()) {
                try {
                    expirationDate = LocalDate.parse(expirationDateStr).atTime(23, 59, 59);
                    if (expirationDate.isBefore(LocalDateTime.now())) {
                        errorMessage = "Ngày hết hạn phải là một ngày trong tương lai.";
                    }
                } catch (DateTimeParseException e) {
                    errorMessage = "Định dạng ngày hết hạn không hợp lệ.";
                }
            }
            if (ageRequirementStr != null && !ageRequirementStr.trim().isEmpty()) {
                try {
                    int ageRequirement = Integer.parseInt(ageRequirementStr);
                    if (ageRequirement < 15 || ageRequirement > 65) {
                        errorMessage += (errorMessage.isEmpty() ? "" : "<br>") + "Yêu cầu độ tuổi phải nằm trong khoảng từ 15 đến 65.";
                    }
                } catch (NumberFormatException e) {
                    errorMessage += (errorMessage.isEmpty() ? "" : "<br>") + "Yêu cầu độ tuổi không hợp lệ.";
                }
            }
            if (skillIDsStr == null || skillIDsStr.length == 0) {
                 errorMessage += (errorMessage.isEmpty() ? "" : "<br>") + "Vui lòng chọn ít nhất một kỹ năng.";
            }

            if (!errorMessage.isEmpty()) {
                loadDropDownData(request);
                request.setAttribute("jobToEdit", jobToEdit);
                request.setAttribute("error", errorMessage);
                request.getRequestDispatcher("/Recruiter/edit-jobposting.jsp").forward(request, response);
                return;
            }

            String salaryRange;
            boolean isMinProvided = salaryMin != null && !salaryMin.trim().isEmpty();
            boolean isMaxProvided = salaryMax != null && !salaryMax.trim().isEmpty();
            
            if (isMinProvided && isMaxProvided) {
                salaryRange = salaryMin.trim() + " - " + salaryMax.trim();
            } else if (isMinProvided) {
                salaryRange = salaryMin.trim();
            } else if (isMaxProvided) {
                salaryRange = salaryMax.trim();
            } else {
                salaryRange = "Thỏa thuận";
            }

            
            Job updatedJob = new Job();
            
            updatedJob.setJobID(jobID);
            updatedJob.setRecruiterID(recruiterID); 
            updatedJob.setJobTitle(jobTitle);
            updatedJob.setDescription(description);
            updatedJob.setRequirements(requirements);
            updatedJob.setSalaryRange(salaryRange);
            
            updatedJob.setCategoryID(Integer.parseInt(categoryIDStr));
            updatedJob.setJobLevelID(jobLevelIDStr.isEmpty() ? 0 : Integer.parseInt(jobLevelIDStr));
            updatedJob.setLocationID(locationIDStr.isEmpty() ? 0 : Integer.parseInt(locationIDStr));
            updatedJob.setJobTypeID(jobTypeIDStr.isEmpty() ? 0 : Integer.parseInt(jobTypeIDStr));
            updatedJob.setCertificatesID(certificatesIDStr.isEmpty() ? 0 : Integer.parseInt(certificatesIDStr));
            
            updatedJob.setHiringCount(hiringCountStr.isEmpty() ? 1 : Integer.parseInt(hiringCountStr));
            updatedJob.setAgeRequirement(ageRequirementStr.isEmpty() ? 0 : Integer.parseInt(ageRequirementStr));
           
            updatedJob.setExpirationDate(LocalDate.parse(expirationDateStr).atStartOfDay());
            updatedJob.setStatus(jobToEdit.getStatus()); 
            
            
            boolean success = jobDAO.updateJob(updatedJob); 
            
            if (success) {
                JobSkillMappingDAO mappingDAO = new JobSkillMappingDAO();
                mappingDAO.deleteJobSkillMappingByJobID(jobID);
                
                if (skillIDsStr != null && skillIDsStr.length > 0) {
                    for (String skillIDStr : skillIDsStr) {
                        int skillID = Integer.parseInt(skillIDStr);
                        mappingDAO.addJobSkillMapping(jobID, skillID);
                    }
                }
                
                response.sendRedirect(REDIRECT_HOME + "?update=success");
            } else {
                loadDropDownData(request);
                request.setAttribute("jobToEdit", updatedJob); 
                request.setAttribute("error", "Lỗi CSDL: Không thể cập nhật tin tuyển dụng.");
                request.getRequestDispatcher("/Recruiter/edit-jobposting.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            loadDropDownData(request);
            request.setAttribute("error", "Lỗi dữ liệu đầu vào. Vui lòng kiểm tra các trường số (ID, số lượng, tuổi) và ngày tháng.");
            request.getRequestDispatcher("/Recruiter/edit-jobposting.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            loadDropDownData(request);
            request.setAttribute("error", "Lỗi hệ thống: Không thể hoàn tất yêu cầu.");
            request.getRequestDispatcher("/Recruiter/edit-jobposting.jsp").forward(request, response);
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Edit Job Posting Servlet";
    }
}