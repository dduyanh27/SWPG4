/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.recuiter;

import dal.JobSeekerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.JobSeeker;

/**
 *
 * @author ADMIN
 */
public class CandidateSearchServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CandidateSearchServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CandidateSearchServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== DEBUG CandidateSearchServlet.doGet() ===");
        
        String q = param(request, "q");
        Integer locationId = parseIntOrNull(request.getParameter("locationId"));
        Integer levelId = parseIntOrNull(request.getParameter("levelId"));
        String gender = param(request, "gender");
        Integer minAge = parseIntOrNull(request.getParameter("minAge"));
        Integer maxAge = parseIntOrNull(request.getParameter("maxAge"));
        int page = parseIntOrDefault(request.getParameter("page"), 1);
        int pageSize = parseIntOrDefault(request.getParameter("pageSize"), 10);
        List<Integer> skillIds = parseIntList(request.getParameterValues("skillId"));
        String fullNameLike = param(request, "fullName");
        String addressLike = param(request, "address");
        String levelOrTitleLike = param(request, "title");

        System.out.println("Request parameters:");
        System.out.println("q: " + q);
        System.out.println("locationId: " + locationId);
        System.out.println("levelId: " + levelId);
        System.out.println("gender: " + gender);
        System.out.println("minAge: " + minAge);
        System.out.println("maxAge: " + maxAge);
        System.out.println("page: " + page);
        System.out.println("pageSize: " + pageSize);
        System.out.println("skillIds: " + skillIds);
        System.out.println("fullNameLike: " + fullNameLike);
        System.out.println("addressLike: " + addressLike);
        System.out.println("levelOrTitleLike: " + levelOrTitleLike);

        JobSeekerDAO dao = new JobSeekerDAO();
        System.out.println("Calling countCandidates...");
        int total = dao.countCandidates(q, locationId, levelId, gender, skillIds);
        System.out.println("Count result: " + total);
        
        int totalPages = (int) Math.ceil((double) total / pageSize);
        int offset = Math.max(0, (page - 1) * pageSize);
        System.out.println("totalPages: " + totalPages);
        System.out.println("offset: " + offset);
        
        System.out.println("Calling searchCandidates...");
        List<JobSeeker> candidates = dao.searchCandidates(
                q, locationId, levelId, gender,
                minAge, maxAge, skillIds,
                offset, pageSize,
                fullNameLike, addressLike, levelOrTitleLike
        );
        System.out.println("Search returned " + candidates.size() + " candidates");
        System.out.println("Setting request attributes:");
        System.out.println("candidates size: " + candidates.size());
        System.out.println("total: " + total);
        System.out.println("totalPages: " + totalPages);
        
        request.setAttribute("candidates", candidates);
        request.setAttribute("q", q);
        request.setAttribute("locationId", locationId);
        request.setAttribute("levelId", levelId);
        request.setAttribute("gender", gender);
        request.setAttribute("fullName", fullNameLike);
        request.setAttribute("address", addressLike);
        request.setAttribute("title", levelOrTitleLike);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("total", total);
        request.setAttribute("totalPages", totalPages);

        System.out.println("Forwarding to candidate-search.jsp");
        request.getRequestDispatcher("/Recruiter/candidate-search.jsp").forward(request, response);
    }

    private String param(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        return v == null ? "" : v.trim();
    }

    private Integer parseIntOrNull(String v) {
        try {
            if (v == null || v.trim().isEmpty()) {
                return null;
            }
            return Integer.parseInt(v.trim());
        } catch (NumberFormatException e) {
            return null;
        }
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

    private List<Integer> parseIntList(String[] arr) {
        java.util.ArrayList<Integer> list = new java.util.ArrayList<>();
        if (arr == null) {
            return list;
        }
        for (String s : arr) {
            Integer v = parseIntOrNull(s);
            if (v != null) {
                list.add(v);
            }
        }
        return list;
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}


