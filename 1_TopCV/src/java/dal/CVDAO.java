package dal;

import model.CV;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CVDAO extends DBContext {

    public List<CV> getCVsByJobSeekerId(int jobSeekerId) {
        List<CV> list = new ArrayList<>();
        String sql = "SELECT CVID, JobSeekerID, CVTitle, CVContent, CVURL, IsActive, CreationDate " +
                     "FROM CVs WHERE JobSeekerID = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobSeekerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CV cv = new CV(
                        rs.getInt("CVID"),
                        rs.getInt("JobSeekerID"),
                        rs.getString("CVTitle"),
                        rs.getString("CVContent"),
                        rs.getString("CVURL"),
                        rs.getBoolean("IsActive"),
                        rs.getDate("CreationDate")
                );
                list.add(cv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public CV getCVById(int cvId) {
        String sql = "SELECT CVID, JobSeekerID, CVTitle, CVContent, CVURL, IsActive, CreationDate " +
                     "FROM CVs WHERE CVID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cvId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new CV(
                        rs.getInt("CVID"),
                        rs.getInt("JobSeekerID"),
                        rs.getString("CVTitle"),
                        rs.getString("CVContent"),
                        rs.getString("CVURL"),
                        rs.getBoolean("IsActive"),
                        rs.getDate("CreationDate")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public int insertCV(CV cv) {
        String sql = "INSERT INTO CVs (JobSeekerID, CVTitle, CVContent, CVURL, IsActive, CreationDate) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, cv.getJobSeekerId());
            ps.setString(2, cv.getCvTitle());
            ps.setString(3, cv.getCvContent());
            ps.setString(4, cv.getCvURL());
            ps.setBoolean(5, cv.isActive());
            ps.setTimestamp(6, new Timestamp(cv.getCreationDate().getTime()));
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    } 
    /**
     * Cập nhật trạng thái IsActive của CV (sử dụng int: 0 hoặc 1)
     * @param cvId ID của CV cần cập nhật
     * @param isActive 1 = Cho phép tìm kiếm, 0 = Không cho phép tìm kiếm
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateCVIsActive(int cvId, int isActive) {
        String sql = "UPDATE CVs SET IsActive = ? WHERE CVID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, isActive);
            ps.setInt(2, cvId);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Kiểm tra CV có thuộc về JobSeeker hay không
     * @param cvId ID của CV
     * @param jobSeekerId ID của JobSeeker
     * @return true nếu CV thuộc về JobSeeker, false nếu không
     */
    public boolean checkCVBelongsToJobSeeker(int cvId, int jobSeekerId) {
        String sql = "SELECT COUNT(*) FROM CVs WHERE CVID = ? AND JobSeekerID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cvId);
            ps.setInt(2, jobSeekerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Xóa CV theo ID
     * @param cvId ID của CV cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteCV(int cvId) {
        String sql = "DELETE FROM CVs WHERE CVID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cvId);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
