package controller.jobseeker;

import dal.JobSeekerDAO;
import model.JobSeeker;
import util.MD5Util;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet xử lý đăng ký tài khoản JobSeeker
 * Thu thập: Email, Password (FullName tự động tạo từ email)
 */
@WebServlet(name = "SignupServlet", urlPatterns = {"/JobSeeker/signup"})
public class SignupServlet extends HttpServlet {

    private JobSeekerDAO jobSeekerDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        jobSeekerDAO = new JobSeekerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to signup page
        response.sendRedirect(request.getContextPath() + "/JobSeeker/signup.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Get form parameters - CHỈ email và password
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            request.getRequestDispatcher("/JobSeeker/signup.jsp").forward(request, response);
            return;
        }

        // Trim inputs
        email = email.trim();

        // Validate email format
        if (!isValidEmail(email)) {
            request.setAttribute("error", "Email không hợp lệ!");
            request.getRequestDispatcher("/JobSeeker/signup.jsp").forward(request, response);
            return;
        }

        // Validate password length
        if (password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("/JobSeeker/signup.jsp").forward(request, response);
            return;
        }

        // Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/JobSeeker/signup.jsp").forward(request, response);
            return;
        }

        // Check if email already exists in any table (JobSeeker, Recruiter, Admin)
        if (jobSeekerDAO.isEmailExistsInAllTables(email)) {
            request.setAttribute("error", "Email đã được sử dụng! Vui lòng chọn email khác.");
            request.getRequestDispatcher("/JobSeeker/signup.jsp").forward(request, response);
            return;
        }

        try {
            // Hash password with MD5
            String hashedPassword = MD5Util.getMD5Hash(password);

            // Tự động tạo FullName từ email (phần trước @)
            String tempFullName = email.substring(0, email.indexOf("@"));
            // VD: john.doe@gmail.com → "john.doe"
            
            // Insert new JobSeeker với FullName tự động
            JobSeeker newJobSeeker = jobSeekerDAO.insertJobSeeker(email, hashedPassword, "Active", tempFullName);

            if (newJobSeeker != null) {
                // Registration successful
                HttpSession session = request.getSession();
                session.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập và cập nhật thông tin cá nhân.");
                
                // Redirect to login page
                response.sendRedirect(request.getContextPath() + "/JobSeeker/jobseeker-login.jsp");
            } else {
                // Registration failed
                request.setAttribute("error", "Đăng ký thất bại! Vui lòng thử lại.");
                request.getRequestDispatcher("/JobSeeker/signup.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/JobSeeker/signup.jsp").forward(request, response);
        }
    }

    /**
     * Validate email format
     */
    private boolean isValidEmail(String email) {
        if (email == null || email.isEmpty()) {
            return false;
        }
        // Simple email validation
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return email.matches(emailRegex);
    }

    @Override
    public String getServletInfo() {
        return "SignupServlet - Handles JobSeeker registration";
    }
}
