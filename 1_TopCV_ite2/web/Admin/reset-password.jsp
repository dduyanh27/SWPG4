<%-- 
    Document   : reset-password
    Created on : Sep 28, 2025, 11:12:37 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reset Password</title>
        <link rel="stylesheet" href="assets/css/style_login.css">
    </head>
    <body>
        <div class="login-container">
            <div class="login-card">
                <div class="login-header">
                    <h2>Reset Password</h2>
                    <p>Enter your new password below</p>
                    
                    <!-- Success Message -->
                    <%
                        String mess = (String) request.getAttribute("mess");
                        if (mess != null && mess.contains("thành công")) {
                    %>
                    <div class="success-notification">
                        <span class="success-icon">🎉</span>
                        <span class="success-text">Mật khẩu đã được cập nhật thành công!</span>
                        <span class="countdown-text">Chuyển về trang đăng nhập trong <span id="countdown">3</span>s</span>
                    </div>
                    <%
                        }
                    %>
                </div>

                <form id="resetForm" class="login-form" action="/Test_ResetPassword/resetPassword" method="POST">
                    <input type="hidden" name="userType" value="admin">
                    <input type="hidden" name="email" value="${email}">
                    
                    <!-- New Password Field -->
                    <div class="form-group">
                        <div class="input-wrapper">
                            <input type="password" id="newPassword" name="password" placeholder=" " required>
                            <label for="newPassword">New Password</label>
                            <div class="focus-border"></div>
                            <span class="error-message" id="newPasswordError"></span>
                        </div>
                    </div>

                    <!-- Confirm Password Field -->
                    <div class="form-group">
                        <div class="input-wrapper">
                            <input type="password" id="confirmPassword" name="confirm_password" placeholder=" " required>
                            <label for="confirmPassword">Confirm Password</label>
                            <div class="focus-border"></div>
                            <span class="error-message" id="confirmPasswordError"></span>
                        </div>
                    </div>

                    <!-- Password Requirements -->
                    <div class="password-requirements">
                        <h4>Password Requirements:</h4>
                        <ul>
                            <li id="length">At least 8 characters</li>
                            <li id="uppercase">One uppercase letter</li>
                            <li id="lowercase">One lowercase letter</li>
                            <li id="number">One number</li>
                            <li id="special">One special character</li>
                        </ul>
                    </div>

                    <!-- Reset Button -->
                    <button type="submit" class="btn login-btn">
                        <span class="btn-text">Reset Password</span>
                        <div class="btn-loader"></div>
                    </button>

                    <!-- Back to Login Link -->
                    <div class="signup-link">
                        <p>Remember your password? <a href="admin-login.jsp">Back to Login</a></p>
                    </div>
                    
                    <!-- Error Message -->
                    <div style="color: red; margin-top: 10px;">${mess}</div>
                </form>

                <!-- Success Message -->
                <div class="success-message" id="successMessage">
                    <div class="success-icon">✓</div>
                    <h3>Password Reset Successful!</h3>
                    <p>Your password has been updated successfully. You can now log in with your new password.</p>
                    <button class="btn" onclick="goToLogin()" style="margin-top: 20px;">
                        <span class="btn-text">Go to Login</span>
                    </button>
                </div>
            </div>
        </div>

        <script>
            // Password validation requirements
            const requirements = {
                length: /.{8,}/,
                uppercase: /[A-Z]/,
                lowercase: /[a-z]/,
                number: /\d/,
                special: /[!@#$%^&*(),.?":{}|<>]/
            };

            // Check if user came from valid reset link
            window.addEventListener('load', function () {
                const email = document.querySelector('input[name="email"]').value;
                if (!email) {
                    alert('Invalid reset link. Please request a new password reset.');
                    window.location.href = 'request-password.jsp';
                }
            });

            // Real-time password validation
            document.getElementById('newPassword').addEventListener('input', function () {
                validatePassword(this.value);
                checkPasswordMatch();
            });

            document.getElementById('confirmPassword').addEventListener('input', function () {
                checkPasswordMatch();
            });

            function validatePassword(password) {
                const checks = {
                    length: requirements.length.test(password),
                    uppercase: requirements.uppercase.test(password),
                    lowercase: requirements.lowercase.test(password),
                    number: requirements.number.test(password),
                    special: requirements.special.test(password)
                };

                // Update visual indicators
                Object.keys(checks).forEach(key => {
                    const element = document.getElementById(key);
                    if (checks[key]) {
                        element.style.color = '#22c55e';
                        element.style.textDecoration = 'line-through';
                    } else {
                        element.style.color = 'rgba(255, 255, 255, 0.6)';
                        element.style.textDecoration = 'none';
                    }
                });

                return Object.values(checks).every(check => check);
            }

            function checkPasswordMatch() {
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                const errorElement = document.getElementById('confirmPasswordError');

                if (confirmPassword && newPassword !== confirmPassword) {
                    showError('confirmPassword', 'Passwords do not match');
                    return false;
                } else {
                    hideError('confirmPassword');
                    return true;
                }
            }

            function showError(fieldId, message) {
                const field = document.getElementById(fieldId);
                const errorElement = document.getElementById(fieldId + 'Error');
                const formGroup = field.closest('.form-group');

                errorElement.textContent = message;
                errorElement.classList.add('show');
                formGroup.classList.add('error');
            }

            function hideError(fieldId) {
                const field = document.getElementById(fieldId);
                const errorElement = document.getElementById(fieldId + 'Error');
                const formGroup = field.closest('.form-group');

                errorElement.classList.remove('show');
                formGroup.classList.remove('error');
            }

            // Form submission
            document.getElementById('resetForm').addEventListener('submit', function (e) {
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = document.getElementById('confirmPassword').value;

                // Validate password strength
                if (!validatePassword(newPassword)) {
                    e.preventDefault();
                    showError('newPassword', 'Password does not meet all requirements');
                    return;
                }

                // Check password match
                if (!checkPasswordMatch()) {
                    e.preventDefault();
                    return;
                }

                // If validation passes, allow form submission
            });

            function goToLogin() {
                window.location.href = 'admin-login.jsp';
            }
        </script>

        <style>
            /* Password Requirements Styling */
            .password-requirements {
                background: rgba(255, 255, 255, 0.05);
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 12px;
                padding: 16px;
                margin-bottom: 24px;
                backdrop-filter: blur(10px);
            }

            .password-requirements h4 {
                color: rgba(255, 255, 255, 0.9);
                font-size: 14px;
                font-weight: 600;
                margin-bottom: 12px;
            }

            .password-requirements ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .password-requirements li {
                color: rgba(255, 255, 255, 0.6);
                font-size: 13px;
                margin-bottom: 6px;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                padding-left: 20px;
            }

            .password-requirements li::before {
                content: '○';
                position: absolute;
                left: 0;
                color: rgba(255, 255, 255, 0.4);
                font-size: 12px;
            }

            .password-requirements li[style*="line-through"]::before {
                content: '✓';
                color: #22c55e;
            }

            /* Success message specific styling */
            .success-message .btn {
                width: auto;
                padding: 12px 24px;
                margin-top: 20px;
            }
        </style>
        
        <script>
            // Auto redirect with countdown if success
            window.addEventListener('load', function() {
                const mess = '${mess}';
                if (mess && mess.includes('thành công')) {
                    let countdown = 3;
                    const countdownElement = document.getElementById('countdown');
                    
                    const timer = setInterval(function() {
                        countdown--;
                        countdownElement.textContent = countdown;
                        
                        if (countdown <= 0) {
                            clearInterval(timer);
                            window.location.href = '/Test_ResetPassword/Admin/admin-login.jsp';
                        }
                    }, 1000);
                }
            });
        </script>
        
        <style>
            .success-notification {
                background: linear-gradient(135deg, #22c55e, #16a34a);
                color: white;
                padding: 12px 20px;
                border-radius: 8px;
                margin: 15px 0;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                box-shadow: 0 4px 12px rgba(34, 197, 94, 0.3);
                animation: slideDown 0.5s ease-out;
            }
            
            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            
            .success-icon {
                font-size: 18px;
                margin-right: 8px;
            }
            
            .success-text {
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 5px;
            }
            
            .countdown-text {
                font-size: 12px;
                opacity: 0.9;
                font-weight: 400;
            }
            
            #countdown {
                font-weight: bold;
                color: #fbbf24;
            }
        </style>
    </body>
</html>

