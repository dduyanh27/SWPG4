<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="model.Admin, model.Role, dal.CampaignDAO, model.Campaign" %>

<%
    // Authentication check - chỉ Marketing Staff mới được truy cập
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
    
    if (adminRole == null || !"Marketing Staff".equals(adminRole.getName())) {
        response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
        return;
    }
    
    Admin admin = (Admin) sessionObj.getAttribute("admin");
    
    // Lấy campaign ID từ parameter
    String campaignIdStr = request.getParameter("id");
    if (campaignIdStr == null || campaignIdStr.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/Staff/campaign.jsp");
        return;
    }
    
    int campaignId;
    try {
        campaignId = Integer.parseInt(campaignIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect(request.getContextPath() + "/Staff/campaign.jsp");
        return;
    }
    
    // Lấy thông tin campaign
    CampaignDAO campaignDAO = new CampaignDAO();
    Campaign campaign = campaignDAO.getCampaignById(campaignId);
    
    if (campaign == null) {
        response.sendRedirect(request.getContextPath() + "/Staff/campaign.jsp");
        return;
    }
    
    request.setAttribute("campaign", campaign);
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>✏️ Chỉnh sửa Chiến dịch Marketing - JOBs</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .form-container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            width: 100%;
            max-width: 1000px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
            animation: slideUp 0.5s ease;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .form-header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: white;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .form-header p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.95rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 24px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: rgba(255, 255, 255, 0.9);
            font-weight: 600;
            font-size: 0.95rem;
        }

        .required {
            color: #ff6b6b;
            margin-left: 4px;
        }

        .form-input,
        .form-select,
        .form-textarea {
            width: 100%;
            padding: 14px 18px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            color: white;
            font-size: 15px;
            font-family: inherit;
            transition: all 0.3s ease;
        }

        .form-input::placeholder,
        .form-textarea::placeholder {
            color: rgba(255, 255, 255, 0.4);
        }

        .form-input:focus,
        .form-select:focus,
        .form-textarea:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.12);
            border-color: #4facfe;
            box-shadow: 0 0 0 3px rgba(79, 172, 254, 0.2);
        }

        .form-select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='white' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 18px center;
            padding-right: 45px;
        }

        .form-select option {
            background: #1a202c;
            color: white;
            padding: 10px;
        }

        .form-textarea {
            resize: vertical;
            min-height: 120px;
            line-height: 1.6;
        }

        .input-hint {
            font-size: 0.8125rem;
            color: rgba(255, 255, 255, 0.5);
            margin-top: 6px;
        }

        .form-actions {
            display: flex;
            gap: 16px;
            justify-content: flex-end;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .btn {
            padding: 14px 32px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-cancel {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .btn-cancel:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
        }

        .btn-submit {
            background: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
            color: white;
            box-shadow: 0 8px 24px rgba(79, 172, 254, 0.4);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(79, 172, 254, 0.5);
        }

        .btn-submit:disabled {
            background: rgba(255, 255, 255, 0.2);
            color: rgba(255, 255, 255, 0.5);
            cursor: not-allowed;
            box-shadow: none;
        }

        .validation-message {
            display: none;
            padding: 12px 16px;
            background: rgba(255, 107, 107, 0.2);
            border: 1px solid rgba(255, 107, 107, 0.4);
            border-radius: 8px;
            color: #ff6b6b;
            font-size: 0.875rem;
            margin-bottom: 20px;
        }

        .validation-message.show {
            display: block;
        }

        @media (max-width: 768px) {
            .form-container {
                padding: 30px 20px;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .form-header h1 {
                font-size: 1.5rem;
            }

            .form-actions {
                flex-direction: column-reverse;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="form-header">
            <h1>
                <span>✏️</span>
                Chỉnh sửa Chiến dịch Marketing
            </h1>
            <p>Cập nhật thông tin chiến dịch marketing</p>
        </div>

        <div class="validation-message" id="validationMessage"></div>
        
        <%-- Hiển thị thông báo lỗi từ server --%>
        <c:if test="${not empty requestScope.error}">
            <div class="validation-message show" style="background: rgba(255, 107, 107, 0.2); border: 1px solid rgba(255, 107, 107, 0.4); color: #ff6b6b;">
                ${requestScope.error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/UpdateCampaignServlet" method="post" onsubmit="return validateForm()">
            <!-- Hidden field for campaign ID -->
            <input type="hidden" name="campaignId" value="${campaign.campaignID}">
            
            <!-- CampaignName -->
            <div class="form-group full-width">
                <label for="campaignName">Tên chiến dịch <span class="required">*</span></label>
                <input type="text" id="campaignName" name="campaignName" class="form-input" 
                       placeholder="Nhập tên chiến dịch" maxlength="200" required
                       value="${campaign.campaignName}">
            </div>

            <div class="form-row">
                <!-- TargetType -->
                <div class="form-group">
                    <label for="targetType">Đối tượng <span class="required">*</span></label>
                    <select id="targetType" name="targetType" class="form-select" required>
                        <option value="">-- Chọn đối tượng --</option>
                        <option value="JobSeeker" ${campaign.targetType == 'JobSeeker' ? 'selected' : ''}>JobSeeker (Người tìm việc)</option>
                        <option value="Recruiter" ${campaign.targetType == 'Recruiter' ? 'selected' : ''}>Recruiter (Nhà tuyển dụng)</option>
                    </select>
                </div>

                <!-- Platform -->
                <div class="form-group">
                    <label for="platform">Nền tảng <span class="required">*</span></label>
                    <select id="platform" name="platform" class="form-select" required>
                        <option value="">-- Chọn nền tảng --</option>
                        <option value="Facebook" ${campaign.platform == 'Facebook' ? 'selected' : ''}>Facebook</option>
                        <option value="Google Ads" ${campaign.platform == 'Google Ads' ? 'selected' : ''}>Google Ads</option>
                        <option value="LinkedIn" ${campaign.platform == 'LinkedIn' ? 'selected' : ''}>LinkedIn</option>
                        <option value="Email" ${campaign.platform == 'Email' ? 'selected' : ''}>Email Marketing</option>
                        <option value="TikTok" ${campaign.platform == 'TikTok' ? 'selected' : ''}>TikTok</option>
                        <option value="Instagram" ${campaign.platform == 'Instagram' ? 'selected' : ''}>Instagram</option>
                        <option value="YouTube" ${campaign.platform == 'YouTube' ? 'selected' : ''}>YouTube</option>
                        <option value="Website" ${campaign.platform == 'Website' ? 'selected' : ''}>Website</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <!-- Budget -->
                <div class="form-group">
                    <label for="budget">Ngân sách (VNĐ) <span class="required">*</span></label>
                    <input type="number" id="budget" name="budget" class="form-input" 
                           placeholder="0" min="0" step="1000" required
                           value="${campaign.budget}">
                    <div class="input-hint">Nhập số tiền ngân sách dự kiến cho chiến dịch</div>
                </div>

                <!-- Status -->
                <div class="form-group">
                    <label for="status">Trạng thái <span class="required">*</span></label>
                    <select id="status" name="status" class="form-select" required>
                        <option value="">-- Chọn trạng thái --</option>
                        <option value="Planned" ${campaign.status == 'Planned' ? 'selected' : ''}>Planned (Đã lên kế hoạch)</option>
                        <option value="Running" ${campaign.status == 'Running' ? 'selected' : ''}>Running (Đang chạy)</option>
                        <option value="Paused" ${campaign.status == 'Paused' ? 'selected' : ''}>Paused (Tạm dừng)</option>
                        <option value="Completed" ${campaign.status == 'Completed' ? 'selected' : ''}>Completed (Hoàn thành)</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <!-- StartDate -->
                <div class="form-group">
                    <label for="startDate">Ngày bắt đầu <span class="required">*</span></label>
                    <input type="date" id="startDate" name="startDate" class="form-input" required
                           value="${campaign.startDate}">
                </div>

                <!-- EndDate -->
                <div class="form-group">
                    <label for="endDate">Ngày kết thúc <span class="required">*</span></label>
                    <input type="date" id="endDate" name="endDate" class="form-input" required
                           value="${campaign.endDate}">
                </div>
            </div>

            <!-- Description -->
            <div class="form-group full-width">
                <label for="description">Mô tả chiến dịch</label>
                <textarea id="description" name="description" class="form-textarea" 
                          placeholder="Nhập mô tả chi tiết về chiến dịch, mục tiêu, đối tượng mục tiêu, nội dung...">${campaign.description}</textarea>
                <div class="input-hint">Mô tả mục tiêu, nội dung và các thông tin khác của chiến dịch</div>
            </div>

            <div class="form-actions">
                <button type="button" class="btn btn-cancel" onclick="window.location.href='campaign.jsp'">
                    🚪 Hủy
                </button>
                <button type="submit" class="btn btn-submit">
                    ✏️ Cập nhật Chiến dịch
                </button>
            </div>
        </form>
    </div>

    <script>
        function validateForm() {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            const budget = parseFloat(document.getElementById('budget').value);
            const validationMessage = document.getElementById('validationMessage');

            // Reset validation message
            validationMessage.classList.remove('show');
            validationMessage.textContent = '';

            // Validate dates
            if (startDate && endDate) {
                const start = new Date(startDate);
                const end = new Date(endDate);

                if (end < start) {
                    validationMessage.textContent = 'Ngày kết thúc phải sau ngày bắt đầu!';
                    validationMessage.classList.add('show');
                    return false;
                }
            }

            // Validate budget
            if (budget < 0) {
                validationMessage.textContent = 'Ngân sách không được âm!';
                validationMessage.classList.add('show');
                return false;
            }

            return true;
        }

        // Set min date for date inputs to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('startDate').setAttribute('min', today);
        
        // Update end date min when start date changes
        document.getElementById('startDate').addEventListener('change', function() {
            document.getElementById('endDate').setAttribute('min', this.value);
        });

        // Format budget input
        document.getElementById('budget').addEventListener('input', function(e) {
            let value = this.value.replace(/\D/g, '');
            if (value) {
                this.value = parseInt(value);
            }
        });
    </script>
</body>
</html>
