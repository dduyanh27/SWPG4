package dal;

import model.CV;
import model.CVDetail;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CVDAO extends DBContext {

    /* ==========================
       CRUD cơ bản cho JobSeeker
       ========================== */
    public List<CV> getCVsByJobSeekerId(int jobSeekerId) {
        List<CV> list = new ArrayList<>();
        String sql = "SELECT CVID, JobSeekerID, CVTitle, CVContent, CVURL, IsActive, CreationDate "
                + "FROM CVs WHERE JobSeekerID = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobSeekerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new CV(
                        rs.getInt("CVID"),
                        rs.getInt("JobSeekerID"),
                        rs.getString("CVTitle"),
                        rs.getString("CVContent"),
                        rs.getString("CVURL"),
                        rs.getBoolean("IsActive"),
                        rs.getDate("CreationDate")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public CV getCVById(int cvId) {
        String sql = "SELECT CVID, JobSeekerID, CVTitle, CVContent, CVURL, IsActive, CreationDate "
                + "FROM CVs WHERE CVID = ?";
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
        String sql = "INSERT INTO CVs (JobSeekerID, CVTitle, CVContent, CVURL, IsActive, CreationDate) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
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

    public boolean updateCVIsActive(int cvId, int isActive) {
        String sql = "UPDATE CVs SET IsActive = ? WHERE CVID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, isActive);
            ps.setInt(2, cvId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCV(int cvId) {
        String sql = "DELETE FROM CVs WHERE CVID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cvId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

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


    /* ==========================
       Dành cho Admin Dashboard
       ========================== */
    public List<CVDetail> getAllCVDetails() {
        List<CVDetail> list = new ArrayList<>();
        String sql = "SELECT c.CVID, c.JobSeekerID, c.CVTitle, c.CVContent, c.CVURL, "
                + "CASE WHEN c.IsActive = 1 THEN 'active' ELSE 'inactive' END as Status, "
                + "c.CreationDate, "
                + "COALESCE(c.ViewCount, 0) as Views, "
                + "COALESCE(js.FullName, 'N/A') as FullName, "
                + "COALESCE(js.Email, 'N/A') as Email, "
                + "COALESCE(js.Phone, 'N/A') as Phone, "
                + "COALESCE(js.Img, '') as AvatarURL, "
                + "COALESCE(js.Headline, 'N/A') as DesiredPosition, "
                + "COALESCE(js.Experience, '0') as Experience, "
                + "COALESCE(l.LocationName, 'N/A') as Location, "
                + "COALESCE(js.Skills, '') as Skills "
                + "FROM CVs c "
                + "LEFT JOIN JobSeeker js ON c.JobSeekerID = js.JobSeekerID "
                + "LEFT JOIN Locations l ON js.LocationID = l.LocationID "
                + "ORDER BY c.CreationDate DESC";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new CVDetail(
                        rs.getInt("CVID"),
                        rs.getInt("JobSeekerID"),
                        rs.getString("CVTitle"),
                        rs.getString("CVContent"),
                        rs.getString("CVURL"),
                        rs.getString("Status"),
                        rs.getDate("CreationDate"),
                        rs.getInt("Views"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("Phone"),
                        rs.getString("AvatarURL"),
                        rs.getString("DesiredPosition"),
                        rs.getString("Experience"),
                        rs.getString("Location"),
                        rs.getString("Skills")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<CVDetail> getCVDetailsWithFilter(String keyword, String status,
            String experience, String sortBy,
            int page, int pageSize) {
        List<CVDetail> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT c.CVID, c.JobSeekerID, c.CVTitle, c.CVContent, c.CVURL, ");
        sql.append("CASE WHEN c.IsActive = 1 THEN 'active' ELSE 'inactive' END as Status, ");
        sql.append("c.CreationDate, COALESCE(c.ViewCount, 0) as Views, ");
        sql.append("js.FullName, js.Email, js.Phone, js.Img as AvatarURL, ");
        sql.append("js.Headline as DesiredPosition, COALESCE(js.Experience, '0') as Experience, ");
        sql.append("l.LocationName as Location, COALESCE(js.Skills, '') as Skills ");
        sql.append("FROM CVs c ");
        sql.append("INNER JOIN JobSeeker js ON c.JobSeekerID = js.JobSeekerID ");
        sql.append("LEFT JOIN Locations l ON js.LocationID = l.LocationID ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filters
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (js.FullName LIKE ? OR js.Email LIKE ? OR js.Skills LIKE ?) ");
            String search = "%" + keyword.trim() + "%";
            params.add(search);
            params.add(search);
            params.add(search);
        }

        if ("active".equals(status)) {
            sql.append("AND c.IsActive = 1 ");
        } else if ("inactive".equals(status)) {
            sql.append("AND c.IsActive = 0 ");
        }

        if (experience != null && !experience.trim().isEmpty()) {
            switch (experience) {
                case "0-1":
                    sql.append("AND (js.Experience IS NULL OR js.Experience <= 1) ");
                    break;
                case "1-3":
                    sql.append("AND js.Experience BETWEEN 1 AND 3 ");
                    break;
                case "3-5":
                    sql.append("AND js.Experience BETWEEN 3 AND 5 ");
                    break;
                case "5+":
                    sql.append("AND js.Experience > 5 ");
                    break;
            }
        }

        // Sort
        switch (sortBy == null ? "newest" : sortBy) {
            case "oldest":
                sql.append("ORDER BY c.CreationDate ASC ");
                break;
            case "name":
                sql.append("ORDER BY js.FullName ASC ");
                break;
            default:
                sql.append("ORDER BY c.CreationDate DESC ");
                break;
        }

        // Pagination
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new CVDetail(
                        rs.getInt("CVID"),
                        rs.getInt("JobSeekerID"),
                        rs.getString("CVTitle"),
                        rs.getString("CVContent"),
                        rs.getString("CVURL"),
                        rs.getString("Status"),
                        rs.getDate("CreationDate"),
                        rs.getInt("Views"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("Phone"),
                        rs.getString("AvatarURL"),
                        rs.getString("DesiredPosition"),
                        rs.getString("Experience"),
                        rs.getString("Location"),
                        rs.getString("Skills")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalCVCount(String keyword, String status, String experience) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM CVs c ");
        sql.append("INNER JOIN JobSeeker js ON c.JobSeekerID = js.JobSeekerID ");
        sql.append("LEFT JOIN Locations l ON js.LocationID = l.LocationID ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (js.FullName LIKE ? OR js.Email LIKE ? OR js.Skills LIKE ?) ");
            String search = "%" + keyword.trim() + "%";
            params.add(search);
            params.add(search);
            params.add(search);
        }

        if ("active".equals(status)) {
            sql.append("AND c.IsActive = 1 ");
        } else if ("inactive".equals(status)) {
            sql.append("AND c.IsActive = 0 ");
        }

        if (experience != null && !experience.trim().isEmpty()) {
            switch (experience) {
                case "0-1":
                    sql.append("AND (js.Experience IS NULL OR js.Experience <= 1) ");
                    break;
                case "1-3":
                    sql.append("AND js.Experience BETWEEN 1 AND 3 ");
                    break;
                case "3-5":
                    sql.append("AND js.Experience BETWEEN 3 AND 5 ");
                    break;
                case "5+":
                    sql.append("AND js.Experience > 5 ");
                    break;
            }
        }

        try (PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Object[] getCVStatistics() {
        String sql = "SELECT "
                + "(SELECT COUNT(*) FROM CVs) as TotalCVs, "
                + "(SELECT COUNT(*) FROM CVs WHERE IsActive = 1) as ActiveCVs, "
                + "(SELECT COUNT(*) FROM CVs WHERE IsActive = 0) as PendingCVs, "
                + "0 as ViewsToday";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Object[]{
                    rs.getInt("TotalCVs"),
                    rs.getInt("ActiveCVs"),
                    rs.getInt("PendingCVs"),
                    rs.getInt("ViewsToday")
                };
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new Object[]{0, 0, 0, 0};
    }
}
