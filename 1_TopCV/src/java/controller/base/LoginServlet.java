/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.base;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.LoginService;
import util.LoginService.LoginResult;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String loginType = request.getParameter("loginType"); // "admin", "jobseeker", "recruiter"
        
        // Validate input
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            forwardToLoginPage(request, response, loginType);
            return;
        }
        
        // Sử dụng LoginService để xác thực
        LoginService loginService = LoginService.getInstance();
        LoginResult result = loginService.authenticateUser(email, password, loginType);
        
        if (result.isSuccess()) {
            // Tạo session và lưu thông tin user
            HttpSession session = request.getSession();
            session.setAttribute("user", result.getUser());
            session.setAttribute("userType", result.getUserType());
            
            // Lưu thông tin cụ thể theo loại user
            switch (result.getUserType()) {
                case "admin":
                    model.Admin admin = (model.Admin) result.getUser();
                    session.setAttribute("userID", admin.getAdminId());
                    session.setAttribute("userName", admin.getFullName());
                    response.sendRedirect(request.getContextPath() + "/Admin/admin-dashboard.jsp");
                    break;
                    
                case "jobseeker":
                    model.JobSeeker jobSeeker = (model.JobSeeker) result.getUser();
                    session.setAttribute("userID", jobSeeker.getJobSeekerId());
                    session.setAttribute("userName", jobSeeker.getFullName());
                    response.sendRedirect(request.getContextPath() + "/JobSeeker/index.jsp");
                    break;
                    
                case "recruiter":
                    model.Recruiter recruiter = (model.Recruiter) result.getUser();
                    session.setAttribute("userID", recruiter.getRecruiterID());
                    session.setAttribute("userName", recruiter.getCompanyName());
                    response.sendRedirect(request.getContextPath() + "/Recruiter/index.jsp");
                    break;
                    
                default:
                    request.setAttribute("error", "Unknown user type");
                    forwardToLoginPage(request, response, loginType);
                    break;
            }
        } else {
            // Đăng nhập thất bại
            request.setAttribute("error", result.getMessage());
            forwardToLoginPage(request, response, loginType);
        }
    }
    
    private void forwardToLoginPage(HttpServletRequest request, HttpServletResponse response, String loginType)
            throws ServletException, IOException {
        
        if ("admin".equals(loginType)) {
            request.getRequestDispatcher("/Admin/admin-login.jsp").forward(request, response);
        } else if ("jobseeker".equals(loginType)) {
            request.getRequestDispatcher("/JobSeeker/jobseeker-login.jsp").forward(request, response);
        } else if ("recruiter".equals(loginType)) {
            request.getRequestDispatcher("/Recruiter/recruiter-login.jsp").forward(request, response);
        } else {
            // Default to admin login
            request.getRequestDispatcher("/Admin/admin-login.jsp").forward(request, response);
        }
   }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
