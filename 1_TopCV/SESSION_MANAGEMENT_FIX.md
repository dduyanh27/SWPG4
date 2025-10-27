# Session Management Enhancement - Fix for Back Button Issue

## Vấn đề đã được giải quyết

**Vấn đề**: Sau khi vào access-denied, người dùng ấn "Quay lại" và refresh trang thì vẫn có thể load được session của cả 2 role.

**Nguyên nhân**: 
- Session chỉ được invalidate khi phát hiện conflict
- Không có cơ chế clear session hoàn toàn khi người dùng quay lại
- Nút "Quay lại" không xử lý session cleanup

## Giải pháp đã triển khai

### 1. ClearSessionServlet (`controller.base.ClearSessionServlet`)

```java
@WebServlet(name = "ClearSessionServlet", urlPatterns = {"/ClearSessionServlet"})
public class ClearSessionServlet extends HttpServlet {
    
    private void processClearSession(HttpServletRequest request, HttpServletResponse response) {
        // Clear session hoàn toàn
        HttpSession session = request.getSession(false);
        if (session != null) {
            // Clear tất cả attributes
            session.removeAttribute("user");
            session.removeAttribute("userType");
            session.removeAttribute("userID");
            session.removeAttribute("userName");
            session.removeAttribute("admin");
            session.removeAttribute("adminRole");
            session.removeAttribute("jobseeker");
            session.removeAttribute("recruiter");
            session.removeAttribute("staffType");
            session.removeAttribute("sessionIdentifier");
            session.removeAttribute("accessDeniedMessage");
            
            // Invalidate session
            session.invalidate();
        }
        
        // Redirect về trang chủ
        response.sendRedirect(request.getContextPath() + "/index.html");
    }
}
```

**Chức năng**:
- Xóa hoàn toàn tất cả dữ liệu session
- Invalidate session
- Redirect về trang chủ

### 2. SessionManager Enhancement

#### Phương thức mới: `checkAndClearSessionIfNeeded()`

```java
public static boolean checkAndClearSessionIfNeeded(HttpServletRequest request) {
    HttpSession session = request.getSession(false);
    if (session == null) {
        return false;
    }
    
    // Kiểm tra session conflict
    if (hasSessionConflict(request)) {
        System.out.println("SESSION CONFLICT DETECTED - Clearing session completely");
        clearSessionCompletely(request);
        return true;
    }
    
    // Kiểm tra session không hợp lệ
    String userType = (String) session.getAttribute(USER_TYPE_KEY);
    if (userType == null) {
        System.out.println("INVALID SESSION - No userType found, clearing session");
        clearSessionCompletely(request);
        return true;
    }
    
    // Kiểm tra tính nhất quán của session
    if (!isSessionConsistent(session, userType)) {
        System.out.println("INCONSISTENT SESSION - Clearing session completely");
        clearSessionCompletely(request);
        return true;
    }
    
    return false;
}
```

#### Phương thức mới: `isSessionConsistent()`

```java
private static boolean isSessionConsistent(HttpSession session, String userType) {
    switch (userType) {
        case "admin":
            // Admin session phải có admin object và adminRole
            return session.getAttribute(ADMIN_KEY) != null && 
                   session.getAttribute(ADMIN_ROLE_KEY) != null &&
                   session.getAttribute(JOBSEEKER_KEY) == null &&
                   session.getAttribute(RECRUITER_KEY) == null;
                   
        case "jobseeker":
            // JobSeeker session phải có jobseeker object
            return session.getAttribute(JOBSEEKER_KEY) != null &&
                   session.getAttribute(ADMIN_KEY) == null &&
                   session.getAttribute(RECRUITER_KEY) == null;
                   
        case "recruiter":
            // Recruiter session phải có recruiter object
            return session.getAttribute(RECRUITER_KEY) != null &&
                   session.getAttribute(ADMIN_KEY) == null &&
                   session.getAttribute(JOBSEEKER_KEY) == null;
                   
        default:
            return false;
    }
}
```

**Chức năng**:
- Kiểm tra session conflict
- Kiểm tra session không hợp lệ
- Kiểm tra tính nhất quán của session
- Tự động clear session nếu phát hiện vấn đề

### 3. Filter Updates

#### AuthenticationFilter
```java
// Check for session conflicts and invalid sessions first
if (SessionManager.checkAndClearSessionIfNeeded(httpRequest)) {
    System.out.println("SESSION CLEARED in AuthenticationFilter - Redirecting to login");
    httpResponse.sendRedirect(contextPath + "/JobSeeker/jobseeker-login.jsp");
    return;
}
```

#### RoleBasedAccessControlFilter
```java
// Check session conflicts and invalid sessions first
if (SessionManager.checkAndClearSessionIfNeeded(httpRequest)) {
    System.out.println("SESSION CLEARED in RoleBasedAccessControlFilter - Redirecting to login");
    httpResponse.sendRedirect(contextPath + "/JobSeeker/jobseeker-login.jsp");
    return;
}
```

