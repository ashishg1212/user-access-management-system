package com.user.servlet;

import com.user.dao.SoftwareDAO;
import com.user.model.Software;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/SoftwareServlet")
public class SoftwareServlet extends HttpServlet {

    private SoftwareDAO softwareDAO;

    @Override
    public void init() {
        // Initialize SoftwareDAO with database connection
        softwareDAO = new SoftwareDAO(DBConnection.getConnection());
    }

    // Handling the POST request for adding new software
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get data from the form
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String[] accessLevelsArray = request.getParameterValues("accessLevels");

        // Join the access levels into a comma-separated string
        String accessLevels = (accessLevelsArray != null) ? String.join(", ", accessLevelsArray) : "";

        // Validate the input data
        if (name == null || name.isEmpty() || description == null || description.isEmpty()) {
            response.sendRedirect("createSoftware.jsp?error=Missing required fields");
            return;
        }

        Software software = new Software();
        software.setName(name);
        software.setDescription(description);
        software.setAccessLevels(accessLevels);

        // Insert software into DB and handle the result
        boolean isAdded = softwareDAO.addSoftware(software);
        if (isAdded) {
            response.sendRedirect("createSoftware.jsp?success=true");
        } else {
            response.sendRedirect("createSoftware.jsp?error=Failed to add software");
        }
    }

    // Handling the GET request to fetch the software list
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Software> softwareList = softwareDAO.getAllSoftware();
        request.setAttribute("softwareList", softwareList);
        request.getRequestDispatcher("/createSoftware.jsp").forward(request, response);
    }
}
