package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/BillingServlet")
public class BillingServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/your_database";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "your_password";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customer_id"));
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // Get item price
            double price = 0;
            String priceQuery = "SELECT price FROM items WHERE id = ?";
            ps = con.prepareStatement(priceQuery);
            ps.setInt(1, itemId);
            rs = ps.executeQuery();
            if (rs.next()) {
                price = rs.getDouble("price");
            }
            rs.close();
            ps.close();

            // Calculate total
            double total = price * quantity;

            // Insert bill into DB
            String insertQuery = "INSERT INTO bills (customer_id, item_id, quantity, total, status) VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(insertQuery);
            ps.setInt(1, customerId);
            ps.setInt(2, itemId);
            ps.setInt(3, quantity);
            ps.setDouble(4, total);
            ps.setString(5, "PENDING");
            ps.executeUpdate();

            // Redirect to view bills
            response.sendRedirect("viewBills.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}
