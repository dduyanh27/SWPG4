<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Tuyển Dụng - Dashboard Tuyển Dụng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Recruiter/css/job-posting.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
/*             Existing alert styles 
            .alert {
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 5px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .alert-error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }*/


            /* Custom Toast Notification Style (for skill limit warning) */
            #custom-toast {
                position: fixed;
                bottom: 20px;
                left: 50%;
                transform: translateX(-50%);
                background-color: #dc3545; /* Red background for error/warning */
                color: white;
                padding: 12px 20px;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                opacity: 0;
                transition: opacity 0.3s, bottom 0.3s;
                z-index: 1000;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            #custom-toast.show {
                opacity: 1;
                bottom: 30px;
            }
            .skill-tag {
                display: inline-block;
                background-color: #f0f0f0;
                border: 1px solid #ccc;
                color: #333;
                padding: 3px 8px;
                margin: 2px;
                border-radius: 4px;
                font-size: 0.9em;
            }
            .close-tag {
                color: #999 !important;
                margin-left: 5px;
                cursor: pointer;
            }
            .close-tag:hover {
                color: #333 !important;
            }
        </style>
    </head>
    <body class="job-posting-page">
        <nav class="navbar">
            <div class="nav-container">
                <div class="nav-left">
                    <div class="logo">
                        <i class="fas fa-briefcase"></i>
                        <span>RecruitPro</span>
                    </div>
                    <ul class="nav-menu">
                        <li><a href="${pageContext.request.contextPath}/Recruiter/index.jsp">Dashboard</a></li>
                        <li><a href="#">Việc Làm</a></li>
                        <li class="dropdown">
                            <a href="#">Ứng viên <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="#">Quản lý theo việc đăng tuyển</a>
                                <a href="${pageContext.request.contextPath}/Recruiter/candidate-folder.html">Quản lý theo thư mục và thẻ</a>
                            </div>
                        </li>
                        <li class="dropdown">
                            <a href="#">Onboarding <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="#">Quy trình onboarding</a>
                                <a href="#">Tài liệu hướng dẫn</a>
                            </div>
                        </li>
                        <li><a href="#">Đơn hàng</a></li>
                        <li><a href="#">Báo cáo</a></li>
                        <li><a href="#" class="company-link">Công ty</a></li>
                    </ul>
                </div>
                <div class="nav-right">
                    <div class="nav-buttons">
                        <div class="dropdown">
                            <button class="btn btn-orange active">
                                ĐĂNG TUYỂN DỤNG <i class="fas fa-chevron-down"></i>
                            </button>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/Recruiter/job-posting.jsp" class="active">Tạo tin tuyển dụng mới</a>
                                <a href="${pageContext.request.contextPath}/Recruiter/job-management.jsp">Quản lý tin đã đăng</a>
                            </div>
                        </div>
                        <button class="btn btn-blue" onclick="window.location.href = '${pageContext.request.contextPath}/Recruiter/candidate-profile.html'">TÌM ỨNG VIÊN</button>
                        <button class="btn btn-white">Mua</button>
                    </div>
                    <div class="nav-icons">
                        <i class="fas fa-shopping-cart"></i>
                        <div class="dropdown user-dropdown">
                            <div class="user-avatar">
                                <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNGNUY3RkEiLz4KPHN2ZyB4PSIxMCIgeT0iMTAiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSIjOUNBM0FGIi8+CjxwYXRoIGQ9Ik0xMiAxNEM5LjMzIDE0IDcgMTYuMzMgNyAxOVYyMVgxN1YxOUMxNyAxNi4zMyAxNC42NyAxNCAxMiAxNFoiIGZpbGw9IiM5Q0EzQUYiLz4KPC9zdmc+Cjwvc3ZnPgo=" alt="User Avatar" class="avatar-img">
                            </div>
                            <div class="dropdown-content user-menu">
                                <div class="user-header">
                                    <i class="fas fa-user-circle"></i>
                                    <div class="user-info">
                                        <div class="user-name">Nguyen Phuoc</div>
                                    </div>
                                    <i class="fas fa-times close-menu"></i>
                                </div>


                                <div class="menu-section">
                                    <div class="section-title">Thành viên</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-users"></i>
                                        <span>Thành viên</span>
                                    </a>
                                </div>


                                <div class="menu-section">
                                    <div class="section-title">Thiết lập tài khoản</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-cog"></i>
                                        <span>Quản lý tài khoản</span>
                                    </a>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-building"></i>
                                        <span>Thông tin công ty</span>
                                    </a>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-shield-alt"></i>
                                        <span>Quản lý quyền truy cập</span>
                                    </a>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-tasks"></i>
                                        <span>Quản lý yêu cầu</span>
                                    </a>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-history"></i>
                                        <span>Lịch sử hoạt động</span>
                                    </a>
                                </div>


                                <div class="menu-section">
                                    <div class="section-title">Liên hệ mua</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-phone"></i>
                                        <span>Liên hệ mua</span>
                                    </a>
                                </div>


                                <div class="menu-section">
                                    <div class="section-title">Hỏi đáp</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-question-circle"></i>
                                        <span>Hỏi đáp</span>
                                    </a>
                                </div>


                                <div class="menu-footer">
                                    <a href="#" class="logout-item">
                                        <i class="fas fa-sign-out-alt"></i>
                                        <span>Thoát</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </nav>


        <div class="progress-container">
            <div class="progress-steps">
                <div class="step active">
                    <div class="step-number">1</div>
                    <div class="step-title">Chỉnh sửa việc làm</div>
                </div>
                <div class="step-line"></div>
                <div class="step">
                    <div class="step-number">2</div>
                    <div class="step-title">Thiết lập quy trình</div>
                </div>
                <div class="step-line"></div>
                <div class="step">
                    <div class="step-number">3</div>
                    <div class="step-title">Đăng tuyển dụng</div>
                </div>
            </div>
        </div>


        <main class="job-posting-main">
            <div class="job-posting-container">
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <c:out value="${success}"/>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <c:out value="${error}"/>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/jobposting" method="POST" id="job-posting-form">
                    <div class="form-section">
                        <div class="section-header">
                            <h2>Mô tả công việc</h2>
                        </div>

                        <div class="form-group">
                            <label for="job-title"> Tiêu Đề <span class="required">*</span></label>
                   
                            <input type="text" id="job-title" name="job-title" 
                                   value="${jobTitle != null ? jobTitle : ''}" 
                                   required>
                        </div>


                        <div class="form-row">
                            <div class="form-group">
                                <label for="job-level">Cấp bậc <span class="required">*</span></label>
                                <select id="job-level" name="job-level" required>
                                    <option value="">Chọn cấp bậc</option>
                                    <c:forEach var="level" items="${jobLevels}">
                                
                                        <option value="${level.typeID}"
                                                ${level.typeID == selectedJobLevelID ? 'selected' : ''}>
                                            ${level.typeName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="job-type">Loại việc làm <span class="required">*</span></label>
                                <select id="job-type" name="job-type" required>
                                    <option value="">Chọn loại việc làm</option>
                                    <c:forEach var="type" items="${jobTypes}">
                           
                                        <option value="${type.typeID}"
                                                ${type.typeID == selectedJobTypeID ? 'selected' : ''}>
                                            ${type.typeName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="job-field">Lĩnh vực công việc <span class="required">*</span></label>
                            <select id="job-field" name="job-field" required>
                                <option value="">Chọn lĩnh vực</option>
                                <c:forEach var="category" items="${categories}">
                                    <c:if test="${empty category.parentCategoryID}">
                        
                                        <option value="${category.categoryID}"
                                                ${category.categoryID == selectedCategoryID ? 'selected' : ''}>
                                            ${category.categoryName}
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="work-location">Địa điểm làm việc <span class="required">*</span></label>
                            <select id="work-location" name="work-location" required>
                                <option value="">Chọn địa điểm</option>
                                <c:forEach var="location" items="${locations}">
  
                                    <option value="${location.locationID}"
                                            ${location.locationID == selectedLocationID ? 'selected' : ''}>
                                        ${location.locationName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Kỹ năng yêu cầu (Tối đa 3)</label>
                            <select id="job-skills" name="job-skills" multiple>
                                <c:forEach var="skill" items="${skills}">
                                    <option value="${skill.skillID}"
                                            <c:forEach var="selectedId" items="${selectedSkillIDs}">
                                                <c:if test="${skill.skillID == selectedId}">selected</c:if>
                                            </c:forEach>
                                            >${skill.skillName}</option>
                                </c:forEach>
                            </select>

                            <input type="hidden" id="selected-skill-ids" name="job-skills"> 
                            <div id="selected-skills" style="margin-top:10px; border:1px solid #ccc; padding:5px; min-height:30px;">
                            </div>
                        </div>

                        <div id="custom-toast" role="alert">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span id="toast-message"></span>
                        </div>


                        <script>
                            const select = document.getElementById('job-skills');
                            const selectedDiv = document.getElementById('selected-skills');
                            const selectedIdsInput = document.getElementById('selected-skill-ids');
                            const toast = document.getElementById('custom-toast');
                            const toastMessage = document.getElementById('toast-message');
                            const MAX_SKILLS = 3;

                            function showToast(message) {
                                toastMessage.textContent = message;
                                toast.classList.add('show');
                                // Tự động ẩn toast sau 3 giây
                                setTimeout(() => {
                                    toast.classList.remove('show');
                                }, 3000);
                            }


                            /**
                             * Cập nhật danh sách kỹ năng đã chọn và kiểm tra giới hạn
                             */
                            function updateSelected() {
                                selectedDiv.innerHTML = '';

                                let selectedOptions = Array.from(select.selectedOptions);
                                let selectedIDs = [];


                                // KIỂM TRA VÀ GIỚI HẠN SỐ LƯỢNG 
//                                if (selectedOptions.length > MAX_SKILLS) {
//                                    // Bỏ chọn phần tử cuối cùng 
//                                    const lastOption = selectedOptions.pop();
//                                    lastOption.selected = false;
//
//                                    // Cần gọi lại Array.from(select.selectedOptions) để lấy danh sách mới
//                                    selectedOptions = Array.from(select.selectedOptions);
//
//                                    // Hiển thị thông báo 
//                                    showToast(`Bạn chỉ có thể chọn tối đa ${MAX_SKILLS} kỹ năng.`);
//                                }


                                // Hiển thị các tag kỹ năng đã chọn
                                selectedOptions.forEach(opt => {
                                    const span = document.createElement('span');
                                    span.className = 'skill-tag'; // áp dụng CSS
                                    span.textContent = opt.text;

                                    const closeBtn = document.createElement('i');
                                    closeBtn.className = 'fas fa-times-circle close-tag';
                                    closeBtn.onclick = (e) => {
                                        e.preventDefault();
                                        opt.selected = false;
                                        updateSelected(); 
                                    };


                                    span.appendChild(closeBtn);
                                    selectedDiv.appendChild(span);
                                    selectedIDs.push(opt.value);
                                });


                                selectedIdsInput.value = selectedIDs.join(',');
                            }


                            select.addEventListener('change', updateSelected);

                            
                            updateSelected();
                        </script>


                        <div class="form-group">
                            <label for="expiration-date">Ngày hết hạn <span class="required">*</span></label>
                            <%-- Sửa: Lấy lại giá trị expirationDate --%>
                            <input type="date" id="expiration-date" name="expiration-date" 
                                   value="${expirationDate != null ? expirationDate : ''}"
                                   required>
                            <small class="hint">Tin tuyển dụng sẽ tự động hết hạn sau ngày này</small>
                        </div>


                        <div class="form-group">
                            <label for="job-description">Mô tả <span class="required">*</span></label>
                            <div class="rich-text-editor">
                                <div class="editor-toolbar">
                                    <button type="button" class="toolbar-btn"><i class="fas fa-bold"></i></button>
                                    <button type="button" class="toolbar-btn"><i class="fas fa-italic"></i></button>
                                </div>
                           
                                <textarea id="job-description" name="job-description" rows="10" required><c:out value="${description}"/></textarea>
                                <div class="char-counter"></div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="requirements">Yêu cầu công việc <span class="required">*</span></label>
                            <div class="rich-text-editor">
                                <div class="editor-toolbar">
                                    <button type="button" class="toolbar-btn"><i class="fas fa-bold"></i></button>
                                    <button type="button" class="toolbar-btn"><i class="fas fa-italic"></i></button>
                                </div>
                            
                                <textarea id="requirements" name="requirements" rows="10" required><c:out value="${requirements}"/></textarea>
                                <div class="char-counter"></div>
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="salary">Mức lương <span class="required">*</span> (VND)</label>
                            <div class="salary-input-group">
                            
                                <input type="number" id="salary-min" name="salary-min" 
                                       value="${salaryMin != null ? salaryMin : ''}" 
                                       placeholder="Từ">
                                <span class="dash">-</span>
                            
                                <input type="number" id="salary-max" name="salary-max" 
                                       value="${salaryMax != null ? salaryMax : ''}" 
                                       placeholder="Đến">
                                <div class="toggle-group">
                                    <label class="toggle-label">Hiển thị cho Ứng Viên</label>
                                    <label class="toggle-switch">
                                        <input type="checkbox">
                                        <span class="slider"></span>
                                    </label>
                                </div>
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="hiring-count">Số lượng tuyển dụng</label>
                            <div class="counter-input">
                                <button type="button" class="counter-btn minus">-</button>
                    
                                <input type="number" id="hiring-count" name="hiring-count" 
                                       value="${hiringCount != null ? hiringCount : '1'}" 
                                       min="1">
                                <button type="button" class="counter-btn plus">+</button>
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="age-requirement">Yêu cầu tuổi tối thiểu</label>
                            <div class="counter-input">
                                <button type="button" class="counter-btn minus">-</button>
                      
                                <input type="number" id="age-requirement" name="age-requirement" 
                                       value="${ageRequirement != null ? ageRequirement : '18'}" 
                                       min="15" max="65">
                                <button type="button" class="counter-btn plus">+</button>
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="min-qualification">Bằng cấp tối thiểu <span class="required">*</span></label>
                            <select id="min-qualification" name="min-qualification" required>
                                <option value="">Chọn bằng cấp</option>
                                <c:forEach var="cert" items="${certificates}">
                 
                                    <option value="${cert.typeID}"
                                            ${cert.typeID == selectedQualificationID ? 'selected' : ''}>
                                        ${cert.typeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>


                    </div>


                    <div class="form-actions">
                        <button type="button" 
                                class="btn btn-secondary" 
                                onclick="window.location.href = '${pageContext.request.contextPath}/homerecuiter'">
                            Hủy
                        </button>
                        <button type="submit" class="btn btn-primary">Lưu </button>
                    </div>
                </form>
            </div>
        </main>


        <div class="chat-widget">
            <div class="chat-content">
                <i class="fas fa-comments"></i>
                <span>Chat</span>
            </div>
        </div>


        <script src="${pageContext.request.contextPath}/Recruiter/script.js"></script>

        <script>
 
                                    document.querySelectorAll('.counter-input .counter-btn').forEach(button => {
                                        button.addEventListener('click', () => {
                                            const input = button.parentNode.querySelector('input[type="number"]');
                                            let value = parseInt(input.value);
                                            const min = parseInt(input.min) || 0;
                                            const max = parseInt(input.max) || Infinity;


                                            if (button.classList.contains('plus')) {
                                                if (value < max) {
                                                    input.value = value + 1;
                                                }
                                            } else if (button.classList.contains('minus')) {
                                                if (value > min) {
                                                    input.value = value - 1;
                                                }
                                            }
                                        });
                                    });
        </script>
    </body>
</html>