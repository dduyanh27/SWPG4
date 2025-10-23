
package controller.admin;

import dal.AdminDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Admin;
import util.MD5Util;


public class AdminChangePassword extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminChangePassword</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminChangePassword at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");
        
        String pass = request.getParameter("currentPassword");
        String npass = request.getParameter("newPassword");
        String cfpass = request.getParameter("confirmPassword");
        
        if (!admin.getPassword().equals(MD5Util.getMD5Hash(pass))) {
            request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng!");
            request.getRequestDispatcher("Admin/admin-profile.jsp").forward(request, response);
            return;
        }
        
        if (!npass.equals(cfpass)) {
            request.setAttribute("errorMessage", "Xác nhận mật khẩu không khớp!");
            request.getRequestDispatcher("Admin/admin-profile.jsp").forward(request, response);
            return;
        }
        
        AdminDAO dao = new AdminDAO();
        dao.updatePassword(admin.getAdminId(), npass);
        
        admin.setPassword(MD5Util.getMD5Hash(npass));
        session.setAttribute("admin", admin);
        
        request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
        request.getRequestDispatcher("Admin/admin-profile.jsp").forward(request, response);
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
