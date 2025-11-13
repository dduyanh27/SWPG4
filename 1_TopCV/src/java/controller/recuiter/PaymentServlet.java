package controller.recuiter;

import dal.PaymentsDAO;
import dal.PaymentDetailsDAO;
import dal.JobPackagesDAO;
import model.Payments;
import model.Recruiter;
import model.PaymentDetails;
import model.JobPackages;
import util.VNPayConfig;
import util.SessionHelper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.*;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {
    
    private PaymentsDAO paymentsDAO = new PaymentsDAO();
    private PaymentDetailsDAO paymentDetailsDAO = new PaymentDetailsDAO();
    private JobPackagesDAO jobPackagesDAO = new JobPackagesDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        try {
            // Get cart data from session
            String cartData = request.getParameter("cartData");
            String cartSubtotal = request.getParameter("cartSubtotal");
            String cartVAT = request.getParameter("cartVAT");
            String cartTotal = request.getParameter("cartTotal");
            
            if (cartData == null || cartData.isEmpty()) {
                response.getWriter().println("Lỗi: Không có dữ liệu giỏ hàng!");
                return;
            }
            
            // Parse cart data
            List<Map<String, Object>> cart = parseCartData(cartData);
            if (cart.isEmpty()) {
                response.getWriter().println("Lỗi: Giỏ hàng trống!");
                return;
            }
            // VALIDATION: chỉ cho phép mua 1 loại gói (có thể nhiều số lượng)
            Set<String> uniqueTitles = new HashSet<>();
            int mergedQuantity = 0;
            String mergedTitle = null;
            int mergedPrice = 0;
            for (Map<String, Object> item : cart) {
                String title = (String) item.get("title");
                uniqueTitles.add(title);
            }
            if (uniqueTitles.size() > 1) {
                response.getWriter().println("Lỗi: Chỉ được phép mua 1 gói duy nhất trong một đơn hàng.");
                return;
            }
            // Gộp số lượng cho cùng một gói (đề phòng dữ liệu trùng)
            mergedTitle = (String) cart.get(0).get("title");
            for (Map<String, Object> item : cart) {
                mergedQuantity += (Integer) item.get("quantity");
                mergedPrice = Integer.parseInt(item.get("price").toString());
            }
            
            // Get recruiter from session
            Recruiter recruiter = SessionHelper.getCurrentRecruiter(request);
            if (recruiter == null) {
                response.getWriter().println("Lỗi: Bạn chưa đăng nhập với tư cách nhà tuyển dụng!");
                return;
            }
            int recruiterID = recruiter.getRecruiterID();
            
            // Calculate total amount
            BigDecimal totalAmount = new BigDecimal(cartTotal);
            
            // Create payment record
            Payments payment = new Payments();
            payment.setRecruiterID(recruiterID);
            payment.setAmount(totalAmount);
            payment.setPaymentMethod("VNPAY");
            payment.setPaymentStatus("pending");
            payment.setTransactionCode("TXN_" + System.currentTimeMillis());
            payment.setPaymentDate(LocalDateTime.now());
            payment.setNotes("Thanh toán gói dịch vụ tuyển dụng");
            
            // Save payment to database
            int paymentID = paymentsDAO.createPayment(payment);
            if (paymentID == -1) {
                response.getWriter().println("Lỗi: Không thể tạo bản ghi thanh toán!");
                return;
            }
            
            // Create payment details
            List<PaymentDetails> paymentDetails = new ArrayList<>();
            System.out.println("Creating payment details for " + cart.size() + " items");
            
            // Dùng bản ghi duy nhất với tổng số lượng
            {
                String packageName = mergedTitle;
                int quantity = mergedQuantity;
                BigDecimal price = new BigDecimal(String.valueOf(mergedPrice));
                System.out.println("Processing merged item: " + packageName + ", quantity: " + quantity + ", price: " + price);
                int packageID = getPackageIdByName(packageName);
                if (packageID == -1) {
                    System.out.println("Package not found: " + packageName);
                    response.getWriter().println("Lỗi: Không tìm thấy gói dịch vụ: " + packageName);
                    return;
                }
                PaymentDetails detail = new PaymentDetails();
                detail.setPaymentID(paymentID);
                detail.setPackageID(packageID);
                detail.setQuantity(quantity);
                detail.setUnitPrice(price);
                paymentDetails.add(detail);
                System.out.println("Added merged payment detail: PaymentID=" + paymentID + ", PackageID=" + packageID + ", Quantity=" + quantity);
            }
            
            System.out.println("Total payment details to create: " + paymentDetails.size());
            
            // Save payment details
            if (!paymentDetailsDAO.createPaymentDetails(paymentDetails)) {
                response.getWriter().println("Lỗi: Không thể tạo chi tiết thanh toán!");
                return;
            }
            
            // Store payment ID in session for return processing
            request.getSession().setAttribute("currentPaymentID", paymentID);
            
            // Create VNPay payment URL
            String vnpUrl = createVNPayPaymentUrl(payment, totalAmount);
            
            // Redirect to VNPay
            response.sendRedirect(vnpUrl);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi hệ thống: " + e.getMessage());
        }
    }
    
    private List<Map<String, Object>> parseCartData(String cartData) {
        List<Map<String, Object>> cart = new ArrayList<>();
        try {
            // Simple JSON parsing for cart data
            // Format: [{"title":"Package Name","price":199000,"quantity":1},...]
            System.out.println("Raw cart data: " + cartData);
            
            // Remove outer brackets
            String cleanData = cartData.trim();
            if (cleanData.startsWith("[") && cleanData.endsWith("]")) {
                cleanData = cleanData.substring(1, cleanData.length() - 1);
            }
            
            // Split by },{ to get individual items
            String[] items = cleanData.split("\\},\\s*\\{");
            
            for (int i = 0; i < items.length; i++) {
                String item = items[i];
                // Remove remaining braces
                item = item.replaceAll("[{}]", "");
                
                Map<String, Object> cartItem = new HashMap<>();
                String[] pairs = item.split(",");
                
                for (String pair : pairs) {
                    String[] keyValue = pair.split(":");
                    if (keyValue.length == 2) {
                        String key = keyValue[0].replaceAll("\"", "").trim();
                        String value = keyValue[1].replaceAll("\"", "").trim();
                        
                        if ("title".equals(key)) {
                            cartItem.put("title", value);
                        } else if ("price".equals(key)) {
                            cartItem.put("price", Integer.parseInt(value));
                        } else if ("quantity".equals(key)) {
                            cartItem.put("quantity", Integer.parseInt(value));
                        }
                    }
                }
                
                // Only add if we have all required fields
                if (cartItem.containsKey("title") && cartItem.containsKey("price") && cartItem.containsKey("quantity")) {
                    cart.add(cartItem);
                    System.out.println("Parsed item: " + cartItem);
                }
            }
            
            System.out.println("Total parsed items: " + cart.size());
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error parsing cart data: " + e.getMessage());
        }
        return cart;
    }
    
    private int getPackageIdByName(String packageName) {
        // Get all packages and find by name
        List<model.JobPackages> packages = jobPackagesDAO.getAllPackages();
        System.out.println("Searching for package: '" + packageName + "'");
        System.out.println("Available packages:");
        
        for (model.JobPackages pkg : packages) {
            System.out.println("  - ID: " + pkg.getPackageID() + ", Name: '" + pkg.getPackageName() + "'");
            if (packageName.equals(pkg.getPackageName())) {
                System.out.println("  ✓ MATCH FOUND: " + pkg.getPackageID());
                return pkg.getPackageID();
            }
        }
        
        System.out.println("  ✗ NO MATCH FOUND for: '" + packageName + "'");
        return -1;
    }
    
    private String createVNPayPaymentUrl(Payments payment, BigDecimal amount) {
        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String vnp_OrderInfo = "Thanh toan goi dich vu tuyen dung - " + payment.getTransactionCode();
        String orderType = "topup";
        String vnp_TxnRef = payment.getTransactionCode();
        String vnp_IpAddr = "127.0.0.1"; // TODO: Get real IP
        String vnp_TmnCode = VNPayConfig.vnp_TmnCode;

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount.multiply(new BigDecimal(100)).intValue()));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
        vnp_Params.put("vnp_OrderType", orderType);
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        
        for (String fieldName : fieldNames) {
            String fieldValue = vnp_Params.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                hashData.append(fieldName).append('=')
                        .append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8))
                        .append('&');
                query.append(fieldName).append('=')
                        .append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8))
                        .append('&');
            }
        }
        
        String queryUrl = query.substring(0, query.length() - 1);
        String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.substring(0, hashData.length() - 1));
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;

        return VNPayConfig.vnp_PayUrl + "?" + queryUrl;
    }
}