<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="dal.LocationDAO"%>
<%@page import="model.Location"%>
<%@page import="java.util.List"%>
<%
    // IMPORTANT: Force redirect if accessed directly
    if (request.getAttribute("featuredGoldJobs") == null) {
        response.sendRedirect(request.getContextPath() + "/JobSeeker/index");
        return;
    }
    
    // Check if user is logged in
    HttpSession userSession = request.getSession(false);
    boolean isLoggedIn = (userSession != null && userSession.getAttribute("user") != null);
    String userType = isLoggedIn ? (String) userSession.getAttribute("userType") : null;
    boolean isJobSeeker = "jobseeker".equals(userType);
    
    LocationDAO ldao = new LocationDAO();
    List<Location> locations = ldao.getAllLocations();
    request.setAttribute("locations", locations);
    
    // NOTE: Marketing content is already loaded by IndexServlet
    // No need to reload here to avoid duplication
    
    // Set login status for use in JSP
    request.setAttribute("isLoggedIn", isLoggedIn);
    request.setAttribute("isJobSeeker", isJobSeeker);
%>
<!doctype html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
         <title>Job board HTML-5 Template </title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="manifest" href="../site.webmanifest">
		<link rel="shortcut icon" type="image/x-icon" href="../assets/img/favicon.ico">

		<!-- CSS here -->
            <link rel="stylesheet" href="../assets/css/bootstrap.min.css">
            <link rel="stylesheet" href="../assets/css/owl.carousel.min.css">
            <link rel="stylesheet" href="../assets/css/flaticon.css">
            <link rel="stylesheet" href="../assets/css/price_rangs.css">
            <link rel="stylesheet" href="../assets/css/slicknav.css">
            <link rel="stylesheet" href="../assets/css/animate.min.css">
            <link rel="stylesheet" href="../assets/css/magnific-popup.css">
            <link rel="stylesheet" href="../assets/css/fontawesome-all.min.css">
            <link rel="stylesheet" href="../assets/css/themify-icons.css">
            <link rel="stylesheet" href="../assets/css/slick.css">
            <link rel="stylesheet" href="../assets/css/nice-select.css">
            <link rel="stylesheet" href="../assets/css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                /* Chữ trong dropdown tùy chỉnh màu đen */
                .nice-select .current,
                .nice-select .list li {
                    color: black;
                }

                :root{
                    --bg-left:  #061f3b;
                    --bg-right: #0a67ff;
                    --text-light: rgba(255,255,255,0.92);
                    --text-light-muted: rgba(255,255,255,0.75);
                    --text-dark: #21323b;
                    --link: #a6c8ff;
                    --link-hover: #d7e6ff;
                    --blue: #0a67ff;
                    --blue-dark: #0b5bdf;
                }
                body{
                    background: linear-gradient(90deg, var(--bg-left) 0%, var(--bg-right) 100%) !important;
                    color: #ffffff;
                }
                h1,h2,h3,h4,h5,h6{color:#ffffff}
                p, li, span, small{color:#ffffff}
                a{color:var(--link)}
                a:hover{color:var(--link-hover)}
                .our-services, .featured-job-area, .home-blog-area, .support-company-area, .footer-area{ color:#ffffff; }
                .our-services h1, .our-services h2, .our-services h3, .our-services h4, .our-services h5, .our-services h6,
                .featured-job-area h1, .featured-job-area h2, .featured-job-area h3, .featured-job-area h4, .featured-job-area h5, .featured-job-area h6,
                .home-blog-area h1, .home-blog-area h2, .home-blog-area h3, .home-blog-area h4, .home-blog-area h5, .home-blog-area h6,
                .support-company-area h1, .support-company-area h2, .support-company-area h3, .support-company-area h4, .support-company-area h5, .support-company-area h6,
                .footer-area h1, .footer-area h2, .footer-area h3, .footer-area h4, .footer-area h5, .footer-area h6{ color:#ffffff; }
                .our-services a, .featured-job-area a, .home-blog-area a, .support-company-area a, .footer-area a{ color: var(--link); }
                .our-services a:hover, .featured-job-area a:hover, .home-blog-area a:hover, .support-company-area a:hover, .footer-area a:hover{ color: var(--link-hover); }
                .btn,
                .head-btn1,
                .head-btn2,
                .post-btn,
                .items-link a,
                .search-box .search-form a,
                .newsletter-submit,
                .button-contactForm,
                a.button,
                a.btn{
                    background: linear-gradient(90deg, var(--blue-dark), var(--blue)) !important;
                    color:#ffffff !important;
                    border-color: var(--blue) !important;
                }
                .btn:hover,
                .head-btn1:hover,
                .head-btn2:hover,
                .post-btn:hover,
                .items-link a:hover,
                .search-box .search-form a:hover,
                .newsletter-submit:hover,
                .button-contactForm:hover,
                a.button:hover,
                a.btn:hover{
                    background: linear-gradient(90deg, var(--blue), var(--blue-dark)) !important;
                    color:#ffffff !important;
                    border-color: var(--blue-dark) !important;
                }
                .header-btn .head-btn1,
                .header-btn .head-btn2{
                    background: linear-gradient(90deg, var(--blue-dark), var(--blue)) !important;
                    border-color: var(--blue) !important;
                    color:#ffffff !important;
                }
                .header-btn .head-btn1:hover,
                .header-btn .head-btn1:focus,
                .header-btn .head-btn1:active,
                .header-btn .head-btn2:hover,
                .header-btn .head-btn2:focus,
                .header-btn .head-btn2:active{
                    background: linear-gradient(90deg, var(--blue), var(--blue-dark)) !important;
                    border-color: var(--blue-dark) !important;
                    color:#ffffff !important;
                }
                .header-btn .head-btn1::before,
                .header-btn .head-btn1::after,
                .header-btn .head-btn2::before,
                .header-btn .head-btn2::after{
                    background: transparent !important;
                    box-shadow: none !important;
                }
                .border-btn2{
                    color: var(--blue) !important;
                    border: 2px solid var(--blue) !important;
                    background: transparent !important;
                }
                .border-btn2:hover{
                    background: var(--blue) !important;
                    color:#ffffff !important;
                    border-color: var(--blue-dark) !important;
                }
                /* New topbar styles to mirror index */
                .header{ position: relative; z-index: 1200; }
                .header-content{ display:flex; align-items:center; justify-content:space-between; gap:24px; padding:14px 28px; }
                .logo-section .logo h1{ margin:0; font-weight:700; color:#ffffff; }
                .logo-section .tagline{ display:block; font-size:12px; color:#e8f0ff; opacity:0.9; }
                .search-section{ flex:1; display:flex; justify-content:center; }
                .search-bar{ width:100%; max-width:820px; background:#ffffff; border-radius:28px; padding:10px 12px; display:flex; align-items:center; gap:14px; box-shadow: 0 6px 18px rgba(2,10,30,0.18); border:1px solid rgba(17,24,39,0.06); }
                .search-bar input{ flex:1; border:none; background:transparent; outline:none; font-size:15px; color:#0f172a; padding:8px 10px; }
                .search-bar input::placeholder{ color:#475569; }
                .location-selector{ display:flex; align-items:center; gap:8px; color:#1f2937; background:rgba(2,10,30,0.04); padding:6px 10px; border-radius:14px; }
                .search-btn{ border:none; background: linear-gradient(90deg, #0b5bdf, #0a67ff); color:#fff; width:40px; height:40px; border-radius:50%; display:flex; align-items:center; justify-content:center; cursor:pointer; box-shadow: 0 6px 16px rgba(10,103,255,0.35); }
                .search-btn:hover{ filter:brightness(1.05); box-shadow: 0 8px 20px rgba(10,103,255,0.45); }
                .header-right{ display:flex; align-items:center; gap:18px; flex-shrink:0; }
                .menu-toggle{ display:flex; align-items:center; gap:8px; color:#e8f0ff; cursor:pointer; white-space:nowrap; font-size:14px; }
                .recruiter-btn{ background:transparent; color:#e8f0ff; border:1px solid rgba(255,255,255,0.6); padding:8px 14px; border-radius:10px; cursor:pointer; backdrop-filter: blur(2px); text-decoration:none; white-space:nowrap; font-size:14px; }
                .recruiter-btn:hover{ background:rgba(255,255,255,0.1); color:#e8f0ff; }
                .user-actions{ display:flex; align-items:center; gap:12px; }
                .user-actions > a, .user-actions > div{ width:40px; height:40px; border-radius:50%; display:flex; align-items:center; justify-content:center; color:#e8f0ff; border:1px solid rgba(255,255,255,0.35); transition: all 0.3s ease; text-decoration:none; }
                .user-actions > a:hover, .user-actions > div:hover{ background:rgba(255,255,255,0.1); border-color:rgba(255,255,255,0.6); }
                .user-actions > a.head-btn2{ width:auto; border-radius:8px; padding:10px 20px; white-space:nowrap; font-size:14px; }
                .logout-icon:hover{ background:rgba(255,107,107,0.2) !important; border-color:rgba(255,107,107,0.6) !important; color:#ff6b6b !important; }
                /* Mega menu */
                .mega-menu{ position:absolute; left:50%; transform:translateX(-50%); top:72px; width:92%; max-width:1100px; background:#ffffff; color:#0f172a; border-radius:16px; box-shadow:0 24px 60px rgba(2,10,30,0.28); padding:24px; display:none; z-index:1300; border:1px solid rgba(17,24,39,0.08); overflow:hidden; }
                .mega-menu::before{ content:""; position:absolute; left:0; top:0; right:0; height:6px; background:linear-gradient(90deg, #0b5bdf, #0a67ff); }
                .mega-menu.open{ display:block; }
                .mega-grid{ display:grid; grid-template-columns: repeat(3, 1fr); gap:28px; }
                .mega-col{ padding:4px 12px; }
                .mega-col + .mega-col{ border-left:1px solid rgba(17,24,39,0.06); }
                .mega-col h4{ margin:0 0 12px 0; color:#0b5bdf; font-weight:700; letter-spacing:.2px; }
                .mega-col a{ display:block; padding:10px 12px; margin:4px 0; color:#0f172a; border-radius:10px; transition: all .2s ease; border:1px solid transparent; }
                .mega-col a:hover{ color:#0b5bdf; background:rgba(10,103,255,0.06); border-color: rgba(10,103,255,0.15); }
                .single-services .services-ion span{ color:#2f80ed !important; }
                .single-services:hover .services-ion span{ color:#2f80ed !important; }
                #scrollUp,
                .scrollUp,
                .back-to-top,
                a.back-to-top{
                    background: linear-gradient(90deg, var(--blue-dark), var(--blue)) !important;
                    color:#ffffff !important;
                    border: none !important;
                    box-shadow: 0 6px 16px rgba(2,10,30,0.45) !important;
                }
                #scrollUp:hover,
                .scrollUp:hover,
                .back-to-top:hover,
                a.back-to-top:hover{
                    background: linear-gradient(90deg, var(--blue), var(--blue-dark)) !important;
                    color:#ffffff !important;
                }
                .header-area .main-menu ul li a,
                #navigation > li > a,
                .header-btn a,
                .section-tittle span,
                .section-tittle2 span,
                .hero__caption h1,
                .single-services .services-cap h5 a,
                .single-services .services-cap span,
                .single-job-items .job-tittle a h4,
                .single-job-items .job-tittle ul li,
                .single-job-items .items-link a,
                .cv-caption p,
                .testimonial-caption .testimonial-top-cap p,
                .testimonial-founder span,
                .testimonial-founder p,
                .support-caption p,
                .footer-area,
                .footer-area p,
                .footer-area a,
                .footer-area h4{ color:#ffffff !important; }
                
                /* Marketing Content Styles */
                .marketing-content-area {
                    background: rgba(255, 255, 255, 0.05);
                    backdrop-filter: blur(10px);
                    border-radius: 20px;
                    padding: 40px 0;
                    margin: 60px 0;
                    border: 1px solid rgba(255, 255, 255, 0.1);
                }
                
                .marketing-content-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                    gap: 30px;
                    margin-top: 40px;
                }
                
                .marketing-content-card {
                    background: rgba(255, 255, 255, 0.08);
                    border-radius: 16px;
                    padding: 25px;
                    border: 1px solid rgba(255, 255, 255, 0.15);
                    transition: all 0.3s ease;
                    backdrop-filter: blur(5px);
                }
                
                .marketing-content-card:hover {
                    transform: translateY(-5px);
                    background: rgba(255, 255, 255, 0.12);
                    border-color: rgba(255, 255, 255, 0.25);
                    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
                }
                
                .marketing-content-header {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    margin-bottom: 20px;
                }
                
                .marketing-platform {
                    background: linear-gradient(90deg, var(--blue-dark), var(--blue));
                    color: white;
                    padding: 6px 12px;
                    border-radius: 20px;
                    font-size: 0.8rem;
                    font-weight: 600;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }
                
                .marketing-date {
                    color: rgba(255, 255, 255, 0.7);
                    font-size: 0.9rem;
                }
                
                .marketing-title {
                    font-size: 1.3rem;
                    font-weight: 700;
                    color: #ffffff;
                    margin-bottom: 15px;
                    line-height: 1.4;
                }
                
                .marketing-text {
                    color: rgba(255, 255, 255, 0.85);
                    line-height: 1.6;
                    margin-bottom: 20px;
                    display: -webkit-box;
                    -webkit-line-clamp: 3;
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                }
                
                .marketing-media {
                    width: 100%;
                    height: 200px;
                    object-fit: cover;
                    border-radius: 12px;
                    margin-bottom: 15px;
                }
                
                .marketing-read-more {
                    color: var(--link);
                    text-decoration: none;
                    font-weight: 600;
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    transition: all 0.2s ease;
                }
                
                .marketing-read-more:hover {
                    color: var(--link-hover);
                    transform: translateX(5px);
                }
                
                .no-content-message {
                    text-align: center;
                    color: rgba(255, 255, 255, 0.6);
                    font-style: italic;
                    padding: 40px 20px;
                }
                
                /* Notification Dropdown Styles */
                .notification-icon {
                    position: relative;
                    cursor: pointer;
                }
                
                .notification-dropdown {
                    position: absolute;
                    top: calc(100% + 15px);
                    right: 0;
                    width: 420px;
                    background: #ffffff;
                    border-radius: 16px;
                    box-shadow: 0 12px 48px rgba(0, 0, 0, 0.25);
                    display: none;
                    z-index: 2000;
                    overflow: hidden;
                    border: 1px solid rgba(0, 0, 0, 0.06);
                }
                
                .notification-dropdown.show {
                    display: block;
                    animation: slideDown 0.3s ease;
                }
                
                @keyframes slideDown {
                    from {
                        opacity: 0;
                        transform: translateY(-10px);
                    }
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
                
                .notification-header {
                    padding: 20px 24px;
                    background: linear-gradient(135deg, #0a67ff 0%, #0b5bdf 100%);
                    color: #ffffff;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                }
                
                .notification-header h3 {
                    margin: 0;
                    font-size: 18px;
                    font-weight: 700;
                    color: #ffffff !important;
                }
                
                .notification-tabs {
                    display: flex;
                    gap: 4px;
                    padding: 12px 16px;
                    background: #f8fafc;
                    border-bottom: 1px solid #e2e8f0;
                }
                
                .notification-tab {
                    flex: 1;
                    padding: 8px 16px;
                    border: none;
                    background: transparent;
                    color: #64748b;
                    font-size: 14px;
                    font-weight: 600;
                    border-radius: 8px;
                    cursor: pointer;
                    transition: all 0.2s ease;
                }
                
                .notification-tab.active {
                    background: #ffffff;
                    color: #0a67ff;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                }
                
                .notification-tab:hover:not(.active) {
                    background: rgba(10, 103, 255, 0.05);
                    color: #0a67ff;
                }
                
                .notification-list {
                    max-height: 420px;
                    overflow-y: auto;
                }
                
                .notification-list::-webkit-scrollbar {
                    width: 6px;
                }
                
                .notification-list::-webkit-scrollbar-track {
                    background: #f1f5f9;
                }
                
                .notification-list::-webkit-scrollbar-thumb {
                    background: #cbd5e1;
                    border-radius: 10px;
                }
                
                .notification-list::-webkit-scrollbar-thumb:hover {
                    background: #94a3b8;
                }
                
                .notification-item {
                    padding: 16px 24px;
                    border-bottom: 1px solid #f1f5f9;
                    transition: background 0.2s ease;
                    cursor: pointer;
                    display: flex;
                    gap: 12px;
                }
                
                .notification-item:hover {
                    background: #f8fafc;
                }
                
                .notification-item.unread {
                    background: #eff6ff;
                }
                
                .notification-item.unread:hover {
                    background: #dbeafe;
                }
                
                .notification-icon-wrapper {
                    width: 48px;
                    height: 48px;
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    flex-shrink: 0;
                    font-size: 20px;
                }
                
                .notification-icon-wrapper.application {
                    background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
                    color: #ffffff;
                }
                
                .notification-icon-wrapper.profile {
                    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                    color: #ffffff;
                }
                
                .notification-icon-wrapper.system {
                    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                    color: #ffffff;
                }
                
                .notification-content {
                    flex: 1;
                    min-width: 0;
                }
                
                .notification-title {
                    font-size: 14px;
                    font-weight: 600;
                    color: #1e293b;
                    margin: 0 0 4px 0;
                    line-height: 1.4;
                }
                
                .notification-message {
                    font-size: 13px;
                    color: #64748b;
                    margin: 0 0 6px 0;
                    line-height: 1.5;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                }
                
                .notification-time {
                    font-size: 12px;
                    color: #94a3b8;
                }
                
                .notification-dot {
                    width: 8px;
                    height: 8px;
                    background: #3b82f6;
                    border-radius: 50%;
                    flex-shrink: 0;
                    margin-top: 6px;
                }
                
                .notification-empty {
                    padding: 60px 24px;
                    text-align: center;
                    color: #94a3b8;
                }
                
                .notification-empty-icon {
                    width: 80px;
                    height: 80px;
                    margin: 0 auto 16px;
                    background: #f1f5f9;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 32px;
                    color: #cbd5e1;
                }
                
                .notification-empty-text {
                    font-size: 15px;
                    color: #64748b;
                    margin: 0;
                }
                
                .notification-footer {
                    padding: 12px 24px;
                    text-align: center;
                    border-top: 1px solid #e2e8f0;
                    background: #f8fafc;
                }
                
                .notification-view-all {
                    color: #0a67ff;
                    text-decoration: none;
                    font-size: 14px;
                    font-weight: 600;
                    transition: color 0.2s ease;
                }
                
                .notification-view-all:hover {
                    color: #0b5bdf;
                }
                
                .notification-badge {
                    position: absolute;
                    top: -2px;
                    right: -2px;
                    background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
                    color: #ffffff;
                    font-size: 10px;
                    font-weight: 700;
                    min-width: 18px;
                    height: 18px;
                    border-radius: 9px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 0 4px;
                    border: 2px solid #0a67ff;
                    box-shadow: 0 2px 8px rgba(239, 68, 68, 0.4);
                }
                
                /* ============================================
                   FEATURED GOLD JOBS STYLES - GÓI VÀNG
                   ============================================ */
                
                /* Premium Gold Badge */
                .premium-gold-badge {
                    position: absolute;
                    top: 15px;
                    right: 15px;
                    background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
                    color: #1a1a1a;
                    padding: 6px 14px;
                    border-radius: 20px;
                    font-size: 11px;
                    font-weight: 700;
                    letter-spacing: 0.5px;
                    text-transform: uppercase;
                    box-shadow: 0 4px 12px rgba(255, 215, 0, 0.4);
                    display: flex;
                    align-items: center;
                    gap: 5px;
                    z-index: 10;
                    animation: pulse-gold 2s infinite;
                }
                
                @keyframes pulse-gold {
                    0%, 100% { transform: scale(1); box-shadow: 0 4px 12px rgba(255, 215, 0, 0.4); }
                    50% { transform: scale(1.05); box-shadow: 0 6px 20px rgba(255, 215, 0, 0.6); }
                }
                
                .premium-gold-badge i {
                    font-size: 14px;
                }
                
                /* Featured Job Card - Enhanced - Simplified for Template Match */
                .jobs-grid-3col {
                    display: grid;
                    grid-template-columns: repeat(3, 1fr);
                    gap: 24px;
                    margin-bottom: 40px;
                }
                
                .job-card-gold {
                    background: #ffffff;
                    border-radius: 12px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                    transition: all 0.3s ease;
                    border: 1px solid #e2e8f0;
                }
                
                .job-card-gold:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 8px 20px rgba(10, 103, 255, 0.15);
                    border-color: #0a67ff;
                }
                
                .job-card-banner {
                    height: 130px;
                    background: #ffffff;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border-bottom: 2px solid #e2e8f0;
                }
                
                .job-card-banner img {
                    max-width: 80%;
                    max-height: 80%;
                    object-fit: contain;
                }
                
                .banner-logo-placeholder {
                    width: 80px;
                    height: 80px;
                    background: linear-gradient(135deg, #0a67ff 0%, #0052cc 100%);
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 32px;
                    font-weight: 700;
                    color: #ffffff;
                }
                
                .job-card-content {
                    padding: 20px;
                }
                
                .job-card-title {
                    font-size: 16px;
                    font-weight: 600;
                    color: #1e293b;
                    margin: 0 0 8px 0;
                    line-height: 1.4;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                    transition: color 0.2s ease;
                }
                
                .job-card-title:hover {
                    color: #0a67ff;
                }
                
                .job-card-company {
                    color: #64748b;
                    font-size: 14px;
                    margin: 0 0 16px 0;
                }
                
                .job-card-info {
                    margin-bottom: 16px;
                }
                
                .job-info-item {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    color: #64748b;
                    font-size: 13px;
                    margin-bottom: 8px;
                }
                
                .job-info-item i {
                    color: #0a67ff;
                    width: 16px;
                    font-size: 13px;
                }
                
                .view-job-btn {
                    display: block;
                    width: 100%;
                    padding: 11px 20px;
                    background: #0a67ff;
                    color: #ffffff;
                    text-align: center;
                    border-radius: 8px;
                    font-weight: 600;
                    font-size: 14px;
                    text-decoration: none;
                    transition: all 0.2s ease;
                    border: none;
                }
                
                .view-job-btn:hover {
                    background: #0052cc;
                    transform: translateY(-2px);
                    box-shadow: 0 4px 12px rgba(10, 103, 255, 0.3);
                    color: #ffffff;
                }
                
                .job-card-link {
                    text-decoration: none;
                }
                
                /* Responsive */
                @media (max-width: 992px) {
                    .jobs-grid-3col {
                        grid-template-columns: repeat(2, 1fr);
                    }
                }
                
                @media (max-width: 576px) {
                    .jobs-grid-3col {
                        grid-template-columns: 1fr;
                    }
                }
                
                .gold-job {
                    background: rgba(255, 255, 255, 0.08);
                    backdrop-filter: blur(5px);
                    border-left: 4px solid #FFD700;
                    transition: all 0.3s ease;
                }
                
                .gold-job:hover {
                    transform: translateX(5px);
                    background: rgba(255, 255, 255, 0.12);
                    box-shadow: 0 8px 24px rgba(255, 215, 0, 0.15);
                }
                
                /* Hot Badge Animation */
                .hot-badge {
                    background: linear-gradient(135deg, #ff4444 0%, #cc0000 100%);
                    color: #ffffff;
                    padding: 4px 10px;
                    border-radius: 12px;
                    font-size: 11px;
                    font-weight: 700;
                    text-transform: uppercase;
                    display: inline-flex;
                    align-items: center;
                    gap: 4px;
                    animation: hot-pulse 1.5s infinite;
                }
                
                @keyframes hot-pulse {
                    0%, 100% { box-shadow: 0 0 10px rgba(255, 68, 68, 0.5); }
                    50% { box-shadow: 0 0 20px rgba(255, 68, 68, 0.8); }
                }
                
                /* Company Verified Badge */
                .verified-badge {
                    display: inline-flex;
                    align-items: center;
                    gap: 4px;
                    color: #4CAF50;
                    font-size: 13px;
                    font-weight: 600;
                }
                
                .verified-badge i {
                    font-size: 16px;
                }
                
                /* Empty State */
                .featured-gold-empty {
                    text-align: center;
                    padding: 60px 20px;
                    background: rgba(255, 255, 255, 0.05);
                    border-radius: 16px;
                    border: 2px dashed rgba(255, 255, 255, 0.2);
                }
                
                .featured-gold-empty i {
                    font-size: 4rem;
                    color: rgba(255, 255, 255, 0.3);
                    margin-bottom: 20px;
                }
                
                .featured-gold-empty p {
                    color: rgba(255, 255, 255, 0.6);
                    font-size: 16px;
                    font-style: italic;
                }
                
                /* Responsive */
                @media (max-width: 768px) {
                    .featured-job-gold {
                        padding: 20px;
                    }
                    
                    .featured-job-gold .company-img {
                        width: 70px;
                        height: 70px;
                    }
                    
                    .featured-job-gold .job-tittle h4 {
                        font-size: 18px;
                    }
                    
                    .premium-gold-badge {
                        top: 10px;
                        right: 10px;
                        padding: 5px 10px;
                        font-size: 10px;
                    }
                }
            </style>
   </head>

   <body>
    <!-- Preloader Start -->
    <div id="preloader-active">
        <div class="preloader d-flex align-items-center justify-content-center">
            <div class="preloader-inner position-relative">
                <div class="preloader-circle"></div>
                <div class="preloader-img pere-text">
                    <img src="../assets/img/logo/logo.png" alt="">
                </div>
            </div>
        </div>
    </div>
    <!-- Preloader Start -->
    <header class="header">
        <div class="header-content">
            <div class="logo-section">
                <div class="logo">
                    <h1>Top</h1>
                    <span class="tagline">Empower growth</span>
                </div>
            </div>
            <div class="search-section">
                <form action="${pageContext.request.contextPath}/job-list" method="get" class="search-bar">
                    <input type="text" name="keyword" placeholder="Tìm kiếm việc làm, công ty">
                    <button type="submit" class="search-btn">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
            </div>
            <div class="header-right">
                <div class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                    <span>Tất cả danh mục</span>
                </div>
                <a class="recruiter-btn" href="../Recruiter/recruiter-login.jsp">Nhà tuyển dụng</a>
                
                <c:choose>
                    <c:when test="${isLoggedIn && isJobSeeker}">
                        <!-- User is logged in as JobSeeker -->
                        <div class="user-actions">
                            <a class="profile-icon" href="${pageContext.request.contextPath}/jobseekerprofile" title="Tài khoản">
                                <i class="fas fa-user"></i>
                            </a>
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
                            <a class="logout-icon" href="${pageContext.request.contextPath}/LogoutServlet" title="Đăng xuất">
                                <i class="fas fa-sign-out-alt"></i>
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Guest user - show login button only -->
                        <div class="user-actions">
                            <a class="head-btn2" href="${pageContext.request.contextPath}/JobSeeker/jobseeker-login.jsp">
                                <i class="fas fa-sign-in-alt"></i> Đăng nhập
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>
        <!-- Mega menu panel -->
        <div class="mega-menu" id="megaMenu">
            <div class="mega-grid">
                <div class="mega-col">
                    <h4>Việc làm</h4>
                    <a href="#">Việc làm mới nhất</a>
                    <a href="${pageContext.request.contextPath}/job-list">Tìm việc làm</a>
                    <a href="#">Việc làm quản lý</a>
                </div>
                <c:if test="${isLoggedIn && isJobSeeker}">
                    <div class="mega-col">
                        <h4>Việc của tôi</h4>
                        <a href="${pageContext.request.contextPath}/saved-jobs">Việc đã lưu</a>
                        <a href="${pageContext.request.contextPath}/applied-jobs">Việc đã ứng tuyển</a>
                        <a href="#">Thông báo việc làm</a>
                        <a href="#">Việc dành cho bạn</a>
                    </div>
                </c:if>
                <div class="mega-col">
                    <h4>Công ty</h4>
                    <a href="${pageContext.request.contextPath}/company-culture">Tất cả công ty</a>
                </div>
            </div>
        </div>
    <main>

        <!-- Online CV Area End-->
        <!-- Featured_job_start -->
        <section class="featured-job-area feature-padding">
            <div class="container">
                <!-- Section Tittle -->
                <div class="row">
                    <div class="col-lg-12">
                        <div class="section-tittle text-center">
                            <h2>Việc Làm Nổi Bật Hàng Đầu</h2>
                        </div>
                    </div>
                </div>
                
                <div class="row justify-content-center">
                    <div class="col-xl-12">
                        <c:choose>
                            <c:when test="${not empty featuredGoldJobs}">
                                <!-- Grid 3 columns -->
                                <div class="jobs-grid-3col">
                                    <c:forEach var="job" items="${featuredGoldJobs}" varStatus="status">
                                        <!-- Job Card -->
                                        <div class="job-card-gold gold-job">
                                            <a href="${pageContext.request.contextPath}/job-detail?jobId=${job.jobID}" class="job-card-link">
                                                <!-- Company Logo -->
                                                <div class="job-card-banner">
                                                    <c:choose>
                                                        <c:when test="${not empty job.companyLogo}">
                                                            <img src="${pageContext.request.contextPath}/${job.companyLogo}" alt="${job.companyName}">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="banner-logo-placeholder">
                                                                ${job.companyName.substring(0, 1).toUpperCase()}
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </a>
                                            
                                            <!-- Job Content -->
                                            <div class="job-card-content">
                                                <a href="${pageContext.request.contextPath}/job-detail?jobId=${job.jobID}">
                                                    <h3 class="job-card-title">${job.jobTitle}</h3>
                                                </a>
                                                
                                                <p class="job-card-company">${job.companyName}</p>
                                                
                                                <div class="job-card-info">
                                                    <div class="job-info-item">
                                                        <i class="fas fa-map-marker-alt"></i>
                                                        <span>${job.locationName}</span>
                                                    </div>
                                                    
                                                    <c:if test="${not empty job.salaryRange}">
                                                        <div class="job-info-item">
                                                            <i class="fas fa-money-bill-wave"></i>
                                                            <span>${job.salaryRange}</span>
                                                        </div>
                                                    </c:if>
                                                </div>
                                                
                                                <a href="${pageContext.request.contextPath}/job-detail?jobId=${job.jobID}" class="view-job-btn">
                                                    Xem chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                
                                <!-- Pagination -->
                                <div id="pagination" style="display:flex; justify-content:center; gap:0.5rem; margin-top:2rem; align-items:center;">
                                    <button id="prevPage" class="btn btn-outline" style="min-width:40px; height:40px; padding:0;">
                                        <i class="fas fa-chevron-left"></i>
                                    </button>
                                    <span id="pageInfo" style="color:#fff; min-width:80px; text-align:center; font-weight:600;"></span>
                                    <button id="nextPage" class="btn btn-outline" style="min-width:40px; height:40px; padding:0;">
                                        <i class="fas fa-chevron-right"></i>
                                    </button>
                                </div>
                            </c:when>
                            
                            <c:otherwise>
                                <!-- Empty State -->
                                <div class="text-center" style="padding: 60px 0;">
                                    <i class="fas fa-briefcase" style="font-size: 48px; color: #ddd; margin-bottom: 20px;"></i>
                                    <p style="color: #999;">Hiện tại chưa có việc làm premium nào.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </section>
        <!-- Featured_job_end -->
        
        <!-- Marketing Content Area Start -->
        <div class="marketing-content-area">
            <div class="container">
                <!-- Section Tittle -->
                <div class="row">
                    <div class="col-lg-12">
                        <div class="section-tittle text-center">
                            <span>📢 Tin tức & Cập nhật</span>
                            <h2>Nội dung Marketing mới nhất</h2>
                        </div>
                    </div>
                </div>
                
                <c:choose>
                    <c:when test="${not empty marketingContents}">
                        <div class="marketing-content-grid">
                            <c:forEach var="content" items="${marketingContents}" begin="0" end="5">
                                <div class="marketing-content-card">
                                    <div class="marketing-content-header">
                                        <span class="marketing-platform">${content.platform}</span>
                                        <c:if test="${not empty content.postDate}">
                                            <span class="marketing-date">
                                                <fmt:formatDate value="${content.postDate}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </c:if>
                                    </div>
                                    
                                    <h3 class="marketing-title">${content.title}</h3>
                                    
                                    <c:if test="${not empty content.contentText}">
                                        <p class="marketing-text">${content.contentText}</p>
                                    </c:if>
                                    
                                    <c:if test="${not empty content.mediaURL}">
                                        <img src="${content.mediaURL}" alt="Marketing content" class="marketing-media" 
                                             onerror="this.style.display='none';">
                                    </c:if>
                                    
                                    <a href="#" onclick="trackViewAndRedirect(${content.contentID})" class="marketing-read-more">
                                        Đọc thêm <i class="fas fa-arrow-right"></i>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-content-message">
                            <i class="fas fa-newspaper" style="font-size: 3rem; margin-bottom: 20px; opacity: 0.5;"></i>
                            <p>Chưa có nội dung marketing nào được xuất bản.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <!-- Marketing Content Area End -->
        
        <!-- How  Apply Process Start-->
        <div class="apply-process-area apply-bg pt-150 pb-150" data-background="../assets/img/gallery/how-applybg.png">
            <div class="container">
                <!-- Section Tittle -->
                <div class="row">
                    <div class="col-lg-12">
                        <div class="section-tittle white-text text-center">
                            <span>Apply process</span>
                            <h2> How it works</h2>
                        </div>
                    </div>
                </div>
                <!-- Apply Process Caption -->
                <div class="row">
                    <div class="col-lg-4 col-md-6">
                        <div class="single-process text-center mb-30">
                            <div class="process-ion">
                                <span class="flaticon-search"></span>
                            </div>
                            <div class="process-cap">
                               <h5>1. Search a job</h5>
                               <p>Sorem spsum dolor sit amsectetur adipisclit, seddo eiusmod tempor incididunt ut laborea.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="single-process text-center mb-30">
                            <div class="process-ion">
                                <span class="flaticon-curriculum-vitae"></span>
                            </div>
                            <div class="process-cap">
                               <h5>2. Apply for job</h5>
                               <p>Sorem spsum dolor sit amsectetur adipisclit, seddo eiusmod tempor incididunt ut laborea.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="single-process text-center mb-30">
                            <div class="process-ion">
                                <span class="flaticon-tour"></span>
                            </div>
                            <div class="process-cap">
                               <h5>3. Get your job</h5>
                               <p>Sorem spsum dolor sit amsectetur adipisclit, seddo eiusmod tempor incididunt ut laborea.</p>
                            </div>
                        </div>
                    </div>
                </div>
             </div>
        </div>
        <!-- How  Apply Process End-->
        <!-- Testimonial Start -->
        <div class="testimonial-area testimonial-padding">
            <div class="container">
                <!-- Testimonial contents -->
                <div class="row d-flex justify-content-center">
                    <div class="col-xl-8 col-lg-8 col-md-10">
                        <div class="h1-testimonial-active dot-style">
                            <!-- Single Testimonial -->
                            <div class="single-testimonial text-center">
                                <!-- Testimonial Content -->
                                <div class="testimonial-caption ">
                                    <!-- founder -->
                                    <div class="testimonial-founder  ">
                                        <div class="founder-img mb-30">
                                            <img src="../assets/img/testmonial/testimonial-founder.png" alt="">
                                            <span>Margaret Lawson</span>
                                            <p>Creative Director</p>
                                        </div>
                                    </div>
                                    <div class="testimonial-top-cap">
                                        <p>“I am at an age where I just want to be fit and healthy our bodies are our responsibility! So start caring for your body and it will care for you. Eat clean it will care for you and workout hard.”</p>
                                    </div>
                                </div>
                            </div>
                            <!-- Single Testimonial -->
                            <div class="single-testimonial text-center">
                                <!-- Testimonial Content -->
                                <div class="testimonial-caption ">
                                    <!-- founder -->
                                    <div class="testimonial-founder  ">
                                        <div class="founder-img mb-30">
                                            <img src="../assets/img/testmonial/testimonial-founder.png" alt="">
                                            <span>Margaret Lawson</span>
                                            <p>Creative Director</p>
                                        </div>
                                    </div>
                                    <div class="testimonial-top-cap">
                                        <p>“I am at an age where I just want to be fit and healthy our bodies are our responsibility! So start caring for your body and it will care for you. Eat clean it will care for you and workout hard.”</p>
                                    </div>
                                </div>
                            </div>
                            <!-- Single Testimonial -->
                            <div class="single-testimonial text-center">
                                <!-- Testimonial Content -->
                                <div class="testimonial-caption ">
                                    <!-- founder -->
                                    <div class="testimonial-founder  ">
                                        <div class="founder-img mb-30">
                                            <img src="../assets/img/testmonial/testimonial-founder.png" alt="">
                                            <span>Margaret Lawson</span>
                                            <p>Creative Director</p>
                                        </div>
                                    </div>
                                    <div class="testimonial-top-cap">
                                        <p>“I am at an age where I just want to be fit and healthy our bodies are our responsibility! So start caring for your body and it will care for you. Eat clean it will care for you and workout hard.”</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Testimonial End -->
         <!-- Support Company Start-->
         <div class="support-company-area support-padding fix">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-xl-6 col-lg-6">
                        <div class="right-caption">
                            <!-- Section Tittle -->
                            <div class="section-tittle section-tittle2">
                                <span>What we are doing</span>
                                <h2>24k Talented people are getting Jobs</h2>
                            </div>
                            <div class="support-caption">
                                <p class="pera-top">Mollit anim laborum duis au dolor in voluptate velit ess cillum dolore eu lore dsu quality mollit anim laborumuis au dolor in voluptate velit cillum.</p>
                                <p>Mollit anim laborum.Duis aute irufg dhjkolohr in re voluptate velit esscillumlore eu quife nrulla parihatur. Excghcepteur signjnt occa cupidatat non inulpadeserunt mollit aboru. temnthp incididbnt ut labore mollit anim laborum suis aute.</p>
                                <a href="about.html" class="btn post-btn">Post a job</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-6 col-lg-6">
                        <div class="support-location-img">
                            <img src="../assets/img/service/support-img.jpg" alt="">
                            <div class="support-img-cap text-center">
                                <p>Since</p>
                                <span>1994</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Support Company End-->
        <!-- Blog Area Start -->
        <div class="home-blog-area blog-h-padding">
            <div class="container">
                <!-- Section Tittle -->
                <div class="row">
                    <div class="col-lg-12">
                        <div class="section-tittle text-center">
                            <span>Our latest blog</span>
                            <h2>Our recent news</h2>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-xl-6 col-lg-6 col-md-6">
                        <div class="home-blog-single mb-30">
                            <div class="blog-img-cap">
                                <div class="blog-img">
                                    <img src="../assets/img/blog/home-blog1.jpg" alt="">
                                    <!-- Blog date -->
                                    <div class="blog-date text-center">
                                        <span>24</span>
                                        <p>Now</p>
                                    </div>
                                </div>
                                <div class="blog-cap">
                                    <p>|   Properties</p>
                                    <h3><a href="single-blog.html">Footprints in Time is perfect House in Kurashiki</a></h3>
                                    <a href="#" class="more-btn">Read more »</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-6 col-lg-6 col-md-6">
                        <div class="home-blog-single mb-30">
                            <div class="blog-img-cap">
                                <div class="blog-img">
                                    <img src="../assets/img/blog/home-blog2.jpg" alt="">
                                    <!-- Blog date -->
                                    <div class="blog-date text-center">
                                        <span>24</span>
                                        <p>Now</p>
                                    </div>
                                </div>
                                <div class="blog-cap">
                                    <p>|   Properties</p>
                                    <h3><a href="single-blog.html">Footprints in Time is perfect House in Kurashiki</a></h3>
                                    <a href="#" class="more-btn">Read more »</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Blog Area End -->

    </main>
    <footer>
        <!-- Footer Start-->
        <div class="footer-area footer-bg footer-padding">
            <div class="container">
                <div class="row d-flex justify-content-between">
                    <div class="col-xl-3 col-lg-3 col-md-4 col-sm-6">
                       <div class="single-footer-caption mb-50">
                         <div class="single-footer-caption mb-30">
                             <div class="footer-tittle">
                                 <h4>About Us</h4>
                                 <div class="footer-pera">
                                     <p>Heaven frucvitful doesn't cover lesser dvsays appear creeping seasons so behold.</p>
                                </div>
                             </div>
                         </div>

                       </div>
                    </div>
                    <div class="col-xl-3 col-lg-3 col-md-4 col-sm-5">
                        <div class="single-footer-caption mb-50">
                            <div class="footer-tittle">
                                <h4>Contact Info</h4>
                                <ul>
                                    <li>
                                    <p>Address :Your address goes
                                        here, your demo address.</p>
                                    </li>
                                    <li><a href="#">Phone : +8880 44338899</a></li>
                                    <li><a href="#">Email : info@colorlib.com</a></li>
                                </ul>
                            </div>

                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-3 col-md-4 col-sm-5">
                        <div class="single-footer-caption mb-50">
                            <div class="footer-tittle">
                                <h4>Important Link</h4>
                                <ul>
                                    <li><a href="#"> View Project</a></li>
                                    <li><a href="#">Contact Us</a></li>
                                    <li><a href="#">Testimonial</a></li>
                                    <li><a href="#">Proparties</a></li>
                                    <li><a href="#">Support</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-3 col-md-4 col-sm-5">
                        <div class="single-footer-caption mb-50">
                            <div class="footer-tittle">
                                <h4>Newsletter</h4>
                                <div class="footer-pera footer-pera2">
                                 <p>Heaven fruitful doesn't over lesser in days. Appear creeping.</p>
                             </div>
                             <!-- Form -->
                             <div class="footer-form" >
                                 <div id="mc_embed_signup">
                                     <form target="_blank" action="https://spondonit.us12.list-manage.com/subscribe/post?u=1462626880ade1ac87bd9c93a&amp;id=92a4423d01"
                                     method="get" class="subscribe_form relative mail_part">
                                         <input type="email" name="email" id="newsletter-form-email" placeholder="Email Address"
                                         class="placeholder hide-on-focus" onfocus="this.placeholder = ''"
                                         onblur="this.placeholder = ' Email Address '">
                                         <div class="form-icon">
                                             <button type="submit" name="submit" id="newsletter-submit"
                                             class="email_icon newsletter-submit button-contactForm"><img src="../assets/img/icon/form.png" alt=""></button>
                                         </div>
                                         <div class="mt-10 info"></div>
                                     </form>
                                 </div>
                             </div>
                            </div>
                        </div>
                    </div>
                </div>
               <!--  -->
               <div class="row footer-wejed justify-content-between">
                    <div class="col-xl-3 col-lg-3 col-md-4 col-sm-6">
                        <!-- logo -->
                        <div class="footer-logo mb-20">
                        <a href="../index.jsp"><img src="../assets/img/logo/logo2_footer.png" alt=""></a>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-3 col-md-4 col-sm-5">
                    <div class="footer-tittle-bottom">
                        <span>5000+</span>
                        <p>Talented Hunter</p>
                    </div>
                    </div>
                    <div class="col-xl-3 col-lg-3 col-md-4 col-sm-5">
                        <div class="footer-tittle-bottom">
                            <span>451</span>
                            <p>Talented Hunter</p>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-3 col-md-4 col-sm-5">
                        <!-- Footer Bottom Tittle -->
                        <div class="footer-tittle-bottom">
                            <span>568</span>
                            <p>Talented Hunter</p>
                        </div>
                    </div>
               </div>
            </div>
        </div>
        <!-- footer-bottom area -->
        <div class="footer-bottom-area footer-bg">
            <div class="container">
                <div class="footer-border">
                     <div class="row d-flex justify-content-between align-items-center">
                         <div class="col-xl-10 col-lg-10 ">
                             <div class="footer-copy-right">
                                 <p><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
  Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
  <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. --></p>
                             </div>
                         </div>
                         <div class="col-xl-2 col-lg-2">
                             <div class="footer-social f-right">
                                 <a href="#"><i class="fab fa-facebook-f"></i></a>
                                 <a href="#"><i class="fab fa-twitter"></i></a>
                                 <a href="#"><i class="fas fa-globe"></i></a>
                                 <a href="#"><i class="fab fa-behance"></i></a>
                             </div>
                         </div>
                     </div>
                </div>
            </div>
        </div>
        <!-- Footer End-->
    </footer>

  <!-- JS here -->
	
		<!-- All JS Custom Plugins Link Here here -->
        <script src="../assets/js/vendor/modernizr-3.5.0.min.js"></script>
		<!-- Jquery, Popper, Bootstrap -->
		<script src="../assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="../assets/js/popper.min.js"></script>
        <script src="../assets/js/bootstrap.min.js"></script>
	    <!-- Jquery Mobile Menu -->
        <script src="../assets/js/jquery.slicknav.min.js"></script>

		<!-- Jquery Slick , Owl-Carousel Plugins -->
        <script src="../assets/js/owl.carousel.min.js"></script>
        <script src="../assets/js/slick.min.js"></script>
        <script src="../assets/js/price_rangs.js"></script>
        
		<!-- One Page, Animated-HeadLin -->
        <script src="../assets/js/wow.min.js"></script>
		<script src="../assets/js/animated.headline.js"></script>
        <script src="../assets/js/jquery.magnific-popup.js"></script>

		<!-- Scrollup, nice-select, sticky -->
        <script src="../assets/js/jquery.scrollUp.min.js"></script>
        <script src="../assets/js/jquery.nice-select.min.js"></script>
		<script src="../assets/js/jquery.sticky.js"></script>
        
        <!-- contact js -->
        <script src="../assets/js/contact.js"></script>
        <script src="../assets/js/jquery.form.js"></script>
        <script src="../assets/js/jquery.validate.min.js"></script>
        <script src="../assets/js/mail-script.js"></script>
        <script src="../assets/js/jquery.ajaxchimp.min.js"></script>
        
		<!-- Jquery Plugins, main Jquery -->	
        <script src="../assets/js/plugins.js"></script>
        <script src="../assets/js/main.js"></script>
        <script>
            (function(){
                const toggle = document.getElementById('menuToggle');
                const panel = document.getElementById('megaMenu');
                if(!toggle || !panel) return;
                function closeOnOutside(e){
                    if(!panel.contains(e.target) && !toggle.contains(e.target)){
                        panel.classList.remove('open');
                        document.removeEventListener('click', closeOnOutside);
                    }
                }
                toggle.addEventListener('click', function(e){
                    e.stopPropagation();
                    panel.classList.toggle('open');
                    if(panel.classList.contains('open')){
                        document.addEventListener('click', closeOnOutside);
                    }
                });
            })();
            
            // Function to track view count and redirect
            function trackViewAndRedirect(contentID) {
                // Send view count request
                fetch('${pageContext.request.contextPath}/view-count?id=' + contentID, {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json',
                    }
                })
                .then(response => response.json())
                .then(data => {
                    // Redirect to content detail page regardless of tracking success
                    window.location.href = '${pageContext.request.contextPath}/content-detail?id=' + contentID;
                })
                .catch(error => {
                    console.error('Error tracking view:', error);
                    // Still redirect even if tracking fails
                    window.location.href = '${pageContext.request.contextPath}/content-detail?id=' + contentID;
                });
            }
            
            // Notification Dropdown functionality với AJAX
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
                    if (!wasShown) loadNotifications(); // Load khi mở dropdown
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
                
                // Load initial badge count khi trang load
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
            
            // ============================================
            // PAGINATION FOR FEATURED GOLD JOBS
            // ============================================
            (function() {
                const jobItems = document.querySelectorAll('.gold-job');
                const pageInfo = document.getElementById('pageInfo');
                const prevBtn = document.getElementById('prevPage');
                const nextBtn = document.getElementById('nextPage');
                
                if (!jobItems.length || !pageInfo || !prevBtn || !nextBtn) return;
                
                const JOBS_PER_PAGE = 9; // 9 jobs per page (3x3 grid)
                let currentPage = 1;
                const totalPages = Math.max(1, Math.ceil(jobItems.length / JOBS_PER_PAGE));
                
                function renderPage(page) {
                    if (page < 1) page = 1;
                    if (page > totalPages) page = totalPages;
                    currentPage = page;
                    
                    jobItems.forEach((item, idx) => {
                        const shouldShow = idx >= (currentPage - 1) * JOBS_PER_PAGE && idx < currentPage * JOBS_PER_PAGE;
                        item.style.display = shouldShow ? '' : 'none';
                    });
                    
                    pageInfo.textContent = currentPage + ' / ' + totalPages;
                    prevBtn.disabled = (currentPage === 1);
                    nextBtn.disabled = (currentPage === totalPages);
                    
                    // Scroll to top of job section
                    const jobSection = document.querySelector('.featured-job-area');
                    if (jobSection) {
                        jobSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }
                }
                
                prevBtn.addEventListener('click', () => renderPage(currentPage - 1));
                nextBtn.addEventListener('click', () => renderPage(currentPage + 1));
                
                renderPage(1);
            })();
        </script>
        
    </body>
</html>