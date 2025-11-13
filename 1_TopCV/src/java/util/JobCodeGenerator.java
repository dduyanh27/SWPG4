package util;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class JobCodeGenerator {
    private static final String CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    private static final int CODE_LENGTH = 8;
    private static final SecureRandom random = new SecureRandom();
    
    /**
     * Generate a unique job code
     * Format: YYMMDD-XXXXXX (Date prefix + random alphanumeric)
     * Example: 241215-A3B9C2D1
     */
    public static String generateJobCode() {
        // Get current date in YYMMDD format
        String datePrefix = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyMMdd"));
        
        // Generate random suffix
        StringBuilder suffix = new StringBuilder();
        for (int i = 0; i < CODE_LENGTH; i++) {
            suffix.append(CHARS.charAt(random.nextInt(CHARS.length())));
        }
        
        return datePrefix + "-" + suffix.toString();
    }
    
    /**
     * Generate a job code with custom prefix
     */
    public static String generateJobCode(String prefix) {
        StringBuilder suffix = new StringBuilder();
        for (int i = 0; i < CODE_LENGTH; i++) {
            suffix.append(CHARS.charAt(random.nextInt(CHARS.length())));
        }
        
        return prefix + "-" + suffix.toString();
    }
}

