<%@ page import="com.user.dao.*" %>
<%@ page import="com.user.model.*" %>
<%@ page import="com.user.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Access</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        h1, h2 {
            text-align: center;
            color: #333;
        }
        .container {
            width: 90%;
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        .form-container, .list-container {
            padding: 20px;
            display: none;
        }
        .form-container input, .form-container select, .form-container textarea {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        .form-container button, .toggle-button, .logout-button {
            padding: 12px 20px;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .form-container button {
            background-color: #4CAF50;
            width: 100%;
        }
        .toggle-button {
            background-color: #007bff;
            margin: 5px;
        }
        .logout-button {
            background-color: #d9534f;
            position: absolute;
            top: 20px;
            right: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #f4f4f4;
        }
        .no-requests {
            text-align: center;
            font-style: italic;
            color: #888;
        }
    </style>
    <script>
        function toggleSection(section) {
            var requestSection = document.getElementById('requestAccessSection');
            var listSection = document.getElementById('viewRequestsSection');
            if (section === 'request') {
                requestSection.style.display = 'block';
                listSection.style.display = 'none';
            } else {
                requestSection.style.display = 'none';
                listSection.style.display = 'block';
            }
        }

        function logout() {
            window.location.href = "index.jsp";
        }

        window.onload = function() {
            toggleSection('request');
        };
    </script>
</head>
<body>

<div class="container">
    <h1>Software Access Management</h1>
    
    <div class="logout-container">
        <button class="logout-button" onclick="logout()">Logout</button>
    </div>

    <!-- Toggle Buttons for Request and View Sections -->
    <div class="button-container">
        <button class="toggle-button" onclick="toggleSection('request')">Request Access</button>
        <button class="toggle-button" onclick="toggleSection('view')">View Access Requests</button>
    </div>

    <!-- Request Access Section -->
    <div id="requestAccessSection" class="form-container">
        <h2>Request Access to Software</h2>
        <form action="RequestServlet" method="POST">
            <label for="softwareName">Software Name:</label>
            <select name="softwareName" id="softwareName">
                <%
                    SoftwareDAO softwareDAO = new SoftwareDAO(DBConnection.getConnection());
                    List<Software> softwareList = softwareDAO.getAllSoftware();
                    for (Software software : softwareList) {
                %>
                    <option value="<%=software.getName()%>"><%=software.getName()%></option>
                <% } %>
            </select>

            <label for="accessType">Access Type:</label>
            <select name="accessType" id="accessType">
                <option value="Read">Read</option>
                <option value="Write">Write</option>
                <option value="Admin">Admin</option>
            </select>

            <label for="reason">Reason:</label>
            <textarea name="reason" id="reason" rows="4" required></textarea>

            <button type="submit">Request Access</button>
        </form>
    </div>

    <!-- View Requests Section -->
    <div id="viewRequestsSection" class="list-container">
        <h2>Existing Access Requests</h2>
        <table>
            <thead>
                <tr>
                    <th>Software Name</th>
                    <th>Access Type</th>
                    <th>Reason</th>
                    <th>Status</th>
                    
                </tr>
            </thead>
            <tbody>
			    <%
			        HttpSession httpsession = request.getSession();
			        User currentUser = (User) httpsession.getAttribute("user");
			        int userId = currentUser.getId();
			         
			        
			        
			        RequestDAO requestDAO = new RequestDAO(DBConnection.getConnection());
			        List<Map<String, Object>> requestList = requestDAO.getAllRequests(userId); // Updated method call
			        
			        if (requestList != null && !requestList.isEmpty()) {
			            for (Map<String, Object> req : requestList) {
			    %>
			                <tr>
			                    <td><%= req.get("softwareName") %></td> <!-- Software Name -->
			                    <td><%= req.get("accessType") %></td> <!-- Access Type -->
			                    <td><%= req.get("reason") %></td> <!-- Reason -->
			                    <td><%= req.get("status") %></td> <!-- Status -->
			                    
			                </tr>
			    <%
			            }
			        } else {
			    %>
			            <tr>
			                <td colspan="5" class="no-requests">No access requests available.</td> 
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
