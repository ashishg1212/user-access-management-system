<%@page import="com.user.servlet.DBConnection"%>
<%@ page import="java.util.List, com.user.model.Software, com.user.dao.SoftwareDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Software Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .logout-container {
            position: absolute;
            top: 20px;
            right: 20px;
        }
        .logout-button {
            padding: 10px 15px;
            background-color: #d9534f;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        .logout-button:hover {
            background-color: #c9302c;
        }
        
        .form-container, .software-list-container {
            padding: 20px;
            margin-bottom: 20px;
        }
        .form-container input, .form-container textarea, .form-container select, .form-container label {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        .form-container button {
            padding: 12px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .form-container button:hover {
            background-color: #218838;
        }
        .software-list-container table {
            width: 100%;
            border-collapse: collapse;
        }
        .software-list-container th, .software-list-container td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        .software-list-container th {
            background-color: #f7f7f7;
        }
        .software-list-container tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .no-software {
            text-align: center;
            font-style: italic;
            color: #999;
        }
        .checkbox-container {
            display: flex;
            gap: 10px;
        }
        .checkbox-container label {
            margin-right: 0;
        }
        .button-container {
            text-align: center;
        }
        .toggle-button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .toggle-button:hover {
            background-color: #0056b3;
        }
        
        
        .checkbox-container {
        display: flex;
        gap: 15px;
        margin: 10px 0;
    }
    .checkbox-container label {
        display: flex;
        align-items: center;
        font-weight: 500;
        color: #333;
        padding: 5px 10px;
        background-color: #e9ecef;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }
    .checkbox-container label:hover {
        background-color: #d1d8e0;
    }
    .checkbox-container input[type="checkbox"] {
        margin-right: 8px;
        cursor: pointer;
        width: 18px;
        height: 18px;
    }

    /* Optional: Active checkbox styling */
    .checkbox-container input[type="checkbox"]:checked + label {
        background-color: #cce5ff;
        color: #007bff;
        font-weight: 600;
    }

    /* Additional styling for button */
    .form-container button {
        padding: 12px 25px;
        font-size: 16px;
    }
    </style>
    <script>
        function toggleSection(section) {
            var addSection = document.getElementById('addSoftwareSection');
            var listSection = document.getElementById('softwareListSection');
            if (section === 'add') {
                addSection.style.display = 'block';
                listSection.style.display = 'none';
            } else {
                addSection.style.display = 'none';
                listSection.style.display = 'block';
            }
        }
        
        function logout() {
            window.location.href = "index.jsp";
        }
        
        // Show the add section by default after login
        window.onload = function() {
            toggleSection('add');
        };
    </script>
</head>
<body>

<div class="container">

    <div class="logout-container">
        <button class="logout-button" onclick="logout()">Logout</button>
    </div>
    
    <h1>Software Management</h1>

    <!-- Toggle Buttons to Show/Add Software -->
    <div class="button-container">
        <button class="toggle-button" onclick="toggleSection('add')">Add Software</button>
        <button class="toggle-button" onclick="toggleSection('list')">View Software List</button>
    </div>

    <!-- Add Software Section -->
    <div id="addSoftwareSection" class="form-container">
        <h2>Add New Software</h2>
        <form action="SoftwareServlet" method="POST">
            <label for="name">Software Name:</label>
            <input type="text" id="name" name="name" required>

            <label for="description">Description:</label>
            <textarea id="description" name="description" rows="4" required></textarea>

            <label for="accessLevels">Access Levels:</label>
            <div class="checkbox-container">
                <label><input type="checkbox" name="accessLevels" value="Read"> Read</label>
                <label><input type="checkbox" name="accessLevels" value="Write"> Write</label>
                <label><input type="checkbox" name="accessLevels" value="Admin"> Admin</label>
            </div>

            <button type="submit">Add Software</button>
        </form>
    </div>

    <!-- View Software List Section -->
    <div id="softwareListSection" class="software-list-container" style="display: none;">
        <h2>Existing Software</h2>
        <table>
            <thead>
                <tr>
                    <th>Software Name</th>
                    <th>Description</th>
                    <th>Access Levels</th>
                </tr>
            </thead>
                <%
                    // Create DAO object and retrieve the software list directly
                    SoftwareDAO softwareDAO = new SoftwareDAO(DBConnection.getConnection());
                    List<Software> softwareList = softwareDAO.getAllSoftware();
                    
                    // Check if softwareList is not empty
                    if (softwareList != null && !softwareList.isEmpty()) {
                        for (Software software : softwareList) {
                %>
                            <tr>
                                <td><%= software.getName() %></td>
                                <td><%= software.getDescription() %></td>
                                <td><%= software.getAccessLevels() %></td>
                            </tr>
                <%
                        }
                    } else {
                %>
                        <tr>
                            <td colspan="3" class="no-software">No software available.</td>
                        </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

</div>

</body>
</html>
