<%-- 
    Document   : payment_failure
    Created on : Oct 23, 2025, 2:00:00 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh toán thất bại - RecruitPro</title>
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

            .failure-container {
                max-width: 600px;
                margin: 50px auto;
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                padding: 40px;
                text-align: center;
            }

            .failure-icon {
                width: 80px;
                height: 80px;
                background: #dc2626;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
                font-size: 40px;
                color: white;
            }

            .failure-title {
                font-size: 28px;
                font-weight: 700;
                color: #1f2937;
                margin-bottom: 15px;
            }

            .failure-message {
                font-size: 16px;
                color: #6b7280;
                margin-bottom: 30px;
            }

            .payment-info {
                background: #fef2f2;
                border: 1px solid #fecaca;
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
                color: #dc2626;
                border-top: 1px solid #fecaca;
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
                background: #dc2626;
                color: white;
            }

            .btn-primary:hover {
                background: #b91c1c;
            }

            .btn-secondary {
                background: #f3f4f6;
                color: #374151;
                border: 1px solid #d1d5db;
            }

            .btn-secondary:hover {
                background: #e5e7eb;
            }

            .help-info {
                background: #fef3c7;
                border: 1px solid #f59e0b;
                border-radius: 8px;
                padding: 15px;
                margin-top: 20px;
                text-align: left;
            }

            .help-info h4 {
                color: #92400e;
                margin-bottom: 10px;
                font-size: 16px;
            }

            .help-list {
                list-style: none;
                padding: 0;
            }

            .help-list li {
                padding: 5px 0;
                color: #92400e;
                font-size: 14px;
            }

            .help-list li i {
                margin-right: 8px;
                color: #f59e0b;
            }
        </style>
    </head>
    <body>
        <div class="failure-container">
            <div class="failure-icon">
                <i class="fas fa-times"></i>
            </div>
            
            <h1 class="failure-title">Thanh toán thất bại!</h1>
            <p class="failure-message">Rất tiếc, giao dịch của bạn không thể hoàn thành. Vui lòng thử lại hoặc liên hệ hỗ trợ.</p>
            
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
                    <span class="info-value" style="color: #dc2626;">Thất bại</span>
                </div>
            </div>
            
            <div class="help-info">
                <h4><i class="fas fa-question-circle"></i> Cần hỗ trợ?</h4>
                <ul class="help-list">
                    <li><i class="fas fa-phone"></i> Hotline: 1900 1234</li>
                    <li><i class="fas fa-envelope"></i> Email: support@recruitpro.com</li>
                    <li><i class="fas fa-clock"></i> Thời gian hỗ trợ: 8:00 - 22:00</li>
                </ul>
            </div>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/Recruiter/shop-cart.jsp" class="btn btn-primary">
                    <i class="fas fa-redo"></i>
                    Thử lại thanh toán
                </a>
                <a href="${pageContext.request.contextPath}/Recruiter/job-packages.jsp" class="btn btn-secondary">
                    <i class="fas fa-shopping-bag"></i>
                    Chọn gói khác
                </a>
            </div>
        </div>

        <script>
            // Set current time
            document.getElementById('paymentTime').textContent = new Date().toLocaleString('vi-VN');
        </script>
    </body>
</html>