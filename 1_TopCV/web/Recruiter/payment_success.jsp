<%-- 
    Document   : payment_success
    Created on : Oct 23, 2025, 2:00:00 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh toán thành công - RecruitPro</title>
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

            .success-container {
                max-width: 600px;
                margin: 50px auto;
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                padding: 40px;
                text-align: center;
            }

            .success-icon {
                width: 80px;
                height: 80px;
                background: #10b981;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
                font-size: 40px;
                color: white;
            }

            .success-title {
                font-size: 28px;
                font-weight: 700;
                color: #1f2937;
                margin-bottom: 15px;
            }

            .success-message {
                font-size: 16px;
                color: #6b7280;
                margin-bottom: 30px;
            }

            .payment-info {
                background: #f9fafb;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 30px;
                text-align: left;
            }

            .info-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
                padding: 5px 0;
            }

            .info-row:last-child {
                margin-bottom: 0;
                font-weight: 600;
                color: #1f2937;
                border-top: 1px solid #e5e7eb;
                padding-top: 10px;
            }

            .info-label {
                color: #6b7280;
            }

            .info-value {
                color: #1f2937;
                font-weight: 500;
            }

            .action-buttons {
                display: flex;
                gap: 15px;
                justify-content: center;
            }

            .btn {
                padding: 12px 24px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s ease;
                border: none;
                font-size: 14px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-primary {
                background: #3b82f6;
                color: white;
            }

            .btn-primary:hover {
                background: #2563eb;
            }

            .btn-secondary {
                background: #f3f4f6;
                color: #374151;
                border: 1px solid #d1d5db;
            }

            .btn-secondary:hover {
                background: #e5e7eb;
            }

            .package-info {
                background: #eff6ff;
                border: 1px solid #dbeafe;
                border-radius: 8px;
                padding: 15px;
                margin-top: 20px;
                text-align: left;
            }

            .package-info h4 {
                color: #1e40af;
                margin-bottom: 10px;
                font-size: 16px;
            }

            .package-list {
                list-style: none;
                padding: 0;
            }

            .package-list li {
                padding: 5px 0;
                color: #1e40af;
                font-size: 14px;
            }

            .package-list li i {
                margin-right: 8px;
                color: #10b981;
            }
        </style>
    </head>
    <body>
        <div class="success-container">
            <div class="success-icon">
                <i class="fas fa-check"></i>
            </div>
            
            <h1 class="success-title">Thanh toán thành công!</h1>
            <p class="success-message">Cảm ơn bạn đã mua gói dịch vụ. Gói dịch vụ đã được kích hoạt và sẵn sàng sử dụng.</p>
            
            <div class="payment-info">
                <div class="info-row">
                    <span class="info-label">Mã giao dịch:</span>
                    <span class="info-value">${param.paymentID}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Phương thức thanh toán:</span>
                    <span class="info-value">VNPay</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Thời gian:</span>
                    <span class="info-value" id="paymentTime"></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Trạng thái:</span>
                    <span class="info-value" style="color: #10b981;">Thành công</span>
                </div>
            </div>
            
            <div class="package-info">
                <h4><i class="fas fa-gift"></i> Gói dịch vụ đã mua</h4>
                <ul class="package-list">
                    <li><i class="fas fa-check"></i> Gói dịch vụ đã được kích hoạt</li>
                    <li><i class="fas fa-check"></i> Có thể sử dụng ngay lập tức</li>
                    <li><i class="fas fa-check"></i> Hỗ trợ 24/7</li>
                </ul>
            </div>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/Recruiter/job-packages.jsp" class="btn btn-primary">
                    <i class="fas fa-shopping-bag"></i>
                    Mua thêm gói
                </a>
                <a href="${pageContext.request.contextPath}/Recruiter/index.jsp" class="btn btn-secondary">
                    <i class="fas fa-home"></i>
                    Về trang chủ
                </a>
            </div>
        </div>

        <script>
            // Set current time
            document.getElementById('paymentTime').textContent = new Date().toLocaleString('vi-VN');
            
            // Clear cart after successful payment
            sessionStorage.removeItem('cartData');
            sessionStorage.removeItem('cartSubtotal');
            sessionStorage.removeItem('cartVAT');
            sessionStorage.removeItem('cartTotal');
        </script>
    </body>
</html>