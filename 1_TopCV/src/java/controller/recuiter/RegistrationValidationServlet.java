package controller.recuiter;

import dal.RecruiterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "RegistrationValidationServlet", urlPatterns = {"/RegistrationValidationServlet"})
@MultipartConfig(maxFileSize = 5242880, maxRequestSize = 5242880) // 5MB
public class RegistrationValidationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("check");
        String value = request.getParameter("value");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        RecruiterDAO recruiterDAO = new RecruiterDAO();
        PrintWriter out = response.getWriter();
        
        
        try {
            
            if ("email".equals(action)) {
                // Kiểm tra email có trùng trong tất cả bảng không
                boolean exists = recruiterDAO.isEmailExistsInAllTables(value);
                out.print("{\"exists\": " + exists + "}");
                
            } else if ("phone".equals(action)) {
                // Kiểm tra số điện thoại có trùng không
                boolean exists = recruiterDAO.isPhoneExists(value);
                out.print("{\"exists\": " + exists + "}");
            } else if ("taxCode".equals(action)) {
                // Validate tax code format only (optional field)
                boolean valid = false;
                if (value != null) {
                    String trimmed = value.trim();
                    valid = trimmed.matches("^[0-9]{10}$");
                }
                out.print("{\"valid\": " + valid + "}");
                
            } else {
                out.print("{\"error\": \"Invalid parameter\"}");
            }
            
        } catch (Exception e) {
            System.err.println("RegistrationValidationServlet error:");
            e.printStackTrace();
            out.print("{\"error\": \"Server error: " + e.getMessage() + "\"}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("check");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            if ("registrationCert".equals(action)) {
                Part filePart = request.getPart("registrationCert");
                if (filePart == null || filePart.getSize() == 0) {
                    out.print("{\"valid\": false, \"error\": \"no_file\"}");
                    return;
                }

                long maxSize = 5L * 1024L * 1024L; // 5MB
                String contentType = filePart.getContentType();
                boolean typeOk = "image/jpeg".equals(contentType) ||
                                 "image/jpg".equals(contentType) ||
                                 "image/png".equals(contentType) ||
                                 "application/pdf".equals(contentType);
                boolean sizeOk = filePart.getSize() <= maxSize;

                boolean valid = typeOk && sizeOk;
                out.print("{\"valid\": " + valid + ", \"typeOk\": " + typeOk + ", \"sizeOk\": " + sizeOk + "}");
            } else {
                out.print("{\"error\": \"Invalid parameter\"}");
            }
        } catch (Exception e) {
            out.print("{\"error\": \"Server error: " + e.getMessage() + "\"}");
        }
    }
}
