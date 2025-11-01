<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Sign Up - TopCV</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		
		<!-- MATERIAL DESIGN ICONIC FONT -->
		<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/fonts/fonts_signup/material-design-iconic-font/css/material-design-iconic-font.min.css">

		<!-- STYLE CSS -->
		<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/signup.css">
	</head>

	<body>
		<div class="wrapper">
			<div class="inner">
				<div class="image-holder">
					<img src="${pageContext.request.contextPath}/assets/img/signup/mau-thiet-ke-van-phong-hien-dai-xanh-bci.jpg" alt="">
				</div>
				<form action="${pageContext.request.contextPath}/JobSeeker/signup" method="post" id="signupForm">
					<h3>Registration Form</h3>
					
					<!-- Error/Success Message -->
					<c:if test="${not empty error}">
						<div class="alert alert-error" style="background: #fee; color: #c33; padding: 12px; border-radius: 6px; margin-bottom: 15px;">
							<i class="zmdi zmdi-alert-circle"></i> ${error}
						</div>
					</c:if>
					<c:if test="${not empty success}">
						<div class="alert alert-success" style="background: #efe; color: #3c3; padding: 12px; border-radius: 6px; margin-bottom: 15px;">
							<i class="zmdi zmdi-check-circle"></i> ${success}
						</div>
					</c:if>
					
					<div class="form-wrapper">
						<input type="email" name="email" placeholder="Email Address" class="form-control" required>
						<i class="zmdi zmdi-email"></i>
					</div>
					
					<div class="form-wrapper">
						<input type="password" name="password" id="password" placeholder="Password" class="form-control" required minlength="6">
						<i class="zmdi zmdi-lock"></i>
					</div>
					<div class="form-wrapper">
						<input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm Password" class="form-control" required>
						<i class="zmdi zmdi-lock"></i>
					</div>
					
					<div id="passwordError" style="color: #c33; font-size: 14px; margin-top: -10px; margin-bottom: 10px;"></div>
					
					<button type="submit">Register
						<i class="zmdi zmdi-arrow-right"></i>
					</button>
					
					<div style="text-align: center; margin-top: 15px;">
						<span style="color: #666;">Already have an account? </span>
						<a href="${pageContext.request.contextPath}/JobSeeker/jobseeker-login.jsp" style="color: #0a67ff; text-decoration: none; font-weight: 600;">Login</a>
					</div>
				</form>
			</div>
		</div>
		
		<script>
			// Client-side validation
			document.getElementById('signupForm').addEventListener('submit', function(e) {
				const password = document.getElementById('password').value;
				const confirmPassword = document.getElementById('confirmPassword').value;
				const errorDiv = document.getElementById('passwordError');
				
				if (password !== confirmPassword) {
					e.preventDefault();
					errorDiv.textContent = 'Passwords do not match!';
					errorDiv.style.display = 'block';
					return false;
				}
				
				if (password.length < 6) {
					e.preventDefault();
					errorDiv.textContent = 'Password must be at least 6 characters!';
					errorDiv.style.display = 'block';
					return false;
				}
				
				errorDiv.textContent = '';
				errorDiv.style.display = 'none';
				return true;
			});
			
			// Clear error on input
			document.getElementById('password').addEventListener('input', function() {
				document.getElementById('passwordError').textContent = '';
			});
			document.getElementById('confirmPassword').addEventListener('input', function() {
				document.getElementById('passwordError').textContent = '';
			});
		</script>
	</body>
</html>
