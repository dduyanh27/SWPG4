package controller.recuiter;

import dal.JobPackageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.JobPackage;

@WebServlet(name = "JobPackageServlet", urlPatterns = {"/recruiter/job-packages"})
public class JobPackageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        if (type == null || type.trim().isEmpty()) {
            type = "DANG_TUYEN";
        }
        type = normalizeType(type);

        JobPackageDAO dao = new JobPackageDAO();
        List<JobPackage> packages = dao.listByType(type);
        request.setAttribute("packages", packages);
        request.setAttribute("selectedType", type);

        // Prepare grouped lists for JSP rendering
        List<JobPackage> dangTuyen = dao.listByType("DANG_TUYEN");
        List<JobPackage> timHoSo = dao.listByType("TIM_HO_SO");
        List<JobPackage> aiPremium = dao.listByType("AI_PREMIUM");
        List<JobPackage> supportServices = dao.listByType("DICH_VU_HO_TRO");
        request.setAttribute("dangTuyen", dangTuyen);
        request.setAttribute("timHoSo", timHoSo);
        request.setAttribute("aiPremium", aiPremium);
        request.setAttribute("supportServices", supportServices);

        // Debug logging
        System.out.println("[JobPackageServlet] type= " + type
                + ", selected size=" + (packages == null ? 0 : packages.size())
                + ", DANG_TUYEN=" + dangTuyen.size()
                + ", TIM_HO_SO=" + timHoSo.size()
                + ", DICH_VU_HO_TRO=" + supportServices.size()
                + ", AI_PREMIUM=" + aiPremium.size());

        boolean debug = "1".equals(request.getParameter("debug")) || "true".equalsIgnoreCase(request.getParameter("debug"));
        if (debug) {
            request.setAttribute("debug", true);
            request.setAttribute("debug_selected_type", type);
            request.setAttribute("debug_counts", String.format("selected=%d, DANG_TUYEN=%d, TIM_HO_SO=%d, DICH_VU_HO_TRO=%d, AI_PREMIUM=%d",
                    (packages == null ? 0 : packages.size()), dangTuyen.size(), timHoSo.size(), supportServices.size(), aiPremium.size()));
        }
        request.getRequestDispatcher("/Recruiter/job-package.jsp").forward(request, response);
    }

    private String normalizeType(String input) {
        String t = input.trim().toUpperCase();
        // Remove accents and spaces variants
        if (t.contains("ĐĂNG") || t.contains("DANG") && t.contains("TUY")) {
            return "DANG_TUYEN";
        }
        if (t.contains("TÌM") || (t.contains("TIM") && t.contains("HO"))) {
            return "TIM_HO_SO";
        }
        if (t.contains("DỊCH") || t.contains("DICH")) {
            return "DICH_VU_HO_TRO";
        }
        if (t.contains("AI") && t.contains("PREMIUM")) {
            return "AI_PREMIUM";
        }
        // Fallback to known codes if already provided
        if ("DANG_TUYEN".equals(t) || "TIM_HO_SO".equals(t) || "AI_PREMIUM".equals(t) || "DICH_VU_HO_TRO".equals(t)) {
            return t;
        }
        return "DANG_TUYEN";
    }
}


