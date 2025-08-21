package dao;

import model.Item;
import util.DBUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    /** List all items (id + name) */
    public List<Item> getAllItems() throws SQLException {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT id, name FROM items ORDER BY name";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                items.add(new Item(rs.getInt("id"), rs.getString("name")));
            }
        }
        return items;
    }

    /** Find only price by id */
    public BigDecimal findPriceById(int itemId) throws SQLException {
        String sql = "SELECT price FROM items WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal("price");
            }
        }
        return null;
    }

    /** Fetch an item by id (returns only id + name to match your Item model) */
    public Item findById(int id) throws SQLException {
        String sql = "SELECT id, name FROM items WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Item(rs.getInt("id"), rs.getString("name"));
                }
            }
        }
        return null;
    }

    /** NEW: Search items by name (returns id + name) */
    public List<Item> searchByName(String q) throws SQLException {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT id, name FROM items WHERE name LIKE ? ORDER BY name LIMIT 25";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + q + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(new Item(rs.getInt("id"), rs.getString("name")));
                }
            }
        }
        return items;
    }
}
