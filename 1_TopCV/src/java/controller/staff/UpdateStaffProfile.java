package controller.staff;

import dal.AdminDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Admin;
import model.Role;

public class UpdateStaffProfile extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Staff/staff-profile.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String adminIdRaw = request.getParameter("adminId");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String bio = request.getParameter("bio");

        if (adminIdRaw == null || adminIdRaw.isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu thông tin adminId.");
            // Lấy role từ session để redirect đúng
            HttpSession sessionCheck = request.getSession();
            Role adminRole = (Role) sessionCheck.getAttribute("adminRole");
            String roleName = (adminRole != null) ? adminRole.getName() : "";
            String staffRole = "Marketing Staff".equals(roleName) ? "marketing" : "sales";
            request.getRequestDispatcher("Staff/staff-profile.jsp?role=" + staffRole).forward(request, response);
            return;
        }

        try {
            int adminId = Integer.parseInt(adminIdRaw);

            Admin adminUpdate = new Admin();
            adminUpdate.setAdminId(adminId);
            adminUpdate.setPhone(phone);
            adminUpdate.setGender(gender);
            adminUpdate.setAddress(address);
            adminUpdate.setBio(bio);

            AdminDAO adminDAO = new AdminDAO();
            adminDAO.updateAdmin(adminUpdate);

            // refresh session admin info
            Admin refreshed = adminDAO.getAdminById(adminId);
            if (refreshed != null) {
                HttpSession session = request.getSession();
                session.setAttribute("admin", refreshed);
                
                // Xác định role từ session (ưu tiên hơn email/name)
                Role adminRole = (Role) session.getAttribute("adminRole");
                String roleName = (adminRole != null) ? adminRole.getName() : "";
                String staffRole = "sales"; // Mặc định là sales
                
                if ("Marketing Staff".equals(roleName)) {
                    staffRole = "marketing";
                } else if ("Sales".equals(roleName)) {
                    staffRole = "sales";
                } else {
                    // Fallback: Kiểm tra email hoặc name nếu không có role trong session
                    if (refreshed.getEmail() != null && 
                        (refreshed.getEmail().toLowerCase().contains("marketing") || 
                         refreshed.getFullName() != null && refreshed.getFullName().toLowerCase().contains("marketing"))) {
                        staffRole = "marketing";
                    }
                }
                
                request.setAttribute("successMessage", "Cập nhật hồ sơ thành công.");
                request.setAttribute("staffRole", staffRole);
                // Redirect với role parameter
                request.getRequestDispatcher("Staff/staff-profile.jsp?role=" + staffRole).forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật thông tin session.");
                // Lấy role từ session để redirect đúng
                HttpSession sessionError = request.getSession();
                Role adminRole = (Role) sessionError.getAttribute("adminRole");
                String roleName = (adminRole != null) ? adminRole.getName() : "";
                String staffRole = "Marketing Staff".equals(roleName) ? "marketing" : "sales";
                request.getRequestDispatcher("Staff/staff-profile.jsp?role=" + staffRole).forward(request, response);
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("errorMessage", "adminId không hợp lệ.");
            // Lấy role từ session để redirect đúng
            HttpSession sessionError = request.getSession();
            Role adminRole = (Role) sessionError.getAttribute("adminRole");
            String roleName = (adminRole != null) ? adminRole.getName() : "";
            String staffRole = "Marketing Staff".equals(roleName) ? "marketing" : "sales";
            request.getRequestDispatcher("Staff/staff-profile.jsp?role=" + staffRole).forward(request, response);
        } catch (Exception ex) {
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật hồ sơ.");
            // Lấy role từ session để redirect đúng
            HttpSession sessionError = request.getSession();
            Role adminRole = (Role) sessionError.getAttribute("adminRole");
            String roleName = (adminRole != null) ? adminRole.getName() : "";
            String staffRole = "Marketing Staff".equals(roleName) ? "marketing" : "sales";
            request.getRequestDispatcher("Staff/staff-profile.jsp?role=" + staffRole).forward(request, response);
        }
    }
}
