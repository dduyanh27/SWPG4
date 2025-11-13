package util;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 * Service for sending emails to candidates (accept/reject notifications)
 * @author ADMIN
 */
public class CandidateEmailService {
    
    static final String from = "min257358@gmail.com"; // Thay đổi email của bạn
    static final String password = "rhdm aawk bayt zlhv"; // Thay đổi app password của bạn
    
    /**
     * Send acceptance email to candidate
     * @param to Candidate email
     * @param candidateName Candidate full name
     * @param jobTitle Job title
     * @param companyName Company name
     * @param recruiterPhone Recruiter phone number
     * @param companyAddress Company address
     * @return true if email sent successfully, false otherwise
     */
    public boolean sendAcceptanceEmail(String to, String candidateName, String jobTitle, String companyName, String recruiterPhone, String companyAddress) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        Session session = Session.getInstance(props, auth);
        MimeMessage msg = new MimeMessage(session);

        try {
            msg.addHeader("Content-type", "text/html; charset=UTF-8");
            msg.setFrom(new InternetAddress(from));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject("Chúc mừng! Bạn đã được chấp nhận cho vị trí " + jobTitle, "UTF-8");

            String content = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;'>"
                    + "<h2 style='color: #4caf50;'>🎉 Chúc Mừng!</h2>"
                    + "<h3>Xin chào " + (candidateName != null ? candidateName : "Ứng viên") + ",</h3>"
                    + "<p>Chúng tôi rất vui mừng thông báo rằng bạn đã được <strong style='color: #4caf50;'>chấp nhận</strong> cho vị trí:</p>"
                    + "<div style='background: #f5f5f5; padding: 15px; border-radius: 8px; margin: 20px 0;'>"
                    + "<p style='margin: 0;'><strong>Vị trí:</strong> " + (jobTitle != null ? jobTitle : "N/A") + "</p>"
                    + "<p style='margin: 5px 0 0 0;'><strong>Công ty:</strong> " + (companyName != null ? companyName : "N/A") + "</p>"
                    + "</div>"
                    + "<p>Chúng tôi đánh giá cao sự quan tâm của bạn và tin rằng bạn sẽ là một bổ sung tuyệt vời cho đội ngũ của chúng tôi.</p>"
                    + "<p><strong>Bước tiếp theo:</strong></p>"
                    + "<ul>"
                    + "<li>Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất để thảo luận về các bước tiếp theo</li>"
                    + "<li>Vui lòng chuẩn bị các tài liệu cần thiết theo yêu cầu</li>"
                    + "<li>Nếu bạn có bất kỳ câu hỏi nào, đừng ngần ngại liên hệ với chúng tôi</li>"
                    + "</ul>"
                    + "<div style='background: #e8f5e9; padding: 15px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #4caf50;'>"
                    + "<p style='margin: 0 0 8px 0;'><strong>📞 Thông tin liên hệ:</strong></p>"
                    + "<p style='margin: 5px 0;'><strong>Điện thoại:</strong> " + (recruiterPhone != null && !recruiterPhone.isEmpty() ? recruiterPhone : "N/A") + "</p>"
                    + "<p style='margin: 5px 0;'><strong>Địa chỉ:</strong> " + (companyAddress != null && !companyAddress.isEmpty() ? companyAddress : "N/A") + "</p>"
                    + "</div>"
                    + "<p>Chúng tôi mong chờ được làm việc với bạn!</p>"
                    + "<p>Trân trọng,<br><strong>Đội Ngũ Tuyển Dụng<br>" + (companyName != null ? companyName : "Công Ty") + "</strong></p>"
                    + "</div>";

            msg.setContent(content, "text/html; charset=UTF-8");
            Transport.send(msg);
            System.out.println("DEBUG CandidateEmailService: Acceptance email sent successfully to: " + to);
            return true;
        } catch (Exception e) {
            System.out.println("DEBUG CandidateEmailService: Error sending acceptance email to: " + to);
            System.out.println("DEBUG CandidateEmailService: Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Send rejection email to candidate
     * @param to Candidate email
     * @param candidateName Candidate full name
     * @param jobTitle Job title
     * @param companyName Company name
     * @return true if email sent successfully, false otherwise
     */
    public boolean sendRejectionEmail(String to, String candidateName, String jobTitle, String companyName) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        Session session = Session.getInstance(props, auth);
        MimeMessage msg = new MimeMessage(session);

        try {
            msg.addHeader("Content-type", "text/html; charset=UTF-8");
            msg.setFrom(new InternetAddress(from));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject("Thông báo về đơn ứng tuyển của bạn - " + jobTitle, "UTF-8");

            String content = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;'>"
                    + "<h2 style='color: #666;'>Thông Báo</h2>"
                    + "<h3>Xin chào " + (candidateName != null ? candidateName : "Ứng viên") + ",</h3>"
                    + "<p>Cảm ơn bạn đã quan tâm và nộp đơn ứng tuyển cho vị trí:</p>"
                    + "<div style='background: #f5f5f5; padding: 15px; border-radius: 8px; margin: 20px 0;'>"
                    + "<p style='margin: 0;'><strong>Vị trí:</strong> " + (jobTitle != null ? jobTitle : "N/A") + "</p>"
                    + "<p style='margin: 5px 0 0 0;'><strong>Công ty:</strong> " + (companyName != null ? companyName : "N/A") + "</p>"
                    + "</div>"
                    + "<p>Sau khi xem xét kỹ lưỡng hồ sơ của bạn, chúng tôi rất tiếc phải thông báo rằng chúng tôi đã quyết định không tiếp tục với đơn ứng tuyển của bạn cho vị trí này tại thời điểm hiện tại.</p>"
                    + "<p>Chúng tôi đánh giá cao thời gian và sự quan tâm mà bạn đã dành cho công ty của chúng tôi. Chúng tôi tin rằng bạn sẽ tìm được cơ hội phù hợp khác trong tương lai.</p>"
                    + "<p>Chúng tôi khuyến khích bạn tiếp tục theo dõi các cơ hội việc làm khác của chúng tôi và chúng tôi mong muốn được gặp lại bạn trong các đợt tuyển dụng sắp tới.</p>"
                    + "<p>Trân trọng,<br><strong>Đội Ngũ Tuyển Dụng<br>" + (companyName != null ? companyName : "Công Ty") + "</strong></p>"
                    + "</div>";

            msg.setContent(content, "text/html; charset=UTF-8");
            Transport.send(msg);
            System.out.println("DEBUG CandidateEmailService: Rejection email sent successfully to: " + to);
            return true;
        } catch (Exception e) {
            System.out.println("DEBUG CandidateEmailService: Error sending rejection email to: " + to);
            System.out.println("DEBUG CandidateEmailService: Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}

