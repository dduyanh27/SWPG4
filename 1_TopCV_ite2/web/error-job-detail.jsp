<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi chi tiết việc làm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/JobSeeker/styles.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .error-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 40px;
            text-align: center;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .error-icon {
            font-size: 64px;
            color: #ff6b6b;
            margin-bottom: 20px;
        }
        .error-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 15px;
        }
        .error-message {
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .error-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
        }
        .btn-primary {
            background: #0066cc;
            color: white;
        }
        .btn-outline {
            border: 2px solid #0066cc;
            color: #0066cc;
            background: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">
            <i class="fas fa-exclamation-triangle"></i>
        </div>
        <h1 class="error-title">Có lỗi xảy ra</h1>
        <div class="error-message">
            <c:choose>
                <c:when test="${not empty errorMessage}">
                    ${errorMessage}
                </c:when>
                <c:otherwise>
                    Trang bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.
                </c:otherwise>
            </c:choose>
        </div>
        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/job-list" class="btn btn-primary">
                <i class="fas fa-search"></i> Tìm việc làm
            </a>
            <a href="javascript:history.back()" class="btn btn-outline">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>
    </div>
</body>
</html>