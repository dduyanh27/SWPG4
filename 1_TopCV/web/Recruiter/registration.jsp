<%-- 
    Document   : registration
    Created on : Sep 24, 2025, 5:01:58 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - VietnamWorks</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }

        /* Header */
        .header {
            background: linear-gradient(110deg, #031428 0%, #062446 40%, #083d9a 70%, #0a67ff 100%);
            color: white;
            padding: 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-content {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 25px;
            height: 70px;
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logo h1 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .tagline {
            font-size: 12px;
            opacity: 0.9;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .language-selector {
            color: #dc3545;
            cursor: pointer;
            font-size: 18px;
        }

        /* Main Container */
        .main-container {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        /* Left Sidebar */
        .sidebar {
            width: 300px;
            background: white;
            border-right: 1px solid #e9ecef;
            padding: 20px;
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
        }

        .registration-progress {
            margin-bottom: 30px;
        }

        .progress-title {
            font-size: 18px;
            font-weight: bold;
            color: #1A3B7D;
            margin-bottom: 20px;
        }

        .progress-steps {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .progress-step {
            display: flex;
            align-items: center;
            padding: 12px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .progress-step.active {
            background: #e3f2fd;
            border-left: 4px solid #0a67ff;
        }

        .progress-step.completed {
            background: #e8f5e8;
            border-left: 4px solid #28a745;
        }

        .step-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 12px;
            font-size: 14px;
        }

        .step-number.active {
            background: #0a67ff;
            color: white;
        }

        .step-number.completed {
            background: #28a745;
            color: white;
        }

        .step-number.inactive {
            background: #e9ecef;
            color: #6c757d;
        }

        .step-info h4 {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 2px;
        }

        .step-info p {
            font-size: 12px;
            color: #666;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 30px;
            background: #f8f9fa;
        }

        .content-header {
            margin-bottom: 30px;
        }

        .content-header h1 {
            font-size: 28px;
            font-weight: bold;
            color: #1A3B7D;
            margin-bottom: 8px;
        }

        .content-header p {
            color: #666;
            font-size: 14px;
        }

        /* Registration Form */
        .registration-form {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .form-step {
            display: none;
        }

        .form-step.active {
            display: block;
        }

        .step-title {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }

        .step-description {
            color: #666;
            margin-bottom: 25px;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-row {
            display: flex;
            gap: 15px;
        }

        .form-row .form-group {
            flex: 1;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
        }

        .required {
            color: #dc3545;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: white;
        }

        .form-input:focus {
            outline: none;
            border-color: #0a67ff;
            box-shadow: 0 0 0 3px rgba(10, 103, 255, 0.1);
        }

        .form-input.error {
            border-color: #dc3545;
        }

        .form-input.error:focus {
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
        }

        .form-input.touched {
            /* Only show validation styling after user interaction */
        }

        .form-select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            background: white;
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 12px center;
            background-repeat: no-repeat;
            background-size: 16px;
            padding-right: 40px;
        }

        .radio-group {
            margin-bottom: 20px;
        }

        .radio-option {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .radio-input {
            margin-right: 10px;
            width: 18px;
            height: 18px;
        }

        .radio-label {
            font-size: 14px;
            color: #333;
            cursor: pointer;
        }

        .currency-selector {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .currency-btn {
            padding: 8px 16px;
            border: 2px solid #e9ecef;
            border-radius: 6px;
            background: white;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .currency-btn.active {
            background: #0a67ff;
            color: white;
            border-color: #0a67ff;
        }

        .checkbox-group {
            margin-bottom: 20px;
        }

        .checkbox-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .checkbox-input {
            margin-right: 10px;
            margin-top: 2px;
            width: 18px;
            height: 18px;
        }

        .checkbox-label {
            font-size: 14px;
            color: #333;
            line-height: 1.4;
        }

        .checkbox-label a {
            color: #0a67ff;
            text-decoration: none;
        }

        .checkbox-label a:hover {
            text-decoration: underline;
        }

        .recaptcha-container {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            background: #f8f9fa;
        }

        .recaptcha-checkbox {
            width: 18px;
            height: 18px;
        }

        .recaptcha-text {
            font-size: 14px;
            color: #333;
        }

        .recaptcha-logo {
            font-size: 12px;
            color: #666;
        }

        .error-message {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        .error-message.show {
            display: block !important;
        }

        .password-help {
            margin-top: 5px;
            margin-bottom: 5px;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            justify-content: flex-end;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-secondary {
            background: white;
            color: #333;
            border: 2px solid #e9ecef;
        }

        .btn-secondary:hover {
            background: #f8f9fa;
            border-color: #dee2e6;
        }

        .btn-primary {
            background: #ff6b35;
            color: white;
            border: 2px solid #ff6b35;
        }

        .btn-primary:hover {
            background: #e55a2b;
            border-color: #e55a2b;
        }

        .btn-primary:disabled {
            background: #ccc;
            border-color: #ccc;
            cursor: not-allowed;
        }

        /* Right Sidebar */
        .right-sidebar {
            width: 280px;
            background: white;
            border-left: 1px solid #e9ecef;
            padding: 20px;
            box-shadow: -2px 0 10px rgba(0,0,0,0.05);
        }

        .right-sidebar h2 {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }

        .feature-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
        }

        .feature-title {
            font-size: 14px;
            font-weight: bold;
            color: #1A3B7D;
            margin-bottom: 8px;
        }

        .feature-description {
            font-size: 12px;
            color: #666;
            line-height: 1.4;
        }

        .chat-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: #1A3B7D;
            color: white;
            border: none;
            border-radius: 25px;
            padding: 12px 20px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            transition: all 0.3s ease;
        }

        .chat-button:hover {
            background: #2C5AA0;
            transform: translateY(-2px);
        }

        .chat-icon {
            width: 20px;
            height: 20px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: #1A3B7D;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .main-container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                order: 2;
            }
            
            .right-sidebar {
                width: 100%;
                order: 3;
            }
            
            .main-content {
                order: 1;
                padding: 20px;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <div class="logo-section">
                <div class="logo">
                    <h1>vietnamworks</h1>
                    <span class="tagline">Empower growth</span>
                </div>
            </div>
            
            <div class="header-right">
                <div class="language-selector">★ ▼</div>
            </div>
        </div>
    </header>

    <div class="main-container">
        <!-- Left Sidebar -->
        <aside class="sidebar">
            <div class="registration-progress">
                <h3 class="progress-title">Tiến trình đăng ký</h3>
                <div class="progress-steps">
                    <div class="progress-step active" data-step="1">
                        <div class="step-number active">1</div>
                        <div class="step-info">
                            <h4>Thông tin liên lạc</h4>
                            <p>Tên, email, mật khẩu</p>
                        </div>
                    </div>
                    <div class="progress-step inactive" data-step="2">
                        <div class="step-number inactive">2</div>
                        <div class="step-info">
                            <h4>Thông tin công ty</h4>
                            <p>Tên công ty, ngành nghề</p>
                        </div>
                    </div>
                    <div class="progress-step inactive" data-step="3">
                        <div class="step-number inactive">3</div>
                        <div class="step-info">
                            <h4>Nhu cầu tuyển dụng</h4>
                            <p>Mục đích, ngân sách</p>
                        </div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="content-header">
                <h1>Đăng ký tài khoản</h1>
                <p>Hoàn thành các bước để tạo tài khoản VietnamWorks</p>
            </div>
            
            <%
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                
                // Success message
                if (success != null && success.equals("registration_success")) {
            %>
            <div style="background: #d1ecf1; color: #0c5460; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #bee5eb; text-align: center;">
                <i class="fas fa-check-circle" style="font-size: 24px; margin-bottom: 10px;"></i>
                <h3 style="margin: 10px 0; color: #0c5460;">🎉 Đăng ký thành công!</h3>
                <p style="margin: 5px 0;">Tài khoản của bạn đã được tạo thành công và đang chờ phê duyệt.</p>
                <p style="margin: 5px 0; font-size: 14px;">Bạn sẽ được chuyển đến trang đăng nhập sau <span id="countdown">5</span> giây...</p>
            </div>
            <script>
                // Auto redirect after 5 seconds
                let countdown = 5;
                const countdownElement = document.getElementById('countdown');
                const timer = setInterval(() => {
                    countdown--;
                    countdownElement.textContent = countdown;
                    if (countdown <= 0) {
                        clearInterval(timer);
                        window.location.href = '${pageContext.request.contextPath}/Recruiter/recruiter-login.jsp';
                    }
                }, 1000);
            </script>
            <%
                }
                
                // Error message
                if (error != null) {
            %>
            <div style="background: #f8d7da; color: #721c24; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
                <i class="fas fa-exclamation-triangle"></i>
                <%
                    if (error.equals("missing_fields")) {
                %>
                    Vui lòng điền đầy đủ tất cả các trường bắt buộc.
                <%
                    } else if (error.equals("email_exists")) {
                %>
                    Email này đã được sử dụng trong hệ thống (có thể đã đăng ký với vai trò khác). Vui lòng chọn email khác.
                <%
                    } else if (error.equals("registration_failed")) {
                %>
                    Đăng ký thất bại. Vui lòng thử lại sau.
                <%
                    } else if (error.equals("system_error")) {
                %>
                    Có lỗi hệ thống. Vui lòng thử lại sau.
                <%
                    } else {
                %>
                    <%= error %>
                <%
                    }
                %>
            </div>
            <%
                }
            %>
            
            <form id="registrationForm" class="registration-form" action="${pageContext.request.contextPath}/RecruiterRegistrationServlet" method="POST" <%= success != null && success.equals("registration_success") ? "style='display: none;'" : "" %>>
                <!-- Step 1: Contact Information -->
                <div id="step1" class="form-step active">
                    <h2 class="step-title">Thông tin liên lạc</h2>
                    <p class="step-description">Vui lòng cung cấp thông tin cá nhân của bạn</p>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="firstName">
                                Tên <span class="required">*</span>
                            </label>
                            <input type="text" id="firstName" name="firstName" class="form-input" required>
                            <div class="error-message" id="firstNameError">Vui lòng nhập tên</div>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="lastName">
                                Họ <span class="required">*</span>
                            </label>
                            <input type="text" id="lastName" name="lastName" class="form-input" required>
                            <div class="error-message" id="lastNameError">Vui lòng nhập họ</div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="phone">
                            Điện thoại <span class="required">*</span>
                        </label>
                        <input type="tel" id="phone" name="phone" class="form-input" required>
                        <div class="error-message" id="phoneError">Vui lòng nhập số điện thoại</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="email">
                            Địa chỉ email <span class="required">*</span>
                        </label>
                        <input type="email" id="email" name="email" class="form-input" required>
                        <div class="error-message" id="emailError">Vui lòng nhập địa chỉ email hợp lệ</div>
                    </div>

                        <div class="form-group">
                            <label class="form-label" for="password">
                                Mật khẩu <span class="required">*</span>
                            </label>
                            <input type="password" id="password" name="password" class="form-input" required>
                            <div class="password-help">
                                <small style="color: #666; font-size: 12px;">
                                    Mật khẩu phải có ít nhất 8 ký tự, bao gồm: chữ hoa (A-Z), chữ thường (a-z), số (0-9) và ký tự đặc biệt (!@#$%^&*...)
                                </small>
                            </div>
                            <div class="error-message" id="passwordError">Mật khẩu không đáp ứng yêu cầu bảo mật</div>
                        </div>

                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">
                            Nhập lại mật khẩu <span class="required">*</span>
                        </label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" required>
                        <div class="error-message" id="confirmPasswordError">Mật khẩu không khớp</div>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn btn-primary" id="step1ContinueBtn" disabled onclick="goToStep(2)">Tiếp tục</button>
                    </div>
                </div>

                <!-- Step 2: Company Information -->
                <div id="step2" class="form-step">
                    <h2 class="step-title">Thông tin công ty</h2>
                    <p class="step-description">Cung cấp thông tin về công ty của bạn</p>
                    
                    <div class="form-group">
                        <label class="form-label" for="companyName">
                            Tên công ty <span class="required">*</span>
                        </label>
                        <input type="text" id="companyName" name="companyName" class="form-input" required>
                        <div class="error-message" id="companyNameError">Vui lòng nhập tên công ty</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="industry">
                            Ngành nghề
                        </label>
                        <select id="industry" name="industry" class="form-select">
                            <option value="">Chọn ngành nghề</option>
                            <option value="accommodation">Dịch vụ lưu trú/Nhà hàng/Khách sạn/Du lịch</option>
                            <option value="technology">Công nghệ thông tin</option>
                            <option value="finance">Tài chính/Ngân hàng</option>
                            <option value="healthcare">Y tế/Chăm sóc sức khỏe</option>
                            <option value="education">Giáo dục/Đào tạo</option>
                            <option value="manufacturing">Sản xuất</option>
                            <option value="retail">Bán lẻ</option>
                            <option value="construction">Xây dựng</option>
                            <option value="other">Khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="address">
                            Địa chỉ <span class="required">*</span>
                        </label>
                        <select id="address" name="address" class="form-select" required>
                            <option value="">Chọn</option>
                            <option value="hanoi">Hà Nội</option>
                            <option value="hcm">TP. Hồ Chí Minh</option>
                            <option value="danang">Đà Nẵng</option>
                            <option value="haiphong">Hải Phòng</option>
                            <option value="cantho">Cần Thơ</option>
                            <option value="other">Tỉnh/Thành phố khác</option>
                        </select>
                        <div class="error-message" id="addressError">Vui lòng chọn địa chỉ</div>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="goToStep(1)">Quay lại</button>
                        <button type="button" class="btn btn-primary" id="step2ContinueBtn" disabled onclick="goToStep(3)">Tiếp tục</button>
                    </div>
                </div>

                <!-- Step 3: Recruitment Information -->
                <div id="step3" class="form-step">
                    <h2 class="step-title">Nhu cầu tuyển dụng</h2>
                    <p class="step-description">Hãy cho chúng tôi biết nhu cầu tuyển dụng của bạn</p>
                    
                    <div class="radio-group">
                        <label class="form-label">
                            Bạn muốn làm gì trên VietnamWorks?
                        </label>
                        <div class="radio-option">
                            <input type="radio" id="postJob" name="purpose" value="post" class="radio-input">
                            <label for="postJob" class="radio-label">Đăng tuyển</label>
                        </div>
                        <div class="radio-option">
                            <input type="radio" id="searchProfiles" name="purpose" value="search" class="radio-input">
                            <label for="searchProfiles" class="radio-label">Tìm kiếm hồ sơ</label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="jobPositions">
                            Bạn đang tuyển dụng những vị trí nào?
                        </label>
                        <input type="text" id="jobPositions" name="jobPositions" class="form-input" placeholder="Nhập chức danh">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="jobLevel">
                            Cấp bậc bạn đang muốn tuyển?
                        </label>
                        <select id="jobLevel" name="jobLevel" class="form-select">
                            <option value="">Chọn cấp bậc</option>
                            <option value="intern">Thực tập sinh</option>
                            <option value="junior">Nhân viên</option>
                            <option value="senior">Chuyên viên</option>
                            <option value="manager">Quản lý</option>
                            <option value="director">Giám đốc</option>
                            <option value="executive">Điều hành</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="budget">
                            Tổng ngân sách dành cho tuyển dụng
                        </label>
                        <select id="budget" name="budget" class="form-select">
                            <option value="">Chọn</option>
                            <option value="under-1000">Dưới 1,000 USD</option>
                            <option value="1000-5000">1,000 - 5,000 USD</option>
                            <option value="5000-10000">5,000 - 10,000 USD</option>
                            <option value="10000-20000">10,000 - 20,000 USD</option>
                            <option value="over-20000">Trên 20,000 USD</option>
                        </select>
                        <div class="currency-selector">
                            <button type="button" class="currency-btn active" onclick="selectCurrency('USD')">USD</button>
                            <button type="button" class="currency-btn" onclick="selectCurrency('VND')">VND</button>
                        </div>
                    </div>

                    <div class="checkbox-group">
                        <div class="checkbox-item">
                            <input type="checkbox" id="privacyPolicy" name="privacyPolicy" class="checkbox-input" required>
                            <label for="privacyPolicy" class="checkbox-label">
                                Tôi đã đọc và đồng ý với các <a href="#">Quy định bảo mật</a> và <a href="#">Thỏa thuận sử dụng</a>
                            </label>
                        </div>
                        <div class="error-message" id="privacyPolicyError">Vui lòng đồng ý với điều khoản</div>
                    </div>


                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="goToStep(2)">Quay lại</button>
                        <button type="submit" class="btn btn-primary" id="step3SubmitBtn" disabled>Hoàn thành</button>
                    </div>
                </div>
            </form>
        </main>

        <!-- Right Sidebar -->
        <aside class="right-sidebar">
            <h2>Tính năng nổi bật</h2>
            
            <div class="feature-card">
                <div class="feature-title">Hệ thống quản lý Ứng viên</div>
                <div class="feature-description">
                    Quản lý hồ sơ ứng viên chỉ với thao tác kéo-thả trên giao diện thân thiện với nhiều tính năng hữu ích.
                </div>
            </div>

            <div class="feature-card">
                <div class="feature-title">Chương trình Bảo hành Tin đăng</div>
                <div class="feature-description">
                    Bạn có thể yêu cầu bảo hành cho tất cả tin đăng của mình trên VietnamWorks
                </div>
            </div>

            <div class="feature-card">
                <div class="feature-title">Giọng nói thành Văn bản</div>
                <div class="feature-description">
                    Cải thiện kỹ năng phỏng vấn bằng cách chuyển những bài phỏng vấn thành văn bản.
                </div>
            </div>
        </aside>
    </div>

    <button class="chat-button">
        <div class="chat-icon">💬</div>
        Trò chuyện
    </button>

    <script>
        // Global variables
        let currentStep = 1;
        let selectedCurrency = 'USD';

        // Step validation fields
        const step1Fields = ['firstName', 'lastName', 'phone', 'email', 'password', 'confirmPassword'];
        const step2Fields = ['companyName', 'address'];
        const step3Fields = []; // No required fields in step 3

        // Initialize form
        document.addEventListener('DOMContentLoaded', function() {
            initializeStep1();
            initializeStep2();
            initializeStep3();
        });

        // Step 1 functions
        function initializeStep1() {
            step1Fields.forEach(fieldName => {
                const field = document.getElementById(fieldName);
                if (field) {
                    // Mark field as touched when user starts typing
                    field.addEventListener('input', () => {
                        field.classList.add('touched');
                        validateStep1Field(fieldName);
                        checkStep1Validity();
                    });
                    
                    // Mark field as touched when user leaves the field
                    field.addEventListener('blur', () => {
                        field.classList.add('touched');
                        validateStep1Field(fieldName);
                        checkStep1Validity();
                    });
                }
            });
            checkStep1Validity();
        }

        function validateStep1Field(fieldName) {
            const field = document.getElementById(fieldName);
            const errorElement = document.getElementById(fieldName + 'Error');
            let isValid = true;

            // Only show error if field has been touched (user interacted with it)
            const hasBeenTouched = field.classList.contains('touched');
            
            field.classList.remove('error');
            if (errorElement) {
                errorElement.classList.remove('show');
            }

            if (!field.value.trim()) {
                isValid = false;
            } else {
                switch(fieldName) {
                    case 'email':
                        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                        if (!emailRegex.test(field.value)) {
                            isValid = false;
                        }
                        break;
                    case 'phone':
                        const phoneRegex = /^[0-9+\-\s()]+$/;
                        if (!phoneRegex.test(field.value) || field.value.length < 10) {
                            isValid = false;
                        }
                        break;
                    case 'password':
                        const password = field.value;
                        const hasUpperCase = /[A-Z]/.test(password);
                        const hasLowerCase = /[a-z]/.test(password);
                        const hasNumbers = /\d/.test(password);
                        const hasSpecialChar = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password);
                        const isLongEnough = password.length >= 8;
                        
                        if (!isLongEnough || !hasUpperCase || !hasLowerCase || !hasNumbers || !hasSpecialChar) {
                            isValid = false;
                        }
                        break;
                    case 'confirmPassword':
                        const passwordValue = document.getElementById('password').value;
                        if (field.value !== passwordValue) {
                            isValid = false;
                        }
                        break;
                }
            }

            // Only show error styling if field has been touched
            if (!isValid && hasBeenTouched) {
                field.classList.add('error');
                if (errorElement) {
                    errorElement.classList.add('show');
                }
            }

            return isValid;
        }

        function checkStep1Validity() {
            const allValid = step1Fields.every(fieldName => {
                const field = document.getElementById(fieldName);
                return field.value.trim() !== '' && !field.classList.contains('error');
            });

            const emailValid = validateStep1Field('email');
            const phoneValid = validateStep1Field('phone');
            const passwordValid = validateStep1Field('password');
            const confirmPasswordValid = validateStep1Field('confirmPassword');

            const formValid = allValid && emailValid && phoneValid && passwordValid && confirmPasswordValid;
            
            const continueBtn = document.getElementById('step1ContinueBtn');
            continueBtn.disabled = !formValid;
            
            if (formValid) {
                continueBtn.style.opacity = '1';
                continueBtn.style.cursor = 'pointer';
            } else {
                continueBtn.style.opacity = '0.6';
                continueBtn.style.cursor = 'not-allowed';
            }

            return formValid;
        }

        // Step 2 functions
        function initializeStep2() {
            step2Fields.forEach(fieldName => {
                const field = document.getElementById(fieldName);
                if (field) {
                    field.addEventListener('input', () => {
                        field.classList.add('touched');
                        validateStep2Field(fieldName);
                        checkStep2Validity();
                    });
                    field.addEventListener('change', () => {
                        field.classList.add('touched');
                        validateStep2Field(fieldName);
                        checkStep2Validity();
                    });
                }
            });
            checkStep2Validity();
        }

        function validateStep2Field(fieldName) {
            const field = document.getElementById(fieldName);
            const errorElement = document.getElementById(fieldName + 'Error');
            let isValid = true;

            const hasBeenTouched = field.classList.contains('touched');
            
            field.classList.remove('error');
            errorElement.style.display = 'none';

            if (!field.value.trim()) {
                isValid = false;
            }

            if (!isValid && hasBeenTouched) {
                field.classList.add('error');
                errorElement.style.display = 'block';
            }

            return isValid;
        }

        function checkStep2Validity() {
            const allValid = step2Fields.every(fieldName => {
                const field = document.getElementById(fieldName);
                return field.value.trim() !== '' && !field.classList.contains('error');
            });

            const continueBtn = document.getElementById('step2ContinueBtn');
            continueBtn.disabled = !allValid;
            
            if (allValid) {
                continueBtn.style.opacity = '1';
                continueBtn.style.cursor = 'pointer';
            } else {
                continueBtn.style.opacity = '0.6';
                continueBtn.style.cursor = 'not-allowed';
            }

            return allValid;
        }

        // Step 3 functions
        function initializeStep3() {
            // Required fields
            step3Fields.forEach(fieldName => {
                const field = document.getElementById(fieldName);
                if (field) {
                    field.addEventListener('input', () => {
                        field.classList.add('touched');
                        validateStep3Field(fieldName);
                        checkStep3Validity();
                    });
                    field.addEventListener('change', () => {
                        field.classList.add('touched');
                        validateStep3Field(fieldName);
                        checkStep3Validity();
                    });
                }
            });

            // Radio buttons
            const purposeRadios = document.querySelectorAll('input[name="purpose"]');
            purposeRadios.forEach(radio => {
                radio.addEventListener('change', () => {
                    validateStep3Field('purpose');
                    checkStep3Validity();
                });
            });

            // Checkboxes
            const privacyCheckbox = document.getElementById('privacyPolicy');
            
            if (privacyCheckbox) {
                privacyCheckbox.addEventListener('change', () => {
                    validateStep3Field('privacyPolicy');
                    checkStep3Validity();
                });
            }

            checkStep3Validity();
        }

        function validateStep3Field(fieldName) {
            const errorElement = document.getElementById(fieldName + 'Error');
            let isValid = true;

            if (errorElement) {
                errorElement.style.display = 'none';
            }

            switch(fieldName) {
                case 'purpose':
                    const purposeRadios = document.querySelectorAll('input[name="purpose"]');
                    isValid = Array.from(purposeRadios).some(radio => radio.checked);
                    break;
                case 'privacyPolicy':
                    const privacyCheckbox = document.getElementById('privacyPolicy');
                    isValid = privacyCheckbox && privacyCheckbox.checked;
                    break;
                default:
                    const field = document.getElementById(fieldName);
                    if (field) {
                        const hasBeenTouched = field.classList.contains('touched');
                        field.classList.remove('error');
                        isValid = field.value.trim() !== '';
                        if (!isValid && hasBeenTouched) {
                            field.classList.add('error');
                        }
                    }
            }

            if (!isValid && errorElement) {
                errorElement.style.display = 'block';
            }

            return isValid;
        }

        function checkStep3Validity() {
            const privacyValid = validateStep3Field('privacyPolicy');
            const formValid = privacyValid;
            
            const submitBtn = document.getElementById('step3SubmitBtn');
            
            if (submitBtn) {
                submitBtn.disabled = !formValid;
                
                if (formValid) {
                    submitBtn.style.opacity = '1';
                    submitBtn.style.cursor = 'pointer';
                } else {
                    submitBtn.style.opacity = '0.6';
                    submitBtn.style.cursor = 'not-allowed';
                }
            }
            return formValid;
        }

        // Navigation functions
        function goToStep(step) {
            // Allow going back to previous steps
            if (step < currentStep) {
                // Hide current step
                document.getElementById('step' + currentStep).classList.remove('active');
                
                // Show new step
                document.getElementById('step' + step).classList.add('active');
                
                // Update progress indicator
                updateProgressIndicator(step);
                
                currentStep = step;
                return;
            }

            // Validate current step before proceeding to next step
            let isValid = false;
            if (currentStep === 1) {
                isValid = checkStep1Validity();
            } else if (currentStep === 2) {
                isValid = checkStep2Validity();
            }

            if (isValid) {
                // Hide current step
                document.getElementById('step' + currentStep).classList.remove('active');
                
                // Show new step
                document.getElementById('step' + step).classList.add('active');
                
                // Update progress indicator
                updateProgressIndicator(step);
                
                currentStep = step;
            } else {
                console.log('Form validation failed for step', currentStep);
            }
        }

        function updateProgressIndicator(step) {
            const steps = document.querySelectorAll('.progress-step');
            
            steps.forEach((stepElement, index) => {
                const stepNumber = stepElement.querySelector('.step-number');
                stepElement.classList.remove('active', 'completed', 'inactive');
                stepNumber.classList.remove('active', 'completed', 'inactive');
                
                if (index + 1 < step) {
                    stepElement.classList.add('completed');
                    stepNumber.classList.add('completed');
                    stepNumber.innerHTML = '✓';
                } else if (index + 1 === step) {
                    stepElement.classList.add('active');
                    stepNumber.classList.add('active');
                    stepNumber.innerHTML = index + 1;
                } else {
                    stepElement.classList.add('inactive');
                    stepNumber.classList.add('inactive');
                    stepNumber.innerHTML = index + 1;
                }
            });
        }

        function selectCurrency(currency) {
            selectedCurrency = currency;
            document.querySelectorAll('.currency-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');
        }

        // Form submission
        document.getElementById('registrationForm').addEventListener('submit', function(e) {
            // Check if we're on step 3
            if (currentStep !== 3) {
                e.preventDefault();
                return false;
            }
            
            // Validate step 3
            const isValid = checkStep3Validity();
            
            if (!isValid) {
                e.preventDefault();
                return false;
            }
            
            // If validation passes, let the form submit naturally
            
            // Show loading state
            const submitBtn = document.getElementById('step3SubmitBtn');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = 'Đang xử lý...';
            }
        });
    </script>
</body>
</html>