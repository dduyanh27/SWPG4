package controller.jobseeker;

import dal.JobSeekerDAO;
import dal.LocationDAO;
import dal.TypeDAO;
import dal.CVDAO;
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
import util.SessionHelper;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "JobSeekerProfileServlet", urlPatterns = {"/jobseekerprofile"})
public class JobSeekerProfileServlet extends HttpServlet {
    private JobSeekerDAO dao;
    private LocationDAO locDao;
    private TypeDAO typeDao;
    private CVDAO cvDAO;
    
    public JobSeekerProfileServlet() {
        try {
            this.dao = new JobSeekerDAO();
            this.locDao = new LocationDAO();
            this.typeDao = new TypeDAO();
            this.cvDAO = new CVDAO();
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
            
            // Lấy danh sách CV của người dùng
            List<CV> uploadedCVs = cvDAO.getCVsByJobSeekerId(id);
            
            request.setAttribute("jobSeeker", js);
            request.setAttribute("locations", locations);
            request.setAttribute("types", types);
            request.setAttribute("uploadedCVs", uploadedCVs);
            
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

            int locationId = (locStr != null && !locStr.isEmpty()) ? Integer.parseInt(locStr) : 0;
            int currentLevelId = (levelStr != null && !levelStr.isEmpty()) ? Integer.parseInt(levelStr) : 0;

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
