package com.user.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.user.dao.RequestDAO;
import com.user.model.User;

@WebServlet("/ApprovalServlet")
public class ApprovalServlet extends HttpServlet {

    private RequestDAO requestDAO;

    @Override
    public void init() {
        requestDAO = new RequestDAO(DBConnection.getConnection());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"Manager".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String action = request.getParameter("action");

        String status = "Rejected";
        if ("approve".equalsIgnoreCase(action)) {
            status = "Approved";
        }

        boolean isUpdated = requestDAO.updateRequestStatus(requestId, status);

        if (isUpdated) {
            response.sendRedirect("pendingRequest.jsp?status=updated");
        } else {
            response.sendRedirect("pendingRequest.jsp?status=error");
        }
    }
}
