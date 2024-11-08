package com.user.servlet;

import com.user.dao.UserDAO;
import com.user.model.User;  
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        // Initialize the userDAO with the database connection
        userDAO = new UserDAO(DBConnection.getConnection());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.validateLogin(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            

            // Redirect based on role
            if ("Employee".equals(user.getRole())) {
                response.sendRedirect("requestAccess.jsp");
            } else if ("Manager".equals(user.getRole())) {
                response.sendRedirect("pendingRequest.jsp");
            } else if ("Admin".equals(user.getRole())) {
                response.sendRedirect("createSoftware.jsp");
            }
        } else {
            // Invalid credentials, redirect back with an error message
            request.setAttribute("errorMessage", "Invalid username or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
