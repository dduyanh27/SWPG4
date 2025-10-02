package controller.recuiter;

import dal.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Job;
import model.Recruiter;

@WebServlet(name = "HomeRecuiterServlet", urlPatterns = {"/homerecuiter"})
public class HomeRecruiterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object userObject = session.getAttribute("user");
        String userType = (String) session.getAttribute("userType");

        Recruiter currentRecruiter = null;
        int recruiterId = 0;
        String userName = "Guest";

        if (userObject == null || !"recruiter".equals(userType) || !(userObject instanceof Recruiter)) {
            response.sendRedirect(request.getContextPath() + "/Recruiter/recruiter-login.jsp");
            return;
        }

        try {
            currentRecruiter = (Recruiter) userObject;
            recruiterId = currentRecruiter.getRecruiterID();
            userName = currentRecruiter.getCompanyName();

            if (recruiterId <= 0) {
                response.sendRedirect(request.getContextPath() + "/Recruiter/recruiter-login.jsp");
                return;
            }


            JobDAO jobDAO = new JobDAO();
            List<Job> jobList = jobDAO.getJobsByRecruiterId(recruiterId);
            request.setAttribute("jobList", jobList);
            request.setAttribute("userName", userName);
            request.setAttribute("userID", recruiterId);
            request.getRequestDispatcher("/Recruiter/index.jsp").forward(request, response);

        } catch (ClassCastException e) {
         
            response.sendRedirect(request.getContextPath() + "/Recruiter/recruiter-login.jsp");
        }
    }

   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}