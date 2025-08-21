package dao;

import model.Cart;
import model.CartItem;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class BillDAO {

    /** Save bill + items, and atomically decrease stock. Returns new bill id. */
    public int checkout(Cart cart) throws Exception {
        if (cart == null || cart.isEmpty()) throw new IllegalArgumentException("Empty cart");

        try (Connection c = DBUtil.getConnection()) {
            try {
                c.setAutoCommit(false);

                int billId = insertBill(c, cart);

                // detect stock column: quantity / qty / stock
                String stockCol = resolveStockColumn(c);

                // do NOT include generated column 'subtotal'
                String insertItemsSql = "INSERT INTO bill_items (bill_id, item_id, quantity, price) VALUES (?,?,?,?)";
                String decStockSql =
                        "UPDATE items SET `" + stockCol + "` = `" + stockCol + "` - ? " +
                                "WHERE id = ? AND `" + stockCol + "` >= ?";

                try (PreparedStatement psItem = c.prepareStatement(insertItemsSql);
                     PreparedStatement psStock = c.prepareStatement(decStockSql)) {

                    for (CartItem ci : cart.getItems().values()) {
                        // bill_items
                        psItem.setInt(1, billId);
                        psItem.setInt(2, ci.getItemId());
                        psItem.setInt(3, ci.getQty());
                        psItem.setBigDecimal(4, ci.getPrice());
                        psItem.addBatch();

                        // stock decrease
                        psStock.setInt(1, ci.getQty());
                        psStock.setInt(2, ci.getItemId());
                        psStock.setInt(3, ci.getQty());
                        psStock.addBatch();
                    }

                    psItem.executeBatch();

                    int[] updates = psStock.executeBatch();
                    for (int u : updates) {
                        if (u == 0) {
                            throw new SQLException("Insufficient stock or item missing while updating '" + stockCol + "'.");
                        }
                    }
                }

                c.commit();
                return billId;
            } catch (Exception ex) {
                c.rollback();
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    /** Insert into bills and return generated id */
    private int insertBill(Connection c, Cart cart) throws Exception {
        String sql = "INSERT INTO bills (customer_id, bill_date, total, status) VALUES (?, NOW(), ?, ?)";
        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (cart.getCustomerId() == null) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, cart.getCustomerId());
            }
            ps.setBigDecimal(2, cart.getTotal());
            ps.setString(3, "PAID"); // adjust as needed
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Failed to create bill");
    }

    /** Find the stock column in 'items' table (tries: quantity, qty, stock). */
    private String resolveStockColumn(Connection c) throws SQLException {
        DatabaseMetaData md = c.getMetaData();
        List<String> cols = new ArrayList<>();
        try (ResultSet rs = md.getColumns(c.getCatalog(), null, "items", "%")) {
            while (rs.next()) cols.add(rs.getString("COLUMN_NAME"));
        }
        String[] candidates = {"quantity", "qty", "stock"};
        for (String cand : candidates) {
            for (String col : cols) {
                if (col != null && col.equalsIgnoreCase(cand)) return col; // actual case
            }
        }
        throw new SQLException("Could not find stock column in 'items'. Tried quantity/qty/stock. Found: " + cols);
    }

    // =========================
    // ====== VIEW HELPERS =====
    // =========================

    /** List all bills (id, date, customer, total, status). */
    public List<Map<String, Object>> listBills() throws SQLException {
        String sql =
                "SELECT b.id, b.bill_date, IFNULL(c.name,'(No customer)') AS customer, " +
                        "       b.total, b.status " +
                        "FROM bills b LEFT JOIN customers c ON c.id = b.customer_id " +
                        "ORDER BY b.id DESC";

        List<Map<String, Object>> out = new ArrayList<>();
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("bill_date", rs.getTimestamp("bill_date"));
                row.put("customer", rs.getString("customer"));
                row.put("total", rs.getBigDecimal("total"));
                row.put("status", rs.getString("status"));
                out.add(row);
            }
        }
        return out;
    }

    /** Get the header for a single bill. */
    public Map<String, Object> getBillHeader(int billId) throws SQLException {
        String sql =
                "SELECT b.id, b.bill_date, IFNULL(c.name,'(No customer)') AS customer, " +
                        "       b.total, b.status " +
                        "FROM bills b LEFT JOIN customers c ON c.id = b.customer_id " +
                        "WHERE b.id = ?";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, billId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("id", rs.getInt("id"));
                    row.put("bill_date", rs.getTimestamp("bill_date"));
                    row.put("customer", rs.getString("customer"));
                    row.put("total", rs.getBigDecimal("total"));
                    row.put("status", rs.getString("status"));
                    return row;
                }
            }
        }
        return null;
    }

    /** List items for a bill (item name, qty, price, subtotal). */
    public List<Map<String, Object>> listBillItems(int billId) throws SQLException {
        String sql =
                "SELECT i.name AS item, bi.quantity, bi.price, (bi.quantity * bi.price) AS subtotal " +
                        "FROM bill_items bi " +
                        "JOIN items i ON i.id = bi.item_id " +
                        "WHERE bi.bill_id = ? " +
                        "ORDER BY bi.id";

        List<Map<String, Object>> out = new ArrayList<>();
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, billId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("item", rs.getString("item"));
                    row.put("quantity", rs.getInt("quantity"));
                    row.put("price", rs.getBigDecimal("price"));
                    row.put("subtotal", rs.getBigDecimal("subtotal"));
                    out.add(row);
                }
            }
        }
        return out;
    }
}
