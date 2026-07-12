package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.OrderDetail;
import util.DBConnection;

public class OrderDetailDAO {

    private OrderDetail mapRow(ResultSet rs) throws SQLException {
        OrderDetail detail = new OrderDetail();
        detail.setId(rs.getInt("id"));
        detail.setOrderId(rs.getInt("order_id"));
        detail.setFoodId(rs.getInt("food_id"));
        detail.setQuantity(rs.getInt("quantity"));
        detail.setPrice(rs.getDouble("price"));
        detail.setSubtotal(rs.getDouble("subtotal"));
        try {
            detail.setFoodName(rs.getString("food_name"));
        } catch (SQLException e) {
            // column not present in this query
        }
        return detail;
    }

    public boolean insertBatch(int orderId, List<OrderDetail> details) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                boolean inserted = insertBatch(conn, orderId, details);
                conn.commit();
                return inserted;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean insertBatch(Connection conn, int orderId, List<OrderDetail> details) throws SQLException {
        String sql = "INSERT INTO order_details (order_id, food_id, quantity, price, subtotal) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (OrderDetail detail : details) {
                ps.setInt(1, orderId);
                ps.setInt(2, detail.getFoodId());
                ps.setInt(3, detail.getQuantity());
                ps.setDouble(4, detail.getPrice());
                ps.setDouble(5, detail.getSubtotal());
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            for (int r : results) {
                if (r == Statement.EXECUTE_FAILED) {
                    return false;
                }
            }
            return true;
        }
    }

    public List<OrderDetail> findByOrderId(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT od.*, f.name AS food_name FROM order_details od "
                + "LEFT JOIN foods f ON od.food_id = f.id "
                + "WHERE od.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
