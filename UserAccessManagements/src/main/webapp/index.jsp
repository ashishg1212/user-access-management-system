<?xml version="1.0" encoding="ISO-8859-1" ?>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
    <title>Welcome to User Access Management System</title>
    <style>
        /* General page styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f4f8;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: #333;
        }

        /* Main container styling */
        .container {
            text-align: center;
            background-color: #ffffff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 80%;
            max-width: 600px;
        }

        /* Header styling */
        h1 {
            font-size: 2em;
            color: #4a90e2;
            margin-bottom: 20px;
        }

        /* Button styling */
        .btn-container {
            margin-top: 20px;
        }

        .btn {
            text-decoration: none;
            display: inline-block;
            padding: 10px 20px;
            font-size: 1em;
            color: #ffffff;
            border-radius: 5px;
            margin: 0 10px;
            transition: background-color 0.3s;
        }

        .btn-signup {
            background-color: #4CAF50;
        }

        .btn-login {
            background-color: #2196F3;
        }

        .btn:hover {
            opacity: 0.9;
        }

        /* Description styling */
        .description {
            font-size: 1.1em;
            color: #555;
            margin-top: 15px;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to the User Access Management System</h1>
        
        <p class="description">
            Our User Access Management System streamlines the process of managing and approving access requests to various software and tools within the organization.
            It provides employees with a convenient way to request access while empowering managers to review and approve requests efficiently.
            Start by signing up if you’re new, or log in to continue.
        </p>

        <div class="btn-container">
            <a href="signup.jsp" class="btn btn-signup">Sign Up</a>
            <a href="login.jsp" class="btn btn-login">Log In</a>
        </div>
    </div>
</body>
</html>