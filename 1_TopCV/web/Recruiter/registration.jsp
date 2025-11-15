<%-- 
    Document   : registration
    Created on : Sep 24, 2025, 5:01:58 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="no-js">
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
            border-color: inherit;
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

        /* Phone validation styles */
        .phone-input {
            position: relative;
        }
        
        .phone-validation-indicator {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 16px;
        }
        
        .phone-validation-indicator.checking {
            color: #007bff;
        }
        
        .phone-validation-indicator.valid {
            color: #28a745;
        }
        
        .phone-validation-indicator.invalid {
            color: #dc3545;
        }
        
        .phone-validation-indicator.exists {
            color: #ffc107;
        }
        
        .validation-feedback {
            margin-top: 5px;
            font-size: 12px;
            padding: 5px 10px;
            border-radius: 4px;
            display: none;
        }
        
        .validation-feedback.checking {
            display: block;
            background-color: #f8f9fa;
            color: #6c757d;
            border: 1px solid #dee2e6;
        }
        
        .validation-feedback.valid {
            display: block;
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .validation-feedback.invalid {
            display: block;
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .validation-feedback.exists {
            display: block;
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        /* Email validation styles */
        .email-input {
            position: relative;
        }
        
        .email-validation-indicator {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 16px;
        }
        
        .email-validation-indicator.checking {
            color: #007bff;
        }
        
        .email-validation-indicator.valid {
            color: #28a745;
        }
        
        .email-validation-indicator.exists {
            color: #dc3545;
        }
        
        /* Hide validation elements when JavaScript is disabled */
        noscript .phone-validation-indicator,
        noscript .email-validation-indicator,
        noscript .validation-feedback {
            display: none !important;
        }
        
        /* Enhanced progressive enhancement */
        .no-js .phone-validation-indicator,
        .no-js .email-validation-indicator,
        .no-js .validation-feedback {
            display: none !important;
        }
        
        .js-enhanced .validate-on-input {
            /* Enhanced styles for JS-enabled browsers */
            transition: all 0.3s ease;
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
    <!-- Noscript message -->
    <noscript>
        <div style="background: #fff3cd; color: #856404; padding: 15px; margin: 20px; border-radius: 8px; border: 1px solid #ffeaa7;">
            <strong>Lưu ý:</strong> Trình duyệt của bạn đã tắt JavaScript. Form sẽ hoạt động với validation cơ bản, tuy nhiên để có trải nghiệm tốt nhất, vui lòng bật JavaScript.
        </div>
    </noscript>
    
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
                            <p>Tên công ty, mã số thuế, giấy phép</p>
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
                String processedImagePath = request.getParameter("processedImage");
                
                // Success message
                if (success != null && success.equals("registration_success")) {
            %>
            <div style="background: #d1ecf1; color: #0c5460; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #bee5eb;">
                <div style="text-align: center;">
                    <i class="fas fa-check-circle" style="font-size: 24px; margin-bottom: 10px;"></i>
                    <h3 style="margin: 10px 0; color: #0c5460;">🎉 Đăng ký thành công!</h3>
                    <p style="margin: 5px 0;">Tài khoản của bạn đã được tạo thành công!</p>
                    <p style="margin: 5px 0; font-size: 14px;">Bạn sẽ được chuyển đến trang chủ sau <span id="countdown">5</span> giây...</p>
                </div>
                
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
                        window.location.href = '${pageContext.request.contextPath}/Recruiter/index.jsp';
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
                    } else if (error.equals("invalid_phone")) {
                %>
                    Số điện thoại không hợp lệ. Vui lòng nhập số điện thoại Việt Nam (bắt đầu bằng 03, 08 hoặc 09) với đúng 10 số.
                <%
                    } else if (error.equals("phone_exists")) {
                %>
                    Số điện thoại này đã được sử dụng trong hệ thống. Vui lòng chọn số điện thoại khác.
                <%
                    } else if (error.equals("invalid_email")) {
                %>
                    Địa chỉ email không hợp lệ. Vui lòng nhập địa chỉ email đúng định dạng.
                <%
                    } else if (error.equals("email_exists")) {
                %>
                    Email này đã được sử dụng trong hệ thống (có thể đã đăng ký với vai trò khác). Vui lòng chọn email khác.
                <%
                    } else if (error.equals("invalid_tax_code")) {
                %>
                    Mã số thuế không hợp lệ. Vui lòng nhập đúng 10 số.
                <%
                    } else if (error.equals("file_required")) {
                %>
                    Vui lòng tải lên ảnh giấy phép đăng ký doanh nghiệp.
                <%
                    } else if (error.equals("invalid_file_type")) {
                %>
                    Định dạng file không được hỗ trợ. Vui lòng tải lên file JPG, PNG hoặc PDF.
                <%
                    } else if (error.equals("file_upload_failed")) {
                %>
                    Không thể tải lên file. Vui lòng thử lại sau.
                <%
                    } else if (error.equals("file_processing_failed")) {
                %>
                    Không thể xử lý file. Vui lòng thử lại sau.
                <%
                    } else if (error.equals("file_too_large")) {
                %>
                    File quá lớn. Vui lòng chọn file nhỏ hơn 5MB.
                <%
                    } else if (error.equals("image_too_small")) {
                %>
                    Kích thước ảnh quá nhỏ. Vui lòng chọn ảnh có kích thước tối thiểu 100x100 pixels.
                <%
                    } else if (error.equals("processing_error")) {
                %>
                    Lỗi xử lý file. Vui lòng thử lại sau.
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
            
            
            
            <form id="registrationForm" class="registration-form" action="${pageContext.request.contextPath}/RecruiterRegistrationServlet" method="POST" enctype="multipart/form-data" <%= success != null && success.equals("registration_success") ? "style='display: none;'" : "" %>>
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
                        <div class="phone-input">
                            <input type="tel" id="phone" name="phone" 
                                   pattern="^[0-9]{10}$" 
                                   minlength="10" maxlength="10"
                                   title="Số điện thoại Việt Nam: Bắt đầu bằng 03, 08 hoặc 09 với đúng 10 số, không có khoảng trắng hoặc ký tự đặc biệt" 
                                   class="form-input" placeholder="Nhập số điện thoại (10 số)" required>
                            <div class="phone-validation-indicator" id="phoneIndicator" style="display: none;"></div>
                        </div>
                        <div class="error-message" id="phoneError">Vui lòng nhập số điện thoại hợp lệ</div>
                        <div class="validation-feedback" id="phoneFeedback"></div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="email">
                            Địa chỉ email <span class="required">*</span>
                        </label>
                        <div class="email-input">
                            <input type="email" id="email" name="email" 
                                   title="Vui lòng nhập địa chỉ email hợp lệ, không có khoảng trắng ở đầu/cuối" 
                                   class="form-input" placeholder="Nhập địa chỉ email" required>
                            <div class="email-validation-indicator" id="emailIndicator" style="display: none;"></div>
                        </div>
                        <div class="error-message" id="emailError">Vui lòng nhập địa chỉ email hợp lệ</div>
                        <div class="validation-feedback" id="emailFeedback"></div>
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
                        <label class="form-label" for="category">
                            Ngành nghề <span class="required">*</span>
                        </label>
                        
                        
                        <select id="category" name="category" class="form-select" required>
                            <option value="">Chọn ngành nghề</option>
                            <c:choose>
                                <c:when test="${parentCategories != null && !parentCategories.isEmpty()}">
                                    <c:forEach var="category" items="${parentCategories}">
                                        <option value="${category.categoryID}">${category.categoryName}</option>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <option value="1">Test Category (No Data)</option>
                                </c:otherwise>
                            </c:choose>
                        </select>
                        <div class="error-message" id="categoryError">Vui lòng chọn ngành nghề</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="address">
                            Địa chỉ <span class="required">*</span>
                        </label>
                        <select id="address" name="address" class="form-select" required>
                            <option value="">Chọn địa chỉ</option>
                            <c:choose>
                                <c:when test="${locations != null && !locations.isEmpty()}">
                                    <c:forEach var="location" items="${locations}">
                                        <option value="${location.locationID}">${location.locationName}</option>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <option value="1">Không có dữ liệu</option>
                                </c:otherwise>
                            </c:choose>
                        </select>
                        <div class="error-message" id="addressError">Vui lòng chọn địa chỉ</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="taxCode">
                            Mã số thuế (không bắt buộc)
                        </label>
                        <input type="text" id="taxCode" name="taxCode" class="form-input" 
                               placeholder="Nhập mã số thuế công ty" 
                               pattern="^[0-9]{10}$" 
                               minlength="10" maxlength="10"
                               title="Mã số thuế phải có đúng 10 số">
                        <div class="error-message" id="taxCodeError" style="display:none;">Vui lòng nhập mã số thuế hợp lệ (10 số)</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="registrationCert">
                            Ảnh Giấy phép đăng ký doanh nghiệp (không bắt buộc)
                        </label>
                        <input type="file" id="registrationCert" name="registrationCert" class="form-input" 
                               accept="image/*" 
                               title="Vui lòng tải lên ảnh giấy phép đăng ký doanh nghiệp">
                        <small style="color: #666; font-size: 12px; margin-top: 5px; display: block;">
                            Định dạng hỗ trợ: JPG, PNG, PDF. Kích thước tối đa: 5MB
                        </small>
                        <div class="error-message" id="registrationCertError" style="display:none;">Vui lòng tải lên ảnh giấy phép đăng ký doanh nghiệp</div>
                        
                        <!-- Image preview container -->
                        <div id="imagePreview" style="margin-top: 10px; display: none;">
                            <img id="previewImg" style="max-width: 200px; max-height: 150px; border: 1px solid #ddd; border-radius: 4px; margin-bottom: 8px;" />
                            <div style="text-align: right;">
                                <button type="button" onclick="removeImage()" style="padding: 4px 12px; font-size: 12px; background: #dc3545; color: white; border: none; border-radius: 3px; cursor: pointer;">Xóa</button>
                            </div>
                        </div>
                        
                        <!-- File info display -->
                        <div id="fileInfo" style="margin-top: 10px;"></div>
                        
                        <!-- Official processed image display (will be shown after successful upload) -->
                        <div id="officialImageContainer" style="margin-top: 10px; display: none;">
                            <div style="background: #d4edda; color: #0c5460; padding: 10px; border-radius: 4px; border: 1px solid #c3e6cb;">
                                <strong>✅ Ảnh đã được xử lý và lưu</strong>
                            </div>
                            <img id="officialImage" style="max-width: 200px; max-height: 150px; margin-top: 10px; border: 2px solid #28a745; border-radius: 4px;" />
                            <div style="font-size: 12px; color: #6c757d; margin-top: 5px;">
                                Đây là ảnh chính thức đã được xử lý và lưu trên server
                            </div>
                        </div>
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
                            <c:choose>
                                <c:when test="${jobLevels != null && !jobLevels.isEmpty()}">
                                    <c:forEach var="jobLevel" items="${jobLevels}">
                                        <option value="${jobLevel.typeID}">${jobLevel.typeName}</option>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <option value="1">Không có dữ liệu</option>
                                </c:otherwise>
                            </c:choose>
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
        const step2Fields = ['companyName', 'address', 'category'];
        const step3Fields = []; // No required fields in step 3

        // Progressive Enhancement - Add JS class to body
        document.documentElement.className = document.documentElement.className.replace('no-js', 'js-enhanced');
        document.body.classList.add('js-enhanced');

        // Initialize form
        document.addEventListener('DOMContentLoaded', function() {
            initializeStep1();
            initializeStep2();
            initializeStep3();
            initializeValidation();
            
            // Add enhanced class to form fields
            const phoneInput = document.getElementById('phone');
            const emailInput = document.getElementById('email');
            if (phoneInput) phoneInput.classList.add('validate-on-input');
            if (emailInput) emailInput.classList.add('validate-on-input');
        });

        // Validation state variables
        let phoneValidationState = 'none'; // none, checking, valid, invalid, exists
        let emailValidationState = 'none';
        let taxCodeValidationState = 'none'; // none, checking, valid, invalid, exists
        let phoneValidationTimeout = null;
        let emailValidationTimeout = null;

        // Initialize AJAX validation
        function initializeValidation() {
            const phoneInput = document.getElementById('phone');
            const emailInput = document.getElementById('email');

            // Phone validation
            phoneInput.addEventListener('input', function() {
                const value = this.value.trim();
                
                // Clear previous timeout
                if (phoneValidationTimeout) {
                    clearTimeout(phoneValidationTimeout);
                }
                
                // Reset validation state
                phoneValidationState = 'none';
                updatePhoneValidationUI();
                
                if (value.length > 0) {
                    // Check for any spaces first (including middle spaces)
                    if (value.includes(' ')) {
                        // Contains any spaces - invalid
                        phoneValidationState = 'invalid';
                        updatePhoneValidationUI();
                        return;
                    }
                    
                    // No spaces - validate format  
                    const phoneRegex = /^(03|08|09)\d{8}$/;
                    
                    if (value.length !== 10) {
                        // Not exactly 10 digits
                        phoneValidationState = 'invalid';
                        updatePhoneValidationUI();
                    } else if (!phoneRegex.test(value)) {
                        // Wrong format (not 03/08/09 + 8 digits)
                        phoneValidationState = 'invalid';
                        updatePhoneValidationUI();
                    } else {
                        // Format is valid, check for duplicates after delay
                        phoneValidationTimeout = setTimeout(() => {
                            checkPhoneDuplicate(value.trim());
                        }, 500);
                    }
                }
            });

            // Email validation
            emailInput.addEventListener('input', function() {
                const value = this.value.trim();
                
                // Clear previous timeout
                if (emailValidationTimeout) {
                    clearTimeout(emailValidationTimeout);
                }
                
                // Reset validation state
                emailValidationState = 'none';
                updateEmailValidationUI();
                
                if (value.length > 0) {
                    // Check for leading/trailing spaces first
                    if (value !== value.trim()) {
                        emailValidationState = 'invalid';
                        updateEmailValidationUI();
                        return;
                    }
                    
                    // Validate format after trimming
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    
                    if (emailRegex.test(value.trim())) {
                        // Format is valid, check for duplicates after delay
                        emailValidationTimeout = setTimeout(() => {
                            checkEmailDuplicate(value.trim());
                        }, 500);
                    } else {
                        // Format is invalid - show error immediately
                        emailValidationState = 'invalid';
                        updateEmailValidationUI();
                    }
                }
            });
        }

        // Check phone number duplicate
        function checkPhoneDuplicate(phone) {
            phoneValidationState = 'checking';
            updatePhoneValidationUI();
            
            var phoneValidationUrl = encodeURIComponent(phone);
            var fetchUrl = '${pageContext.request.contextPath}/RegistrationValidationServlet?check=phone&value=' + phoneValidationUrl;
            
            fetch(fetchUrl)
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        phoneValidationState = 'none';
                    } else {
                        phoneValidationState = data.exists ? 'exists' : 'valid';
                    }
                    updatePhoneValidationUI();
                    checkStep1Validity(); // Re-check form validity
                })
                .catch(error => {
                    console.error('Phone validation error:', error);
                    phoneValidationState = 'none';
                    updatePhoneValidationUI();
                    checkStep1Validity(); // Re-check form validity
                });
        }

        // Check email duplicate
        function checkEmailDuplicate(email) {
            emailValidationState = 'checking';
            updateEmailValidationUI();
            
            var emailValidationUrl = encodeURIComponent(email);
            var fetchUrl = '${pageContext.request.contextPath}/RegistrationValidationServlet?check=email&value=' + emailValidationUrl;
            
            fetch(fetchUrl)
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        emailValidationState = 'none';
                    } else {
                        emailValidationState = data.exists ? 'exists' : 'valid';
                    }
                    updateEmailValidationUI();
                    checkStep1Validity(); // Re-check form validity
                })
                .catch(error => {
                    console.error('Email validation error:', error);
                    emailValidationState = 'none';
                    updateEmailValidationUI();
                    checkStep1Validity(); // Re-check form validity
                });
        }

        // Update phone validation UI
        function updatePhoneValidationUI() {
            const indicator = document.getElementById('phoneIndicator');
            const feedback = document.getElementById('phoneFeedback');
            const input = document.getElementById('phone');
            
            // Reset classes
            indicator.className = 'phone-validation-indicator';
            feedback.className = 'validation-feedback';
            indicator.style.display = 'none';
            feedback.style.display = 'none';
            
            switch (phoneValidationState) {
                case 'checking':
                    indicator.innerHTML = '⟳';
                    indicator.classList.add('checking');
                    indicator.style.display = 'block';
                    feedback.textContent = 'Đang kiểm tra số điện thoại...';
                    feedback.classList.add('checking');
                    feedback.style.display = 'block';
                    break;
                case 'valid':
                    indicator.innerHTML = '✓';
                    indicator.classList.add('valid');
                    indicator.style.display = 'block';
                    // Don't show feedback message for valid state
                    feedback.style.display = 'none';
                    input.classList.remove('error');
                    break;
                case 'invalid':
                    indicator.innerHTML = '✗';
                    indicator.classList.add('invalid');
                    indicator.style.display = 'block';
                    feedback.textContent = 'Số điện thoại không hợp lệ. Không được có khoảng trắng và phải bắt đầu bằng 03, 08 hoặc 09 với đúng 10 số';
                    feedback.classList.add('invalid');
                    feedback.style.display = 'block';
                    input.classList.add('error');
                    break;
                case 'exists':
                    indicator.innerHTML = '⚠';
                    indicator.classList.add('exists');
                    indicator.style.display = 'block';
                    feedback.textContent = 'Số điện thoại này đã được sử dụng';
                    feedback.classList.add('exists');
                    feedback.style.display = 'block';
                    input.classList.add('error');
                    break;
            }
        }

        // Update email validation UI
        function updateEmailValidationUI() {
            const indicator = document.getElementById('emailIndicator');
            const feedback = document.getElementById('emailFeedback');
            const input = document.getElementById('email');
            
            // Reset classes
            indicator.className = 'email-validation-indicator';
            feedback.className = 'validation-feedback';
            indicator.style.display = 'none';
            feedback.style.display = 'none';
            
            switch (emailValidationState) {
                case 'checking':
                    indicator.innerHTML = '⟳';
                    indicator.classList.add('checking');
                    indicator.style.display = 'block';
                    feedback.textContent = 'Đang kiểm tra email...';
                    feedback.classList.add('checking');
                    feedback.style.display = 'block';
                    break;
                case 'valid':
                    indicator.innerHTML = '✓';
                    indicator.classList.add('valid');
                    indicator.style.display = 'block';
                    // Don't show feedback message for valid state
                    feedback.style.display = 'none';
                    input.classList.remove('error');
                    break;
                case 'invalid':
                    indicator.innerHTML = '✗';
                    indicator.classList.add('invalid');
                    indicator.style.display = 'block';
                    feedback.textContent = 'Email không hợp lệ. Không được có khoảng trắng ở đầu/cuối và phải đúng định dạng';
                    feedback.classList.add('invalid');
                    feedback.style.display = 'block';
                    input.classList.add('error');
                    break;
                case 'exists':
                    indicator.innerHTML = '✗';
                    indicator.classList.add('exists');
                    indicator.style.display = 'block';
                    feedback.textContent = 'Email này đã được sử dụng';
                    feedback.classList.add('exists');
                    feedback.style.display = 'block';
                    input.classList.add('error');
                    break;
            }
        }

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
                        // Check for spaces first - invalid if any spaces exist
                        if (field.value.includes(' ')) {
                            isValid = false;
                        } else {
                            const phoneRegex = /^(03|08|09)\d{8}$/;
                            if (!phoneRegex.test(field.value) || field.value.length !== 10) {
                            isValid = false;
                            }
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

            // Check AJAX validation states
            const emailAvailable = emailValidationState === 'valid';
            const phoneAvailable = phoneValidationState === 'valid';

            const formValid = allValid && emailValid && phoneValid && passwordValid && confirmPasswordValid && emailAvailable && phoneAvailable;
            
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
            // Optional field AJAX validations
            const taxCodeInput = document.getElementById('taxCode');
            if (taxCodeInput) {
                let taxDebounce;
                taxCodeInput.addEventListener('input', () => {
                    const value = taxCodeInput.value.trim();
                    if (taxDebounce) clearTimeout(taxDebounce);
                    if (value.length === 0) {
                        taxCodeValidationState = 'none';
                        clearFieldError('taxCode');
                        checkStep2Validity();
                        return;
                    }
                    // format check first
                    const taxRegex = /^[0-9]{10}$/;
                    if (!taxRegex.test(value)) {
                        taxCodeValidationState = 'invalid';
                        setFieldError('taxCode', 'Vui lòng nhập mã số thuế hợp lệ (10 số)');
                        checkStep2Validity();
                        return;
                    }
                    taxCodeValidationState = 'checking';
                    setFieldError('taxCode', 'Đang kiểm tra mã số thuế...');
                    taxDebounce = setTimeout(() => ajaxValidateTaxCode(value), 500);
                });
            }
            const regCertInput = document.getElementById('registrationCert');
            if (regCertInput) {
                regCertInput.addEventListener('change', () => {
                    if (regCertInput.files && regCertInput.files.length > 0) {
                        ajaxValidateRegistrationCert(regCertInput.files[0]);
                    } else {
                        clearFieldError('registrationCert');
                    }
                });
            }
            checkStep2Validity();
        }

        function validateStep2Field(fieldName) {
            const field = document.getElementById(fieldName);
            const errorElement = document.getElementById(fieldName + 'Error');
            let isValid = true;

            const hasBeenTouched = field.classList.contains('touched');
            
            field.classList.remove('error');
            if (errorElement) {
                errorElement.style.display = 'none';
            }

            if (!field.value.trim()) {
                isValid = false;
            } else {
                // Specific validation for certain fields
                switch(fieldName) {
                    case 'taxCode':
                        // Optional: only validate if provided
                        if (field.value.trim().length > 0) {
                            const taxCodeRegex = /^[0-9]{10}$/;
                            if (!taxCodeRegex.test(field.value.trim())) {
                                isValid = false;
                            }
                        } else {
                            isValid = true;
                        }
                        break;
                    case 'registrationCert':
                        // Optional: only validate if a file is selected
                        if (field.files.length > 0) {
                            const file = field.files[0];
                            const maxSize = 5 * 1024 * 1024; // 5MB
                            const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf'];
                            
                            if (file.size > maxSize) {
                                isValid = false;
                                errorElement.textContent = 'Kích thước file phải nhỏ hơn 5MB';
                            } else if (!allowedTypes.includes(file.type)) {
                                isValid = false;
                                errorElement.textContent = 'Chỉ hỗ trợ định dạng JPG, PNG, PDF';
                            }
                        } else {
                            isValid = true;
                        }
                        break;
                }
            }

            if (!isValid && hasBeenTouched) {
                field.classList.add('error');
                if (errorElement) {
                    errorElement.style.display = 'block';
                }
            }

            return isValid;
        }

        function checkStep2Validity() {
            const allValid = step2Fields.every(fieldName => {
                const field = document.getElementById(fieldName);
                return field.value.trim() !== '' && !field.classList.contains('error');
            });

            // Tax code is optional, but if provided it must be valid and not exists
            const taxInput = document.getElementById('taxCode');
            let taxOk = true;
            if (taxInput && taxInput.value.trim().length > 0) {
                taxOk = taxCodeValidationState === 'valid';
            }

            const continueBtn = document.getElementById('step2ContinueBtn');
            continueBtn.disabled = !(allValid && taxOk);
            
            if (allValid) {
                continueBtn.style.opacity = '1';
                continueBtn.style.cursor = 'pointer';
            } else {
                continueBtn.style.opacity = '0.6';
                continueBtn.style.cursor = 'not-allowed';
            }

            return allValid;
        }

        // Helpers for AJAX validation UI
        function setFieldError(fieldName, message) {
            const field = document.getElementById(fieldName);
            const errorElement = document.getElementById(fieldName + 'Error');
            if (field) field.classList.add('error');
            if (errorElement) {
                if (message) errorElement.textContent = message;
                errorElement.style.display = 'block';
            }
        }

        function clearFieldError(fieldName) {
            const field = document.getElementById(fieldName);
            const errorElement = document.getElementById(fieldName + 'Error');
            if (field) field.classList.remove('error');
            if (errorElement) errorElement.style.display = 'none';
        }

        function ajaxValidateTaxCode(value) {
            const url = '${pageContext.request.contextPath}/RegistrationValidationServlet?check=taxCode&value=' + encodeURIComponent(value);
            fetch(url)
                .then(r => r.json())
                .then(data => {
                    if (!data || data.valid !== true) {
                        taxCodeValidationState = 'invalid';
                        setFieldError('taxCode', 'Vui lòng nhập mã số thuế hợp lệ (10 số)');
                    } else if (data.exists === true) {
                        taxCodeValidationState = 'exists';
                        setFieldError('taxCode', 'Mã số thuế này đã được sử dụng');
                    } else {
                        taxCodeValidationState = 'valid';
                        clearFieldError('taxCode');
                    }
                    checkStep2Validity();
                })
                .catch(() => {
                    taxCodeValidationState = 'invalid';
                    setFieldError('taxCode', 'Không thể kiểm tra mã số thuế lúc này');
                    checkStep2Validity();
                });
        }

        function ajaxValidateRegistrationCert(file) {
            const formData = new FormData();
            formData.append('check', 'registrationCert');
            formData.append('registrationCert', file);
            fetch('${pageContext.request.contextPath}/RegistrationValidationServlet', { method: 'POST', body: formData })
                .then(r => r.json())
                .then(data => {
                    if (data && data.valid === true) {
                        clearFieldError('registrationCert');
                        // Show preview only after validation passes
                        showFilePreview(file);
                    } else {
                        let msg = 'File không hợp lệ';
                        if (data && data.sizeOk === false) msg = 'Kích thước file phải nhỏ hơn 5MB';
                        else if (data && data.typeOk === false) msg = 'Chỉ hỗ trợ định dạng JPG, PNG, PDF';
                        setFieldError('registrationCert', msg);
                        // Hide preview on validation failure
                        document.getElementById('imagePreview').style.display = 'none';
                    }
                })
                .catch(() => {
                    setFieldError('registrationCert', 'Không thể kiểm tra file lúc này');
                    // Hide preview on error
                    document.getElementById('imagePreview').style.display = 'none';
                });
        }

        function showFilePreview(file) {
            const previewContainer = document.getElementById('imagePreview');
            const previewImg = document.getElementById('previewImg');
            
            // Validate basic file type for preview only
            const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png'];

            if (allowedTypes.includes(file.type)) {
                // Show image preview ONLY for viewing
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    previewContainer.style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else if (file.type === 'application/pdf') {
                // For PDF files, show file icon and name
                previewImg.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjE1MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8cmVjdCB3aWR0aD0iMjAwIiBoZWlnaHQ9IjE1MCIgZmlsbD0iI2Y1ZjVmNSIgc3Ryb2tlPSIjZGRkIiBzdHJva2Utd2lkdGg9IjEiLz4KICA8dGV4dCB4PSIxMDAiIHk9Ijc1IiBmb250LWZhbWlseT0iQXJpYWwiIGZvbnQtc2l6ZT0iMTIiIGZpbGw9IiM2NjYiIHRleHQtYW5jaG9yPSJtaWRkbGUiPkZpbGUgUERGPC90ZXh0Pgo8L3N2Zz4K';
                previewContainer.style.display = 'block';
            } else {
                // Show warning for unsupported preview but allow submission
                previewImg.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjE1MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8cmVjdCB3aWR0aD0iMjAwIiBoZWlnaHQ9IjE1MCIgZmlsbD0iI2ZmZjNlMyIgc3Ryb2tlPSIjZGI4MjJiIiBzdHJva2Utd2lkdGg9IjIiLz4KICA8dGV4dCB4PSIxMDAiIHk9IjcwIiBmb250LWZhbWlseT0iQXJpYWwiIGZvbnQtc2l6ZT0iMTAiIGZpbGw9IiM2YjUzMmMiIHRleHQtYW5jaG9yPSJtaWRkbGUiPuG7tVdpbGwgcHJvY2Vzc2VkPC90ZXh0Pgo8L3N2Zz4K';
                previewContainer.style.display = 'block';
            }
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
                // Stop at invalid step
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

        // File handling functions
        document.addEventListener('DOMContentLoaded', function() {
            const registrationCertInput = document.getElementById('registrationCert');
            if (registrationCertInput) {
                registrationCertInput.addEventListener('change', function(e) {
                    handleFileInput(e);
                });
            }
        });

        function handleFileInput(event) {
            const file = event.target.files[0];
            const previewContainer = document.getElementById('imagePreview');
            const previewImg = document.getElementById('previewImg');
            
            if (file) {
                // Clear any previous messages
                const errorElement = document.getElementById('registrationCertError');
                if (errorElement) {
                    errorElement.style.display = 'none';
                }
                
                // Clear file info (no longer displaying detailed info)
                const fileInfo = document.getElementById('fileInfo');
                if (fileInfo) {
                    fileInfo.innerHTML = '';
                }
                
                // Hide preview first
                previewContainer.style.display = 'none';
                
                // AJAX validate first, then show preview only if valid
                ajaxValidateRegistrationCert(file);
                
                // Mark field as touched and validate (basic validation only)
                event.target.classList.add('touched');
                validateStep2Field('registrationCert');
                checkStep2Validity();
            }
        }

        function removeImage() {
            const registrationCertInput = document.getElementById('registrationCert');
            const previewContainer = document.getElementById('imagePreview');
            const fileInfo = document.getElementById('fileInfo');
            const officialImageContainer = document.getElementById('officialImageContainer');
            
            // Clear file input
            registrationCertInput.value = '';
            
            // Hide all containers
            previewContainer.style.display = 'none';
            if (fileInfo) fileInfo.innerHTML = '';
            if (officialImageContainer) officialImageContainer.style.display = 'none';
            
            // Mark field as touched and validate
            registrationCertInput.classList.add('touched');
            validateStep2Field('registrationCert');
            checkStep2Validity();
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