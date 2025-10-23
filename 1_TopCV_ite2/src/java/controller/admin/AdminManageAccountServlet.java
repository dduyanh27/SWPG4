 package controller.admin;

import dal.AdminDAO;
import dal.JobSeekerDAO;
import dal.RecruiterDAO;
import model.Admin;
import model.JobSeeker;
import model.Recruiter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;


public class AdminManageAccountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy role từ query param, default = "admin"
        String selectedRole = request.getParameter("role");
        if (selectedRole == null || selectedRole.isEmpty()) {
            selectedRole = "admin";
        }
        request.setAttribute("selectedRole", selectedRole);

        // Load danh sách Admin
        AdminDAO adminDAO = new AdminDAO();
        List<Admin> adminList = adminDAO.getAllAdmin();
        request.setAttribute("adminList", adminList);

        // Load danh sách JobSeeker
        JobSeekerDAO jsDAO = new JobSeekerDAO();
        List<JobSeeker> jobSeekerList = jsDAO.getAllJobSeekersActive();
        request.setAttribute("jobSeekerList", jobSeekerList);

        // Load danh sách Recruiter
        RecruiterDAO reDAO = new RecruiterDAO();
        List<Recruiter> recruiterList = reDAO.getAllRecruiters();
        request.setAttribute("recruiterList", recruiterList);

        // Forward sang JSP
        request.getRequestDispatcher("Admin/admin-manage-account.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
