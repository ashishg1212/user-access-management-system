package com.user.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.user.dao.RequestDAO;
import com.user.dao.SoftwareDAO;
import com.user.model.Request;
import com.user.model.Software;
import com.user.model.User;

@WebServlet("/RequestServlet")
public class RequestServlet extends HttpServlet {

    private RequestDAO requestDAO;
    private SoftwareDAO softwareDAO;

    @Override
    public void init() {
        // Initialize DAOs with DB connection
        requestDAO = new RequestDAO(DBConnection.getConnection());
        softwareDAO = new SoftwareDAO(DBConnection.getConnection());
    }

    // POST method to handle request submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Ensure the user is logged in
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve form parameters
        String softwareName = request.getParameter("softwareName");
        String accessType = request.getParameter("accessType");
        String reason = request.getParameter("reason");

        // Check if all required parameters are present
        if (softwareName == null || accessType == null || reason == null || reason.trim().isEmpty()) {
            response.sendRedirect("requestAccess.jsp?status=error&message=All fields are required");
            return;
        }

        // Fetch software object by name from the database
        Software software = softwareDAO.getSoftwareByName(softwareName);
        if (software == null) {
            response.sendRedirect("requestAccess.jsp?status=error&message=Software not found");
            return;
        }

        // Create a new Request object and set its attributes
        Request req = new Request();
        req.setUserId(user.getId()); // Set user ID from session
        req.setSoftwareId(software.getId()); // Set software ID fetched from DB
        req.setAccessType(accessType); // Set access type (Read/Write/Admin)
        req.setReason(reason); // Set reason for access request
        req.setStatus("Pending"); // Default status

        // Add the request to the database
        boolean isRequestAdded = requestDAO.addRequest(req);
        if (isRequestAdded) {
            response.sendRedirect("requestAccess.jsp?status=success"); // Redirect with success message
        } else {
            response.sendRedirect("requestAccess.jsp?status=fail&message=Request could not be added"); // Redirect with failure message
        }
    }

    // Optionally, implement the GET method to display requests for the logged-in user
    /*
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("Employee")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Fetch the list of all software from the database
        List<Software> softwareList = softwareDAO.getAllSoftware();
        request.setAttribute("softwareList", softwareList);

        // Fetch the list of requests for the logged-in user
        List<Request> requests = requestDAO.getRequestsByUserId(user.getId());
        request.setAttribute("requests", requests);

        // Forward to the JSP page to display the data
        request.getRequestDispatcher("requestAccess.jsp").forward(request, response);
    }
    */
}
