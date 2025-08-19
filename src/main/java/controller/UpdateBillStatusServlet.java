package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/UpdateBillStatusServlet")
public class UpdateBillStatusServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/your_database";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "your_password";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String billId = request.getParameter("bill_id");
        String status = request.getParameter("status");

        if (billId != null && status != null) {
            Connection con = null;
            PreparedStatement ps = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

                String sql = "UPDATE bills SET status=? WHERE bill_id=?";
                ps = con.prepareStatement(sql);
                ps.setString(1, status);
                ps.setInt(2, Integer.parseInt(billId));

                ps.executeUpdate();

                // Redirect back to the bill details page
                response.sendRedirect("viewBillDetails.jsp?bill_id=" + billId);

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Error updating bill status: " + e.getMessage());
            } finally {
                try { if (ps != null) ps.close(); } catch (Exception ignored) {}
                try { if (con != null) con.close(); } catch (Exception ignored) {}
            }
        } else {
            response.getWriter().println("Invalid request: Missing bill_id or status");
        }
    }
}
