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
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import dal.JobDAO;
import dal.TypeDAO;
import dal.LocationDAO;
import dal.CategoryDAO;
import dal.RecruiterPackagesDAO;
import dal.JobPackagesDAO;
import dal.JobFeatureMappingsDAO;
import model.Job;
import util.JobCodeGenerator;
import model.Type;
import model.Location;
import model.Category;
import java.util.List;
import model.Recruiter;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 *
 * @author Admin
 */
@WebServlet(name = "JobPostingServlet", urlPatterns = {"/jobposting"})
public class JobPostingServlet extends HttpServlet {

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
     
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet JopPostingServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet JopPostingServlet at " + request.getContextPath() + "</h1>");
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
        System.out.println("DEBUG: JobPostingServlet doGet() called"); // Gọi khi tải trang đăng tin (GET)
        try {
            TypeDAO typeDAO = new TypeDAO(); // Khởi tạo DAO để lấy dữ liệu Type
            System.out.println("DEBUG: TypeDAO created"); // Log debug
            
            LocationDAO locationDAO = new LocationDAO(); // DAO địa điểm
            CategoryDAO categoryDAO = new CategoryDAO(); // DAO ngành nghề
            
            System.out.println("DEBUG: Calling getJobLevels()"); // Lấy danh sách cấp bậc công việc
            List<Type> jobLevels = typeDAO.getJobLevels(); // Danh sách cấp bậc
            System.out.println("DEBUG: getJobLevels() returned: " + (jobLevels != null ? jobLevels.size() + " items" : "null"));
            
            System.out.println("DEBUG: Calling getJobTypes()"); // Lấy danh sách loại việc
            List<Type> jobTypes = typeDAO.getJobTypes(); // Danh sách loại việc
            System.out.println("DEBUG: getJobTypes() returned: " + (jobTypes != null ? jobTypes.size() + " items" : "null"));
            
            System.out.println("DEBUG: Calling getTypesByCategory('Certificate')"); // Lấy danh sách bằng cấp
            List<Type> certificates = typeDAO.getTypesByCategory("Certificate"); // Danh sách bằng cấp
            System.out.println("DEBUG: getTypesByCategory('Certificate') returned: " + (certificates != null ? certificates.size() + " items" : "null"));
            
            List<Location> locations = locationDAO.getAllLocations(); // Danh sách địa điểm
            
            // Lấy parent categories và all categories để hiển thị dropdown phân cấp
            List<Category> parentCategories = categoryDAO.getParentCategories(); // Danh mục cha
            List<Category> allCategories = categoryDAO.getAllCategories(); // Tất cả danh mục (để lọc con theo cha)
            
            // Đảm bảo không set null - nếu null thì set empty list
            if (jobLevels == null) {
                jobLevels = new java.util.ArrayList<>(); // Tránh null gây lỗi JSP
                System.out.println("DEBUG: jobLevels was null, setting to empty list");
            }
            if (jobTypes == null) {
                jobTypes = new java.util.ArrayList<>(); // Tránh null gây lỗi JSP
                System.out.println("DEBUG: jobTypes was null, setting to empty list");
            }
            if (certificates == null) {
                certificates = new java.util.ArrayList<>(); // Tránh null gây lỗi JSP
                System.out.println("DEBUG: certificates was null, setting to empty list");
            }
            if (locations == null) {
                locations = new java.util.ArrayList<>(); // Tránh null
                System.out.println("DEBUG: locations was null, setting to empty list");
            }
            if (parentCategories == null) {
                parentCategories = new java.util.ArrayList<>(); // Tránh null
            }
            if (allCategories == null) {
                allCategories = new java.util.ArrayList<>(); // Tránh null
            }
            
            request.setAttribute("jobLevels", jobLevels); // Đẩy cấp bậc sang JSP
            request.setAttribute("jobTypes", jobTypes); // Đẩy loại việc sang JSP
            request.setAttribute("certificates", certificates); // Đẩy bằng cấp sang JSP
            request.setAttribute("locations", locations); // Đẩy địa điểm sang JSP
            request.setAttribute("parentCategories", parentCategories); // Danh mục cha sang JSP
            request.setAttribute("allCategories", allCategories); // Tất cả danh mục sang JSP
            
            System.out.println("DEBUG: Attributes set - jobLevels size: " + jobLevels.size() + ", jobTypes size: " + jobTypes.size());
            
            // Lấy recruiter từ session (JSP đã có nhưng cần đảm bảo có sẵn)
            model.Recruiter recruiter = (model.Recruiter) request.getSession().getAttribute("recruiter"); // Người tuyển dụng hiện tại
            request.setAttribute("recruiter", recruiter); // Đẩy recruiter sang JSP (địa chỉ công ty, logo, ...)
            // DEBUG: xuất recruiterId
            request.setAttribute("debugRecruiterId", recruiter != null ? recruiter.getRecruiterID() : null);

            // Quy tắc mới: NHẤT ĐỊNH dùng gói ĐĂNG_TUYỂN mua GẦN NHẤT
            // - Nếu gói gần nhất đã hết hạn → hiển thị cảnh báo và vô hiệu hoá nổi bật & nút "Đăng tin"
            // - Nếu gói gần nhất còn hạn nhưng hết lượt → hiển thị cảnh báo và vô hiệu hoá nổi bật & nút "Đăng tin"
            // - Nếu gói gần nhất hợp lệ且还剩 lượt → 允许 nổi bật phụ thuộc vào features của gói
            boolean allowFeatured = false; // Cho phép bật checkbox "Đăng tin nổi bật" hay không
            Integer selectedRecruiterPackageID = null;
            Integer selectedPackageDuration = null;
            boolean postingDisabled = false; // Nếu true, nút "Đăng tin" sẽ bị disabled
            String packageWarning = null; // Thông báo về gói (hết hạn/hết lượt)
            try {
                if (recruiter != null) {
                    RecruiterPackagesDAO rpDAO = new RecruiterPackagesDAO(); // DAO gói nhà tuyển dụng
                    List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> history = rpDAO.getPurchaseHistoryWithDetails(recruiter.getRecruiterID()); // Lịch sử mua (mới nhất trước)
                    // DEBUG: số lượng bản ghi lịch sử
                    request.setAttribute("debugHistoryCount", history != null ? history.size() : null);
                    if (history != null && !history.isEmpty()) {
                        RecruiterPackagesDAO.RecruiterPackagesWithDetails latest = null;
                        for (RecruiterPackagesDAO.RecruiterPackagesWithDetails pkg : history) {
                            if (pkg.packageType != null && pkg.packageType.equalsIgnoreCase("DANG_TUYEN")) { // Chỉ xét gói ĐĂNG_TUYỂN
                                latest = pkg; // Lấy gói gần nhất (history đã DESC theo ngày mua)
                                break;
                            }
                        }
                        if (latest != null) {
                            selectedRecruiterPackageID = latest.recruiterPackageID; // ID bản ghi gói gần nhất
                            selectedPackageDuration = latest.duration; // Thời hạn gói (ngày)
                            boolean isExpired = latest.expiryDate == null || !latest.expiryDate.isAfter(java.time.LocalDateTime.now()); // Hết hạn?
                            // Tính lượt còn lại dựa trên features.posts (mặc định 1 nếu không có)
                            int postsPerPackage = 1;
                            try {
                                JobPackagesDAO tmpDao = new JobPackagesDAO();
                                model.JobPackages tmpPkg = tmpDao.getPackageById(latest.packageID);
                                if (tmpPkg != null && tmpPkg.getFeatures() != null) {
                                    try {
                                        com.google.gson.JsonObject obj = new com.google.gson.Gson().fromJson(tmpPkg.getFeatures(), com.google.gson.JsonObject.class);
                                        if (obj != null && obj.has("posts")) {
                                            postsPerPackage = obj.get("posts").getAsInt();
                                        }
                                    } catch (Exception ignore) {}
                                }
                            } catch (Exception ignore) {}
                            int remainingPosts = (latest.quantity * postsPerPackage) - latest.usedQuantity;
                            boolean outOfPosts = remainingPosts <= 0; // Hết lượt?
                            if (isExpired) {
                                postingDisabled = true; // Cấm bấm Đăng tin
                                packageWarning = "Gói đăng tuyển gần nhất đã hết hạn. Vui lòng gia hạn hoặc mua gói mới."; // Thông báo hết hạn
                            } else if (outOfPosts) {
                                postingDisabled = true; // Cấm bấm Đăng tin
                                packageWarning = "Gói đăng tuyển gần nhất đã hết lượt đăng tin. Vui lòng mua thêm lượt."; // Thông báo hết lượt
                            } else {
                                try {
                                    JobPackagesDAO jpDAO = new JobPackagesDAO(); // DAO đọc chi tiết gói (features JSON)
                                    model.JobPackages jp = jpDAO.getPackageById(latest.packageID); // Gói gốc
                                    if (jp != null && jp.getFeatures() != null) {
                                        String features = jp.getFeatures(); // Chuỗi JSON tính năng của gói
                                        try {
                                            Gson gson = new Gson(); // Dùng Gson parse JSON
                                            JsonObject obj = gson.fromJson(features, JsonObject.class); // Parse chuỗi -> JSON
                                            boolean webPriority = obj.has("web_priority") && obj.get("web_priority").getAsBoolean(); // Quyền ưu tiên web
                                            boolean featured = obj.has("featured") && obj.get("featured").getAsBoolean(); // Quyền tin nổi bật
                                            allowFeatured = webPriority || featured; // Cho phép bật nếu một trong hai là true
                                        } catch (Exception jsonEx) {
                                            String lower = features.toLowerCase(); // Fallback nếu JSON lỗi
                                            allowFeatured = lower.contains("\"web_priority\": true") || lower.contains("\"featured\": true"); // Dò chuỗi
                                        }
                                    }
                                } catch (Exception ignore) {}
                            }
                        }
                    }
                } else {
                    // Không có recruiter → disable đăng tin và ghi chú
                    postingDisabled = true;
                    packageWarning = "Vui lòng đăng nhập để sử dụng gói đăng tuyển.";
                }
            } catch (Exception ex) {
                System.out.println("DEBUG: Error determining latest package/featured allowance: " + ex.getMessage()); // Lỗi xác định gói/feature
            }

            request.setAttribute("allowFeatured", allowFeatured); // Cho phép/khóa checkbox "Đăng tin nổi bật"
            request.setAttribute("postingRecruiterPackageID", selectedRecruiterPackageID); // ID gói gần nhất
            request.setAttribute("postingPackageDuration", selectedPackageDuration); // Thời hạn gói
            request.setAttribute("postingDisabled", postingDisabled); // true -> disable nút Đăng tin
            request.setAttribute("packageWarning", packageWarning); // Thông báo hiển thị trên form
            // DEBUG: kết quả cuối cùng
            request.setAttribute("debugAllowFeatured", allowFeatured);
            request.setAttribute("debugPostingDisabled", postingDisabled);
            // DEBUG: thêm postsPerPackage và remaining nếu có thể
            try {
                if (selectedRecruiterPackageID != null) {
                    RecruiterPackagesDAO rpDAO2 = new RecruiterPackagesDAO();
                    java.util.List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> hist2 = rpDAO2.getPurchaseHistoryWithDetails(((model.Recruiter)request.getSession().getAttribute("recruiter")).getRecruiterID());
                    for (RecruiterPackagesDAO.RecruiterPackagesWithDetails pkg : hist2) {
                        if (pkg.recruiterPackageID == selectedRecruiterPackageID) {
                            int postsPerPackage = 1;
                            try {
                                JobPackagesDAO tmpDao = new JobPackagesDAO();
                                model.JobPackages tmpPkg = tmpDao.getPackageById(pkg.packageID);
                                if (tmpPkg != null && tmpPkg.getFeatures() != null) {
                                    com.google.gson.JsonObject obj = new com.google.gson.Gson().fromJson(tmpPkg.getFeatures(), com.google.gson.JsonObject.class);
                                    if (obj != null && obj.has("posts")) postsPerPackage = obj.get("posts").getAsInt();
                                }
                            } catch (Exception ignore) {}
                            int remainingPosts = (pkg.quantity * postsPerPackage) - pkg.usedQuantity;
                            request.setAttribute("debugPostsPerPackage", postsPerPackage);
                            request.setAttribute("debugRemainingPosts", remainingPosts);
                            break;
                        }
                    }
                }
            } catch (Exception ignore) {}
            
            request.getRequestDispatcher("Recruiter/job-posting.jsp").forward(request, response); // Forward sang JSP hiển thị form
        } catch (Exception e) {
            System.out.println("DEBUG: Exception in doGet: " + e.getMessage()); // Log lỗi tổng quát
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu: " + e.getMessage()); // Gửi thông báo lỗi ra JSP
            request.getRequestDispatcher("Recruiter/job-posting.jsp").forward(request, response); // Quay lại trang form
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
        System.out.println("=========================================="); // Log phân cách
        System.out.println("DEBUG: JobPostingServlet doPost() called!"); // Gọi khi submit form (POST)
        System.out.println("DEBUG: Request Method: " + request.getMethod()); // Phương thức
        System.out.println("DEBUG: Context Path: " + request.getContextPath()); // Context path
        System.out.println("DEBUG: Request URI: " + request.getRequestURI()); // URI
        System.out.println("=========================================="); // Log phân cách
        try {
            String jobTitle = request.getParameter("job-title"); // Tiêu đề công việc
            String description = request.getParameter("job-description"); // Mô tả công việc
            String requirements = request.getParameter("job-requirements"); // Yêu cầu công việc
            int jobLevelID = Integer.parseInt(request.getParameter("job-level")); // Cấp bậc
            String salaryMinStr = request.getParameter("salary-min");
            String salaryMaxStr = request.getParameter("salary-max");
            String salaryRange = salaryMinStr + "-" + salaryMaxStr; // Dải lương "min-max"
            String expirationDateStr = request.getParameter("expiration-date"); // Hạn bài (nếu có)
            int ageRequirement = 0; // Giá trị mặc định (field cũ đã bỏ)
            int jobTypeID = Integer.parseInt(request.getParameter("job-type")); // Loại việc
            int hiringCount = Integer.parseInt(request.getParameter("hiring-count")); // Số lượng cần tuyển
            String action = request.getParameter("action"); // draft | post (2 nút submit)
            // Chú thích: action đến từ nút Lưu nháp hoặc Đăng tin
            String featuredParam = request.getParameter("featured"); // Checkbox nổi bật
            boolean featuredSelected = "1".equals(featuredParam) || "on".equalsIgnoreCase(featuredParam); // true nếu người dùng tick
            // Chú thích: nếu gói không cho phép nổi bật, checkbox sẽ bị disabled trên UI
            
            // Lấy recruiter từ session
            model.Recruiter recruiter = (model.Recruiter) request.getSession().getAttribute("recruiter"); // Lấy recruiter từ session
            if (recruiter == null) {
                request.setAttribute("error", "Vui lòng đăng nhập để đăng tin tuyển dụng!"); // Chưa đăng nhập → chặn
                doGet(request, response);
                return;
            }
            
            // Lấy categoryID từ recruiter (vì đã bỏ field job-field)
            int categoryID = 0;
            if (recruiter.getCategoryID() > 0) {
                categoryID = recruiter.getCategoryID();
            }
            
            // Tạo Job object
            Job job = new Job(); // Tạo đối tượng Job để lưu DB
            job.setRecruiterID(recruiter.getRecruiterID()); // Gán RecruiterID
            job.setJobTitle(jobTitle); // Tiêu đề
            job.setDescription(description); // Mô tả
            job.setRequirements(requirements); // Yêu cầu
            job.setJobLevelID(jobLevelID); // Cấp bậc
            job.setSalaryRange(salaryRange); // Dải lương
            
            // Validate mức lương hợp lệ (>=0, min <= max)
            try {
                if (salaryMinStr != null && !salaryMinStr.isEmpty() && salaryMaxStr != null && !salaryMaxStr.isEmpty()) {
                    long smin = Long.parseLong(salaryMinStr);
                    long smax = Long.parseLong(salaryMaxStr);
                    if (smin < 0 || smax < 0 || smin > smax) {
                        request.setAttribute("error", "Mức lương không hợp lệ (phải ≥0 và tối thiểu ≤ tối đa).");
                        doGet(request, response);
                        return;
                    }
                }
            } catch (NumberFormatException nfe) {
                request.setAttribute("error", "Mức lương phải là số hợp lệ.");
                doGet(request, response);
                return;
            }

            // Parse expiration date - chỉ dùng khi lưu nháp
            // Khi đăng tin (post), sẽ dùng ngày hết hạn của gói
            if ("draft".equalsIgnoreCase(action)) {
                if (expirationDateStr != null && !expirationDateStr.isEmpty()) {
                    LocalDateTime expirationDate = LocalDateTime.parse(expirationDateStr + "T23:59:59");
                    job.setExpirationDate(expirationDate);
                }
            } else {
                // Khi đăng tin (post), tìm gói và lấy ngày hết hạn
                RecruiterPackagesDAO rpDAO = new RecruiterPackagesDAO();
                List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> history = rpDAO.getPurchaseHistoryWithDetails(recruiter.getRecruiterID());
                RecruiterPackagesDAO.RecruiterPackagesWithDetails chosen = null;
                if (history != null && !history.isEmpty()) {
                    for (RecruiterPackagesDAO.RecruiterPackagesWithDetails pkg : history) {
                        if (pkg.packageType != null && pkg.packageType.equalsIgnoreCase("DANG_TUYEN")) {
                            chosen = pkg; // Chọn gói gần nhất
                            break;
                        }
                    }
                }
                if (chosen != null && chosen.expiryDate != null) {
                    // Đặt ngày hết hạn của job trùng với ngày hết hạn của gói
                    job.setExpirationDate(chosen.expiryDate);
                    System.out.println("DEBUG: Set job expiration date to package expiry date: " + chosen.expiryDate);
                }
            }
            
            // Set PostingDate to current time
            job.setPostingDate(LocalDateTime.now()); // Ngày đăng (thời điểm tạo)
            
            job.setCategoryID(categoryID);
            job.setAgeRequirement(ageRequirement);
            // Ghi chú (VI): trạng thái việc làm sẽ theo action người dùng chọn
            job.setStatus("draft".equalsIgnoreCase(action) ? "Draft" : "Published"); // Lưu nháp → Draft, Đăng tin → Published
            job.setJobTypeID(jobTypeID);
            job.setHiringCount(hiringCount);
            
            // Set default values
            job.setViewCount(0); // Khởi tạo lượt xem
            job.setIsUrgent(false); // Không gấp mặc định
            job.setIsPriority(featuredSelected); // Lưu trạng thái nổi bật (1/0)
            
            // Generate job code
            job.setJobCode(JobCodeGenerator.generateJobCode()); // Sinh mã công việc
            
            // Get and set contact person and application email
            String contactPerson = request.getParameter("contact-person"); // Người liên hệ
            String applicationEmail = request.getParameter("application-email"); // Email nhận hồ sơ
            job.setContactPerson(contactPerson != null ? contactPerson : ""); // Gán người liên hệ
            job.setApplicationEmail(applicationEmail != null ? applicationEmail : ""); // Gán email nhận hồ sơ
            
            // Get and set min experience
            String minExpStr = request.getParameter("min-experience");
            if (minExpStr != null && !minExpStr.trim().isEmpty()) {
                try {
                    int mx = Integer.parseInt(minExpStr);
                    if (mx < 0 || mx > 60) {
                        request.setAttribute("error", "Năm kinh nghiệm tối thiểu phải từ 0 đến 60.");
                        doGet(request, response);
                        return;
                    }
                    job.setMinExperience(mx);
                } catch (NumberFormatException e) {
                    job.setMinExperience(null);
                }
            }
            
            // Get and set certificates ID (bằng cấp tối thiểu)
            String certificatesIDStr = request.getParameter("certificates-id");
            if (certificatesIDStr != null && !certificatesIDStr.trim().isEmpty()) {
                try {
                    int certID = Integer.parseInt(certificatesIDStr);
                    job.setCertificatesID(certID);
                } catch (NumberFormatException e) {
                    job.setCertificatesID(null);
                }
            } else {
                job.setCertificatesID(null);
            }
            
            // Get and set location ID (khu vực)
            String locationIDStr = request.getParameter("location-id");
            if (locationIDStr != null && !locationIDStr.trim().isEmpty()) {
                try {
                    int locID = Integer.parseInt(locationIDStr);
                    job.setLocationID(locID);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Khu vực không hợp lệ.");
                    doGet(request, response);
                    return;
                }
            } else {
                request.setAttribute("error", "Vui lòng chọn khu vực.");
                doGet(request, response);
                return;
            }
            
            // Get and set nationality
            String nationality = request.getParameter("nationality");
            job.setNationality(nationality != null ? nationality : "any");
            
            // Get and set gender
            String gender = request.getParameter("gender");
            job.setGender(gender != null ? gender : "any");
            
            // Get and set marital status
            String maritalStatus = request.getParameter("marital-status");
            job.setMaritalStatus(maritalStatus != null ? maritalStatus : "any");
            
            // Get and set age min/max
            String ageMinStr = request.getParameter("age-min");
            String ageMaxStr = request.getParameter("age-max");
            if (ageMinStr != null && !ageMinStr.trim().isEmpty()) {
                try {
                    job.setAgeMin(Integer.parseInt(ageMinStr));
                } catch (NumberFormatException e) {
                    job.setAgeMin(null);
                }
            }
            if (ageMaxStr != null && !ageMaxStr.trim().isEmpty()) {
                try {
                    job.setAgeMax(Integer.parseInt(ageMaxStr));
                } catch (NumberFormatException e) {
                    job.setAgeMax(null);
                }
            }
            // Validate độ tuổi trong khoảng 15-65 và min <= max (nếu cả hai có)
            if (job.getAgeMin() != null && job.getAgeMax() != null) {
                if (job.getAgeMin() < 15 || job.getAgeMin() > 65 || job.getAgeMax() < 15 || job.getAgeMax() > 65 || job.getAgeMin() > job.getAgeMax()) {
                    request.setAttribute("error", "Độ tuổi không hợp lệ (15-65) và tối thiểu ≤ tối đa.");
                    doGet(request, response);
                    return;
                }
            }
            
            System.out.println("DEBUG: Starting to save job...");
            JobDAO jobDAO = new JobDAO();
            int jobID = jobDAO.addJob(job);
            System.out.println("DEBUG: Job saved with ID: " + jobID);
            
            if (jobID > 0) {
                // Xử lý skills
                String skillsParam = request.getParameter("skills");
                System.out.println("DEBUG: Skills parameter: " + skillsParam);
                if (skillsParam != null && !skillsParam.trim().isEmpty()) {
                    dal.SkillDAO skillDAO = new dal.SkillDAO();
                    dal.JobSkillMappingDAO mappingDAO = new dal.JobSkillMappingDAO();
                    
                    // Split skills bằng dấu phẩy (tạo skill nếu chưa có và map vào Job)
                    String[] skillNames = skillsParam.split(",");
                    System.out.println("DEBUG: Processing " + skillNames.length + " skills");
                    
                    for (String skillName : skillNames) {
                        skillName = skillName.trim();
                        if (!skillName.isEmpty()) {
                            try {
                                // Kiểm tra và thêm skill nếu chưa tồn tại
                                int skillID = skillDAO.addSkill(skillName);
                                System.out.println("DEBUG: Skill '" + skillName + "' -> SkillID: " + skillID);
                                
                                if (skillID > 0) {
                                    // Thêm mapping giữa Job và Skill
                                    boolean mappingAdded = mappingDAO.addMapping(jobID, skillID);
                                    System.out.println("DEBUG: Mapping added: " + mappingAdded);
                                }
                            } catch (Exception ex) {
                                System.out.println("DEBUG: Error processing skill '" + skillName + "': " + ex.getMessage());
                                ex.printStackTrace();
                            }
                        }
                    }
                }
                
                if ("post".equalsIgnoreCase(action)) {
                    // Nhánh Đăng tin：BẮT BUỘC dùng gói ĐĂNG_TUYỂN mua gần nhất
                    RecruiterPackagesDAO rpDAO = new RecruiterPackagesDAO();
                    List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> history = rpDAO.getPurchaseHistoryWithDetails(recruiter.getRecruiterID());
                    RecruiterPackagesDAO.RecruiterPackagesWithDetails chosen = null;
                    if (history != null && !history.isEmpty()) {
                        for (RecruiterPackagesDAO.RecruiterPackagesWithDetails pkg : history) {
                            if (pkg.packageType != null && pkg.packageType.equalsIgnoreCase("DANG_TUYEN")) {
                                chosen = pkg; // Chọn gói gần nhất (PurchaseDate DESC)
                                break;
                            }
                        }
                    }
                    if (chosen == null) {
                        request.setAttribute("error", "Không tìm thấy gói ĐĂNG_TUYỂN gần nhất. Vui lòng mua gói trước khi đăng."); // Không có gói để dùng
                        doGet(request, response);
                        return;
                    }
                    boolean isExpired = chosen.expiryDate == null || !chosen.expiryDate.isAfter(java.time.LocalDateTime.now()); // Hết hạn?
                    // Tính lượt còn lại = Quantity * postsPerPackage - UsedQuantity
                    int postsPerPackage = 1;
                    try {
                        JobPackagesDAO tmpDao = new JobPackagesDAO();
                        model.JobPackages tmpPkg = tmpDao.getPackageById(chosen.packageID);
                        if (tmpPkg != null && tmpPkg.getFeatures() != null) {
                            try {
                                com.google.gson.JsonObject obj = new com.google.gson.Gson().fromJson(tmpPkg.getFeatures(), com.google.gson.JsonObject.class);
                                if (obj != null && obj.has("posts")) {
                                    postsPerPackage = obj.get("posts").getAsInt();
                                }
                            } catch (Exception ignore) {}
                        }
                    } catch (Exception ignore) {}
                    int remainingPosts = (chosen.quantity * postsPerPackage) - chosen.usedQuantity;
                    boolean outOfPosts = remainingPosts <= 0; // Hết lượt?
                    if (isExpired) {
                        request.setAttribute("error", "Gói đăng tuyển gần nhất đã hết hạn. Vui lòng gia hạn hoặc mua gói mới."); // Cảnh báo hết hạn
                        doGet(request, response);
                        return;
                    }
                    if (outOfPosts) {
                        request.setAttribute("error", "Gói đăng tuyển gần nhất đã hết lượt đăng tin. Vui lòng mua thêm lượt."); // Cảnh báo hết lượt
                        doGet(request, response);
                        return;
                    }

                    // Bước 2: Kiểm tra quyền nổi bật (web_priority/featured trong features JSON)
                    boolean allowFeatured = false;
                    try {
                        JobPackagesDAO jpDAO = new JobPackagesDAO();
                        model.JobPackages jp = jpDAO.getPackageById(chosen.packageID);
                        if (jp != null && jp.getFeatures() != null) {
                            try {
                                Gson gson = new Gson();
                                JsonObject obj = gson.fromJson(jp.getFeatures(), JsonObject.class);
                                boolean webPriority = obj.has("web_priority") && obj.get("web_priority").getAsBoolean();
                                boolean featuredFlag = obj.has("featured") && obj.get("featured").getAsBoolean();
                                allowFeatured = webPriority || featuredFlag;
                            } catch (Exception je) {
                                String lower = jp.getFeatures().toLowerCase();
                                allowFeatured = lower.contains("\"web_priority\": true") || lower.contains("\"featured\": true");
                            }
                        }
                    } catch (Exception ex) {
                        System.out.println("DEBUG: features check error: " + ex.getMessage()); // Lỗi đọc features gói
                    }
                    if (!allowFeatured && featuredSelected) {
                        // Nếu không được phép nổi bật nhưng người dùng tick → bỏ chọn (không set trái phép)
                        jobDAO.updateJobStatus(jobID, "Published"); // Trạng thái vẫn Published
                    }

                    // Bước 3: Trừ lượt của gói (UsedQuantity + 1)
                    // Đã tự kiểm tra remainingPosts dựa trên features.posts → tăng UsedQuantity trực tiếp
                    boolean pkgUpdated = rpDAO.incrementUsedQuantityForce(chosen.recruiterPackageID);
                    if (!pkgUpdated) {
                        request.setAttribute("error", "Không thể trừ lượt từ gói đăng tuyển. Vui lòng thử lại."); // Không trừ được lượt → lỗi
                        doGet(request, response);
                        return;
                    }

                    // Bước 4: Lưu lịch sử sử dụng gói vào JobFeatureMappings (để theo dõi hiệu lực)
                    JobFeatureMappingsDAO mappingDAO = new JobFeatureMappingsDAO();
                    model.JobFeatureMappings mapping = new model.JobFeatureMappings();
                    mapping.setJobID(jobID); // Gán JobID
                    mapping.setRecruiterPackageID(chosen.recruiterPackageID); // Gán ID gói
                    mapping.setFeatureType("DANG_TUYEN"); // Loại tính năng/nhóm gói
                    mapping.setAppliedDate(LocalDateTime.now()); // Ngày áp dụng
                    if (chosen.duration > 0) {
                        mapping.setExpireDate(LocalDateTime.now().plusDays(chosen.duration)); // Hết hạn = hôm nay + duration
                    }
                    boolean mappingOk = mappingDAO.addJobFeatureMapping(mapping);
                    if (!mappingOk) {
                        request.setAttribute("error", "Không thể lưu lịch sử sử dụng gói."); // Lưu lịch sử thất bại
                        doGet(request, response);
                        return;
                    }

                    // Thành công
                    request.getSession().setAttribute("successMessage", "Đăng tuyển dụng thành công! Tin của bạn đang chờ duyệt."); // Thông báo thành công
                    response.sendRedirect(request.getContextPath() + "/Recruiter/index.jsp"); // Quay về dashboard
                } else {
                    // Nhánh Lưu nháp：không trừ lượt và không ghi lịch sử sử dụng gói
                    request.setAttribute("success", "Đã lưu nháp tin tuyển dụng."); // Thông báo lưu nháp
                    doGet(request, response);
                }
            } else {
                System.out.println("DEBUG: Failed to save job!"); // Lưu Job thất bại
                request.setAttribute("error", "Có lỗi xảy ra khi lưu tin tuyển dụng!"); // Báo lỗi cho người dùng
                request.getRequestDispatcher("/Recruiter/job-posting.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("DEBUG: Exception in doPost: " + e.getMessage()); // Log lỗi tổng quát
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage()); // Thông báo lỗi ra JSP
            try {
                request.getRequestDispatcher("/Recruiter/job-posting.jsp").forward(request, response); // Quay lại trang form
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
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
