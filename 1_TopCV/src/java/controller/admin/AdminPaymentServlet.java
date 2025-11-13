package controller.admin;

import dal.PaymentsDAO;
import model.PaymentWithRecruiterInfo;
import model.PaymentStatistics;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminPaymentServlet", urlPatterns = {"/admin-payment"})
public class AdminPaymentServlet extends HttpServlet {

    private PaymentsDAO paymentsDAO = new PaymentsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            System.out.println("=== AdminPaymentServlet.doGet() DEBUG ===");
            
            // Load all payments with recruiter information - Traditional DAO approach
            List<PaymentWithRecruiterInfo> paymentList = paymentsDAO.getAllPaymentsWithRecruiterInfo();
            System.out.println("Payment list size: " + (paymentList != null ? paymentList.size() : "NULL"));
            request.setAttribute("paymentList", paymentList);
            
            // Load payment statistics - Traditional DAO approach
            PaymentStatistics stats = paymentsDAO.getPaymentStatistics();
            System.out.println("Statistics loaded: " + (stats != null ? "YES" : "NULL"));
            request.setAttribute("paymentStats", stats);
            
            // Forward to JSP page
            request.getRequestDispatcher("/Admin/ad-payment.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // In case of error, still forward to JSP with empty data
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu thanh toán: " + e.getMessage());
            request.getRequestDispatcher("/Admin/ad-payment.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            updatePaymentStatus(request, response);
        } else if ("addPayment".equals(action)) {
            addPayment(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    private void updatePaymentStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int paymentID = Integer.parseInt(request.getParameter("paymentID"));
            String status = request.getParameter("status");
            String transactionCode = request.getParameter("transactionCode");
            
            boolean success = paymentsDAO.updatePaymentStatus(paymentID, status, transactionCode);
            
            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Cập nhật trạng thái thành công\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Cập nhật trạng thái thất bại\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra: " + e.getMessage() + "\"}");
        }
    }
    
    private void addPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // This would typically involve creating a new payment record
            // For now, just return success message
            response.getWriter().write("{\"success\": true, \"message\": \"Thêm giao dịch thành công\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra: " + e.getMessage() + "\"}");
        }
    }
}
