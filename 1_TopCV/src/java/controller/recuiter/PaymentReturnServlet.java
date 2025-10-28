package controller.recuiter;

import dal.PaymentsDAO;
import dal.PaymentDetailsDAO;
import dal.RecruiterPackagesDAO;
import dal.JobPackagesDAO;
import model.Payments;
import model.PaymentDetails;
import model.RecruiterPackages;
import model.JobPackages;
import util.VNPayConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "PaymentReturnServlet", urlPatterns = {"/payment-return"})
public class PaymentReturnServlet extends HttpServlet {
    
    private PaymentsDAO paymentsDAO = new PaymentsDAO();
    private PaymentDetailsDAO paymentDetailsDAO = new PaymentDetailsDAO();
    private RecruiterPackagesDAO recruiterPackagesDAO = new RecruiterPackagesDAO();
    private JobPackagesDAO jobPackagesDAO = new JobPackagesDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        try {
            // Get all VNPay parameters
            Map<String, String> fields = new HashMap<>();
            for (String key : request.getParameterMap().keySet()) {
                String value = request.getParameter(key);
                if (value != null && !value.isEmpty()) {
                    fields.put(key, value);
                }
            }

            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            fields.remove("vnp_SecureHashType");
            fields.remove("vnp_SecureHash");

            // Verify signature
            String signValue = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, VNPayConfig.hashAllFields(fields));
            
            if (!signValue.equals(vnp_SecureHash)) {
                response.getWriter().println("<html><body><h3>Lỗi: Chữ ký không hợp lệ!</h3></body></html>");
                return;
            }
            
            // Get payment result
            String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");
            String vnp_TxnRef = request.getParameter("vnp_TxnRef");
            
            // Get payment by transaction code (more reliable than session)
            Payments payment = paymentsDAO.getPaymentByTransactionCode(vnp_TxnRef);
            if (payment == null) {
                response.getWriter().println("<html><body><h3>Lỗi: Không tìm thấy thông tin thanh toán với mã giao dịch: " + vnp_TxnRef + "</h3></body></html>");
                return;
            }
            
            int paymentID = payment.getPaymentID();
            
            if ("00".equals(vnp_TransactionStatus)) {
                // Payment successful
                handleSuccessfulPayment(payment, vnp_TxnRef, request, response);
            } else {
                // Payment failed
                handleFailedPayment(paymentID, vnp_TxnRef, request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<html><body><h3>Lỗi hệ thống: " + e.getMessage() + "</h3></body></html>");
        }
    }
    
    private void handleSuccessfulPayment(Payments payment, String transactionCode, 
                                      HttpServletRequest request, HttpServletResponse response) 
                                      throws IOException {
        
        try {
            int paymentID = payment.getPaymentID();
            
            // Update payment status to success
            boolean updateSuccess = paymentsDAO.updatePaymentStatus(paymentID, "success", transactionCode);
            
            if (!updateSuccess) {
                response.getWriter().println("<html><body><h3>Lỗi: Không thể cập nhật trạng thái thanh toán!</h3></body></html>");
                return;
            }
            
            // Get payment details
            List<PaymentDetails> paymentDetails = paymentDetailsDAO.getPaymentDetailsByPaymentId(paymentID);
            
            // Create recruiter packages
            List<RecruiterPackages> recruiterPackages = new ArrayList<>();
            LocalDateTime now = LocalDateTime.now();
            
            for (PaymentDetails detail : paymentDetails) {
                // Get package info to calculate expiry date
                JobPackages jobPackage = jobPackagesDAO.getPackageById(detail.getPackageID());
                if (jobPackage == null) {
                    continue; // Skip if package not found
                }
                
                // Calculate expiry date based on package duration
                LocalDateTime expiryDate = now.plusDays(jobPackage.getDuration() != null ? jobPackage.getDuration() : 30);
                
                RecruiterPackages recruiterPackage = new RecruiterPackages();
                recruiterPackage.setRecruiterID(payment.getRecruiterID());
                recruiterPackage.setPackageID(detail.getPackageID());
                recruiterPackage.setQuantity(detail.getQuantity());
                recruiterPackage.setUsedQuantity(0);
                recruiterPackage.setPurchaseDate(now);
                recruiterPackage.setExpiryDate(expiryDate);
                recruiterPackage.setIsUsed(false);
                
                recruiterPackages.add(recruiterPackage);
            }
            
            // Save recruiter packages
            boolean packagesCreated = recruiterPackagesDAO.createRecruiterPackages(recruiterPackages);
            
            if (!packagesCreated) {
                response.getWriter().println("<html><body><h3>Cảnh báo: Thanh toán thành công nhưng không thể tạo gói dịch vụ!</h3></body></html>");
                return;
            }
            
            // Clear session
            request.getSession().removeAttribute("currentPaymentID");
            
            // Redirect to success page
            response.sendRedirect(request.getContextPath() + "/Recruiter/payment_success.jsp?paymentID=" + paymentID);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<html><body><h3>Lỗi xử lý thanh toán thành công: " + e.getMessage() + "</h3></body></html>");
        }
    }
    
    private void handleFailedPayment(int paymentID, String transactionCode, 
                                   HttpServletRequest request, HttpServletResponse response) 
                                   throws IOException {
        
        try {
            // Update payment status to failed
            paymentsDAO.updatePaymentStatus(paymentID, "failed", transactionCode);
            
            // Clear session
            request.getSession().removeAttribute("currentPaymentID");
            
            // Redirect to failure page
            response.sendRedirect(request.getContextPath() + "/Recruiter/payment_failure.jsp?paymentID=" + paymentID);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<html><body><h3>Lỗi xử lý thanh toán thất bại: " + e.getMessage() + "</h3></body></html>");
        }
    }
}