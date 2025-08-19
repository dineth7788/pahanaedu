package dao;

import model.BillDetails;
import util.DBUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class BillDAO {

    /**
     * Inserts a new bill record and returns the generated bill ID.
     */
    public int createBill(int customerId, int itemId, int quantity, BigDecimal total) throws SQLException {
        String sql = "INSERT INTO bills (customer_id, item_id, quantity, total, status) " +
                "VALUES (?, ?, ?, ?, 'PENDING')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, customerId);
            ps.setInt(2, itemId);
            ps.setInt(3, quantity);
            ps.setBigDecimal(4, total);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    /**
     * Retrieves a bill's details (header + line items) by bill ID.
     */
    public BillDetails findDetails(int billId) throws SQLException {
        String sql =
                "SELECT b.id AS bill_id, " +
                        "       b.customer_id, " +
                        "       c.name AS customer_name, " +
                        "       b.bill_date, " +
                        "       b.total, " +
                        "       b.status, " +
                        "       bi.item_id, " +
                        "       i.name AS item_name, " +
                        "       bi.quantity, " +
                        "       bi.price, " +
                        "       bi.subtotal " +
                        "FROM bills b " +
                        "JOIN customers c ON b.customer_id = c.id " +
                        "JOIN bill_items bi ON b.id = bi.bill_id " +
                        "JOIN items i ON bi.item_id = i.id " +
                        "WHERE b.id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, billId);
            try (ResultSet rs = ps.executeQuery()) {
                BillDetails details = null;
                while (rs.next()) {
                    if (details == null) {
                        details = new BillDetails();
                        details.setBillId(rs.getInt("bill_id"));
                        details.setCustomerId(rs.getInt("customer_id"));
                        details.setCustomerName(rs.getString("customer_name"));
                        details.setBillDate(rs.getTimestamp("bill_date"));
                        details.setTotal(rs.getBigDecimal("total"));
                        details.setStatus(rs.getString("status"));
                    }
                    details.addItem(
                            rs.getInt("item_id"),
                            rs.getString("item_name"),
                            rs.getInt("quantity"),
                            rs.getBigDecimal("price"),
                            rs.getBigDecimal("subtotal")
                    );
                }
                return details;
            }
        }
    }

    /**
     * Deletes a bill by ID.
     */
    public boolean delete(int billId) throws SQLException {
        String sql = "DELETE FROM bills WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, billId);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    /**
     * Updates the status of a bill.
     */
    public boolean updateStatus(int billId, String status) throws SQLException {
        String sql = "UPDATE bills SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, billId);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }
}
