package dal;

import model.Token;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 * Data Access Object for Token management
 * @author ADMIN
 */
public class TokenDAO extends DBContext {

    /**
     * Insert a new token for password reset
     */
    public boolean insertTokenForget(Token tokenForget) {
        if (c == null) {
            System.err.println("Database connection is null in TokenDAO.insertTokenForget");
            return false;
        }
        
        String sql = "INSERT INTO Token (token, expiryTime, isUsed, userId, userType) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, tokenForget.getToken());
            ps.setTimestamp(2, Timestamp.valueOf(tokenForget.getExpiryTime()));
            ps.setBoolean(3, tokenForget.isUsed());
            ps.setInt(4, tokenForget.getUserId());
            ps.setString(5, tokenForget.getUserType());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get token by token string
     */
    public Token getTokenPassword(String token) {
        if (c == null) {
            System.err.println("Database connection is null in TokenDAO.getTokenPassword");
            return null;
        }
        
        String sql = "SELECT * FROM Token WHERE token = ?";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            st.setString(1, token);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Token(
                            rs.getInt("id"),
                            rs.getInt("userId"),
                            rs.getString("userType"),
                            rs.getBoolean("isUsed"),
                            rs.getString("token"),
                            rs.getTimestamp("expiryTime").toLocalDateTime()
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get active token by userId and userType
     */
    public Token getActiveTokenByUser(int userId, String userType) {
        if (c == null) {
            System.err.println("Database connection is null in TokenDAO.getActiveTokenByUser");
            return null;
        }
        
        String sql = "SELECT * FROM Token WHERE userId = ? AND userType = ? AND isUsed = 0 AND expiryTime > ?";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setString(2, userType);
            st.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Token(
                            rs.getInt("id"),
                            rs.getInt("userId"),
                            rs.getString("userType"),
                            rs.getBoolean("isUsed"),
                            rs.getString("token"),
                            rs.getTimestamp("expiryTime").toLocalDateTime()
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Delete existing tokens for user before inserting new one
     */
    public boolean deleteExistingTokens(int userId, String userType) {
        if (c == null) {
            System.err.println("Database connection is null in TokenDAO.deleteExistingTokens");
            return false;
        }
        
        String sql = "DELETE FROM Token WHERE userId = ? AND userType = ?";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setString(2, userType);
            return st.executeUpdate() >= 0; // >= 0 because no rows to delete is also OK
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update token status (mark as used)
     */
    public void updateStatus(Token token) {
        if (c == null) {
            System.err.println("Database connection is null in TokenDAO.updateStatus");
            return;
        }
        
        String sql = "UPDATE Token SET isUsed = ? WHERE token = ?";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            st.setBoolean(1, token.isUsed());
            st.setString(2, token.getToken());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Clean up expired tokens
     */
    public void cleanupExpiredTokens() {
        String sql = "DELETE FROM Token WHERE expiryTime < ?";
        try (PreparedStatement st = c.prepareStatement(sql)) {
            st.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
