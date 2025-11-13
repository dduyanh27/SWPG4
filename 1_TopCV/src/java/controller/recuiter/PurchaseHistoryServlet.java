package controller.recuiter;

import dal.RecruiterPackagesDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Recruiter;

@WebServlet(name = "PurchaseHistoryServlet", urlPatterns = {"/recruiter/purchase-history"})
public class PurchaseHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Recruiter recruiter = (Recruiter) request.getSession().getAttribute("recruiter");
        if (recruiter == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        int page = parseIntOrDefault(request.getParameter("page"), 1);
        int pageSize = parseIntOrDefault(request.getParameter("pageSize"), 5);
        String q = request.getParameter("q");
        String qNorm = q == null ? null : q.trim().toLowerCase();
        RecruiterPackagesDAO dao = new RecruiterPackagesDAO();
        List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> history =
                dao.getPurchaseHistoryWithDetails(recruiter.getRecruiterID());
        if (qNorm != null && !qNorm.isEmpty()) {
            history = history.stream().filter(it -> {
                try {
                    String idStr = "#" + it.recruiterPackageID;
                    String name = it.packageName != null ? it.packageName.toLowerCase() : "";
                    String type = it.packageType != null ? it.packageType.toLowerCase() : "";
                    String status = (it.expiryDate != null && it.expiryDate.isBefore(java.time.LocalDateTime.now())) ? "da het han" : "con han";
                    return idStr.toLowerCase().contains(qNorm)
                            || name.contains(qNorm)
                            || type.contains(qNorm)
                            || status.contains(qNorm);
                } catch (Exception e) {
                    return false;
                }
            }).toList();
        }
        int total = history.size();
        
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;
        int offset = Math.max(0, (page - 1) * pageSize);
        int end = Math.min(total, offset + pageSize);
        List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> pageItems =
                offset < end ? history.subList(offset, end) : java.util.Collections.emptyList();
        
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("q", q);
        request.setAttribute("total", total);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("purchaseHistory", pageItems);
        request.getRequestDispatcher("/Recruiter/purchase-history.jsp").forward(request, response);
    }
    
    private int parseIntOrDefault(String v, int def) {
        try {
            if (v == null || v.trim().isEmpty()) {
                return def;
            }
            return Integer.parseInt(v.trim());
        } catch (NumberFormatException e) {
            return def;
        }
    }
}


