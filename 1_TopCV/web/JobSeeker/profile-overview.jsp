<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VietnamWorks - Tổng Quan Hồ Sơ</title>
    <link rel="stylesheet" href="styles.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <div class="logo-section">
                <div class="logo">
                    <h1>Top</h1>
                    <span class="tagline">Empower growth</span>
                </div>
            </div>
            
            <div class="search-section">
                <div class="search-bar">
                    <input type="text" placeholder="Tìm kiếm việc làm, công ty, kỹ năng">
                    <div class="location-selector">
                        <i class="fas fa-map-marker-alt"></i>
                        <span>Tất cả địa điểm</span>
                    </div>
                    <button class="search-btn">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
            
            <div class="header-right">
                <div class="menu-toggle">
                    <i class="fas fa-bars"></i>
                    <span>Tất cả danh mục</span>
                </div>
                <a class="recruiter-btn" href="../Recruiter/recruiter-login.jsp">Nhà tuyển dụng</a>
                <div class="user-actions">
                    <div class="profile-icon">
                        <i class="fas fa-user"></i>
                        <span>Vi</span>
                    </div>
                    <div class="notification-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div class="message-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <a class="logout-icon" href="${pageContext.request.contextPath}/LogoutServlet" title="Đăng xuất">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <div class="main-container">
        <!-- Left Sidebar -->
        <aside class="sidebar">
            <!-- User Profile Card -->
            <div class="profile-card">
                <div class="profile-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="profile-info">
                    <h3>MINH Nguyễn</h3>
                    <p>Software Engineer</p>
                </div>
                <div class="profile-edit" id="sidebarToggle" title="Thu gọn/Mở rộng sidebar">
                    <i class="fas fa-angle-left"></i>
                </div>
            </div>
            
            <div class="resume-status">
                <h4>Cho phép tìm kiếm hồ sơ</h4>
                <div class="resume-toggle">
                    <label class="toggle-switch">
                        <input type="checkbox" checked>
                        <span class="slider"></span>
                    </label>
                    <span class="resume-file">CHAPTER_1.pdf</span>
                </div>
                <a href="#" class="setup-resume">Thiết Lập Hồ Sơ</a>
            </div>

            <!-- Navigation Menu -->
            <nav class="nav-menu">
                <ul>
                    <li>
                        <a href="profile-overview.html" class="nav-item active">
                            <i class="fas fa-chart-pie"></i>
                            <span>Tổng Quan</span>
                        </a>
                    </li>
                    <li>
                        <a href="profile.html" class="nav-item">
                            <i class="fas fa-file-alt"></i>
                            <span>Hồ Sơ Của Tôi</span>
                        </a>
                    </li>
                    <li>
                        <a href="#" class="nav-item">
                            <i class="fas fa-building"></i>
                            <span>Công Ty Của Tôi</span>
                        </a>
                    </li>
                    <li>
                        <a href="index.html" class="nav-item">
                            <i class="fas fa-briefcase"></i>
                            <span>Việc Làm Của Tôi</span>
                        </a>
                    </li>
                    <li>
                        <a href="#" class="nav-item">
                            <i class="fas fa-bell"></i>
                            <span>Thông Báo Việc Làm</span>
                        </a>
                    </li>
                    <li>
                        <a href="#" class="nav-item">
                            <i class="fas fa-shopping-cart"></i>
                            <span>Quản Lý Đơn Hàng</span>
                        </a>
                    </li>
                    <li>
                        <a href="account-management.html" class="nav-item">
                            <i class="fas fa-cog"></i>
                            <span>Quản Lý Tài Khoản</span>
                        </a>
                    </li>
                </ul>
            </nav>

            <!-- Call to Action Button -->
            <button class="cta-button">
                <i class="fas fa-bell"></i>
                <span>Tạo Thông Báo Việc Làm</span>
            </button>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="content-header">
                <h1>Tổng Quan</h1>
            </div>

            <!-- Hoạt động của bạn (biểu đồ placeholder) -->
            <div class="job-detail-content">
                <h2 style="margin-bottom: 1rem; color:#333; font-size:1.2rem;">Hoạt Động Của Bạn</h2>
                <div style="background:#fff; border:1px solid #f0f0f0; border-radius:8px; padding:1rem;">
                    <svg id="overviewSparkline" width="100%" height="80" viewBox="0 0 300 80" preserveAspectRatio="none" style="display:block;"></svg>
                    <div style="display:flex; gap:1rem; align-items:center; margin-top:0.75rem; color:#666; font-size:0.9rem;">
                        <span style="color:#0066cc;">— Hoạt động gần đây</span>
                    </div>
                </div>
            </div>

            <!-- Hồ sơ đính kèm -->
            <div class="job-detail-content" style="margin-top:1rem;">
                <h2 style="margin-bottom: 1rem; color:#333; font-size:1.2rem;">Hồ sơ đính kèm của bạn</h2>
                <div style="background:#fff; border:1px solid #f0f0f0; border-radius:8px; padding:1rem; display:flex; justify-content:space-between; align-items:center;">
                    <div style="display:flex; align-items:center; gap:0.75rem; color:#333;">
                        <i class="fas fa-paperclip" style="color:#0066cc;"></i>
                        <strong>CHAPTER_1.pdf</strong>
                    </div>
                    <a href="#" class="view-more-link">Quản lý hồ sơ đính kèm</a>
                </div>
            </div>

            <!-- Hàng thẻ thống kê nhanh -->
            <div style="display:grid; grid-template-columns: 1fr 1fr 1fr; gap:1rem; margin-top:1rem;">
                <div class="job-detail-content" style="padding:0;">
                    <div style="padding:1rem;">
                        <h3 style="color:#666; font-size:0.95rem; margin-bottom:0.75rem;">Công ty quan tâm đến bạn</h3>
                        <div style="display:flex; flex-direction:column; gap:0.75rem;">
                            <div style="display:flex; align-items:center; justify-content:space-between; background:#f8f9fa; border-radius:8px; padding:0.75rem 1rem;">
                                <div style="display:flex; align-items:center; gap:0.5rem; color:#666;">
                                    <span style="color:#ff6b35; font-weight:600;">0</span>
                                    <span>Lượt xem hồ sơ</span>
                                </div>
                                <i class="fas fa-chevron-right" style="color:#999;"></i>
                            </div>
                            <div style="display:flex; align-items:center; justify-content:space-between; background:#f8f9fa; border-radius:8px; padding:0.75rem 1rem;">
                                <div style="display:flex; align-items:center; gap:0.5rem; color:#666;">
                                    <span style="color:#ff6b35; font-weight:600;">0</span>
                                    <span>Lượt lưu hồ sơ</span>
                                </div>
                                <i class="fas fa-chevron-right" style="color:#999;"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="job-detail-content" style="padding:0;">
                    <div style="padding:1rem; display:flex; flex-direction:column; gap:0.5rem;">
                        <h3 style="color:#666; font-size:0.95rem;">Ứng viên có cùng chức danh</h3>
                        <div style="background:#fff0e6; border:1px solid #fde2cf; border-radius:8px; padding:1.25rem; text-align:center;">
                            <div style="color:#ff6b35; font-size:1.4rem; font-weight:700;">13357</div>
                            <div style="color:#666; margin-top:0.25rem;">Ứng viên</div>
                            <a href="#" class="view-more-link" style="margin-top:0.5rem; display:inline-block;">Chuẩn bị phỏng vấn</a>
                        </div>
                    </div>
                </div>

                <div class="job-detail-content" style="padding:0;">
                    <div style="padding:1rem; display:flex; flex-direction:column; gap:0.5rem;">
                        <h3 style="color:#666; font-size:0.95rem;">Việc làm phù hợp</h3>
                        <div style="background:#e8f0ff; border:1px solid #d6e4ff; border-radius:8px; padding:1.25rem; text-align:center;">
                            <div style="color:#ff6b35; font-size:1.4rem; font-weight:700;">200</div>
                            <div style="color:#666; margin-top:0.25rem;">Công việc</div>
                            <a href="#" class="view-more-link" style="margin-top:0.5rem; display:inline-block;">Xem việc làm phù hợp</a>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        
    </div>

    <!-- Reuse profile modal for quick edit -->
    <div class="profile-modal" id="profileModal">
        <div class="modal-overlay"></div>
        <div class="modal-content">
            <div class="modal-header">
                <h2>Thông Tin Cơ Bản</h2>
                <button class="modal-close" onclick="closeProfileModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-row">
                    <div class="form-group">
                        <label>Họ <span class="required">*</span></label>
                        <input type="text" value="MINH">
                    </div>
                    <div class="form-group">
                        <label>Tên <span class="required">*</span></label>
                        <input type="text" value="Nguyễn">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Chức Danh <span class="required">*</span></label>
                        <input type="text" value="Software Engineer">
                    </div>
                    <div class="form-group">
                        <label>Cấp bậc hiện tại <span class="required">*</span></label>
                        <select>
                            <option selected>Thực tập sinh/Sinh viên</option>
                            <option>Nhân viên</option>
                            <option>Chuyên viên</option>
                            <option>Quản lý</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="cancel-btn" onclick="closeProfileModal()">Hủy</button>
                <button class="save-btn" onclick="saveProfile()">Lưu</button>
            </div>
        </div>
    </div>

    <script src="script.js"></script>
    <script>
    // Minimal inline sparkline (no external libs)
    document.addEventListener('DOMContentLoaded', function () {
        const svg = document.getElementById('overviewSparkline');
        if (!svg) return;
        // Sample data (0-10 range). You can replace by real data later.
        const data = [0,0,0,0,0,1,1,2,2,3,3,6,8];
        const width = 300; // viewBox width
        const height = 80; // viewBox height
        const padding = 6;
        const maxY = Math.max(10, Math.max(...data));
        const stepX = (width - padding * 2) / (data.length - 1);

        // Build path
        const points = data.map((v, i) => {
            const x = padding + i * stepX;
            const y = height - padding - (v / maxY) * (height - padding * 2);
            return { x, y };
        });
        const d = points.map((p, i) => (i === 0 ? `M ${p.x} ${p.y}` : `L ${p.x} ${p.y}`)).join(' ');

        // Background grid (optional, light)
        const grid = document.createElementNS('http://www.w3.org/2000/svg', 'g');
        grid.setAttribute('stroke', '#eee');
        grid.setAttribute('stroke-width', '1');
        for (let i = 1; i <= 3; i++) {
            const y = padding + i * ((height - padding * 2) / 3);
            const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            line.setAttribute('x1', '0');
            line.setAttribute('y1', y);
            line.setAttribute('x2', width);
            line.setAttribute('y2', y);
            line.setAttribute('opacity', '0.6');
            grid.appendChild(line);
        }
        svg.appendChild(grid);

        // Area fill for nicer look
        const area = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        const areaD = `${d} L ${points[points.length - 1].x} ${height - padding} L ${points[0].x} ${height - padding} Z`;
        area.setAttribute('d', areaD);
        area.setAttribute('fill', 'rgba(0,102,204,0.08)');
        area.setAttribute('stroke', 'none');
        svg.appendChild(area);

        // Line path
        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute('d', d);
        path.setAttribute('fill', 'none');
        path.setAttribute('stroke', '#0066cc');
        path.setAttribute('stroke-width', '2');
        path.setAttribute('stroke-linecap', 'round');
        path.setAttribute('stroke-linejoin', 'round');
        svg.appendChild(path);

        // End point highlight
        const last = points[points.length - 1];
        const dot = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
        dot.setAttribute('cx', last.x);
        dot.setAttribute('cy', last.y);
        dot.setAttribute('r', '2.5');
        dot.setAttribute('fill', '#0066cc');
        svg.appendChild(dot);
    });
    </script>
</body>
<!-- Derived from bố cục của profile.html -->
</html>



