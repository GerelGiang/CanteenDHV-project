package controller;

import dao.FoodDAO;
import dao.OrderDAO;
import model.CartItem;
import model.Food;
import model.Order;
import model.OrderDetail;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Objects;

public class OrderServlet extends HttpServlet {

    private FoodDAO foodDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        foodDAO = new FoodDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        if (action == null) {
            action = "history";
        }

        switch (action) {
            case "detail":
                showOrderDetail(request, response, user);
                break;
            case "cancel":
                cancelOrder(request, response, session, user);
                break;
            case "history":
            default:
                showOrderHistory(request, response, user);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        if ("place".equals(action)) {
            placeOrder(request, response, session, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    private void showOrderHistory(HttpServletRequest request, HttpServletResponse response,
                                   User user) throws ServletException, IOException {
        List<Order> orders = orderDAO.findByUserId(user.getId());
        request.setAttribute("orders", orders);
        request.setAttribute("pageTitle", "Đơn hàng của tôi - DHV Canteen");
        request.getRequestDispatcher("/views/student/orders.jsp").forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response,
                                  User user) throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            Order order = orderDAO.findById(orderId);

            // Verify order belongs to current user
            if (order == null || !Objects.equals(order.getUserId(), user.getId())) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy đơn hàng.");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            dao.OrderDetailDAO orderDetailDAO = new dao.OrderDetailDAO();
            List<OrderDetail> details = orderDetailDAO.findByOrderId(orderId);
            order.setOrderDetails(details);

            request.setAttribute("order", order);
            request.setAttribute("pageTitle", "Chi tiết đơn hàng #" + orderId + " - DHV Canteen");
            request.getRequestDispatcher("/views/student/order-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Mã đơn hàng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response,
                              HttpSession session, User user) throws IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            Order order = orderDAO.findById(orderId);

            // Verify order belongs to user and is pending
            if (order == null || !Objects.equals(order.getUserId(), user.getId())) {
                session.setAttribute("errorMessage", "Không tìm thấy đơn hàng.");
            } else if (!"pending".equals(order.getStatus())) {
                session.setAttribute("errorMessage", "Chỉ có thể hủy đơn đang chờ xác nhận.");
            } else {
                boolean success = orderDAO.updateStatus(orderId, "cancelled");
                if (success) {
                    session.setAttribute("successMessage", "Đã hủy thành công đơn hàng #" + orderId + ".");
                } else {
                    session.setAttribute("errorMessage", "Hủy đơn hàng thất bại. Vui lòng thử lại.");
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ.");
        }
        response.sendRedirect(request.getContextPath() + "/orders");
    }

    @SuppressWarnings("unchecked")
    private void placeOrder(HttpServletRequest request, HttpServletResponse response,
                             HttpSession session, User user) throws IOException {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            session.setAttribute("errorMessage", "Giỏ hàng đang trống. Vui lòng thêm món trước khi đặt hàng.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String note = request.getParameter("note");

        // Re-validate cart items against current menu state to block unavailable/deleted items.
        List<String> unavailableFoods = new ArrayList<>();
        List<OrderDetail> details = new ArrayList<>();
        double totalAmount = 0;
        Iterator<CartItem> iterator = cart.iterator();
        while (iterator.hasNext()) {
            CartItem item = iterator.next();
            Food latestFood = foodDAO.findAvailableById(item.getFood().getId());
            if (latestFood == null) {
                unavailableFoods.add(item.getFood().getName());
                iterator.remove();
                continue;
            }

            item.setFood(latestFood);
            double subtotal = latestFood.getPrice() * item.getQuantity();
            totalAmount += subtotal;

            OrderDetail detail = new OrderDetail();
            detail.setFoodId(latestFood.getId());
            detail.setQuantity(item.getQuantity());
            detail.setPrice(latestFood.getPrice());
            detail.setSubtotal(subtotal);
            details.add(detail);
        }
        session.setAttribute("cart", cart);

        if (!unavailableFoods.isEmpty()) {
            session.setAttribute("errorMessage",
                    "Một số món hiện không còn bán và đã được xóa khỏi giỏ hàng: " + String.join(", ", unavailableFoods));
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        if (details.isEmpty()) {
            session.setAttribute("errorMessage", "Giỏ hàng đang trống. Vui lòng thêm món trước khi đặt hàng.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Create order
        Order order = new Order();
        order.setUserId(user.getId());
        order.setTotalAmount(totalAmount);
        order.setStatus("pending");
        order.setOrderType("online");
        order.setNote(note);

        int orderId = orderDAO.insertWithDetails(order, details);

        if (orderId > 0) {
            cart.clear();
            session.setAttribute("cart", cart);
            session.setAttribute("successMessage", "Đặt hàng thành công! Mã đơn hàng: #" + orderId);
            response.sendRedirect(request.getContextPath() + "/orders?action=detail&id=" + orderId);
        } else {
            session.setAttribute("errorMessage", "Đặt hàng thất bại. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
