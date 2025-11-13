<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.text.SimpleDateFormat"%>
<%@page import="dal.ChatDAO"%>
<%@page import="model.Recruiter, model.Role"%>
<%
    // Authentication check - chỉ Sales mới được truy cập
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null) {
        response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
        return;
    }
    
    String userType = (String) sessionObj.getAttribute("userType");
    Role adminRole = (Role) sessionObj.getAttribute("adminRole");
    
    if (userType == null || !"admin".equals(userType)) {
        response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
        return;
    }
    
    if (adminRole == null || !"Sales".equals(adminRole.getName())) {
        response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Service - TopCV</title>
        <link rel="stylesheet" href="sale.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Auto-refresh every 3 seconds -->
        <meta http-equiv="refresh" content="3">
    </head>
    <body>
        <!-- Back Button -->
        <button class="back-button" onclick="goBack()">
            <i class="fas fa-arrow-left"></i>
            Quay lại
        </button>
        
        <!-- Connection Status -->
        <div class="connection-status connected">
            <i class="fas fa-wifi"></i> Đã kết nối
        </div>

        <div class="customer-service-container">
            <!-- Sidebar -->
            <div class="customer-sidebar">
                <div class="sidebar-header">
                    <h2><i class="fas fa-comments"></i> Hỗ trợ khách hàng</h2>
                    <p>Quản lý tin nhắn và hỗ trợ khách hàng</p>
                </div>
                
                <div class="search-box">
                    <form action="cus-service.jsp" method="GET">
                        <input type="text" name="searchRecruiter" placeholder="Tìm kiếm nhà tuyển dụng..." 
                               value="<%= request.getParameter("searchRecruiter") != null ? request.getParameter("searchRecruiter") : "" %>">
                        <button type="submit" class="btn-search">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>
                </div>
                
                <div class="customer-list">
                    <%
                        String searchTerm = request.getParameter("searchRecruiter");
                        String currentRecruiterId = request.getParameter("recruiterId");
                        if (currentRecruiterId == null) currentRecruiterId = "1";
                        
                        // Use existing ChatDAO to get recruiters
                        ChatDAO chatDAO = new ChatDAO();
                        List<Recruiter> filteredRecruiters;
                        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                            filteredRecruiters = chatDAO.searchRecruiters(searchTerm);
                        } else {
                            filteredRecruiters = chatDAO.getAllRecruiters();
                        }
                        
                        // Display filtered recruiters
                        for (Recruiter recruiter : filteredRecruiters) {
                            String recruiterId = String.valueOf(recruiter.getRecruiterID());
                            String avatar = recruiter.getCompanyName().substring(0, 2).toUpperCase();
                            String companyName = recruiter.getCompanyName();
                            String jobTitle = recruiter.getCompanyDescription();
                            String time = chatDAO.getLastMessageTime(recruiter.getRecruiterID());
                            int unreadCount = chatDAO.getUnreadMessageCount(recruiter.getRecruiterID());
                            String activeClass = recruiterId.equals(currentRecruiterId) ? "active" : "";
                    %>
                    <div class="customer-item <%= activeClass %>" onclick="selectRecruiter('<%= recruiterId %>')">
                        <div class="customer-avatar"><%= avatar %></div>
                        <div class="customer-info">
                            <div class="customer-name"><%= companyName %></div>
                            <div class="customer-last-message"><%= jobTitle %></div>
                        </div>
                        <div class="customer-meta">
                            <div><%= time %></div>
                            <% if (unreadCount > 0) { %>
                            <div class="unread-badge"><%= unreadCount %></div>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                    
                    <% if (filteredRecruiters.isEmpty()) { %>
                    <div class="no-results">
                        <i class="fas fa-search"></i>
                        <p>Không tìm thấy nhà tuyển dụng nào</p>
                    </div>
                    <% } %>
                </div>
            </div>
            
            <!-- Chat Main Area -->
            <div class="chat-main">
                <div class="chat-header">
                    <div class="chat-customer-info">
                        <%
                            String selectedRecruiterId = request.getParameter("recruiterId");
                            if (selectedRecruiterId == null) selectedRecruiterId = "1";
                            
                            // Get selected recruiter from DAO
                            Recruiter selectedRecruiter = chatDAO.getRecruiterById(Integer.parseInt(selectedRecruiterId));
                            String selectedAvatar = "CT";
                            String selectedName = "Công ty ABC";
                            String selectedJob = "Tuyển dụng Developer Java";
                            boolean isOnline = true;
                            
                            if (selectedRecruiter != null) {
                                selectedAvatar = selectedRecruiter.getCompanyName().substring(0, 2).toUpperCase();
                                selectedName = selectedRecruiter.getCompanyName();
                                selectedJob = selectedRecruiter.getCompanyDescription();
                                isOnline = true; // Default to online
                            }
                        %>
                        <div class="chat-customer-avatar"><%= selectedAvatar %></div>
                        <div class="chat-customer-details">
                            <h3><%= selectedName %></h3>
                            <p><%= selectedJob %></p>
                            <p><i class="fas fa-circle online-indicator"></i> <%= isOnline ? "Đang hoạt động" : "Offline" %></p>
                        </div>
                    </div>
                    <div class="chat-actions">
                        <button class="btn-action" onclick="makeCall()">
                            <i class="fas fa-phone"></i> Gọi
                        </button>
                        <button class="btn-action" onclick="makeVideoCall()">
                            <i class="fas fa-video"></i> Video
                        </button>
                        <button class="btn-action primary" onclick="showCustomerInfo()">
                            <i class="fas fa-info-circle"></i> Thông tin
                        </button>
                    </div>
                </div>
                
                <div class="chat-messages" id="chatMessages">
                    <%
                        // Get messages from session (simple format)
                        java.util.List<String[]> sessionMessages = 
                            (java.util.List<String[]>) session.getAttribute("chatMessages");
                        
                        // Display session messages (if any)
                        if (sessionMessages != null && !sessionMessages.isEmpty()) {
                            for (String[] msg : sessionMessages) {
                                if (msg.length >= 5 && msg[0].equals(selectedRecruiterId)) {
                                    String sender = msg[1];
                                    String avatar = msg[2];
                                    String message = msg[3];
                                    String time = msg[4];
                    %>
                    <div class="message <%= sender %>">
                        <div class="message-avatar"><%= avatar %></div>
                        <div class="message-content">
                            <div><%= message %></div>
                            <div class="message-time"><%= time %></div>
                        </div>
                    </div>
                    <%
                                }
                            }
                        } else {
                            // Show empty state
                    %>
                    <div class="empty-chat">
                        <i class="fas fa-comments"></i>
                        <h3>Chưa có tin nhắn nào</h3>
                        <p>Bắt đầu cuộc trò chuyện với nhà tuyển dụng</p>
                    </div>
                    <% } %>
                </div>
                
                <!-- Typing Indicator -->
                <div class="typing-indicator" id="typingIndicator">
                    <i class="fas fa-circle"></i>
                    <i class="fas fa-circle"></i>
                    <i class="fas fa-circle"></i>
                    <span>Đang nhập...</span>
                </div>
                
                <div class="chat-input-area">
                    <form action="../ChatServlet" method="POST" class="chat-input-container">
                        <input type="hidden" name="customerId" value="<%= selectedRecruiterId %>">
                        <textarea name="message" class="chat-input" placeholder="Nhập tin nhắn cho nhà tuyển dụng..." required></textarea>
                        <div class="chat-actions-bottom">
                            <button type="button" class="btn-attach" onclick="attachFile()">
                                <i class="fas fa-paperclip"></i>
                            </button>
                            <button type="submit" class="btn-send">
                                <i class="fas fa-paper-plane"></i> Gửi
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            // Simple navigation function
            function goBack() {
                window.location.href = 'salehome.jsp';
            }
            
            // Select recruiter function
            function selectRecruiter(recruiterId) {
                window.location.href = 'cus-service.jsp?recruiterId=' + recruiterId;
            }
            
            // Action functions
            function makeCall() {
                alert('Tính năng gọi điện sẽ được tích hợp với hệ thống VoIP');
            }
            
            function makeVideoCall() {
                alert('Tính năng video call sẽ được tích hợp với WebRTC');
            }
            
            function showCustomerInfo() {
                alert('Thông tin nhà tuyển dụng chi tiết sẽ được hiển thị ở đây');
            }
            
            function attachFile() {
                alert('Tính năng đính kèm file sẽ được tích hợp');
            }
        </script>
    </body>
</html>