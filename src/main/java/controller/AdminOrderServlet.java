package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.CategoryDAO;
import dao.FoodDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import model.Category;
import model.Food;
import model.Order;
import model.OrderDetail;

public class AdminOrderServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private OrderDetailDAO orderDetailDAO;
    private FoodDAO foodDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        orderDetailDAO = new OrderDetailDAO();
        foodDAO = new FoodDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "detail": {
                int id = Integer.parseInt(request.getParameter("id"));
                Order order = orderDAO.findById(id);
                if (order != null) {
                    List<OrderDetail> details = orderDetailDAO.findByOrderId(id);
                    order.setOrderDetails(details);
                    request.setAttribute("order", order);
                    request.setAttribute("pageTitle", "Chi tiết đơn hàng #" + id);
                    request.getRequestDispatcher("/views/admin/order-detail.jsp").forward(request, response);
                } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("error", "Không tìm thấy đơn hàng.");
                    response.sendRedirect(request.getContextPath() + "/admin/orders");
                }
                break;
            }
            case "updateStatus": {
                int id = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                orderDAO.updateStatus(id, status);
                HttpSession session = request.getSession();
                session.setAttribute("success", "Cập nhật trạng thái đơn hàng thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                break;
            }
            case "counter": {
                List<Food> foods = foodDAO.findAvailable();
                List<Category> categories = categoryDAO.findAll();
                request.setAttribute("foods", foods);
                request.setAttribute("categories", categories);
                request.setAttribute("pageTitle", "Bán hàng tại quầy");
                request.getRequestDispatcher("/views/admin/counter-order.jsp").forward(request, response);
                break;
            }
            default:
                listOrders(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        HttpSession session = request.getSession();

        if ("placeCounter".equals(action)) {
            String[] foodIds = request.getParameterValues("foodIds");
            String[] quantities = request.getParameterValues("quantities");
            String note = request.getParameter("note");

            if (foodIds == null || foodIds.length == 0) {
                session.setAttribute("error", "Vui lòng chọn ít nhất một món ăn.");
                response.sendRedirect(request.getContextPath() + "/admin/orders?action=counter");
                return;
            }

            double totalAmount = 0;
            List<OrderDetail> details = new ArrayList<>();

            for (int i = 0; i < foodIds.length; i++) {
                int foodId = Integer.parseInt(foodIds[i]);
                int quantity = Integer.parseInt(quantities[i]);

                if (quantity <= 0) continue;

                Food food = foodDAO.findAvailableById(foodId);
                if (food != null) {
                    OrderDetail detail = new OrderDetail();
                    detail.setFoodId(foodId);
                    detail.setQuantity(quantity);
                    detail.setPrice(food.getPrice());
                    detail.setSubtotal(food.getPrice() * quantity);
                    details.add(detail);
                    totalAmount += food.getPrice() * quantity;
                }
            }

            if (details.isEmpty()) {
                session.setAttribute("error", "Không có món ăn hợp lệ trong đơn hàng.");
                response.sendRedirect(request.getContextPath() + "/admin/orders?action=counter");
                return;
            }

            // Create counter order
            Order order = new Order();
            order.setUserId(null);
            order.setTotalAmount(totalAmount);
            order.setStatus("completed");
            order.setOrderType("counter");
            order.setNote(note);

            int orderId = orderDAO.insertWithDetails(order, details);
            if (orderId > 0) {
                session.setAttribute("success", "Tạo đơn hàng tại quầy thành công! Mã đơn: #" + orderId);
            } else {
                session.setAttribute("error", "Tạo đơn hàng thất bại. Vui lòng thử lại.");
            }

            response.sendRedirect(request.getContextPath() + "/admin/orders");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Order> orders = orderDAO.findAll();
        request.setAttribute("orders", orders);
        request.setAttribute("pageTitle", "Quản lý đơn hàng");

        // Transfer flash messages from session to request
        HttpSession session = request.getSession();
        if (session.getAttribute("success") != null) {
            request.setAttribute("success", session.getAttribute("success"));
            session.removeAttribute("success");
        }
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        request.getRequestDispatcher("/views/admin/orders.jsp").forward(request, response);
    }
}
