package controller.recuiter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "ImageValidationServlet", urlPatterns = {"/ImageValidationServlet"})
@MultipartConfig(maxFileSize = 5242880, maxRequestSize = 5242880) // 5MB
public class ImageValidationServlet extends HttpServlet {

    // Các loại file được phép
    private static final List<String> ALLOWED_IMAGE_TYPES = Arrays.asList(
        "image/jpeg", "image/jpg", "image/png", "image/gif"
    );
    
    private static final List<String> ALLOWED_DOCUMENT_TYPES = Arrays.asList(
        "application/pdf", "image/jpeg", "image/jpg", "image/png"
    );
    
    // Kích thước tối đa cho từng loại file
    private static final long MAX_IMAGE_SIZE = 1024 * 1024; // 1MB cho hình ảnh
    private static final long MAX_DOCUMENT_SIZE = 5 * 1024 * 1024; // 5MB cho tài liệu
    
    // Số lượng file tối đa
    private static final int MAX_IMAGES_COUNT = 5;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            String fileType = request.getParameter("fileType"); // "logo", "images", "registrationCert"
            
            if (fileType == null || fileType.trim().isEmpty()) {
                out.print("{\"valid\": false, \"error\": \"Loại file không được xác định\"}");
                return;
            }
            
            switch (fileType) {
                case "logo":
                    validateLogoFile(request, out);
                    break;
                case "images":
                    validateImagesFiles(request, out);
                    break;
                case "registrationCert":
                    validateRegistrationCertFile(request, out);
                    break;
                default:
                    out.print("{\"valid\": false, \"error\": \"Loại file không hợp lệ\"}");
                    break;
            }
            
        } catch (Exception e) {
            System.err.println("ImageValidationServlet error:");
            e.printStackTrace();
            out.print("{\"valid\": false, \"error\": \"Lỗi server: " + e.getMessage() + "\"}");
        }
    }
    
    private void validateLogoFile(HttpServletRequest request, PrintWriter out) 
            throws ServletException, IOException {
        
        Part filePart = request.getPart("logoFile");
        
        if (filePart == null || filePart.getSize() == 0) {
            out.print("{\"valid\": false, \"error\": \"Không có file được chọn\"}");
            return;
        }
        
        // Kiểm tra file type
        String contentType = filePart.getContentType();
        if (!ALLOWED_IMAGE_TYPES.contains(contentType)) {
            out.print("{\"valid\": false, \"error\": \"Logo phải có định dạng JPG, JPEG, PNG hoặc GIF\"}");
            return;
        }
        
        // Kiểm tra file size
        long fileSize = filePart.getSize();
        if (fileSize > MAX_IMAGE_SIZE) {
            out.print("{\"valid\": false, \"error\": \"Logo quá lớn. Kích thước tối đa là 1MB\"}");
            return;
        }
        
        // Kiểm tra file name
        String fileName = getFileName(filePart);
        if (fileName == null || fileName.trim().isEmpty()) {
            out.print("{\"valid\": false, \"error\": \"Tên file không hợp lệ\"}");
            return;
        }
        
        out.print("{\"valid\": true, \"fileName\": \"" + fileName + "\", \"fileSize\": " + fileSize + "}");
    }
    
    private void validateImagesFiles(HttpServletRequest request, PrintWriter out) 
            throws ServletException, IOException {
        
        List<Part> fileParts = request.getParts().stream()
                .filter(part -> "images".equals(part.getName()))
                .collect(java.util.stream.Collectors.toList());
        
        if (fileParts.isEmpty()) {
            out.print("{\"valid\": false, \"error\": \"Không có file được chọn\"}");
            return;
        }
        
        // Kiểm tra số lượng file
        if (fileParts.size() > MAX_IMAGES_COUNT) {
            out.print("{\"valid\": false, \"error\": \"Chỉ có thể upload tối đa " + MAX_IMAGES_COUNT + " ảnh\"}");
            return;
        }
        
        StringBuilder errors = new StringBuilder();
        int validCount = 0;
        
        for (Part filePart : fileParts) {
            if (filePart.getSize() == 0) continue;
            
            // Kiểm tra file type
            String contentType = filePart.getContentType();
            if (!ALLOWED_IMAGE_TYPES.contains(contentType)) {
                String fileName = getFileName(filePart);
                errors.append("File \"").append(fileName).append("\" không đúng định dạng. ");
                continue;
            }
            
            // Kiểm tra file size
            long fileSize = filePart.getSize();
            if (fileSize > MAX_IMAGE_SIZE) {
                String fileName = getFileName(filePart);
                errors.append("File \"").append(fileName).append("\" quá lớn. ");
                continue;
            }
            
            validCount++;
        }
        
        if (validCount == 0) {
            out.print("{\"valid\": false, \"error\": \"Không có file hợp lệ nào\"}");
            return;
        }
        
        if (errors.length() > 0) {
            out.print("{\"valid\": false, \"error\": \"" + errors.toString() + "\"}");
            return;
        }
        
        out.print("{\"valid\": true, \"validCount\": " + validCount + ", \"totalCount\": " + fileParts.size() + "}");
    }
    
    private void validateRegistrationCertFile(HttpServletRequest request, PrintWriter out) 
            throws ServletException, IOException {
        
        Part filePart = request.getPart("registrationCertFile");
        
        if (filePart == null || filePart.getSize() == 0) {
            out.print("{\"valid\": false, \"error\": \"Không có file được chọn\"}");
            return;
        }
        
        // Kiểm tra file type
        String contentType = filePart.getContentType();
        if (!ALLOWED_DOCUMENT_TYPES.contains(contentType)) {
            out.print("{\"valid\": false, \"error\": \"Chỉ chấp nhận file PDF, JPG, PNG\"}");
            return;
        }
        
        // Kiểm tra file size
        long fileSize = filePart.getSize();
        if (fileSize > MAX_DOCUMENT_SIZE) {
            out.print("{\"valid\": false, \"error\": \"File quá lớn. Kích thước tối đa là 5MB\"}");
            return;
        }
        
        // Kiểm tra file name
        String fileName = getFileName(filePart);
        if (fileName == null || fileName.trim().isEmpty()) {
            out.print("{\"valid\": false, \"error\": \"Tên file không hợp lệ\"}");
            return;
        }
        
        out.print("{\"valid\": true, \"fileName\": \"" + fileName + "\", \"fileSize\": " + fileSize + "}");
    }
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) {
            return null;
        }
        
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
    }
}
