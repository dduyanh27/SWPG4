<style>
    /* Inline styles for notification component - can be moved to separate CSS file */
    .notification-icon {
        position: relative;
        cursor: pointer;
        padding: 10px;
        margin: 0 5px;
    }
    
    .notification-icon i {
        font-size: 20px;
        color: #333;
    }
    
    .notification-badge {
        position: absolute;
        top: 5px;
        right: 5px;
        background: #ff4444;
        color: white;
        border-radius: 50%;
        width: 20px;
        height: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 11px;
        font-weight: bold;
    }
    
    .notification-dropdown {
        position: absolute;
        top: 100%;
        right: 0;
        width: 400px;
        max-height: 600px;
        background: white;
        border-radius: 8px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        display: none;
        flex-direction: column;
        z-index: 1000;
        margin-top: 10px;
    }
    
    .notification-dropdown.show {
        display: flex;
    }
    
    .notification-header {
        padding: 15px 20px;
        border-bottom: 1px solid #eee;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 8px 8px 0 0;
    }
    
    .notification-header h3 {
        margin: 0;
        font-size: 16px;
        color: white;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .notification-tabs {
        display: flex;
        border-bottom: 1px solid #eee;
        background: #f8f9fa;
    }
    
    .notification-tab {
        flex: 1;
        padding: 12px;
        border: none;
        background: none;
        cursor: pointer;
        font-size: 14px;
        color: #666;
        transition: all 0.3s;
        position: relative;
    }
    
    .notification-tab.active {
        color: #667eea;
        font-weight: 600;
    }
    
    .notification-tab.active::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 3px;
        background: #667eea;
    }
    
    .notification-list {
        max-height: 400px;
        overflow-y: auto;
    }
    
    .notification-item {
        display: flex;
        padding: 15px 20px;
        border-bottom: 1px solid #f0f0f0;
        cursor: pointer;
        transition: background 0.2s;
        position: relative;
    }
    
    .notification-item:hover {
        background: #f8f9fa;
    }
    
    .notification-item.unread {
        background: #f0f4ff;
    }
    
    .notification-icon-wrapper {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 12px;
        flex-shrink: 0;
    }
    
    .notification-icon-wrapper.application {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }
    
    .notification-icon-wrapper.profile {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        color: white;
    }
    
    .notification-icon-wrapper.system {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        color: white;
    }
    
    .notification-content {
        flex: 1;
    }
    
    .notification-title {
        margin: 0 0 4px 0;
        font-size: 14px;
        font-weight: 600;
        color: #333;
    }
    
    .notification-message {
        margin: 0 0 4px 0;
        font-size: 13px;
        color: #666;
        line-height: 1.4;
    }
    
    .notification-time {
        font-size: 12px;
        color: #999;
    }
    
    .notification-dot {
        width: 8px;
        height: 8px;
        background: #667eea;
        border-radius: 50%;
        position: absolute;
        right: 20px;
        top: 50%;
        transform: translateY(-50%);
    }
    
    .notification-empty {
        padding: 40px 20px;
        text-align: center;
    }
    
    .notification-empty-icon {
        font-size: 48px;
        color: #ddd;
        margin-bottom: 10px;
    }
    
    .notification-empty-text {
        color: #999;
        font-size: 14px;
    }
    
    .notification-footer {
        padding: 12px 20px;
        border-top: 1px solid #eee;
        text-align: center;
    }
    
    .notification-view-all {
        color: #667eea;
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
    }
</style>

<!-- Notification Dropdown HTML -->
<div class="notification-icon" id="notificationIcon">
    <i class="fas fa-bell"></i>
    <span class="notification-badge" style="display:none;">0</span>
    
    <!-- Notification Dropdown -->
    <div class="notification-dropdown" id="notificationDropdown">
        <div class="notification-header">
            <h3><i class="fas fa-bell"></i> Thông Báo</h3>
        </div>
        
        <div class="notification-tabs">
            <button class="notification-tab active" data-tab="all">Tất cả</button>
            <button class="notification-tab" data-tab="unread">Chưa đọc</button>
            <button class="notification-tab" data-tab="read">Đã đọc</button>
        </div>
        
        <div class="notification-list">
            <div class="notification-empty">
                <div class="notification-empty-icon">
                    <i class="fas fa-spinner fa-spin"></i>
                </div>
                <p class="notification-empty-text">Đang tải...</p>
            </div>
        </div>
        
        <div class="notification-footer">
            <a href="#" class="notification-view-all">Xem tất cả thông báo</a>
        </div>
    </div>
</div>