**Cải tiến**:
- Sử dụng `checkAndClearSessionIfNeeded()` thay vì chỉ kiểm tra conflict
- Tự động redirect về login khi session không hợp lệ
- Log chi tiết để debug

### 4. Access Denied Page Updates

#### Thay đổi nút "Quay lại"
```html
<!-- Trước -->
<a href="javascript:history.back()" class="btn btn-secondary">
    ← Quay lại
</a>

<!-- Sau -->
<a href="${pageContext.request.contextPath}/ClearSessionServlet" class="btn btn-primary">
    🔄 Đăng nhập lại
</a>

<a href="${pageContext.request.contextPath}/index.html" class="btn btn-secondary">
    🏠 Về trang chủ
</a>
```

#### JavaScript Enhancement
```javascript
// Prevent back button and force session clear
window.addEventListener('pageshow', function(event) {
    if (event.persisted) {
        // Page was loaded from cache (back button)
        console.log('Page loaded from cache - redirecting to clear session');
        window.location.href = '${pageContext.request.contextPath}/ClearSessionServlet';
    }
});

// Disable back button
history.pushState(null, null, location.href);
window.onpopstate = function(event) {
    history.go(1);
};
```

**Chức năng**:
- Ngăn chặn nút "Quay lại" của browser
- Tự động redirect đến ClearSessionServlet khi load từ cache
- Force người dùng phải đăng nhập lại

## Luồng xử lý mới

### Scenario: Người dùng đăng nhập JobSeeker, sau đó đăng nhập Admin

```
1. Đăng nhập JobSeeker
   ├── Session: {userType: "jobseeker", jobseeker: JobSeekerObject}
   └── Redirect: /JobSeeker/index.jsp

2. Mở tab mới, đăng nhập Admin
   ├── SessionManager.createIsolatedSession() được gọi
   ├── Phát hiện existing session với userType = "jobseeker"
   ├── Invalidate session cũ
   ├── Tạo session mới: {userType: "admin", admin: AdminObject, adminRole: RoleObject}
   └── Redirect: /Admin/admin-dashboard.jsp

3. Refresh tab JobSeeker
   ├── Request đến /JobSeeker/index.jsp
   ├── AuthenticationFilter.doFilter() được gọi
   ├── SessionManager.checkAndClearSessionIfNeeded() = true
   ├── SessionManager.clearSessionCompletely() được gọi
   ├── Redirect: /JobSeeker/jobseeker-login.jsp
   └── Session hoàn toàn sạch

4. Người dùng ấn "Quay lại" từ access-denied
   ├── JavaScript ngăn chặn back button
   ├── Redirect đến /ClearSessionServlet
   ├── ClearSessionServlet.clearSessionCompletely()
   └── Redirect: /index.html
```

## Các cải tiến chính

### 1. **Session Validation Mạnh Mẽ**
- Kiểm tra session conflict
- Kiểm tra session không hợp lệ
- Kiểm tra tính nhất quán của session
- Tự động clear session khi phát hiện vấn đề

### 2. **Complete Session Cleanup**
- Xóa tất cả attributes
- Invalidate session
- Redirect về trang chủ
- Không để lại dữ liệu cũ

### 3. **User Experience Cải Thiện**
- Thay nút "Quay lại" bằng "Đăng nhập lại"
- Ngăn chặn back button
- Tự động redirect khi load từ cache
- Thông báo rõ ràng

### 4. **Security Enhancement**
- Không cho phép truy cập với session không hợp lệ
- Force re-authentication khi cần thiết
- Ngăn chặn session hijacking

## Testing

### Test Case 1: Back Button Prevention
1. Đăng nhập JobSeeker
2. Mở tab mới, đăng nhập Admin
3. Refresh tab JobSeeker → Access denied
4. Ấn "Quay lại" → Redirect đến ClearSessionServlet
5. **Expected**: Session được clear hoàn toàn

### Test Case 2: Session Consistency
1. Đăng nhập JobSeeker
2. Manually modify session (add admin data)
3. Refresh trang
4. **Expected**: Session được clear và redirect về login

### Test Case 3: Cache Loading
1. Đăng nhập JobSeeker
2. Mở tab mới, đăng nhập Admin
3. Refresh tab JobSeeker → Access denied
4. Use browser back button
5. **Expected**: Redirect đến ClearSessionServlet

## Kết quả

✅ **Session được clear hoàn toàn** khi có conflict
✅ **Không thể truy cập** với session không hợp lệ
✅ **Ngăn chặn back button** để tránh bypass
✅ **Force re-authentication** khi cần thiết
✅ **User experience tốt hơn** với thông báo rõ ràng
