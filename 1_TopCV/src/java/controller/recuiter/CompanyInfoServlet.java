package controller.recruiter;

import dal.RecruiterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Recruiter;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CompanyInfoServlet", urlPatterns = {"/CompanyInfoServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class CompanyInfoServlet extends HttpServlet {

    private static final int MAX_IMAGES = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Recruiter recruiter = (Recruiter) session.getAttribute("user");

        if (recruiter == null) {
            response.sendRedirect(request.getContextPath() + "/Recruiter/recruiter-login.jsp");
            return;
        }

        RecruiterDAO recruiterDAO = new RecruiterDAO();
        Recruiter fullRecruiter = recruiterDAO.getRecruiterById(recruiter.getRecruiterID());

        if (fullRecruiter != null) {
            // Clean company images if there are logo paths mixed in
            String cleanedImages = cleanCompanyImages(fullRecruiter.getImg());
            if (cleanedImages != null && !cleanedImages.equals(fullRecruiter.getImg())) {
                fullRecruiter.setImg(cleanedImages);
                // update via DAO: use updateCompanyInfo(Recruiter)
                fullRecruiter.setCompanyLogoURL(fullRecruiter.getCompanyLogoURL()); // keep existing
                recruiterDAO.updateCompanyInfo(fullRecruiter);
            }
            request.setAttribute("recruiter", fullRecruiter);
        }

        request.getRequestDispatcher("/Recruiter/company-info.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Recruiter sessionRecruiter = (Recruiter) session.getAttribute("user");
        if (sessionRecruiter == null) {
            response.sendRedirect(request.getContextPath() + "/Recruiter/recruiter-login.jsp");
            return;
        }

        try {
            // form params
            String companyName = request.getParameter("companyName");
            String phone = request.getParameter("phone");
            String companyAddress = request.getParameter("companyAddress");
            String companySize = request.getParameter("companySize");
            String contactPerson = request.getParameter("contactPerson");
            String companyBenefits = request.getParameter("companyBenefits");
            String companyDescription = request.getParameter("companyDescription");
            String companyVideoURL = request.getParameter("companyVideoURL");
            String website = request.getParameter("website");

            String removedLogo = request.getParameter("removedLogo");       // expected "true" or null
            String removedImages = request.getParameter("removedImages");   // expected comma-separated full paths

            int recruiterId = sessionRecruiter.getRecruiterID();

            // handle uploads
            String newLogoPath = handleLogoUpload(request, recruiterId);
            String newImagesCsv = handleCompanyImagesUpload(request, recruiterId);

            // fetch fresh recruiter from DB
            RecruiterDAO recruiterDAO = new RecruiterDAO();
            Recruiter current = recruiterDAO.getRecruiterById(recruiterId);
            if (current == null) {
                response.sendRedirect(request.getContextPath() + "/CompanyInfoServlet?error=not_found");
                return;
            }

            // decide final logo
            String finalLogoPath;
            if (newLogoPath != null) {
                // new uploaded logo -> delete old logo file (if exists) and use new
                deleteFileIfExists(current.getCompanyLogoURL());
                finalLogoPath = newLogoPath;
            } else if ("true".equals(removedLogo)) {
                // removed logo
                deleteFileIfExists(current.getCompanyLogoURL());
                finalLogoPath = null;
            } else {
                finalLogoPath = current.getCompanyLogoURL(); // keep existing
            }

            // decide final images list (CSV of paths)
            String finalImages;
            // start from existing images (could be null)
            String existingImages = current.getImg();
            // remove images marked for deletion
            if (removedImages != null && !removedImages.trim().isEmpty()) {
                existingImages = removeImagesFromExisting(existingImages, removedImages);
                // also delete files physically
                String[] rem = removedImages.split(",");
                for (String p : rem) {
                    deleteFileIfExists(p.trim());
                }
            }
            // merge new images if any
            if (newImagesCsv != null && !newImagesCsv.isEmpty()) {
                List<String> merged = new ArrayList<>();
                if (existingImages != null && !existingImages.isEmpty()) {
                    for (String s : existingImages.split(",")) {
                        if (!s.trim().isEmpty()) merged.add(s.trim());
                    }
                }
                for (String s : newImagesCsv.split(",")) {
                    if (!s.trim().isEmpty()) merged.add(s.trim());
                }
                // limit to MAX_IMAGES
                if (merged.size() > MAX_IMAGES) merged = merged.subList(0, MAX_IMAGES);
                finalImages = String.join(",", merged);
            } else {
                finalImages = existingImages;
            }

            // final length check
            if (finalImages != null && finalImages.length() > 1000) {
                // defensive truncate keeping first MAX_IMAGES
                String[] arr = finalImages.split(",");
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < arr.length && i < MAX_IMAGES; i++) {
                    if (sb.length() > 0) sb.append(",");
                    sb.append(arr[i].trim());
                }
                finalImages = sb.toString();
            }

            // build Recruiter object to update (use current to keep other fields)
            Recruiter updated = current;
            updated.setCompanyName(companyName);
            updated.setPhone(phone);
            updated.setCompanyAddress(companyAddress);
            updated.setCompanySize(companySize);
            updated.setContactPerson(contactPerson);
            updated.setCompanyBenefits(companyBenefits);
            updated.setCompanyDescription(companyDescription);
            updated.setCompanyVideoURL(companyVideoURL);
            updated.setWebsite(website);
            updated.setCompanyLogoURL(finalLogoPath);
            updated.setImg(finalImages);

            boolean success = recruiterDAO.updateCompanyInfo(updated);

            if (success) {
                // refresh session user
                Recruiter refreshed = recruiterDAO.getRecruiterById(recruiterId);
                if (refreshed != null) session.setAttribute("user", refreshed);
                response.sendRedirect(request.getContextPath() + "/CompanyInfoServlet?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/CompanyInfoServlet?error=update_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/CompanyInfoServlet?error=system_error");
        }
    }

    // Save single logo part, return relative path like "/uploads/logos/..."
    private String handleLogoUpload(HttpServletRequest request, int recruiterId) throws IOException, ServletException {
        Part logoPart = request.getPart("companyLogo");
        if (logoPart == null || logoPart.getSize() == 0) return null;

        String fileName = getFileName(logoPart);
        if (fileName == null || fileName.isEmpty()) return null;

        String uploadDir = getServletContext().getRealPath("/uploads/logos");
        File uploadDirFile = new File(uploadDir);
        if (!uploadDirFile.exists()) uploadDirFile.mkdirs();

        String ext = fileName.contains(".") ? fileName.substring(fileName.lastIndexOf(".")) : "";
        String unique = "l" + recruiterId + "_" + System.currentTimeMillis() + ext;
        File out = new File(uploadDirFile, unique);

        try (InputStream in = logoPart.getInputStream()) {
            Files.copy(in, out.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        return "/uploads/logos/" + unique;
    }

    // Save multiple images, return CSV of relative paths or null
    private String handleCompanyImagesUpload(HttpServletRequest request, int recruiterId) throws IOException, ServletException {
        List<String> saved = new ArrayList<>();
        int count = 0;
        for (Part part : request.getParts()) {
            if (!"companyImages".equals(part.getName())) continue;
            if (part.getSize() == 0) continue;
            if (count >= MAX_IMAGES) break;

            String fileName = getFileName(part);
            if (fileName == null || fileName.isEmpty()) continue;

            String uploadDir = getServletContext().getRealPath("/uploads/company-images");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) uploadDirFile.mkdirs();

            String ext = fileName.contains(".") ? fileName.substring(fileName.lastIndexOf(".")) : "";
            String unique = "c" + recruiterId + "_" + System.currentTimeMillis() + "_" + (count + 1) + ext;
            File out = new File(uploadDirFile, unique);
            try (InputStream in = part.getInputStream()) {
                Files.copy(in, out.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            saved.add("/uploads/company-images/" + unique);
            count++;
        }
        return saved.isEmpty() ? null : String.join(",", saved);
    }

    // robust filename extraction (handles IE full path)
    private String getFileName(Part part) {
        String cd = part.getHeader("content-disposition");
        if (cd == null) return null;
        for (String token : cd.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                // IE may send full path, keep only filename
                int idx = Math.max(name.lastIndexOf('/'), name.lastIndexOf('\\'));
                if (idx >= 0) name = name.substring(idx + 1);
                return name;
            }
        }
        return null;
    }

    // delete a file on disk given a relative path like "/uploads/..."
    private void deleteFileIfExists(String relativePath) {
        if (relativePath == null || relativePath.trim().isEmpty()) return;
        try {
            String real = getServletContext().getRealPath(relativePath.trim());
            if (real == null) return;
            File f = new File(real);
            if (f.exists()) f.delete();
        } catch (Exception ignored) {
        }
    }

    // remove images listed in removedCsv from existingCsv (both CSV of relative paths)
    private String removeImagesFromExisting(String existingCsv, String removedCsv) {
        if (existingCsv == null || existingCsv.trim().isEmpty()) return null;
        if (removedCsv == null || removedCsv.trim().isEmpty()) return existingCsv;

        String[] existing = existingCsv.split(",");
        String[] removed = removedCsv.split(",");

        List<String> keep = new ArrayList<>();
        outer:
        for (String e : existing) {
            String te = e.trim();
            if (te.isEmpty()) continue;
            for (String r : removed) {
                if (te.equals(r.trim())) {
                    continue outer; // skip this existing
                }
            }
            keep.add(te);
        }
        return keep.isEmpty() ? null : String.join(",", keep);
    }

    // remove any paths that contain "/logos/" from the images CSV
    private String cleanCompanyImages(String companyImages) {
        if (companyImages == null || companyImages.trim().isEmpty()) return null;
        String[] arr = companyImages.split(",");
        List<String> keep = new ArrayList<>();
        for (String s : arr) {
            String t = s.trim();
            if (t.isEmpty()) continue;
            if (t.contains("/logos/")) continue; // drop logos from images
            keep.add(t);
        }
        return keep.isEmpty() ? null : String.join(",", keep);
    }
}
