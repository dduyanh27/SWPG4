package util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Map;
import java.util.TreeMap;

public class VNPayConfig {
    public static String vnp_PayUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static String vnp_ReturnUrl = "http://localhost:9999/1_TopCV/payment-return";
    public static String vnp_TmnCode = "ENG3I3LH";
    public static String vnp_HashSecret = "QS3HAQHG3JCO5OXQ4LG2R42L1BPX62DZ";

    public static String hmacSHA512(final String key, final String data) {
        try {
            if (key == null || data == null) {
                throw new NullPointerException();
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes();
            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            return "";
        }
    }

    public static String hashAllFields(Map<String, String> fields) {
        // Remove sign fields
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");
        
        // Create hash data
        TreeMap<String, String> sortedFields = new TreeMap<>(fields);
        StringBuilder hashData = new StringBuilder();
        
        for (Map.Entry<String, String> entry : sortedFields.entrySet()) {
            if (entry.getValue() != null && !entry.getValue().isEmpty()) {
                hashData.append(entry.getKey()).append('=');
                hashData.append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8));
                hashData.append('&');
            }
        }
        
        // Remove last '&'
        if (hashData.length() > 0) {
            hashData.setLength(hashData.length() - 1);
        }
        
        return hashData.toString();
    }
}