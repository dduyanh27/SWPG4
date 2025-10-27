package controller.staff;

import dal.CampaignDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Admin;

@WebServlet(name = "DeleteCampaignServlet", urlPatterns = {"/delete-campaign"})
public class DeleteCampaignServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Kiểm tra session admin
            Admin admin = (Admin) request.getSession().getAttribute("admin");
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
                return;
            }

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

            // Xóa campaign từ database
            CampaignDAO campaignDAO = new CampaignDAO();
            boolean success = campaignDAO.deleteCampaign(campaignId);

            if (success) {
                // Redirect về trang campaign với thông báo thành công
                response.sendRedirect(request.getContextPath() + "/Staff/campaign.jsp?deleted=1");
            } else {
                // Redirect về trang campaign với thông báo lỗi
                response.sendRedirect(request.getContextPath() + "/Staff/campaign.jsp?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Staff/campaign.jsp?error=1");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}


