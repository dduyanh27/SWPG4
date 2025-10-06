<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO, dal.RecruiterDAO, dal.JobSeekerDAO, java.util.List, model.Admin, model.Recruiter, model.JobSeeker" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="dal.AdminJobDAO" %>
<%@ page import="model.Job" %>
<%@ page import="model.AdminJobDetail" %>

<%
    AdminJobDAO ajd = new AdminJobDAO();
    List<Job> jobList = ajd.getAllJobs();
    request.setAttribute("jobList", jobList);
    List<Job> pendingJobs = ajd.getJobsByStatus("Pending");
    request.setAttribute("pendingJobs", pendingJobs);
    List<Job> publishedJobs = ajd.getJobsByStatus("Published");
    request.setAttribute("publishedJobs", publishedJobs);
    
    AdminJobDAO dao = new AdminJobDAO();
    List<AdminJobDetail> jobDetails = dao.getAllDetailJob();
    request.setAttribute("jobDetails", jobDetails);

    String view = request.getParameter("view");
    boolean showingPending = "pending".equalsIgnoreCase(view);
    request.setAttribute("showingPending", showingPending);
    if (showingPending) {
        request.setAttribute("jobList", pendingJobs);
    }
%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Jobs Admin - Quản lý tin tuyển dụng</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/ad-jobpos.css">
    </head>
    <body>
        <button class="mobile-menu-toggle" onclick="toggleSidebar()" style="display: none;">
            ☰
        </button>

        <div class="container">
            <div class="unified-sidebar" id="unifiedSidebar">
                <div class="sidebar-brand">
                    <h1 class="brand-title">JOBs</h1>
                    <p class="brand-subtitle">Admin Dashboard</p>
                </div>

                <div class="sidebar-profile">
                    <div class="sidebar-avatar">
                        <div class="sidebar-avatar-placeholder">A</div>
                    </div>
                    <div class="sidebar-admin-name">${sessionScope.admin.fullName}</div>
                    <div class="sidebar-admin-role">🛡️ Quản trị viên</div>
                    <span class="sidebar-status">Hoạt động</span>
                </div>

                <nav class="sidebar-nav">
                    <div class="nav-title">Menu chính</div>
                    <a href="${pageContext.request.contextPath}/Admin/admin-dashboard.jsp" class="nav-item">📊 Bảng thống kê</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-jobposting-management.jsp" class="nav-item active">💼 Tin tuyển dụng</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-manage-account.jsp" class="nav-item">👥 Quản lý tài khoản</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-cv-management.jsp" class="nav-item">📁 Quản lý CV</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-staff.jsp" class="nav-item">🏢  Quản lý nhân sự</a>
                    <a href="#" class="nav-item">💳 Quản lý thanh toán</a>
                </nav>

                <div class="sidebar-actions">
                    <a href="${pageContext.request.contextPath}/Admin/admin-profile.jsp" class="action-btn">👤 Hồ sơ cá nhân</a>
                    <a href="#" class="action-btn logout">🚪 Đăng xuất</a>
                </div>
            </div>

            <div class="main">
                <header class="topbar">
                    <div class="title">Quản lý công việc</div>
                    <div class="topbar-actions">
                        <button class="btn btn-ghost btn-sm">🔄 Làm mới</button>
                        <button class="btn btn-primary btn-sm" onclick="showCreateJobModal()">➕ Tạo tin mới</button>
                    </div>
                </header>

                <main class="content">
                    <!-- Statistics Cards -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">💼</div>
                                <div class="stat-trend trend-up">↗️ +12%</div>
                            </div>
                            <div class="stat-value">${fn:length(jobList)}</div>
                            <div class="stat-label">Tổng tin tuyển dụng</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">✅</div>
                                <div class="stat-trend trend-up">↗️ +8%</div>
                            </div>
                            <div class="stat-value">${fn:length(publishedJobs)}</div>
                            <div class="stat-label">Đã duyệt</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">⏳</div>
                                <div class="stat-trend trend-down">↘️ -5%</div>
                            </div>
                            <div class="stat-value">${fn:length(pendingJobs)}</div>
                            <div class="stat-label">Chờ duyệt</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">📊</div>
                                <div class="stat-trend trend-up">↗️ +23%</div>
                            </div>
                            <div class="stat-value">15,439</div>
                            <div class="stat-label">Lượt ứng tuyển</div>
                        </div>
                    </div>

                    <!-- Controls Section -->
                    <div class="controls-section">
                        <div class="controls-header">
                            <div class="section-title">🔍 Tìm kiếm & Bộ lọc</div>
                            <button class="btn btn-ghost btn-sm" onclick="resetFilters()">↺ Đặt lại</button>
                        </div>

                        <div class="filters-grid">
                            <div class="filter-group">
                                <label class="filter-label">Tìm kiếm</label>
                                <input type="text" class="filter-input" placeholder="Tên công việc, công ty..." id="searchInput">
                            </div>

                            <div class="filter-group">
                                <label class="filter-label">Địa điểm</label>
                                <select class="filter-input" id="locationFilter">
                                    <option value="">Tất cả địa điểm</option>
                                    <option value="hanoi">Hà Nội</option>
                                    <option value="hcm">TP. Hồ Chí Minh</option>
                                    <option value="danang">Đà Nẵng</option>
                                    <option value="other">Khác</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label class="filter-label">Loại hình</label>
                                <select class="filter-input" id="typeFilter">
                                    <option value="">Tất cả loại hình</option>
                                    <option value="fulltime">Toàn thời gian</option>
                                    <option value="parttime">Bán thời gian</option>
                                    <option value="contract">Hợp đồng</option>
                                    <option value="internship">Thực tập</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label class="filter-label">Trạng thái</label>
                                <select class="filter-input" id="statusFilter">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="active">Đang hoạt động</option>
                                    <option value="pending">Chờ duyệt</option>
                                    <option value="expired">Đã hết hạn</option>
                                    <option value="draft">Bản nháp</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label class="filter-label">Danh mục</label>
                                <select class="filter-input" id="categoryFilter">
                                    <option value="">Tất cả danh mục</option>
                                    <option value="it">Công nghệ thông tin</option>
                                    <option value="marketing">Marketing</option>
                                    <option value="sales">Kinh doanh</option>
                                    <option value="hr">Nhân sự</option>
                                    <option value="finance">Tài chính</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label class="filter-label">Mức lương</label>
                                <select class="filter-input" id="salaryFilter">
                                    <option value="">Tất cả mức lương</option>
                                    <option value="0-10">Dưới 10 triệu</option>
                                    <option value="10-20">10-20 triệu</option>
                                    <option value="20-30">20-30 triệu</option>
                                    <option value="30+">Trên 30 triệu</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Job Listings Table -->
                    <div class="data-table-container">
                        <div class="table-header">
                            <div class="table-title">📋 Danh sách công việc</div>
                            <div class="table-actions">
                                <c:choose>
                                    <c:when test="${showingPending}">
                                        <a class="btn btn-ghost btn-sm" href="${pageContext.request.contextPath}/Admin/admin-jobposting-management.jsp">📋 Tất cả</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="btn btn-ghost btn-sm" href="${pageContext.request.contextPath}/Admin/admin-jobposting-management.jsp?view=pending">📤 Danh sách chờ duyệt</a>
                                    </c:otherwise>
                                </c:choose>
                                <button class="btn btn-success btn-sm" onclick="bulkApprove()">✅ Duyệt hàng loạt</button>
                            </div>
                        </div>


                        <!-- Bang -->
                        <div class="table-wrapper">
                            <table id="jobsTable">
                                <thead>
                                    <tr>
                                        <th><input type="checkbox" id="selectAll"></th>
                                        <th class="sortable" onclick="sortTable(1)">Công việc</th>
                                        <th class="sortable" onclick="sortTable(2)">Công ty</th>
                                        <th class="sortable" onclick="sortTable(3)">Danh mục</th>
                                        <th class="sortable" onclick="sortTable(4)">Mức lương</th>
                                        <th class="sortable" onclick="sortTable(5)">Địa điểm</th>
                                        <th class="sortable" onclick="sortTable(6)">Ứng viên</th>
                                        <th class="sortable" onclick="sortTable(7)">Trạng thái</th>
                                        <th class="sortable" onclick="sortTable(8)">Ngày tạo</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody id="jobsTableBody">
                                    <c:choose>
                                        <c:when test="${empty jobDetails}">
                                            <tr>
                                                <td colspan="10" style="text-align: center; padding: 20px;">
                                                    <div style="color: #666;">
                                                        <p>Không có dữ liệu job nào được tìm thấy.</p>
                                                        <p>Debug: jobList size = ${fn:length(jobList)}</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="jobDetail" items="${jobDetails}">
                                                <c:if test="${( !showingPending || jobDetail.status eq 'Pending') && jobDetail.status ne 'Closed'}">
                                                <tr>
                                                    <td><input type="checkbox" class="row-select" value="${jobDetail.jobId}"></td>
                                                    <td>
                                                        <div class="job-info">
                                                            <div class="job-title">${jobDetail.jobTitle}</div>
                                                            <div class="job-meta">
                                                                <span>${jobDetail.requirements}</span>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>${jobDetail.recruiterName}</td>
                                                    <td>${jobDetail.categoryName}</td>
                                                    <td><div class="salary-range">${jobDetail.salaryRange}</div></td>
                                                    <td>${jobDetail.locationName}</td>
                                                    <td>-</td>
                                                    <td>${jobDetail.status}</td>
                                                    <td><div>-</div></td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <button class="btn btn-ghost btn-sm" onclick="viewJob('${jobDetail.jobId}')">👁️</button>
                                                            <button class="btn btn-primary btn-sm" onclick="editJob('${jobDetail.jobId}')">✏️</button>
                                                            <button class="btn btn-danger btn-sm" onclick="deleteJob('${jobDetail.jobId}')">🗑️</button>
                                                            <c:if test="${jobDetail.status eq 'Pending'}">
                                                                 <form action="${pageContext.request.contextPath}/adminapprovejobpost" method="post" style="display:inline-block;">
                                                                     <input type="hidden" name="jobId" value="${jobDetail.jobId}" />
                                                                    <button type="submit" class="btn btn-success btn-sm">✅ Duyệt</button>
                                                                </form>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                                </c:if>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>


                            </table>
                        </div>


                    </div>
                    <form id="bulkApproveForm" action="${pageContext.request.contextPath}/adminapprovejobpost" method="post" style="display:none;">
                    </form>
                    <form id="deleteJobForm" action="${pageContext.request.contextPath}/adminclosejobpost" method="post" style="display:none;">
                        <input type="hidden" name="jobId" id="deleteJobId" />
                    </form>
                </main>
            </div>
        </div>

        <!-- Job Detail Modal -->
        <div id="jobDetailModal" class="modal-overlay" style="display: none;">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="modal-title">📋 Chi tiết tin tuyển dụng</div>
                    <button class="modal-close" onclick="closeModal('jobDetailModal')">&times;</button>
                </div>
                <div id="jobDetailContent">
                    <!-- Job details will be loaded here -->
                </div>
            </div>
        </div>

        <!-- Create/Edit Job Modal -->
        <div id="createJobModal" class="modal-overlay" style="display: none;">
            <div class="modal-content" style="max-width: 1000px;">
                <div class="modal-header">
                    <div class="modal-title">➕ Tạo tin tuyển dụng mới</div>
                    <button class="modal-close" onclick="closeModal('createJobModal')">&times;</button>
                </div>
                <div id="createJobForm">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                        <div class="filter-group">
                            <label class="filter-label">Tiêu đề công việc *</label>
                            <input type="text" class="filter-input" placeholder="VD: Senior Frontend Developer">
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Công ty *</label>
                            <select class="filter-input">
                                <option>Chọn công ty</option>
                                <option>TechGlobal Solutions</option>
                                <option>Digital Marketing Pro</option>
                                <option>StartupTech Vietnam</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Danh mục *</label>
                            <select class="filter-input">
                                <option>Chọn danh mục</option>
                                <option>Công nghệ thông tin</option>
                                <option>Marketing</option>
                                <option>Thiết kế</option>
                                <option>Dữ liệu</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Loại hình *</label>
                            <select class="filter-input">
                                <option>Toàn thời gian</option>
                                <option>Bán thời gian</option>
                                <option>Hợp đồng</option>
                                <option>Thực tập</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Mức lương tối thiểu (VND)</label>
                            <input type="number" class="filter-input" placeholder="15000000">
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Mức lương tối đa (VND)</label>
                            <input type="number" class="filter-input" placeholder="25000000">
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Địa điểm *</label>
                            <select class="filter-input">
                                <option>Hà Nội</option>
                                <option>TP. Hồ Chí Minh</option>
                                <option>Đà Nẵng</option>
                                <option>Khác</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Kinh nghiệm yêu cầu</label>
                            <select class="filter-input">
                                <option>Chưa có kinh nghiệm</option>
                                <option>Dưới 1 năm</option>
                                <option>1-2 năm</option>
                                <option>3-5 năm</option>
                                <option>Trên 5 năm</option>
                            </select>
                        </div>
                    </div>

                    <div class="filter-group" style="margin-bottom: 20px;">
                        <label class="filter-label">Mô tả công việc *</label>
                        <textarea class="filter-input" rows="5" placeholder="Mô tả chi tiết về công việc, trách nhiệm, yêu cầu..."></textarea>
                    </div>

                    <div class="filter-group" style="margin-bottom: 20px;">
                        <label class="filter-label">Yêu cầu ứng viên</label>
                        <textarea class="filter-input" rows="4" placeholder="Các yêu cầu về kỹ năng, trình độ, kinh nghiệm..."></textarea>
                    </div>

                    <div class="filter-group" style="margin-bottom: 20px;">
                        <label class="filter-label">Quyền lợi</label>
                        <textarea class="filter-input" rows="3" placeholder="Các quyền lợi, phúc lợi cho ứng viên..."></textarea>
                    </div>

                    <div style="display: flex; gap: 10px; justify-content: flex-end;">
                        <button class="btn btn-ghost" onclick="closeModal('createJobModal')">Hủy</button>
                        <button class="btn btn-primary">Lưu nháp</button>
                        <button class="btn btn-success">Đăng ngay</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <script>
        (function () {
            var selectAll = document.getElementById('selectAll');
            if (selectAll) {
                selectAll.addEventListener('change', function () {
                    var checks = document.querySelectorAll('.row-select');
                    for (var i = 0; i < checks.length; i++) {
                        checks[i].checked = this.checked;
                    }
                });
            }
        })();

        function bulkApprove() {
            var selected = document.querySelectorAll('.row-select:checked');
            if (selected.length === 0) {
                alert('Vui lòng chọn ít nhất 1 tin để duyệt.');
                return;
            }
            var form = document.getElementById('bulkApproveForm');
            form.innerHTML = '';
            for (var i = 0; i < selected.length; i++) {
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'jobId';
                input.value = selected[i].value;
                form.appendChild(input);
            }
            form.submit();
        }

        function deleteJob(jobId) {
            if (!jobId) return;
            var confirmMsg = 'Bạn có chắc chắn muốn xóa/đóng tin tuyển dụng này?';
            if (!confirm(confirmMsg)) return;
            var input = document.getElementById('deleteJobId');
            if (!input) return;
            input.value = jobId;
            var form = document.getElementById('deleteJobForm');
            if (form) form.submit();
        }
    </script>
</html>
