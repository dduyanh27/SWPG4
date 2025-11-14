<%-- 
    Document   : recruiter-login
    Created on : Sep 24, 2025, 7:47:23 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Glassmorphism Login Form</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style_login.css">
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <h2>Recruiter Login</h2>
                <p>Sign in to your recruiter account</p>
                
                <!-- Success Message for Pending Registration -->
                <%
                    String success = request.getParameter("success");
                    if (success != null && success.equals("registration_pending")) {
                %>
                <div style="background: #d1ecf1; color: #0c5460; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #bee5eb;">
                    <i class="fas fa-info-circle"></i> Đăng ký thành công! Tài khoản của bạn đang chờ phê duyệt. Vui lòng đợi admin kích hoạt tài khoản.
                </div>
                <%
                    }
                %>
                
                <!-- Error Message -->
                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                <div style="background: #f8d7da; color: #721c24; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
                    <i class="fas fa-exclamation-triangle"></i> <%= error %>
                </div>
                <%
                    }
                %>
            </div>
            
            <form class="login-form" id="loginForm" action="${pageContext.request.contextPath}/LoginServlet" method="POST" novalidate>
                <input type="hidden" name="loginType" value="recruiter">
                <div class="form-group">
                    <div class="input-wrapper">
                        <input type="email" id="email" name="email" required autocomplete="email" placeholder=" ">
                        <label for="email">Email Address</label>
                        <span class="focus-border"></span>
                    </div>
                    <span class="error-message" id="emailError"></span>
                </div>

                <div class="form-group">
                    <div class="input-wrapper password-wrapper">
                        <input type="password" id="password" name="password" required autocomplete="current-password" placeholder=" ">
                        <label for="password">Password</label>
                        <button type="button" class="password-toggle" id="passwordToggle" aria-label="Toggle password visibility">
                            <span class="eye-icon"></span>
                        </button>
                        <span class="focus-border"></span>
                    </div>
                    <span class="error-message" id="passwordError"></span>
                </div>

                <div class="form-options">
                    <label class="remember-wrapper">
                        <input type="checkbox" id="remember" name="remember">
                        <span class="checkbox-label">
                            <span class="checkmark"></span>
                            Remember me
                        </span>
                    </label>
                    <a href="request-password.jsp" class="forgot-password">Forgot password?</a>
                </div>

                <button type="submit" class="login-btn btn">
                    <span class="btn-text">Sign In</span>
                    <span class="btn-loader"></span>
                </button>
            </form>

            <div class="signup-link">
                <p>Don't have an account? <a href="${pageContext.request.contextPath}/RecruiterRegistrationServlet">Sign up</a></p>
            </div>

            <div class="signup-link" style="margin-top: 10px;">
                <p><a href="${pageContext.request.contextPath}/index.jsp" style="color: #667eea;">← Quay về trang chủ</a></p>
            </div>

            <div class="success-message" id="successMessage">
                <div class="success-icon">✓</div>
                <h3>Login Successful!</h3>
                <p>Redirecting to your dashboard...</p>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/shared/js/form-utils.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>

