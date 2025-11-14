package controller.jobseeker;

import dal.JobSeekerDAO;
import dal.LocationDAO;
import dal.TypeDAO;
import dal.CVDAO;
import dal.ApplicationDAO;
import dal.SavedJobDAO;
import dal.SkillDAO;
import dal.JobListDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.JobSeeker;
import model.Location;
import model.Type;
import model.CV;
import model.ApplicationView;
import model.SavedJob;
import model.Skill;
import util.SessionHelper;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "JobSeekerProfileServlet", urlPatterns = {"/jobseekerprofile"})
public class JobSeekerProfileServlet extends HttpServlet {
    private JobSeekerDAO dao;
    private LocationDAO locDao;
    private TypeDAO typeDao;
    private CVDAO cvDAO;
    private ApplicationDAO appDAO;
    private SavedJobDAO savedJobDAO;
    private SkillDAO skillDAO;
    private JobListDAO jobListDAO;
    
    public JobSeekerProfileServlet() {
        try {
            this.dao = new JobSeekerDAO();
            this.locDao = new LocationDAO();
            this.typeDao = new TypeDAO();
            this.cvDAO = new CVDAO();
            this.appDAO = new ApplicationDAO();
            this.savedJobDAO = new SavedJobDAO();
            this.skillDAO = new SkillDAO();
            this.jobListDAO = new JobListDAO();
        } catch (Exception e) {
            System.err.println("Error initializing DAOs in JobSeekerProfileServlet: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra xem DAOs đã được khởi tạo thành công chưa
        if (dao == null || locDao == null || typeDao == null) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Server configuration error. Please try again later.");
            return;
        }
        
        // Lấy thông tin người dùng hiện tại từ session
        JobSeeker currentJobSeeker = SessionHelper.getCurrentJobSeeker(request);
        Integer userId = SessionHelper.getCurrentUserId(request);
        
        // Kiểm tra xem người dùng đã login chưa và có phải JobSeeker không
        if (currentJobSeeker == null || userId == null || !SessionHelper.isJobSeeker(request)) {
            response.sendRedirect(request.getContextPath() + "/JobSeeker/jobseeker-login.jsp");
            return;
        }
        
        try {
            int id = userId;
            JobSeeker js = dao.getJobSeekerById(id);
            List<Location> locations = locDao.getAllLocations();
            List<Type> types = typeDao.getJobLevels();
            String typeName = null;
            if (js.getCurrentLevelId() != null) {
                typeName = typeDao.getTypeNameByCurrentLevelId(js.getCurrentLevelId());
            }
            
            // Lấy danh sách CV của người dùng
            List<CV> uploadedCVs = cvDAO.getCVsByJobSeekerId(id);
            
            // Lấy thống kê dashboard
            List<ApplicationView> applications = appDAO.getApplicationsByJobSeeker(id);
            List<SavedJob> savedJobs = savedJobDAO.getSavedJobsByJobSeeker(id);
            
            // Đếm số lượng
            int cvCount = uploadedCVs != null ? uploadedCVs.size() : 0;
            int totalApplications = applications != null ? applications.size() : 0;
            int savedJobsCount = savedJobs != null ? savedJobs.size() : 0;
            
            // Đếm theo trạng thái ứng tuyển
            int pendingCount = 0;
            int acceptedCount = 0;
            int interviewCount = 0;
            int rejectedCount = 0;
            
            if (applications != null) {
                for (ApplicationView app : applications) {
                    String status = app.getStatus();
                    if (status != null) {
                        switch (status.toLowerCase()) {
                            case "pending":
                            case "đang chờ":
                                pendingCount++;
                                break;
                            case "accepted":
                            case "chấp thuận":
                                acceptedCount++;
                                break;
                            case "interview":
                            case "phỏng vấn":
                                interviewCount++;
                                break;
                            case "rejected":
                            case "từ chối":
                                rejectedCount++;
                                break;
                        }
                    }
                }
            }
            
            // Lấy hoạt động gần đây (top 5)
            List<ApplicationView> recentApplications = null;
            if (applications != null && !applications.isEmpty()) {
                int endIndex = Math.min(5, applications.size());
                recentApplications = applications.subList(0, endIndex);
            }
            
            List<SavedJob> recentSavedJobs = null;
            if (savedJobs != null && !savedJobs.isEmpty()) {
                int endIndex = Math.min(3, savedJobs.size());
                recentSavedJobs = savedJobs.subList(0, endIndex);
            }
            
            // Set các attribute cho JSP
            request.setAttribute("jobSeeker", js);
            request.setAttribute("locations", locations);
            request.setAttribute("types", types);
            request.setAttribute("uploadedCVs", uploadedCVs);
            request.setAttribute("typeName", typeName);
            
            // Dashboard statistics
            request.setAttribute("cvCount", cvCount);
            request.setAttribute("totalApplications", totalApplications);
            request.setAttribute("savedJobsCount", savedJobsCount);
            request.setAttribute("profileViews", 0); // Mock data, có thể implement sau
            
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("acceptedCount", acceptedCount);
            request.setAttribute("interviewCount", interviewCount);
            request.setAttribute("rejectedCount", rejectedCount);
            
            request.setAttribute("recentApplications", recentApplications);
            request.setAttribute("recentSavedJobs", recentSavedJobs);
            
            // Load skills for the JobSeeker
            List<Skill> jobSeekerSkills = skillDAO.getSkillsByJobSeekerId(id);
            List<Skill> allSkills = skillDAO.getAllSkills();
            request.setAttribute("jobSeekerSkills", jobSeekerSkills);
            request.setAttribute("allSkills", allSkills);
            
            // Load jobs by JobSeeker's location for sidebar
            List<model.JobList> locationJobs = null;
            if (js.getLocationId() != null && js.getLocationId() > 0) {
                locationJobs = jobListDAO.getJobsByLocation(js.getLocationId(), 10);
            }
            request.setAttribute("locationJobs", locationJobs);
            
            request.getRequestDispatcher("JobSeeker/profile.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in JobSeekerProfileServlet doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Unable to load profile. Please try again later.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra xem DAOs đã được khởi tạo thành công chưa
        if (dao == null) {
            response.sendError(500, "Server configuration error. Please try again later.");
            return;
        }
        
        JobSeeker currentJobSeeker = SessionHelper.getCurrentJobSeeker(request);
        Integer userId = SessionHelper.getCurrentUserId(request);
        
        if (currentJobSeeker == null || userId == null || !SessionHelper.isJobSeeker(request)) {
            response.sendRedirect(request.getContextPath() + "/JobSeeker/jobseeker-login.jsp");
            return;
        }
        
        try {
            int id = userId;
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String headline = request.getParameter("headline");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            String status = request.getParameter("status");
            String address = request.getParameter("address");
            String contactInfo = request.getParameter("contactInfo");

            String locStr = request.getParameter("locationID");
            String levelStr = request.getParameter("currentLevelID");

            Integer locationId = (locStr != null && !locStr.isEmpty()) ? Integer.parseInt(locStr) : null;
            Integer currentLevelId = (levelStr != null && !levelStr.isEmpty()) ? Integer.parseInt(levelStr) : null;
            

            // Validate Họ và tên
            if (fullName == null || fullName.trim().isEmpty() || fullName.length() > 100 || !fullName.matches("^[\\p{L}\\s]+$")) {
                request.setAttribute("error", "Họ và tên chỉ được chứa chữ cái và khoảng trắng, tối đa 100 ký tự.");
                request.getRequestDispatcher("/JobSeeker/profile.jsp").forward(request, response);
                return;
            }

            // Validate Số điện thoại
            if (phone != null && !phone.trim().isEmpty()) {
                if (!phone.matches("^\\d{10,11}$")) {
                    request.setAttribute("error", "Số điện thoại không hợp lệ.");
                    request.getRequestDispatcher("/JobSeeker/profile.jsp").forward(request, response);
                    return;
                }
            }

            // Validate Headline
            if (headline != null && headline.length() > 200) {
                request.setAttribute("error", "Headline không được vượt quá 200 ký tự.");
                request.getRequestDispatcher("/JobSeeker/profile.jsp").forward(request, response);
                return;
            }

            // Validate Địa chỉ chi tiết
            if (address != null && address.length() > 255) {
                request.setAttribute("error", "Địa chỉ không được vượt quá 255 ký tự.");
                request.getRequestDispatcher("/JobSeeker/profile.jsp").forward(request, response);
                return;
            }

            // Validate Thông tin liên hệ
            if (contactInfo != null && contactInfo.length() > 255) {
                request.setAttribute("error", "Thông tin liên hệ không được vượt quá 255 ký tự.");
                request.getRequestDispatcher("/JobSeeker/profile.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng JobSeeker để update
            JobSeeker js = new JobSeeker();
            js.setJobSeekerId(id);
            js.setFullName(fullName);
            js.setEmail(email);
            js.setHeadline(headline);
            js.setPhone(phone);
            js.setGender(gender);
            js.setStatus(status);
            js.setAddress(address);
            js.setContactInfo(contactInfo);
            js.setLocationId(locationId);
            js.setCurrentLevelId(currentLevelId);

            dao.updateProfileModal(js);
            
            // Cập nhật lại thông tin trong session sau khi update bằng SessionHelper
            JobSeeker updatedJobSeeker = dao.getJobSeekerById(id);
            SessionHelper.updateJobSeekerInSession(request, updatedJobSeeker);
            
            response.sendRedirect("jobseekerprofile");
        } catch (Exception e) {
            System.err.println("Error in JobSeekerProfileServlet doPost: " + e.getMessage());
            e.printStackTrace();
            response.sendError(500, "Unable to update profile. Please try again later.");
        }
    }
}
