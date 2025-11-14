package controller.admin;

import dal.RecruiterDAO;
import model.Recruiter;
import util.SessionHelper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AdminViewRecruiterCompanyServlet", urlPatterns = {"/admin-view-recruiter-company"})
public class AdminViewRecruiterCompanyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        if (!SessionHelper.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
            return;
        }
        
        // Lấy ID recruiter từ parameter
        String recruiterIdParam = request.getParameter("id");
        if (recruiterIdParam == null || recruiterIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing recruiter ID");
            return;
        }
        
        try {
            int recruiterId = Integer.parseInt(recruiterIdParam);
            
            // Load thông tin recruiter từ database
            RecruiterDAO recruiterDAO = new RecruiterDAO();
            Recruiter recruiter = recruiterDAO.getRecruiterById(recruiterId);
            
            if (recruiter == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Recruiter not found");
                return;
            }
            
            // Set recruiter vào request attribute
            request.setAttribute("recruiter", recruiter);
            
            // Forward đến trang hiển thị thông tin công ty
            request.getRequestDispatcher("/Admin/admin-recruiter-company-info.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid recruiter ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading recruiter information");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
