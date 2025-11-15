<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Job" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý tin đã đăng - Recruit Dashboard</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Recruiter/styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            /* Job Management Specific Styles */
            .job-management-page {
                background-color: #f5f7fa;
                min-height: 100vh;
            }

            .main-content {
                max-width: 1400px;
                margin: 0 auto;
                padding: 20px;
            }

            .job-management-main {
                background: white;
                border-radius: 12px;
                padding: 0;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            /* Filter Tabs */
            .filter-tabs {
                display: flex;
                border-bottom: 1px solid #e5e7eb;
                padding: 0 20px;
                background: white;
                border-radius: 12px 12px 0 0;
            }

            .tab {
                padding: 15px 20px;
                cursor: pointer;
                border-bottom: 3px solid transparent;
                color: #6b7280;
                font-weight: 500;
                transition: all 0.3s ease;
                position: relative;
            }

            .tab.active {
                color: #2563eb;
                border-bottom-color: #2563eb;
                background: #f8fafc;
            }

            .tab:hover {
                color: #2563eb;
                background: #f8fafc;
            }

            /* Action Bar */
            .action-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px;
                border-bottom: 1px solid #e5e7eb;
                background: white;
            }

            .search-container {
                flex: 1;
                max-width: 800px;
            }

            .search-box {
                position: relative;
                display: flex;
                align-items: center;
            }

            .search-box i {
                position: absolute;
                left: 12px;
                color: #9ca3af;
                z-index: 1;
            }

            .search-box input {
                width: 100%;
                padding: 10px 12px 10px 40px;
                border: 1px solid #d1d5db;
                border-radius: 8px;
                font-size: 14px;
                outline: none;
                transition: border-color 0.3s ease;
            }

            .search-box input:focus {
                border-color: #2563eb;
            }

            .action-buttons {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .btn-excel {
                background: white;
                color: #059669;
                border: 1px solid #059669;
                padding: 10px 16px;
                border-radius: 8px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .btn-excel:hover {
                background: #059669;
                color: white;
            }

            .btn-filter {
                background: white;
                color: #6b7280;
                border: 1px solid #d1d5db;
                padding: 10px;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-filter:hover {
                background: #f3f4f6;
                color: #374151;
            }

            /* Job List */
            .job-list {
                padding: 0;
            }

            /* Column Header */
            .column-header {
                font-size: 14px;
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .job-item {
                display: grid;
                grid-template-columns: 2fr 1.5fr 1fr 1fr 1fr;
                gap: 20px;
                padding: 20px;
                border-bottom: 1px solid #e5e7eb;
                align-items: start;
            }

            .job-item:last-child {
                border-bottom: none;
            }

            .job-item:hover {
                background: #f8fafc;
            }

            /* Job Title Section */
            .job-title-section {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }


            .job-title {
                font-size: 16px;
                font-weight: 600;
                color: #2563eb;
                margin: 0;
                line-height: 1.4;
            }

            .job-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 12px;
                align-items: center;
                font-size: 12px;
                color: #6b7280;
            }

            .job-id {
                background: #f3f4f6;
                padding: 2px 6px;
                border-radius: 4px;
                font-weight: 500;
            }

            .views {
                display: flex;
                align-items: center;
                gap: 4px;
            }

            .category {
                background: #dbeafe;
                color: #1e40af;
                padding: 2px 6px;
                border-radius: 4px;
                font-weight: 500;
            }

            .posted-by {
                color: #9ca3af;
            }

            .job-actions {
                display: flex;
                gap: 0px;
                align-items: center;
                margin-top: 8px;
            }

            .action-btn:not(:last-child) {
                margin-right: -60px;
            }

            .action-btn {
                background: none;
                border: none;
                color: #6b7280;
                cursor: pointer;
                padding: 1px;
                border-radius: 2px;
                transition: all 0.3s ease;
                font-size: 14px;
                width: 10px;
                height: 16px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .action-btn:hover {
                background: #f3f4f6;
                color: #374151;
            }

            .repost-btn {
                background: #f3f4f6;
                color: #374151;
                padding: 1px 3px;
                border-radius: 2px;
                font-size: 11px;
                font-weight: 500;
                height: 16px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-left: -60px;
            }

            .repost-btn:hover {
                background: #e5e7eb;
            }

            /* Service Section */
            .service-section {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .service-item {
                font-size: 12px;
                color: #6b7280;
                padding: 4px 8px;
                background: #f3f4f6;
                border-radius: 4px;
                display: inline-block;
            }

            .service-item.disabled {
                color: #9ca3af;
            }

            .service-items-container {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
                margin-bottom: 12px;
            }

            .service-buttons {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }


            .service-desc {
                font-size: 10px;
                color: #9ca3af;
                display: block;
                margin-top: 2px;
            }

            .btn-upgrade {
                background: white;
                color: #ef4444;
                border: 1px solid #ef4444;
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 8px;
                align-self: flex-start;
            }

            .btn-upgrade:hover {
                background: #ef4444;
                color: white;
            }

            .btn-view-cv {
                background: white;
                color: #ef4444;
                border: 2px solid #ef4444;
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 8px;
                align-self: flex-start;
                position: relative;
            }

            .btn-view-cv:hover {
                background: #ef4444;
                color: white;
            }

            .btn-view-cv::after {
                content: '2';
                position: absolute;
                top: -8px;
                right: -8px;
                background: #ef4444;
                color: white;
                border-radius: 50%;
                width: 16px;
                height: 16px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                font-weight: 600;
            }

            /* Expiration Section */
            .expiration-section {
                display: flex;
                flex-direction: column;
                gap: 4px;
            }

            .expiration-status {
                font-size: 12px;
                font-weight: 500;
            }

            .expiration-status.expired {
                color: #ef4444;
            }

            .expiration-dates {
                font-size: 11px;
                color: #6b7280;
            }

            /* Applications Section */
            .applications-section {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .application-count {
                font-size: 14px;
                font-weight: 500;
                color: #374151;
            }

            /* Refresh Section */
            .refresh-section {
                display: flex;
                align-items: center;
            }

            .last-refresh {
                font-size: 12px;
                color: #6b7280;
            }

            .refresh-date {
                display: block;
            }

            .refresh-time {
                display: block;
                color: #9ca3af;
            }

            /* Bottom Right Buttons */
            .bottom-buttons {
                position: fixed;
                bottom: 30px;
                right: 30px;
                display: flex;
                flex-direction: column;
                gap: 15px;
                z-index: 1000;
            }

            .three-dots-btn {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: #2563eb;
                color: white;
                border: none;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
                transition: all 0.3s ease;
            }

            .three-dots-btn:hover {
                background: #1d4ed8;
                transform: translateY(-2px);
            }

            .help-btn {
                background: #1f2937;
                color: white;
                border: none;
                padding: 12px 20px;
                border-radius: 25px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                font-weight: 500;
                box-shadow: 0 4px 15px rgba(31, 41, 55, 0.3);
                transition: all 0.3s ease;
            }

            .help-btn:hover {
                background: #111827;
                transform: translateY(-2px);
            }

            /* Responsive Design */
            @media (max-width: 1200px) {

                .job-item {
                    grid-template-columns: 1fr;
                    gap: 15px;
                }

                .job-title-section,
                .service-section,
                .expiration-section,
                .applications-section,
                .refresh-section {
                    border-bottom: 1px solid #e5e7eb;
                    padding-bottom: 15px;
                }
            }

            @media (max-width: 768px) {
                .main-content {
                    padding: 10px;
                }

                .filter-tabs {
                    flex-wrap: wrap;
                    padding: 0 10px;
                }

                .tab {
                    padding: 10px 15px;
                    font-size: 14px;
                }

                .action-bar {
                    flex-direction: column;
                    gap: 15px;
                    align-items: stretch;
                }

                .search-container {
                    max-width: none;
                }
            }
        </style>
    </head>
    <body class="job-management-page">
        <%
            // Guard: nếu truy cập trực tiếp JSP, chuyển hướng về servlet để nạp dữ liệu
            if (request.getAttribute("selectedTab") == null) {
                response.sendRedirect(request.getContextPath() + "/listpostingjobs?tab=active");
                return;
            }
        %>
        <!-- Navigation Bar -->
        <nav class="navbar">
            <div class="nav-container">
                <div class="nav-left">
                    <div class="logo">
                        <i class="fas fa-briefcase"></i>
                        <span>RecruitPro</span>
                    </div>
                    <ul class="nav-menu">
                        <li><a href="${pageContext.request.contextPath}/Recruiter/index.jsp">Dashboard</a></li>
                        <li><a href="#">Việc Làm</a></li>
                        <li class="dropdown">
                            <a href="#">Ứng viên <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/candidate-management">Quản lý theo việc đăng tuyển</a>
                                <a href="${pageContext.request.contextPath}/Recruiter/candidate-folder.html">Quản lý theo thư mục và thẻ</a>
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
                                <a href="#">Quản lý đơn hàng</a>
                                <a href="${pageContext.request.contextPath}/recruiter/purchase-history">Lịch sử mua</a>
                            </div>
                        </li>
                        <li><a href="#">Báo cáo</a></li>
                        <li><a href="${pageContext.request.contextPath}/Recruiter/company-info.jsp" class="company-link">Công ty</a></li>
                    </ul>
                </div>
                <div class="nav-right">
                    <div class="nav-buttons">
                        <div class="dropdown">
                            <button class="btn btn-orange active">
                                ĐĂNG TUYỂN DỤNG <i class="fas fa-chevron-down"></i>
                            </button>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/jobposting">Tạo tin tuyển dụng mới</a>
                                <a href="${pageContext.request.contextPath}/listpostingjobs" class="active">Quản lý tin đã đăng</a>
                            </div>
                        </div>
                        <button class="btn btn-blue" onclick="window.location.href='${pageContext.request.contextPath}/candidate-search'">TÌM ỨNG VIÊN</button>
                        <button class="btn btn-white" onclick="window.location.href='${pageContext.request.contextPath}/Recruiter/job-package.jsp'">Mua</button>
                    </div>
                    <div class="nav-icons">
                        <i class="fas fa-shopping-cart"></i>
                        <div class="dropdown user-dropdown">
                            <div class="user-avatar">
                                <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNGNUY3RkEiLz4KPHN2ZyB4PSIxMCIgeT0iMTAiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSIjOUNBM0FGIi8+CjxwYXRoIGQ9Ik0xMiAxNEM5LjMzIDE0IDcgMTYuMzMgNyAxOVYyMUgxN1YxOUMxNyAxNi4zMyAxNC42NyAxNCAxMiAxNFoiIGZpbGw9IiM5Q0EzQUYiLz4KPC9zdmc+Cjwvc3ZnPgo=" alt="User Avatar" class="avatar-img">
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

        <!-- Main Content -->
        <div class="main-content">
            <div class="job-management-main">
                <!-- Filter Tabs -->
                <%
                    String selectedTab = (String) request.getAttribute("selectedTab");
                    if (selectedTab == null) selectedTab = "active";
                    List aL = (List) request.getAttribute("activeJobs");
                    List eL = (List) request.getAttribute("expiredJobs");
                    List dL = (List) request.getAttribute("draftJobs");
                    List pL = (List) request.getAttribute("pendingJobs");
                    int aC = aL != null ? aL.size() : 0;
                    int eC = eL != null ? eL.size() : 0;
                    int dC = dL != null ? dL.size() : 0;
                    int pC = pL != null ? pL.size() : 0;
                    System.out.println("[JSP job-management] selectedTab=" + selectedTab + ", active=" + aC + ", expired=" + eC + ", draft=" + dC);
                %>
                <div class="filter-tabs">
                    <a class="tab <%= "active".equals(selectedTab) ? "active" : "" %>" href="<%= request.getContextPath() %>/listpostingjobs?tab=active">
                        <span>Đang Hiển Thị (<%= aC %>)</span>
                    </a>
                    <a class="tab <%= "expired".equals(selectedTab) ? "active" : "" %>" href="<%= request.getContextPath() %>/listpostingjobs?tab=expired">
                        <span>Đã Hết Hạn (<%= eC %>)</span>
                    </a>
                    <a class="tab <%= "draft".equals(selectedTab) ? "active" : "" %>" href="<%= request.getContextPath() %>/listpostingjobs?tab=draft">
                        <span>Nháp (<%= dC %>)</span>
                    </a>
                </div>

                <!-- Action Bar -->
                <div class="action-bar">
                    <div class="search-container">
                        <form class="search-box" method="get" action="<%= request.getContextPath() %>/listpostingjobs" style="display:flex; align-items:center; gap:8px;">
                            <i class="fas fa-search"></i>
                            <input type="text" name="q" placeholder="Tìm theo tiêu đề hoặc mã tin" value="<%= request.getAttribute("q") != null ? (String)request.getAttribute("q") : "" %>">
                            <select name="pkg" style="padding:8px 10px; border:1px solid #d1d5db; border-radius:8px; font-size:14px; color:#374151;">
                                <%
                                    String pkg = (String) request.getAttribute("pkg");
                                    if (pkg == null || pkg.isEmpty()) pkg = "all";
                                    java.util.List pkgNames = (java.util.List) request.getAttribute("pkgNames");
                                %>
                                <option value="all" <%= "all".equalsIgnoreCase(pkg) ? "selected" : "" %>>Tất cả gói</option>
                                <%
                                    if (pkgNames != null) {
                                        for (Object oName : pkgNames) {
                                            String name = String.valueOf(oName);
                                %>
                                <option value="<%= name %>" <%= name.equalsIgnoreCase(pkg) ? "selected" : "" %>><%= name %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                            <input type="hidden" name="tab" value="<%= selectedTab %>">
                            <input type="hidden" name="pageSize" value="<%= (request.getAttribute("pageSize") != null) ? (Integer)request.getAttribute("pageSize") : 5 %>">
                            <button type="submit" class="btn btn-filter">Lọc</button>
                        </form>
                    </div>
                </div>

                <!-- Job List - Đang Hiển Thị -->
                <div class="job-list" <% if (!"active".equals(selectedTab)) { %>style="display: none;"<% } %>>
                    <div class="column-header">Đang hiển thị</div>
                    <%
                        List jobs = (List) request.getAttribute("jobs");
                        if (jobs != null && !jobs.isEmpty()) {
                            for (Object o : jobs) {
                                Job j = (Job) o;
                    %>
                    <div class="job-item">
                        <div class="job-title-section">
                            <div class="column-header">Chức danh</div>
                            <h3 class="job-title"><%= j.getJobTitle() %></h3>
                            <div class="job-meta">
                                <span class="views"><i class="fas fa-eye"></i><%= j.getViewCount() %></span>
                                <span class="job-id">ID: <%= j.getJobID() %></span>
                            </div>
                            <div class="job-actions">
                                <a href="<%= request.getContextPath() %>/jobposting?jobID=<%= j.getJobID() %>" class="action-btn" title="Chỉnh sửa"><i class="fas fa-edit"></i></a>
                                <button class="action-btn" title="Sao chép"><i class="fas fa-copy"></i></button>
                                <button class="action-btn" title="Xem"><i class="fas fa-eye"></i></button>
                                <button class="action-btn" title="Thêm"><i class="fas fa-ellipsis-h"></i></button>
                                <button class="action-btn repost-btn" title="Đăng lại">Đăng lại</button>
                            </div>
                        </div>
                        <div class="service-section">
                            <div class="column-header">Dịch vụ</div>
                            <div class="service-items-container">
                                <div class="service-item"><span class="service-name">Đăng Tuyển Dụng</span></div>
                            </div>
                        </div>
                        <div class="expiration-section">
                            <div class="column-header">Hết hạn</div>
                            <div class="expiration-status"><span>Hết hạn: <%= j.getExpirationDate() != null ? j.getExpirationDate() : "-" %></span></div>
                        </div>
                        <div class="applications-section">
                            <div class="column-header">Hồ sơ ứng tuyển</div>
                            <div class="application-count">
                                <%
                                    Map<Integer, Integer> applicationCounts1 = (Map<Integer, Integer>) request.getAttribute("applicationCounts");
                                    int appCount1 = 0;
                                    if (applicationCounts1 != null && applicationCounts1.containsKey(j.getJobID())) {
                                        appCount1 = applicationCounts1.get(j.getJobID());
                                    }
                                %>
                                <span><%= appCount1 %></span>
                            </div>
                        </div>
                        
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div class="job-item">
                        <div class="job-title-section"><h3 class="job-title">Không có tin tuyển dụng nào</h3></div>
                    </div>
                    <%
                        }
                    %>
                </div>

                <!-- Job List - Đã Hết Hạn -->
                <div class="job-list" <% if (!"expired".equals(selectedTab)) { %>style="display: none;"<% } %>>
                    <div class="column-header">Đã hết hạn</div>
                    <%
                        List jobs2 = (List) request.getAttribute("jobs");
                        if (jobs2 != null && !jobs2.isEmpty()) {
                            for (Object o : jobs2) {
                                Job j = (Job) o;
                    %>
                    <div class="job-item">
                        <div class="job-title-section">
                            <div class="column-header">Chức danh</div>
                            <h3 class="job-title"><%= j.getJobTitle() %></h3>
                            <div class="job-meta">
                                <span class="views"><i class="fas fa-eye"></i><%= j.getViewCount() %></span>
                                <span class="job-id">ID: <%= j.getJobID() %></span>
                            </div>
                            <div class="job-actions">
                                <a href="<%= request.getContextPath() %>/jobposting?jobID=<%= j.getJobID() %>" class="action-btn" title="Chỉnh sửa"><i class="fas fa-edit"></i></a>
                                <button class="action-btn" title="Sao chép"><i class="fas fa-copy"></i></button>
                                <button class="action-btn" title="Xem"><i class="fas fa-eye"></i></button>
                                <button class="action-btn" title="Thêm"><i class="fas fa-ellipsis-h"></i></button>
                                <button class="action-btn repost-btn" title="Đăng lại">Đăng lại</button>
                            </div>
                        </div>
                        <div class="service-section">
                            <div class="column-header">Dịch vụ</div>
                            <div class="service-items-container">
                                <div class="service-item"><span class="service-name">Đăng Tuyển Dụng</span></div>
                            </div>
                        </div>
                        <div class="expiration-section">
                            <div class="column-header">Hết hạn</div>
                            <div class="expiration-status expired"><span>Hết hạn: <%= j.getExpirationDate() != null ? j.getExpirationDate() : "-" %></span></div>
                        </div>
                        <div class="applications-section">
                            <div class="column-header">Hồ sơ ứng tuyển</div>
                            <div class="application-count">
                                <%
                                    Map<Integer, Integer> applicationCounts2 = (Map<Integer, Integer>) request.getAttribute("applicationCounts");
                                    int appCount2 = 0;
                                    if (applicationCounts2 != null && applicationCounts2.containsKey(j.getJobID())) {
                                        appCount2 = applicationCounts2.get(j.getJobID());
                                    }
                                %>
                                <span><%= appCount2 %></span>
                            </div>
                        </div>
                        
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div class="job-item">
                        <div class="job-title-section"><h3 class="job-title">Không có tin hết hạn</h3></div>
                    </div>
                    <%
                        }
                    %>
                </div>

                <!-- Job List - Nháp -->
                <div class="job-list" <% if (!"draft".equals(selectedTab)) { %>style="display: none;"<% } %>>
                    <div class="column-header">Nháp</div>
                    <%
                        List jobs3 = (List) request.getAttribute("jobs");
                        if (jobs3 != null && !jobs3.isEmpty()) {
                            for (Object o : jobs3) {
                                Job j = (Job) o;
                    %>
                    <div class="job-item">
                        <div class="job-title-section">
                            <div class="column-header">Chức danh</div>
                            <h3 class="job-title"><%= j.getJobTitle() %></h3>
                            <div class="job-meta">
                                <span class="views"><i class="fas fa-eye"></i><%= j.getViewCount() %></span>
                                <span class="job-id">ID: <%= j.getJobID() %></span>
                            </div>
                            <div class="job-actions">
                                <a href="<%= request.getContextPath() %>/jobposting?jobID=<%= j.getJobID() %>" class="action-btn" title="Chỉnh sửa"><i class="fas fa-edit"></i></a>
                                <button class="action-btn" title="Sao chép"><i class="fas fa-copy"></i></button>
                                <button class="action-btn" title="Xem"><i class="fas fa-eye"></i></button>
                                <button class="action-btn" title="Thêm"><i class="fas fa-ellipsis-h"></i></button>
                                <button class="action-btn repost-btn" title="Đăng lại">Đăng lại</button>
                            </div>
                        </div>
                        <div class="service-section">
                            <div class="column-header">Dịch vụ</div>
                            <div class="service-items-container">
                                <div class="service-item"><span class="service-name">Đăng Tuyển Dụng</span></div>
                            </div>
                        </div>
                        <div class="expiration-section">
                            <div class="column-header">Hết hạn</div>
                            <div class="expiration-status"><span>Hết hạn: <%= j.getExpirationDate() != null ? j.getExpirationDate() : "-" %></span></div>
                        </div>
                        <div class="applications-section">
                            <div class="column-header">Hồ sơ ứng tuyển</div>
                            <div class="application-count">
                                <%
                                    Map<Integer, Integer> applicationCounts3 = (Map<Integer, Integer>) request.getAttribute("applicationCounts");
                                    int appCount3 = 0;
                                    if (applicationCounts3 != null && applicationCounts3.containsKey(j.getJobID())) {
                                        appCount3 = applicationCounts3.get(j.getJobID());
                                    }
                                %>
                                <span><%= appCount3 %></span>
                            </div>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div class="job-item">
                        <div class="job-title-section"><h3 class="job-title">Không có tin nháp</h3></div>
                    </div>
                    <%
                        }
                    %>
                </div>

                <!-- Removed 'Chờ duyệt' tab and list -->

                <!-- Pagination -->
                <%
                    Integer curPage = (Integer) request.getAttribute("page");
                    Integer curPageSize = (Integer) request.getAttribute("pageSize");
                    Integer total = (Integer) request.getAttribute("total");
                    Integer totalPages = (Integer) request.getAttribute("totalPages");
                    String tabParam = (String) request.getAttribute("selectedTab");
                    String qParam = (String) request.getAttribute("q");
                    String qEnc = (String) request.getAttribute("qEncoded");
                    String pkgParam = (String) request.getAttribute("pkg");
                    String pkgEnc = (String) request.getAttribute("pkgEncoded");
                    if (curPage == null) curPage = 1;
                    if (curPageSize == null) curPageSize = 5;
                    if (total == null) total = 0;
                    if (totalPages == null) totalPages = 1;
                %>
                <%
                    if (total >= 1) {
                        int startPage = (curPage - 2 > 1) ? curPage - 2 : 1;
                        int endPage = (curPage + 2 < totalPages) ? curPage + 2 : totalPages;
                %>
                <div class="pagination-container" style="padding: 16px 20px; display:flex; align-items:center; justify-content: space-between;">
                    <div class="pagination-info">
                        <span>Trang <%= curPage %> / <%= totalPages %> (<%= total %> kết quả)</span>
                    </div>
                    <div class="pagination">
                        <%
                            if (curPage > 1) {
                        %>
                        <a class="pagination-btn prev-btn" href="<%= request.getContextPath() %>/listpostingjobs?tab=<%= tabParam %>&page=<%= curPage - 1 %>&pageSize=<%= curPageSize %><%= (qEnc!=null && !qEnc.isEmpty())? ("&q="+qEnc) : "" %><%= (pkgEnc!=null && !pkgEnc.isEmpty())? ("&pkg="+pkgEnc) : (pkgParam!=null && !pkgParam.isEmpty()? ("&pkg="+pkgParam) : "") %>"><i class="fas fa-chevron-left"></i> Trước</a>
                        <%
                            }
                            if (startPage > 1) {
                        %>
                        <a class="pagination-btn" href="<%= request.getContextPath() %>/listpostingjobs?tab=<%= tabParam %>&page=1&pageSize=<%= curPageSize %><%= (qEnc!=null && !qEnc.isEmpty())? ("&q="+qEnc) : "" %><%= (pkgEnc!=null && !pkgEnc.isEmpty())? ("&pkg="+pkgEnc) : (pkgParam!=null && !pkgParam.isEmpty()? ("&pkg="+pkgParam) : "") %>">1</a>
                        <%
                                if (startPage > 2) {
                        %>
                        <span class="pagination-dots">...</span>
                        <%
                                }
                            }
                            for (int i = startPage; i <= endPage; i++) {
                                String activeCls = (i == curPage) ? " active" : "";
                        %>
                        <a class="pagination-btn<%= activeCls %>" href="<%= request.getContextPath() %>/listpostingjobs?tab=<%= tabParam %>&page=<%= i %>&pageSize=<%= curPageSize %><%= (qEnc!=null && !qEnc.isEmpty())? ("&q="+qEnc) : "" %><%= (pkgEnc!=null && !pkgEnc.isEmpty())? ("&pkg="+pkgEnc) : (pkgParam!=null && !pkgParam.isEmpty()? ("&pkg="+pkgParam) : "") %>"><%= i %></a>
                        <%
                            }
                            if (endPage < totalPages) {
                                if (endPage < totalPages - 1) {
                        %>
                        <span class="pagination-dots">...</span>
                        <%
                                }
                        %>
                        <a class="pagination-btn" href="<%= request.getContextPath() %>/listpostingjobs?tab=<%= tabParam %>&page=<%= totalPages %>&pageSize=<%= curPageSize %><%= (qEnc!=null && !qEnc.isEmpty())? ("&q="+qEnc) : "" %><%= (pkgEnc!=null && !pkgEnc.isEmpty())? ("&pkg="+pkgEnc) : (pkgParam!=null && !pkgParam.isEmpty()? ("&pkg="+pkgParam) : "") %>"><%= totalPages %></a>
                        <%
                            }
                            if (curPage < totalPages) {
                        %>
                        <a class="pagination-btn next-btn" href="<%= request.getContextPath() %>/listpostingjobs?tab=<%= tabParam %>&page=<%= curPage + 1 %>&pageSize=<%= curPageSize %><%= (qEnc!=null && !qEnc.isEmpty())? ("&q="+qEnc) : "" %><%= (pkgEnc!=null && !pkgEnc.isEmpty())? ("&pkg="+pkgEnc) : (pkgParam!=null && !pkgParam.isEmpty()? ("&pkg="+pkgParam) : "") %>">Sau <i class="fas fa-chevron-right"></i></a>
                        <%
                            }
                        %>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>

        <!-- Bottom Right Buttons -->
        <div class="bottom-buttons">
            <button class="three-dots-btn">
                <i class="fas fa-ellipsis-h"></i>
            </button>
            <button class="help-btn">
                <i class="fas fa-question"></i>
                Trợ giúp
            </button>
        </div>

        <script src="<%= request.getContextPath() %>/Recruiter/script.js"></script>
    </body>
</html>
