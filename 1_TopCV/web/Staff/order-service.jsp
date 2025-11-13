<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Role" %>
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
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Management - TopCV</title>
        <link rel="stylesheet" href="sale.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="order-service-container">
            <!-- Page Header -->
            <div class="page-header">
                <h1 class="page-title"><i class="fas fa-shopping-cart"></i> Quản lý đơn hàng</h1>
                <p class="page-subtitle">Theo dõi và xử lý các đơn hàng gói đăng tuyển</p>
            </div>
            
            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon pending">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-number">12</div>
                    <div class="stat-label">Chờ xử lý</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon approved">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-number">45</div>
                    <div class="stat-label">Đã duyệt</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon rejected">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <div class="stat-number">3</div>
                    <div class="stat-label">Từ chối</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon revenue">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="stat-number">89.5M</div>
                    <div class="stat-label">Doanh thu (VNĐ)</div>
                </div>
            </div>
            
            <!-- Filter Section -->
            <div class="filter-section">
                <div class="filter-row">
                    <div class="filter-group">
                        <label for="statusFilter">Trạng thái</label>
                        <select id="statusFilter">
                            <option value="">Tất cả</option>
                            <option value="pending">Chờ xử lý</option>
                            <option value="approved">Đã duyệt</option>
                            <option value="rejected">Từ chối</option>
                            <option value="processing">Đang xử lý</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="packageFilter">Gói dịch vụ</label>
                        <select id="packageFilter">
                            <option value="">Tất cả</option>
                            <option value="basic">Basic</option>
                            <option value="premium">Premium</option>
                            <option value="vip">VIP</option>
                            <option value="enterprise">Enterprise</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="dateFilter">Ngày đặt</label>
                        <input type="date" id="dateFilter">
                    </div>
                    <div class="filter-group">
                        <label for="searchOrder">Tìm kiếm</label>
                        <input type="text" id="searchOrder" placeholder="Mã đơn hàng, tên khách hàng...">
                    </div>
                    <button class="btn-filter" onclick="applyFilters()">
                        <i class="fas fa-filter"></i> Lọc
                    </button>
                </div>
            </div>
            
            <!-- Orders Grid -->
            <div class="orders-grid" id="ordersGrid">
                <!-- Order Card 1 -->
                <div class="order-card" data-status="pending" data-package="vip">
                    <div class="order-header">
                        <div class="order-id">#ORD-2024-001</div>
                        <div class="order-status pending">Chờ xử lý</div>
                    </div>
                    <div class="order-body">
                        <div class="order-info">
                            <div class="info-row">
                                <span class="info-label">Khách hàng:</span>
                                <span class="info-value">Công ty ABC Ltd</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Người liên hệ:</span>
                                <span class="info-value">Nguyễn Văn A</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Email:</span>
                                <span class="info-value">contact@abc.com</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số điện thoại:</span>
                                <span class="info-value">0901234567</span>
                            </div>
                        </div>
                        
                        <div class="package-details">
                            <div class="package-name">Gói VIP - 3 tháng</div>
                            <ul class="package-features">
                                <li>Đăng tối đa 50 tin tuyển dụng</li>
                                <li>Ưu tiên hiển thị</li>
                                <li>Hỗ trợ 24/7</li>
                                <li>Báo cáo chi tiết</li>
                                <li>Quản lý ứng viên</li>
                            </ul>
                        </div>
                        
                        <div class="order-amount">8,970,000 VNĐ</div>
                    </div>
                    <div class="order-footer">
                        <div class="order-date">15/10/2024 14:30</div>
                        <div class="order-actions">
                            <button class="btn-order approve" onclick="approveOrder('ORD-2024-001')">
                                <i class="fas fa-check"></i> Duyệt
                            </button>
                            <button class="btn-order reject" onclick="rejectOrder('ORD-2024-001')">
                                <i class="fas fa-times"></i> Từ chối
                            </button>
                            <button class="btn-order" onclick="viewOrderDetail('ORD-2024-001')">
                                <i class="fas fa-eye"></i> Chi tiết
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Order Card 2 -->
                <div class="order-card" data-status="approved" data-package="premium">
                    <div class="order-header">
                        <div class="order-id">#ORD-2024-002</div>
                        <div class="order-status approved">Đã duyệt</div>
                    </div>
                    <div class="order-body">
                        <div class="order-info">
                            <div class="info-row">
                                <span class="info-label">Khách hàng:</span>
                                <span class="info-value">XYZ Corporation</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Người liên hệ:</span>
                                <span class="info-value">Trần Thị B</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Email:</span>
                                <span class="info-value">hr@xyz.com</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số điện thoại:</span>
                                <span class="info-value">0987654321</span>
                            </div>
                        </div>
                        
                        <div class="package-details">
                            <div class="package-name">Gói Premium - 6 tháng</div>
                            <ul class="package-features">
                                <li>Đăng tối đa 30 tin tuyển dụng</li>
                                <li>Ưu tiên hiển thị</li>
                                <li>Hỗ trợ 8h-17h</li>
                                <li>Báo cáo cơ bản</li>
                            </ul>
                        </div>
                        
                        <div class="order-amount">7,200,000 VNĐ</div>
                    </div>
                    <div class="order-footer">
                        <div class="order-date">14/10/2024 09:15</div>
                        <div class="order-actions">
                            <button class="btn-order" onclick="viewOrderDetail('ORD-2024-002')">
                                <i class="fas fa-eye"></i> Chi tiết
                            </button>
                            <button class="btn-order" onclick="downloadInvoice('ORD-2024-002')">
                                <i class="fas fa-download"></i> Hóa đơn
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Order Card 3 -->
                <div class="order-card" data-status="processing" data-package="enterprise">
                    <div class="order-header">
                        <div class="order-id">#ORD-2024-003</div>
                        <div class="order-status processing">Đang xử lý</div>
                    </div>
                    <div class="order-body">
                        <div class="order-info">
                            <div class="info-row">
                                <span class="info-label">Khách hàng:</span>
                                <span class="info-value">DEF Group</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Người liên hệ:</span>
                                <span class="info-value">Lê Minh C</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Email:</span>
                                <span class="info-value">recruitment@def.com</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số điện thoại:</span>
                                <span class="info-value">0912345678</span>
                            </div>
                        </div>
                        
                        <div class="package-details">
                            <div class="package-name">Gói Enterprise - 12 tháng</div>
                            <ul class="package-features">
                                <li>Đăng không giới hạn tin tuyển dụng</li>
                                <li>Ưu tiên cao nhất</li>
                                <li>Hỗ trợ 24/7</li>
                                <li>Báo cáo nâng cao</li>
                                <li>API tích hợp</li>
                                <li>Dedicated account manager</li>
                            </ul>
                        </div>
                        
                        <div class="order-amount">25,000,000 VNĐ</div>
                    </div>
                    <div class="order-footer">
                        <div class="order-date">13/10/2024 16:45</div>
                        <div class="order-actions">
                            <button class="btn-order" onclick="viewOrderDetail('ORD-2024-003')">
                                <i class="fas fa-eye"></i> Chi tiết
                            </button>
                            <button class="btn-order" onclick="updateOrderStatus('ORD-2024-003')">
                                <i class="fas fa-edit"></i> Cập nhật
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Order Card 4 -->
                <div class="order-card" data-status="rejected" data-package="basic">
                    <div class="order-header">
                        <div class="order-id">#ORD-2024-004</div>
                        <div class="order-status rejected">Từ chối</div>
                    </div>
                    <div class="order-body">
                        <div class="order-info">
                            <div class="info-row">
                                <span class="info-label">Khách hàng:</span>
                                <span class="info-value">GHI Company</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Người liên hệ:</span>
                                <span class="info-value">Phạm Hoàng D</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Email:</span>
                                <span class="info-value">info@ghi.com</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số điện thoại:</span>
                                <span class="info-value">0923456789</span>
                            </div>
                        </div>
                        
                        <div class="package-details">
                            <div class="package-name">Gói Basic - 1 tháng</div>
                            <ul class="package-features">
                                <li>Đăng tối đa 5 tin tuyển dụng</li>
                                <li>Hỗ trợ email</li>
                                <li>Báo cáo cơ bản</li>
                            </ul>
                        </div>
                        
                        <div class="order-amount">990,000 VNĐ</div>
                    </div>
                    <div class="order-footer">
                        <div class="order-date">12/10/2024 11:20</div>
                        <div class="order-actions">
                            <button class="btn-order" onclick="viewOrderDetail('ORD-2024-004')">
                                <i class="fas fa-eye"></i> Chi tiết
                            </button>
                            <button class="btn-order" onclick="reconsiderOrder('ORD-2024-004')">
                                <i class="fas fa-redo"></i> Xem xét lại
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Order Card 5 -->
                <div class="order-card" data-status="pending" data-package="premium">
                    <div class="order-header">
                        <div class="order-id">#ORD-2024-005</div>
                        <div class="order-status pending">Chờ xử lý</div>
                    </div>
                    <div class="order-body">
                        <div class="order-info">
                            <div class="info-row">
                                <span class="info-label">Khách hàng:</span>
                                <span class="info-value">JKL Solutions</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Người liên hệ:</span>
                                <span class="info-value">Võ Thị E</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Email:</span>
                                <span class="info-value">hr@jkl.com</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số điện thoại:</span>
                                <span class="info-value">0934567890</span>
                            </div>
                        </div>
                        
                        <div class="package-details">
                            <div class="package-name">Gói Premium - 3 tháng</div>
                            <ul class="package-features">
                                <li>Đăng tối đa 30 tin tuyển dụng</li>
                                <li>Ưu tiên hiển thị</li>
                                <li>Hỗ trợ 8h-17h</li>
                                <li>Báo cáo cơ bản</li>
                            </ul>
                        </div>
                        
                        <div class="order-amount">3,600,000 VNĐ</div>
                    </div>
                    <div class="order-footer">
                        <div class="order-date">11/10/2024 15:30</div>
                        <div class="order-actions">
                            <button class="btn-order approve" onclick="approveOrder('ORD-2024-005')">
                                <i class="fas fa-check"></i> Duyệt
                            </button>
                            <button class="btn-order reject" onclick="rejectOrder('ORD-2024-005')">
                                <i class="fas fa-times"></i> Từ chối
                            </button>
                            <button class="btn-order" onclick="viewOrderDetail('ORD-2024-005')">
                                <i class="fas fa-eye"></i> Chi tiết
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Order Card 6 -->
                <div class="order-card" data-status="approved" data-package="vip">
                    <div class="order-header">
                        <div class="order-id">#ORD-2024-006</div>
                        <div class="order-status approved">Đã duyệt</div>
                    </div>
                    <div class="order-body">
                        <div class="order-info">
                            <div class="info-row">
                                <span class="info-label">Khách hàng:</span>
                                <span class="info-value">MNO Industries</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Người liên hệ:</span>
                                <span class="info-value">Đỗ Văn F</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Email:</span>
                                <span class="info-value">contact@mno.com</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số điện thoại:</span>
                                <span class="info-value">0945678901</span>
                            </div>
                        </div>
                        
                        <div class="package-details">
                            <div class="package-name">Gói VIP - 6 tháng</div>
                            <ul class="package-features">
                                <li>Đăng tối đa 50 tin tuyển dụng</li>
                                <li>Ưu tiên hiển thị</li>
                                <li>Hỗ trợ 24/7</li>
                                <li>Báo cáo chi tiết</li>
                                <li>Quản lý ứng viên</li>
                            </ul>
                        </div>
                        
                        <div class="order-amount">17,940,000 VNĐ</div>
                    </div>
                    <div class="order-footer">
                        <div class="order-date">10/10/2024 10:15</div>
                        <div class="order-actions">
                            <button class="btn-order" onclick="viewOrderDetail('ORD-2024-006')">
                                <i class="fas fa-eye"></i> Chi tiết
                            </button>
                            <button class="btn-order" onclick="downloadInvoice('ORD-2024-006')">
                                <i class="fas fa-download"></i> Hóa đơn
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <script>
            // Filter functionality
            function applyFilters() {
                const statusFilter = document.getElementById('statusFilter').value;
                const packageFilter = document.getElementById('packageFilter').value;
                const dateFilter = document.getElementById('dateFilter').value;
                const searchTerm = document.getElementById('searchOrder').value.toLowerCase();
                
                const orderCards = document.querySelectorAll('.order-card');
                
                orderCards.forEach(card => {
                    let show = true;
                    
                    // Status filter
                    if (statusFilter && card.dataset.status !== statusFilter) {
                        show = false;
                    }
                    
                    // Package filter
                    if (packageFilter && card.dataset.package !== packageFilter) {
                        show = false;
                    }
                    
                    // Search filter
                    if (searchTerm) {
                        const orderId = card.querySelector('.order-id').textContent.toLowerCase();
                        const customerName = card.querySelector('.info-value').textContent.toLowerCase();
                        if (!orderId.includes(searchTerm) && !customerName.includes(searchTerm)) {
                            show = false;
                        }
                    }
                    
                    // Date filter (simplified - would need more complex logic for real implementation)
                    if (dateFilter) {
                        // This is a simplified version - in real implementation, you'd compare actual dates
                        const orderDate = card.querySelector('.order-date').textContent;
                        // Add date comparison logic here
                    }
                    
                    card.style.display = show ? 'block' : 'none';
                });
            }
            
            // Order action functions
            function approveOrder(orderId) {
                if (confirm(`Bạn có chắc chắn muốn duyệt đơn hàng ${orderId}?`)) {
                    // Update order status
                    const orderCard = document.querySelector(`[onclick*="${orderId}"]`).closest('.order-card');
                    const statusElement = orderCard.querySelector('.order-status');
                    statusElement.textContent = 'Đã duyệt';
                    statusElement.className = 'order-status approved';
                    
                    // Update actions
                    const actionsContainer = orderCard.querySelector('.order-actions');
                    actionsContainer.innerHTML = `
                        <button class="btn-order" onclick="viewOrderDetail('${orderId}')">
                            <i class="fas fa-eye"></i> Chi tiết
                        </button>
                        <button class="btn-order" onclick="downloadInvoice('${orderId}')">
                            <i class="fas fa-download"></i> Hóa đơn
                        </button>
                    `;
                    
                    // Update dataset
                    orderCard.dataset.status = 'approved';
                    
                    alert(`Đơn hàng ${orderId} đã được duyệt thành công!`);
                }
            }
            
            function rejectOrder(orderId) {
                const reason = prompt(`Nhập lý do từ chối đơn hàng ${orderId}:`);
                if (reason) {
                    // Update order status
                    const orderCard = document.querySelector(`[onclick*="${orderId}"]`).closest('.order-card');
                    const statusElement = orderCard.querySelector('.order-status');
                    statusElement.textContent = 'Từ chối';
                    statusElement.className = 'order-status rejected';
                    
                    // Update actions
                    const actionsContainer = orderCard.querySelector('.order-actions');
                    actionsContainer.innerHTML = `
                        <button class="btn-order" onclick="viewOrderDetail('${orderId}')">
                            <i class="fas fa-eye"></i> Chi tiết
                        </button>
                        <button class="btn-order" onclick="reconsiderOrder('${orderId}')">
                            <i class="fas fa-redo"></i> Xem xét lại
                        </button>
                    `;
                    
                    // Update dataset
                    orderCard.dataset.status = 'rejected';
                    
                    alert(`Đơn hàng ${orderId} đã bị từ chối. Lý do: ${reason}`);
                }
            }
            
            function viewOrderDetail(orderId) {
                alert(`Xem chi tiết đơn hàng ${orderId}\n\nTrong ứng dụng thực tế, đây sẽ mở modal hoặc chuyển đến trang chi tiết.`);
            }
            
            function downloadInvoice(orderId) {
                alert(`Tải hóa đơn cho đơn hàng ${orderId}\n\nTrong ứng dụng thực tế, đây sẽ tải file PDF hóa đơn.`);
            }
            
            function updateOrderStatus(orderId) {
                const newStatus = prompt(`Cập nhật trạng thái cho đơn hàng ${orderId}:\n1. pending - Chờ xử lý\n2. approved - Đã duyệt\n3. rejected - Từ chối\n4. processing - Đang xử lý\n\nNhập số (1-4):`);
                
                const statusMap = {
                    '1': { text: 'Chờ xử lý', class: 'pending' },
                    '2': { text: 'Đã duyệt', class: 'approved' },
                    '3': { text: 'Từ chối', class: 'rejected' },
                    '4': { text: 'Đang xử lý', class: 'processing' }
                };
                
                if (statusMap[newStatus]) {
                    const orderCard = document.querySelector(`[onclick*="${orderId}"]`).closest('.order-card');
                    const statusElement = orderCard.querySelector('.order-status');
                    statusElement.textContent = statusMap[newStatus].text;
                    statusElement.className = `order-status ${statusMap[newStatus].class}`;
                    orderCard.dataset.status = statusMap[newStatus].class;
                    
                    alert(`Trạng thái đơn hàng ${orderId} đã được cập nhật thành: ${statusMap[newStatus].text}`);
                }
            }
            
            function reconsiderOrder(orderId) {
                if (confirm(`Bạn có muốn xem xét lại đơn hàng ${orderId}?`)) {
                    // Reset to pending status
                    const orderCard = document.querySelector(`[onclick*="${orderId}"]`).closest('.order-card');
                    const statusElement = orderCard.querySelector('.order-status');
                    statusElement.textContent = 'Chờ xử lý';
                    statusElement.className = 'order-status pending';
                    
                    // Update actions
                    const actionsContainer = orderCard.querySelector('.order-actions');
                    actionsContainer.innerHTML = `
                        <button class="btn-order approve" onclick="approveOrder('${orderId}')">
                            <i class="fas fa-check"></i> Duyệt
                        </button>
                        <button class="btn-order reject" onclick="rejectOrder('${orderId}')">
                            <i class="fas fa-times"></i> Từ chối
                        </button>
                        <button class="btn-order" onclick="viewOrderDetail('${orderId}')">
                            <i class="fas fa-eye"></i> Chi tiết
                        </button>
                    `;
                    
                    // Update dataset
                    orderCard.dataset.status = 'pending';
                    
                    alert(`Đơn hàng ${orderId} đã được chuyển về trạng thái chờ xử lý.`);
                }
            }
            
            // Real-time search
            document.getElementById('searchOrder').addEventListener('input', function() {
                applyFilters();
            });
            
            // Auto-refresh statistics (simulate)
            function updateStatistics() {
                const pendingCount = document.querySelectorAll('[data-status="pending"]').length;
                const approvedCount = document.querySelectorAll('[data-status="approved"]').length;
                const rejectedCount = document.querySelectorAll('[data-status="rejected"]').length;
                
                document.querySelector('.stat-card:nth-child(1) .stat-number').textContent = pendingCount;
                document.querySelector('.stat-card:nth-child(2) .stat-number').textContent = approvedCount;
                document.querySelector('.stat-card:nth-child(3) .stat-number').textContent = rejectedCount;
            }
            
            // Update statistics when filters change
            document.getElementById('statusFilter').addEventListener('change', updateStatistics);
            document.getElementById('packageFilter').addEventListener('change', updateStatistics);
        </script>
    </body>
</html>