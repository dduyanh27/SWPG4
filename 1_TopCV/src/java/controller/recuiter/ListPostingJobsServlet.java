/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.recuiter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.List;
import dal.JobDAO;
import dal.JobFeatureMappingsDAO;
import dal.RecruiterPackagesDAO;
import dal.JobPackagesDAO;
import dal.ApplicationDAO;
import model.JobPackages;
import model.Job;
import model.Recruiter;
import java.util.Map;
import java.util.HashMap;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ListPostingJobsServlet", urlPatterns = {"/listpostingjobs", "/listpostingjobsservlet"})
public class ListPostingJobsServlet extends HttpServlet {

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
            out.println("<title>Servlet ListPostingJobsServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ListPostingJobsServlet at " + request.getContextPath() + "</h1>");
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
         HttpSession session = request.getSession(false);
         Recruiter recruiter = session != null ? (Recruiter) session.getAttribute("recruiter") : null;

         String tab = request.getParameter("tab");
         if (tab == null || tab.isEmpty()) {
             tab = "active"; // default tab
         }
         String q = request.getParameter("q");
         if (q != null) q = q.trim();
         String qEncoded = null;
         String pkg = request.getParameter("pkg"); // package name filter (e.g., "Gói Vàng")
         if (pkg != null) pkg = pkg.trim();
         String pkgEnc = null;
         try {
             if (pkg != null && !pkg.isEmpty()) {
                 pkgEnc = java.net.URLEncoder.encode(pkg, java.nio.charset.StandardCharsets.UTF_8.name());
             }
         } catch (Exception ignore) {}
         try {
             if (q != null && !q.isEmpty()) {
                 qEncoded = java.net.URLEncoder.encode(q, java.nio.charset.StandardCharsets.UTF_8.name());
             }
         } catch (Exception ignore) {}
         System.out.println("[ListPostingJobsServlet] tab=" + tab);
         System.out.println("[ListPostingJobsServlet] recruiter=" + (recruiter != null ? recruiter.getRecruiterID() : "null"));

         int page = parseIntOrDefault(request.getParameter("page"), 1);
         int pageSize = parseIntOrDefault(request.getParameter("pageSize"), 5);

         List<Job> active = Collections.emptyList();
         List<Job> expired = Collections.emptyList();
         List<Job> draft = Collections.emptyList();
         List<Job> pending = Collections.emptyList();
         List<Job> currentList = Collections.emptyList();

