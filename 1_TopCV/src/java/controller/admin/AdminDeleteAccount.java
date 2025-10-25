package controller.admin;

import dal.AdminDAO;
import dal.JobSeekerDAO;
import dal.RecruiterDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;

public class AdminDeleteAccount extends HttpServlet {

    private AdminDAO adminDAO = new AdminDAO();
    private RecruiterDAO recruiterDAO = new RecruiterDAO();
    private JobSeekerDAO jobSeekerDAO = new JobSeekerDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminDeleteAccount</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminDeleteAccount at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        String idStr = request.getParameter("id");
        String message = null;

        if (type != null && idStr != null) {
            try {
                int id = Integer.parseInt(idStr);

                boolean ok;
                switch (type) {
                    case "admin":
                        ok = adminDAO.deleteAdminById(id);
                        message = ok ? "Đã xóa Admin thành công!" : "Không thể xóa Admin.";
                        break;
//                    case "recruiter":
//                        ok = recruiterDAO.deleteRecruiterById(id);
//                        message = ok ? "Đã xóa Recruiter thành công!" : "Không thể xóa Recruiter.";
//                        break;
                    case "jobseeker":
                        ok = jobSeekerDAO.deleteJobSeekerById(id);
                        message = ok ? "Đã xóa Job Seeker thành công!" : "Không thể xóa Job Seeker.";
                        break;
                    default:
                        message = "Loại tài khoản không hợp lệ!";
                }

            } catch (NumberFormatException e) {
                message = "ID không hợp lệ!";
            }
        } else {
            message = "Thiếu thông tin xóa!";
        }

        String role = (type == null || type.isEmpty()) ? "admin" : type;
        String encodedMsg = message == null ? "" : URLEncoder.encode(message, "UTF-8");
        response.sendRedirect("manage-accounts?role=" + role + (encodedMsg.isEmpty() ? "" : ("&msg=" + encodedMsg)));
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
