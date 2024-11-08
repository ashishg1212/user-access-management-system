package com.user.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.user.model.Request;

public class RequestDAO {

    private Connection connection;

    public RequestDAO(Connection connection) {
        this.connection = connection;
    }

    // Method to add a new request
    public boolean addRequest(Request request) {
        String sql = "INSERT INTO requests (userId, softwareId, accessType, reason, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, request.getUserId());
            stmt.setInt(2, request.getSoftwareId());
            stmt.setString(3, request.getAccessType());
            stmt.setString(4, request.getReason());
            stmt.setString(5, request.getStatus());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to get requests by userId
    public List<Request> getRequestsByUserId(int userId) {
        List<Request> requests = new ArrayList<>();
        String sql = "SELECT * FROM requests WHERE userId = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Request req = new Request();
                    req.setId(rs.getInt("id"));
                    req.setUserId(rs.getInt("userId"));
                    req.setSoftwareId(rs.getInt("softwareId"));
                    req.setAccessType(rs.getString("accessType"));
                    req.setReason(rs.getString("reason"));
                    req.setStatus(rs.getString("status"));
                    requests.add(req);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }
    
    public List<Map<String, Object>> getAllRequests(int userId) {
        List<Map<String, Object>> requests = new ArrayList<>();
        String sql = "SELECT r.id, r.userId, r.accessType, r.reason, r.status, s.name " +
                     "FROM requests r " +
                     "JOIN software s ON r.softwareId = s.id " +
                     "WHERE r.userId = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Map<String, Object> requestMap = new HashMap<>();
                requestMap.put("id", resultSet.getInt("id"));
                requestMap.put("userId", resultSet.getInt("userId"));
                requestMap.put("accessType", resultSet.getString("accessType"));
                requestMap.put("reason", resultSet.getString("reason"));
                requestMap.put("status", resultSet.getString("status"));
                requestMap.put("softwareName", resultSet.getString("name")); // Add software name

                requests.add(requestMap);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }


    
    public boolean updateRequestStatus(int requestId, String status) {
        String query = "UPDATE requests SET status = ? WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, requestId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Request> getPendingRequests() {
        List<Request> pendingRequests = new ArrayList<>();
        String query = "SELECT * FROM requests WHERE status = 'Pending'";
        try (PreparedStatement pstmt = connection.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Request req = new Request();
                req.setId(rs.getInt("id"));
                req.setUserId(rs.getInt("userId"));
                req.setSoftwareId(rs.getInt("softwareId"));
                req.setAccessType(rs.getString("accessType"));
                req.setReason(rs.getString("reason"));
                req.setStatus(rs.getString("status"));
                pendingRequests.add(req);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pendingRequests;
    }
    
    

}
