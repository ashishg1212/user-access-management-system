package com.user.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.user.dao.UserDAO;
import com.user.model.User;

@WebServlet("/SignUpServlet")
public class SignUpServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        // Assuming there's a method to get DB connection
        userDAO = new UserDAO(DBConnection.getConnection());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

       
       

        User users = new User();
        users.setUsername(username);
        users.setPassword(password);  // Store the hashed password
        users.setRole("Employee");  // default role is Employee

        boolean isRegistered = userDAO.registerUser(users);
        if (isRegistered) {
            response.sendRedirect("login.jsp");  // Redirect to login page on success
        } else {
            response.getWriter().println("Registration failed.");
        }
    }
}
