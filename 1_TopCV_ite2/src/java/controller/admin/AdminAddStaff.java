/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dal.AdminDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Admin;

@WebServlet(name = "AdminAddStaff", urlPatterns = {"/addstaff"})
public class AdminAddStaff extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminAddStaff</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminAddStaff at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String roleIdStr = request.getParameter("roleId");
        String status = request.getParameter("status");

        if (!password.equals(confirmPassword)) {
            response.sendRedirect("admin-add-staff.jsp?error=Mật khẩu không khớp");
            return;
        }

        AdminDAO dao = new AdminDAO();
        Admin newAdmin = new Admin();
        newAdmin.setFullName(fullName);
        newAdmin.setGender(gender);
        newAdmin.setEmail(email);
        newAdmin.setPhone(phone);
        newAdmin.setPassword(password);
        newAdmin.setStatus(status);

        // Thêm vào bảng Admins
        Admin created = dao.addStaff(newAdmin);

        if (created != null && roleIdStr != null && !roleIdStr.isEmpty()) {
            int roleId = Integer.parseInt(roleIdStr);
            dao.assignRoleToStaff(roleId, created.getAdminId());
        }

        String selectedRole = request.getParameter("returnRole");
        String redirectUrl = request.getContextPath() + "/Admin/ad-staff.jsp?role=" + (selectedRole != null ? selectedRole : "admin") + "&msg=" + URLEncoder.encode("Thêm nhân sự thành công!", "UTF-8");
        response.sendRedirect(redirectUrl);

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
