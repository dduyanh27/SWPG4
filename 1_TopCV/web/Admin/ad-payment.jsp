<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Date, java.text.SimpleDateFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Sample payment data - in real application, this would come from database
    List<java.util.Map<String, Object>> paymentList = new ArrayList<>();
    
    // Add sample payment records
    java.util.Map<String, Object> payment1 = new java.util.HashMap<>();
    payment1.put("id", "PAY001");
    payment1.put("recruiterName", "TechCorp Vietnam");
    payment1.put("recruiterEmail", "contact@techcorp.vn");
    payment1.put("amount", 2500000);
    payment1.put("currency", "VND");
    payment1.put("paymentMethod", "Bank Transfer");
    payment1.put("status", "Completed");
    payment1.put("transactionDate", "2024-01-15 14:30:00");
    payment1.put("description", "Premium Job Posting Package");
    payment1.put("invoiceNumber", "INV-2024-001");
    paymentList.add(payment1);
    
    java.util.Map<String, Object> payment2 = new java.util.HashMap<>();
    payment2.put("id", "PAY002");
    payment2.put("recruiterName", "StartupXYZ");
    payment2.put("recruiterEmail", "hr@startupxyz.com");
    payment2.put("amount", 1500000);
    payment2.put("currency", "VND");
    payment2.put("paymentMethod", "Credit Card");
    payment2.put("status", "Pending");
    payment2.put("transactionDate", "2024-01-16 09:15:00");
    payment2.put("description", "Standard Job Posting");
    payment2.put("invoiceNumber", "INV-2024-002");
    paymentList.add(payment2);
    
    java.util.Map<String, Object> payment3 = new java.util.HashMap<>();
    payment3.put("id", "PAY003");
    payment3.put("recruiterName", "GlobalCorp Asia");
    payment3.put("recruiterEmail", "admin@globalcorp.asia");
    payment3.put("amount", 5000000);
    payment3.put("currency", "VND");
    payment3.put("paymentMethod", "Bank Transfer");
    payment3.put("status", "Failed");
    payment3.put("transactionDate", "2024-01-14 16:45:00");
    payment3.put("description", "Enterprise Package");
    payment3.put("invoiceNumber", "INV-2024-003");
    paymentList.add(payment3);
    
    java.util.Map<String, Object> payment4 = new java.util.HashMap<>();
    payment4.put("id", "PAY004");
    payment4.put("recruiterName", "Innovation Labs");
    payment4.put("recruiterEmail", "info@innovationlabs.vn");
    payment4.put("amount", 3000000);
    payment4.put("currency", "VND");
    payment4.put("paymentMethod", "E-Wallet");
    payment4.put("status", "Completed");
    payment4.put("transactionDate", "2024-01-13 11:20:00");
    payment4.put("description", "Premium Job Posting + Featured");
    payment4.put("invoiceNumber", "INV-2024-004");
    paymentList.add(payment4);
    
    request.setAttribute("paymentList", paymentList);
    
    // Calculate summary statistics
    int totalPayments = paymentList.size();
    int completedPayments = 0;
    int pendingPayments = 0;
    int failedPayments = 0;
    long totalRevenue = 0;
    
    for (java.util.Map<String, Object> payment : paymentList) {
        String status = (String) payment.get("status");
        if ("Completed".equals(status)) {
            completedPayments++;
            // Sửa lỗi cast từ Integer sang Long
            Object amountObj = payment.get("amount");
            if (amountObj instanceof Integer) {
                totalRevenue += ((Integer) amountObj).longValue();
            } else if (amountObj instanceof Long) {
                totalRevenue += (Long) amountObj;
            }
        } else if ("Pending".equals(status)) {
            pendingPayments++;
        } else if ("Failed".equals(status)) {
            failedPayments++;
        }
    }
    
    request.setAttribute("totalPayments", totalPayments);
    request.setAttribute("completedPayments", completedPayments);
    request.setAttribute("pendingPayments", pendingPayments);
    request.setAttribute("failedPayments", failedPayments);
    request.setAttribute("totalRevenue", totalRevenue);
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
                    <!-- Payment Statistics -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">💰</div>
                                <div class="stat-trend trend-up">↗️ +12.5%</div>
                            </div>
                            <div class="stat-value">₫${totalRevenue/1000}K</div>
                            <div class="stat-label">Tổng doanh thu</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">✅</div>
                                <div class="stat-trend trend-up">↗️ +8.3%</div>
                            </div>
                            <div class="stat-value">${completedPayments}</div>
                            <div class="stat-label">Giao dịch thành công</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">⏳</div>
                                <div class="stat-trend trend-neutral">→ 0%</div>
                            </div>
                            <div class="stat-value">${pendingPayments}</div>
                            <div class="stat-label">Đang chờ xử lý</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">❌</div>
                                <div class="stat-trend trend-down">↘️ -2.1%</div>
                            </div>
                            <div class="stat-value">${failedPayments}</div>
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
                                        <option value="Completed">Thành công</option>
                                        <option value="Pending">Đang chờ</option>
                                        <option value="Failed">Thất bại</option>
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
                                        <tr class="payment-row" data-status="${payment.status}" data-method="${payment.paymentMethod}">
                                            <td>
                                                <div class="payment-id">
                                                    <span class="id-badge">${payment.id}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="recruiter-info">
                                                    <div class="recruiter-name">${payment.recruiterName}</div>
                                                    <div class="recruiter-email">${payment.recruiterEmail}</div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="amount-info">
                                                    <span class="amount">₫${payment.amount}</span>
                                                    <span class="currency">${payment.currency}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="payment-method">${payment.paymentMethod}</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${payment.status eq 'Completed'}">
                                                        <span class="status-badge status-completed">✅ Thành công</span>
                                                    </c:when>
                                                    <c:when test="${payment.status eq 'Pending'}">
                                                        <span class="status-badge status-pending">⏳ Đang chờ</span>
                                                    </c:when>
                                                    <c:when test="${payment.status eq 'Failed'}">
                                                        <span class="status-badge status-failed">❌ Thất bại</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="date-info">
                                                    <span class="date">${payment.transactionDate}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="description">
                                                    <span class="desc-text">${payment.description}</span>
                                                    <span class="invoice">${payment.invoiceNumber}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button class="btn-action btn-view" onclick="viewPayment('${payment.id}')" title="Xem chi tiết">
                                                        👁️
                                                    </button>
                                                    <c:if test="${payment.status eq 'Pending'}">
                                                        <button class="btn-action btn-approve" onclick="approvePayment('${payment.id}')" title="Duyệt">
                                                            ✅
                                                        </button>
                                                        <button class="btn-action btn-reject" onclick="rejectPayment('${payment.id}')" title="Từ chối">
                                                            ❌
                                                        </button>
                                                    </c:if>
                                                    <button class="btn-action btn-download" onclick="downloadInvoice('${payment.invoiceNumber}')" title="Tải hóa đơn">
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
                                Hiển thị ${totalPayments} giao dịch
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
                    const status = row.getAttribute('data-status');
                    const method = row.getAttribute('data-method');
                    
                    let showRow = true;
                    
                    if (statusFilter && status !== statusFilter) {
                        showRow = false;
                    }
                    
                    if (methodFilter && method !== methodFilter) {
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
                    alert('Giao dịch đã được duyệt thành công!');
                    // Here you would update the payment status
                }
            }

            function rejectPayment(paymentId) {
                if (confirm('Bạn có chắc chắn muốn từ chối giao dịch này?')) {
                    alert('Giao dịch đã bị từ chối!');
                    // Here you would update the payment status
                }
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
