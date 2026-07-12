package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.FoodDAO;
import dao.OrderDAO;
import dao.UserDAO;
import model.Food;
import model.Order;

public class AdminDashboardServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private FoodDAO foodDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        foodDAO = new FoodDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Revenue stats
        double totalRevenue = orderDAO.getTotalRevenue();
        double todayRevenue = orderDAO.getRevenueToday();

        // Order counts
        int totalOrders = orderDAO.countAll();
        int todayOrders = orderDAO.countToday();
        int pendingOrders = orderDAO.countByStatus("pending");

        // Other counts
        int totalFoods = foodDAO.countAll();
        int totalStudents = userDAO.countStudents();

        // Recent orders (first 10)
        List<Order> allOrders = orderDAO.findAll();
        List<Order> recentOrders = allOrders.size() > 10
                ? allOrders.subList(0, 10) : allOrders;

        // Top selling foods
        List<Food> topFoods = foodDAO.findTopSelling(5);

        // Set attributes
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("todayRevenue", todayRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("todayOrders", todayOrders);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("totalFoods", totalFoods);
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("topFoods", topFoods);
        request.setAttribute("pageTitle", "Bảng điều khiển");

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }
}
