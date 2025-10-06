
package controller.admin;

import dal.AdminDAO;
import java.io.IOException;
import java.net.URLEncoder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="AdminAssignRole", urlPatterns={"/adminassignrole"})
public class AdminAssignRole extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Redirect về trang ad-staff.jsp nếu truy cập trực tiếp
        response.sendRedirect(request.getContextPath() + "/Admin/ad-staff.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Lấy tham số từ request
            int adminId = Integer.parseInt(request.getParameter("adminId"));
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            String selectedRole = request.getParameter("selectedRole");
            
            System.out.println("AdminId: " + adminId + ", RoleId: " + roleId + ", SelectedRole: " + selectedRole); // Debug log
            
            // Gọi AdminDAO để assign role
            AdminDAO adminDAO = new AdminDAO();
            adminDAO.assignRole(roleId, adminId);
            
            // Redirect về trang ad-staff.jsp với thông báo thành công
            String msg = URLEncoder.encode("Phân quyền thành công!", "UTF-8");
            String redirectUrl = request.getContextPath() + "/Admin/ad-staff.jsp?role=" + selectedRole + "&msg=" + msg;
            System.out.println("Redirect URL: " + redirectUrl); // Debug log
            response.sendRedirect(redirectUrl);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Redirect về trang ad-staff.jsp với thông báo lỗi
            String selectedRole = request.getParameter("selectedRole");
            String msg = URLEncoder.encode("Lỗi khi phân quyền!", "UTF-8");
            String redirectUrl = request.getContextPath() + "/Admin/ad-staff.jsp?role=" + selectedRole + "&msg=" + msg;
            System.out.println("Error Redirect URL: " + redirectUrl); // Debug log
            response.sendRedirect(redirectUrl);
        }
    }

    @Override
    public String getServletInfo() {
        return "Admin Assign Role Servlet";
    }
}
