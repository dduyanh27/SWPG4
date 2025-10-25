package controller.jobseeker;

import dal.JobSeekerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.JobSeeker;
import util.SessionHelper;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.UUID;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;

@WebServlet(name = "AvatarUploadServlet", urlPatterns = {"/upload-avatar"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, fileSizeThreshold = 1024 * 1024) // 5MB
public class AvatarUploadServlet extends HttpServlet {

    private transient JobSeekerDAO jobSeekerDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        jobSeekerDAO = new JobSeekerDAO();
    }

    private String getUploadDir(HttpServletRequest request) {
        // Prefer context attribute set by listener, then context-param
        Object ctxAttr = getServletContext().getAttribute("AVATAR_UPLOAD_DIR");
        if (ctxAttr instanceof String && !((String) ctxAttr).trim().isEmpty()) {
            return ((String) ctxAttr).trim();
        }
        String configured = getServletContext().getInitParameter("avatarUploadDir");
        if (configured != null && !configured.trim().isEmpty()) {
            return configured.trim();
        }
        // Final fallback: user home -> SWPG4/TopCV_Avatars (drive-agnostic)
        return java.nio.file.Paths.get(System.getProperty("user.home"), "SWPG4", "TopCV_Avatars").toString();
    }

    private static boolean isAllowedImage(String contentType, String filename) {
        if (contentType == null) return false;
        String ct = contentType.toLowerCase(Locale.ROOT);
        boolean typeOk = ct.startsWith("image/") && (ct.contains("jpeg") || ct.contains("png") || ct.contains("webp") || ct.contains("jpg"));
        String lower = filename.toLowerCase(Locale.ROOT);
        boolean extOk = lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") || lower.endsWith(".webp");
        return typeOk && extOk;
    }

    private static String getExtension(String fileName) {
        int dot = fileName.lastIndexOf('.');
        return (dot >= 0) ? fileName.substring(dot) : "";
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        JobSeeker current = SessionHelper.getCurrentJobSeeker(request);
        Integer userId = SessionHelper.getCurrentUserId(request);
        if (current == null || userId == null || !SessionHelper.isJobSeeker(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false,\"message\":\"Chưa đăng nhập\"}");
            return;
        }

        Part filePart = null;
        try {
            filePart = request.getPart("avatarFile");
        } catch (Exception ex) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Thiếu file tải lên\"}");
            return;
        }

        if (filePart == null || filePart.getSize() == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Chưa chọn ảnh\"}");
            return;
        }

        String submittedName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String contentType = filePart.getContentType();

        if (!isAllowedImage(contentType, submittedName)) {
            response.setStatus(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE);
            response.getWriter().write("{\"success\":false,\"message\":\"Chỉ hỗ trợ JPG, PNG, WEBP (<=5MB)\"}");
            return;
        }

        // Read into memory for validation (<=5MB) and save later
        byte[] imageBytes;
        try (InputStream in = filePart.getInputStream(); ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            in.transferTo(baos);
            imageBytes = baos.toByteArray();
        }

        // Validate actual image content and reasonable dimensions
        BufferedImage buffered;
        try (ByteArrayInputStream bais = new ByteArrayInputStream(imageBytes)) {
            buffered = ImageIO.read(bais);
        }
        if (buffered == null) {
            response.setStatus(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE);
            response.getWriter().write("{\"success\":false,\"message\":\"File không phải ảnh hợp lệ\"}");
            return;
        }
        int width = buffered.getWidth();
        int height = buffered.getHeight();
        int MAX_W = 5000, MAX_H = 5000;
        if (width <= 0 || height <= 0 || width > MAX_W || height > MAX_H) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Kích thước ảnh quá lớn (<= " + MAX_W + "x" + MAX_H + ")\"}");
            return;
        }

        // Create upload directory if missing
        String uploadDir = getUploadDir(request);
        Path uploadPath = Paths.get(uploadDir);
        try {
            Files.createDirectories(uploadPath);
        } catch (IOException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"Không thể tạo thư mục lưu trữ\"}");
            return;
        }

        // Generate safe unique filename
        String ext = getExtension(submittedName);
        String ts = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String generated = "js_" + userId + "_" + ts + "_" + UUID.randomUUID().toString().replace("-", "").substring(0, 8) + ext.toLowerCase(Locale.ROOT);

        Path target = uploadPath.resolve(generated).normalize();
        if (!target.startsWith(uploadPath)) { // path traversal guard
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Tên file không hợp lệ\"}");
            return;
        }

        // Save file (data already in memory)
        try (FileOutputStream out = new FileOutputStream(target.toFile())) {
            out.write(imageBytes);
        } catch (IOException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"Không thể lưu file\"}");
            return;
        }

        // Remember old avatar filename to delete later
        String oldFile = null;
        try {
            JobSeeker exist = jobSeekerDAO.getJobSeekerById(userId);
            if (exist != null) oldFile = exist.getImg();
        } catch (Exception ignore) {}

        // Update DB
        boolean updated = jobSeekerDAO.updateAvatar(userId, generated);
        if (!updated) {
            // best-effort: delete file if DB update fails
            try { Files.deleteIfExists(target); } catch (IOException ignore) {}
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"Không thể cập nhật hồ sơ\"}");
            return;
        }

        // Delete old avatar if any (best-effort)
        if (oldFile != null && !oldFile.isEmpty() && !generated.equals(oldFile)) {
            try {
                Path oldPath = uploadPath.resolve(oldFile).normalize();
                if (oldPath.startsWith(uploadPath)) {
                    Files.deleteIfExists(oldPath);
                }
            } catch (IOException ignore) {}
        }

        // Refresh session object
        try {
            JobSeeker refreshed = jobSeekerDAO.getJobSeekerById(userId);
            if (refreshed != null) {
                SessionHelper.updateJobSeekerInSession(request, refreshed);
            }
        } catch (Exception ignore) {}

        String imageUrl = request.getContextPath() + "/avatar/" + generated;
        response.getWriter().write("{\"success\":true,\"filename\":\"" + generated + "\",\"url\":\"" + imageUrl + "\"}");
    }
}
