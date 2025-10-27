package controller.staff;

import dal.AdminDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Admin;

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
            request.getRequestDispatcher("Staff/staff-profile.jsp").forward(request, response);
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
                
                // Xác định role để redirect về đúng dashboard
                String staffRole = "sales"; // Mặc định là sales
                if (refreshed.getEmail() != null && 
                    (refreshed.getEmail().toLowerCase().contains("marketing") || 
                     refreshed.getFullName() != null && refreshed.getFullName().toLowerCase().contains("marketing"))) {
                    staffRole = "marketing";
                }
                
                // Debug: In ra console để kiểm tra
                System.out.println("UpdateStaffProfile - Staff Role Detection:");
                System.out.println("Email: " + refreshed.getEmail());
                System.out.println("FullName: " + refreshed.getFullName());
                System.out.println("Detected Role: " + staffRole);
                
                request.setAttribute("successMessage", "Cập nhật hồ sơ thành công.");
                request.setAttribute("staffRole", staffRole);
                request.getRequestDispatcher("Staff/staff-profile.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật thông tin session.");
                request.getRequestDispatcher("Staff/staff-profile.jsp").forward(request, response);
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("errorMessage", "adminId không hợp lệ.");
            request.getRequestDispatcher("Staff/staff-profile.jsp").forward(request, response);
        } catch (Exception ex) {
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật hồ sơ.");
            request.getRequestDispatcher("Staff/staff-profile.jsp").forward(request, response);
        }
    }
}
