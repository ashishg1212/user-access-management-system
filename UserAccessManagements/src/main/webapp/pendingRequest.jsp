<%@ page import="java.util.List" %>
<%@ page import="com.user.model.*, com.user.dao.*,  com.user.servlet.*, java.util.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Requests</title>
    <style>
       
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; padding: 20px; }
        h1 { text-align: center; color: #333; }
        table { width: 80%; margin: 20px auto; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f4f4f4; color: #333; }
        tbody tr:nth-child(even) { background-color: #f9f9f9; }
        .actions { display: flex; gap: 10px; justify-content: center; }
        .btn { padding: 5px 10px; border: none; cursor: pointer; }
        .btn-approve { background-color: #4CAF50; color: white; }
        .btn-reject { background-color: #f44336; color: white; }
        
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
    </style>
    <script>
	    function logout() {
	        window.location.href = "index.jsp";
	    }
    </script>
</head>
<body>
     <div class="logout-container">
        <button class="logout-button" onclick="logout()">Logout</button>
    </div>
    <h1>Pending Access Requests</h1>

    <%
        HttpSession httpsession = request.getSession();
        User manager = (User) httpsession.getAttribute("user");

        if (manager != null && "Manager".equals(manager.getRole())) {
            RequestDAO requestDAO = new RequestDAO(DBConnection.getConnection());
            UserDAO userDAO = new UserDAO(DBConnection.getConnection());
            SoftwareDAO softwareDAO = new SoftwareDAO(DBConnection.getConnection());

            List<Request> pendingRequests = requestDAO.getPendingRequests();

            if (pendingRequests != null && !pendingRequests.isEmpty()) {
    %>
                <table>
                    <tr>
                        <th>Employee Name</th>
                        <th>Software Name</th>
                        <th>Access Type</th>
                        <th>Reason</th>
                        <th>Actions</th>
                    </tr>
                    <% for (Request req : pendingRequests) { 
                        User employee = userDAO.getUserById(req.getUserId());
                        Software software = softwareDAO.getSoftwareById(req.getSoftwareId());
                        
                        // Adding null checks for employee and software
                        if (employee != null && software != null) { 
                    %>
                        <tr>
                            <td><%= employee.getUsername() %></td>
                            <td><%= software.getName() %></td>
                            <td><%= req.getAccessType() %></td>
                            <td><%= req.getReason() %></td>
                            <td class="actions">
                                <form action="ApprovalServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="requestId" value="<%= req.getId() %>">
                                    <button type="submit" name="action" value="approve" class="btn btn-approve">Approve</button>
                                    <button type="submit" name="action" value="reject" class="btn btn-reject">Reject</button>
                                </form>
                            </td>
                        </tr>
                    <% 
                        } // End if for employee and software null check 
                    } %>
                </table>
    <%      } else { %>
                <p style="text-align: center;">No pending requests at the moment.</p>
    <%      }
        } else {
            response.sendRedirect("login.jsp");
        }
    %>
</body>
</html>
