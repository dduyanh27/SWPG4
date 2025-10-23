package controller.recuiter;

import dal.JobPackagesDAO;
import model.JobPackages;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "JobPackageServlet", urlPatterns = {"/job-package-api"})
public class JobPackageServlet extends HttpServlet {

    private JobPackagesDAO jobPackagesDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        jobPackagesDAO = new JobPackagesDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        PrintWriter out = response.getWriter();
        
        System.out.println("=== DEBUG: JobPackageServlet.doGet() ===");
        System.out.println("Action: " + action);
        System.out.println("Request URL: " + request.getRequestURL());
        System.out.println("Query String: " + request.getQueryString());
        
        try {
            // Check if DAO is initialized
            if (jobPackagesDAO == null) {
                System.out.println("Initializing JobPackagesDAO...");
                jobPackagesDAO = new JobPackagesDAO();
            }
            
            if ("getPackagesByType".equals(action)) {
                String packageType = request.getParameter("type");
                System.out.println("Requested package type: " + packageType);
                
                if (packageType != null && !packageType.trim().isEmpty()) {
                    List<JobPackages> packages = jobPackagesDAO.getPackagesByType(packageType);
                    System.out.println("Retrieved " + packages.size() + " packages from database");
                    String jsonResponse = convertPackagesToJson(packages);
                    System.out.println("JSON Response length: " + jsonResponse.length());
                    out.print(jsonResponse);
                } else {
                    System.out.println("ERROR: Package type is required");
                    JsonObject error = new JsonObject();
                    error.addProperty("success", false);
                    error.addProperty("message", "Package type is required");
                    out.print(gson.toJson(error));
                }
            } else if ("getAllTypes".equals(action)) {
                System.out.println("Getting all package types...");
                List<String> types = jobPackagesDAO.getAllPackageTypes();
                System.out.println("Found types: " + types);
                JsonObject responseObj = new JsonObject();
                responseObj.addProperty("success", true);
                responseObj.add("types", gson.toJsonTree(types));
                out.print(gson.toJson(responseObj));
            } else if ("getAllPackages".equals(action)) {
                System.out.println("Getting all packages...");
                List<JobPackages> packages = jobPackagesDAO.getAllActivePackages();
                System.out.println("Retrieved " + packages.size() + " packages from database");
                String jsonResponse = convertPackagesToJson(packages);
                out.print(jsonResponse);
            } else {
                System.out.println("ERROR: Invalid action: " + action);
                JsonObject error = new JsonObject();
                error.addProperty("success", false);
                error.addProperty("message", "Invalid action");
                out.print(gson.toJson(error));
            }
        } catch (Exception e) {
            System.out.println("EXCEPTION in JobPackageServlet: " + e.getMessage());
            e.printStackTrace();
            JsonObject error = new JsonObject();
            error.addProperty("success", false);
            error.addProperty("message", "Server error: " + e.getMessage());
            error.addProperty("errorType", e.getClass().getSimpleName());
            out.print(gson.toJson(error));
        }
        
        System.out.println("=== END DEBUG: JobPackageServlet.doGet() ===");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String convertPackagesToJson(List<JobPackages> packages) {
        JsonObject responseObj = new JsonObject();
        responseObj.addProperty("success", true);
        
        // Create a simplified version for JSON serialization
        com.google.gson.JsonArray packagesArray = new com.google.gson.JsonArray();
        for (JobPackages pkg : packages) {
            JsonObject packageJson = new JsonObject();
            packageJson.addProperty("packageID", pkg.getPackageID());
            packageJson.addProperty("packageName", pkg.getPackageName());
            packageJson.addProperty("packageType", pkg.getPackageType());
            packageJson.addProperty("description", pkg.getDescription());
            packageJson.addProperty("price", pkg.getPrice());
            packageJson.addProperty("duration", pkg.getDuration());
            packageJson.addProperty("points", pkg.getPoints());
            packageJson.addProperty("features", pkg.getFeatures());
            packageJson.addProperty("isActive", pkg.isIsActive());
            packageJson.addProperty("createdAt", pkg.getCreatedAt() != null ? pkg.getCreatedAt().toString() : null);
            packageJson.addProperty("updatedAt", pkg.getUpdatedAt() != null ? pkg.getUpdatedAt().toString() : null);
            
            packagesArray.add(packageJson);
        }
        
        responseObj.add("packages", packagesArray);
        return gson.toJson(responseObj);
    }

    private String formatPrice(BigDecimal price) {
        if (price == null) {
            return "0 VND";
        }
        NumberFormat formatter = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
        return formatter.format(price) + " VND";
    }
}
