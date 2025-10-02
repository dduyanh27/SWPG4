<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="32kb" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <c:choose>
            <c:when test="${not empty job}">
                <title>Chỉnh Sửa Việc Làm: <c:out value="${job.jobTitle}"/> - Dashboard</title>
            </c:when>
            <c:otherwise>
                <title>Đăng Tuyển Dụng Mới - Dashboard Tuyển Dụng</title>
            </c:otherwise>
        </c:choose>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Recruiter/css/job-posting.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Custom CSS từ file gốc */
            #custom-toast {
                position: fixed;
                bottom: 20px;
                left: 50%;
                transform: translateX(-50%);
                background-color: #dc3545;
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
            }

            .salary-input-container {
                display: flex;
                flex-direction: column; 
            }

            .salary-input-group {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-top: 5px;
            }

            .salary-input-group input[type="number"] {
                flex-grow: 1; 
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                max-width: 150px; 
            }

            .dash {
                font-weight: bold;
                color: #555;
            }
        </style>
    </head>
    <body class="job-posting-page">

        <%-- PHẦN NAV BAR (Giữ nguyên) --%>
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
                            <%-- Menu người dùng (Giữ nguyên) --%>
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
                                    <a href="#" class="menu-item"><i class="fas fa-users"></i><span>Thành viên</span></a>
                                </div>
                                <div class="menu-section">
                                    <div class="section-title">Thiết lập tài khoản</div>
                                    <a href="#" class="menu-item"><i class="fas fa-cog"></i><span>Quản lý tài khoản</span></a>
                                    <a href="#" class="menu-item"><i class="fas fa-building"></i><span>Thông tin công ty</span></a>
                                    <a href="#" class="menu-item"><i class="fas fa-shield-alt"></i><span>Quản lý quyền truy cập</span></a>
                                    <a href="#" class="menu-item"><i class="fas fa-tasks"></i><span>Quản lý yêu cầu</span></a>
                                    <a href="#" class="menu-item"><i class="fas fa-history"></i><span>Lịch sử hoạt động</span></a>
                                </div>
                                <div class="menu-section">
                                    <div class="section-title">Liên hệ mua</div>
                                    <a href="#" class="menu-item"><i class="fas fa-phone"></i><span>Liên hệ mua</span></a>
                                </div>
                                <div class="menu-section">
                                    <div class="section-title">Hỏi đáp</div>
                                    <a href="#" class="menu-item"><i class="fas fa-question-circle"></i><span>Hỏi đáp</span></a>
                                </div>
                                <div class="menu-footer">
                                    <a href="#" class="logout-item"><i class="fas fa-sign-out-alt"></i><span>Thoát</span></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
        <%-- KẾT THÚC PHẦN NAV BAR --%>




        <main class="job-posting-main">
            <div class="job-posting-container">

                <h1 style="text-align: center; margin-bottom: 30px;">
                    <c:choose>
                        <c:when test="${not empty job}">
                            Thông Tin Công Việc
                        </c:when>
                        <c:otherwise>
                            Đăng Tuyển Dụng Mới (Bước 1/3)
                        </c:otherwise>
                    </c:choose>
                </h1>
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

                <%-- Form chính --%>
                <form action="<c:url value="/jobdetails"/>" method="GET" id="job-posting-form">
                    <c:if test="${not empty job}">
                        <input type="hidden" name="job-id" value="${job.jobID}">
                    </c:if>

                    <div class="form-section">
                        <div class="section-header">
                            <h2>Mô tả công việc</h2>
                        </div>

                        <div class="form-group">
                            <label for="job-title"> Tiêu Đề</label>
                            <input type="text" id="job-title" name="job-title" 
                                   value="<c:out value="${job.jobTitle}"/>" 
                                   readonly>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="job-level">Cấp bậc</label>
                                <select id="job-level" name="job-level" disabled>
                                    <option value="">Chọn cấp bậc</option>
                                    <c:forEach var="level" items="${jobLevels}">
                                        <option value="${level.typeID}"
                                                ${level.typeID == job.jobLevelID ? 'selected' : ''}>
                                            ${level.typeName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="job-type">Loại việc làm</label>
                                <select id="job-type" name="job-type" disabled>
                                    <option value="">Chọn loại việc làm</option>
                                    <c:forEach var="type" items="${jobTypes}">
                                        <option value="${type.typeID}"
                                                ${type.typeID == job.jobTypeID ? 'selected' : ''}>
                                            ${type.typeName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="job-field">Lĩnh vực công việc</label>
                            <select id="job-field" name="job-field" disabled>
                                <option value="">Chọn lĩnh vực</option>
                                <c:forEach var="category" items="${categories}">
                                    <c:if test="${empty category.parentCategoryID}">
                                        <option value="${category.categoryID}"
                                                ${category.categoryID == job.categoryID ? 'selected' : ''}>
                                            ${category.categoryName}
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="work-location">Địa điểm làm việc</label>
                            <select id="work-location" name="work-location" disabled>
                                <option value="">Chọn địa điểm</option>
                                <c:forEach var="location" items="${locations}">
                                    <option value="${location.locationID}"
                                            ${location.locationID == job.locationID ? 'selected' : ''}>
                                        ${location.locationName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="job-skills">Kỹ năng yêu cầu </label>
                            <select multiple class="form-control" id="job-skills" name="skills_select" style="display: none;" disabled>
                                <c:forEach var="skill" items="${allSkills}">
                                    <option value="${skill.skillID}"
                                            <c:forEach var="selectedSkill" items="${skills}">
                                                <c:if test="${skill.skillID == selectedSkill.skillID}">
                                                    selected
                                                </c:if>
                                            </c:forEach>
                                            >${skill.skillName}</option>
                                </c:forEach>
                            </select>
                            <input type="hidden" id="selected-skill-ids" name="job-skills"> 
                            <div id="selected-skills" style="margin-top:10px; border:1px solid #ccc; padding:5px; min-height:30px; border-radius: 4px; background-color: #f5f5f5;">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="expiration-date">Ngày hết hạn</label>
                            <input type="date" id="expiration-date" name="expiration-date" 
                                   value="<c:out value="${expirationLocalDate}"/>"
                                   readonly>
                        </div>

                        <div class="form-group salary-input-container">
                            <label>Mức Lương (Triệu VND/Tháng)</label>
                            <div class="salary-input-group">
                                <c:set var="salaryParts" value="${fn:split(job.salaryRange, '-')}" />
                                <input type="number" id="salary-min" name="salary-min" 
                                       value="${fn:trim(salaryParts[0])}" 
                                       placeholder="Từ (Triệu)" readonly>
                                <span class="dash">-</span>
                                <c:set var="maxPart" value="${fn:trim(salaryParts[1])}" />
                                <c:set var="cleanedMax" value="${fn:replace(maxPart, ' triệu', '')}" />
                                <input type="number" id="salary-max" name="salary-max" 
                                       value="${cleanedMax}" 
                                       placeholder="Đến (Triệu)" readonly>
                                <span class="unit">Triệu VND</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="hiring-count">Số lượng tuyển dụng</label>
                            <div class="counter-input">
                                <button type="button" class="counter-btn minus" data-target="hiring-count" disabled>-</button>
                                <input type="number" id="hiring-count" name="hiring-count" 
                                       value="<c:out value="${job.hiringCount != null ? job.hiringCount : '1'}"/>" 
                                       readonly>
                                <button type="button" class="counter-btn plus" data-target="hiring-count" disabled>+</button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="age-requirement">Yêu cầu tuổi tối thiểu</label>
                            <div class="counter-input">
                                <button type="button" class="counter-btn minus" data-target="age-requirement" disabled>-</button>
                                <input type="number" id="age-requirement" name="age-requirement" 
                                       value="<c:out value="${job.ageRequirement != null ? job.ageRequirement : '18'}"/>" 
                                       readonly>
                                <button type="button" class="counter-btn plus" data-target="age-requirement" disabled>+</button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="min-qualification">Bằng cấp tối thiểu</label>
                            <select id="min-qualification" name="min-qualification" disabled>
                                <option value="">Chọn bằng cấp</option>
                                <c:forEach var="cert" items="${certificates}">
                                    <option value="${cert.typeID}"
                                            ${cert.typeID == job.certificatesID ? 'selected' : ''}>
                                        ${cert.typeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="job-description">Mô tả</label>
                            <div class="rich-text-editor">
                                <div class="editor-toolbar" style="display: none;">
                                </div>
                                <textarea id="job-description" name="job-description" rows="10" readonly><c:out value="${job.description}"/></textarea>
                                <div class="char-counter" style="display: none;"></div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="requirements">Yêu cầu công việc</label>
                            <div class="rich-text-editor">
                                <div class="editor-toolbar" style="display: none;">
                                </div>
                                <textarea id="requirements" name="requirements" rows="10" readonly><c:out value="${job.requirements}"/></textarea>
                                <div class="char-counter" style="display: none;"></div>
                            </div>
                        </div>

                    </div>

                    <div id="custom-toast" style="display: none;" role="alert"></div>
                    <div class="form-actions">
                        <button type="button" 
                                class="btn btn-secondary" 
                                onclick="window.location.href = '${pageContext.request.contextPath}/homerecuiter'">
                            Quay Lại
                        </button>
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
                                            const select = document.getElementById('job-skills');
                                            const selectedDiv = document.getElementById('selected-skills');
                                            const selectedIdsInput = document.getElementById('selected-skill-ids');
                                            const toast = document.getElementById('custom-toast');
                                            const toastMessage = document.getElementById('toast-message');
                                            const MAX_SKILLS = 3;
                                            function showToast(message) {
                                                toastMessage.textContent = message;
                                                toast.classList.add('show');
                                                setTimeout(() => {
                                                    toast.classList.remove('show');
                                                }, 3000);
                                            }
                                            function updateSelected() {
                                                selectedDiv.innerHTML = '';
                                                let selectedOptions = Array.from(select.selectedOptions);
                                                let selectedIDs = [];
                                                if (selectedOptions.length > MAX_SKILLS) {
                                                    showToast(`Bạn chỉ có thể chọn tối đa ${MAX_SKILLS} kỹ năng.`);
                                                    for (let i = MAX_SKILLS; i < selectedOptions.length; i++) {
                                                        selectedOptions[i].selected = false;
                                                    }
                                                    selectedOptions.length = MAX_SKILLS;
                                                }
                                                selectedOptions.forEach(opt => {
                                                    const span = document.createElement('span');
                                                    span.className = 'skill-tag';
                                                    span.textContent = opt.text;
                                                    span.setAttribute('data-skill-id', opt.value);
                                                    const closeBtn = document.createElement('i');
                                                    closeBtn.className = 'fas fa-times-circle close-tag';
                                                    closeBtn.onclick = (e) => {
                                                        e.preventDefault();
                                                        const optionToUnselect = select.querySelector(`option[value="${opt.value}"]`);
                                                        if (optionToUnselect) {
                                                            optionToUnselect.selected = false;
                                                        }
                                                        updateSelected();
                                                    };
                                                    span.appendChild(closeBtn);
                                                    selectedDiv.appendChild(span);
                                                    selectedIDs.push(opt.value);
                                                });
                                                selectedIdsInput.value = selectedIDs.join(',');
                                            }
                                            select.addEventListener('change', updateSelected);
                                            document.querySelectorAll('.counter-input .counter-btn').forEach(button => {
                                                button.addEventListener('click', (e) => {
                                                    e.preventDefault();
                                                    const targetId = button.getAttribute('data-target');
                                                    const input = document.getElementById(targetId);
                                                    if (!input)
                                                        return;
                                                    let value = parseInt(input.value) || 0;
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
                                            document.querySelectorAll('.rich-text-editor').forEach(editorDiv => {
                                                const textarea = editorDiv.querySelector('textarea');
                                                const toolbar = editorDiv.querySelector('.editor-toolbar');

                                                if (toolbar) {
                                                    toolbar.querySelectorAll('.toolbar-btn').forEach(button => {
                                                        button.addEventListener('click', (e) => {
                                                            e.preventDefault();
                                                            const command = button.getAttribute('data-command');
                                                            if (command && textarea) {
                                                                try {
                                                                    document.execCommand(command, false, null);
                                                                } catch (error) {
                                                                    console.warn(`Lệnh execCommand không được hỗ trợ hoặc không thành công cho: ${command}`);
                                                                }
                                                            }
                                                        });
                                                    });
                                                }
                                            });

                                            document.addEventListener('DOMContentLoaded', updateSelected);
        </script>
    </body>
</html>