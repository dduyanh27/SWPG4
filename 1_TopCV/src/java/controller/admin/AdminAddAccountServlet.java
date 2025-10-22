package controller.admin;

import dal.DAO;
import model.Admin;
import model.JobSeeker;
import model.Recruiter;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminAddAccountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị form thêm tài khoản
        request.getRequestDispatcher("Admin/admin-profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        // Kiểm tra dữ liệu bắt buộc
        if (email == null || email.isEmpty() || password == null || password.isEmpty()
                || fullName == null || fullName.isEmpty() || phone == null || phone.isEmpty()
                || gender == null || gender.isEmpty() || role == null || role.isEmpty()
                || status == null || status.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("Admin/admin-profile.jsp").forward(request, response);
            return;
        }

        try {
            DAO dao = new DAO(); // DAO dùng chung cho 3 table

            switch (role.toLowerCase()) {
                case "admin":
                    Admin admin = new Admin();
                    admin.setEmail(email);
                    admin.setPassword(password);
                    admin.setFullName(fullName);
                    admin.setPhone(phone);
                    admin.setGender(gender);
                    admin.setStatus(status);
                    dao.addAdmin(admin);
                    break;

                case "jobseeker":
                    JobSeeker js = new JobSeeker();
                    js.setEmail(email);
                    js.setPassword(password);
                    js.setFullName(fullName);
                    js.setPhone(phone);
                    js.setGender(gender);
                    js.setStatus(status);
                    dao.addJobSeeker(js);
                    break;

                case "recruiter":
                    Recruiter re = new Recruiter();
                    re.setEmail(email);
                    re.setPassword(password);
                    re.setCompanyName(fullName);
                    re.setPhone(phone);
                    re.setStatus(status);
                    dao.addRecruiter(re);
                    break;

                default:
                    request.setAttribute("error", "Vai trò không hợp lệ!");
                    request.getRequestDispatcher("Admin/admin-profile.jsp").forward(request, response);
                    return;
            }

            // Thêm thành công → chuyển về danh sách tài khoản
            response.sendRedirect("manage-accounts?role=" + role);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi thêm tài khoản: " + e.getMessage());
            request.getRequestDispatcher("Admin/admin-manage-account.jsp").forward(request, response);
        }
    }
}
