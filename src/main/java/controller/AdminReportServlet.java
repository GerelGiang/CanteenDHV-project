package controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.FoodDAO;
import dao.OrderDAO;
import model.Food;

public class AdminReportServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private FoodDAO foodDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        foodDAO = new FoodDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // Default to current month if no dates provided
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        if (startDate == null || startDate.isEmpty() || endDate == null || endDate.isEmpty()) {
            Calendar cal = Calendar.getInstance();
            endDate = sdf.format(cal.getTime());
            cal.set(Calendar.DAY_OF_MONTH, 1);
            startDate = sdf.format(cal.getTime());
        }

        // Revenue by date range
        double revenue = orderDAO.getRevenueByDateRange(startDate, endDate);

        // Orders in date range
        List<model.Order> ordersInRange = orderDAO.findByDateRange(startDate, endDate);
        int orderCount = ordersInRange.size();
        int completedCount = 0;
        for (model.Order o : ordersInRange) {
            if ("completed".equals(o.getStatus())) {
                completedCount++;
            }
        }

        // Top selling foods
        List<Food> topFoods = foodDAO.findTopSelling(10);

        // Daily revenue data for chart (last 30 days)
        Map<String, Double> dailyRevenue = orderDAO.getRevenueByDay(30);

        // Set attributes
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("revenue", revenue);
        request.setAttribute("orderCount", orderCount);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("topFoods", topFoods);
        request.setAttribute("dailyRevenue", dailyRevenue);
        request.setAttribute("pageTitle", "Thống kê doanh thu");

        request.getRequestDispatcher("/views/admin/reports.jsp").forward(request, response);
    }
}
