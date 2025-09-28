package controller.recuiter;

import dal.RecruiterDAO;
import model.Recruiter;
import util.MD5Util;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RecruiterRegistrationServlet", urlPatterns = {"/RecruiterRegistrationServlet"})
public class RecruiterRegistrationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy thông tin từ form
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String companyName = request.getParameter("companyName");
            String industry = request.getParameter("industry");
            String address = request.getParameter("address");

            // Kiểm tra các trường bắt buộc
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                companyName == null || companyName.trim().isEmpty() ||
                address == null || address.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=missing_fields");
                return;
            }
            
            // Set default values for optional fields
            if (industry == null || industry.trim().isEmpty()) {
                industry = "other";
            }

            // Kiểm tra email đã tồn tại trong tất cả các bảng chưa
            RecruiterDAO recruiterDAO = new RecruiterDAO();
            
            if (recruiterDAO.isEmailExistsInAllTables(email)) {
                response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=email_exists");
                return;
            }

            // Mã hóa mật khẩu bằng MD5
            String encryptedPassword = MD5Util.getMD5Hash(password);

            // Tạo recruiter mới với status "Pending"
            String fullName = firstName + " " + lastName;
            Recruiter recruiter = recruiterDAO.insertRecruiter(
                email, 
                encryptedPassword, 
                fullName, 
                phone, 
                companyName, 
                industry, 
                address, 
                "Pending"
            );

            if (recruiter != null) {
                // Redirect to registration page with success message
                response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?success=registration_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=registration_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=system_error");
        }
    }
}