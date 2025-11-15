<%-- 
    Document   : candidate-management
    Created on : Nov 2, 2025, 8:29:11 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page import="model.Job" %>
<%@page import="model.CandidateApplication" %>
<%@page import="java.util.List" %>
<%@page import="java.time.format.DateTimeFormatter" %>
<%
    Job job = (Job) request.getAttribute("job");
    List<Job> allJobs = (List<Job>) request.getAttribute("allJobs");
    if (allJobs == null) allJobs = new java.util.ArrayList<>();
    
    List<CandidateApplication> candidates = (List<CandidateApplication>) request.getAttribute("candidates");
    if (candidates == null) {
        candidates = new java.util.ArrayList<>();
    }
    
    Integer jobID = (Integer) request.getAttribute("jobID");
    Long approvedCount = (Long) request.getAttribute("approvedCount");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    
    if (approvedCount == null) approvedCount = 0L;
    if (totalCount == null) totalCount = candidates.size();
    
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
    
    String errorMessage = (String) request.getAttribute("error");
    
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    
    // remove debug logs
    
    // Search param and in-page filtering (like purchase-history): by candidate name or CV title
    String q = request.getParameter("q");
    List<CandidateApplication> displayCandidates = candidates;
    if (q != null && !q.trim().isEmpty()) {
        String qLower = q.toLowerCase();
        java.util.List<CandidateApplication> filtered = new java.util.ArrayList<>();
        for (CandidateApplication c : candidates) {
            String name = c.getCandidateName() != null ? c.getCandidateName().toLowerCase() : "";
            String cvTitle = c.getCvTitle() != null ? c.getCvTitle().toLowerCase() : "";
            if (name.contains(qLower) || cvTitle.contains(qLower)) {
                filtered.add(c);
            }
        }
        displayCandidates = filtered;
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Ứng Viên</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Recruiter/styles.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Recruiter/candidate-management.css">
    </head>
    <body>
        <nav class="navbar">
            <div class="nav-container">
                <div class="nav-left">
                    <div class="logo">
                        <i class="fas fa-briefcase"></i>
                        <span>RecruitPro</span>
                    </div>
                    <ul class="nav-menu">
                        <li><a href="${pageContext.request.contextPath}/Recruiter/index.jsp">Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/Recruiter/job-management.jsp">Việc Làm</a></li>
                        <li class="dropdown">
                            <a href="#" class="active">Ứng viên <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/candidate-management">Quản lý theo việc đăng tuyển</a>
                                <a href="${pageContext.request.contextPath}/Recruiter/candidate-folder.html" class="highlighted">Quản lý theo thư mục và thẻ</a>
                            </div>
                        </li>
                        <li class="dropdown">
                            <a href="#">Onboarding <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="#">Quy trình onboarding</a>
                                <a href="#">Tài liệu hướng dẫn</a>
                            </div>
                        </li>
                        <li class="dropdown">
                            <a href="#">Đơn hàng <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/recruiter/purchase-history">Lịch sử mua</a>
                            </div>
                        </li>
                        <li><a href="#">Báo cáo</a></li>
                        <li><a href="${pageContext.request.contextPath}/Recruiter/company-info.jsp">Công ty</a></li>
                    </ul>
                </div>
                <div class="nav-right">
                    <div class="nav-buttons">
                        <div class="dropdown">
                            <button class="btn btn-orange">
                                Đăng Tuyển Dụng <i class="fas fa-chevron-down"></i>
                            </button>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/Recruiter/job-posting.jsp">Tạo tin tuyển dụng mới</a>
                                <a href="${pageContext.request.contextPath}/Recruiter/job-management.jsp">Quản lý tin đã đăng</a>
                            </div>
                        </div>
                        <button class="btn btn-blue" onclick="window.location.href='${pageContext.request.contextPath}/candidate-search'">Tìm Ứng Viên</button>
                        <button class="btn btn-white" onclick="window.location.href='${pageContext.request.contextPath}/Recruiter/job-package.jsp'">Mua</button>
                    </div>
                    <div class="nav-icons">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-bell"></i>
                        <div class="dropdown user-dropdown">
                            <div class="user-avatar">
                                <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNGNUY3RkEiLz4KPHN2ZyB4PSIxMCIgeT0iMTAiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTJaIiBmaWxsPSIjOUNBM0FGIi8+CjxwYXRoIGQ9Ik0xMiAxNEM5LjMzIDE0IDcgMTYuMzMgNyAxOVYyMUgxN1YxOUMxNyAxNi4zMyAxNC42NyAxNCAxMiAxNFoiIGZpbGw9IiM5Q0EzQUYiLz4KPC9zdmc+Cjwvc3ZnPgo=" alt="User Avatar" class="avatar-img">
                            </div>
                            <div class="dropdown-content user-menu">
                                <div class="user-header">
                                    <i class="fas fa-user-circle"></i>
                                    <div class="user-info">
                                        <div class="user-name">Nguyen Phuoc</div>
                                    </div>
                                    <i class="fas fa-times close-menu"></i>
                                </div>
                                <div class="menu-section">
                                    <div class="section-title">Thành viên</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-users"></i>
                                        <span>Thành viên</span>
                                    </a>
                                </div>
                                <div class="menu-section">
                                    <div class="section-title">Thiết lập tài khoản</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-cog"></i>
                                        <span>Quản lý tài khoản</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/Recruiter/company-info.jsp" class="menu-item highlighted">
                                        <i class="fas fa-building"></i>
                                        <span>Thông tin công ty</span>
                                    </a>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-shield-alt"></i>
                                        <span>Quản lý quyền truy cập</span>
                                    </a>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-tasks"></i>
                                        <span>Quản lý yêu cầu</span>
                                    </a>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-history"></i>
                                        <span>Lịch sử hoạt động</span>
                                    </a>
                                </div>
                                <div class="menu-section">
                                    <div class="section-title">Liên hệ mua</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-phone"></i>
                                        <span>Liên hệ mua</span>
                                    </a>
                                </div>
                                <div class="menu-section">
                                    <div class="section-title">Hỏi đáp</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-question-circle"></i>
                                        <span>Hỏi đáp</span>
                                    </a>
                                </div>
                                <div class="menu-footer">
                                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-item">
                                        <i class="fas fa-sign-out-alt"></i>
                                        <span>Thoát</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </nav>

        <% if (successMessage != null && !successMessage.isEmpty()) { %>
        <div class="success-alert" style="position: fixed; top: 80px; left: 50%; transform: translateX(-50%); background: #4caf50; color: white; padding: 15px 25px; border-radius: 5px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); z-index: 10000; display: flex; align-items: center; gap: 10px;">
            <i class="fas fa-check-circle"></i>
            <span><%= successMessage %></span>
            <button onclick="this.parentElement.remove()" style="background: none; border: none; color: white; font-size: 18px; cursor: pointer; margin-left: 10px;">&times;</button>
        </div>
        <script>
            setTimeout(function() {
                var alert = document.querySelector('.success-alert');
                if (alert) alert.remove();
            }, 5000);
        </script>
        <% } %>
        
        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
        <div class="error-alert" style="position: fixed; top: 80px; left: 50%; transform: translateX(-50%); background: #f44336; color: white; padding: 15px 25px; border-radius: 5px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); z-index: 10000; display: flex; align-items: center; gap: 10px;">
            <i class="fas fa-exclamation-circle"></i>
            <span><%= errorMessage %></span>
            <button onclick="this.parentElement.remove()" style="background: none; border: none; color: white; font-size: 18px; cursor: pointer; margin-left: 10px;">&times;</button>
        </div>
        <script>
            setTimeout(function() {
                var alert = document.querySelector('.error-alert');
                if (alert) alert.remove();
            }, 5000);
        </script>
        <% } %>
        
        <main class="main-content" style="padding: 0 !important; margin: 0 auto !important; max-width: 1400px !important; display: block !important;">
            <div class="candidates-container" style="width: 100% !important; margin: 0 auto !important;">
                <!-- Info, Tabs -->
                <div class="job-info">
                    <div class="job-title">Việc làm</div>
                    <div class="job-details">
                        <% if (allJobs != null && !allJobs.isEmpty()) { %>
                        <select id="job-select" onchange="changeJob(this.value)" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 16px; min-width: 300px; background: white; cursor: pointer;">
                            <% for (Job j : allJobs) { 
                                boolean isSelected = (job != null && job.getJobID() == j.getJobID());
                                String jobTitleDisplay = j.getJobTitle() != null ? j.getJobTitle() : "N/A";
                            %>
                            <option value="<%= j.getJobID() %>" <%= isSelected ? "selected" : "" %>>
                                <%= jobTitleDisplay %> - ID: <%= j.getJobID() %>
                            </option>
                            <% } %>
                        </select>
                        <% } else { %>
                        <span>Bạn chưa có tin tuyển dụng nào</span>
                        <% } %>
                        (<%= totalCount %>)
                    </div>
                    <div class="job-date">
                        <% if (job != null && job.getPostingDate() != null) { %>
                            <%= job.getPostingDate().format(dateFormatter) %>
                        <% } else { %>
                            N/A
                        <% } %>
                        • Đã duyệt <%= approvedCount %>/<%= totalCount %>
                    </div>
                </div>
                <!-- Table and search tools -->
                <div class="candidates-table">
                    <form method="GET" action="${pageContext.request.contextPath}/candidate-management" style="display:flex; gap:8px; align-items:center; margin:0 0 12px 0;">
                        <input type="hidden" name="jobID" value="<%= job != null ? job.getJobID() : (jobID != null ? jobID : 0) %>">
                        <input type="text" name="q" value="<%= q != null ? q : "" %>" placeholder="Tìm theo tên hoặc tiêu đề CV..." style="flex:1; min-width:280px; padding:8px 12px; border:1px solid #ddd; border-radius:6px;" />
                        <button type="submit" class="btn btn-blue" style="padding:8px 14px;">Tìm kiếm</button>
                        <c:if test="${not empty param.q}">
                            <a class="btn btn-white" style="padding:8px 14px; text-decoration:none;" href="${pageContext.request.contextPath}/candidate-management?jobID=<%= job != null ? job.getJobID() : (jobID != null ? jobID : 0) %>">Xóa</a>
                        </c:if>
                    </form>
                    <table>
                        <thead>
                            <tr>
                                <th><input type="checkbox"></th>
                                <th>Tên ứng viên</th>
                                <th>Ngày ứng tuyển</th>
                                <th>Rating</th>
                                <th>Năm kinh nghiệm</th>
                                <th>Tiêu chí phù hợp</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (displayCandidates != null && !displayCandidates.isEmpty()) { 
                                for (CandidateApplication candidate : displayCandidates) {
                                    String formattedDate = candidate.getFormattedApplicationDate();
                                    String status = candidate.getStatus() != null ? candidate.getStatus() : "Pending";
                                    // Debug: ensure applicationID and jobID are not null
                                    Integer appID = candidate.getApplicationID();
                                    Integer jID = candidate.getJobID();
                                    // ensure not null
                            %>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td>
                                    <div class="candidate-info">
                                        <i class="fas fa-user"></i>
                                        <%
                                            // Build URL with parameters
                                            String profileUrl = request.getContextPath() + "/candidate-profile-view?jobSeekerID=" + candidate.getJobSeekerID();
                                            if (candidate.getCvID() > 0) {
                                                profileUrl += "&cvID=" + candidate.getCvID();
                                            }
                                            if (candidate.getApplicationID() > 0) {
                                                profileUrl += "&applicationID=" + candidate.getApplicationID();
                                            }
                                            if (candidate.getJobID() > 0) {
                                                profileUrl += "&jobID=" + candidate.getJobID();
                                            }
                                        %>
                                        <a href="<%= profileUrl %>" 
                                           style="color: #333; text-decoration: none; font-weight: 500;"
                                           onmouseover="this.style.color='#ff6b35'; this.style.textDecoration='underline';"
                                           onmouseout="this.style.color='#333'; this.style.textDecoration='none';">
                                            <%= candidate.getCandidateName() != null ? candidate.getCandidateName() : "N/A" %>
                                        </a>
                                    </div>
                                </td>
                                <td>Ứng tuyển: <%= formattedDate %></td>
                                <td><%= String.format("%.1f", candidate.getRating()) %>★</td>
                                <td><%= candidate.getExperienceYears() %> năm</td>
                                <td>
                                    <span class="tag"><%= candidate.getCvTitle() != null ? candidate.getCvTitle() : "CV" %></span>
                                </td>
                                <td>
                                    <%
                                        String candidateStatus = candidate.getStatus();
                                        if (candidateStatus != null) {
                                            if ("Accepted".equals(candidateStatus)) {
                                    %>
                                    <div class="status-badge accepted" style="display: inline-block; padding: 6px 12px; border-radius: 6px; background: #4caf50; color: white; font-size: 13px; font-weight: 500;">
                                        <i class="fas fa-check-circle"></i> Đã chấp nhận
                                    </div>
                                    <% 
                                            } else if ("Rejected".equals(candidateStatus)) {
                                    %>
                                    <div class="status-badge rejected" style="display: inline-block; padding: 6px 12px; border-radius: 6px; background: #f44336; color: white; font-size: 13px; font-weight: 500;">
                                        <i class="fas fa-times-circle"></i> Đã từ chối
                                    </div>
                                    <% 
                                            } else {
                                                // Status = "Pending" hoặc các status khác - hiển thị buttons
                                    %>
                                    <div class="action-buttons-group">
                                        <form action="${pageContext.request.contextPath}/candidate-management" method="POST" style="display: inline;" 
                                              onsubmit="return confirm('Bạn có chắc chắn muốn chấp nhận ứng viên này?');">
                                            <input type="hidden" name="action" value="accept">
                                            <input type="hidden" name="applicationID" value="<%= candidate.getApplicationID() %>">
                                            <input type="hidden" name="jobID" value="<%= candidate.getJobID() %>">
                                            <button type="submit" class="btn-accept">
                                                <i class="fas fa-check"></i> Chấp nhận
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/candidate-management" method="POST" style="display: inline;"
                                              onsubmit="return confirm('Bạn có chắc chắn muốn từ chối ứng viên này?');">
                                            <input type="hidden" name="action" value="reject">
                                            <input type="hidden" name="applicationID" value="<%= candidate.getApplicationID() %>">
                                            <input type="hidden" name="jobID" value="<%= candidate.getJobID() %>">
                                            <button type="submit" class="btn-reject">
                                                <i class="fas fa-times"></i> Từ chối
                                            </button>
                                        </form>
                                    </div>
                                    <%
                                            }
                                        } else {
                                            // Status null - hiển thị buttons
                                    %>
                                    <div class="action-buttons-group">
                                        <form action="${pageContext.request.contextPath}/candidate-management" method="POST" style="display: inline;" 
                                              onsubmit="return confirm('Bạn có chắc chắn muốn chấp nhận ứng viên này?');">
                                            <input type="hidden" name="action" value="accept">
                                            <input type="hidden" name="applicationID" value="<%= candidate.getApplicationID() %>">
                                            <input type="hidden" name="jobID" value="<%= candidate.getJobID() %>">
                                            <button type="submit" class="btn-accept">
                                                <i class="fas fa-check"></i> Chấp nhận
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/candidate-management" method="POST" style="display: inline;"
                                              onsubmit="return confirm('Bạn có chắc chắn muốn từ chối ứng viên này?');">
                                            <input type="hidden" name="action" value="reject">
                                            <input type="hidden" name="applicationID" value="<%= candidate.getApplicationID() %>">
                                            <input type="hidden" name="jobID" value="<%= candidate.getJobID() %>">
                                            <button type="submit" class="btn-reject">
                                                <i class="fas fa-times"></i> Từ chối
                                            </button>
                                        </form>
                                    </div>
                                    <%
                                        }
                                    %>
                                </td>
                            </tr>
                            <% }
                            } else { %>
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 40px;">
                                    <p style="color: #999;"><%= (q != null && !q.trim().isEmpty()) ? "Không tìm thấy ứng viên phù hợp từ khóa." : "Chưa có ứng viên nào ứng tuyển cho công việc này." %></p>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <%
                    Integer curPage = (Integer) request.getAttribute("page");
                    Integer curPageSize = (Integer) request.getAttribute("pageSize");
                    Integer total = (Integer) request.getAttribute("total");
                    Integer totalPages = (Integer) request.getAttribute("totalPages");
                    if (curPage == null) curPage = 1;
                    if (curPageSize == null) curPageSize = 10;
                    if (total == null) total = 0;
                    if (totalPages == null) totalPages = 1;
                    Integer curJobId = (Integer) request.getAttribute("jobID");
                %>
                <c:if test="${total >= 1}">
                    <div class="pagination-container" style="margin-top: 12px; display:flex; align-items:center; justify-content: space-between;">
                        <div class="pagination-info">
                            <span>Trang <%= curPage %> / <%= totalPages %> (<%= total %> kết quả)</span>
                        </div>
                        <div class="pagination">
                            <c:if test="${page > 1}">
                                <a class="pagination-btn prev-btn" href="${pageContext.request.contextPath}/candidate-management?jobID=<%= curJobId %>&page=${page-1}&pageSize=${pageSize}${not empty param.q ? '&q=' : ''}${fn:escapeXml(param.q)}"><i class="fas fa-chevron-left"></i> Trước</a>
                            </c:if>
                            <c:set var="startPage" value="${page - 2 > 1 ? page - 2 : 1}" />
                            <c:set var="endPage" value="${page + 2 < totalPages ? page + 2 : totalPages}" />
                            <c:if test="${startPage > 1}">
                                <a class="pagination-btn" href="${pageContext.request.contextPath}/candidate-management?jobID=<%= curJobId %>&page=1&pageSize=${pageSize}${not empty param.q ? '&q=' : ''}${fn:escapeXml(param.q)}">1</a>
                                <c:if test="${startPage > 2}"><span class="pagination-dots">...</span></c:if>
                            </c:if>
                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                <a class="pagination-btn ${i == page ? 'active' : ''}" href="${pageContext.request.contextPath}/candidate-management?jobID=<%= curJobId %>&page=${i}&pageSize=${pageSize}${not empty param.q ? '&q=' : ''}${fn:escapeXml(param.q)}">${i}</a>
                            </c:forEach>
                            <c:if test="${endPage < totalPages}">
                                <c:if test="${endPage < totalPages - 1}"><span class="pagination-dots">...</span></c:if>
                                <a class="pagination-btn" href="${pageContext.request.contextPath}/candidate-management?jobID=<%= curJobId %>&page=${totalPages}&pageSize=${pageSize}${not empty param.q ? '&q=' : ''}${fn:escapeXml(param.q)}">${totalPages}</a>
                            </c:if>
                            <c:if test="${page < totalPages}">
                                <a class="pagination-btn next-btn" href="${pageContext.request.contextPath}/candidate-management?jobID=<%= curJobId %>&page=${page+1}&pageSize=${pageSize}${not empty param.q ? '&q=' : ''}${fn:escapeXml(param.q)}">Sau <i class="fas fa-chevron-right"></i></a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>

        <footer class="footer">
            <div class="retention-notice">
                <i class="fas fa-info-circle"></i>
                Hồ sơ sẽ được lưu trữ tại trang Quản Lý Tuyển Dụng lên tới 24 tháng.
            </div>
            <div class="copyright">
                Bản Quyền © Công Ty Cổ Phần Navigos Group Việt Nam
                <div>Tầng 20, Tòa nhà E.Town Central, 11 Đoàn Văn Bơ, Phường 13, Quận 4, TP.HCM, Vietnam</div>
            </div>
        </footer>
    <script>
        function changeJob(jobId) {
            try {
                var params = new URLSearchParams(window.location.search);
                var q = params.get('q');
                var url = '${pageContext.request.contextPath}/candidate-management?jobID=' + encodeURIComponent(jobId);
                if (q) {
                    url += '&q=' + encodeURIComponent(q);
                }
                window.location.href = url;
            } catch (e) {
                window.location.href = '${pageContext.request.contextPath}/candidate-management?jobID=' + jobId;
            }
        }
    </script>
    <script src="${pageContext.request.contextPath}/Recruiter/candidate-management.js"></script>
</body>
</html>
