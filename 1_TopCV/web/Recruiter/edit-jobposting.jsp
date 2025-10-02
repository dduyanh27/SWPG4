
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="32kb" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chỉnh Sửa Tin Tuyển Dụng - ${jobToEdit.jobTitle}</title> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Recruiter/styles.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Thêm CSS cho trang chỉnh sửa */
            .edit-job-container {
                max-width: 900px;
                margin: 20px auto;
                padding: 30px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            }
            .edit-job-container h1 {
                color: #1e40af;
                border-bottom: 2px solid #dbeafe;
                padding-bottom: 15px;
                margin-bottom: 25px;
            }
            .form-group {
                margin-bottom: 20px;
            }
            .form-group label {
                display: block;
                font-weight: bold;
                margin-bottom: 5px;
                color: #333;
            }
            .form-group input[type="text"],
            .form-group input[type="number"],
            .form-group input[type="date"],
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
                font-size: 14px;
            }
            .form-group textarea {
                resize: vertical;
                min-height: 150px;
            }
            .form-row {
                display: flex;
                gap: 20px;
            }
            .form-row .form-group {
                flex: 1;
                min-width: 0;
            }
            .form-actions {
                display: flex;
                justify-content: flex-end;
                gap: 15px;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px dashed #eee;
            }
            .btn-save, .btn-cancel {
                padding: 10px 25px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
                transition: background-color 0.3s;
            }
            .btn-save {
                background-color: #1e40af; 
                color: white;
            }
            .btn-save:hover {
                background-color: #1c3c98;
            }
            .btn-cancel {
                background-color: #fce7f3; 
                color: #a855f7; 
            }
            .btn-cancel:hover {
                background-color: #f7d6e4;
            }

         
            .salary-input-group {
                display: flex;
                gap: 10px;
                align-items: center;
            }
            .salary-input-group input {
                flex: 1;
            }
            html, body {
                min-height: 100%;
                margin: 0;
                padding: 0;
                overflow-x: hidden;
            }
            .index-page {
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }
            .main-content {
                flex-grow: 1; 
                min-height: calc(100vh - 60px); 
                padding-bottom: 50px; 
            }
        </style>
    </head>
    <body class="index-page">

        <c:if test="${jobToEdit == null}">
            <c:redirect url="${pageContext.request.contextPath}/Recruiter/job-management.jsp"/>
        </c:if>

        <%-- LOGIC TÁCH CHUỖI LƯƠNG ĐỂ ĐIỀN VÀO HAI Ô NHẬP LIỆU --%>
        <c:set var="fullRange" value="${jobToEdit.salaryRange}" />
        <c:set var="salaryMin" value="${fullRange eq 'Thỏa thuận' ? '' : fullRange}" />
        <c:set var="salaryMax" value="" />

        <c:if test="${fn:contains(fullRange, '-')}" >
            <c:set var="parts" value="${fn:split(fullRange, '-')}" />
            <c:if test="${fn:length(parts) == 2}">
                <c:set var="salaryMin" value="${fn:trim(parts[0])}" />
                <c:set var="salaryMax" value="${fn:trim(parts[1])}" />
            </c:if>
        </c:if>

        <nav class="navbar">
            <div class="nav-container">
                <div class="nav-left">
                    <div class="logo">
                        <i class="fas fa-briefcase"></i>
                        <span>RecruitPro</span>
                    </div>
                    <ul class="nav-menu">
                        <li><a href="${pageContext.request.contextPath}/Recruiter/index.jsp">Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/Recruiter/job-management.jsp" class="active">Việc Làm</a></li>
                        <li class="dropdown">
                            <a href="#">Ứng viên <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="#">Quản lý theo việc đăng tuyển</a>
                                <a href="${pageContext.request.contextPath}/Recruiter/candidate-folder.html">Quản lý theo thư mục và thẻ</a>
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="nav-right">
                    <div class="nav-buttons">
                        <div class="dropdown">
                            <button class="btn btn-orange">
                                Đăng Tuyển Dụng <i class="fas fa-chevron-down"></i>
                            </button>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/jobposting">Tạo tin tuyển dụng mới</a> 
                                <a href="${pageContext.request.contextPath}/Recruiter/job-management.jsp">Quản lý tin đã đăng</a>
                            </div>
                        </div>
                        <button class="btn btn-blue" onclick="window.location.href = '${pageContext.request.contextPath}/Recruiter/candidate-profile.html'">Tìm Ứng Viên</button>
                        <button class="btn btn-white">Mua</button>
                    </div>
                    <div class="nav-icons">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-bell"></i>
                        <div class="dropdown user-dropdown">
                            <div class="user-avatar">
                                <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNGNUY3RkEiLz4KPHN2ZyB4PSIxMCIgeT0iMTAiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSIjOUNBM0FGIi8+CjxwYXRoIGQ9Ik0xMiAxNEM5LjMzIDE0IDcgMTYuMzMgNyAxOVYyMUgxN1YxOUMxNyAxNi4zMyAxNC42NyAxNCAxMiAxNFoiIGZpbGw9IiM5Q0EzQUYiLz4KPC9zdmc+Cjwvc3ZnPgo=" alt="User Avatar" class="avatar-img">
                            </div>
                            <div class="dropdown-content user-menu">
                                <div class="user-header">
                                    <i class="fas fa-user-circle"></i>
                                    <div class="user-info">
                                        <div class="user-name">${userName}</div>
                                        <div class="user-role">Recruiter</div>
                                        <div class="user-id">ID: ${userID}</div>
                                    </div>
                                    <i class="fas fa-times close-menu"></i>
                                </div>
                                <div class="menu-footer">
                                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-item">
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

        <main class="main-content">
            <div class="edit-job-container">
                <h1>Chỉnh Sửa Tin Tuyển Dụng: ${jobToEdit.jobTitle}</h1>
                <c:if test="${not empty error}">
                    <div style="background-color: #fef2f2; border: 1px solid #fecaca; color: #dc2626; padding: 10px; margin-bottom: 20px; border-radius: 4px;">
                        <i class="fas fa-exclamation-triangle"></i> ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/edit-jobposting" method="POST">
                    <input type="hidden" name="jobID" value="${jobToEdit.jobID}">
                    <input type="hidden" name="status" value="${jobToEdit.status}">

                    <div class="form-row">
                        <div class="form-group">
                            <label for="jobTitle">Tên công việc <span style="color: red;">*</span></label>
                            <input type="text" id="jobTitle" name="jobTitle" value="${jobToEdit.jobTitle}" required>
                        </div>

                        <div class="form-group">
                            <label for="categoryID">Danh mục công việc <span style="color: red;">*</span></label>
                            <select id="categoryID" name="categoryID" required>
                                <option value="">Chọn Danh mục</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryID}" 
                                            <c:if test="${category.categoryID == jobToEdit.categoryID}">selected</c:if>>
                                        ${category.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="description">Mô tả công việc <span style="color: red;">*</span></label>
                        <textarea id="description" name="description" required><c:out value="${jobToEdit.description}"/></textarea>
                    </div>

                    <div class="form-group">
                        <label for="requirements">Yêu cầu công việc <span style="color: red;">*</span></label>
                        <textarea id="requirements" name="requirements" requi red><c:out value="${jobToEdit.requirements}"/></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="jobLevelID">Cấp bậc</label>
                            <select id="jobLevelID" name="jobLevelID">
                                <option value="">Chọn Cấp bậc</option>
                                <c:forEach var="level" items="${jobLevels}">
                                    <option value="${level.typeID}" 
                                            <c:if test="${level.typeID == jobToEdit.jobLevelID}">selected</c:if>>
                                        ${level.typeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="locationID">Địa điểm làm việc</label>
                            <select id="locationID" name="locationID">
                                <option value="">Chọn Địa điểm</option>
                                <c:forEach var="location" items="${locations}">
                                    <option value="${location.locationID}" 
                                            <c:if test="${location.locationID == jobToEdit.locationID}">selected</c:if>>
                                        ${location.locationName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="jobTypeID">Loại hình công việc</label>
                            <select id="jobTypeID" name="jobTypeID">
                                <option value="">Chọn Loại hình</option>
                                <c:forEach var="type" items="${jobTypes}">
                                    <option value="${type.typeID}" 
                                            <c:if test="${type.typeID == jobToEdit.jobTypeID}">selected</c:if>>
                                        ${type.typeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="salaryRange">Mức lương (Nhập giá trị hoặc để trống để chọn 'Thỏa thuận')</label>
                            <div class="salary-input-group">
                                <input type="text" id="salaryMin" name="salaryMin" 
                                       value="${salaryMin}" placeholder="Từ (Ví dụ: 10 Triệu)">
                                <span>-</span>
                                <input type="text" id="salaryMax" name="salaryMax" 
                                       value="${salaryMax}" placeholder="Đến (Ví dụ: 15 Triệu)">
                            </div>
                            <p style="font-size: 0.8em; color: #666; margin-top: 5px;">*Nếu chỉ điền 1 trong 2 trường, hãy đảm bảo ô còn lại trống.</p>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="hiringCount">Số lượng tuyển</label>
                            <input type="number" id="hiringCount" name="hiringCount" value="${jobToEdit.hiringCount}" min="1">
                        </div>                      
                        <div class="form-group">
                            <label for="ageRequirement">Yêu cầu tuổi </label>
                            <input type="number" id="ageRequirement" name="ageRequirement" value="${jobToEdit.ageRequirement}" min="0" max="100" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="certificatesID">Chứng chỉ</label>
                            <select id="certificatesID" name="certificatesID">
                                <option value="">Chọn Chứng chỉ</option>
                                <%-- Lặp qua List chứng chỉ: items="${certificates}" --%>
                                <c:forEach var="cert" items="${certificates}">
                                    <option value="${cert.typeID}" 
                                            <c:if test="${cert.typeID == jobToEdit.certificatesID}">selected</c:if>>
                                        ${cert.typeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                             <label for="expirationDate">Ngày hết hạn <span style="color: red;">*</span></label>
                            <input type="date" id="expirationDate" name="expirationDate"
                                   value="${jobToEdit.expirationDate != null ? jobToEdit.expirationDate.toLocalDate() : ''}"
                                   required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Kỹ năng yêu cầu (Chọn nhiều)</label>
                        <div style="height: 150px; overflow-y: scroll; border: 1px solid #ccc; padding: 10px; border-radius: 4px;">
                            <c:forEach var="skill" items="${skills}">
                                <div style="margin-bottom: 5px;">
                                    <input type="checkbox" id="skill_${skill.skillID}" name="job-skills" 
                                           value="${skill.skillID}" 
                                           <c:if test="${fn:contains(selectedSkillIDs, skill.skillID)}">checked</c:if> >
                                    <label for="skill_${skill.skillID}" style="display: inline; font-weight: normal;">${skill.skillName}</label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>


                    <div class="form-actions">
                        <button type="button" class="btn-cancel" onclick="window.location.href = '${pageContext.request.contextPath}/homerecuiter'">Hủy</button>
                        <button type="submit" class="btn-save">Lưu Thay Đổi</button>
                    </div>
                </form>
            </div>
        </main>
        <div class="feedback-button">
            <div class="feedback-content">
                <span>Feedback</span>
            </div>
        </div>
        <div class="chat-button">
            <i class="fas fa-comments"></i>
            <span>Trò chuyện</span>
        </div>

        <script src="${pageContext.request.contextPath}/Recruiter/script.js"></script>
    </body>
</html>