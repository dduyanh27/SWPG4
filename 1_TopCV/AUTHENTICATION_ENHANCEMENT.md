# Enhanced Authentication System

## Tổng quan

Hệ thống authentication đã được tăng cường để giải quyết vấn đề **role conflict** khi đăng nhập với nhiều role khác nhau trong cùng một trình duyệt. Khi refresh trang, hệ thống sẽ tự động kiểm tra và forward các role không phù hợp sang trang `access-denied.jsp`.

## Các thành phần chính

### 1. SessionManager (`util.SessionManager`)
- **Chức năng**: Quản lý session isolation và phát hiện role conflict
- **Tính năng chính**:
  - Tạo session isolated cho từng role
  - Phát hiện và xử lý session conflict
  - Kiểm tra quyền truy cập dựa trên path và role
  - Forward role không phù hợp sang access-denied

### 2. AuthenticationFilter (`filter.AuthenticationFilter`)
- **Chức năng**: Filter chính để kiểm tra authentication
- **Tính năng mới**:
  - Kiểm tra session conflict trước khi xử lý request
  - Sử dụng SessionManager để kiểm tra quyền truy cập
  - Forward chi tiết với thông báo lỗi cụ thể

### 3. RoleBasedAccessControlFilter (`filter.RoleBasedAccessControlFilter`)
- **Chức năng**: Kiểm tra quyền truy cập chi tiết dựa trên role và path
- **Tính năng**:
  - Định nghĩa các path cụ thể cho từng role
  - Kiểm tra quyền truy cập granular
  - Thông báo lỗi chi tiết cho từng trường hợp

### 4. LoginServlet (`controller.base.LoginServlet`)
- **Chức năng**: Xử lý đăng nhập với session isolation
- **Tính năng mới**:
  - Sử dụng SessionManager.createIsolatedSession()
  - Tự động invalidate session cũ khi có conflict
  - Redirect dựa trên role cụ thể

## Cách hoạt động

### 1. Khi đăng nhập
```java
// LoginServlet sử dụng SessionManager
SessionManager.createIsolatedSession(request, response, "admin", admin, role);
```

### 2. Khi truy cập trang
```java
// AuthenticationFilter kiểm tra session conflict
if (SessionManager.hasSessionConflict(httpRequest)) {
    SessionManager.clearSessionConflict(httpRequest);
    httpResponse.sendRedirect(contextPath + "/access-denied.jsp");
    return;
}

// Kiểm tra quyền truy cập
if (!SessionManager.checkRoleConflict(httpRequest, httpResponse, requestPath)) {
    return; // Đã redirect sang access-denied
}
```

### 3. Role-based access control
```java
// RoleBasedAccessControlFilter kiểm tra chi tiết
if (!hasAccessToPath(httpRequest, relativePath, userType, currentRole)) {
    String errorMessage = generateAccessDeniedMessage(relativePath, userType, currentRole);
    redirectToAccessDenied(httpRequest, httpResponse, errorMessage);
    return;
}
```

## Cấu hình Filter

Trong `web.xml`:
```xml
<!-- Enhanced Authentication Filter -->
<filter>
    <filter-name>AuthenticationFilter</filter-name>
    <filter-class>filter.AuthenticationFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>AuthenticationFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>

<!-- Role-Based Access Control Filter -->
<filter>
    <filter-name>RoleBasedAccessControlFilter</filter-name>
    <filter-class>filter.RoleBasedAccessControlFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>RoleBasedAccessControlFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

## Các Role được hỗ trợ

### Admin Roles
- **Admin**: Truy cập tất cả khu vực Admin
- **Marketing Staff**: Chỉ truy cập `/Staff/marketing*` và `/Staff/campaign*`
- **Sales**: Chỉ truy cập `/Staff/sale*` và `/Staff/order*`

### User Roles
- **JobSeeker**: Truy cập `/JobSeeker/*`
- **Recruiter**: Truy cập `/Recruiter/*`

## Xử lý Role Conflict

### Khi phát hiện conflict:
1. **Log conflict**: Ghi log để debug
2. **Invalidate session**: Xóa session cũ
3. **Redirect**: Chuyển hướng sang `access-denied.jsp`
4. **Thông báo**: Hiển thị thông báo lỗi chi tiết

### Thông báo lỗi mẫu:
```
"Bạn không có quyền truy cập vào khu vực Admin. 
Vai trò hiện tại: JobSeeker. 
Chỉ có Admin mới có thể truy cập khu vực này."
```

## Trang Access Denied

Trang `access-denied.jsp` được cải thiện với:
- **Thông báo lỗi chi tiết** từ session
- **Thông tin role hiện tại**
- **Nút redirect** phù hợp với role
- **Giao diện thân thiện** với người dùng

## Lợi ích

1. **Bảo mật tăng cường**: Ngăn chặn truy cập trái phép
2. **UX tốt hơn**: Thông báo lỗi rõ ràng
3. **Session isolation**: Tránh conflict giữa các role
4. **Maintainable**: Code dễ bảo trì và mở rộng
5. **Debugging**: Log chi tiết để debug

## Testing

### Test Case 1: Role Conflict
1. Đăng nhập với JobSeeker
2. Mở tab mới, đăng nhập với Admin
3. Refresh tab JobSeeker
4. **Expected**: Redirect sang access-denied với thông báo phù hợp

### Test Case 2: Unauthorized Access
1. Đăng nhập với JobSeeker
2. Truy cập trực tiếp `/Admin/admin-dashboard.jsp`
3. **Expected**: Redirect sang access-denied

### Test Case 3: Marketing Staff Access
1. Đăng nhập với Marketing Staff
2. Truy cập `/Staff/marketinghome.jsp`
3. **Expected**: Cho phép truy cập
4. Truy cập `/Staff/salehome.jsp`
5. **Expected**: Redirect sang access-denied

## Troubleshooting

### Lỗi thường gặp:
1. **Import errors**: Đảm bảo các import đúng package
2. **Filter order**: AuthenticationFilter phải chạy trước RoleBasedAccessControlFilter
3. **Session timeout**: Kiểm tra session timeout settings

### Debug:
- Kiểm tra console log để xem session conflict
- Sử dụng browser dev tools để kiểm tra session attributes
- Kiểm tra filter chain trong web.xml
