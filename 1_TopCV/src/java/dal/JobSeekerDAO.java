/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import model.JobSeeker;
import java.util.ArrayList;
import java.util.List;

public class JobSeekerDAO extends DBContext {
    
    public void testConnection() {
    String sql = "SELECT COUNT(*) as count FROM JobSeeker";
    try (PreparedStatement ps = c.prepareStatement(sql)) {
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            int count = rs.getInt("count");
            System.out.println("Database connected! Total JobSeekers: " + count);
        }
    } catch (Exception e) {
        System.out.println("Database connection failed: " + e.getMessage());
        e.printStackTrace();
    }
}
    //convert ResultSet -> JobSeeker
    private JobSeeker extractJobSeeker(ResultSet rs) throws SQLException {
        return new JobSeeker(
                rs.getInt("JobSeekerID"),
                rs.getString("Email"),
                rs.getString("Password"),
                rs.getString("FullName"),
                rs.getString("Phone"),
                rs.getString("Gender"),
                rs.getString("Headline"),
                rs.getString("ContactInfo"),
                rs.getString("Address"),
                (Integer) rs.getObject("LocationID"),   // dùng getObject để tránh lỗi khi null
                rs.getString("Img"),
                (Integer) rs.getObject("CurrentLevelID"),
                rs.getString("Status")
        );
    }
    public List<JobSeeker> getAllJobSeekers() {
        List<JobSeeker> list = new ArrayList<>();
        String sql = "SELECT * FROM JobSeeker";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                JobSeeker js = extractJobSeeker(rs);
                list.add(js);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public JobSeeker getJobSeekerById(int id) {
    String sql = "SELECT * FROM JobSeeker WHERE JobSeekerID = ?";
    System.out.println("Executing query: " + sql + " with ID: " + id);
    
    try (PreparedStatement ps = c.prepareStatement(sql)) {
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            JobSeeker js = extractJobSeeker(rs);
            System.out.println("JobSeeker found: " + js.getFullName());
            return js;
        } else {
            System.out.println("No JobSeeker found with ID: " + id);
        }
    } catch (Exception e) {
        System.out.println("Error in getJobSeekerById: " + e.getMessage());
        e.printStackTrace();
    }
    return null;
}
    
    public void updateProfileModal(JobSeeker js) {
        String sql = "UPDATE JobSeeker SET Email=?, FullName=?, Phone=?, Gender=?, " +
                "Headline=?, ContactInfo=?, Address=?, LocationID=?, CurrentLevelID=?, Status=? " +
                "WHERE JobSeekerID=?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, js.getEmail());
            ps.setString(2, js.getFullName());
            ps.setString(3, js.getPhone());
            ps.setString(4, js.getGender());
            ps.setString(5, js.getHeadline());
            ps.setString(6, js.getContactInfo());
            ps.setString(7, js.getAddress());
            ps.setInt(8, js.getLocationId());
            ps.setInt(9, js.getCurrentLevelId());
            ps.setString(10, js.getStatus());
            ps.setInt(11, js.getJobSeekerId());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

