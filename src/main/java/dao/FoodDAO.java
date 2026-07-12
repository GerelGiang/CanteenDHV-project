package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Food;
import util.DBConnection;

public class FoodDAO {

    private Food mapRow(ResultSet rs) throws SQLException {
        Food food = new Food();
        food.setId(rs.getInt("id"));
        food.setCategoryId(rs.getInt("category_id"));
        food.setName(rs.getString("name"));
        food.setDescription(rs.getString("description"));
        food.setPrice(rs.getDouble("price"));
        food.setImage(rs.getString("image"));
        food.setStatus(rs.getInt("status"));
        food.setIsDeleted(rs.getInt("is_deleted"));
        food.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            food.setCategoryName(rs.getString("category_name"));
        } catch (SQLException e) {
            // column not present in this query
        }
        return food;
    }

    public List<Food> findAll() {
        List<Food> list = new ArrayList<>();
        String sql = "SELECT f.*, c.name AS category_name FROM foods f "
                + "LEFT JOIN categories c ON f.category_id = c.id "
                + "WHERE f.is_deleted = 0 ORDER BY f.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Food> findByCategory(int categoryId) {
        List<Food> list = new ArrayList<>();
        String sql = "SELECT f.*, c.name AS category_name FROM foods f "
                + "LEFT JOIN categories c ON f.category_id = c.id "
                + "WHERE f.category_id = ? AND f.is_deleted = 0 ORDER BY f.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
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

    public List<Food> findAvailable() {
        List<Food> list = new ArrayList<>();
        String sql = "SELECT f.*, c.name AS category_name FROM foods f "
                + "LEFT JOIN categories c ON f.category_id = c.id "
                + "WHERE f.status = 1 AND f.is_deleted = 0 ORDER BY f.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Food> findAvailableByCategory(int categoryId) {
        List<Food> list = new ArrayList<>();
        String sql = "SELECT f.*, c.name AS category_name FROM foods f "
                + "LEFT JOIN categories c ON f.category_id = c.id "
                + "WHERE f.status = 1 AND f.is_deleted = 0 AND f.category_id = ? "
                + "ORDER BY f.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
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

    public Food findById(int id) {
        String sql = "SELECT f.*, c.name AS category_name FROM foods f "
                + "LEFT JOIN categories c ON f.category_id = c.id "
                + "WHERE f.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Food findAvailableById(int id) {
        String sql = "SELECT f.*, c.name AS category_name FROM foods f "
                + "LEFT JOIN categories c ON f.category_id = c.id "
                + "WHERE f.id = ? AND f.status = 1 AND f.is_deleted = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Food> search(String keyword) {
        List<Food> list = new ArrayList<>();
        String sql = "SELECT f.*, c.name AS category_name FROM foods f "
                + "LEFT JOIN categories c ON f.category_id = c.id "
                + "WHERE f.name LIKE ? AND f.is_deleted = 0 ORDER BY f.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
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

    public List<Food> searchAvailable(String keyword, Integer categoryId,
                                       Double minPrice, Double maxPrice, String sortBy) {
        List<Food> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT f.*, c.name AS category_name FROM foods f "
                + "LEFT JOIN categories c ON f.category_id = c.id "
                + "WHERE f.status = 1 AND f.is_deleted = 0");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND f.name LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (categoryId != null) {
            sql.append(" AND f.category_id = ?");
            params.add(categoryId);
        }
        if (minPrice != null) {
            sql.append(" AND f.price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND f.price <= ?");
            params.add(maxPrice);
        }

        if ("price_asc".equals(sortBy)) {
            sql.append(" ORDER BY f.price ASC");
        } else if ("price_desc".equals(sortBy)) {
            sql.append(" ORDER BY f.price DESC");
        } else if ("name_asc".equals(sortBy)) {
            sql.append(" ORDER BY f.name ASC");
        } else if ("name_desc".equals(sortBy)) {
            sql.append(" ORDER BY f.name DESC");
        } else {
            sql.append(" ORDER BY f.created_at DESC");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else if (param instanceof Double) {
                    ps.setDouble(i + 1, (Double) param);
                }
            }
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

    public boolean insert(Food food) {
        String sql = "INSERT INTO foods (category_id, name, description, price, image, status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, food.getCategoryId());
            ps.setString(2, food.getName());
            ps.setString(3, food.getDescription());
            ps.setDouble(4, food.getPrice());
            ps.setString(5, food.getImage());
            ps.setInt(6, food.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Food food) {
        String sql = "UPDATE foods SET category_id = ?, name = ?, description = ?, "
                + "price = ?, image = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, food.getCategoryId());
            ps.setString(2, food.getName());
            ps.setString(3, food.getDescription());
            ps.setDouble(4, food.getPrice());
            ps.setString(5, food.getImage());
            ps.setInt(6, food.getStatus());
            ps.setInt(7, food.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean softDelete(int id) {
        String sql = "UPDATE foods SET is_deleted = 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM foods WHERE is_deleted = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Food> findTopSelling(int limit) {
        List<Food> list = new ArrayList<>();
        String sql = "SELECT f.*, c.name AS category_name, SUM(od.quantity) AS total_sold "
                + "FROM foods f "
                + "LEFT JOIN categories c ON f.category_id = c.id "
                + "JOIN order_details od ON f.id = od.food_id "
                + "WHERE f.is_deleted = 0 "
                + "GROUP BY f.id "
                + "ORDER BY total_sold DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
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
