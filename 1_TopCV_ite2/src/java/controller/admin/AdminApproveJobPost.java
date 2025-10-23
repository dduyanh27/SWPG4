/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.AdminJobDAO;

/**
 *
 * @author Admin
 */
@WebServlet(name="AdminApproveJobPost", urlPatterns={"/adminapprovejobpost"})
public class AdminApproveJobPost extends HttpServlet {
   
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

        String redirectUrl = request.getContextPath() + "/Admin/admin-jobposting-management.jsp";

        try {
            String[] jobIds = request.getParameterValues("jobId");
            if (jobIds == null || jobIds.length == 0) {
                String fallback = request.getParameter("jobIds");
                if (fallback != null && !fallback.trim().isEmpty()) {
                    jobIds = fallback.split(",");
                }
            }

            if (jobIds == null || jobIds.length == 0) {
                response.sendRedirect(redirectUrl + "?success=0&message=Missing+jobId");
                return;
            }

            AdminJobDAO adminJobDAO = new AdminJobDAO();
            int approvedCount = 0;
            for (String idStr : jobIds) {
                if (idStr == null || idStr.trim().isEmpty()) {
                    continue;
                }
                try {
                    int jobId = Integer.parseInt(idStr.trim());
                    adminJobDAO.approveJobs(jobId);
                    approvedCount++;
                } catch (NumberFormatException ignore) {
                }
            }
            response.sendRedirect(redirectUrl + "?success=1&approved=" + approvedCount);
        } catch (Exception ex) {
            response.sendRedirect(redirectUrl + "?success=0");
        }
    } 


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
