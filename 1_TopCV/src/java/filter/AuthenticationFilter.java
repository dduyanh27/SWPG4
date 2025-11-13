/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package filter;

import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author ADMIN
 */
public class AuthenticationFilter implements Filter {
    private static final String[] PUBLIC_PATHS = {
        "/index.jsp",
        "/JobSeeker/index.jsp",  // Allow guests to view homepage
        "/job-list",              // Allow guests to view job listings
        "/JobSeeker/job-list.jsp", // Allow guests to view job list page
        "/job-detail",            // Allow guests to view job details
        "/JobSeeker/job-detail.jsp", // Allow guests to view job detail page
        "/Admin/admin-login.jsp", 
        "/JobSeeker/jobseeker-login.jsp",
        "/JobSeeker/jobseeker-login",
        "/Recruiter/recruiter-login.jsp",
        "/Recruiter/registration.jsp",
        "/RecruiterRegistrationServlet",
        "/LoginServlet",
        "/GoogleLoginServlet",
        "/userLogin",
        "/LogoutServlet",
        "/assets/",
        "/css/",
        "/js/",
        "/images/"
    };
    
    private static final String[] ADMIN_PATHS = {
        "/admin/",
        "/AdminStaffLoginServlet"
    };
    
    private static final String[] USER_PATHS = {
        "/jobseeker/",
        "/recruiter/",
        "/UserLoginServlet"
    };
    
    private static final boolean debug = true;

    // The filter configuration object we are associated with.  If
    // this value is null, this filter instance is not currently
    // configured. 
    private FilterConfig filterConfig = null;
    
    public AuthenticationFilter() {
    }    
    
