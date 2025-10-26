package controller.jobseeker;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet(name = "AvatarImageServlet", urlPatterns = {"/avatar/*"})
public class AvatarImageServlet extends HttpServlet {

    private String getUploadDir() {
        Object ctxAttr = getServletContext().getAttribute("AVATAR_UPLOAD_DIR");
        if (ctxAttr instanceof String && !((String) ctxAttr).trim().isEmpty()) {
            return ((String) ctxAttr).trim();
        }
        String configured = getServletContext().getInitParameter("avatarUploadDir");
        if (configured != null && !configured.trim().isEmpty()) {
            return configured.trim();
        }
        return java.nio.file.Paths.get(System.getProperty("user.home"), "SWPG4", "TopCV_Avatars").toString();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo(); // expected like /filename.jpg
        // Validate path: allow single-segment name only, starting with '/'
        if (pathInfo == null || 
            "/".equals(pathInfo) || 
            pathInfo.contains("..") || 
            pathInfo.indexOf('/', 1) >= 0) { // additional '/' beyond the first is not allowed
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String fileName = pathInfo.substring(1); // remove leading '/'
        Path baseDir = Paths.get(getUploadDir());
        Path filePath = baseDir.resolve(fileName).normalize();

        if (!filePath.startsWith(baseDir) || !Files.exists(filePath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = Files.probeContentType(filePath);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        response.setContentType(contentType);
        response.setHeader("Cache-Control", "public, max-age=86400"); // 1 day

        try (FileInputStream in = new FileInputStream(filePath.toFile());
             OutputStream out = response.getOutputStream()) {
            in.transferTo(out);
        }
    }
}
