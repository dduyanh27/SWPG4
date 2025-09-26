package controller.jobseeker;

import dal.JobSeekerDAO;
import dal.LocationDAO;
import dal.TypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.JobSeeker;
import model.Location;
import model.Type;

public class JobSeekerProfileServlet extends HttpServlet {
    private JobSeekerDAO dao = new JobSeekerDAO();
    private LocationDAO locDao = new LocationDAO();
    private TypeDAO typeDao = new TypeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id=1;
        JobSeeker js = dao.getJobSeekerById(id);
        List<Location> locations = locDao.getAllLocations();
        List<Type> types = typeDao.getAllType();
        request.setAttribute("jobSeeker", js);
        request.setAttribute("locations", locations);
        request.setAttribute("types", types);
        request.getRequestDispatcher("JobSeeker/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = 1;
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
        response.sendRedirect("jobseekerprofile");
    }
}
