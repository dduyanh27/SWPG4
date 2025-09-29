<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Recruiter" %>
<%
    Recruiter recruiter = (Recruiter) request.getAttribute("recruiter");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    
    // If no recruiter from request, try to get from session
    if (recruiter == null) {
        Recruiter sessionRecruiter = (Recruiter) session.getAttribute("user");
        if (sessionRecruiter != null) {
            recruiter = sessionRecruiter;
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông Tin Công Ty - Dashboard Tuyển Dụng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Recruiter/styles.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="company-info-page">
    <!-- Top Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-left">
                <div class="logo">
                    <i class="fas fa-briefcase"></i>
                    <span>RecruitPro</span>
                </div>
                <ul class="nav-menu">
                    <li><a href="index.html">Dashboard</a></li>
                    <li><a href="#">Việc Làm</a></li>
                    <li class="dropdown">
                        <a href="#">Ứng viên <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="#">Quản lý theo việc đăng tuyển</a>
                            <a href="#">Quản lý theo thư mục và thẻ</a>
                        </div>
                    </li>
                    <li class="dropdown">
                        <a href="#">Onboarding <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="#">Quy trình onboarding</a>
                            <a href="#">Tài liệu hướng dẫn</a>
                        </div>
                    </li>
                    <li><a href="#">Đơn hàng</a></li>
                    <li><a href="#">Báo cáo</a></li>
                    <li><a href="#" class="active">Công ty</a></li>
                </ul>
            </div>
            <div class="nav-right">
                <div class="nav-buttons">
                    <div class="dropdown">
                        <button class="btn btn-orange">
                            Đăng Tuyển Dụng <i class="fas fa-chevron-down"></i>
                        </button>
                        <div class="dropdown-content">
                            <a href="job-posting.html">Tạo tin tuyển dụng mới</a>
                            <a href="job-management.html">Quản lý tin đã đăng</a>
                        </div>
                    </div>
                    <button class="btn btn-blue">Tìm Ứng Viên</button>
                    <button class="btn btn-white">Mua</button>
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
                                <a href="#" class="menu-item highlighted">
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
                                <a href="#" class="logout-item">
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
    <main class="account-main">
        <div class="account-container">
            <!-- Left Sidebar -->
            <aside class="account-sidebar">
                <nav class="sidebar-nav">
                    <div class="nav-group">
                        <a href="account-management.html" class="nav-link">
                            <i class="fas fa-cog"></i>
                            <span>Quản lý tài khoản</span>
                        </a>
                    </div>
                    
                    <div class="nav-group">
                        <div class="nav-item dropdown">
                            <a href="#" class="nav-link active">
                                <i class="fas fa-building"></i>
                                <span>Thông tin công ty</span>
                                <i class="fas fa-chevron-down"></i>
                            </a>
                            <div class="dropdown-submenu">
                                <a href="#" class="nav-link active">
                                    <i class="fas fa-user"></i>
                                    <span>Thông tin chung</span>
                                </a>
                                <a href="#" class="nav-link">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span>Địa điểm làm việc</span>
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="nav-group">
                        <div class="nav-item dropdown">
                            <a href="#" class="nav-link">
                                <i class="fas fa-shield-alt"></i>
                                <span>Quản lý quyền truy cập</span>
                                <i class="fas fa-chevron-down"></i>
                            </a>
                            <div class="dropdown-submenu">
                                <a href="#" class="nav-link">
                                    <i class="fas fa-users"></i>
                                    <span>Người dùng</span>
                                </a>
                                <a href="#" class="nav-link">
                                    <i class="fas fa-user-tag"></i>
                                    <span>Vai trò</span>
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="nav-group">
                        <a href="#" class="nav-link">
                            <i class="fas fa-tasks"></i>
                            <span>Quản lý yêu cầu</span>
                        </a>
                        <a href="#" class="nav-link">
                            <i class="fas fa-history"></i>
                            <span>Lịch sử hoạt động</span>
                        </a>
                    </div>
                </nav>
            </aside>

            <!-- Main Content Area -->
            <div class="account-content">
                <div class="content-header">
                    <h1>Thông Tin Công Ty</h1>
                </div>

                <div class="company-form">
                    <!-- Success/Error Messages -->
                    <% if (success != null && success.equals("updated")) { %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        Cập nhật thông tin công ty thành công!
                    </div>
                    <% } %>
                    
                    <% if (error != null) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <% if (error.equals("update_failed")) { %>
                            Cập nhật thông tin thất bại. Vui lòng thử lại.
                        <% } else if (error.equals("system_error")) { %>
                            Có lỗi hệ thống. Vui lòng thử lại sau.
                        <% } else { %>
                            <%= error %>
                        <% } %>
                    </div>
                    <% } %>
                    
                    <form id="companyInfoForm" action="${pageContext.request.contextPath}/CompanyInfoServlet" method="POST" enctype="multipart/form-data">
                        <!-- Hidden fields to track removed images -->
                        <input type="hidden" id="removedLogo" name="removedLogo" value="">
                        <input type="hidden" id="removedImages" name="removedImages" value="">
                    <!-- Thông Tin Công Ty Section -->
                    <div class="form-section">
                        <h3>Thông Tin Công Ty</h3>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="company-name">Tên Công Ty <span class="required">*</span></label>
                                <input type="text" id="company-name" name="companyName" 
                                       value="<%= recruiter != null && recruiter.getCompanyName() != null ? recruiter.getCompanyName() : "" %>"
                                       placeholder="Nhập tên công ty" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="phone">Điện Thoại <span class="required">*</span></label>
                                <input type="tel" id="phone" name="phone" 
                                       value="<%= recruiter != null && recruiter.getPhone() != null ? recruiter.getPhone() : "" %>"
                                       required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="address">Địa Chỉ Công Ty</label>
                                <input type="text" id="address" name="companyAddress" 
                                       value="<%= recruiter != null && recruiter.getCompanyAddress() != null ? recruiter.getCompanyAddress() : "" %>"
                                       placeholder="Nhập địa chỉ công ty">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="company-size">Quy Mô Công Ty</label>
                                <select id="company-size" name="companySize">
                                    <option value="">Vui lòng chọn</option>
                                    <option value="1-10" <%= recruiter != null && "1-10".equals(recruiter.getCompanySize()) ? "selected" : "" %>>1-10 nhân viên</option>
                                    <option value="11-50" <%= recruiter != null && "11-50".equals(recruiter.getCompanySize()) ? "selected" : "" %>>11-50 nhân viên</option>
                                    <option value="51-200" <%= recruiter != null && "51-200".equals(recruiter.getCompanySize()) ? "selected" : "" %>>51-200 nhân viên</option>
                                    <option value="201-500" <%= recruiter != null && "201-500".equals(recruiter.getCompanySize()) ? "selected" : "" %>>201-500 nhân viên</option>
                                    <option value="500+" <%= recruiter != null && "500+".equals(recruiter.getCompanySize()) ? "selected" : "" %>>500+ nhân viên</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="contact-person">Người Liên Hệ</label>
                                <input type="text" id="contact-person" name="contactPerson" 
                                       value="<%= recruiter != null && recruiter.getContactPerson() != null ? recruiter.getContactPerson() : "" %>"
                                       placeholder="Nhập tên người liên hệ">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="website">Website</label>
                                <input type="url" id="website" name="website" 
                                       value="<%= recruiter != null && recruiter.getWebsite() != null ? recruiter.getWebsite() : "" %>"
                                       placeholder="https://example.com">
                            </div>
                        </div>
                    </div>

                    <!-- Phúc Lợi Từ Công Ty Section -->
                    <div class="form-section">
                        <h3>Phúc Lợi Từ Công Ty <span class="required">*</span></h3>
                        
                        <div class="form-group">
                            <textarea id="company-benefits" name="companyBenefits" 
                                      placeholder="Nhập các phúc lợi của công ty (mỗi phúc lợi trên một dòng)..."><%= recruiter != null && recruiter.getCompanyBenefits() != null ? recruiter.getCompanyBenefits() : "" %></textarea>
                        </div>
                    </div>

                    <!-- Sơ Lược Về Công Ty Section -->
                    <div class="form-section">
                        <h3>Sơ Lược Về Công Ty</h3>
                        <div class="form-group">
                            <textarea id="company-overview" name="companyDescription" 
                                      placeholder="Nhập mô tả về công ty..."><%= recruiter != null && recruiter.getCompanyDescription() != null ? recruiter.getCompanyDescription() : "" %></textarea>
                            <div class="char-counter">
                                <span>Bạn còn có thể nhập <strong id="charCount">10000</strong> ký tự</span>
                            </div>
                        </div>
                    </div>

                    <!-- Logo Công Ty Section -->
                    <div class="form-section">
                        <h3>Logo Công Ty</h3>
                        <div class="file-upload">
                            <div class="upload-area" id="logoUploadArea" <%= recruiter != null && recruiter.getCompanyLogoURL() != null && !recruiter.getCompanyLogoURL().isEmpty() ? "style='display: none;'" : "" %>>
                                <i class="fas fa-cloud-upload-alt"></i>
                                <p>Kéo và thả logo ở đây hoặc <span>Chọn file</span></p>
                                <input type="file" id="companyLogo" name="companyLogo" accept="image/*" style="display: none;">
                            </div>
                            <div id="logoPreview" class="image-preview" <%= recruiter != null && recruiter.getCompanyLogoURL() != null && !recruiter.getCompanyLogoURL().isEmpty() ? "" : "style='display: none;'" %>>
                                <% if (recruiter != null && recruiter.getCompanyLogoURL() != null && !recruiter.getCompanyLogoURL().isEmpty()) { %>
                                    <img id="logoPreviewImg" 
                                         src="<%= request.getContextPath() + recruiter.getCompanyLogoURL() %>" 
                                         alt="Logo Preview" 
                                         style="max-width: 200px; max-height: 150px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);"
                                         onerror="this.style.display='none'; document.getElementById('logoUploadArea').style.display='block'; document.getElementById('logoPreview').style.display='none';">
                                <% } else { %>
                                    <img id="logoPreviewImg" src="" alt="Logo Preview" style="display: none;">
                                <% } %>
                                <button type="button" id="removeLogo" class="remove-image">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                            <small class="upload-hint">(Tập tin với phần mở rộng .jpg, .jpeg, .png, .gif và kích thước <1MB)</small>
                        </div>
                    </div>

                    <!-- Hình Ảnh Công Ty Section -->
                    <div class="form-section">
                        <h3>Hình Ảnh Công Ty</h3>
                        <p class="upload-limit">Tối đa 5 ảnh</p>
                        <div class="file-upload">
                            <div class="upload-area" id="imagesUploadArea">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <p>Kéo và thả hình ảnh ở đây hoặc <span>Chọn file</span></p>
                                <input type="file" id="companyImages" name="companyImages" accept="image/*" multiple style="display: none;">
                            </div>
                            <div id="imagesPreview" class="images-preview">
                                <!-- Existing images from database -->
                                <% if (recruiter != null && recruiter.getImg() != null && !recruiter.getImg().isEmpty()) { 
                                    String[] imagePaths = recruiter.getImg().split(",");
                                    String logoPath = recruiter.getCompanyLogoURL();
                                    
                                    for (String imagePath : imagePaths) {
                                        if (!imagePath.trim().isEmpty()) {
                                            // Skip if this is the logo (avoid duplicate display)
                                            boolean isLogo = false;
                                            if (logoPath != null && !logoPath.isEmpty()) {
                                                // Check if this image path contains logo directory or matches logo path
                                                if (imagePath.trim().contains("/logos/") || 
                                                    imagePath.trim().equals(logoPath.trim())) {
                                                    isLogo = true;
                                                }
                                            }
                                            
                                            if (!isLogo) { %>
                                                <div class="image-preview-item existing-image" style="position: relative; display: inline-block; margin: 5px;">
                                                    <img src="<%= request.getContextPath() + imagePath.trim() %>" 
                                                         alt="Company Image" 
                                                         style="max-width: 150px; max-height: 100px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); object-fit: cover;"
                                                         onerror="this.parentElement.style.display='none';">
                                                    <button type="button" class="remove-image" onclick="removeExistingImage(this, '<%= imagePath.trim() %>')" style="position: absolute; top: -8px; right: -8px; background: #dc3545; color: white; border: none; border-radius: 50%; width: 24px; height: 24px; cursor: pointer; display: flex; align-items: center; justify-content: center;">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>
                                            <% }
                                        }
                                    }
                                } %>
                                <!-- Preview images will be added here -->
                            </div>
                            <small class="upload-hint">(Tập tin với phần mở rộng .jpg, .jpeg, .png, .gif và kích thước <1MB mỗi file)</small>
                        </div>
                    </div>

                    <!-- Video Công Ty Section -->
                    <div class="form-section">
                        <h3>Video Công Ty</h3>
                        <div class="form-group">
                            <input type="url" id="company-video" name="companyVideoURL" 
                                   value="<%= recruiter != null && recruiter.getCompanyVideoURL() != null ? recruiter.getCompanyVideoURL() : "" %>"
                                   placeholder="Sao chép và dán từ liên kết Youtube của bạn vào đây">
                        </div>
                    </div>

                    <!-- Save Button -->
                    <div class="form-actions">
                        <button type="submit" class="save-btn">
                            <i class="fas fa-save"></i>
                            Lưu
                        </button>
                    </div>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <!-- Chat Widget -->
    <div class="chat-widget">
        <div class="chat-content">
            <i class="fas fa-comments"></i>
            <span>We're online, chat with us!</span>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/Recruiter/script.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // ========================================
            // VARIABLES AND INITIALIZATION
            // ========================================
            let selectedCompanyImages = []; // Store selected files for company images
            
            // Check for broken images and handle them
            function handleBrokenImages() {
                const images = document.querySelectorAll('img');
                images.forEach(img => {
                    img.addEventListener('error', function() {
                        // Hide broken images
                        this.style.display = 'none';
                        // If it's a logo, show upload area
                        if (this.id === 'logoPreviewImg') {
                            document.getElementById('logoUploadArea').style.display = 'block';
                            document.getElementById('logoPreview').style.display = 'none';
                        }
                    });
                });
            }
            
            // Initialize broken image handling
            handleBrokenImages();
            
            // Character counter elements
            const companyOverview = document.getElementById('company-overview');
            const charCount = document.getElementById('charCount');
            const maxLength = 10000;
            
            if (companyOverview && charCount) {
                function updateCharCount() {
                    const remaining = maxLength - companyOverview.value.length;
                    charCount.textContent = remaining;
                    charCount.style.color = remaining < 100 ? 'red' : 'inherit';
                }
                
                companyOverview.addEventListener('input', updateCharCount);
                updateCharCount(); // Initial count
            }
            
            
            // ========================================
            // LOGO UPLOAD HANDLING
            // ========================================
            const logoElements = {
                uploadArea: document.getElementById('logoUploadArea'),
                input: document.getElementById('companyLogo'),
                preview: document.getElementById('logoPreview'),
                previewImg: document.getElementById('logoPreviewImg'),
                removeBtn: document.getElementById('removeLogo')
            };
            
            if (logoElements.uploadArea && logoElements.input) {
                setupLogoUpload();
            }
            
            function setupLogoUpload() {
                // Click to upload
                logoElements.uploadArea.addEventListener('click', () => logoElements.input.click());
                
                // Drag and drop handlers
                ['dragover', 'dragleave', 'drop'].forEach(eventType => {
                    logoElements.uploadArea.addEventListener(eventType, handleLogoDragEvent);
                });
                
                // File selection
                logoElements.input.addEventListener('change', (e) => {
                    if (e.target.files.length > 0) {
                        handleLogoPreview(e.target.files[0]);
                    }
                });
                
                // Remove logo
                if (logoElements.removeBtn) {
                    logoElements.removeBtn.addEventListener('click', removeLogo);
                }
            }
            
            function handleLogoDragEvent(e) {
                e.preventDefault();
                
                if (e.type === 'dragover') {
                    logoElements.uploadArea.classList.add('drag-over');
                } else if (e.type === 'dragleave') {
                    logoElements.uploadArea.classList.remove('drag-over');
                } else if (e.type === 'drop') {
                    logoElements.uploadArea.classList.remove('drag-over');
                    const files = e.dataTransfer.files;
                    if (files.length > 0) {
                        logoElements.input.files = files;
                        handleLogoPreview(files[0]);
                    }
                }
            }
            
            function removeLogo() {
                const currentLogoSrc = logoElements.previewImg.src;
                const contextPath = '<%= request.getContextPath() %>';
                
                if (currentLogoSrc.includes(contextPath)) {
                    document.getElementById('removedLogo').value = 'true';
                }
                
                logoElements.input.value = '';
                logoElements.preview.style.display = 'none';
                logoElements.uploadArea.style.display = 'block';
            }
            
            // ========================================
            // COMPANY IMAGES UPLOAD HANDLING
            // ========================================
            const imageElements = {
                uploadArea: document.getElementById('imagesUploadArea'),
                input: document.getElementById('companyImages'),
                preview: document.getElementById('imagesPreview')
            };
            
            if (imageElements.uploadArea && imageElements.input) {
                setupImageUpload();
            }
            
            function setupImageUpload() {
                // Click to upload
                imageElements.uploadArea.addEventListener('click', () => imageElements.input.click());
                
                // Drag and drop handlers
                ['dragover', 'dragleave', 'drop'].forEach(eventType => {
                    imageElements.uploadArea.addEventListener(eventType, handleImageDragEvent);
                });
                
                // File selection
                imageElements.input.addEventListener('change', (e) => {
                    if (e.target.files.length > 0) {
                        addFilesToSelection(Array.from(e.target.files));
                    }
                });
            }
            
            function handleImageDragEvent(e) {
                e.preventDefault();
                
                if (e.type === 'dragover') {
                    imageElements.uploadArea.classList.add('drag-over');
                } else if (e.type === 'dragleave') {
                    imageElements.uploadArea.classList.remove('drag-over');
                } else if (e.type === 'drop') {
                    imageElements.uploadArea.classList.remove('drag-over');
                    const files = e.dataTransfer.files;
                    if (files.length > 0) {
                        addFilesToSelection(Array.from(files));
                    }
                }
            }
            
            function addFilesToSelection(newFiles) {
                // Validate files first
                const validFiles = validateImageFiles(newFiles);
                if (validFiles.length === 0) return;
                
                // Add new files to existing list (avoid duplicates)
                const actuallyNewFiles = [];
                validFiles.forEach(file => {
                    if (!selectedCompanyImages.some(existingFile => 
                        existingFile.name === file.name && existingFile.size === file.size)) {
                        selectedCompanyImages.push(file);
                        actuallyNewFiles.push(file);
                    }
                });
                
                // Update preview and file input - only process the new files
                if (actuallyNewFiles.length > 0) {
                    handleImagesPreview(actuallyNewFiles);
                }
                updateFileInput();
            }
            
            function validateImageFiles(files) {
                const validFiles = [];
                const maxSize = 1024 * 1024; // 1MB
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
                
                files.forEach(file => {
                    // Check file type
                    if (!allowedTypes.includes(file.type)) {
                        alert(`File "${file.name}" không đúng định dạng. Chỉ chấp nhận JPG, JPEG, PNG, GIF.`);
                        return;
                    }
                    
                    // Check file size
                    if (file.size > maxSize) {
                        alert(`File "${file.name}" quá lớn. Kích thước tối đa là 1MB.`);
                        return;
                    }
                    
                    validFiles.push(file);
                });
                
                return validFiles;
            }
            
            // ========================================
            // HELPER FUNCTIONS
            // ========================================
            
            function handleLogoPreview(file) {
                if (!file?.type.startsWith('image/')) {
                    alert('Vui lòng chọn file hình ảnh hợp lệ.');
                    return;
                }
                
                // Validate logo file
                const maxSize = 1024 * 1024; // 1MB
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
                
                if (!allowedTypes.includes(file.type)) {
                    alert('Logo phải có định dạng JPG, JPEG, PNG hoặc GIF.');
                    return;
                }
                
                if (file.size > maxSize) {
                    alert('Logo quá lớn. Kích thước tối đa là 1MB.');
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = (e) => {
                    logoElements.previewImg.src = e.target.result;
                    logoElements.preview.style.display = 'block';
                    logoElements.uploadArea.style.display = 'none';
                };
                reader.readAsDataURL(file);
            }
            
            function handleImagesPreview(files) {
                if (!imageElements.preview) return;
                
                // Count existing images (both from database and already selected)
                const existingImages = imageElements.preview.querySelectorAll('.existing-image');
                const alreadySelectedImages = imageElements.preview.querySelectorAll('.image-preview-item:not(.existing-image)');
                const totalExisting = existingImages.length + alreadySelectedImages.length;
                const maxImages = 5;
                
                
                if (totalExisting + files.length > maxImages) {
                    alert(`Chỉ có thể upload tối đa ${maxImages} ảnh. Bạn đã có ${totalExisting} ảnh và đang thêm ${files.length} ảnh.`);
                    return;
                }
                
                // Show loading state
                showImageUploadLoading();
                
                // Add all selected files as preview
                let processedCount = 0;
                files.forEach(file => {
                    if (file?.type.startsWith('image/')) {
                        createImagePreview(file, () => {
                            processedCount++;
                            if (processedCount === files.length) {
                                hideImageUploadLoading();
                            }
                        });
                    }
                });
            }
            
            function showImageUploadLoading() {
                const loadingDiv = document.createElement('div');
                loadingDiv.id = 'imageUploadLoading';
                loadingDiv.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý hình ảnh...';
                loadingDiv.style.cssText = 'text-align: center; padding: 20px; color: #007bff; font-size: 14px;';
                imageElements.preview.appendChild(loadingDiv);
            }
            
            function hideImageUploadLoading() {
                const loadingDiv = document.getElementById('imageUploadLoading');
                if (loadingDiv) {
                    loadingDiv.remove();
                }
            }
            
            function createImagePreview(file, callback) {
                const reader = new FileReader();
                reader.onload = (e) => {
                    const previewDiv = document.createElement('div');
                    previewDiv.className = 'image-preview-item';
                    previewDiv.style.cssText = 'position: relative; display: inline-block; margin: 5px;';
                    
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.alt = 'Company Image';
                    img.style.cssText = 'max-width: 150px; max-height: 100px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); object-fit: cover;';
                    
                    // Add file info tooltip
                    const fileInfo = document.createElement('div');
                    fileInfo.className = 'file-info';
                    fileInfo.style.cssText = 'position: absolute; bottom: -20px; left: 0; right: 0; font-size: 10px; color: #666; text-align: center;';
                    fileInfo.textContent = file.name + ' (' + (file.size / 1024).toFixed(1) + 'KB)';
                    
                    const removeBtn = document.createElement('button');
                    removeBtn.type = 'button';
                    removeBtn.className = 'remove-image';
                    removeBtn.onclick = () => removeImagePreview(removeBtn);
                    removeBtn.style.cssText = 'position: absolute; top: -8px; right: -8px; background: #dc3545; color: white; border: none; border-radius: 50%; width: 24px; height: 24px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.2s;';
                    removeBtn.innerHTML = '<i class="fas fa-times"></i>';
                    removeBtn.onmouseover = () => removeBtn.style.transform = 'scale(1.1)';
                    removeBtn.onmouseout = () => removeBtn.style.transform = 'scale(1)';
                    
                    previewDiv.appendChild(img);
                    previewDiv.appendChild(fileInfo);
                    previewDiv.appendChild(removeBtn);
                    imageElements.preview.appendChild(previewDiv);
                    
                    // Update container display
                    imageElements.preview.style.cssText = 'display: flex; flex-wrap: wrap; gap: 15px; margin-top: 15px;';
                    
                    // Call callback when done
                    if (callback) callback();
                };
                reader.readAsDataURL(file);
            }
            
            function updateFileInput() {
                const dataTransfer = new DataTransfer();
                selectedCompanyImages.forEach(file => dataTransfer.items.add(file));
                imageElements.input.files = dataTransfer.files;
            }
            
            // ========================================
            // GLOBAL FUNCTIONS (called from HTML)
            // ========================================
            
            // Remove new image preview (not from database)
            window.removeImagePreview = function(button) {
                const previewDiv = button.parentElement;
                const img = previewDiv.querySelector('img');
                const fileInfo = previewDiv.querySelector('.file-info');
                
                if (img?.src.startsWith('data:')) {
                    // Find and remove from selected files array
                    const fileName = fileInfo ? fileInfo.textContent.split(' (')[0] : '';
                    selectedCompanyImages = selectedCompanyImages.filter(file => 
                        file.name !== fileName
                    );
                    updateFileInput();
                }
                
                // Add fade out animation
                previewDiv.style.transition = 'opacity 0.3s ease';
                previewDiv.style.opacity = '0';
                setTimeout(() => {
                    previewDiv.remove();
                }, 300);
            };
            
            // Remove existing image from database
            window.removeExistingImage = function(button, imagePath) {
                const removedImagesField = document.getElementById('removedImages');
                const currentRemoved = removedImagesField.value;
                
                removedImagesField.value = currentRemoved 
                    ? `${currentRemoved},${imagePath}` 
                    : imagePath;
                
                // Add fade out animation
                const previewDiv = button.parentElement;
                previewDiv.style.transition = 'opacity 0.3s ease';
                previewDiv.style.opacity = '0';
                setTimeout(() => {
                    previewDiv.remove();
                }, 300);
            };
            
        });
    </script>
    
    <style>
        /* Alert Messages */
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        /* Upload Areas */
        .upload-area {
            border: 2px dashed #ddd;
            border-radius: 8px;
            padding: 40px 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }
        .upload-area:hover,
        .upload-area.drag-over {
            border-color: #007bff;
            background-color: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,123,255,0.15);
        }
        .upload-area span {
            color: #007bff;
            font-weight: bold;
        }
        .upload-area i {
            font-size: 2rem;
            color: #007bff;
            margin-bottom: 10px;
        }
        
        /* Image Previews */
        .image-preview {
            margin-top: 15px;
            position: relative;
            display: inline-block;
        }
        .image-preview img {
            max-width: 200px;
            max-height: 150px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .images-preview {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 15px;
            min-height: 50px;
        }
        
        /* Upload limit warning */
        .upload-limit {
            color: #ff6b35;
            font-size: 14px;
            margin: 5px 0 15px 0;
            font-weight: 500;
            background: #fff3cd;
            padding: 8px 12px;
            border-radius: 4px;
            border-left: 4px solid #ff6b35;
        }
        
        .image-preview-item {
            position: relative;
            display: inline-block;
            transition: all 0.3s ease;
        }
        .image-preview-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .image-preview-item img {
            max-width: 150px;
            max-height: 100px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        .file-info {
            position: absolute;
            bottom: -20px;
            left: 0;
            right: 0;
            font-size: 10px;
            color: #666;
            text-align: center;
            background: rgba(255,255,255,0.9);
            padding: 2px 4px;
            border-radius: 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        /* Remove Buttons */
        .remove-image {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        .remove-image:hover {
            background: #c82333;
            transform: scale(1.1);
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
        }
        
        /* Character Counter */
        .char-counter {
            text-align: right;
            margin-top: 5px;
            font-size: 12px;
            color: #666;
        }
    </style>

