<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AccountDAO,java.util.List,model.Account" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Jobs Admin - Quản lý tin tuyển dụng</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <style>
            :root{
                --bg-dark-1: #031428;   /* Very dark left */
                --bg-dark-2: #062446;   /* Mid */
                --bg-bright:  #0a67ff;  /* Bright right */
                --card-dark:  rgba(6,24,44,0.85);
                --card-light: rgba(255,255,255,0.02);
                --muted: rgba(255,255,255,0.75);
                --muted-2: rgba(255,255,255,0.6);
                --primary:#2f80ed;
                --danger:#ff5a6b;
                --success:#00d68f;
                --radius:10px;
                --shadow: 0 10px 30px rgba(2,10,30,0.6);
            }

            *{
                box-sizing:border-box
            }
            html,body{
                height:100%
            }
            body{
                margin:0;
                font-family:Inter, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
                background: linear-gradient(110deg, var(--bg-dark-1) 0%, var(--bg-dark-2) 40%, #083d9a 70%, var(--bg-bright) 100%);
                color: var(--muted);
                -webkit-font-smoothing:antialiased;
                -moz-osx-font-smoothing:grayscale;
                font-size:14px;
                min-height:100vh;
                position:relative;
                overflow-x:hidden;
            }

            /* faint spotlight on right like screenshot */
            body::after{
                content:"";
                position:fixed;
                right:-20%;
                top:0;
                width:45%;
                height:100%;
                background: radial-gradient(circle at left center, rgba(10,103,255,0.08), transparent 35%);
                pointer-events:none;
            }

            .container {
                display: flex;
            }

            /* Unified left sidebar combining navigation and admin profile */
            .unified-sidebar {
                position: fixed;
                left: 0;
                top: 0;
                width: 280px;
                height: 100vh;
                background: linear-gradient(180deg, rgba(3,18,40,0.95), rgba(6,24,44,0.95));
                backdrop-filter: blur(15px);
                border-right: 1px solid rgba(255,255,255,0.1);
                box-shadow: 4px 0 20px rgba(0,0,0,0.3);
                z-index: 1000;
                overflow-y: auto;
                padding: 20px;
                box-sizing: border-box;
            }

            .sidebar-brand {
                text-align: center;
                margin-bottom: 25px;
                padding-bottom: 20px;
                border-bottom: 1px solid rgba(255,255,255,0.1);
            }

            .brand-title {
                font-size: 24px;
                font-weight: 700;
                color: #00e5ff;
                margin: 0;
            }

            .brand-subtitle {
                font-size: 12px;
                color: rgba(255,255,255,0.6);
                margin-top: 5px;
            }

            /* Admin profile section in sidebar */
            .sidebar-profile {
                background: rgba(255,255,255,0.08);
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 25px;
                text-align: center;
                border: 1px solid rgba(255,255,255,0.05);
            }

            .sidebar-avatar {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                border: 2px solid #00e5ff;
                margin: 0 auto 12px;
                overflow: hidden;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .sidebar-avatar:hover {
                transform: scale(1.05);
                border-color: #40c4ff;
            }

            .sidebar-avatar img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .sidebar-avatar-placeholder {
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, #00e5ff, #0288d1);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                color: white;
                font-weight: bold;
            }

            .sidebar-admin-name {
                font-size: 16px;
                font-weight: 600;
                color: #ffffff;
                margin-bottom: 5px;
            }

            .sidebar-admin-role {
                font-size: 12px;
                color: #00e5ff;
                margin-bottom: 12px;
            }

            .sidebar-status {
                display: inline-block;
                padding: 3px 8px;
                border-radius: 10px;
                font-size: 10px;
                font-weight: 600;
                text-transform: uppercase;
                background: rgba(76,175,80,0.2);
                color: #4caf50;
                border: 1px solid rgba(76,175,80,0.3);
            }

            /* Navigation in sidebar */
            .sidebar-nav {
                margin-bottom: 25px;
            }

            .nav-title {
                font-size: 12px;
                font-weight: 600;
                color: rgba(255,255,255,0.6);
                text-transform: uppercase;
                margin-bottom: 15px;
                padding-left: 12px;
            }

            .nav-item {
                display: block;
                padding: 12px 16px;
                border-radius: 8px;
                color: rgba(255,255,255,0.8);
                text-decoration: none;
                font-weight: 500;
                font-size: 14px;
                margin-bottom: 5px;
                transition: all 0.3s ease;
                position: relative;
            }

            .nav-item:hover,
            .nav-item.active {
                background: rgba(0,229,255,0.15);
                color: #ffffff;
                transform: translateX(5px);
            }

            .nav-item.active::before {
                content: '';
                position: absolute;
                left: 0;
                top: 50%;
                transform: translateY(-50%);
                width: 3px;
                height: 20px;
                background: #00e5ff;
                border-radius: 0 2px 2px 0;
            }

            /* Quick actions in sidebar */
            .sidebar-actions {
                margin-top: auto;
                padding-top: 20px;
                border-top: 1px solid rgba(255,255,255,0.1);
            }

            .action-btn {
                display: block;
                width: 100%;
                padding: 10px 16px;
                background: rgba(0,229,255,0.1);
                border: 1px solid rgba(0,229,255,0.2);
                border-radius: 8px;
                color: #ffffff;
                text-decoration: none;
                font-size: 13px;
                font-weight: 500;
                text-align: center;
                margin-bottom: 8px;
                transition: all 0.3s ease;
            }

            .action-btn:hover {
                background: rgba(0,229,255,0.2);
                border-color: rgba(0,229,255,0.4);
            }

            .action-btn.logout {
                background: rgba(255,107,107,0.1);
                border-color: rgba(255,107,107,0.2);
                color: #ff6b6b;
            }

            .action-btn.logout:hover {
                background: rgba(255,107,107,0.2);
                border-color: rgba(255,107,107,0.4);
            }

            /* Main content adjusted for sidebar */
            .main {
                margin-left: 280px;
                padding: 0;
                width: calc(100% - 280px);
                box-sizing: border-box;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            /* Topbar */
            .topbar{
                height:70px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                background:linear-gradient(90deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));
                padding:0 20px;
                border-bottom:1px solid rgba(255,255,255,0.03);
                backdrop-filter:blur(10px);
                color: var(--muted);
            }

            .topbar .title{
                font-weight:700;
                color:#eaf4ff;
                font-size:20px;
            }

            /* Content */
            .content{
                padding:28px;
                max-width:1200px;
                margin:0 auto;
                width:100%;
                flex: 1;
            }

            .card{
                background: linear-gradient(180deg, var(--card-dark), rgba(6,24,44,0.6));
                border-radius:var(--radius);
                padding:18px;
                box-shadow:var(--shadow);
                border:1px solid rgba(255,255,255,0.03);
                color: #eaf4ff;
            }

            .card .card-title{
                font-size:16px;
                font-weight:600;
                color:#f8fcff;
                margin-bottom:12px;
            }

            /* Table */
            .table-wrap{
                overflow-x:auto;
            }
            table{
                width:100%;
                border-collapse:collapse;
                min-width:900px;
                font-size:13px;
                color: #eaf4ff;
            }
            thead th{
                text-align:left;
                padding:14px 12px;
                background: rgba(255,255,255,0.03);
                color: rgba(255,255,255,0.75);
                font-weight:600;
                border-bottom:1px solid rgba(255,255,255,0.04);
                vertical-align:middle;
            }
            tbody td{
                padding:14px 12px;
                border-bottom:1px solid rgba(255,255,255,0.02);
                vertical-align:middle;
                color:#eaf4ff;
            }
            tbody tr:hover{
                background: rgba(255,255,255,0.01)
            }
            .id-col{
                width:48px;
                color:rgba(255,255,255,0.6);
                font-weight:600
            }
            .job-title{
                font-weight:600;
                color:#ffffff
            }
            .muted{
                color:var(--muted-2);
                font-size:13px
            }
            .center{
                text-align:center
            }

            /* buttons */
            .btn{
                display:inline-block;
                padding:8px 12px;
                border-radius:6px;
                font-weight:600;
                font-size:13px;
                cursor:pointer;
                border:0;
                box-shadow: 0 6px 16px rgba(2,10,30,0.45);
            }
            .btn.confirm{
                background:linear-gradient(90deg,var(--primary),#0b63ff);
                color:#fff
            }
            .btn.danger{
                background:linear-gradient(90deg,#ff5a6b,#e74c3c);
                color:#fff
            }
            .btn.ghost{
                background:transparent;
                border:1px solid rgba(255,255,255,0.06);
                color:var(--primary)
            }

            /* status */
            .status{
                display:inline-block;
                padding:6px 10px;
                border-radius:999px;
                font-weight:600;
                font-size:12px;
            }
            .status.ok{
                background: rgba(0,255,150,0.06);
                color:#bff7d6
            }
            .status.pending{
                background: rgba(255,215,90,0.06);
                color:#ffe8a6
            }

            /* Employer link styling */
            .employer-link{
                color:var(--primary);
                text-decoration:none;
                font-weight:600;
            }
            .employer-link:hover{
                color:#fff;
                text-decoration:underline;
            }

            /* Mobile menu toggle */
            .mobile-menu-toggle{
                display:none;
                position:fixed;
                top:20px;
                left:20px;
                z-index:1001;
                background:rgba(0,229,255,0.9);
                color:#fff;
                border:none;
                border-radius:8px;
                width: 45px;
                height: 45px;
                cursor:pointer;
                font-size: 18px;
                box-shadow: 0 4px 15px rgba(0,229,255,0.3);
            }

            /* Responsive */
            @media (max-width: 1024px) {
                .unified-sidebar {
                    transform: translateX(-100%);
                    transition: transform 0.3s ease;
                }

                .unified-sidebar.show {
                    transform: translateX(0);
                }

                .main {
                    margin-left: 0;
                    width: 100%;
                }

                .mobile-menu-toggle {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
            }

            @media (max-width:768px) {
                .content{
                    padding:14px
                }
                table{
                    min-width:700px
                }
                .unified-sidebar {
                    width: 260px;
                }
            }

            @media (min-width: 1025px) {
                .mobile-menu-toggle {
                    display: none;
                }
            }
        </style>
    </head>
    <body>
        <!-- Mobile menu toggle button for responsive design -->
        <button class="mobile-menu-toggle" onclick="toggleSidebar()" style="display: none;">
            ☰
        </button>

        <div class="container">
            <!-- Unified sidebar combining navigation and admin profile -->
            <div class="unified-sidebar" id="unifiedSidebar">
                <!-- Brand section -->
                <div class="sidebar-brand">
                    <h1 class="brand-title">JOBs</h1>
                    <p class="brand-subtitle">Admin Dashboard</p>
                </div>

                <!-- Admin profile section -->
                <div class="sidebar-profile">
                    <div class="sidebar-avatar">
                        <c:choose>
                            <c:when test="${not empty adminProfile.avatarURL}">
                                <img src="${adminProfile.avatarURL}" alt="Avatar">
                            </c:when>
                            <c:otherwise>
                                <div class="sidebar-avatar-placeholder">
                                    ${fn:substring(sessionScope.admin.fullName, 0, 1)}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="sidebar-admin-name">
                        <c:choose>
                            <c:when test="${not empty sessionScope.admin}">
                                ${sessionScope.admin.fullName}
                            </c:when>
                            <c:otherwise>
                                Quản trị viên
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="sidebar-admin-role">🛡️ Quản trị viên</div>
                    <span class="sidebar-status">Hoạt động</span>
                </div>

                <!-- Navigation section -->
                <nav class="sidebar-nav">
                    <div class="nav-title">Menu chính</div>
                    <a href="admin-dashboard.jsp" class="nav-item">📊 Bảng thống kê</a>
                    <a href="admin-jobposting-management.jsp" class="nav-item active">💼 Tin tuyển dụng</a>
                    <a href="admin-manage-account.jsp" class="nav-item">👥 Quản lý tài khoản</a>
                    <a href="#" class="nav-item">📁 Quản lý danh mục</a>
                    <a href="#" class="nav-item">📝 Đơn xin việc</a>
                    <a href="admin-profile.jsp" class="nav-item">👤 Hồ sơ cá nhân</a>
                </nav>

                <!-- Quick actions -->
                <div class="sidebar-actions">
                    <a href="admin-profile.jsp" class="action-btn">👤 Hồ sơ cá nhân</a>
                    <a href="logout" class="action-btn logout">🚪 Đăng xuất</a>
                </div>
            </div>

            <div class="main">
                <!-- Enhanced topbar -->
                <header class="topbar">
                    <div class="title">Quản lý tin tuyển dụng</div>
                </header>

                <main class="content">
                    <div class="card">
                        <div class="card-title">Danh sách tin tuyển dụng</div>

                        <div class="table-wrap">
                            <!-- Aggregated table: Nhà tuyển dụng | Danh mục | Số tin còn hoạt động -->
                            <table aria-label="Danh sách nhà tuyển dụng">
                                <thead>
                                    <tr>
                                        <th>Nhà tuyển dụng</th>
                                        <th>Danh mục</th>
                                        <th class="center">Số tin còn hoạt động</th>
                                    </tr>
                                </thead>
                                <tbody id="employers-table"></tbody>
                            </table>
                        </div>

                        <!-- Modal to show active jobs for an employer -->
                        <div id="jobsModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);align-items:center;justify-content:center;z-index:9999">
                            <div style="background:var(--card-dark);padding:18px;border-radius:10px;max-width:900px;width:90%;color:#eaf4ff;box-shadow:var(--shadow);">
                                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px">
                                    <div style="font-weight:700">Tin đang hoạt động</div>
                                    <button onclick="closeJobsModal()" style="background:transparent;border:0;color:var(--muted);font-weight:700;cursor:pointer">Đóng ✕</button>
                                </div>
                                <div id="modalJobsList" style="max-height:60vh;overflow:auto"></div>
                            </div>
                        </div>

                    </div>
                </main>
            </div>
        </div>

        
    </body>
</html>
