<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AccountDAO,java.util.List,model.Account" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Dữ liệu nên được truyền qua Servlet /adminmanageaccount. Loại bỏ fallback tại JSP để tránh lỗi runtime. --%>
<%
    if (request.getAttribute("accountList") == null) {
        AccountDAO accountDAO = new AccountDAO();
        List<Account> accountList = accountDAO.getAllAccount();
        request.setAttribute("accountList", accountList);
    }
%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Admin - Quản lý tài khoản</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <style>
            :root{
                --bg-dark-1: #031428;
                --bg-dark-2: #062446;
                --bg-bright: #0a67ff;
                --card:#071a3a;
                --muted:rgba(255,255,255,0.75);
                --muted-2:rgba(255,255,255,0.6);
                --accent: rgba(255,255,255,0.03);
                --danger:#ff5a6b;
                --primary:#2f80ed;
                --success:#00d68f;
                --warning:#ff9500;
                --radius:10px;
            }
            *{
                box-sizing:border-box
            }
            body{
                margin:0;
                font-family:Inter,system-ui,Arial;
                background: linear-gradient(110deg, var(--bg-dark-1) 0%, var(--bg-dark-2) 40%, #083d9a 70%, var(--bg-bright) 100%);
                color:var(--muted);
                min-height:100vh;
            }

            /* status badge */
            .status{
                display:inline-block;
                padding:6px 10px;
                border-radius:8px;
                font-weight:700;
                font-size:13px;
                text-transform:uppercase;
                letter-spacing:0.5px;
            }
            .status.active{
                background: rgba(0,255,150,0.1);
                color:#00d68f;
                border:1px solid rgba(0,255,150,0.2);
            }
            .status.inactive{
                background: rgba(255,90,107,0.1);
                color:#ff5a6b;
                border:1px solid rgba(255,90,107,0.2);
            }
            .status.pending{
                background: rgba(255,149,0,0.1);
                color:#ff9500;
                border:1px solid rgba(255,149,0,0.2);
            }

            /* role badge */
            .role{
                display:inline-block;
                padding:4px 8px;
                border-radius:6px;
                font-weight:600;
                font-size:12px;
                text-transform:uppercase;
                letter-spacing:0.3px;
            }
            .role.admin{
                background: linear-gradient(45deg, #ff6b6b, #ee5a24);
                color:#fff;
            }
            .role.employer{
                background: linear-gradient(45deg, #4834d4, #686de0);
                color:#fff;
            }
            .role.jobseeker{
                background: linear-gradient(45deg, #00a085, #00d2d3);
                color:#fff;
            }

            .col-pass{
                width:200px;
            }
            .col-date{
                width:130px
            }
            .col-status{
                width:120px;
                text-align:center
            }
            .col-role{
                width:110px;
                text-align:center
            }
            .col-act{
                width:140px;
                text-align:center
            }

            .wrap{
                display:flex;
                min-height:100vh
            }

            /* sidebar */
            .sidebar{
                width:280px;
                background:linear-gradient(180deg, rgba(2,10,30,0.95), rgba(3,18,40,0.95));
                border-right:1px solid rgba(255,255,255,0.03);
                padding:18px;
                position:relative;
            }
            .brand{
                font-weight:700;
                color:#dbefff;
                margin-bottom:12px;
                font-size:24px;
                display:flex;
                align-items:center;
                gap:8px;
            }
            .brand::before{
                content:"💼";
                font-size:20px;
            }
            .nav{
                display:flex;
                flex-direction:column;
                gap:6px
            }
            .nav a{
                padding:12px 14px;
                border-radius:8px;
                color:rgba(255,255,255,0.85);
                text-decoration:none;
                font-weight:600;
                transition:all 0.2s ease;
                display:flex;
                align-items:center;
                gap:10px;
            }
            .nav a::before{
                font-size:16px;
            }
            .nav a:nth-child(1)::before{content:"📋";}
            .nav a:nth-child(2)::before{content:"👥";}
            .nav a:nth-child(3)::before{content:"📁";}
            .nav a:nth-child(4)::before{content:"📝";}
            .nav a:nth-child(5)::before{content:"💼";}
            
            .nav a:hover{
                background:rgba(255,255,255,0.05);
                color:#fff;
                transform:translateX(4px);
            }
            .nav a.active{
                background:linear-gradient(90deg, rgba(47,128,237,0.2), rgba(10,103,255,0.1));
                color:#fff;
                border:1px solid rgba(47,128,237,0.3);
            }

            /* logout button */
            .logout-btn{
                position:absolute;
                bottom:20px;
                left:18px;
                right:18px;
                padding:12px;
                background:linear-gradient(45deg, var(--danger), #e55039);
                color:#fff;
                border:none;
                border-radius:8px;
                font-weight:600;
                cursor:pointer;
                text-decoration:none;
                display:flex;
                align-items:center;
                justify-content:center;
                gap:8px;
                transition:all 0.2s ease;
            }
            .logout-btn:hover{
                transform:translateY(-2px);
                box-shadow:0 4px 12px rgba(255,90,107,0.3);
            }
            .logout-btn::before{
                content:"🚪";
            }

            /* main */
            .main{
                flex:1;
                display:flex;
                flex-direction:column
            }
            .topbar{
                height:70px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                background:linear-gradient(90deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));
                padding:0 20px;
                border-bottom:1px solid rgba(255,255,255,0.03);
                backdrop-filter:blur(10px);
            }
            .topbar .title{
                font-weight:700;
                color:#eaf4ff;
                font-size:20px;
            }
            .user-info{
                display:flex;
                align-items:center;
                gap:12px;
                color:var(--muted);
            }
            .avatar{
                width:36px;
                height:36px;
                border-radius:50%;
                background:linear-gradient(45deg, var(--primary), var(--bg-bright));
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:700;
                color:#fff;
            }

            .container{
                padding:24px;
                max-width:1400px;
                margin:0 auto;
                width:100%
            }

            /* stats cards */
            .stats{
                display:grid;
                grid-template-columns:repeat(auto-fit, minmax(200px, 1fr));
                gap:20px;
                margin-bottom:24px;
            }
            .stat-card{
                background:linear-gradient(135deg, rgba(7,26,58,0.8), rgba(6,36,70,0.6));
                border-radius:12px;
                padding:20px;
                border:1px solid rgba(255,255,255,0.06);
                text-align:center;
            }
            .stat-number{
                font-size:28px;
                font-weight:700;
                color:#fff;
                margin-bottom:4px;
            }
            .stat-label{
                color:var(--muted-2);
                font-size:14px;
                text-transform:uppercase;
                letter-spacing:0.5px;
            }

            /* card changed to dark */
            .card{
                background: linear-gradient(180deg, var(--card), rgba(6,24,44,0.6));
                border-radius:16px;
                padding:24px;
                border:1px solid rgba(255,255,255,0.04);
                box-shadow:0 10px 30px rgba(2,10,30,0.6);
                color: #eaf4ff;
            }

            .toolbar{
                display:flex;
                align-items:center;
                justify-content:space-between;
                margin-bottom:20px;
                gap:16px;
                flex-wrap:wrap;
            }
            .left-tools{
                display:flex;
                align-items:center;
                gap:16px;
                flex-wrap:wrap;
            }
            .right-tools{
                display:flex;
                align-items:center;
                gap:12px;
                flex-wrap:wrap;
            }

            /* Enhanced form controls */
            select, input[type="text"]{
                padding:10px 14px;
                border-radius:8px;
                border:1px solid rgba(255,255,255,0.1);
                background:rgba(255,255,255,0.05);
                color:#fff;
                font-size:14px;
                transition:all 0.2s ease;
            }
            select:focus, input[type="text"]:focus{
                outline:none;
                border-color:var(--primary);
                box-shadow:0 0 0 3px rgba(47,128,237,0.1);
            }
            select option{
                background:#062446;
                color:#fff;
            }
            input[type="text"]{
                min-width:220px;
            }
            input[type="text"]::placeholder{
                color:var(--muted-2);
            }

            /* Enhanced buttons */
            .btn{
                padding:8px 16px;
                border-radius:8px;
                border:0;
                font-weight:600;
                cursor:pointer;
                text-decoration:none;
                display:inline-flex;
                align-items:center;
                gap:6px;
                transition:all 0.2s ease;
                font-size:13px;
            }
            .btn:hover{
                transform:translateY(-1px);
            }
            .btn.primary{
                background:linear-gradient(45deg, var(--primary), #0b63ff);
                color:#fff;
            }
            .btn.primary:hover{
                box-shadow:0 4px 12px rgba(47,128,237,0.3);
            }
            .btn.success{
                background:linear-gradient(45deg, var(--success), #00a085);
                color:#fff;
            }
            .btn.success:hover{
                box-shadow:0 4px 12px rgba(0,214,143,0.3);
            }
            .btn.danger{
                background:linear-gradient(45deg, var(--danger), #e55039);
                color:#fff;
            }
            .btn.danger:hover{
                box-shadow:0 4px 12px rgba(255,90,107,0.3);
            }
            .btn.outline{
                background:transparent;
                border:1px solid rgba(255,255,255,0.2);
                color:var(--muted);
            }
            .btn.outline:hover{
                background:rgba(255,255,255,0.05);
                border-color:rgba(255,255,255,0.4);
            }

            /* Add button */
            .btn-add{
                background:linear-gradient(45deg, var(--success), #00a085);
                color:#fff;
                padding:12px 20px;
                border-radius:10px;
                text-decoration:none;
                font-weight:600;
                display:inline-flex;
                align-items:center;
                gap:8px;
                transition:all 0.2s ease;
            }
            .btn-add:hover{
                transform:translateY(-2px);
                box-shadow:0 6px 16px rgba(0,214,143,0.3);
            }
            .btn-add::before{
                content:"➕";
                font-size:14px;
            }

            /* table */
            .table-wrap{
                overflow-x:auto;
                border-radius:12px;
                border:1px solid rgba(255,255,255,0.04);
            }
            table{
                width:100%;
                border-collapse:collapse;
                font-size:14px;
                color:var(--muted);
                background:transparent;
            }
            thead th{
                background:rgba(255,255,255,0.02);
                padding:16px 12px;
                text-align:left;
                color:var(--muted);
                font-weight:700;
                border-bottom:1px solid rgba(255,255,255,0.06);
                text-transform:uppercase;
                letter-spacing:0.5px;
                font-size:12px;
            }
            tbody td{
                padding:16px 12px;
                border-bottom:1px solid rgba(255,255,255,0.02);
                color:rgba(255,255,255,0.9);
                vertical-align:middle;
            }
            tbody tr{
                transition:all 0.2s ease;
            }
            tbody tr:hover{
                background:rgba(255,255,255,0.02);
                transform:scale(1.001);
            }

            .col-id{
                width:60px;
                text-align:center;
                font-weight:700;
                color:var(--primary);
            }
            .col-email{
                min-width:200px;
            }
            .col-name{
                min-width:150px;
            }

            /* toggle password button */
            .btn-toggle{
                padding:4px 8px;
                margin-left:8px;
                border-radius:6px;
                background:rgba(255,255,255,0.05);
                color:var(--muted);
                font-weight:500;
                font-size:11px;
                border:1px solid rgba(255,255,255,0.1);
            }
            .pwd{
                font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, "Roboto Mono", "Courier New", monospace;
                letter-spacing:1px;
                color:var(--muted-2);
            }
            .pwd.hidden{
                color:var(--muted-2);
            }
            .pwd.hidden::before{
                content:"••••••••";
            }

            /* footer / pagination */
            .table-footer{
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding-top:20px;
                color:var(--muted-2);
                border-top:1px solid rgba(255,255,255,0.02);
                margin-top:16px;
            }
            .pagination{
                display:flex;
                gap:8px;
                align-items:center
            }
            .pbtn{
                padding:8px 12px;
                border-radius:8px;
                border:1px solid rgba(255,255,255,0.04);
                background:rgba(255,255,255,0.02);
                color:var(--muted);
                cursor:pointer;
                transition:all 0.2s ease;
                font-weight:500;
            }
            .pbtn:hover{
                background:rgba(255,255,255,0.05);
                border-color:rgba(255,255,255,0.1);
            }
            .pbtn.active{
                background:linear-gradient(90deg,var(--primary),#0b63ff);
                color:#fff;
                border-color:transparent
            }
            .pbtn:disabled{
                opacity:0.5;
                cursor:not-allowed;
            }

            /* Filter section */
            .filters{
                background:rgba(255,255,255,0.02);
                padding:16px;
                border-radius:10px;
                margin-bottom:20px;
                border:1px solid rgba(255,255,255,0.04);
            }
            .filter-row{
                display:flex;
                gap:16px;
                align-items:center;
                flex-wrap:wrap;
            }
            .filter-group{
                display:flex;
                flex-direction:column;
                gap:6px;
            }
            .filter-label{
                font-size:12px;
                color:var(--muted-2);
                text-transform:uppercase;
                letter-spacing:0.5px;
                font-weight:600;
            }

            /* No data state */
            .no-data{
                text-align:center;
                padding:40px 20px;
                color:var(--muted-2);
            }
            .no-data::before{
                content:"🔍";
                font-size:48px;
                display:block;
                margin-bottom:16px;
            }

            /* mobile menu toggle */
            .mobile-menu-toggle{
                display:none;
                position:fixed;
                top:20px;
                left:20px;
                z-index:1000;
                background:var(--primary);
                color:#fff;
                border:none;
                border-radius:8px;
                padding:10px;
                cursor:pointer;
            }

            /* responsive */
            @media (max-width:1200px){
                .container{
                    max-width:100%;
                }
                .toolbar{
                    flex-direction:column;
                    align-items:stretch;
                }
                .left-tools, .right-tools{
                    justify-content:space-between;
                }
            }
            @media (max-width:900px){
                .sidebar{
                    position:fixed;
                    left:-280px;
                    top:0;
                    height:100vh;
                    z-index:999;
                    transition:left 0.3s ease;
                }
                .sidebar.open{
                    left:0;
                }
                .mobile-menu-toggle{
                    display:block;
                }
                .container{
                    padding:16px;
                }
                .stats{
                    grid-template-columns:repeat(2, 1fr);
                }
                .col-pass{
                    width:150px;
                }
                .filter-row{
                    flex-direction:column;
                    align-items:stretch;
                }
            }
            @media (max-width:600px){
                .stats{
                    grid-template-columns:1fr;
                }
                .table-wrap{
                    font-size:12px;
                }
                thead th, tbody td{
                    padding:8px 6px;
                }
            }
        </style>
    </head>
    <body>
        <!-- mobile menu toggle -->
        <button class="mobile-menu-toggle" onclick="toggleMobileMenu()">☰</button>

        <div class="wrap">
            <!-- Updated sidebar navigation links -->
            <aside class="sidebar" id="sidebar">
                <div class="brand">JOBs</div>
                <nav class="nav">
                    <a href="admin-dashboard.jsp">Bảng thống kê</a>
                    <a href="admin-jobposting-management.jsp">Tin tuyển dụng</a>
                    <a class="active" href="#">Quản lý tài khoản</a>
                    <a href="#">Quản lý danh mục</a>
                    <a href="#">Đơn xin việc</a>
                </nav>
                <a href="logout" class="logout-btn" onclick="return confirm('Bạn có chắc chắn muốn đăng xuất?');">Đăng xuất</a>
            </aside>

            <main class="main">
                <header class="topbar">
                    <div class="title">Quản lý tài khoản</div>
                    <div class="user-info">
                        <div class="avatar">A</div>
                        <div>Admin</div>
                    </div>
                </header>

                <section class="container">
                    <!-- Stats Cards -->
                    <div class="stats">
                        <div class="stat-card">
                            <div class="stat-number" id="totalAccounts">${fn:length(accountList)}</div>
                            <div class="stat-label">Tổng tài khoản</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number" id="activeAccounts">0</div>
                            <div class="stat-label">Đang hoạt động</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number" id="inactiveAccounts">0</div>
                            <div class="stat-label">Không hoạt động</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number" id="pendingAccounts">0</div>
                            <div class="stat-label">Chờ xác thực</div>
                        </div>
                    </div>

                    <div class="card">
                        <!-- Filters -->
                        <div class="filters">
                            <div class="filter-row">
                                <div class="filter-group">
                                    <label class="filter-label">Trạng thái</label>
                                    <select id="statusFilter">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="active">Hoạt động</option>
                                        <option value="inactive">Không hoạt động</option>
                                        <option value="pending">Chờ xác thực</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label class="filter-label">Vai trò</label>
                                    <select id="roleFilter">
                                        <option value="">Tất cả vai trò</option>
                                        <option value="admin">Admin</option>
                                        <option value="employer">Nhà tuyển dụng</option>
                                        <option value="jobseeker">Người tìm việc</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label class="filter-label">Ngày tạo</label>
                                    <select id="dateFilter">
                                        <option value="">Tất cả thời gian</option>
                                        <option value="today">Hôm nay</option>
                                        <option value="week">Tuần này</option>
                                        <option value="month">Tháng này</option>
                                        <option value="year">Năm này</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="toolbar">
                            <div class="left-tools">
                                <label style="color: var(--muted-2);">Hiển thị
                                    <select id="rowsPerPage">
                                        <option value="5">5</option>
                                        <option value="10" selected>10</option>
                                        <option value="25">25</option>
                                        <option value="50">50</option>
                                    </select>
                                    mục</label>
                            </div>

                            <div class="right-tools">
                                <input type="text" id="searchInput" placeholder="🔍 Tìm kiếm theo email, tên..." />
                                <a href="admin-add-account.jsp" class="btn-add">Thêm tài khoản</a>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table aria-label="Danh sách tài khoản">
                                <thead>
                                    <tr>
                                        <th class="col-id">ID</th>
                                        <th class="col-email">Email</th>
                                        <th class="col-pass">Password</th>
                                        <th class="col-role">Role</th>
                                        <th class="col-status">Status</th>
                                        <th class="col-act">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody id="tableBody">
                                    <c:forEach var="account" items="${accountList}">
                                        <tr data-status="${account.status}" data-role="${account.roleId}">
                                            <td class="col-id">${account.accountId}</td>
                                            <td class="col-email">${account.email}</td>
                                            <td class="col-pass">
                                                <span class="pwd hidden" data-password="${account.password}"></span>
                                                <button class="btn-toggle" onclick="togglePassword(this)">Hiện</button>
                                            </td>
                                            <td class="col-role">
                                                <span class="role">${account.roleId}</span>
                                            </td>
                                            <td class="col-status">
                                                <span class="status ${account.status}">${account.status}</span>
                                            </td>
                                            <td class="col-date"></td>
                                            <td class="col-act">
                                                <a href="edit-account?accountId=${account.accountId}" class="btn outline">✏️ Sửa</a>
                                                <a href="delete-account?accountId=${account.accountId}" class="btn danger" onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản này?');">🗑️ Xóa</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <div id="noDataMessage" class="no-data" style="display:none;">
                                <div>Không tìm thấy tài khoản nào phù hợp</div>
                            </div>
                        </div>

                        <div class="table-footer">
                            <div id="infoText">
                                Hiển thị 0 - 0 của 0 mục
                            </div>
                            <div class="pagination" id="pagination"></div>
                        </div>
                    </div>
                </section>
            </main>
        </div>

        <script>
            // Global variables
            let currentPage = 1;
            let rowsPerPage = 10;
            let allRows = [];
            let filteredRows = [];

            // Initialize
            document.addEventListener('DOMContentLoaded', function() {
                allRows = Array.from(document.querySelectorAll('#tableBody tr'));
                filteredRows = [...allRows];
                
                // Add sample data for missing fields if needed
                addSampleData();
                
                updateStats();
                updateTable();
                
                // Event listeners
                document.getElementById('rowsPerPage').addEventListener('change', function() {
                    rowsPerPage = parseInt(this.value);
                    currentPage = 1;
                    updateTable();
                });

                document.getElementById('searchInput').addEventListener('input', function() {
                    currentPage = 1;
                    filterAndUpdate();
                });

                document.getElementById('statusFilter').addEventListener('change', filterAndUpdate);
                document.getElementById('roleFilter').addEventListener('change', filterAndUpdate);
                document.getElementById('dateFilter').addEventListener('change', filterAndUpdate);
            });

            function addSampleData() {
                const roles = ['admin', 'employer', 'jobseeker'];
                const statuses = ['active', 'inactive', 'pending'];
                const names = ['Nguyễn Văn A', 'Trần Thị B', 'Lê Văn C', 'Phạm Thị D', 'Hoàng Văn E'];
                
                allRows.forEach((row, index) => {
                    // Add sample role if missing
                    const roleCell = row.querySelector('.role');
                    if (roleCell && !roleCell.textContent.trim()) {
                        const randomRole = roles[index % roles.length];
                        roleCell.textContent = randomRole;
                        roleCell.className = `role ${randomRole}`;
                        row.setAttribute('data-role', randomRole);
                    }
                    
                    // Add sample status if missing  
                    const statusCell = row.querySelector('.status');
                    if (statusCell && !statusCell.textContent.trim()) {
                        const randomStatus = statuses[index % statuses.length];
                        statusCell.textContent = randomStatus;
                        statusCell.className = `status ${randomStatus}`;
                        row.setAttribute('data-status', randomStatus);
                    }
                    
                    // Add sample name if missing
                    const nameCell = row.querySelector('.col-name');
                    if (nameCell && nameCell.textContent.includes('Chưa cập nhật')) {
                        nameCell.textContent = names[index % names.length];
                    }
                    
                    // Add sample date if missing
                    const dateCell = row.querySelector('.col-date');
                    if (dateCell && (!dateCell.textContent.trim() || dateCell.textContent.includes('2024-01-01'))) {
                        const randomDate = new Date(2024, Math.floor(Math.random() * 12), Math.floor(Math.random() * 28) + 1);
                        const yyyy = randomDate.getFullYear();
                        const mm = String(randomDate.getMonth() + 1).padStart(2, '0');
                        const dd = String(randomDate.getDate()).padStart(2, '0');
                        const formatted = `${yyyy}-${mm}-${dd}`;
                        dateCell.textContent = formatted;
                        row.setAttribute('data-date', formatted);
                    }
                });
            }

            function togglePassword(buttonEl) {
                const cell = buttonEl.closest('td');
                const span = cell.querySelector('.pwd');
                if (span.classList.contains('hidden')) {
                    span.classList.remove('hidden');
                    span.textContent = span.getAttribute('data-password') || '';
                    buttonEl.textContent = 'Ẩn';
                } else {
                    span.classList.add('hidden');
                    span.textContent = '';
                    buttonEl.textContent = 'Hiện';
                }
            }

            function filterAndUpdate() {
                const q = (document.getElementById('searchInput').value || '').toLowerCase();
                const status = (document.getElementById('statusFilter').value || '').toLowerCase();
                const role = (document.getElementById('roleFilter').value || '').toLowerCase();
                const dateRange = document.getElementById('dateFilter').value;

                const now = new Date();
                const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
                const startOfWeek = new Date(startOfToday); startOfWeek.setDate(startOfWeek.getDate() - startOfToday.getDay());
                const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
                const startOfYear = new Date(now.getFullYear(), 0, 1);

                filteredRows = allRows.filter(row => {
                    const emailText = (row.querySelector('.col-email')?.textContent || '').toLowerCase();
                    const nameText = (row.querySelector('.col-name')?.textContent || '').toLowerCase();
                    const rowStatus = (row.getAttribute('data-status') || row.querySelector('.status')?.textContent || '').toLowerCase();
                    const rowRole = (row.getAttribute('data-role') || row.querySelector('.role')?.textContent || '').toLowerCase();
                    const dateStr = row.getAttribute('data-date') || row.querySelector('.col-date')?.textContent || '';

                    // search
                    const matchesSearch = !q || emailText.includes(q) || nameText.includes(q);
                    // status
                    const matchesStatus = !status || rowStatus === status;
                    // role
                    const matchesRole = !role || rowRole === role;
                    // date range
                    let matchesDate = true;
                    if (dateRange) {
                        const d = new Date(dateStr);
                        if (!isNaN(d)) {
                            if (dateRange === 'today') matchesDate = d >= startOfToday;
                            else if (dateRange === 'week') matchesDate = d >= startOfWeek;
                            else if (dateRange === 'month') matchesDate = d >= startOfMonth;
                            else if (dateRange === 'year') matchesDate = d >= startOfYear;
                        }
                    }

                    return matchesSearch && matchesStatus && matchesRole && matchesDate;
                });

                currentPage = 1;
                updateStats();
                updateTable();
            }

            function updateStats() {
                const total = filteredRows.length;
                let active = 0, inactive = 0, pending = 0;
                filteredRows.forEach(row => {
                    const s = (row.getAttribute('data-status') || row.querySelector('.status')?.textContent || '').toLowerCase();
                    if (s === 'active') active++;
                    else if (s === 'inactive') inactive++;
                    else if (s === 'pending') pending++;
                });
                const totalEl = document.getElementById('totalAccounts');
                if (totalEl) totalEl.textContent = String(total);
                const a = document.getElementById('activeAccounts'); if (a) a.textContent = String(active);
                const i = document.getElementById('inactiveAccounts'); if (i) i.textContent = String(inactive);
                const p = document.getElementById('pendingAccounts'); if (p) p.textContent = String(pending);
            }

            function updateTable() {
                // hide all
                allRows.forEach(r => r.style.display = 'none');

                const total = filteredRows.length;
                const totalPages = Math.max(1, Math.ceil(total / rowsPerPage));
                if (currentPage > totalPages) currentPage = totalPages;
                const start = (currentPage - 1) * rowsPerPage;
                const end = Math.min(start + rowsPerPage, total);

                for (let i = start; i < end; i++) {
                    filteredRows[i].style.display = '';
                }

                document.getElementById('noDataMessage').style.display = total === 0 ? '' : 'none';
                renderInfoText(start, end, total);
                renderPagination(totalPages);
            }

            function renderInfoText(start, end, total) {
                const info = document.getElementById('infoText');
                if (!info) return;
                if (total === 0) {
                    info.textContent = 'Không có mục nào để hiển thị';
                } else {
                    info.textContent = `Hiển thị ${start + 1} - ${end} của ${total} mục`;
                }
            }

            function renderPagination(totalPages) {
                const container = document.getElementById('pagination');
                if (!container) return;
                container.innerHTML = '';

                const createBtn = (label, disabled, onClick, active=false) => {
                    const b = document.createElement('button');
                    b.className = 'pbtn' + (active ? ' active' : '');
                    b.textContent = label;
                    b.disabled = !!disabled;
                    if (onClick) b.addEventListener('click', onClick);
                    return b;
                };

                container.appendChild(createBtn('«', currentPage === 1, () => { currentPage = Math.max(1, currentPage - 1); updateTable(); }));

                for (let p = 1; p <= totalPages; p++) {
                    container.appendChild(createBtn(String(p), false, () => { currentPage = p; updateTable(); }, p === currentPage));
                }

                container.appendChild(createBtn('»', currentPage === totalPages, () => { currentPage = Math.min(totalPages, currentPage + 1); updateTable(); }));
            }

            // mobile menu functionality
            function toggleMobileMenu() {
                const sidebar = document.getElementById('sidebar');
                sidebar.classList.toggle('open');
            }

            // Close mobile menu when clicking outside
            document.addEventListener('click', function(e) {
                const sidebar = document.getElementById('sidebar');
                const toggle = document.querySelector('.mobile-menu-toggle');
                if (!sidebar.contains(e.target) && !toggle.contains(e.target)) {
                    sidebar.classList.remove('open');
                }
            });
        </script>
    </body>
</html>
