package controller.jobseeker;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import model.JobSeeker;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import dal.JobSeekerDAO;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import model.GoogleAccount;
import util.Iconstant;

@WebServlet(name = "GoogleLoginServlet", urlPatterns = {"/GoogleLoginServlet", "/userLogin", "/JobSeeker/jobseeker-login"})
public class GoogleLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null || code.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/JobSeeker/jobseeker-login.jsp");
            return;
        }

        try {
            String accessToken = getToken(code);
            GoogleAccount account = getUserInfo(accessToken);

            JobSeekerDAO dao = new JobSeekerDAO();
            
            // Check if email exists in JobSeeker table
            JobSeeker user = dao.getJobSeekerByEmail(account.getEmail());
            
            if (user == null) {
                // Email doesn't exist, create new account
                user = dao.insertJobSeeker(account.getEmail(), "GOOGLE_LOGIN", "Active", account.getName());
                
                if (user == null) {
                    throw new Exception("Không thể tạo tài khoản mới");
                }
            } else {
                // Email exists, check if it's a password account
                if (dao.hasPasswordAccount(account.getEmail())) {
                    // Account exists with password, prevent Google login
                    throw new Exception("Email này đã được đăng ký với mật khẩu. Vui lòng đăng nhập bằng email và mật khẩu thay vì Google.");
                } else if (dao.isGoogleAccount(account.getEmail())) {
                    // Already a Google account
                } else {
                    // Mark existing account as Google login account
                    dao.setAsGoogleAccount(user.getJobSeekerId());
                }
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("jobseeker", user); // Add this for session consistency check
            session.setAttribute("userType", "jobseeker");
            session.setAttribute("userID", user.getJobSeekerId());
            session.setAttribute("userName", user.getFullName() != null ? user.getFullName() : user.getEmail());
            
            response.sendRedirect(request.getContextPath() + "/JobSeeker/index.jsp");
        } catch (Exception ex) {
            ex.printStackTrace();
            
            String msg = ex.getMessage();
            if (msg != null) {
                msg = msg.replace('\n', ' ').replace('\r', ' ');
            } else {
                msg = "Có lỗi xảy ra trong quá trình đăng nhập Google. Vui lòng thử lại.";
            }
            
            response.sendRedirect(request.getContextPath() + "/JobSeeker/jobseeker-login.jsp?oauth_error=" + 
                java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8));
        }
    }

    private String getToken(String code) throws IOException {
        String tokenEndpoint = "https://oauth2.googleapis.com/token";
        var request = Request.Post(tokenEndpoint)
                .addHeader("Accept", "application/json")
                .bodyForm(
                        Form.form()
                                .add("client_id", Iconstant.GOOGLE_CLIENT_ID)
                                .add("client_secret", Iconstant.GOOGLE_CLIENT_SECRET)
                                .add("redirect_uri", Iconstant.GOOGLE_REDIRECT_URI)
                                .add("code", code)
                                .add("grant_type", Iconstant.GOOGLE_GRANT_TYPE)
                                .build()
                );
        var resp = request.execute().returnResponse();
        int status = resp.getStatusLine().getStatusCode();
        String body = resp.getEntity() != null ? new String(resp.getEntity().getContent().readAllBytes()) : "";
        if (status != 200) {
            throw new IOException("Token HTTP " + status + ": " + body);
        }

        JsonObject jobj = new Gson().fromJson(body, JsonObject.class);
        if (jobj == null || !jobj.has("access_token")) {
            throw new IOException("Invalid token response: " + body);
        }
        return jobj.get("access_token").getAsString();
    }

    private GoogleAccount getUserInfo(final String accessToken) throws IOException {
        String link = Iconstant.GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, GoogleAccount.class);
    }
}
