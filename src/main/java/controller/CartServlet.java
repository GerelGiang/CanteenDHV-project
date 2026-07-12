package controller;

import dao.FoodDAO;
import model.CartItem;
import model.Food;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class CartServlet extends HttpServlet {

    private FoodDAO foodDAO;

    @Override
    public void init() throws ServletException {
        foodDAO = new FoodDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        if (action == null) {
            action = "view";
        }

        switch (action) {
            case "add":
                addToCart(request, response, cart, session);
                break;
            case "remove":
                removeFromCart(request, response, cart, session);
                break;
            case "increase":
                changeQuantity(request, response, cart, session, 1);
                break;
            case "decrease":
                changeQuantity(request, response, cart, session, -1);
                break;
            case "clear":
                cart.clear();
                session.setAttribute("cart", cart);
                response.sendRedirect(request.getContextPath() + "/cart");
                break;
            default:
                // Calculate total and forward to cart page
                double cartTotal = 0;
                for (CartItem item : cart) {
                    cartTotal += item.getSubtotal();
                }
                request.setAttribute("cartTotal", cartTotal);
                request.setAttribute("pageTitle", "Giỏ hàng - DHV Canteen");
                request.getRequestDispatcher("/views/student/cart.jsp").forward(request, response);
                break;
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response,
                           List<CartItem> cart, HttpSession session)
            throws IOException {
        try {
            int foodId = Integer.parseInt(request.getParameter("id"));
            Food food = foodDAO.findAvailableById(foodId);

            if (food != null) {
                // Check if food already in cart
                boolean found = false;
                for (CartItem item : cart) {
                    if (item.getFood().getId() == foodId) {
                        item.setQuantity(item.getQuantity() + 1);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    cart.add(new CartItem(food, 1));
                }
                session.setAttribute("cart", cart);
                session.setAttribute("successMessage", "Đã thêm món vào giỏ hàng!");
            } else {
                session.setAttribute("errorMessage", "Món ăn này hiện không còn bán hoặc không còn tồn tại.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Món ăn không hợp lệ.");
        }

        // Redirect back to referer or /foods
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/foods");
        }
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response,
                                List<CartItem> cart, HttpSession session)
            throws IOException {
        try {
            int foodId = Integer.parseInt(request.getParameter("id"));
            Iterator<CartItem> it = cart.iterator();
            while (it.hasNext()) {
                CartItem item = it.next();
                if (item.getFood().getId() == foodId) {
                    it.remove();
                    break;
                }
            }
            session.setAttribute("cart", cart);
        } catch (NumberFormatException e) {
            // ignore
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void changeQuantity(HttpServletRequest request, HttpServletResponse response,
                                List<CartItem> cart, HttpSession session, int delta)
            throws IOException {
        try {
            int foodId = Integer.parseInt(request.getParameter("id"));
            Iterator<CartItem> it = cart.iterator();
            while (it.hasNext()) {
                CartItem item = it.next();
                if (item.getFood().getId() == foodId) {
                    int newQty = item.getQuantity() + delta;
                    if (newQty <= 0) {
                        it.remove();
                    } else {
                        item.setQuantity(newQty);
                    }
                    break;
                }
            }
            session.setAttribute("cart", cart);
        } catch (NumberFormatException e) {
            // ignore
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
