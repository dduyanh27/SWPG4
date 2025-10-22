package dal;

import java.sql.*;
import java.util.*;
import model.Campaign;

public class CampaignDAO extends DBContext {

    public List<Campaign> getAllActiveCampaigns() {
        List<Campaign> campaigns = new ArrayList<>();
        String sql = "SELECT c.*, a.FullName as CreatorName "
                + "FROM Campaigns c "
                + "LEFT JOIN Admins a ON c.CreatedBy = a.AdminID "
                + "WHERE c.Status = 'Running' "
                + "ORDER BY c.CreatedAt DESC";

        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Campaign campaign = new Campaign();
                campaign.setCampaignID(rs.getInt("CampaignID"));
                campaign.setCampaignName(rs.getString("CampaignName"));
                campaign.setTargetType(rs.getString("TargetType"));
                campaign.setPlatform(rs.getString("Platform"));
                campaign.setBudget(rs.getBigDecimal("Budget"));
                campaign.setStartDate(rs.getDate("StartDate"));
                campaign.setEndDate(rs.getDate("EndDate"));
                campaign.setStatus(rs.getString("Status"));
                campaign.setDescription(rs.getString("Description"));
                campaign.setCreatedBy(rs.getInt("CreatedBy"));
                campaign.setCreatedAt(rs.getTimestamp("CreatedAt"));
                campaign.setCreatorName(rs.getString("CreatorName"));

                campaigns.add(campaign);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return campaigns;
    }

    public List<Campaign> getAllCampaigns() {
        List<Campaign> campaigns = new ArrayList<>();
        String sql = "SELECT c.*, a.FullName as CreatorName "
                + "FROM Campaigns c "
                + "LEFT JOIN Admins a ON c.CreatedBy = a.AdminID "
                + "ORDER BY c.CreatedAt DESC";

        try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Campaign campaign = new Campaign();
                campaign.setCampaignID(rs.getInt("CampaignID"));
                campaign.setCampaignName(rs.getString("CampaignName"));
                campaign.setTargetType(rs.getString("TargetType"));
                campaign.setPlatform(rs.getString("Platform"));
                campaign.setBudget(rs.getBigDecimal("Budget"));
                campaign.setStartDate(rs.getDate("StartDate"));
                campaign.setEndDate(rs.getDate("EndDate"));
                campaign.setStatus(rs.getString("Status"));
                campaign.setDescription(rs.getString("Description"));
                campaign.setCreatedBy(rs.getInt("CreatedBy"));
                campaign.setCreatedAt(rs.getTimestamp("CreatedAt"));
                campaign.setCreatorName(rs.getString("CreatorName"));

                campaigns.add(campaign);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return campaigns;
    }

    //search
    public List<Campaign> searchCampaigns(String search) {
        List<Campaign> campaigns = new ArrayList<>();
        String sql = "SELECT c.*, a.FullName as CreatorName "
                + "FROM Campaigns c "
                + "LEFT JOIN Admins a ON c.CreatedBy = a.AdminID "
                + "WHERE c.CampaignName LIKE ? OR c.Platform LIKE ? OR c.Status LIKE ? "
                + "ORDER BY c.CreatedAt DESC";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            String searchPattern = "%" + search.trim() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Campaign campaign = new Campaign();
                    campaign.setCampaignID(rs.getInt("CampaignID"));
                    campaign.setCampaignName(rs.getString("CampaignName"));
                    campaign.setTargetType(rs.getString("TargetType"));
                    campaign.setPlatform(rs.getString("Platform"));
                    campaign.setBudget(rs.getBigDecimal("Budget"));
                    campaign.setStartDate(rs.getDate("StartDate"));
                    campaign.setEndDate(rs.getDate("EndDate"));
                    campaign.setStatus(rs.getString("Status"));
                    campaign.setDescription(rs.getString("Description"));
                    campaign.setCreatedBy(rs.getInt("CreatedBy"));
                    campaign.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    campaign.setCreatorName(rs.getString("CreatorName"));
                    campaigns.add(campaign);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return campaigns;
    }

    public boolean addCampaign(Campaign campaign) {
        String sql = "INSERT INTO Campaigns (CampaignName, TargetType, Platform, Budget, StartDate, EndDate, Status, Description, CreatedBy) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, campaign.getCampaignName());
            ps.setString(2, campaign.getTargetType());
            ps.setString(3, campaign.getPlatform());
            ps.setBigDecimal(4, campaign.getBudget());
            ps.setDate(5, campaign.getStartDate());
            ps.setDate(6, campaign.getEndDate());
            ps.setString(7, campaign.getStatus());
            ps.setString(8, campaign.getDescription());
            ps.setInt(9, campaign.getCreatedBy());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Campaign getCampaignById(int campaignId) {
        String sql = "SELECT c.*, a.FullName as CreatorName "
                + "FROM Campaigns c "
                + "LEFT JOIN Admins a ON c.CreatedBy = a.AdminID "
                + "WHERE c.CampaignID = ?";
        Campaign campaign = null;

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, campaignId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    campaign = new Campaign();
                    campaign.setCampaignID(rs.getInt("CampaignID"));
                    campaign.setCampaignName(rs.getString("CampaignName"));
                    campaign.setTargetType(rs.getString("TargetType"));
                    campaign.setPlatform(rs.getString("Platform"));
                    campaign.setBudget(rs.getBigDecimal("Budget"));
                    campaign.setStartDate(rs.getDate("StartDate"));
                    campaign.setEndDate(rs.getDate("EndDate"));
                    campaign.setStatus(rs.getString("Status"));
                    campaign.setDescription(rs.getString("Description"));
                    campaign.setCreatedBy(rs.getInt("CreatedBy"));
                    campaign.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    campaign.setCreatorName(rs.getString("CreatorName"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return campaign;
    }

    public boolean deleteCampaign(int campaignId) {
        String sql = "DELETE FROM Campaigns WHERE CampaignID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, campaignId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCampaign(Campaign campaign) {
        String sql = "UPDATE Campaigns SET CampaignName = ?, TargetType = ?, Platform = ?, Budget = ?, "
                + "StartDate = ?, EndDate = ?, Status = ?, Description = ? "
                + "WHERE CampaignID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, campaign.getCampaignName());
            ps.setString(2, campaign.getTargetType());
            ps.setString(3, campaign.getPlatform());
            ps.setBigDecimal(4, campaign.getBudget());
            ps.setDate(5, campaign.getStartDate());
            ps.setDate(6, campaign.getEndDate());
            ps.setString(7, campaign.getStatus());
            ps.setString(8, campaign.getDescription());
            ps.setInt(9, campaign.getCampaignID());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
