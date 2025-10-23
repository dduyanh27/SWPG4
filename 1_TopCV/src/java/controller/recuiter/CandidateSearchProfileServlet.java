package controller.recuiter;

import dal.JobSeekerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.JobSeeker;

public class CandidateSearchProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        Integer id = null;
        try {
            id = idParam == null ? null : Integer.parseInt(idParam);
        } catch (NumberFormatException ignored) {}

        if (id == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing candidate id");
            return;
        }

        JobSeekerDAO dao = new JobSeekerDAO();
        JobSeeker js = dao.getJobSeekerById(id);
        if (js == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Candidate not found");
            return;
        }

        // Giả lập quyền xem thông tin dựa trên session (ví dụ: hasPackage)
        Boolean hasPackage = (Boolean) req.getSession().getAttribute("recruiterHasViewPackage");
        if (hasPackage == null) hasPackage = Boolean.FALSE;

        req.setAttribute("candidate", js);
        req.setAttribute("hasPackage", hasPackage);
        req.getRequestDispatcher("/Recruiter/candidate-search-profile.jsp").forward(req, resp);
    }
}


