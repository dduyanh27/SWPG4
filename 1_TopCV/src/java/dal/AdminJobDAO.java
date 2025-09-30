package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.AdminJobDetail;
import model.Job;

public class AdminJobDAO extends DBContext {

    public List<Job> getAllJobs() {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT * FROM Jobs";
        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Job job = new Job(
                        rs.getInt("JobID"),
                        rs.getInt("RecruiterID"),
                        rs.getString("JobTitle"),
                        rs.getString("Description"),
                        rs.getString("Requirements"),
                        rs.getInt("JobLevelID"),
                        rs.getInt("LocationID"),
                        rs.getString("SalaryRange"),
                        rs.getTimestamp("PostingDate").toLocalDateTime(),
                        rs.getTimestamp("ExpirationDate").toLocalDateTime(),
                        rs.getInt("CategoryID"),
                        rs.getInt("AgeRequirement"),
                        rs.getString("Status"),
                        rs.getInt("JobTypeID"),
                        rs.getInt("HiringCount")
                );
                list.add(job);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy Job theo ID
    public Job getJobById(int jobId) {
        String sql = "SELECT * FROM Jobs WHERE JobID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Job(
                            rs.getInt("JobID"),
                            rs.getInt("RecruiterID"),
                            rs.getString("JobTitle"),
                            rs.getString("Description"),
                            rs.getString("Requirements"),
                            rs.getInt("JobLevelID"),
                            rs.getInt("LocationID"),
                            rs.getString("SalaryRange"),
                            rs.getTimestamp("PostingDate").toLocalDateTime(),
                            rs.getTimestamp("ExpirationDate").toLocalDateTime(),
                            rs.getInt("CategoryID"),
                            rs.getInt("AgeRequirement"),
                            rs.getString("Status"),
                            rs.getInt("JobTypeID"),
                            rs.getInt("HiringCount")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteJob(int jobId) {
        String sql = "DELETE FROM Jobs WHERE JobID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm job mới
    public boolean addJob(Job job) {
        String sql = "INSERT INTO Jobs (RecruiterID, JobTitle, Description, Requirements, JobLevelID, LocationID, SalaryRange, PostingDate, ExpirationDate, CategoryID, AgeRequirement, Status, JobTypeID, HiringCount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, job.getRecruiterID());
            ps.setString(2, job.getJobTitle());
            ps.setString(3, job.getDescription());
            ps.setString(4, job.getRequirements());
            ps.setInt(5, job.getJobLevelID());
            ps.setInt(6, job.getLocationID());
            ps.setString(7, job.getSalaryRange());
            ps.setTimestamp(8, java.sql.Timestamp.valueOf(job.getPostingDate()));
            ps.setTimestamp(9, java.sql.Timestamp.valueOf(job.getExpirationDate()));
            ps.setInt(10, job.getCategoryID());
            ps.setInt(11, job.getAgeRequirement());
            ps.setString(12, job.getStatus());
            ps.setInt(13, job.getJobTypeID());
            ps.setInt(14, job.getHiringCount());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật job
    public boolean updateJob(Job job) {
        String sql = "UPDATE Jobs SET RecruiterID=?, JobTitle=?, Description=?, Requirements=?, JobLevelID=?, LocationID=?, SalaryRange=?, PostingDate=?, ExpirationDate=?, CategoryID=?, AgeRequirement=?, Status=?, JobTypeID=?, HiringCount=? WHERE JobID=?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, job.getRecruiterID());
            ps.setString(2, job.getJobTitle());
            ps.setString(3, job.getDescription());
            ps.setString(4, job.getRequirements());
            ps.setInt(5, job.getJobLevelID());
            ps.setInt(6, job.getLocationID());
            ps.setString(7, job.getSalaryRange());
            ps.setTimestamp(8, java.sql.Timestamp.valueOf(job.getPostingDate()));
            ps.setTimestamp(9, java.sql.Timestamp.valueOf(job.getExpirationDate()));
            ps.setInt(10, job.getCategoryID());
            ps.setInt(11, job.getAgeRequirement());
            ps.setString(12, job.getStatus());
            ps.setInt(13, job.getJobTypeID());
            ps.setInt(14, job.getHiringCount());
            ps.setInt(15, job.getJobID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy danh sách job theo status
    public List<Job> getJobsByStatus(String status) {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT * FROM Jobs WHERE Status = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Job job = new Job(
                            rs.getInt("JobID"),
                            rs.getInt("RecruiterID"),
                            rs.getString("JobTitle"),
                            rs.getString("Description"),
                            rs.getString("Requirements"),
                            rs.getInt("JobLevelID"),
                            rs.getInt("LocationID"),
                            rs.getString("SalaryRange"),
                            rs.getTimestamp("PostingDate").toLocalDateTime(),
                            rs.getTimestamp("ExpirationDate").toLocalDateTime(),
                            rs.getInt("CategoryID"),
                            rs.getInt("AgeRequirement"),
                            rs.getString("Status"),
                            rs.getInt("JobTypeID"),
                            rs.getInt("HiringCount")
                    );
                    list.add(job);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách job theo category
    public List<Job> getJobsByCategory(int categoryID) {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT * FROM Jobs WHERE CategoryID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, categoryID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Job job = new Job(
                            rs.getInt("JobID"),
                            rs.getInt("RecruiterID"),
                            rs.getString("JobTitle"),
                            rs.getString("Description"),
                            rs.getString("Requirements"),
                            rs.getInt("JobLevelID"),
                            rs.getInt("LocationID"),
                            rs.getString("SalaryRange"),
                            rs.getTimestamp("PostingDate").toLocalDateTime(),
                            rs.getTimestamp("ExpirationDate").toLocalDateTime(),
                            rs.getInt("CategoryID"),
                            rs.getInt("AgeRequirement"),
                            rs.getString("Status"),
                            rs.getInt("JobTypeID"),
                            rs.getInt("HiringCount")
                    );
                    list.add(job);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //lay jobdetail
    public List<AdminJobDetail> getAllDetailJob() {
        List<AdminJobDetail> list = new ArrayList<>();
        String sql = "SELECT j.JobID, j.JobTitle, j.Requirements, j.SalaryRange, j.Status, "
                + "       r.CompanyName AS RecruiterName, c.CategoryName, l.LocationName "
                + "FROM Jobs j "
                + "LEFT JOIN Recruiter r ON j.RecruiterID = r.RecruiterID "
                + "LEFT JOIN Categories c ON j.CategoryID = c.CategoryID "
                + "LEFT JOIN Locations l ON j.LocationID = l.LocationID";

        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AdminJobDetail jobDetail = new AdminJobDetail(
                        rs.getInt("JobID"),
                        rs.getString("JobTitle"),
                        rs.getString("Requirements"),
                        rs.getString("SalaryRange"),
                        rs.getString("RecruiterName"),
                        rs.getString("CategoryName"),
                        rs.getString("LocationName"),
                        rs.getString("Status")
                );
                list.add(jobDetail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Cập nhật status của job
    public boolean updateJobStatus(int jobId, String status) {
        String sql = "UPDATE Jobs SET Status = ? WHERE JobID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, jobId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đếm tổng số job
    public int getTotalJobCount() {
        String sql = "SELECT COUNT(*) FROM Jobs";
        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm số job theo status
    public int getJobCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Jobs WHERE Status = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //hàm approve job
    public void approveJobs(int jobId) {
        String sql = "UPDATE Jobs\n"
                + "SET Status = 'Published'\n"
                + "WHERE JobID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Cập nhật thành công: " + rowsAffected + " job đã được publish.");
            } else {
                System.out.println("Không tìm thấy job với ID = " + jobId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    //xoa job
    public void closeJobs(int jobId) {
        String sql = "UPDATE Jobs\n"
                + "SET Status = 'Closed'\n"
                + "WHERE JobID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Xóa thành công!");
            } else {
                System.out.println("Không tìm thấy job với ID = " + jobId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        AdminJobDAO dao = new AdminJobDAO();

        // Test 1: Lấy tất cả jobs
        System.out.println("===== Danh sách tất cả Jobs =====");
        for (Job job : dao.getAllJobs()) {
            System.out.println(job);
        }

        // Test 2: Lấy Job theo ID
        System.out.println("\n===== Job có ID = 1 =====");
        Job job = dao.getJobById(1);
        if (job != null) {
            System.out.println(job);
        } else {
            System.out.println("Không tìm thấy Job có ID = 1");
        }

        // Test 3: Lấy jobs theo status
        System.out.println("\n===== Jobs có Status = 'Active' =====");
        for (Job activeJob : dao.getJobsByStatus("Active")) {
            System.out.println(activeJob);
        }

        // Test 4: Lấy jobs theo category
        System.out.println("\n===== Jobs có CategoryID = 1 =====");
        for (Job categoryJob : dao.getJobsByCategory(1)) {
            System.out.println(categoryJob);
        }

        // Test 5: Đếm tổng số jobs
        System.out.println("\n===== Thống kê Jobs =====");
        System.out.println("Tổng số jobs: " + dao.getTotalJobCount());
        System.out.println("Số jobs Active: " + dao.getJobCountByStatus("Active"));
        System.out.println("Số jobs Inactive: " + dao.getJobCountByStatus("Inactive"));

        // Test 6: Cập nhật status job
        System.out.println("\n===== Cập nhật Status Job ID = 1 =====");
        boolean updated = dao.updateJobStatus(1, "Inactive");
        System.out.println("Kết quả cập nhật status: " + updated);

        // Test 7: Xóa Job theo ID
        System.out.println("\n===== Xóa Job có ID = 10 =====");
        boolean deleted = dao.deleteJob(10);
        System.out.println("Kết quả xóa: " + deleted);
    }
}
