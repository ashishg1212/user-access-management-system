package com.user.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.user.model.Software;

public class SoftwareDAO {

    private Connection connection;

    public SoftwareDAO(Connection connection) {
        this.connection = connection;
    }

    // Method to add a new software
    public boolean addSoftware(Software software) {
        String query = "INSERT INTO software (name, description, accessLevels) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, software.getName());
            stmt.setString(2, software.getDescription());
            stmt.setString(3, software.getAccessLevels());
            return stmt.executeUpdate() > 0; // Returns true if insert was successful
        } catch (SQLException e) {
            e.printStackTrace();  // Consider replacing with proper logging
        }
        return false;
    }

    // Method to fetch all software from the database
    public List<Software> getAllSoftware() {
        List<Software> softwareList = new ArrayList<>();
        String query = "SELECT * FROM software";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Software software = new Software();
                software.setId(rs.getInt("id"));
                software.setName(rs.getString("name"));
                software.setDescription(rs.getString("description"));
                software.setAccessLevels(rs.getString("accessLevels"));
                softwareList.add(software);
            }
        } catch (SQLException e) {
            e.printStackTrace(); 
        }
        return softwareList;
    }
    
    // Method to fetch a software by name
    public Software getSoftwareByName(String name) {
        String query = "SELECT * FROM software WHERE name = ?";
        Software software = null;
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                software = new Software();
                software.setId(rs.getInt("id"));
                software.setName(rs.getString("name"));
                software.setDescription(rs.getString("description"));
                software.setAccessLevels(rs.getString("accessLevels"));
            }
        } catch (SQLException e) {
            e.printStackTrace();  
        }
        
        return software;
    }
    
    public Software getSoftwareById(int softwareId) {
        String query = "SELECT * FROM software WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, softwareId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Software software = new Software();
                software.setId(rs.getInt("id"));
                software.setName(rs.getString("name"));
                software.setDescription(rs.getString("description"));
                software.setAccessLevels(rs.getString("accessLevels"));
                return software;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