    private void doBeforeProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("AuthenticationFilter:DoBeforeProcessing");
        }

        // Write code here to process the request and/or response before
        // the rest of the filter chain is invoked.
        // For example, a logging filter might log items on the request object,
        // such as the parameters.
        /*
	for (Enumeration en = request.getParameterNames(); en.hasMoreElements(); ) {
	    String name = (String)en.nextElement();
	    String values[] = request.getParameterValues(name);
	    int n = values.length;
	    StringBuffer buf = new StringBuffer();
	    buf.append(name);
	    buf.append("=");
	    for(int i=0; i < n; i++) {
	        buf.append(values[i]);
	        if (i < n-1)
	            buf.append(",");
	    }
	    log(buf.toString());
	}
         */
    }    
    
    private void doAfterProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("AuthenticationFilter:DoAfterProcessing");
        }

        // Write code here to process the request and/or response after
        // the rest of the filter chain is invoked.
        // For example, a logging filter might log the attributes on the
        // request object after the request has been processed. 
        /*
	for (Enumeration en = request.getAttributeNames(); en.hasMoreElements(); ) {
	    String name = (String)en.nextElement();
	    Object value = request.getAttribute(name);
	    log("attribute: " + name + "=" + value.toString());

	}
         */
        // For example, a filter might append something to the response.
        /*
	PrintWriter respOut = new PrintWriter(response.getWriter());
	respOut.println("<P><B>This has been appended by an intrusive filter.</B>");
         */
    }

    /**
     *
     * @param request The servlet request we are processing
     * @param response The servlet response we are creating
     * @param chain The filter chain we are processing
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet error occurs
     */
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {
        
        if (debug) {
            log("AuthenticationFilter:doFilter()");
        }
        
        doBeforeProcessing(request, response);
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String contextPath = httpRequest.getContextPath();
        String requestPath = httpRequest.getRequestURI().substring(contextPath.length());
        
        // Always propagate session data as request attributes for JSP usage
        HttpSession session = httpRequest.getSession(false);
        if (session != null) {
            Object user = session.getAttribute("user");
            String userType = (String) session.getAttribute("userType");
            Object userID = session.getAttribute("userID");
            Object userName = session.getAttribute("userName");
            Object staffType = session.getAttribute("staffType");
            if (user != null) httpRequest.setAttribute("user", user);
            if (userType != null) httpRequest.setAttribute("userType", userType);
            if (userID != null) httpRequest.setAttribute("userID", userID);
            if (userName != null) httpRequest.setAttribute("userName", userName);
            if (staffType != null) httpRequest.setAttribute("staffType", staffType);
        }
        
        // Allow public paths and static resources
        if (isPublic(requestPath) || isStaticResource(requestPath)) {
            proceed(chain, request, response);
            return;
        }
        
        String userType = session != null ? (String) session.getAttribute("userType") : null;
        
        // Admin area access control
        if (requestPath.startsWith("/Admin/") || "/Admin/admin-dashboard.jsp".equals(requestPath)) {
            if ("admin".equals(userType)) {
                proceed(chain, request, response);
            } else {
                httpResponse.sendRedirect(contextPath + "/Admin/admin-login.jsp");
            }
            return;
        }
        
        // Jobseeker area access control
        if (requestPath.startsWith("/JobSeeker/")) {
            // Allow guests to access homepage, job list, and job detail
            if (requestPath.equals("/JobSeeker/index.jsp") || 
                requestPath.equals("/JobSeeker/job-list.jsp") || 
                requestPath.equals("/JobSeeker/job-detail.jsp")) {
                proceed(chain, request, response);
                return;
            }
            
            // Other JobSeeker pages require authentication
            if ("jobseeker".equals(userType)) {
                proceed(chain, request, response);
            } else {
                httpResponse.sendRedirect(contextPath + "/JobSeeker/jobseeker-login.jsp");
            }
            return;
        }
        
        // Recruiter area access control
        if (requestPath.startsWith("/Recruiter/")) {
            if ("recruiter".equals(userType)) {
                proceed(chain, request, response);
            } else {
                httpResponse.sendRedirect(contextPath + "/Recruiter/recruiter-login.jsp");
            }
            return;
        }
        
        // CompanyInfoServlet access control (for recruiters only)
        if ("/CompanyInfoServlet".equals(requestPath)) {
            if ("recruiter".equals(userType)) {
                proceed(chain, request, response);
            } else {
                httpResponse.sendRedirect(contextPath + "/Recruiter/recruiter-login.jsp");
            }
            return;
        }
        
        // For other non-public paths, require authentication
        if (userType == null) {
            httpResponse.sendRedirect(contextPath + "/JobSeeker/jobseeker-login.jsp");
            return;
        }
        
        proceed(chain, request, response);
    }

    private void proceed(FilterChain chain, ServletRequest request, ServletResponse response) throws IOException, ServletException {
        Throwable problem = null;
        try {
            chain.doFilter(request, response);
        } catch (Throwable t) {
            problem = t;
            t.printStackTrace();
        }
        doAfterProcessing(request, response);
        if (problem != null) {
            if (problem instanceof ServletException) {
                throw (ServletException) problem;
            }
            if (problem instanceof IOException) {
                throw (IOException) problem;
            }
            sendProcessingError(problem, response);
        }
    }

    private boolean isPublic(String path) {
        for (String prefix : PUBLIC_PATHS) {
            if (path.equals(prefix) || path.startsWith(prefix)) {
                return true;
            }
        }
        return false;
    }

    private boolean isStaticResource(String path) {
        String lower = path.toLowerCase();
        return lower.endsWith(".css") || lower.endsWith(".js") || lower.endsWith(".png") ||
               lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".gif") ||
               lower.endsWith(".svg") || lower.endsWith(".ico") || lower.endsWith(".woff") ||
               lower.endsWith(".woff2") || lower.endsWith(".ttf") || lower.endsWith(".map");
    }

    /**
     * Return the filter configuration object for this filter.
     */
    public FilterConfig getFilterConfig() {
        return (this.filterConfig);
    }

    /**
     * Set the filter configuration object for this filter.
     *
     * @param filterConfig The filter configuration object
     */
    public void setFilterConfig(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }

    /**
     * Destroy method for this filter
     */
    public void destroy() {        
    }

    /**
     * Init method for this filter
     */
    public void init(FilterConfig filterConfig) {        
        this.filterConfig = filterConfig;
        if (filterConfig != null) {
            if (debug) {                
                log("AuthenticationFilter:Initializing filter");
            }
        }
    }

    /**
     * Return a String representation of this object.
     */
    @Override
    public String toString() {
        if (filterConfig == null) {
            return ("AuthenticationFilter()");
        }
        StringBuffer sb = new StringBuffer("AuthenticationFilter(");
        sb.append(filterConfig);
        sb.append(")");
        return (sb.toString());
    }
    
    private void sendProcessingError(Throwable t, ServletResponse response) {
        String stackTrace = getStackTrace(t);        
        
        if (stackTrace != null && !stackTrace.equals("")) {
            try {
                response.setContentType("text/html");
                PrintStream ps = new PrintStream(response.getOutputStream());
                PrintWriter pw = new PrintWriter(ps);                
                pw.print("<html>\n<head>\n<title>Error</title>\n</head>\n<body>\n"); //NOI18N

                // PENDING! Localize this for next official release
                pw.print("<h1>The resource did not process correctly</h1>\n<pre>\n");                
                pw.print(stackTrace);                
                pw.print("</pre></body>\n</html>"); //NOI18N
                pw.close();
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
            }
        } else {
            try {
                PrintStream ps = new PrintStream(response.getOutputStream());
                t.printStackTrace(ps);
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
            }
        }
    }
    
    public static String getStackTrace(Throwable t) {
        String stackTrace = null;
        try {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            pw.close();
            sw.close();
            stackTrace = sw.getBuffer().toString();
        } catch (Exception ex) {
        }
        return stackTrace;
    }
    
    public void log(String msg) {
        filterConfig.getServletContext().log(msg);        
    }
    
}