<!-- Notification Dropdown JavaScript -->
<script>
(function() {
    const notificationIcon = document.getElementById('notificationIcon');
    const notificationDropdown = document.getElementById('notificationDropdown');
    const notificationTabs = document.querySelectorAll('.notification-tab');
    const notificationList = document.querySelector('.notification-list');
    const notificationBadge = document.querySelector('.notification-badge');
    
    if (!notificationIcon || !notificationDropdown) return;
    
    let allNotifications = [];
    let currentFilter = 'all';
    
    // Load notifications từ server
    function loadNotifications() {
        fetch('<%= request.getContextPath() %>/notifications?action=getRecent&limit=20')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    allNotifications = data.notifications;
                    renderNotifications(currentFilter);
                    updateBadgeCount();
                }
            })
            .catch(error => console.error('Error loading notifications:', error));
    }
    
    // Render notifications based on filter
    function renderNotifications(filter) {
        notificationList.innerHTML = '';
        currentFilter = filter;
        
        let filtered = allNotifications;
        if (filter === 'unread') {
            filtered = allNotifications.filter(n => !n.isRead);
        } else if (filter === 'read') {
            filtered = allNotifications.filter(n => n.isRead);
        }
        
        if (filtered.length === 0) {
            notificationList.innerHTML = 
                '<div class="notification-empty">' +
                    '<div class="notification-empty-icon"><i class="fas fa-inbox"></i></div>' +
                    '<p class="notification-empty-text">Không có thông báo nào</p>' +
                '</div>';
            return;
        }
        
        filtered.forEach(notif => {
            const item = createNotificationItem(notif);
            notificationList.appendChild(item);
        });
    }
    
    // Create notification item HTML
    function createNotificationItem(notif) {
        const item = document.createElement('div');
        item.className = 'notification-item' + (notif.isRead ? '' : ' unread');
        item.setAttribute('data-id', notif.notificationID);
        item.setAttribute('data-status', notif.isRead ? 'read' : 'unread');
        
        let iconClass = 'fas fa-bell';
        let iconColorClass = 'system';
        
        if (notif.iconType === 'application') {
            iconClass = 'fas fa-file-alt';
            iconColorClass = 'application';
        } else if (notif.iconType === 'profile') {
            iconClass = 'fas fa-user-check';
            iconColorClass = 'profile';
        } else if (notif.iconType === 'chat') {
            iconClass = 'fas fa-comment';
            iconColorClass = 'system';
        }
        
        item.innerHTML = 
            '<div class="notification-icon-wrapper ' + iconColorClass + '">' +
                '<i class="' + iconClass + '"></i>' +
            '</div>' +
            '<div class="notification-content">' +
                '<p class="notification-title">' + escapeHtml(notif.title) + '</p>' +
                '<p class="notification-message">' + escapeHtml(notif.message) + '</p>' +
                '<span class="notification-time">' + notif.timeAgo + '</span>' +
            '</div>' +
            (!notif.isRead ? '<div class="notification-dot"></div>' : '');
        
        // Chỉ mark as read, không redirect
        item.addEventListener('click', function(e) {
            e.stopPropagation();
            if (!notif.isRead) {
                markAsRead(notif.notificationID);
            }
        });
        
        return item;
    }
    
    // Mark notification as read
    function markAsRead(notificationID) {
        const params = new URLSearchParams();
        params.append('notificationID', notificationID);
        
        fetch('<%= request.getContextPath() %>/notifications?action=markAsRead', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params.toString()
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const notif = allNotifications.find(n => n.notificationID == notificationID);
                if (notif) {
                    notif.isRead = true;
                    
                    // Update UI immediately
                    const notificationItem = document.querySelector('.notification-item[data-id="' + notificationID + '"]');
                    if (notificationItem) {
                        notificationItem.classList.remove('unread');
                        notificationItem.setAttribute('data-status', 'read');
                        const dot = notificationItem.querySelector('.notification-dot');
                        if (dot) dot.remove();
                    }
                    
                    // Update badge count
                    updateBadgeCount();
                    
                    // Re-render if on "unread" tab
                    const activeTab = document.querySelector('.notification-tab.active');
                    if (activeTab && activeTab.getAttribute('data-tab') === 'unread') {
                        renderNotifications('unread');
                    }
                }
            }
        })
        .catch(error => console.error('Error marking as read:', error));
    }
    
    // Update badge count
    function updateBadgeCount() {
        const unreadCount = allNotifications.filter(n => !n.isRead).length;
        if (notificationBadge) {
            if (unreadCount > 0) {
                notificationBadge.textContent = unreadCount;
                notificationBadge.style.display = 'flex';
            } else {
                notificationBadge.style.display = 'none';
            }
        }
    }
    
    // Escape HTML to prevent XSS
    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
    
    // Toggle dropdown
    notificationIcon.addEventListener('click', function(e) {
        e.stopPropagation();
        const wasShown = notificationDropdown.classList.contains('show');
        notificationDropdown.classList.toggle('show');
        if (!wasShown) loadNotifications();
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!notificationDropdown.contains(e.target) && !notificationIcon.contains(e.target)) {
            notificationDropdown.classList.remove('show');
        }
    });
    
    // Prevent dropdown from closing when clicking inside
    notificationDropdown.addEventListener('click', function(e) {
        e.stopPropagation();
    });
    
    // Tab filtering
    notificationTabs.forEach(tab => {
        tab.addEventListener('click', function() {
            notificationTabs.forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            
            const filter = this.getAttribute('data-tab');
            renderNotifications(filter);
        });
    });
    
    // Load initial badge count
    fetch('<%= request.getContextPath() %>/notifications?action=getUnreadCount')
        .then(response => response.json())
        .then(data => {
            if (data.success && notificationBadge) {
                const count = data.unreadCount;
                if (count > 0) {
                    notificationBadge.textContent = count;
                    notificationBadge.style.display = 'flex';
                } else {
                    notificationBadge.style.display = 'none';
                }
            }
        })
        .catch(error => console.error('Error loading unread count:', error));
})();
</script>