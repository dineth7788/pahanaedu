package dao;

import model.Customer;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Data access for customers.
 */
public class CustomerDAO {

    /**
     * Return all customers (id + name) ordered by name.
     * Used for the billing page dropdown.
     */
    public List<Customer> getAllCustomers() throws SQLException {
        List<Customer> customers = new ArrayList<>();
        final String sql = "SELECT id, name FROM customers ORDER BY name";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                customers.add(new Customer(
                        rs.getInt("id"),
                        rs.getString("name")
                ));
            }
        }
        return customers;
    }

    /**
     * Fetch a single customer by id.
     */
    public Customer getCustomerById(int id) throws SQLException {
        final String sql = "SELECT id, name FROM customers WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getInt("id"),
                            rs.getString("name")
                    );
                }
            }
        }
        return null;
    }

    /** Optional alias if other code calls findById(...) */
    public Customer findById(int id) throws SQLException {
        return getCustomerById(id);
    }

    // ---------------- NEW HELPERS FOR BILLING ----------------

    /**
     * Map of all customers: id -> name (ordered by name).
     * Convenient for JSTL <c:forEach> over entrySet().
     */
    public Map<Integer, String> mapAll() throws SQLException {
        final String sql = "SELECT id, name FROM customers ORDER BY name";
        Map<Integer, String> out = new LinkedHashMap<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                out.put(rs.getInt("id"), rs.getString("name"));
            }
        }
        return out;
    }

    /**
     * Return the customer's name for a given id (or null if not found).
     */
    public String findName(int id) throws SQLException {
        final String sql = "SELECT name FROM customers WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString(1) : null;
            }
        }
    }

    /**
     * Optional: simple search to support a customer finder later.
     */
    public List<Customer> searchByName(String q) throws SQLException {
        final String sql = "SELECT id, name FROM customers WHERE name LIKE ? ORDER BY name LIMIT 25";
        List<Customer> results = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + q + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    results.add(new Customer(rs.getInt("id"), rs.getString("name")));
                }
            }
        }
        return results;
    }
}
