<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Danh sách công việc đã ứng tuyển</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
    <style>
        /* CSS Variables */
        :root {
            --bg-left: #061f3b;
            --bg-right: #0a67ff;
            --text-light: rgba(255,255,255,0.92);
            --text-light-muted: rgba(255,255,255,0.75);
            --text-dark: #21323b;
            --blue: #0a67ff;
            --blue-dark: #0b5bdf;
            --white: #ffffff;
            --shadow-sm: 0 2px 8px rgba(0,0,0,0.1);
            --shadow-md: 0 8px 25px rgba(0,0,0,0.15);
            --shadow-lg: 0 15px 35px rgba(0,0,0,0.2);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, var(--bg-left) 0%, var(--bg-right) 100%);
            color: var(--white);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        /* ========== HEADER ========== */
        .header {
            position: sticky;
            top: 0;
            z-index: 1200;
            background: rgba(6, 31, 59, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        }

        .header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            padding: 16px 32px;
            max-width: 1400px;
            margin: 0 auto;
        }

        /* Logo Section */
        .logo-section .logo h1 {
            margin: 0;
            font-weight: 700;
            color: var(--white);
            font-size: 28px;
        }

        .logo-section .tagline {
            display: block;
            font-size: 11px;
            color: #e8f0ff;
            opacity: 0.85;
            margin-top: 2px;
        }

        /* Search Section */
        .search-section {
            flex: 1;
            max-width: 600px;
        }

        .search-bar {
            width: 100%;
            background: var(--white);
            border-radius: 30px;
            padding: 8px 12px;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            transition: all 0.3s ease;
        }

        .search-bar:focus-within {
            box-shadow: 0 6px 20px rgba(10,103,255,0.3);
            transform: translateY(-1px);
        }

        .search-bar input {
            flex: 1;
            border: none;
            background: transparent;
            outline: none;
            font-size: 15px;
            color: #0f172a;
            padding: 10px;
        }

        .search-bar input::placeholder {
            color: #94a3b8;
        }

        .search-btn {
            border: none;
            background: linear-gradient(135deg, var(--blue-dark), var(--blue));
            color: var(--white);
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(10,103,255,0.3);
        }

        .search-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 18px rgba(10,103,255,0.5);
        }

        /* Header Right */
        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .menu-toggle {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--white);
            cursor: pointer;
            padding: 10px 16px;
            border-radius: 10px;
            transition: all 0.3s ease;
            background: rgba(255,255,255,0.1);
        }

        .menu-toggle:hover {
            background: rgba(255,255,255,0.2);
        }

        .recruiter-btn {
            background: linear-gradient(135deg, #10b981, #059669);
            color: var(--white);
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(16,185,129,0.3);
        }

        .recruiter-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16,185,129,0.4);
        }

        .user-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-actions > a,
        .user-actions > div {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            background: rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            font-size: 18px;
        }

        .user-actions > a:hover,
        .user-actions > div:hover {
            background: rgba(255,255,255,0.2);
            transform: scale(1.1);
        }

        .logout-icon:hover {
            background: rgba(239,68,68,0.2) !important;
            color: #ef4444 !important;
        }

        /* ========== MEGA MENU ========== */
        .mega-menu {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            top: 78px;
            width: 92%;
            max-width: 1100px;
            background: var(--white);
            color: #0f172a;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 28px;
            display: none;
            z-index: 1300;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateX(-50%) translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateX(-50%) translateY(0);
            }
        }

        .mega-menu.open {
            display: block;
        }

        .mega-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 32px;
        }

        .mega-col h4 {
            margin: 0 0 16px 0;
            color: var(--blue-dark);
            font-weight: 700;
            font-size: 16px;
        }

        .mega-col a {
            display: block;
            padding: 12px 16px;
            margin: 6px 0;
            color: #334155;
            border-radius: 10px;
            transition: all 0.2s ease;
            text-decoration: none;
        }

        .mega-col a:hover {
            color: var(--blue);
            background: rgba(10,103,255,0.08);
            transform: translateX(5px);
        }

        /* ========== MAIN CONTENT ========== */
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 50px auto;
            padding: 0 20px;
        }

        h2 {
            text-align: center;
            color: var(--white);
            margin-bottom: 40px;
            font-size: 36px;
            font-weight: 700;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
            position: relative;
            padding-bottom: 15px;
        }

        h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, var(--blue-dark), var(--blue));
            border-radius: 2px;
        }

        /* ========== JOB CARDS ========== */
        .job-card {
            background: var(--white);
            border-radius: 16px;
            padding: 28px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-md);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .job-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, var(--blue-dark), var(--blue), #06b6d4);
        }

        .job-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-lg);
        }

        .job-title {
            font-size: 22px;
            font-weight: 700;
            color: var(--blue);
            margin-bottom: 12px;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .job-title:hover {
            color: var(--blue-dark);
        }

        .company {
            font-size: 18px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .company::before {
            content: '🏢';
            font-size: 18px;
        }

        .job-info {
            font-size: 14px;
            margin: 10px 0;
            color: #475569;
            display: flex;
            align-items: flex-start;
            gap: 10px;
            line-height: 1.6;
        }

        .job-info strong {
            color: var(--blue-dark);
            min-width: 130px;
            font-weight: 600;
        }

        /* ========== STATUS BADGES ========== */
        .status {
            display: inline-flex;
            align-items: center;
            padding: 7px 16px;
            border-radius: 25px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }

        .status::before {
            content: '';
            width: 8px;
            height: 8px;
            border-radius: 50%;
            margin-right: 8px;
        }

        .status.pending {
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            color: #78350f;
        }

        .status.pending::before {
            background: #78350f;
        }

        .status.accepted {
            background: linear-gradient(135deg, #10b981, #059669);
            color: var(--white);
        }

        .status.accepted::before {
            background: var(--white);
        }

        .status.rejected {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: var(--white);
        }

        .status.rejected::before {
            background: var(--white);
        }

        /* ========== FILTER SECTION ========== */
        .filter-section {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .filter-form {
            display: flex;
            align-items: end;
            gap: 20px;
            flex-wrap: wrap;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .filter-group label {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-light);
        }

        .filter-group select {
            padding: 12px 16px;
            border-radius: 12px;
            border: 2px solid rgba(255,255,255,0.2);
            background: rgba(255,255,255,0.1);
            color: var(--white);
            font-size: 14px;
            min-width: 180px;
            transition: all 0.3s ease;
        }

        .filter-group select:focus {
            outline: none;
            border-color: var(--blue);
            background: rgba(255,255,255,0.15);
        }

        .filter-group select option {
            background: var(--bg-left);
            color: var(--white);
        }

        .filter-btn, .reset-btn {
            padding: 12px 24px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .filter-btn {
            background: linear-gradient(135deg, var(--blue-dark), var(--blue));
            color: var(--white);
        }

        .filter-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(10,103,255,0.4);
        }

        .reset-btn {
            background: rgba(255,255,255,0.1);
            color: var(--text-light);
            border: 2px solid rgba(255,255,255,0.2);
        }

        .reset-btn:hover {
            background: rgba(255,255,255,0.2);
            color: var(--white);
        }

        /* ========== STATISTICS SECTION ========== */
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .stat-item {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.2);
            transition: all 0.3s ease;
        }

        .stat-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        .stat-number {
            display: block;
            font-size: 32px;
            font-weight: 700;
            color: var(--blue);
            margin-bottom: 8px;
        }

        /* Different colors for each stat */
        .stat-item:nth-child(1) .stat-number { color: #0ea5e9; } /* Total - Blue */
        .stat-item:nth-child(2) .stat-number { color: #f59e0b; } /* Pending - Orange */
        .stat-item:nth-child(3) .stat-number { color: #10b981; } /* Accepted - Green */
        .stat-item:nth-child(4) .stat-number { color: #ef4444; } /* Rejected - Red */

        .stat-label {
            font-size: 14px;
            color: var(--text-light-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* ========== ACTION BUTTONS ========== */
        .action-buttons {
            display: flex;
            gap: 12px;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        .action-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 24px;
            border-radius: 30px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: none;
            cursor: pointer;
            gap: 8px;
        }

        .view-btn {
            background: linear-gradient(135deg, var(--blue-dark), var(--blue));
            color: var(--white);
            box-shadow: 0 4px 15px rgba(10,103,255,0.3);
        }

        .cancel-btn {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: var(--white);
            box-shadow: 0 4px 15px rgba(239,68,68,0.3);
        }

        .action-btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255,255,255,0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .action-btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255,255,255,0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .action-btn:hover::before {
            width: 300px;
            height: 300px;
        }

        .view-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(10,103,255,0.5);
        }

        .cancel-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(239,68,68,0.5);
        }

        /* ========== MODAL ========== */
        .modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.7);
            backdrop-filter: blur(5px);
        }

        .modal.show {
            display: flex;
            align-items: center;
            justify-content: center;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .modal-content {
            background: linear-gradient(135deg, var(--bg-left), var(--bg-right));
            color: var(--white);
            border-radius: 20px;
            padding: 30px;
            width: 90%;
            max-width: 500px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0,0,0,0.5);
            animation: slideUp 0.3s ease;
        }

        @keyframes slideUp {
            from { 
                opacity: 0;
                transform: translateY(30px);
            }
            to { 
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal h3 {
            margin-bottom: 15px;
            color: #ef4444;
            font-size: 24px;
        }

        .modal p {
            margin-bottom: 25px;
            line-height: 1.6;
            color: var(--text-light-muted);
        }

        .modal-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        .modal-btn {
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .confirm-btn {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: var(--white);
        }

        .confirm-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(239,68,68,0.4);
        }

        .cancel-modal-btn {
            background: rgba(255,255,255,0.1);
            color: var(--text-light);
            border: 2px solid rgba(255,255,255,0.2);
        }

        .cancel-modal-btn:hover {
            background: rgba(255,255,255,0.2);
        }

        /* ========== CANCEL DISABLED STATE ========== */
        .cancel-disabled {
            display: inline-flex;
            align-items: center;
            padding: 12px 24px;
            border-radius: 30px;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-light-muted);
            background: rgba(255,255,255,0.05);
            border: 2px solid rgba(255,255,255,0.1);
            gap: 8px;
            cursor: not-allowed;
            opacity: 0.7;
        }

        .cancel-disabled i {
            font-size: 16px;
        }

        /* ========== EMPTY STATE ========== */
        .empty-state {
            text-align: center;
            padding: 60px 40px;
            background: rgba(255,255,255,0.1);
            border-radius: 20px;
            backdrop-filter: blur(10px);
            border: 2px dashed rgba(255,255,255,0.3);
        }

        .empty-state i {
            font-size: 64px;
            margin-bottom: 24px;
            color: rgba(255,255,255,0.6);
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .empty-state p {
            font-size: 20px;
            color: var(--text-light-muted);
            margin-bottom: 10px;
        }

        /* ========== RESPONSIVE ========== */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                padding: 12px 20px;
                gap: 15px;
            }

            .search-section {
                width: 100%;
                max-width: 100%;
            }

            .header-right {
                width: 100%;
                justify-content: space-between;
            }

            .mega-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .container {
                width: 95%;
                margin: 30px auto;
            }

            h2 {
                font-size: 26px;
            }

            .filter-form {
                flex-direction: column;
                align-items: stretch;
            }

            .filter-group {
                width: 100%;
            }

            .filter-group select {
                min-width: 100%;
            }

            .stats-section {
                grid-template-columns: repeat(2, 1fr);
                gap: 12px;
            }

            .job-card {
                padding: 20px;
            }

            .job-info {
                flex-direction: column;
                gap: 5px;
            }

            .job-info strong {
                min-width: auto;
            }
        }

        @media (max-width: 480px) {
            .menu-toggle span {
                display: none;
            }

            .recruiter-btn {
                padding: 10px 15px;
                font-size: 13px;
            }

            .user-actions > a,
            .user-actions > div {
                width: 38px;
                height: 38px;
                font-size: 16px;
            }

            .stats-section {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .stat-number {
                font-size: 28px;
            }

            .stat-item {
                padding: 15px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 8px;
            }

            .action-btn {
                width: 100%;
                text-align: center;
            }

            .cancel-disabled {
                width: 100%;
                text-align: center;
                justify-content: center;
            }
        }
    </style>
</head>
<body>

    <!-- ========== HEADER ========== -->
    <header class="header">
        <div class="header-content">
            <div class="logo-section">
                <a href="${pageContext.request.contextPath}/JobSeeker/index.jsp" class="logo">
                    <h1>Top</h1>
                    <span class="tagline">Empower growth</span>
                </a>
            </div>
            
            <div class="search-section">
                <form action="${pageContext.request.contextPath}/job-list" method="get" class="search-bar">
                    <input type="text" name="keyword" placeholder="Tìm kiếm việc làm, công ty...">
                    <button type="submit" class="search-btn">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
            </div>
            
            <div class="header-right">
                <div class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                    <span>Danh mục</span>
                </div>
                
                <a class="recruiter-btn" href="../Recruiter/recruiter-login.jsp">Nhà tuyển dụng</a>
                
                <div class="user-actions">
                    <a class="profile-icon" href="${pageContext.request.contextPath}/jobseekerprofile" title="Tài khoản">
                        <i class="fas fa-user"></i>
                    </a>
                    <%@ include file="/shared/notification-dropdown.jsp" %>
                    <div class="message-icon" title="Tin nhắn">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <a class="logout-icon" href="${pageContext.request.contextPath}/LogoutServlet" title="Đăng xuất">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- ========== MEGA MENU ========== -->
    <div class="mega-menu" id="megaMenu">
        <div class="mega-grid">
            <div class="mega-col">
                <h4>Việc làm</h4>
                <a href="#">Việc làm mới nhất</a>
                <a href="${pageContext.request.contextPath}/job-list">Tìm việc làm</a>
                <a href="#">Việc làm quản lý</a>
            </div>
            <div class="mega-col">
                <h4>Việc của tôi</h4>
                <a href="${pageContext.request.contextPath}/saved-jobs">Việc đã lưu</a>
                <a href="${pageContext.request.contextPath}/applied-jobs">Việc đã ứng tuyển</a>
                <a href="#">Thông báo việc làm</a>
                <a href="#">Việc dành cho bạn</a>
            </div>
            <div class="mega-col">
                <h4>Công ty</h4>
                <a href="#">Tất cả công ty</a>
                <a href="#">Top công ty</a>
                <a href="#">Đánh giá công ty</a>
            </div>
        </div>
    </div>

    <!-- ========== MAIN CONTENT ========== -->
    <div class="container">
        <h2>Danh sách công việc đã ứng tuyển</h2>

        <!-- Filter Form -->
        <div class="filter-section">
            <form method="get" action="${pageContext.request.contextPath}/applied-jobs" class="filter-form">
                <div class="filter-group">
                    <label for="statusFilter">Trạng thái:</label>
                    <select id="statusFilter" name="status">
                        <option value="">Tất cả trạng thái</option>
                        <option value="Pending" ${selectedStatus eq 'Pending' ? 'selected' : ''}>Đang chờ</option>
                        <option value="Accepted" ${selectedStatus eq 'Accepted' ? 'selected' : ''}>Đã chấp nhận</option>
                        <option value="Rejected" ${selectedStatus eq 'Rejected' ? 'selected' : ''}>Đã từ chối</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="dateRangeFilter">Thời gian:</label>
                    <select id="dateRangeFilter" name="dateRange">
                        <option value="">Tất cả thời gian</option>
                        <option value="7" ${selectedDateRange eq '7' ? 'selected' : ''}>7 ngày qua</option>
                        <option value="30" ${selectedDateRange eq '30' ? 'selected' : ''}>30 ngày qua</option>
                        <option value="90" ${selectedDateRange eq '90' ? 'selected' : ''}>3 tháng qua</option>
                    </select>
                </div>
                
                <button type="submit" class="filter-btn">
                    <i class="fas fa-filter"></i> Lọc
                </button>
                
                <a href="${pageContext.request.contextPath}/applied-jobs" class="reset-btn">
                    <i class="fas fa-undo"></i> Đặt lại
                </a>
            </form>
        </div>

        <!-- Statistics Summary -->
        <div class="stats-section">
            <div class="stat-item">
                <span class="stat-number">${totalApplications}</span>
                <span class="stat-label">Tổng ứng tuyển</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">${pendingApplications}</span>
                <span class="stat-label">Đang chờ</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">${acceptedApplications}</span>
                <span class="stat-label">Đã chấp nhận</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">${rejectedApplications}</span>
                <span class="stat-label">Bị từ chối</span>
            </div>
        </div>

        <!-- Empty State -->
        <c:if test="${empty applications}">
            <div class="empty-state">
                <i class="fas fa-briefcase"></i>
                <p>Bạn chưa ứng tuyển công việc nào</p>
                <p style="font-size: 14px; color: rgba(255,255,255,0.6);">
                    Hãy khám phá các cơ hội việc làm phù hợp với bạn!
                </p>
                <a href="${pageContext.request.contextPath}/job-list" class="action-btn" style="margin-top: 25px;">
                    <i class="fas fa-search"></i> Tìm việc làm ngay
                </a>
            </div>
        </c:if>

        <!-- Job Cards -->
        <div id="appliedJobsList">
        <c:forEach var="app" items="${applications}" varStatus="loop">
            <div class="job-card" data-index="${loop.index}">
                <div class="job-title">${app.jobTitle}</div>
                <div class="company">${app.companyName}</div>
                
                <div class="job-info">
                    <strong><i class="fas fa-map-marker-alt"></i> Địa điểm:</strong>
                    <span>${app.locationName}</span>
                </div>
                
                <div class="job-info">
                    <strong><i class="fas fa-money-bill-wave"></i> Mức lương:</strong>
                    <span>${app.salaryRange}</span>
                </div>
                
                <div class="job-info">
                    <strong><i class="fas fa-briefcase"></i> Ngành nghề:</strong>
                    <span>${app.industry}</span>
                </div>
                
                <div class="job-info">
                    <strong><i class="fas fa-file-alt"></i> CV đã nộp:</strong>
                    <span>${app.cvTitle}</span>
                </div>
                
                <div class="job-info">
                    <strong><i class="fas fa-calendar-alt"></i> Ngày nộp:</strong>
                    <span>${app.formattedApplicationDate}</span>
                </div>
                
                <div class="job-info">
                    <strong><i class="fas fa-info-circle"></i> Trạng thái:</strong>
                    <span class="status 
                        <c:choose>
                            <c:when test="${app.status eq 'Pending'}">pending</c:when>
                            <c:when test="${app.status eq 'Accepted'}">accepted</c:when>
                            <c:when test="${app.status eq 'Rejected'}">rejected</c:when>
                        </c:choose>">
                        ${app.status}
                    </span>
                </div>
                
                <div class="action-buttons">
                    <a href="job-detail?jobId=${app.jobID}" class="action-btn view-btn">
                        <i class="fas fa-eye"></i> Xem chi tiết
                    </a>
                    <!-- Chỉ hiển thị nút hủy khi status = Pending -->
                    <c:if test="${app.status eq 'Pending'}">
                        <button onclick="cancelApplication(${app.applicationID}, '${app.jobTitle}')" class="action-btn cancel-btn">
                            <i class="fas fa-times"></i> Hủy nộp đơn
                        </button>
                    </c:if>
                    <!-- Hiển thị thông báo cho các status khác -->
                    <c:if test="${app.status ne 'Pending'}">
                        <span class="cancel-disabled">
                            <c:choose>
                                <c:when test="${app.status eq 'Accepted'}">
                                    <i class="fas fa-check-circle"></i> Đã được chấp nhận
                                </c:when>
                                <c:when test="${app.status eq 'Rejected'}">
                                    <i class="fas fa-times-circle"></i> Đã bị từ chối
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-info-circle"></i> Không thể hủy
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </c:if>
                </div>
            </div>
        </c:forEach>
        </div>
        <!-- Pagination (JS) -->
        <div id="pagination" style="display:flex; justify-content:center; gap:0.5rem; margin-top:1.5rem; align-items:center;">
            <button id="prevPage" class="action-btn"><i class="fas fa-chevron-left"></i></button>
            <span id="pageInfo" style="color:#fff; min-width:48px; text-align:center;"></span>
            <button id="nextPage" class="action-btn"><i class="fas fa-chevron-right"></i></button>
        </div>
    </div>

    <!-- ========== CANCEL MODAL ========== -->
    <div id="cancelModal" class="modal">
        <div class="modal-content">
            <h3><i class="fas fa-exclamation-triangle"></i> Xác nhận hủy nộp đơn</h3>
            <p id="cancelMessage">Bạn có chắc chắn muốn hủy nộp đơn cho vị trí này không?</p>
            <p style="font-size: 12px; color: rgba(255,255,255,0.6);">
                Hành động này không thể hoàn tác!
            </p>
            <div class="modal-buttons">
                <button id="confirmCancel" class="modal-btn confirm-btn">
                    <i class="fas fa-trash"></i> Xác nhận hủy
                </button>
                <button id="cancelCancel" class="modal-btn cancel-modal-btn">
                    <i class="fas fa-times"></i> Đóng
                </button>
            </div>
        </div>
    </div>

    <!-- ========== JAVASCRIPT ========== -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // --- Simple JS Pagination for applied jobs ---
            const jobsList = document.getElementById('appliedJobsList');
            const cards = Array.from(jobsList.querySelectorAll('.job-card'));
            const pageInfo = document.getElementById('pageInfo');
            const prevBtn = document.getElementById('prevPage');
            const nextBtn = document.getElementById('nextPage');
            const JOBS_PER_PAGE = 10;
            let currentPage = 1;
            const totalPages = Math.max(1, Math.ceil(cards.length / JOBS_PER_PAGE));

            function renderPage(page) {
                if (page < 1) page = 1;
                if (page > totalPages) page = totalPages;
                currentPage = page;
                cards.forEach((card, idx) => {
                    card.style.display = (idx >= (currentPage-1)*JOBS_PER_PAGE && idx < currentPage*JOBS_PER_PAGE) ? '' : 'none';
                });
                pageInfo.textContent = currentPage + ' / ' + totalPages;
                prevBtn.disabled = (currentPage === 1);
                nextBtn.disabled = (currentPage === totalPages);
            }
            prevBtn.addEventListener('click', () => renderPage(currentPage-1));
            nextBtn.addEventListener('click', () => renderPage(currentPage+1));
            renderPage(1);
            const menuToggle = document.getElementById('menuToggle');
            const megaMenu = document.getElementById('megaMenu');
            
            // Toggle mega menu
            menuToggle.addEventListener('click', function(e) {
                e.stopPropagation();
                megaMenu.classList.toggle('open');
            });
            
            // Close mega menu when clicking outside
            document.addEventListener('click', function(event) {
                if (!menuToggle.contains(event.target) && !megaMenu.contains(event.target)) {
                    megaMenu.classList.remove('open');
                }
            });

            // Fade-in animation cho job cards
            const jobCards = document.querySelectorAll('.job-card');
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver(function(entries) {
                entries.forEach((entry, index) => {
                    if (entry.isIntersecting) {
                        setTimeout(() => {
                            entry.target.style.opacity = '1';
                            entry.target.style.transform = 'translateY(0)';
                        }, index * 100);
                        observer.unobserve(entry.target);
                    }
                });
            }, observerOptions);

            jobCards.forEach(card => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                card.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                observer.observe(card);
            });

            // Smooth scroll
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });

            // Modal handlers
            const modal = document.getElementById('cancelModal');
            const confirmBtn = document.getElementById('confirmCancel');
            const cancelBtn = document.getElementById('cancelCancel');

            cancelBtn.addEventListener('click', function() {
                closeModal();
            });

            // Close modal when clicking outside
            modal.addEventListener('click', function(e) {
                if (e.target === modal) {
                    closeModal();
                }
            });

            // ESC key to close modal
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape' && modal.classList.contains('show')) {
                    closeModal();
                }
            });
        });

        // Global variables for cancel operation
        let currentApplicationId = null;
        let currentJobTitle = null;

        // Show cancel confirmation modal
        function cancelApplication(applicationId, jobTitle) {
            currentApplicationId = applicationId;
            currentJobTitle = jobTitle;
            
            const message = document.getElementById('cancelMessage');
            message.textContent = `Bạn có chắc chắn muốn hủy nộp đơn cho vị trí "${jobTitle}" không?`;
            
            const modal = document.getElementById('cancelModal');
            modal.classList.add('show');
            
            // Set up confirm button click handler
            const confirmBtn = document.getElementById('confirmCancel');
            confirmBtn.onclick = function() {
                performCancelApplication();
            };
        }

        // Close modal
        function closeModal() {
            const modal = document.getElementById('cancelModal');
            modal.classList.remove('show');
            currentApplicationId = null;
            currentJobTitle = null;
        }

        // Perform the actual cancellation
        function performCancelApplication() {
            if (!currentApplicationId) return;

            // Show loading state
            const confirmBtn = document.getElementById('confirmCancel');
            const originalText = confirmBtn.innerHTML;
            confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
            confirmBtn.disabled = true;

            // Send DELETE request
            fetch('${pageContext.request.contextPath}/cancel-application', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'applicationId=' + encodeURIComponent(currentApplicationId)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Show success message and reload page
                    alert('✅ Đã hủy nộp đơn thành công!');
                    window.location.reload();
                } else {
                    // Show specific error message
                    const errorMsg = data.message || 'Không thể hủy nộp đơn';
                    if (errorMsg.includes('Pending')) {
                        alert('⚠️ Không thể hủy nộp đơn!\n\nChỉ có thể hủy các đơn ứng tuyển đang ở trạng thái "Đang chờ" (Pending).');
                    } else {
                        alert('❌ ' + errorMsg);
                    }
                    // Restore button
                    confirmBtn.innerHTML = originalText;
                    confirmBtn.disabled = false;
                    closeModal();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi hủy nộp đơn');
                // Restore button
                confirmBtn.innerHTML = originalText;
                confirmBtn.disabled = false;
            });
        }
    </script>

</body>
</html>