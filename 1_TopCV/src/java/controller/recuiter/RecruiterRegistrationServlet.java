package controller.recuiter;

import dal.RecruiterDAO;
import dal.CategoryDAO;
import dal.LocationDAO;
import dal.TypeDAO;
import model.Category;
import model.Location;
import model.Type;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import model.Recruiter;
import util.MD5Util;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.io.File;
import java.util.UUID;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;
import java.util.Iterator;
import java.util.List;

@WebServlet(name = "RecruiterRegistrationServlet", urlPatterns = {"/RecruiterRegistrationServlet"})
@MultipartConfig(maxFileSize = 5242880, maxRequestSize = 5242880) // 5MB max file size
public class RecruiterRegistrationServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads/registration-cert";
    private static final String THUMBNAIL_DIR = "uploads/registration-cert/thumbnails";
    private static final int MAX_WIDTH = 1200;
    private static final int MAX_HEIGHT = 1200;
    private static final int THUMBNAIL_WIDTH = 300;
    private static final int THUMBNAIL_HEIGHT = 300;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("=== RecruiterRegistrationServlet.doGet() CALLED ===");
            System.out.println("Request URL: " + request.getRequestURL());
            System.out.println("Request URI: " + request.getRequestURI());
            System.out.println("Context Path: " + request.getContextPath());
            
            // Load parent categories for the form
            CategoryDAO categoryDAO = new CategoryDAO();
            System.out.println("CategoryDAO created successfully");
            
            List<Category> parentCategories = categoryDAO.getParentCategories();
            System.out.println("getParentCategories() returned: " + (parentCategories != null ? parentCategories.size() : "null") + " categories");
            
            request.setAttribute("parentCategories", parentCategories);
            System.out.println("parentCategories set as request attribute");
            
            // Load locations for the form
            LocationDAO locationDAO = new LocationDAO();
            System.out.println("LocationDAO created successfully");
            
            List<Location> locations = locationDAO.getAllLocations();
            System.out.println("getAllLocations() returned: " + (locations != null ? locations.size() : "null") + " locations");
            
            request.setAttribute("locations", locations);
            System.out.println("locations set as request attribute");
            
            // Load job levels for the form (TypeCategory = 'Level')
            TypeDAO typeDAO = new TypeDAO();
            System.out.println("TypeDAO created successfully");
            
            List<Type> jobLevels = typeDAO.getJobLevels();
            System.out.println("getJobLevels() returned: " + (jobLevels != null ? jobLevels.size() : "null") + " job levels");
            
            request.setAttribute("jobLevels", jobLevels);
            System.out.println("jobLevels set as request attribute");
            
            request.getRequestDispatcher("/Recruiter/registration.jsp").forward(request, response);
            System.out.println("Forwarded to registration.jsp");
        } catch (Exception e) {
            System.err.println("Error in RecruiterRegistrationServlet.doGet(): " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=system_error");
        }
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
            String taxCode = request.getParameter("taxCode");
            String parentCategoryId = request.getParameter("parentCategory");
            String subCategoryId = request.getParameter("subCategory");
            String categoryId = request.getParameter("category");

            // Kiểm tra các trường bắt buộc (trước khi trim)
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                companyName == null || companyName.trim().isEmpty() ||
                address == null || address.trim().isEmpty() ||
                categoryId == null || categoryId.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=missing_fields");
                return;
            }
            
            // Trim tất cả các trường ngay từ đầu
            firstName = firstName.trim();
            lastName = lastName.trim();
            email = email.trim();
            password = password.trim();
            phone = phone.trim();
            companyName = companyName.trim();
            address = address.trim();
            if (taxCode != null) taxCode = taxCode.trim();
            
            // Validate phone format (Vietnamese format) - check for any spaces AFTER trimming
            if (phone.contains(" ")) {
                response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=invalid_phone");
                return;
            }
            
            if (!isValidVietnamesePhone(phone)) {
                response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=invalid_phone");
                return;
            }
            
            // Validate email format (already trimmed above)
            if (!isValidEmail(email)) {
                response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=invalid_email");
                return;
            }
            
            // Validate tax code format only if provided
            if (taxCode != null && !taxCode.isEmpty()) {
                if (!isValidTaxCode(taxCode)) {
                    response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=invalid_tax_code");
                    return;
                }
            }
            
            // Use the selected category ID directly
            int finalCategoryId = Integer.parseInt(categoryId.trim());
            
            // Convert location ID to location name
            LocationDAO locationDAO = new LocationDAO();
            int locationId = Integer.parseInt(address.trim());
            Location location = locationDAO.getLocationById(locationId);
            String locationName = address; // Default to original value if location not found
            if (location != null) {
                locationName = location.getLocationName();
            }

            // Kiểm tra phone đã tồn tại trong tất cả các bảng chưa
            RecruiterDAO recruiterDAO = new RecruiterDAO();
            
            if (recruiterDAO.isPhoneExists(phone)) {
                response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=phone_exists");
                return;
            }
            
            // Kiểm tra email đã tồn tại trong tất cả các bảng chưa
            if (recruiterDAO.isEmailExistsInAllTables(email)) {
                response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=email_exists");
                return;
            }

            // Handle file upload for registration certificate
            String registrationCertPath = null;
            Part filePart = request.getPart("registrationCert");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);
                if (fileName != null && !fileName.isEmpty()) {
                    try {
                        // Process and validate file
                        ProcessedImageResult result = processRegistrationCertificate(filePart, fileName);
                        
                        if (result.isSuccess()) {
                            registrationCertPath = result.getMainImagePath();
                            System.out.println("Successfully processed image: " + result.getMainImagePath());
                            System.out.println("Thumbnail created: " + result.getThumbnailPath());
                        } else {
                            response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=" + result.getErrorMessage());
                            return;
                        }
                    } catch (Exception e) {
                        System.err.println("Error processing file: " + e.getMessage());
                        e.printStackTrace();
                        response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=file_processing_failed");
                        return;
                    }
                }
            }

            // Mã hóa mật khẩu bằng MD5
            String encryptedPassword = MD5Util.getMD5Hash(password);

            // Tạo recruiter mới với status "Pending"
            String fullName = firstName + " " + lastName;
            Recruiter recruiter = recruiterDAO.insertRecruiter(
                email, 
                encryptedPassword, 
                fullName, 
                phone, // Already trimmed phone
                companyName, 
                industry, 
                locationName, // Use location name instead of location ID
                "Active",
                taxCode,
                registrationCertPath,
                finalCategoryId
            );

            if (recruiter != null) {
                // Store recruiter information in session
                request.getSession().setAttribute("recruiter", recruiter);
                request.getSession().setAttribute("userType", "recruiter");
                
                // Redirect to registration page with success message and countdown
                response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?success=registration_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=registration_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Recruiter/registration.jsp?error=system_error");
        }
    }
    
    // Validate Vietnamese phone number format
    private boolean isValidVietnamesePhone(String phone) {
        if (phone == null || phone.isEmpty()) {
            return false;
        }
        
        // Check if phone has exactly 10 digits (no spaces allowed)
        if (phone.length() != 10) {
            return false;
        }
        
        // Check if phone starts with 03, 08, or 09
        if (!phone.startsWith("03") && !phone.startsWith("08") && !phone.startsWith("09")) {
            return false;
        }
        
        // Check if all characters are digits
        return phone.matches("\\d{10}");
    }
    
    // Validate email format
    private boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        // Simple email format validation
        return email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");
    }
    
    // Validate tax code format
    private boolean isValidTaxCode(String taxCode) {
        if (taxCode == null || taxCode.isEmpty()) {
            return false;
        }
        
        // Check if tax code has exactly 10 digits
        if (taxCode.length() != 10) {
            return false;
        }
        
        // Check if all characters are digits
        return taxCode.matches("\\d{10}");
    }
    
    // Helper method to get uploaded file name
    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                if (fileName.contains("\\")) {
                    fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
                }
                return fileName;
            }
        }
        return null;
    }
    
    // Inner class to hold processed image result
    private static class ProcessedImageResult {
        private final boolean success;
        private final String mainImagePath;
        private final String thumbnailPath;
        private final String errorMessage;
        
        public ProcessedImageResult(boolean success, String mainImagePath, String thumbnailPath, String errorMessage) {
            this.success = success;
            this.mainImagePath = mainImagePath;
            this.thumbnailPath = thumbnailPath;
            this.errorMessage = errorMessage;
        }
        
        public boolean isSuccess() { return success; }
        public String getMainImagePath() { return mainImagePath; }
        public String getThumbnailPath() { return thumbnailPath; }
        public String getErrorMessage() { return errorMessage; }
    }
    
    // Main method to process registration certificate
    private ProcessedImageResult processRegistrationCertificate(Part filePart, String fileName) {
        String uploadPath = getServletContext().getRealPath("/") + UPLOAD_DIR;
        String thumbnailPath = getServletContext().getRealPath("/") + THUMBNAIL_DIR;
        
        try {
            // Create directories
            createDirectories(uploadPath, thumbnailPath);
            
            // Generate unique filename
            String fileExtension = getFileExtension(fileName);
            String uniqueId = UUID.randomUUID().toString();
            String processedFileName = "processed_" + uniqueId + ".jpg";
            String thumbnailFileName = "thumb_" + uniqueId + ".jpg";
            
            // Validate file type and get content type
            String contentType = filePart.getContentType();
            if (contentType == null || (!isSupportedImageType(contentType) && !contentType.equals("application/pdf"))) {
                return new ProcessedImageResult(false, null, null, "invalid_file_type");
            }
            
            // Check file size
            long fileSize = filePart.getSize();
            if (fileSize > 5 * 1024 * 1024) { // 5MB limit
                return new ProcessedImageResult(false, null, null, "file_too_large");
            }
            
            // Process based on file type
            if (isSupportedImageType(contentType)) {
                return processImageFile(filePart, uploadPath, thumbnailPath, processedFileName, thumbnailFileName);
            } else if (contentType.equals("application/pdf")) {
                return processPDFFile(filePart, uploadPath, processedFileName);
            }
            
            return new ProcessedImageResult(false, null, null, "unsupported_format");
            
        } catch (Exception e) {
            System.err.println("Error in processRegistrationCertificate: " + e.getMessage());
            e.printStackTrace();
            return new ProcessedImageResult(false, null, null, "processing_error");
        }
    }
    
    // Process image files (JPEG, PNG, etc.)
    private ProcessedImageResult processImageFile(Part filePart, String uploadPath, String thumbnailPath, 
                                                String processedFileName, String thumbnailFileName) {
        try (InputStream inputStream = filePart.getInputStream()) {
            // Read original image
            BufferedImage originalImage = ImageIO.read(inputStream);
            
            if (originalImage == null) {
                return new ProcessedImageResult(false, null, null, "invalid_image");
            }
            
            // Validate image dimensions
            int originalWidth = originalImage.getWidth();
            int originalHeight = originalImage.getHeight();
            
            if (originalWidth < 100 || originalHeight < 100) {
                return new ProcessedImageResult(false, null, null, "image_too_small");
            }
            
            // Create processed main image (resize if needed, optimize quality)
            BufferedImage processedImage = resizeImageIfNeeded(originalImage, MAX_WIDTH, MAX_HEIGHT);
            
            // Create thumbnail
            BufferedImage thumbnail = resizeImageIfNeeded(originalImage, THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT);
            
            // Save processed image
            String mainImagePath = UPLOAD_DIR + "/" + processedFileName;
            String fullMainImagePath = uploadPath + File.separator + processedFileName;
            saveOptimizedImage(processedImage, fullMainImagePath);
            
            // Save thumbnail
            String thumbnailRelPath = THUMBNAIL_DIR + "/" + thumbnailFileName;
            String fullThumbnailPath = thumbnailPath + File.separator + thumbnailFileName;
            saveOptimizedImage(thumbnail, fullThumbnailPath);
            
            return new ProcessedImageResult(true, mainImagePath, thumbnailRelPath, null);
            
        } catch (IOException e) {
            System.err.println("Error processing image: " + e.getMessage());
            return new ProcessedImageResult(false, null, null, "image_processing_failed");
        }
    }
    
    // Process PDF files (simply copy without processing)
    private ProcessedImageResult processPDFFile(Part filePart, String uploadPath, String processedFileName) {
        try (InputStream inputStream = filePart.getInputStream()) {
            String fullPath = uploadPath + File.separator + processedFileName;
            Files.copy(inputStream, Paths.get(fullPath), StandardCopyOption.REPLACE_EXISTING);
            
            String relativePath = UPLOAD_DIR + "/" + processedFileName;
            return new ProcessedImageResult(true, relativePath, null, null);
            
        } catch (IOException e) {
            System.err.println("Error processing PDF: " + e.getMessage());
            return new ProcessedImageResult(false, null, null, "pdf_processing_failed");
        }
    }
    
    // Resize image if needed while maintaining aspect ratio
    private BufferedImage resizeImageIfNeeded(BufferedImage originalImage, int maxWidth, int maxHeight) {
        int originalWidth = originalImage.getWidth();
        int originalHeight = originalImage.getHeight();
        
        // Calculate new dimensions
        int newWidth = originalWidth;
        int newHeight = originalHeight;
        
        if (originalWidth > maxWidth || originalHeight > maxHeight) {
            double widthRatio = (double) maxWidth / originalWidth;
            double heightRatio = (double) maxHeight / originalHeight;
            double ratio = Math.min(widthRatio, heightRatio);
            
            newWidth = (int) (originalWidth * ratio);
            newHeight = (int) (originalHeight * ratio);
        }
        
        // Create resized image
        BufferedImage resizedImage = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = resizedImage.createGraphics();
        
        // High quality rendering hints
        g2d.setRenderingHint(java.awt.RenderingHints.KEY_INTERPOLATION, java.awt.RenderingHints.VALUE_INTERPOLATION_BICUBIC);
        g2d.setRenderingHint(java.awt.RenderingHints.KEY_RENDERING, java.awt.RenderingHints.VALUE_RENDER_QUALITY);
        g2d.setRenderingHint(java.awt.RenderingHints.KEY_ANTIALIASING, java.awt.RenderingHints.VALUE_ANTIALIAS_ON);
        
        g2d.drawImage(originalImage, 0, 0, newWidth, newHeight, null);
        g2d.dispose();
        
        return resizedImage;
    }
    
    // Save image with optimized quality
    private void saveOptimizedImage(BufferedImage image, String filePath) throws IOException {
        Iterator<ImageWriter> writers = ImageIO.getImageWritersByFormatName("jpg");
        ImageWriter writer = writers.next();
        
        javax.imageio.ImageWriteParam param = writer.getDefaultWriteParam();
        if (param.canWriteCompressed()) {
            param.setCompressionMode(javax.imageio.ImageWriteParam.MODE_EXPLICIT);
            param.setCompressionQuality(0.8f); // 80% quality
        }
        
        try (javax.imageio.stream.ImageOutputStream ios = ImageIO.createImageOutputStream(new File(filePath))) {
            writer.setOutput(ios);
            writer.write(null, new javax.imageio.IIOImage(image, null, null), param);
        }
        writer.dispose();
    }
    
    // Create necessary directories
    private void createDirectories(String uploadPath, String thumbnailPath) {
        File uploadDir = new File(uploadPath);
        File thumbnailDir = new File(thumbnailPath);
        
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        if (!thumbnailDir.exists()) {
            thumbnailDir.mkdirs();
        }
    }
    
    // Check if file type is supported image
    private boolean isSupportedImageType(String contentType) {
        return contentType.equals("image/jpeg") || 
               contentType.equals("image/jpg") || 
               contentType.equals("image/png") || 
               contentType.equals("image/gif") ||
               contentType.equals("image/webp");
    }
    
    // Get file extension helper
    private String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > 0 && lastDotIndex < fileName.length() - 1) {
            return fileName.substring(lastDotIndex);
        }
        return ".jpg"; // default
    }
}