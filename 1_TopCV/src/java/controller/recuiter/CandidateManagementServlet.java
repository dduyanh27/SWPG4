package controller.recuiter;

import dal.ApplicationDAO;
import dal.JobDAO;
import dal.RecruiterDAO;
import dal.NotificationDAO;
import model.CandidateApplication;
import model.Job;
import model.Recruiter;
import util.CandidateEmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CandidateManagementServlet", urlPatterns = {"/candidate-management"})
public class CandidateManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("==========================================");
        System.out.println("DEBUG CandidateManagementServlet: doGet() called");
        System.out.println("==========================================");

        try {
            // Lấy recruiter từ session
            Recruiter recruiter = (Recruiter) request.getSession().getAttribute("recruiter");
            if (recruiter == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Lấy jobID từ parameter (nếu có)
            String jobIDStr = request.getParameter("jobID");
            int jobID = 0;

            if (jobIDStr != null && !jobIDStr.isEmpty()) {
                try {
                    jobID = Integer.parseInt(jobIDStr);
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG CandidateManagementServlet: Invalid jobID: " + jobIDStr);
                }
            }

            // Lấy danh sách tất cả jobs có status = 'Published' của recruiter
            JobDAO jobDAO = new JobDAO();
            List<Job> allJobs = jobDAO.getPublishedJobsByRecruiterId(recruiter.getRecruiterID());

            // Nếu không có jobID, lấy job đầu tiên published của recruiter
            if (jobID == 0) {
                if (allJobs != null && !allJobs.isEmpty()) {
                    jobID = allJobs.get(0).getJobID();
                    System.out.println("DEBUG CandidateManagementServlet: Using first published job - JobID: " + jobID);
                } else {
                    request.setAttribute("error", "Bạn chưa có tin tuyển dụng Published nào!");
                    request.setAttribute("allJobs", new java.util.ArrayList<>());
                    request.setAttribute("candidates", new java.util.ArrayList<>());
                    request.getRequestDispatcher("/Recruiter/candidate-management.jsp").forward(request, response);
                    return;
                }
            }

            request.setAttribute("allJobs", allJobs);

            System.out.println("DEBUG CandidateManagementServlet: Found " + allJobs.size() + " published jobs for recruiter: " + recruiter.getRecruiterID());

            // Lấy thông tin job được chọn
            Job job = jobDAO.getJobById(jobID);

            if (job == null || job.getRecruiterID() != recruiter.getRecruiterID()) {
                request.setAttribute("error", "Không tìm thấy tin tuyển dụng hoặc bạn không có quyền!");
                request.setAttribute("candidates", new java.util.ArrayList<>());
                request.getRequestDispatcher("/Recruiter/candidate-management.jsp").forward(request, response);
                return;
            }

            // Kiểm tra job có status = 'Published' không
            String jobStatus = job.getStatus();
            if (!"Published".equals(jobStatus)) {
                System.out.println("DEBUG CandidateManagementServlet: Job has status: '" + jobStatus + "', expected: 'Published'");
                request.setAttribute("error", "Job này không ở trạng thái Published! Status hiện tại: " + jobStatus);
                request.setAttribute("candidates", new java.util.ArrayList<>());
                request.getRequestDispatcher("/Recruiter/candidate-management.jsp").forward(request, response);
                return;
            }

            request.setAttribute("job", job);

            // Lấy danh sách applications cho job này
            ApplicationDAO applicationDAO = new ApplicationDAO();
            List<CandidateApplication> candidates = applicationDAO.getApplicationsByJobID(jobID, recruiter.getRecruiterID());

            // Lọc theo từ khóa q (giống purchase-history): theo tên ứng viên hoặc tiêu đề CV, không phân biệt hoa thường
            String q = request.getParameter("q");
            List<CandidateApplication> filtered = candidates;
            if (q != null && !q.trim().isEmpty()) {
                String qLower = q.toLowerCase();
                java.util.ArrayList<CandidateApplication> tmp = new java.util.ArrayList<>();
                for (CandidateApplication c : candidates) {
                    String name = c.getCandidateName() != null ? c.getCandidateName().toLowerCase() : "";
                    String cvTitle = c.getCvTitle() != null ? c.getCvTitle().toLowerCase() : "";
                    if (name.contains(qLower) || cvTitle.contains(qLower)) {
                        tmp.add(c);
                    }
                }
                filtered = tmp;
            }

            int page = parseIntOrDefault(request.getParameter("page"), 1);
            int pageSize = parseIntOrDefault(request.getParameter("pageSize"), 10);
            int total = filtered.size();
            int totalPages = (int) Math.ceil((double) total / pageSize);
            if (totalPages == 0) totalPages = 1;
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;
            int from = Math.max(0, (page - 1) * pageSize);
            int to = Math.min(total, from + pageSize);
            List<CandidateApplication> pageItems = from < to ? filtered.subList(from, to) : java.util.Collections.emptyList();

            request.setAttribute("candidates", pageItems);
            request.setAttribute("jobID", jobID);
            request.setAttribute("page", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("total", total);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("q", q);

            // Tính số lượng đã duyệt
            long approvedCount = candidates.stream()
                    .filter(c -> "Accepted".equals(c.getStatus()) || "Chấp nhận".equals(c.getStatus()))
                    .count();

            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("totalCount", candidates.size());

            System.out.println("DEBUG CandidateManagementServlet: Found " + candidates.size() + " candidates for JobID: " + jobID
                    + (q != null && !q.trim().isEmpty() ? (", filtered: " + total + " by q='" + q + "'") : ""));

        } catch (Exception e) {
            System.out.println("DEBUG CandidateManagementServlet: Exception in doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.setAttribute("candidates", new java.util.ArrayList<>());
        }

        request.getRequestDispatcher("/Recruiter/candidate-management.jsp").forward(request, response);
    }

    private int parseIntOrDefault(String v, int def) {
        try {
            if (v == null || v.trim().isEmpty()) return def;
            return Integer.parseInt(v.trim());
        } catch (NumberFormatException e) {
            return def;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("==========================================");
        System.out.println("DEBUG CandidateManagementServlet: doPost() called - Processing accept/reject");
        System.out.println("==========================================");

        try {
            // Lấy recruiter từ session
            Recruiter recruiter = (Recruiter) request.getSession().getAttribute("recruiter");
            if (recruiter == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String action = request.getParameter("action"); // "accept" hoặc "reject"
            String applicationIDStr = request.getParameter("applicationID");
            String jobIDStr = request.getParameter("jobID");

            System.out.println("DEBUG CandidateManagementServlet: POST - action: '" + action + "', applicationID: '" + applicationIDStr + "', jobID: '" + jobIDStr + "'");

            if (action == null || applicationIDStr == null || jobIDStr == null || 
                applicationIDStr.trim().isEmpty() || jobIDStr.trim().isEmpty()) {
                System.out.println("DEBUG CandidateManagementServlet: Missing or empty required parameters!");
                request.setAttribute("error", "Thiếu thông tin cần thiết!");
                doGet(request, response);
                return;
            }

            int applicationID;
            int jobID;
            try {
                applicationID = Integer.parseInt(applicationIDStr.trim());
                jobID = Integer.parseInt(jobIDStr.trim());
                System.out.println("DEBUG CandidateManagementServlet: Parsed applicationID: " + applicationID + ", jobID: " + jobID);
            } catch (NumberFormatException e) {
                System.out.println("DEBUG CandidateManagementServlet: NumberFormatException - applicationID: '" + applicationIDStr + "', jobID: '" + jobIDStr + "'");
                System.out.println("DEBUG CandidateManagementServlet: Exception: " + e.getMessage());
                request.setAttribute("error", "Thông tin không hợp lệ!");
                doGet(request, response);
                return;
            }

            // Xác định status mới
            String newStatus;
            if ("accept".equalsIgnoreCase(action)) {
                newStatus = "Accepted";
                System.out.println("DEBUG CandidateManagementServlet: Action = accept, setting status to: 'Accepted'");
            } else if ("reject".equalsIgnoreCase(action)) {
                newStatus = "Rejected";
                System.out.println("DEBUG CandidateManagementServlet: Action = reject, setting status to: 'Rejected'");
            } else {
                System.out.println("DEBUG CandidateManagementServlet: Invalid action: " + action);
                request.setAttribute("error", "Hành động không hợp lệ!");
                doGet(request, response);
                return;
            }

            System.out.println("DEBUG CandidateManagementServlet: Updating ApplicationID: " + applicationID
                    + ", JobID: " + jobID
                    + ", RecruiterID: " + recruiter.getRecruiterID()
                    + ", New Status: " + newStatus);

            // Lấy thông tin candidate TRƯỚC KHI update để gửi email
            ApplicationDAO applicationDAO = new ApplicationDAO();
            List<CandidateApplication> allCandidates = applicationDAO.getApplicationsByJobID(jobID, recruiter.getRecruiterID());
            CandidateApplication candidate = null;
            for (CandidateApplication c : allCandidates) {
                if (c.getApplicationID() == applicationID) {
                    candidate = c;
                    break;
                }
            }

            // Cập nhật status
            boolean success = applicationDAO.updateApplicationStatus(applicationID, jobID, recruiter.getRecruiterID(), newStatus);

            if (success) {
                System.out.println("DEBUG CandidateManagementServlet: Successfully updated application " + applicationID
                        + " status to '" + newStatus + "'");

                // Gửi email cho candidate
                if (candidate != null && candidate.getCandidateEmail() != null && !candidate.getCandidateEmail().isEmpty()) {
                    CandidateEmailService emailService = new CandidateEmailService();

                    // Lấy thông tin công ty
                    RecruiterDAO recruiterDAO = new RecruiterDAO();
                    Recruiter companyRecruiter = recruiterDAO.getRecruiterById(recruiter.getRecruiterID());
                    String companyName = (companyRecruiter != null && companyRecruiter.getCompanyName() != null)
                            ? companyRecruiter.getCompanyName()
                            : "Công Ty";
                    String recruiterPhone = (companyRecruiter != null && companyRecruiter.getPhone() != null)
                            ? companyRecruiter.getPhone()
                            : "";
                    String companyAddress = (companyRecruiter != null && companyRecruiter.getCompanyAddress() != null)
                            ? companyRecruiter.getCompanyAddress()
                            : "";

                    // Lấy thông tin job
                    JobDAO jobDAO = new JobDAO();
                    Job job = jobDAO.getJobById(jobID);
                    String jobTitle = (job != null && job.getJobTitle() != null) ? job.getJobTitle() : "Vị trí ứng tuyển";

                    boolean emailSent = false;
                    if ("accept".equalsIgnoreCase(action)) {
                        // Gửi email chấp nhận
                        emailSent = emailService.sendAcceptanceEmail(
                                candidate.getCandidateEmail(),
                                candidate.getCandidateName(),
                                jobTitle,
                                companyName,
                                recruiterPhone,
                                companyAddress
                        );
                        
                        // Gửi notification cho JobSeeker
                        NotificationDAO.sendNotification(
                                candidate.getJobSeekerID(), // ID của JobSeeker
                                "jobseeker", // Loại user nhận thông báo
                                "application", // Loại thông báo
                                "Chúc mừng! Đơn ứng tuyển được chấp nhận", // Tiêu đề
                                "Đơn ứng tuyển của bạn cho vị trí \"" + jobTitle + "\" tại " + companyName + " đã được chấp nhận. Nhà tuyển dụng sẽ liên hệ với bạn sớm.", // Nội dung
                                applicationID, // ID đơn ứng tuyển
                                "application", // Loại related item
                                request.getContextPath() + "/JobSeeker/applied-jobs.jsp", // URL khi click vào thông báo
                                2 // Priority: 2 = High (quan trọng)
                        );
                        
                        System.out.println("DEBUG CandidateManagementServlet: Acceptance email sent: " + emailSent + ", notification sent for JobSeekerID: " + candidate.getJobSeekerID());
                    } else if ("reject".equalsIgnoreCase(action)) {
                        // Gửi email từ chối
                        emailSent = emailService.sendRejectionEmail(
                                candidate.getCandidateEmail(),
                                candidate.getCandidateName(),
                                jobTitle,
                                companyName
                        );
                        
                        // Gửi notification cho JobSeeker
                        NotificationDAO.sendNotification(
                                candidate.getJobSeekerID(), // ID của JobSeeker
                                "jobseeker", // Loại user nhận thông báo
                                "application", // Loại thông báo
                                "Đơn ứng tuyển không được chấp nhận", // Tiêu đề
                                "Rất tiếc, đơn ứng tuyển của bạn cho vị trí \"" + jobTitle + "\" tại " + companyName + " chưa phù hợp với yêu cầu tuyển dụng lần này. Đừng nản chí, hãy tiếp tục cố gắng!", // Nội dung
                                applicationID, // ID đơn ứng tuyển
                                "application", // Loại related item
                                request.getContextPath() + "/JobSeeker/applied-jobs.jsp", // URL khi click vào thông báo
                                1 // Priority: 1 = Medium
                        );
                        
                        System.out.println("DEBUG CandidateManagementServlet: Rejection email sent: " + emailSent + ", notification sent for JobSeekerID: " + candidate.getJobSeekerID());
                    }

                    if (!emailSent) {
                        System.out.println("DEBUG CandidateManagementServlet: WARNING - Email could not be sent to: " + candidate.getCandidateEmail());
                        // Vẫn tiếp tục vì status đã update thành công
                    }
                } else {
                    System.out.println("DEBUG CandidateManagementServlet: WARNING - No email found for candidate! ApplicationID: " + applicationID);
                }

                request.getSession().setAttribute("successMessage",
                        "Đã " + ("accept".equalsIgnoreCase(action) ? "chấp nhận" : "từ chối") + " ứng viên thành công!");
            } else {
                System.out.println("DEBUG CandidateManagementServlet: Failed to update application status!");
                request.setAttribute("error", "Không thể cập nhật trạng thái ứng viên!");
            }

        } catch (Exception e) {
            System.out.println("DEBUG CandidateManagementServlet: Exception in doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }

        // Redirect về trang candidate-management với jobID
        String jobID = request.getParameter("jobID");
        String q = request.getParameter("q");
        if (jobID != null && !jobID.isEmpty()) {
            String url = request.getContextPath() + "/candidate-management?jobID=" + jobID;
            if (q != null && !q.trim().isEmpty()) {
                url += "&q=" + java.net.URLEncoder.encode(q, java.nio.charset.StandardCharsets.UTF_8);
            }
            response.sendRedirect(url);
        } else {
            doGet(request, response);
        }
    }
}
