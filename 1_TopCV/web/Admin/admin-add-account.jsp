<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Tài Khoản Mới | Quản Lý Hệ Thống</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #2c5530 0%, #1a3d1f 100%);
                min-height: 100vh;
                padding: 20px;
                color: #333;
            }

            .container {
                max-width: 600px;
                margin: 0 auto;
                background: rgba(255, 255, 255, 0.95);
                border-radius: 15px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                backdrop-filter: blur(10px);
            }

            .header {
                background: linear-gradient(135deg, #4a7c59 0%, #2d4a33 100%);
                color: white;
                padding: 30px 40px;
                text-align: center;
                position: relative;
            }

            .header::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="80" cy="40" r="3" fill="rgba(255,255,255,0.08)"/><circle cx="40" cy="80" r="2" fill="rgba(255,255,255,0.12)"/></svg>');
                pointer-events: none;
            }

            .header h2 {
                font-size: 28px;
                font-weight: 300;
                margin-bottom: 8px;
                position: relative;
                z-index: 1;
            }

            .header .subtitle {
                font-size: 14px;
                opacity: 0.9;
                position: relative;
                z-index: 1;
            }

            .form-container {
                padding: 40px;
            }

            .alert {
                padding: 15px 20px;
                margin-bottom: 25px;
                border-radius: 8px;
                font-weight: 500;
                border-left: 4px solid;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .alert.error {
                background-color: #ffeaea;
                color: #d63384;
                border-left-color: #d63384;
            }

            .alert.success {
                background-color: #e8f5e8;
                color: #2d5a32;
                border-left-color: #4a7c59;
            }

            .form-group {
                margin-bottom: 25px;
            }

            .form-label {
                display: block;
                font-weight: 600;
                color: #2d4a33;
                margin-bottom: 8px;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .form-input {
                width: 100%;
                padding: 15px 18px;
                border: 2px solid #e1e8e5;
                border-radius: 10px;
                font-size: 16px;
                transition: all 0.3s ease;
                background: white;
            }

            .form-input:focus {
                outline: none;
                border-color: #4a7c59;
                box-shadow: 0 0 0 3px rgba(74, 124, 89, 0.1);
                transform: translateY(-2px);
            }

            .form-input:hover {
                border-color: #6fa778;
            }

            .submit-btn {
                width: 100%;
                background: linear-gradient(135deg, #4a7c59 0%, #2d4a33 100%);
                color: white;
                padding: 16px 30px;
                border: none;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
                box-shadow: 0 5px 15px rgba(74, 124, 89, 0.3);
            }

            .submit-btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(74, 124, 89, 0.4);
                background: linear-gradient(135deg, #5a8c69 0%, #3d5a43 100%);
            }

            .submit-btn:active {
                transform: translateY(-1px);
            }

            .back-link {
                text-align: center;
                margin-top: 25px;
                padding-top: 20px;
                border-top: 1px solid #e1e8e5;
            }

            .back-link a {
                color: #4a7c59;
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s ease;
                padding: 8px 16px;
                border-radius: 5px;
            }

            .back-link a:hover {
                background-color: #f8faf9;
                color: #2d4a33;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .container {
                    margin: 10px;
                    border-radius: 10px;
                }

                .header {
                    padding: 25px 20px;
                }

                .header h2 {
                    font-size: 24px;
                }

                .form-container {
                    padding: 30px 20px;
                }

                .form-input {
                    padding: 12px 15px;
                }

                .submit-btn {
                    padding: 14px 25px;
                }
            }

            /* Animation cho form */
            .form-group {
                animation: slideInUp 0.6s ease forwards;
                opacity: 0;
            }

            .form-group:nth-child(1) {
                animation-delay: 0.1s;
            }
            .form-group:nth-child(2) {
                animation-delay: 0.2s;
            }
            .form-group:nth-child(3) {
                animation-delay: 0.3s;
            }
            .form-group:nth-child(4) {
                animation-delay: 0.4s;
            }
            .form-group:nth-child(5) {
                animation-delay: 0.5s;
            }

            @keyframes slideInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Icon cho input */
            .input-with-icon {
                position: relative;
            }

            .input-icon {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #4a7c59;
                opacity: 0.7;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h2>Thêm Tài Khoản Mới</h2>
                <p class="subtitle">Tạo tài khoản người dùng trong hệ thống</p>
            </div>

            <div class="form-container">
                <c:if test="${not empty error}">
                    <div class="alert error">
                        <strong>Lỗi:</strong> ${error}
                    </div>
                </c:if>

                <c:if test="${not empty message}">
                    <div class="alert success">
                        <strong>Thành công:</strong> ${message}
                    </div>
                </c:if>

                <form action="adminaddaccount" method="post">
                    <div class="form-group">
                        <label class="form-label" for="email">📧 Địa chỉ Email</label>
                        <div class="input-with-icon">
                            <input type="email" 
                                   id="email"
                                   name="email" 
                                   class="form-input" 
                                   value="${param.email}" 
                                   required 
                                   placeholder="Nhập địa chỉ email...">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="password">🔐 Mật khẩu</label>
                        <input type="password" 
                               id="password"
                               name="password" 
                               class="form-input" 
                               required 
                               placeholder="Nhập mật khẩu...">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="fullName">👤 Họ và tên / Tên công ty</label>
                        <input type="text" 
                               id="fullName"
                               name="fullName" 
                               class="form-input" 
                               value="${param.fullName}" 
                               required 
                               placeholder="Nhập họ tên (JobSeeker/Admin) hoặc tên công ty (Recruiter)...">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="phone">📱 Số điện thoại</label>
                        <input type="tel" 
                               id="phone"
                               name="phone" 
                               class="form-input" 
                               value="${param.phone}" 
                               required 
                               placeholder="Nhập số điện thoại...">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="gender">⚥ Giới tính</label>
                        <select id="gender" name="gender" class="form-input" required>
                            <option value="" disabled selected>Chọn giới tính</option>
                            <option value="Nam" ${param.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="Nữ" ${param.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                            <option value="Khác" ${param.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="role">👤 Vai trò</label>
                        <select id="role" name="role" class="form-input" required>
                            <option value="" disabled selected>Chọn vai trò</option>
                            <option value="admin" ${param.role == 'admin' ? 'selected' : ''}>Admin</option>
                            <option value="jobseeker" ${param.role == 'jobseeker' ? 'selected' : ''}>JobSeeker</option>
                            <option value="recruiter" ${param.role == 'recruiter' ? 'selected' : ''}>Recruiter</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="status">📊 Trạng thái</label>
                        <select id="status" name="status" class="form-input" required>
                            <option value="" disabled selected>Chọn trạng thái</option>
                            <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                            <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                            <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="submit-btn">
                            ✨ Tạo Tài Khoản
                        </button>
                    </div>
                </form>

                <div class="back-link">
                    <a href="manage-accounts?role=admin">← Quay lại danh sách tài khoản</a>
                </div>
            </div>
        </div>

<!--        <script>
            // Thêm hiệu ứng focus cho form
            document.querySelectorAll('.form-input').forEach(input => {
                input.addEventListener('focus', function () {
                    this.parentElement.style.transform = 'scale(1.02)';
                });

                input.addEventListener('blur', function () {
                    this.parentElement.style.transform = 'scale(1)';
                });
            });

            // Validation cơ bản
            document.querySelector('form').addEventListener('submit', function (e) {
                const email = document.getElementById('email').value;
                const password = document.getElementById('password').value;
                const fullName = document.getElementById('fullName').value;
                const phone = document.getElementById('phone').value;
                const gender = document.getElementById('gender').value;
                const role = document.getElementById('role').value;
                const status = document.getElementById('status').value;

                if (!email.includes('@')) {
                    alert('Vui lòng nhập địa chỉ email hợp lệ!');
                    e.preventDefault();
                    return;
                }

                if (password.length < 6) {
                    alert('Mật khẩu phải có ít nhất 6 ký tự!');
                    e.preventDefault();
                    return;
                }

                if (fullName.trim().length < 2) {
                    alert('Họ tên phải có ít nhất 2 ký tự!');
                    e.preventDefault();
                    return;
                }

                if (phone.trim().length < 10) {
                    alert('Số điện thoại phải có ít nhất 10 số!');
                    e.preventDefault();
                    return;
                }

                if (!gender) {
                    alert('Vui lòng chọn giới tính!');
                    e.preventDefault();
                    return;
                }

                if (!role) {
                    alert('Vui lòng chọn vai trò!');
                    e.preventDefault();
                    return;
                }

                if (!status) {
                    alert('Vui lòng chọn trạng thái!');
                    e.preventDefault();
                    return;
                }
            });
        </script>-->
    </body>
</html>