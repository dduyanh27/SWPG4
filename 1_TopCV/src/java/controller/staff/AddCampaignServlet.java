package controller.staff;

import dal.CampaignDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Admin;
import model.Campaign;

@WebServlet(name = "AddCampaignServlet", urlPatterns = {"/AddCampaignServlet"})
public class AddCampaignServlet extends HttpServlet {

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

            // Lấy dữ liệu từ form
            String campaignName = request.getParameter("campaignName");
            String targetType = request.getParameter("targetType");
            String platform = request.getParameter("platform");
            String budgetStr = request.getParameter("budget");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String status = request.getParameter("status");
            String description = request.getParameter("description");
            String createdByStr = request.getParameter("createdBy");

            // Validation
            if (campaignName == null || campaignName.trim().isEmpty()) {
                request.setAttribute("error", "Tên chiến dịch không được để trống!");
                request.getRequestDispatcher("/Staff/add-campaign.jsp").forward(request, response);
                return;
            }

            if (targetType == null || targetType.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn đối tượng!");
                request.getRequestDispatcher("/Staff/add-campaign.jsp").forward(request, response);
                return;
            }

            if (platform == null || platform.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn nền tảng!");
                request.getRequestDispatcher("/Staff/add-campaign.jsp").forward(request, response);
                return;
            }

            if (budgetStr == null || budgetStr.trim().isEmpty()) {
                request.setAttribute("error", "Ngân sách không được để trống!");
                request.getRequestDispatcher("/Staff/add-campaign.jsp").forward(request, response);
                return;
            }

            if (startDateStr == null || startDateStr.trim().isEmpty()) {
                request.setAttribute("error", "Ngày bắt đầu không được để trống!");
                request.getRequestDispatcher("/Staff/add-campaign.jsp").forward(request, response);
                return;
            }

            if (endDateStr == null || endDateStr.trim().isEmpty()) {
                request.setAttribute("error", "Ngày kết thúc không được để trống!");
                request.getRequestDispatcher("/Staff/add-campaign.jsp").forward(request, response);
                return;
            }

            if (status == null || status.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn trạng thái!");
                request.getRequestDispatcher("/Staff/add-campaign.jsp").forward(request, response);
                return;
            }

            // Parse và validate dữ liệu
            BigDecimal budget;
            try {
                budget = new BigDecimal(budgetStr);
                if (budget.compareTo(BigDecimal.ZERO) < 0) {
                    request.setAttribute("error", "Ngân sách không được âm!");
                    request.getRequestDispatcher("/Staff/add-campaign.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Ngân sách không hợp lệ!");
                request.getRequestDispatcher("/Staff/add-campaign.jsp").forward(request, response);
                return;
            }

            Date startDate, endDate;
            try {
                startDate = Date.valueOf(startDateStr);
                endDate = Date.valueOf(endDateStr);
                
                if (endDate.before(startDate)) {
                    request.setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu!");
                    request.getRequestDispatcher("/Staff/add-campaign.jsp").forward(request, response);
                    return;
                }
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Ngày tháng không hợp lệ!");
                request.getRequestDispatcher("/Staff/add-campaign.jsp").forward(request, response);
                return;
            }

            int createdBy;
            try {
                createdBy = Integer.parseInt(createdByStr);
            } catch (NumberFormatException e) {
                createdBy = admin.getAdminId(); // Fallback to session admin
            }

            // Tạo đối tượng Campaign
            Campaign campaign = new Campaign();
            campaign.setCampaignName(campaignName.trim());
            campaign.setTargetType(targetType);
            campaign.setPlatform(platform);
            campaign.setBudget(budget);
            campaign.setStartDate(startDate);
            campaign.setEndDate(endDate);
            campaign.setStatus(status);
            campaign.setDescription(description != null ? description.trim() : "");
            campaign.setCreatedBy(createdBy);

            // Thêm campaign vào database
            CampaignDAO campaignDAO = new CampaignDAO();
            boolean success = campaignDAO.addCampaign(campaign);

            if (success) {
                // Redirect về trang campaign với thông báo thành công
                response.sendRedirect(request.getContextPath() + "/Staff/campaign.jsp?success=1");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi tạo chiến dịch. Vui lòng thử lại!");
                request.getRequestDispatcher("/Staff/add-campaign.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/Staff/add-campaign.jsp").forward(request, response);
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


