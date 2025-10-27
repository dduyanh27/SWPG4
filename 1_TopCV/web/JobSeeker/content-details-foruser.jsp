<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.MarketingContent, model.Campaign" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${content.title} - TopCV Blog</title>
    <link rel="stylesheet" href="../assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/css/fontawesome-all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-left: #061f3b;
            --bg-right: #0a67ff;
            --text-light: rgba(255,255,255,0.92);
            --text-light-muted: rgba(255,255,255,0.75);
            --text-dark: #21323b;
            --link: #a6c8ff;
            --link-hover: #d7e6ff;
            --blue: #0a67ff;
            --blue-dark: #0b5bdf;
        }
        
        body {
            background: linear-gradient(90deg, var(--bg-left) 0%, var(--bg-right) 100%);
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
        }
        
        /* Header Styles */
        .blog-header {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .logo {
            font-size: 1.8rem;
            font-weight: 700;
            color: #ffffff;
            text-decoration: none;
        }
        
        .back-btn {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 10px 20px;
            border-radius: 25px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
        
        .back-btn:hover {
            background: rgba(255, 255, 255, 0.2);
            color: #ffffff;
            transform: translateX(-5px);
        }
        
        /* Main Content */
        .blog-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        
        .blog-article {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }
        
        /* Article Header */
        .article-header {
            margin-bottom: 40px;
            text-align: center;
        }
        
        .platform-badge {
            background: linear-gradient(90deg, var(--blue-dark), var(--blue));
            color: white;
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
            margin-bottom: 20px;
        }
        
        .article-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 20px;
            line-height: 1.3;
        }
        
        .article-meta {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 30px;
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.95rem;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        /* Article Content */
        .article-content {
            margin-bottom: 40px;
        }
        
        .article-text {
            font-size: 1.1rem;
            line-height: 1.8;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 30px;
            white-space: pre-wrap;
        }
        
        .article-media {
            width: 100%;
            max-width: 100%;
            height: auto;
            border-radius: 15px;
            margin: 30px 0;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }
        
        /* Campaign Info */
        .campaign-info {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 15px;
            padding: 25px;
            margin: 30px 0;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .campaign-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .campaign-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .campaign-detail-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .campaign-detail-label {
            font-size: 0.85rem;
            color: rgba(255, 255, 255, 0.6);
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .campaign-detail-value {
            font-size: 1rem;
            color: rgba(255, 255, 255, 0.9);
            font-weight: 600;
        }
        
        /* Article Footer */
        .article-footer {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 30px;
            text-align: center;
        }
        
        .share-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .share-btn {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 12px 20px;
            border-radius: 25px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            font-size: 0.9rem;
        }
        
        .share-btn:hover {
            background: rgba(255, 255, 255, 0.2);
            color: #ffffff;
            transform: translateY(-2px);
        }
        
        .share-btn.facebook:hover { background: #1877f2; }
        .share-btn.twitter:hover { background: #1da1f2; }
        .share-btn.linkedin:hover { background: #0077b5; }
        
        /* Related Content */
        .related-content {
            margin-top: 60px;
        }
        
        .related-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .related-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .related-card {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }
        
        .related-card:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-5px);
        }
        
        .related-card h4 {
            color: #ffffff;
            font-size: 1.1rem;
            margin-bottom: 10px;
        }
        
        .related-card p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.9rem;
            margin-bottom: 15px;
        }
        
        .related-card a {
            color: var(--link);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
        }
        
        .related-card a:hover {
            color: var(--link-hover);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .blog-container {
                padding: 20px 15px;
            }
            
            .blog-article {
                padding: 25px;
            }
            
            .article-title {
                font-size: 2rem;
            }
            
            .article-meta {
                flex-direction: column;
                gap: 15px;
            }
            
            .campaign-details {
                grid-template-columns: 1fr;
            }
            
            .share-buttons {
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="blog-header">
        <div class="header-content">
            <a href="${pageContext.request.contextPath}/JobSeeker/index.jsp" class="logo">TopCV</a>
            <a href="${pageContext.request.contextPath}/JobSeeker/index.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i>
                Quay lại trang chủ
            </a>
        </div>
    </header>

    <!-- Main Content -->
    <main class="blog-container">
        <c:choose>
            <c:when test="${not empty content}">
                <article class="blog-article">
                    <!-- Article Header -->
                    <header class="article-header">
                        <div class="platform-badge">${content.platform}</div>
                        <h1 class="article-title">${content.title}</h1>
                        <div class="article-meta">
                            <div class="meta-item">
                                <i class="fas fa-calendar-alt"></i>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty content.postDate}">
                                            <fmt:formatDate value="${content.postDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise>Chưa đặt ngày</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-user"></i>
                                <span>${content.creatorName}</span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-eye"></i>
                                <span>Đã xuất bản</span>
                            </div>
                        </div>
                    </header>

                    <!-- Article Content -->
                    <div class="article-content">
                        <c:if test="${not empty content.contentText}">
                            <div class="article-text">${content.contentText}</div>
                        </c:if>

                        <c:if test="${not empty content.mediaURL}">
                            <img src="${content.mediaURL}" alt="Article media" class="article-media" 
                                 onerror="this.style.display='none';">
                        </c:if>
                    </div>

                    <!-- Campaign Information -->
                    <c:if test="${not empty campaign}">
                        <div class="campaign-info">
                            <h3 class="campaign-title">
                                <i class="fas fa-bullhorn"></i>
                                Thông tin chiến dịch
                            </h3>
                            <div class="campaign-details">
                                <div class="campaign-detail-item">
                                    <span class="campaign-detail-label">Tên chiến dịch</span>
                                    <span class="campaign-detail-value">${campaign.campaignName}</span>
                                </div>
                                <div class="campaign-detail-item">
                                    <span class="campaign-detail-label">Nền tảng</span>
                                    <span class="campaign-detail-value">${campaign.platform}</span>
                                </div>
                                <div class="campaign-detail-item">
                                    <span class="campaign-detail-label">Loại đối tượng</span>
                                    <span class="campaign-detail-value">${campaign.targetType}</span>
                                </div>
                                <div class="campaign-detail-item">
                                    <span class="campaign-detail-label">Ngân sách</span>
                                    <span class="campaign-detail-value">
                                        <fmt:formatNumber value="${campaign.budget}" type="currency" currencyCode="VND"/>
                                    </span>
                                </div>
                            </div>
                            <c:if test="${not empty campaign.description}">
                                <div style="margin-top: 15px;">
                                    <span class="campaign-detail-label">Mô tả</span>
                                    <p style="margin-top: 5px; color: rgba(255, 255, 255, 0.8); line-height: 1.6;">${campaign.description}</p>
                                </div>
                            </c:if>
                        </div>
                    </c:if>

                    <!-- Article Footer -->
                    <footer class="article-footer">
                        <div class="share-buttons">
                            <a href="#" class="share-btn facebook" onclick="shareOnFacebook()">
                                <i class="fab fa-facebook-f"></i>
                                Facebook
                            </a>
                            <a href="#" class="share-btn twitter" onclick="shareOnTwitter()">
                                <i class="fab fa-twitter"></i>
                                Twitter
                            </a>
                            <a href="#" class="share-btn linkedin" onclick="shareOnLinkedIn()">
                                <i class="fab fa-linkedin-in"></i>
                                LinkedIn
                            </a>
                        </div>
                        <p style="color: rgba(255, 255, 255, 0.6); font-size: 0.9rem;">
                            Cảm ơn bạn đã đọc bài viết này!
                        </p>
                    </footer>
                </article>

                <!-- Related Content -->
                <section class="related-content">
                    <h2 class="related-title">Bài viết liên quan</h2>
                    <div class="related-grid">
                        <div class="related-card">
                            <h4>🎯 Tìm việc làm phù hợp</h4>
                            <p>Khám phá các cơ hội việc làm tốt nhất dành cho bạn</p>
                            <a href="${pageContext.request.contextPath}/job-list">Xem ngay →</a>
                        </div>
                        <div class="related-card">
                            <h4>📝 Tạo CV chuyên nghiệp</h4>
                            <p>Hướng dẫn tạo CV ấn tượng để thu hút nhà tuyển dụng</p>
                            <a href="${pageContext.request.contextPath}/JobSeeker/profile.jsp">Tạo CV →</a>
                        </div>
                        <div class="related-card">
                            <h4>💼 Kỹ năng phỏng vấn</h4>
                            <p>Bí quyết để có buổi phỏng vấn thành công</p>
                            <a href="#">Đọc thêm →</a>
                        </div>
                    </div>
                </section>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 60px 20px;">
                    <div style="font-size: 4rem; margin-bottom: 20px;">📄</div>
                    <h2 style="color: #ffffff; margin-bottom: 10px;">Không tìm thấy bài viết</h2>
                    <p style="color: rgba(255, 255, 255, 0.7); margin-bottom: 30px;">Bài viết bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                    <a href="${pageContext.request.contextPath}/JobSeeker/index.jsp" class="back-btn">
                        <i class="fas fa-home"></i>
                        Về trang chủ
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <script>
        // Share functions
        function shareOnFacebook() {
            const url = encodeURIComponent(window.location.href);
            const title = encodeURIComponent(document.title);
            window.open(`https://www.facebook.com/sharer/sharer.php?u=${url}`, '_blank', 'width=600,height=400');
        }
        
        function shareOnTwitter() {
            const url = encodeURIComponent(window.location.href);
            const title = encodeURIComponent(document.title);
            window.open(`https://twitter.com/intent/tweet?url=${url}&text=${title}`, '_blank', 'width=600,height=400');
        }
        
        function shareOnLinkedIn() {
            const url = encodeURIComponent(window.location.href);
            const title = encodeURIComponent(document.title);
            window.open(`https://www.linkedin.com/sharing/share-offsite/?url=${url}`, '_blank', 'width=600,height=400');
        }
        
        // Smooth scroll for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    </script>
</body>
</html>
