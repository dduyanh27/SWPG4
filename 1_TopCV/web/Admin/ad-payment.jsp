<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Date, java.text.SimpleDateFormat, model.Role" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    // Authentication check - chỉ Admin mới được truy cập
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
    
    if (adminRole == null || !"Admin".equals(adminRole.getName())) {
        response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
        return;
    }
    
    // Check if paymentList is already loaded from servlet
    if (request.getAttribute("paymentList") == null) {
        // If not loaded, redirect to servlet to load data
        response.sendRedirect(request.getContextPath() + "/admin-payment");
        return;
    }
%>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Admin - Quản lý thanh toán</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/payment.css">
    </head>
    <body>
        <!-- Mobile menu toggle button -->
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
                        <c:choose>
                            <c:when test="${not empty sessionScope.admin.avatarUrl}">
                                <img src="${pageContext.request.contextPath}/assets/img/admin/${sessionScope.admin.avatarUrl}" alt="Avatar">
                            </c:when>
                            <c:otherwise>
                                <div class="sidebar-avatar-placeholder">${fn:substring(sessionScope.admin.fullName, 0, 1)}</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="sidebar-admin-name">${sessionScope.admin.fullName}</div>
                    <div class="sidebar-admin-role">🛡️ Quản trị viên</div>
                    <span class="sidebar-status">Hoạt động</span>
                </div>

                <nav class="sidebar-nav">
                    <div class="nav-title">Menu chính</div>
                    <a href="${pageContext.request.contextPath}/Admin/admin-dashboard.jsp" class="nav-item">📊 Bảng thống kê</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-jobposting-management.jsp" class="nav-item">💼 Tin tuyển dụng</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-manage-account.jsp" class="nav-item">👥 Quản lý tài khoản</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-cv-management.jsp" class="nav-item">📁 Quản lý CV</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-staff.jsp" class="nav-item">🏢 Quản lý nhân sự</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-payment.jsp" class="nav-item active">💳 Quản lý thanh toán</a>
                </nav>

                <div class="sidebar-actions">
                    <a href="${pageContext.request.contextPath}/Admin/admin-profile.jsp" class="action-btn">👤 Hồ sơ cá nhân</a>
                    <a href="#" class="action-btn logout">🚪 Đăng xuất</a>
                </div>
            </div>

            <div class="main">
                <header class="topbar">
                    <div class="title">Quản lý thanh toán</div>
                    <div class="topbar-actions">
                        <button class="btn btn-ghost btn-sm" onclick="refreshPayments()">🔄 Làm mới</button>
                        <button class="btn btn-primary btn-sm" onclick="exportPayments()">📊 Xuất báo cáo</button>
                        <button class="btn btn-success btn-sm" onclick="showAddPaymentModal()">➕ Thêm giao dịch</button>
                    </div>
                </header>

                <main class="content">
                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-error" style="background-color: #fee; color: #c33; padding: 15px; margin: 20px 0; border-radius: 5px; border: 1px solid #fcc;">
                            <strong>Lỗi:</strong> ${error}
                        </div>
                    </c:if>
                    
                    <!-- Payment Statistics -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">💰</div>
                                <div class="stat-trend trend-up">↗️ +12.5%</div>
                            </div>
                            <c:choose>
                                <c:when test="${paymentStats.totalRevenue != null && paymentStats.totalRevenue > 0}">
                                    <c:set var="revenueValue" value="${paymentStats.totalRevenue}" />
                                    <c:choose>
                                        <c:when test="${revenueValue >= 1000000}">
                                            <div class="stat-value">₫<fmt:formatNumber value="${revenueValue/1000000}" maxFractionDigits="1" />M</div>
                                        </c:when>
                                        <c:when test="${revenueValue >= 1000}">
                                            <div class="stat-value">₫<fmt:formatNumber value="${revenueValue/1000}" maxFractionDigits="1" />K</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="stat-value">₫<fmt:formatNumber value="${revenueValue}" maxFractionDigits="0" /></div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <div class="stat-value">₫0</div>
                                </c:otherwise>
                            </c:choose>
                            <div class="stat-label">Tổng doanh thu</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">✅</div>
                                <div class="stat-trend trend-up">↗️ +8.3%</div>
                            </div>
                            <div class="stat-value">${paymentStats.completedPayments}</div>
                            <div class="stat-label">Giao dịch thành công</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">⏳</div>
                                <div class="stat-trend trend-neutral">→ 0%</div>
                            </div>
                            <div class="stat-value">${paymentStats.pendingPayments}</div>
                            <div class="stat-label">Đang chờ xử lý</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">❌</div>
                                <div class="stat-trend trend-down">↘️ -2.1%</div>
                            </div>
                            <div class="stat-value">${paymentStats.failedPayments}</div>
                            <div class="stat-label">Giao dịch thất bại</div>
                        </div>
                    </div>

                    <!-- Payment Management -->
                    <div class="payment-section">
                        <div class="section-header">
                            <h2>💳 Danh sách giao dịch</h2>
                            <div class="section-controls">
                                <div class="filter-group">
                                    <select class="filter-select" id="statusFilter" onchange="filterPayments()">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="success">Thành công</option>
                                        <option value="pending">Đang chờ</option>
                                        <option value="failed">Thất bại</option>
                                    </select>
                                    <select class="filter-select" id="methodFilter" onchange="filterPayments()">
                                        <option value="">Tất cả phương thức</option>
                                        <option value="Bank Transfer">Chuyển khoản</option>
                                        <option value="Credit Card">Thẻ tín dụng</option>
                                        <option value="E-Wallet">Ví điện tử</option>
                                    </select>
                                </div>
                                <div class="search-group">
                                    <input type="text" id="searchInput" placeholder="🔍 Tìm kiếm theo tên, email..." 
                                           onkeyup="searchPayments()" class="search-input">
                                </div>
                            </div>
                        </div>

                        <div class="payment-table-container">
                            <table class="payment-table" id="paymentTable">
                                <thead>
                                    <tr>
                                        <th>ID Giao dịch</th>
                                        <th>Nhà tuyển dụng</th>
                                        <th>Số tiền</th>
                                        <th>Phương thức</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày giao dịch</th>
                                        <th>Mô tả</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="payment" items="${paymentList}">
                                        <tr class="payment-row" data-status="${payment.paymentStatus}" data-method="${payment.paymentMethod}">
                                            <td>
                                                <div class="payment-id">
                                                    <span class="id-badge">PAY${payment.paymentID}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="recruiter-info">
                                                    <div class="recruiter-name">${payment.companyName}</div>
                                                    <div class="recruiter-email">${payment.recruiterEmail}</div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="amount-info">
                                                    <c:choose>
                                                        <c:when test="${payment.amount != null}">
                                                            <span class="amount">₫<fmt:formatNumber value="${payment.amount}" maxFractionDigits="0" groupingUsed="true" /></span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="amount">₫0</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <span class="currency">VND</span>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="payment-method">${payment.paymentMethod}</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${fn:toLowerCase(payment.paymentStatus) eq 'success' or fn:toLowerCase(payment.paymentStatus) eq 'completed'}">
                                                        <span class="status-badge status-completed">✅ Thành công</span>
                                                    </c:when>
                                                    <c:when test="${fn:toLowerCase(payment.paymentStatus) eq 'pending'}">
                                                        <span class="status-badge status-pending">⏳ Đang chờ</span>
                                                    </c:when>
                                                    <c:when test="${fn:toLowerCase(payment.paymentStatus) eq 'failed'}">
                                                        <span class="status-badge status-failed">❌ Thất bại</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-unknown">⚠️ ${payment.paymentStatus}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="date-info">
                                                    <span class="date">${payment.paymentDate}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="description">
                                                    <span class="desc-text">${payment.notes}</span>
                                                    <span class="invoice">INV-${payment.transactionCode}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button class="btn-action btn-view" onclick="viewPayment('${payment.paymentID}')" title="Xem chi tiết">
                                                        👁️
                                                    </button>
                                                    <c:if test="${fn:toLowerCase(payment.paymentStatus) eq 'pending'}">
                                                        <button class="btn-action btn-approve" onclick="approvePayment('${payment.paymentID}')" title="Duyệt">
                                                            ✅
                                                        </button>
                                                        <button class="btn-action btn-reject" onclick="rejectPayment('${payment.paymentID}')" title="Từ chối">
                                                            ❌
                                                        </button>
                                                    </c:if>
                                                    <button class="btn-action btn-download" onclick="downloadInvoice('INV-${payment.transactionCode}')" title="Tải hóa đơn">
                                                        📄
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div class="table-footer">
                            <div class="pagination-info">
                                Hiển thị ${paymentStats.totalPayments} giao dịch
                                <c:if test="${empty paymentList}">
                                    <span style="color: #999; font-style: italic;">(Chưa có giao dịch nào)</span>
                                </c:if>
                            </div>
                            <div class="pagination-controls">
                                <button class="btn-pagination" onclick="previousPage()" disabled>← Trước</button>
                                <span class="page-info">Trang 1 / 1</span>
                                <button class="btn-pagination" onclick="nextPage()" disabled>Tiếp →</button>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <!-- Payment Detail Modal -->
        <div id="paymentModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Chi tiết giao dịch</h3>
                    <span class="close" onclick="closeModal()">&times;</span>
                </div>
                <div class="modal-body" id="modalBody">
                    <!-- Payment details will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button class="btn btn-ghost" onclick="closeModal()">Đóng</button>
                    <button class="btn btn-primary" onclick="printPayment()">In hóa đơn</button>
                </div>
            </div>
        </div>

        <!-- Add Payment Modal -->
        <div id="addPaymentModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Thêm giao dịch mới</h3>
                    <span class="close" onclick="closeAddModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="addPaymentForm" class="payment-form">
                        <div class="form-group">
                            <label for="recruiterName">Tên nhà tuyển dụng:</label>
                            <input type="text" id="recruiterName" name="recruiterName" required>
                        </div>
                        <div class="form-group">
                            <label for="recruiterEmail">Email:</label>
                            <input type="email" id="recruiterEmail" name="recruiterEmail" required>
                        </div>
                        <div class="form-group">
                            <label for="amount">Số tiền (VND):</label>
                            <input type="number" id="amount" name="amount" required>
                        </div>
                        <div class="form-group">
                            <label for="paymentMethod">Phương thức thanh toán:</label>
                            <select id="paymentMethod" name="paymentMethod" required>
                                <option value="">Chọn phương thức</option>
                                <option value="Bank Transfer">Chuyển khoản</option>
                                <option value="Credit Card">Thẻ tín dụng</option>
                                <option value="E-Wallet">Ví điện tử</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="description">Mô tả:</label>
                            <textarea id="description" name="description" rows="3"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-ghost" onclick="closeAddModal()">Hủy</button>
                    <button class="btn btn-primary" onclick="submitPayment()">Thêm giao dịch</button>
                </div>
            </div>
        </div>

        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('unifiedSidebar');
                sidebar.classList.toggle('sidebar-open');
            }

            function refreshPayments() {
                location.reload();
            }

            function exportPayments() {
                alert('Chức năng xuất báo cáo đang được phát triển...');
            }

            function showAddPaymentModal() {
                document.getElementById('addPaymentModal').style.display = 'block';
            }

            function closeAddModal() {
                document.getElementById('addPaymentModal').style.display = 'none';
            }

            function submitPayment() {
                const form = document.getElementById('addPaymentForm');
                const formData = new FormData(form);
                
                // Validate form
                if (!form.checkValidity()) {
                    alert('Vui lòng điền đầy đủ thông tin');
                    return;
                }
                
                // Here you would typically send the data to server
                alert('Giao dịch đã được thêm thành công!');
                closeAddModal();
                form.reset();
            }

            function filterPayments() {
                const statusFilter = document.getElementById('statusFilter').value;
                const methodFilter = document.getElementById('methodFilter').value;
                const rows = document.querySelectorAll('.payment-row');
                
                rows.forEach(row => {
                    const status = (row.getAttribute('data-status') || '').toLowerCase();
                    const method = (row.getAttribute('data-method') || '').toLowerCase();
                    
                    let showRow = true;
                    
                    if (statusFilter) {
                        const filterStatus = statusFilter.toLowerCase();
                        // Handle both 'success' and 'completed' as completed
                        const isCompleted = status === 'success' || status === 'completed';
                        if (filterStatus === 'success' && !isCompleted) {
                            showRow = false;
                        } else if (filterStatus !== 'success' && status !== filterStatus) {
                            showRow = false;
                        }
                    }
                    
                    if (methodFilter && method !== methodFilter.toLowerCase()) {
                        showRow = false;
                    }
                    
                    row.style.display = showRow ? '' : 'none';
                });
            }

            function searchPayments() {
                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                const rows = document.querySelectorAll('.payment-row');
                
                rows.forEach(row => {
                    const text = row.textContent.toLowerCase();
                    row.style.display = text.includes(searchTerm) ? '' : 'none';
                });
            }

            function viewPayment(paymentId) {
                // In a real application, this would fetch payment details from server
                const modalBody = document.getElementById('modalBody');
                modalBody.innerHTML = `
                    <div class="payment-detail">
                        <h4>Thông tin giao dịch ${paymentId}</h4>
                        <p><strong>Trạng thái:</strong> Đang chờ xử lý</p>
                        <p><strong>Số tiền:</strong> ₫2,500,000 VND</p>
                        <p><strong>Phương thức:</strong> Chuyển khoản ngân hàng</p>
                        <p><strong>Ngày tạo:</strong> 15/01/2024 14:30:00</p>
                        <p><strong>Mô tả:</strong> Premium Job Posting Package</p>
                    </div>
                `;
                document.getElementById('paymentModal').style.display = 'block';
            }

            function closeModal() {
                document.getElementById('paymentModal').style.display = 'none';
            }

            function approvePayment(paymentId) {
                if (confirm('Bạn có chắc chắn muốn duyệt giao dịch này?')) {
                    updatePaymentStatus(paymentId, 'success', 'APPROVED_' + Date.now());
                }
            }

            function rejectPayment(paymentId) {
                if (confirm('Bạn có chắc chắn muốn từ chối giao dịch này?')) {
                    updatePaymentStatus(paymentId, 'failed', 'REJECTED_' + Date.now());
                }
            }
            
            function updatePaymentStatus(paymentId, status, transactionCode) {
                const formData = new FormData();
                formData.append('action', 'updateStatus');
                formData.append('paymentID', paymentId);
                formData.append('status', status);
                formData.append('transactionCode', transactionCode);
                
                fetch('${pageContext.request.contextPath}/admin-payment', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        // Reload page to show updated data
                        location.reload();
                    } else {
                        alert('Lỗi: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi cập nhật trạng thái');
                });
            }

            function downloadInvoice(invoiceNumber) {
                alert(`Đang tải hóa đơn ${invoiceNumber}...`);
            }

            function printPayment() {
                window.print();
            }

            function previousPage() {
                // Pagination logic
            }

            function nextPage() {
                // Pagination logic
            }

            // Close modals when clicking outside
            window.onclick = function(event) {
                const paymentModal = document.getElementById('paymentModal');
                const addModal = document.getElementById('addPaymentModal');
                
                if (event.target === paymentModal) {
                    closeModal();
                }
                if (event.target === addModal) {
                    closeAddModal();
                }
            }

            // Mobile responsive
            window.addEventListener('resize', function() {
                const sidebar = document.getElementById('unifiedSidebar');
                if (window.innerWidth > 768) {
                    sidebar.classList.remove('sidebar-open');
                }
            });
        </script>
    </body>
</html>
