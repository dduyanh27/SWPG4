<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO, dal.RecruiterDAO, dal.JobSeekerDAO, java.util.List, model.Admin, model.Recruiter, model.JobSeeker" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
                <h2>Admin Login</h2>
                <p>Sign in to your admin account</p>
            </div>
            
            <form class="login-form" id="loginForm" action="${pageContext.request.contextPath}/LoginServlet" method="POST" novalidate>
                <input type="hidden" name="loginType" value="admin">
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
                    <a href="forgotpassword.html" class="forgot-password">Forgot password?</a>
                </div>

                <button type="submit" class="login-btn btn">
                    <span class="btn-text">Sign In</span>
                    <span class="btn-loader"></span>
                </button>
            </form>

            <div class="signup-link">
                <p>Don't have an account? <a href="signup.html">Sign up</a></p>
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

