<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO,java.util.List,model.Admin,model.Role" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Authentication check - chỉ Sales mới được truy cập
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null) {
        response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
        return;
    }
    
    String userType = (String) sessionObj.getAttribute("userType");
    Role adminRole = (Role) sessionObj.getAttribute("adminRole");
    
    if (userType == null || !"admin".equals(userType)) {
        response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
        return;
    }
    
    if (adminRole == null || !"Sales".equals(adminRole.getName())) {
        response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
        return;
    }
    
    Admin admin = (Admin) sessionObj.getAttribute("admin");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý khách hàng - Sales Dashboard</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/dashboard.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Staff/sale.css">
        <style>
            /* Customer Management Styles */
            .customer-management-container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 20px;
            }
            
            .page-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
                border-radius: 15px;
                margin-bottom: 30px;
                text-align: center;
            }
            
            .page-header h1 {
                margin: 0;
                font-size: 2.5rem;
                font-weight: 700;
            }
            
            .page-header p {
                margin: 10px 0 0 0;
                font-size: 1.1rem;
                opacity: 0.9;
            }
            
            /* Stats Cards */
            .stats-overview {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }
            
            .stat-card {
                background: white;
                border-radius: 12px;
                padding: 25px;
                text-align: center;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                border: 1px solid #e0e6ed;
                transition: transform 0.3s ease;
            }
            
            .stat-card:hover {
                transform: translateY(-3px);
            }
            
            .stat-icon {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 15px;
                font-size: 1.8rem;
                color: white;
            }
            
            .stat-icon.total {
                background: linear-gradient(135deg, #667eea, #764ba2);
            }
            
            .stat-icon.active {
                background: linear-gradient(135deg, #43e97b, #38f9d7);
            }
            
            .stat-icon.premium {
                background: linear-gradient(135deg, #f093fb, #f5576c);
            }
            
            .stat-icon.revenue {
                background: linear-gradient(135deg, #4facfe, #00f2fe);
            }
            
            .stat-number {
                font-size: 2.2rem;
                font-weight: 700;
                color: #2d3748;
                margin-bottom: 5px;
            }
            
            .stat-label {
                color: #718096;
                font-size: 0.9rem;
                font-weight: 500;
            }
            
            /* Filter Section */
            .filter-section {
                background: white;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 25px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                border: 1px solid #e0e6ed;
            }
            
            .filter-row {
                display: flex;
                gap: 20px;
                align-items: end;
                flex-wrap: wrap;
            }
            
            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 8px;
                min-width: 200px;
            }
            
            .filter-group label {
                font-weight: 600;
                color: #2d3748;
                font-size: 0.9rem;
            }
            
            .filter-group input,
            .filter-group select {
                padding: 10px 15px;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 0.9rem;
                outline: none;
                transition: border-color 0.3s;
            }
            
            .filter-group input:focus,
            .filter-group select:focus {
                border-color: #667eea;
            }
            
            .btn-filter {
                padding: 10px 25px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s;
                height: fit-content;
            }
            
            .btn-filter:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            }
            
            /* Customer Table */
            .customers-table-container {
                background: white;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                border: 1px solid #e0e6ed;
            }
            
            .table-header {
                background: linear-gradient(135deg, #f8f9fa, #e9ecef);
                padding: 20px 25px;
                border-bottom: 1px solid #e2e8f0;
            }
            
            .table-header h3 {
                margin: 0;
                color: #2d3748;
                font-size: 1.3rem;
                font-weight: 600;
            }
            
            .customers-table {
                width: 100%;
                border-collapse: collapse;
            }
            
            .customers-table th {
                background: #f8f9fa;
                padding: 15px 20px;
                text-align: left;
                font-weight: 600;
                color: #2d3748;
                border-bottom: 1px solid #e2e8f0;
                font-size: 0.9rem;
            }
            
            .customers-table td {
                padding: 15px 20px;
                border-bottom: 1px solid #f1f5f9;
                vertical-align: middle;
            }
            
            .customers-table tr:hover {
                background: #f8f9fa;
            }
            
            .customer-avatar {
                width: 45px;
                height: 45px;
                border-radius: 50%;
                background: linear-gradient(135deg, #667eea, #764ba2);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: bold;
                font-size: 1.1rem;
                margin-right: 12px;
            }
            
            .customer-info {
                display: flex;
                align-items: center;
            }
            
            .customer-details h4 {
                margin: 0 0 3px 0;
                color: #2d3748;
                font-weight: 600;
            }
            
            .customer-details p {
                margin: 0;
                color: #718096;
                font-size: 0.85rem;
            }
            
            .status-badge {
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                text-transform: uppercase;
            }
            
            .status-badge.active {
                background: #d4edda;
                color: #155724;
            }
            
            .status-badge.premium {
                background: #fff3cd;
                color: #856404;
            }
            
            .status-badge.inactive {
                background: #f8d7da;
                color: #721c24;
            }
            
            .action-buttons {
                display: flex;
                gap: 8px;
            }
            
            .btn-action {
                padding: 6px 12px;
                border: 1px solid #e2e8f0;
                background: white;
                border-radius: 6px;
                cursor: pointer;
                font-size: 0.8rem;
                font-weight: 600;
                transition: all 0.3s;
                text-decoration: none;
                color: #4a5568;
            }
            
            .btn-action:hover {
                background: #f8f9fa;
                border-color: #667eea;
                color: #667eea;
            }
            
            .btn-action.primary {
                background: #667eea;
                color: white;
                border-color: #667eea;
            }
            
            .btn-action.primary:hover {
                background: #5a67d8;
            }
            
            .btn-action.danger {
                background: #e53e3e;
                color: white;
                border-color: #e53e3e;
            }
            
            .btn-action.danger:hover {
                background: #c53030;
            }
            
            /* Add Customer Modal */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.5);
            }
            
            .modal-content {
                background-color: white;
                margin: 5% auto;
                padding: 0;
                border-radius: 12px;
                width: 90%;
                max-width: 600px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.3);
                animation: slideIn 0.3s ease-out;
            }
            
            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(-50px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            
            .modal-header {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                padding: 20px 25px;
                border-radius: 12px 12px 0 0;
            }
            
            .modal-header h2 {
                margin: 0;
                font-size: 1.5rem;
            }
            
            .modal-body {
                padding: 25px;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #2d3748;
            }
            
            .form-group input,
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 10px 15px;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 0.9rem;
                outline: none;
                transition: border-color 0.3s;
            }
            
            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
                border-color: #667eea;
            }
            
            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
            }
            
            .modal-footer {
                padding: 20px 25px;
                border-top: 1px solid #e2e8f0;
                display: flex;
                justify-content: flex-end;
                gap: 10px;
            }
            
            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s;
            }
            
            .btn-primary {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
            }
            
            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            }
            
            .btn-secondary {
                background: #e2e8f0;
                color: #4a5568;
            }
            
            .btn-secondary:hover {
                background: #cbd5e0;
            }
            
            /* Responsive */
            @media (max-width: 768px) {
                .filter-row {
                    flex-direction: column;
                }
                
                .form-row {
                    grid-template-columns: 1fr;
                }
                
                .customers-table-container {
                    overflow-x: auto;
                }
                
                .customers-table {
                    min-width: 600px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Mobile menu toggle button -->
        <button class="mobile-menu-toggle" onclick="toggleSidebar()" style="display: none;">
            ☰
        </button>

        <!-- Unified Sidebar -->
        <div class="unified-sidebar" id="unifiedSidebar">
            <!-- Brand Section -->
            <div class="sidebar-brand">
                <h1 class="brand-title">JOBs</h1>
                <p class="brand-subtitle">Sales Dashboard</p>
            </div>

            <!-- Profile Section -->
            <div class="sidebar-profile">
                <div class="sidebar-avatar">
                    <c:choose>
                        <c:when test="${not empty sessionScope.admin.avatarUrl}">
                            <img src="assets/img/admin/${sessionScope.admin.avatarUrl}" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <div class="sidebar-avatar-placeholder">
                                ${fn:substring(sessionScope.admin.fullName, 0, 1)}
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="sidebar-admin-name">${sessionScope.admin.fullName}</div>
                <div class="sidebar-admin-role">💼 Sales Staff</div>
                <span class="sidebar-status">Hoạt động</span>
            </div>

            <!-- Navigation -->
            <nav class="sidebar-nav">
                <div class="nav-title">Menu chính</div>
                <a href="${pageContext.request.contextPath}/Staff/salehome.jsp" class="nav-item">📊 Tổng quan</a>
                <a href="${pageContext.request.contextPath}/Staff/cus-service.jsp" class="nav-item">💬 Customer Service</a>
                <a href="${pageContext.request.contextPath}/Staff/order-service.jsp" class="nav-item">🛒 Quản lý đơn hàng</a>
                <a href="${pageContext.request.contextPath}/Staff/dt.jsp" class="nav-item active">👥 Quản lý khách hàng</a>
                <a href="#" class="nav-item">📈 Báo cáo doanh thu</a>
                <a href="#" class="nav-item">⚙️ Cài đặt</a>
            </nav>

            <!-- Actions -->
            <div class="sidebar-actions">
                <a href="${pageContext.request.contextPath}/Staff/staff-profile.jsp?role=sales" class="action-btn">👤 Hồ sơ cá nhân</a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="action-btn logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="container">
            <div class="main">
                <div class="customer-management-container">
                    <!-- Page Header -->
                    <div class="page-header">
                        <h1>👥 Quản lý khách hàng</h1>
                        <p>Theo dõi và quản lý thông tin khách hàng đã mua dịch vụ</p>
                    </div>

                    <!-- Stats Overview -->
                    <div class="stats-overview">
                        <div class="stat-card">
                            <div class="stat-icon total">👥</div>
                            <div class="stat-number">156</div>
                            <div class="stat-label">Tổng khách hàng</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon active">✅</div>
                            <div class="stat-number">89</div>
                            <div class="stat-label">Khách hàng hoạt động</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon premium">⭐</div>
                            <div class="stat-number">45</div>
                            <div class="stat-label">Khách hàng Premium</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon revenue">💰</div>
                            <div class="stat-number">₫12.5M</div>
                            <div class="stat-label">Tổng doanh thu</div>
                        </div>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <div class="filter-row">
                            <div class="filter-group">
                                <label>Tìm kiếm khách hàng</label>
                                <input type="text" id="searchInput" placeholder="Nhập tên, email hoặc công ty...">
                            </div>
                            <div class="filter-group">
                                <label>Trạng thái</label>
                                <select id="statusFilter">
                                    <option value="">Tất cả</option>
                                    <option value="active">Hoạt động</option>
                                    <option value="premium">Premium</option>
                                    <option value="inactive">Không hoạt động</option>
                                </select>
                            </div>
                            <div class="filter-group">
                                <label>Gói dịch vụ</label>
                                <select id="packageFilter">
                                    <option value="">Tất cả</option>
                                    <option value="basic">Basic</option>
                                    <option value="premium">Premium</option>
                                    <option value="enterprise">Enterprise</option>
                                </select>
                            </div>
                            <button class="btn-filter" onclick="filterCustomers()">🔍 Lọc</button>
                        </div>
                    </div>

                    <!-- Customers Table -->
                    <div class="customers-table-container">
                        <div class="table-header">
                            <h3>Danh sách khách hàng</h3>
                        </div>
                        <table class="customers-table">
                            <thead>
                                <tr>
                                    <th>Khách hàng</th>
                                    <th>Công ty</th>
                                    <th>Gói dịch vụ</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày mua</th>
                                    <th>Doanh thu</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody id="customersTableBody">
                                <!-- Sample Data -->
                                <tr>
                                    <td>
                                        <div class="customer-info">
                                            <div class="customer-avatar">AB</div>
                                            <div class="customer-details">
                                                <h4>Anh Bình</h4>
                                                <p>anh.binh@techcorp.com</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>TechCorp Solutions</td>
                                    <td>Premium Package</td>
                                    <td><span class="status-badge premium">Premium</span></td>
                                    <td>15/10/2024</td>
                                    <td>₫2,500,000</td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="#" class="btn-action primary">Xem</a>
                                            <a href="#" class="btn-action">Sửa</a>
                                            <a href="#" class="btn-action danger">Xóa</a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="customer-info">
                                            <div class="customer-avatar">CM</div>
                                            <div class="customer-details">
                                                <h4>Chị Mai</h4>
                                                <p>mai.nguyen@global.com</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>Global Industries</td>
                                    <td>Enterprise Package</td>
                                    <td><span class="status-badge active">Hoạt động</span></td>
                                    <td>12/10/2024</td>
                                    <td>₫5,000,000</td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="#" class="btn-action primary">Xem</a>
                                            <a href="#" class="btn-action">Sửa</a>
                                            <a href="#" class="btn-action danger">Xóa</a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="customer-info">
                                            <div class="customer-avatar">TH</div>
                                            <div class="customer-details">
                                                <h4>Thầy Hùng</h4>
                                                <p>hung.le@startup.vn</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>Startup Vietnam</td>
                                    <td>Basic Package</td>
                                    <td><span class="status-badge active">Hoạt động</span></td>
                                    <td>10/10/2024</td>
                                    <td>₫1,200,000</td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="#" class="btn-action primary">Xem</a>
                                            <a href="#" class="btn-action">Sửa</a>
                                            <a href="#" class="btn-action danger">Xóa</a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="customer-info">
                                            <div class="customer-avatar">LN</div>
                                            <div class="customer-details">
                                                <h4>Linh Nguyễn</h4>
                                                <p>linh.nguyen@digital.com</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>Digital Marketing Co.</td>
                                    <td>Premium Package</td>
                                    <td><span class="status-badge premium">Premium</span></td>
                                    <td>08/10/2024</td>
                                    <td>₫2,800,000</td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="#" class="btn-action primary">Xem</a>
                                            <a href="#" class="btn-action">Sửa</a>
                                            <a href="#" class="btn-action danger">Xóa</a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="customer-info">
                                            <div class="customer-avatar">DT</div>
                                            <div class="customer-details">
                                                <h4>Đức Trần</h4>
                                                <p>duc.tran@finance.vn</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>Finance Solutions</td>
                                    <td>Basic Package</td>
                                    <td><span class="status-badge inactive">Không hoạt động</span></td>
                                    <td>05/10/2024</td>
                                    <td>₫1,500,000</td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="#" class="btn-action primary">Xem</a>
                                            <a href="#" class="btn-action">Sửa</a>
                                            <a href="#" class="btn-action danger">Xóa</a>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add Customer Modal -->
        <div id="addCustomerModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Thêm khách hàng mới</h2>
                </div>
                <div class="modal-body">
                    <form id="addCustomerForm">
                        <div class="form-row">
                            <div class="form-group">
                                <label>Họ và tên *</label>
                                <input type="text" id="customerName" required>
                            </div>
                            <div class="form-group">
                                <label>Email *</label>
                                <input type="email" id="customerEmail" required>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Số điện thoại</label>
                                <input type="tel" id="customerPhone">
                            </div>
                            <div class="form-group">
                                <label>Công ty</label>
                                <input type="text" id="customerCompany">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Gói dịch vụ *</label>
                                <select id="customerPackage" required>
                                    <option value="">Chọn gói dịch vụ</option>
                                    <option value="basic">Basic Package</option>
                                    <option value="premium">Premium Package</option>
                                    <option value="enterprise">Enterprise Package</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Trạng thái</label>
                                <select id="customerStatus">
                                    <option value="active">Hoạt động</option>
                                    <option value="premium">Premium</option>
                                    <option value="inactive">Không hoạt động</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Ghi chú</label>
                            <textarea id="customerNotes" rows="3" placeholder="Ghi chú về khách hàng..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="addCustomer()">Thêm khách hàng</button>
                </div>
            </div>
        </div>

        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('unifiedSidebar');
                sidebar.classList.toggle('sidebar-open');
            }

            // Mobile responsive
            window.addEventListener('resize', function() {
                const sidebar = document.getElementById('unifiedSidebar');
                if (window.innerWidth > 768) {
                    sidebar.classList.remove('sidebar-open');
                }
            });

            // Filter customers function
            function filterCustomers() {
                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                const statusFilter = document.getElementById('statusFilter').value;
                const packageFilter = document.getElementById('packageFilter').value;
                
                const rows = document.querySelectorAll('#customersTableBody tr');
                
                rows.forEach(row => {
                    const customerName = row.querySelector('.customer-details h4').textContent.toLowerCase();
                    const customerEmail = row.querySelector('.customer-details p').textContent.toLowerCase();
                    const company = row.cells[1].textContent.toLowerCase();
                    const status = row.querySelector('.status-badge').textContent.toLowerCase();
                    const package = row.cells[2].textContent.toLowerCase();
                    
                    const matchesSearch = customerName.includes(searchTerm) || 
                                        customerEmail.includes(searchTerm) || 
                                        company.includes(searchTerm);
                    
                    const matchesStatus = !statusFilter || status.includes(statusFilter);
                    const matchesPackage = !packageFilter || package.includes(packageFilter);
                    
                    if (matchesSearch && matchesStatus && matchesPackage) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            // Add customer modal functions
            function openAddCustomerModal() {
                document.getElementById('addCustomerModal').style.display = 'block';
            }

            function closeModal() {
                document.getElementById('addCustomerModal').style.display = 'none';
                document.getElementById('addCustomerForm').reset();
            }

            function addCustomer() {
                // Get form data
                const name = document.getElementById('customerName').value;
                const email = document.getElementById('customerEmail').value;
                const phone = document.getElementById('customerPhone').value;
                const company = document.getElementById('customerCompany').value;
                const package = document.getElementById('customerPackage').value;
                const status = document.getElementById('customerStatus').value;
                const notes = document.getElementById('customerNotes').value;
                
                // Validate required fields
                if (!name || !email || !package) {
                    alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                    return;
                }
                
                // Here you would typically send data to server
                // For now, just show success message
                alert('Khách hàng đã được thêm thành công!');
                closeModal();
            }

            // Close modal when clicking outside
            window.onclick = function(event) {
                const modal = document.getElementById('addCustomerModal');
                if (event.target === modal) {
                    closeModal();
                }
            }

            // Search functionality
            document.getElementById('searchInput').addEventListener('input', filterCustomers);
        </script>
        
        <!-- Chatbot Integration -->
        <jsp:include page="../components/chatbot.jsp" />
    </body>
</html>
