/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dal.AdminDAO;
import model.Admin;
import model.Role;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.UUID;


@WebServlet(name = "UploadAvatar", urlPatterns = {"/uploadavatar"})
@MultipartConfig
public class UploadAvatar extends HttpServlet {


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UploadAvatar</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UploadAvatar at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
            return;
        }

        // Xác định user type: Admin hay Staff (Marketing Staff, Sales)
        Role adminRole = (Role) session.getAttribute("adminRole");
        String roleName = (adminRole != null) ? adminRole.getName() : "";
        boolean isAdmin = "Admin".equals(roleName);
        boolean isStaff = "Marketing Staff".equals(roleName) || "Sales".equals(roleName);
        
        // Xác định thư mục lưu file và trang redirect
        String imgFolder = isAdmin ? "admin" : "staff";
        String redirectPage = isAdmin ? "/Admin/admin-profile.jsp" : "/Staff/staff-profile.jsp";
        
        // Xác định staffRole nếu là Staff
        String staffRole = null;
        if (isStaff) {
            staffRole = "Marketing Staff".equals(roleName) ? "marketing" : "sales";
        }

        try {
            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                // Kiểm tra định dạng file
                if (!isValidImageFile(originalFileName)) {
                    request.setAttribute("errorMessage", "Chỉ chấp nhận file ảnh (.jpg, .jpeg, .png, .gif)");
                    if (isStaff && staffRole != null) {
                        redirectPage = "/Staff/staff-profile.jsp?role=" + staffRole;
                    }
                    request.getRequestDispatcher(redirectPage).forward(request, response);
                    return;
                }
                
                // Tạo tên file unique
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                
                // Lưu file vào thư mục build (để server có thể serve)
                String buildPath = getServletContext().getRealPath("/assets/img/" + imgFolder + "/");
                File buildDir = new File(buildPath);
                if (!buildDir.exists()) {
                    buildDir.mkdirs();
                }
                
                // Lưu file vào thư mục web (để không bị mất khi rebuild)
                String webPath = getServletContext().getRealPath("") + File.separator + ".." + File.separator + "web" + File.separator + "assets" + File.separator + "img" + File.separator + imgFolder + File.separator;
                File webDir = new File(webPath);
                if (!webDir.exists()) {
                    webDir.mkdirs();
                }
                
                // Lưu file vào thư mục build
                String buildFilePath = buildPath + File.separator + uniqueFileName;
                filePart.write(buildFilePath);
                
                // Copy file sang thư mục web
                try {
                    java.nio.file.Files.copy(
                        java.nio.file.Paths.get(buildFilePath), 
                        java.nio.file.Paths.get(webPath + uniqueFileName),
                        java.nio.file.StandardCopyOption.REPLACE_EXISTING
                    );
                    System.out.println("File đã được lưu vào build: " + buildFilePath);
                    System.out.println("File đã được copy sang web: " + webPath + uniqueFileName);
                } catch (Exception e) {
                    System.out.println("Không thể copy file sang thư mục web: " + e.getMessage());
                }

                // Cập nhật DB
                AdminDAO dao = new AdminDAO();
                dao.updateAvatar(admin.getAdminId(), uniqueFileName);
                
                // Cập nhật session
                admin.setAvatarUrl(uniqueFileName);
                session.setAttribute("admin", admin);
                request.setAttribute("successMessage", "Cập nhật avatar thành công!");
            } else {
                request.setAttribute("errorMessage", "Vui lòng chọn file ảnh để tải lên");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }

        // Redirect về đúng trang với role parameter nếu là Staff
        if (isStaff && staffRole != null) {
            redirectPage = "/Staff/staff-profile.jsp?role=" + staffRole;
        }
        request.getRequestDispatcher(redirectPage).forward(request, response);
    }
    
    /**
     * Kiểm tra định dạng file ảnh có hợp lệ không
     */
    private boolean isValidImageFile(String fileName) {
        String lowerFileName = fileName.toLowerCase();
        return lowerFileName.endsWith(".jpg") || 
               lowerFileName.endsWith(".jpeg") || 
               lowerFileName.endsWith(".png") || 
               lowerFileName.endsWith(".gif");
    }


@Override
public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