         if (recruiter != null) {
             JobDAO jobDAO = new JobDAO();
             active = jobDAO.getActiveNotExpiredByRecruiterId(recruiter.getRecruiterID());
             expired = jobDAO.getExpiredActiveByRecruiterId(recruiter.getRecruiterID());
             draft = jobDAO.getDraftJobsByRecruiterId(recruiter.getRecruiterID());
             pending = jobDAO.getPendingJobsByRecruiterId(recruiter.getRecruiterID());

             // Load posting package names for dropdown (type DANG_TUYEN)
             JobPackagesDAO jobPackagesDAO = new JobPackagesDAO();
             java.util.List<JobPackages> postingPkgs = jobPackagesDAO.getPackagesByType("dang-tuyen");
             java.util.List<String> pkgNames = new java.util.ArrayList<>();
             for (JobPackages p : postingPkgs) {
                 if (p != null && p.getPackageName() != null && !pkgNames.contains(p.getPackageName())) {
                     pkgNames.add(p.getPackageName());
                 }
             }
             request.setAttribute("pkgNames", pkgNames);

             // Filter by keyword (job title or job code contains)
             if (q != null && !q.isEmpty()) {
                 String qLower = q.toLowerCase();
                 java.util.function.Predicate<Job> pred = j -> {
                     if (j == null) return false;
                     String t = j.getJobTitle() != null ? j.getJobTitle().toLowerCase() : "";
                     String code = j.getJobCode() != null ? j.getJobCode().toLowerCase() : "";
                     return t.contains(qLower) || code.contains(qLower);
                 };
                 active = active.stream().filter(pred).toList();
                 expired = expired.stream().filter(pred).toList();
                 draft = draft.stream().filter(pred).toList();
                 pending = pending.stream().filter(pred).toList();
             }

              // Filter by package name -> resolve PackageID -> all RecruiterPackageIDs -> JobIDs using those RPIDs
              if (pkg != null && !pkg.isEmpty() && !"all".equalsIgnoreCase(pkg)) {
                  JobPackagesDAO jpDAO = new JobPackagesDAO();
                  int pkgId = jpDAO.getPackageIdByName(pkg);
                  if (pkgId > 0) {
                      RecruiterPackagesDAO rpDAO = new RecruiterPackagesDAO();
                      java.util.List<model.RecruiterPackages> rpAll = rpDAO.getRecruiterPackagesByRecruiterId(recruiter.getRecruiterID());
                      java.util.Set<Integer> allowedRpIds = new java.util.HashSet<>();
                      for (model.RecruiterPackages rp : rpAll) {
                          if (rp != null && rp.getPackageID() == pkgId) allowedRpIds.add(rp.getRecruiterPackageID());
                      }
                      if (!allowedRpIds.isEmpty()) {
                          JobFeatureMappingsDAO mappingDAO = new JobFeatureMappingsDAO();
                          java.util.Set<Integer> allowedJobIds = new java.util.HashSet<>();
                          for (Integer rpid : allowedRpIds) {
                              java.util.List<Integer> jids = mappingDAO.getJobIdsByRecruiterPackageId(rpid);
                              if (jids != null) allowedJobIds.addAll(jids);
                          }
                          java.util.function.Predicate<Job> byJobId = j -> allowedJobIds.contains(j.getJobID());
                          active = active.stream().filter(byJobId).toList();
                          expired = expired.stream().filter(byJobId).toList();
                          draft = draft.stream().filter(byJobId).toList();
                          pending = pending.stream().filter(byJobId).toList();
                      } else {
                          active = java.util.Collections.emptyList();
                          expired = java.util.Collections.emptyList();
                          draft = java.util.Collections.emptyList();
                          pending = java.util.Collections.emptyList();
                      }
                  } else {
                      // No matched package name -> empty
                      active = java.util.Collections.emptyList();
                      expired = java.util.Collections.emptyList();
                      draft = java.util.Collections.emptyList();
                      pending = java.util.Collections.emptyList();
                  }
              }

             switch (tab) {
                 case "expired":
                     currentList = expired;
                     break;
                 case "draft":
                     currentList = draft;
                     break;
                 case "pending":
                     currentList = pending;
                     break;
                 case "active":
                 default:
                     currentList = active;
                     break;
             }

             // For counts and existing JSP usage
             request.setAttribute("activeJobs", active);
             request.setAttribute("expiredJobs", expired);
             request.setAttribute("draftJobs", draft);
             request.setAttribute("pendingJobs", pending);
         }

         int total = currentList.size();
         int totalPages = (int) Math.ceil((double) total / pageSize);
         if (totalPages == 0) totalPages = 1;
         if (page < 1) page = 1;
         if (page > totalPages) page = totalPages;
         int from = Math.max(0, (page - 1) * pageSize);
         int to = Math.min(total, from + pageSize);
         List<Job> paged = from < to ? currentList.subList(from, to) : Collections.emptyList();

         // Get application counts for each job
         ApplicationDAO applicationDAO = new ApplicationDAO();
         Map<Integer, Integer> applicationCounts = new HashMap<>();
         for (Job job : paged) {
             int count = applicationDAO.getApplicationCountByJobId(job.getJobID());
             applicationCounts.put(job.getJobID(), count);
         }

         request.setAttribute("selectedTab", tab);
         // Cung cấp đúng một danh sách đã phân trang cho JSP, giống purchase-history
         request.setAttribute("jobs", paged);
         request.setAttribute("applicationCounts", applicationCounts);
         request.setAttribute("page", page);
         request.setAttribute("pageSize", pageSize);
         request.setAttribute("total", total);
         request.setAttribute("totalPages", totalPages);
         request.setAttribute("q", q);
         request.setAttribute("qEncoded", qEncoded);
         request.setAttribute("pkg", pkg);
         request.getRequestDispatcher("Recruiter/job-management.jsp").forward(request, response);
    }

    private int parseIntOrDefault(String v, int def) {
        try {
            if (v == null || v.trim().isEmpty()) return def;
            return Integer.parseInt(v.trim());
        } catch (NumberFormatException e) {
            return def;
        }
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
