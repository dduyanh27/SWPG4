
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


public class AdminChangePassword extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
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
        
        if (!admin.getPassword().equals(pass)) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }
        
        if (!npass.equals(cfpass)) {
            request.setAttribute("error", "Xác nhận mật khẩu không khớp!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }
        
        AdminDAO dao = new AdminDAO();
        dao.updatePassword(admin.getAdminId(), npass);
        
        admin.setPassword(npass);
        session.setAttribute("admin", admin);
        
        request.setAttribute("success", "Đổi mật khẩu thành công!");
        request.getRequestDispatcher("admin-profile.jsp").forward(request, response);
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
