package controller.recuiter;

import dal.ApplicationDAO;
import dal.CVDAO;
import dal.JobSeekerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Application;
import model.CV;
import model.JobSeeker;
import model.Recruiter;

@WebServlet(name = "CandidateProfileServlet", urlPatterns = {"/candidate-profile-view"})
public class CandidateProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Set UTF-8 encoding
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        
        System.out.println("==========================================");
        System.out.println("DEBUG CandidateProfileServlet: doGet() called");
        System.out.println("==========================================");
        
        // Lấy recruiter từ session
        Recruiter recruiter = (Recruiter) req.getSession().getAttribute("recruiter");
        if (recruiter == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        String jobSeekerIDParam = req.getParameter("jobSeekerID");
        String cvIDParam = req.getParameter("cvID");
        String applicationIDParam = req.getParameter("applicationID");
        String jobIDParam = req.getParameter("jobID");
        
        System.out.println("DEBUG CandidateProfileServlet: Raw parameters - jobSeekerID: '" + jobSeekerIDParam + "', cvID: '" + cvIDParam + "', applicationID: '" + applicationIDParam + "', jobID: '" + jobIDParam + "'");
        
        Integer jobSeekerID = null;
        Integer cvID = null;
        Integer applicationID = null;
        Integer jobID = null;
        
        try {
            if (jobSeekerIDParam != null && !jobSeekerIDParam.isEmpty()) {
                jobSeekerID = Integer.parseInt(jobSeekerIDParam);
            }
        } catch (NumberFormatException e) {
            System.out.println("DEBUG CandidateProfileServlet: Invalid jobSeekerID: " + jobSeekerIDParam);
        }
        
        try {
            if (cvIDParam != null && !cvIDParam.isEmpty()) {
                cvID = Integer.parseInt(cvIDParam);
            }
        } catch (NumberFormatException e) {
            System.out.println("DEBUG CandidateProfileServlet: Invalid cvID: " + cvIDParam);
        }
        
        try {
            if (applicationIDParam != null && !applicationIDParam.isEmpty()) {
                applicationID = Integer.parseInt(applicationIDParam);
            }
        } catch (NumberFormatException e) {
            System.out.println("DEBUG CandidateProfileServlet: Invalid applicationID: " + applicationIDParam);
        }
        
        try {
            if (jobIDParam != null && !jobIDParam.isEmpty()) {
                jobID = Integer.parseInt(jobIDParam);
            }
        } catch (NumberFormatException e) {
            System.out.println("DEBUG CandidateProfileServlet: Invalid jobID: " + jobIDParam);
        }
        
        if (jobSeekerID == null) {
            System.out.println("DEBUG CandidateProfileServlet: Missing jobSeekerID");
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing candidate id");
            return;
        }
        
        // Lấy thông tin JobSeeker
        JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();
        JobSeeker js = jobSeekerDAO.getJobSeekerById(jobSeekerID);
        
        if (js == null) {
            System.out.println("DEBUG CandidateProfileServlet: Candidate not found - JobSeekerID: " + jobSeekerID);
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Candidate not found");
            return;
        }
        
        System.out.println("DEBUG CandidateProfileServlet: Found candidate: " + js.getFullName());
        
        // Lấy thông tin CV
        CVDAO cvDAO = new CVDAO();
        CV selectedCV = null;
        List<CV> allCVs = cvDAO.getCVsByJobSeekerId(jobSeekerID);
        
        // Nếu có cvID, lấy CV đó và verify nó thuộc về JobSeeker này
        if (cvID != null) {
            selectedCV = cvDAO.getCVById(cvID);
            if (selectedCV != null && selectedCV.getJobSeekerId() != jobSeekerID) {
                System.out.println("DEBUG CandidateProfileServlet: CV does not belong to JobSeeker, ignoring cvID");
                selectedCV = null;
            } else if (selectedCV != null) {
                System.out.println("DEBUG CandidateProfileServlet: Using CV from application - CVID: " + cvID);
            }
        }
        
        // Nếu không có selectedCV, lấy CV active đầu tiên
        if (selectedCV == null && allCVs != null && !allCVs.isEmpty()) {
            // Tìm CV active đầu tiên
            for (CV cv : allCVs) {
                if (cv.isActive()) {
                    selectedCV = cv;
                    break;
                }
            }
            // Nếu không có active, lấy CV đầu tiên
            if (selectedCV == null) {
                selectedCV = allCVs.get(0);
            }
            System.out.println("DEBUG CandidateProfileServlet: Using first available CV - CVID: " + 
                             (selectedCV != null ? selectedCV.getCvId() : "null"));
        }
        
        // Giả lập quyền xem thông tin dựa trên session (ví dụ: hasPackage)
        Boolean hasPackage = (Boolean) req.getSession().getAttribute("recruiterHasViewPackage");
        if (hasPackage == null) hasPackage = Boolean.FALSE;
        
        // Lấy trạng thái đơn ứng tuyển nếu có applicationID
        String applicationStatus = null;
        if (applicationID != null) {
            try {
                ApplicationDAO applicationDAO = new ApplicationDAO();
                Application application = applicationDAO.getApplicationById(applicationID);
                if (application != null) {
                    String rawStatus = application.getStatus();
                    if (rawStatus != null) {
                        applicationStatus = rawStatus.trim();
                    }
                    System.out.println("DEBUG CandidateProfileServlet: ApplicationID: " + applicationID);
                    System.out.println("DEBUG CandidateProfileServlet: Application found, status (raw): '" + rawStatus + "'");
                    System.out.println("DEBUG CandidateProfileServlet: Application status (trimmed): '" + applicationStatus + "'");
                } else {
                    System.out.println("DEBUG CandidateProfileServlet: WARNING - Application not found for ID: " + applicationID);
                }
            } catch (Exception e) {
                System.out.println("DEBUG CandidateProfileServlet: ERROR getting application status: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            System.out.println("DEBUG CandidateProfileServlet: No applicationID provided in request");
        }
        
        req.setAttribute("candidate", js);
        req.setAttribute("selectedCV", selectedCV);
        req.setAttribute("allCVs", allCVs);
        req.setAttribute("hasPackage", hasPackage);
        req.setAttribute("applicationID", applicationID);
        req.setAttribute("jobID", jobID);
        req.setAttribute("applicationStatus", applicationStatus);
        
        System.out.println("DEBUG CandidateProfileServlet: Forwarding to candidate-profile.jsp");
        req.getRequestDispatcher("/Recruiter/candidate-profile.jsp").forward(req, resp);
    }
}

