<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="dal.ContentDAO"%>
<%@page import="model.MarketingContent"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.*"%>

<%
    ContentDAO contentDAO = new ContentDAO();
    
    // Test 1: Check database connection
    boolean dbConnected = false;
    try {
        java.sql.Connection conn = contentDAO.getConnection();
        dbConnected = (conn != null && !conn.isClosed());
        System.out.println("Database connected: " + dbConnected);
    } catch (Exception e) {
        System.out.println("Database connection error: " + e.getMessage());
    }
    
    // Test 2: Get all content
    List<MarketingContent> allContent = contentDAO.getAllContent();
    System.out.println("Total content items: " + allContent.size());
    
    // Test 3: Get published content for website
    List<MarketingContent> websiteContent = contentDAO.getPublishedContentForWebsite();
    System.out.println("Website content items: " + websiteContent.size());
    
    // Test 3b: Get all website content (simple)
    List<MarketingContent> allWebsiteContent = contentDAO.getAllWebsiteContent();
    System.out.println("All website content items: " + allWebsiteContent.size());
    
    // Test 4: Check specific content
    for (MarketingContent content : allContent) {
        System.out.println("Content ID: " + content.getContentID() + 
                          ", Title: " + content.getTitle() + 
                          ", Status: " + content.getStatus() + 
                          ", Platform: " + content.getPlatform() + 
                          ", PostDate: " + content.getPostDate());
    }
    
    request.setAttribute("dbConnected", dbConnected);
    request.setAttribute("allContent", allContent);
    request.setAttribute("websiteContent", websiteContent);
    request.setAttribute("allWebsiteContent", allWebsiteContent);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Debug Content Display</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .debug-section { border: 1px solid #ddd; margin: 10px 0; padding: 15px; }
        .success { background-color: #d4edda; }
        .error { background-color: #f8d7da; }
        .content-item { border: 1px solid #ccc; margin: 5px 0; padding: 10px; }
        .published { background-color: #d4edda; }
        .draft { background-color: #fff3cd; }
        .website { border-left: 4px solid #007bff; }
    </style>
</head>
<body>
    <h1>🔍 Debug Content Display</h1>
    
    <!-- Test 1: Database Connection -->
    <div class="debug-section ${dbConnected ? 'success' : 'error'}">
        <h3>Test 1: Database Connection</h3>
        <p><strong>Status:</strong> ${dbConnected ? '✅ Connected' : '❌ Failed'}</p>
    </div>
    
    <!-- Test 2: All Content -->
    <div class="debug-section">
        <h3>Test 2: All Content (${allContent.size()} items)</h3>
        <c:forEach var="content" items="${allContent}">
            <div class="content-item ${content.status == 'Published' ? 'published' : 'draft'} ${content.platform == 'Website' ? 'website' : ''}">
                <strong>ID:</strong> ${content.contentID} | 
                <strong>Title:</strong> ${content.title} | 
                <strong>Status:</strong> ${content.status} | 
                <strong>Platform:</strong> ${content.platform} | 
                <strong>PostDate:</strong> ${content.postDate}
            </div>
        </c:forEach>
    </div>
    
    <!-- Test 3: Website Content -->
    <div class="debug-section">
        <h3>Test 3: Website Content (${websiteContent.size()} items) - Will be displayed</h3>
        <c:choose>
            <c:when test="${websiteContent.size() > 0}">
                <c:forEach var="content" items="${websiteContent}">
                    <div class="content-item published website">
                        <strong>ID:</strong> ${content.contentID} | 
                        <strong>Title:</strong> ${content.title} | 
                        <strong>Status:</strong> ${content.status} | 
                        <strong>Platform:</strong> ${content.platform} | 
                        <strong>PostDate:</strong> ${content.postDate}
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p style="color: red;">❌ No content found for website display!</p>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Test 3b: All Website Content (Simple) -->
    <div class="debug-section">
        <h3>Test 3b: All Website Content (${allWebsiteContent.size()} items) - Simple Query</h3>
        <c:choose>
            <c:when test="${allWebsiteContent.size() > 0}">
                <c:forEach var="content" items="${allWebsiteContent}">
                    <div class="content-item ${content.status == 'Published' ? 'published' : 'draft'} website">
                        <strong>ID:</strong> ${content.contentID} | 
                        <strong>Title:</strong> ${content.title} | 
                        <strong>Status:</strong> ${content.status} | 
                        <strong>Platform:</strong> ${content.platform} | 
                        <strong>PostDate:</strong> ${content.postDate}
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p style="color: red;">❌ No website content found at all!</p>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Test 4: Manual Fix -->
    <div class="debug-section">
        <h3>Test 4: Manual Fix</h3>
        <form action="${pageContext.request.contextPath}/loadcontentpage" method="GET">
            <button type="submit" style="background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px;">
                🔧 Run LoadContentPage Servlet (Auto Fix)
            </button>
        </form>
        
        <form action="${pageContext.request.contextPath}/JobSeeker/index.jsp" method="GET">
            <button type="submit" style="background: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 5px;">
                🌐 View Website (JobSeeker/index.jsp)
            </button>
        </form>
    </div>
    
    <!-- Test 5: Direct Database Query -->
    <div class="debug-section">
        <h3>Test 5: Direct Database Query</h3>
        <%
            try {
                java.sql.Connection conn = contentDAO.getConnection();
                String sql = "SELECT ContentID, Title, Status, Platform, PostDate FROM MarketingContents WHERE Platform = 'Website'";
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    out.println("<table border='1' style='width:100%; border-collapse: collapse;'>");
                    out.println("<tr><th>ID</th><th>Title</th><th>Status</th><th>Platform</th><th>PostDate</th></tr>");
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getInt("ContentID") + "</td>");
                        out.println("<td>" + rs.getString("Title") + "</td>");
                        out.println("<td>" + rs.getString("Status") + "</td>");
                        out.println("<td>" + rs.getString("Platform") + "</td>");
                        out.println("<td>" + rs.getTimestamp("PostDate") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                }
            } catch (Exception e) {
                out.println("<p style='color: red;'>Database query error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>
