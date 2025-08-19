package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class DeleteBillServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String billId = request.getParameter("bill_id");

        if (billId != null) {
            Connection con = null;
            PreparedStatement ps = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/your_database", "root", "your_password");

                String sql = "DELETE FROM bills WHERE bill_id = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(billId));
                int rows = ps.executeUpdate();

                if (rows > 0) {
                    // ✅ Redirect back to bills list with success message
                    response.sendRedirect("viewBills.jsp?msg=deleted");
                } else {
                    response.sendRedirect("viewBills.jsp?msg=notfound");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("viewBills.jsp?msg=error");
            } finally {
                try { if (ps != null) ps.close(); } catch (Exception ignored) {}
                try { if (con != null) con.close(); } catch (Exception ignored) {}
            }
        } else {
            response.sendRedirect("viewBills.jsp?msg=invalid");
        }
    }
}
