/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin;

import dal.AdminJobDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Job;
import model.AdminJobDetail;


@WebServlet(name="AdminJobFilter", urlPatterns={"/adminjobfilter"})
public class AdminJobFilter extends HttpServlet {
   

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminJobFilter</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminJobFilter at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Xử lý GET request - hiển thị trang filter
        AdminJobDAO ajd = new AdminJobDAO();
        
        // Lấy tất cả jobs để hiển thị
        List<Job> jobList = ajd.getAllJobs();
        request.setAttribute("jobList", jobList);
        
        List<Job> pendingJobs = ajd.getJobsByStatus("Pending");
        request.setAttribute("pendingJobs", pendingJobs);
        
        List<Job> publishedJobs = ajd.getJobsByStatus("Published");
        request.setAttribute("publishedJobs", publishedJobs);
        
        List<AdminJobDetail> jobDetails = ajd.getAllDetailJob();
        request.setAttribute("jobDetails", jobDetails);
        
        // Forward về trang JSP
        request.getRequestDispatcher("/Admin/admin-jobposting-management.jsp").forward(request, response);
    } 


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Xử lý POST request - filter jobs
        String search = request.getParameter("search");
        String location = request.getParameter("location");
        String type = request.getParameter("type");
        String status = request.getParameter("status");
        String category = request.getParameter("category");
        String salary = request.getParameter("salary");
        
        AdminJobDAO ajd = new AdminJobDAO();
        
        // Gọi method filterJobs để lấy kết quả
        List<AdminJobDetail> filteredJobs = ajd.filterJobs(search, location, type, status, category, salary);
        
        // Set attributes cho request
        request.setAttribute("jobDetails", filteredJobs);
        request.setAttribute("search", search);
        request.setAttribute("location", location);
        request.setAttribute("type", type);
        request.setAttribute("status", status);
        request.setAttribute("category", category);
        request.setAttribute("salary", salary);
        
        // Lấy thống kê
        List<Job> jobList = ajd.getAllJobs();
        request.setAttribute("jobList", jobList);
        
        List<Job> pendingJobs = ajd.getJobsByStatus("Pending");
        request.setAttribute("pendingJobs", pendingJobs);
        
        List<Job> publishedJobs = ajd.getJobsByStatus("Published");
        request.setAttribute("publishedJobs", publishedJobs);
        
        // Forward về trang JSP
        request.getRequestDispatcher("/Admin/admin-jobposting-management.jsp").forward(request, response);
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
