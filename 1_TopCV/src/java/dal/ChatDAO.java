package dal;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import model.ChatMessage;
import model.Recruiter;

public class ChatDAO extends DBContext {

    public void saveMessages(ChatMessage msg) {
        String sql = "INSERT INTO ChatMessages (SenderRole, SenderID, ReceiverRole, ReceiverID, MessageContent, SentAt) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, msg.getSenderRole());
            ps.setInt(2, msg.getSenderID());
            ps.setString(3, msg.getReceiverRole());
            ps.setInt(4, msg.getReceiverID());
            ps.setString(5, msg.getMessageContent());
            ps.setTimestamp(6, new Timestamp(msg.getSentAt().getTime()));
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<ChatMessage> getChatHistory(String roleA, int idA, String roleB, int idB) {
        List<ChatMessage> list = new ArrayList<>();
        String sql = "SELECT * FROM ChatMessages WHERE \" +\n"
                + "                \"((SenderRole = ? AND SenderID = ? AND ReceiverRole = ? AND ReceiverID = ?) \" +\n"
                + "                \"OR (SenderRole = ? AND SenderID = ? AND ReceiverRole = ? AND ReceiverID = ?)) \" +\n"
                + "                \"ORDER BY SentAt ASC";
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, roleA);
            ps.setInt(2, idA);
            ps.setString(3, roleB);
            ps.setInt(4, idB);
            ps.setString(5, roleB);
            ps.setInt(6, idB);
            ps.setString(7, roleA);
            ps.setInt(8, idA);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new ChatMessage(
                        rs.getInt("MessageID"),
                        rs.getString("SenderRole"),
                        rs.getInt("SenderID"),
                        rs.getString("ReceiverRole"),
                        rs.getInt("ReceiverID"),
                        rs.getString("MessageContent"),
                        rs.getTimestamp("SentAt")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🧾 3. Lấy danh sách khách hàng đã nhắn với Admin
    public List<Integer> getUsersChattedWithAdmin() {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT DISTINCT SenderID FROM ChatMessages WHERE ReceiverRole = 'Admin'";
        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getInt("SenderID"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🧹 4. Xóa tin nhắn cũ (ví dụ > 30 ngày)
    public int deleteOldMessages(int days) {
        String sql = "DELETE FROM ChatMessages WHERE DATEDIFF(day, SentAt, GETDATE()) > ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, days);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Recruiter searchRcByName(String companyName) {
        Recruiter recruiter = null;

        StringBuilder sql = new StringBuilder("SELECT * FROM Recruiter WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (companyName != null && !companyName.trim().isEmpty()) {
            sql.append("AND CompanyName LIKE ? ");
            params.add("%" + companyName + "%");
        }
        if (params.isEmpty()) {
            return null;
        }

        try (PreparedStatement st = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                recruiter = new Recruiter();
                recruiter.setRecruiterID(rs.getInt("RecruiterID"));
                recruiter.setEmail(rs.getString("Email"));
                recruiter.setPassword(rs.getString("Password"));
                recruiter.setPhone(rs.getString("Phone"));
                recruiter.setCompanyName(rs.getString("CompanyName"));
                recruiter.setCompanyDescription(rs.getString("CompanyDescription"));
                recruiter.setCompanyLogoURL(rs.getString("CompanyLogoURL"));
                recruiter.setWebsite(rs.getString("Website"));
                recruiter.setImg(rs.getString("Img"));
                recruiter.setCategoryID(rs.getInt("CategoryID"));
                recruiter.setStatus(rs.getString("Status"));
                recruiter.setCompanyAddress(rs.getString("CompanyAddress"));
                recruiter.setCompanySize(rs.getString("CompanySize"));
                recruiter.setContactPerson(rs.getString("ContactPerson"));
                recruiter.setCompanyBenefits(rs.getString("CompanyBenefits"));
                recruiter.setCompanyVideoURL(rs.getString("CompanyVideoURL"));
                recruiter.setTaxcode(rs.getString("Taxcode"));
                recruiter.setRegistrationCert(rs.getString("RegistrationCert"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return recruiter;
    }

    // 🔍 Tìm kiếm danh sách nhà tuyển dụng
    public List<Recruiter> searchRecruiters(String searchTerm) {
        List<Recruiter> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Recruiter WHERE Status = 'Active' ");
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (CompanyName LIKE ? OR CompanyDescription LIKE ?) ");
        }
        
        sql.append("ORDER BY CompanyName ASC");
        
        try (PreparedStatement ps = c.prepareStatement(sql.toString())) {
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchPattern = "%" + searchTerm + "%";
                ps.setString(1, searchPattern);
                ps.setString(2, searchPattern);
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Recruiter recruiter = new Recruiter();
                recruiter.setRecruiterID(rs.getInt("RecruiterID"));
                recruiter.setEmail(rs.getString("Email"));
                recruiter.setPassword(rs.getString("Password"));
                recruiter.setPhone(rs.getString("Phone"));
                recruiter.setCompanyName(rs.getString("CompanyName"));
                recruiter.setCompanyDescription(rs.getString("CompanyDescription"));
                recruiter.setCompanyLogoURL(rs.getString("CompanyLogoURL"));
                recruiter.setWebsite(rs.getString("Website"));
                recruiter.setImg(rs.getString("Img"));
                recruiter.setCategoryID(rs.getInt("CategoryID"));
                recruiter.setStatus(rs.getString("Status"));
                recruiter.setCompanyAddress(rs.getString("CompanyAddress"));
                recruiter.setCompanySize(rs.getString("CompanySize"));
                recruiter.setContactPerson(rs.getString("ContactPerson"));
                recruiter.setCompanyBenefits(rs.getString("CompanyBenefits"));
                recruiter.setCompanyVideoURL(rs.getString("CompanyVideoURL"));
                recruiter.setTaxcode(rs.getString("Taxcode"));
                recruiter.setRegistrationCert(rs.getString("RegistrationCert"));
                list.add(recruiter);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 📋 Lấy tất cả nhà tuyển dụng
    public List<Recruiter> getAllRecruiters() {
        List<Recruiter> list = new ArrayList<>();
        String sql = "SELECT * FROM Recruiter WHERE Status = 'Active' ORDER BY CompanyName ASC";
        
        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Recruiter recruiter = new Recruiter();
                recruiter.setRecruiterID(rs.getInt("RecruiterID"));
                recruiter.setEmail(rs.getString("Email"));
                recruiter.setPassword(rs.getString("Password"));
                recruiter.setPhone(rs.getString("Phone"));
                recruiter.setCompanyName(rs.getString("CompanyName"));
                recruiter.setCompanyDescription(rs.getString("CompanyDescription"));
                recruiter.setCompanyLogoURL(rs.getString("CompanyLogoURL"));
                recruiter.setWebsite(rs.getString("Website"));
                recruiter.setImg(rs.getString("Img"));
                recruiter.setCategoryID(rs.getInt("CategoryID"));
                recruiter.setStatus(rs.getString("Status"));
                recruiter.setCompanyAddress(rs.getString("CompanyAddress"));
                recruiter.setCompanySize(rs.getString("CompanySize"));
                recruiter.setContactPerson(rs.getString("ContactPerson"));
                recruiter.setCompanyBenefits(rs.getString("CompanyBenefits"));
                recruiter.setCompanyVideoURL(rs.getString("CompanyVideoURL"));
                recruiter.setTaxcode(rs.getString("Taxcode"));
                recruiter.setRegistrationCert(rs.getString("RegistrationCert"));
                list.add(recruiter);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🎯 Lấy nhà tuyển dụng theo ID
    public Recruiter getRecruiterById(int recruiterId) {
        Recruiter recruiter = null;
        String sql = "SELECT * FROM Recruiter WHERE RecruiterID = ?";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                recruiter = new Recruiter();
                recruiter.setRecruiterID(rs.getInt("RecruiterID"));
                recruiter.setEmail(rs.getString("Email"));
                recruiter.setPassword(rs.getString("Password"));
                recruiter.setPhone(rs.getString("Phone"));
                recruiter.setCompanyName(rs.getString("CompanyName"));
                recruiter.setCompanyDescription(rs.getString("CompanyDescription"));
                recruiter.setCompanyLogoURL(rs.getString("CompanyLogoURL"));
                recruiter.setWebsite(rs.getString("Website"));
                recruiter.setImg(rs.getString("Img"));
                recruiter.setCategoryID(rs.getInt("CategoryID"));
                recruiter.setStatus(rs.getString("Status"));
                recruiter.setCompanyAddress(rs.getString("CompanyAddress"));
                recruiter.setCompanySize(rs.getString("CompanySize"));
                recruiter.setContactPerson(rs.getString("ContactPerson"));
                recruiter.setCompanyBenefits(rs.getString("CompanyBenefits"));
                recruiter.setCompanyVideoURL(rs.getString("CompanyVideoURL"));
                recruiter.setTaxcode(rs.getString("Taxcode"));
                recruiter.setRegistrationCert(rs.getString("RegistrationCert"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return recruiter;
    }

    // 💬 Lấy tin nhắn cuối cùng với nhà tuyển dụng
    public String getLastMessageWithRecruiter(int recruiterId) {
        String lastMessage = "";
        String sql = "SELECT TOP 1 MessageContent FROM ChatMessages " +
                    "WHERE (SenderID = ? AND SenderRole = 'Recruiter') " +
                    "OR (ReceiverID = ? AND ReceiverRole = 'Recruiter') " +
                    "ORDER BY SentAt DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            ps.setInt(2, recruiterId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                lastMessage = rs.getString("MessageContent");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lastMessage;
    }

    // 🔢 Đếm số tin nhắn chưa đọc từ nhà tuyển dụng
    public int getUnreadMessageCount(int recruiterId) {
        int count = 0;
        String sql = "SELECT COUNT(*) as unread_count FROM ChatMessages " +
                    "WHERE SenderID = ? AND SenderRole = 'Recruiter' " +
                    "AND IsRead = 0";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("unread_count");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // ⏰ Lấy thời gian tin nhắn cuối
    public String getLastMessageTime(int recruiterId) {
        String lastTime = "";
        String sql = "SELECT TOP 1 SentAt FROM ChatMessages " +
                    "WHERE (SenderID = ? AND SenderRole = 'Recruiter') " +
                    "OR (ReceiverID = ? AND ReceiverRole = 'Recruiter') " +
                    "ORDER BY SentAt DESC";
        
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            ps.setInt(2, recruiterId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Timestamp timestamp = rs.getTimestamp("SentAt");
                if (timestamp != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
                    lastTime = sdf.format(timestamp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lastTime;
    }
}
