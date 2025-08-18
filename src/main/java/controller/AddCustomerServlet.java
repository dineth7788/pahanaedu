package controller;

import util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/add-customer")
public class AddCustomerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // simple auth guard (optional): ensure user logged in
        if (request.getSession(false) == null || request.getSession(false).getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Name is required");
            request.getRequestDispatcher("addCustomer.jsp").forward(request, response);
            return;
        }

        String sql = "INSERT INTO customers (name, email, phone, address) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (conn == null) throw new ServletException("DB connection is null");

            ps.setString(1, name);
            ps.setString(2, (email == null || email.isEmpty()) ? null : email);
            ps.setString(3, (phone == null || phone.isEmpty()) ? null : phone);
            ps.setString(4, (address == null || address.isEmpty()) ? null : address);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                // after save, show message on the same page
                request.setAttribute("message", "Customer saved successfully");
                request.getRequestDispatcher("addCustomer.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to save customer");
                request.getRequestDispatcher("addCustomer.jsp").forward(request, response);
            }

        } catch (Exception e) {
            // handle duplicate email etc.
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("addCustomer.jsp").forward(request, response);
        }
    }
}
