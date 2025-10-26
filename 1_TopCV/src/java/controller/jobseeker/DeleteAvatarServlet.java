package controller.jobseeker;

import dal.JobSeekerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.JobSeeker;
import util.SessionHelper;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet(name = "DeleteAvatarServlet", urlPatterns = {"/delete-avatar"})
public class DeleteAvatarServlet extends HttpServlet {

    private transient JobSeekerDAO jobSeekerDAO;

    @Override
    public void init() throws ServletException {
        jobSeekerDAO = new JobSeekerDAO();
    }

    private String getUploadDir(HttpServletRequest request) {
        Object ctxAttr = getServletContext().getAttribute("AVATAR_UPLOAD_DIR");
        if (ctxAttr instanceof String && !((String) ctxAttr).trim().isEmpty()) return ((String) ctxAttr).trim();
        String configured = getServletContext().getInitParameter("avatarUploadDir");
        if (configured != null && !configured.trim().isEmpty()) return configured.trim();
        return java.nio.file.Paths.get(System.getProperty("user.home"), "SWPG4", "TopCV_Avatars").toString();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        JobSeeker current = SessionHelper.getCurrentJobSeeker(request);
        Integer userId = SessionHelper.getCurrentUserId(request);
        if (current == null || userId == null || !SessionHelper.isJobSeeker(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false,\"message\":\"Chưa đăng nhập\"}");
            return;
        }

        JobSeeker db = jobSeekerDAO.getJobSeekerById(userId);
        if (db == null || db.getImg() == null || db.getImg().isEmpty()) {
            // nothing to delete, but consider success to simplify UI
            jobSeekerDAO.updateAvatar(userId, null);
            SessionHelper.updateJobSeekerInSession(request, jobSeekerDAO.getJobSeekerById(userId));
            response.getWriter().write("{\"success\":true}");
            return;
        }

        String uploadDir = getUploadDir(request);
        Path base = Paths.get(uploadDir);
        Path oldPath = base.resolve(db.getImg()).normalize();
        try {
            if (oldPath.startsWith(base)) {
                Files.deleteIfExists(oldPath);
            }
        } catch (Exception ignore) {}

        jobSeekerDAO.updateAvatar(userId, null);
        JobSeeker refreshed = jobSeekerDAO.getJobSeekerById(userId);
        if (refreshed != null) SessionHelper.updateJobSeekerInSession(request, refreshed);

        response.getWriter().write("{\"success\":true}");
    }
}
