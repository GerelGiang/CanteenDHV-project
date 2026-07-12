package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import dao.CategoryDAO;
import dao.FoodDAO;
import util.FileUploadUtil;
import model.Category;
import model.Food;

public class AdminFoodServlet extends HttpServlet {

    private FoodDAO foodDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
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
            case "add": {
                List<Category> categories = categoryDAO.findAll();
                request.setAttribute("categories", categories);
                request.setAttribute("pageTitle", "Thêm món ăn");
                request.getRequestDispatcher("/views/admin/food-form.jsp").forward(request, response);
                break;
            }
            case "edit": {
                int id = Integer.parseInt(request.getParameter("id"));
                Food food = foodDAO.findById(id);
                if (food != null) {
                    List<Category> categories = categoryDAO.findAll();
                    request.setAttribute("food", food);
                    request.setAttribute("categories", categories);
                    request.setAttribute("pageTitle", "Sửa món ăn");
                    request.getRequestDispatcher("/views/admin/food-form.jsp").forward(request, response);
                } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("error", "Không tìm thấy món ăn.");
                    response.sendRedirect(request.getContextPath() + "/admin/foods");
                }
                break;
            }
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean deleted = foodDAO.softDelete(id);
                HttpSession session = request.getSession();
                if (deleted) {
                    session.setAttribute("success", "Đã xóa món ăn thành công!");
                } else {
                    session.setAttribute("error", "Xóa món ăn thất bại. Vui lòng thử lại.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/foods");
                break;
            }
            default:
                listFoods(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "add";
        }

        HttpSession session = request.getSession();

        switch (action) {
            case "add": {
                try {
                    String name = request.getParameter("name");
                    String description = request.getParameter("description");
                    double price = Double.parseDouble(request.getParameter("price"));
                    int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                    int status = Integer.parseInt(request.getParameter("status"));

                    if (price < 0) {
                        throw new IllegalArgumentException("Giá phải lớn hơn hoặc bằng 0.");
                    }

                    String uploadDir = getServletContext().getRealPath("/uploads/foods");
                    Part filePart = request.getPart("image");
                    String fileName = FileUploadUtil.saveFile(filePart, uploadDir);

                    Food food = new Food();
                    food.setName(name);
                    food.setDescription(description);
                    food.setPrice(price);
                    food.setCategoryId(categoryId);
                    food.setImage(fileName);
                    food.setStatus(status);

                    boolean success = foodDAO.insert(food);
                    if (success) {
                        session.setAttribute("success", "Đã thêm món ăn thành công!");
                    } else {
                        session.setAttribute("error", "Thêm món ăn thất bại. Vui lòng thử lại.");
                    }
                } catch (IllegalArgumentException e) {
                    session.setAttribute("error", e.getMessage() != null ? e.getMessage() : "Dữ liệu món ăn không hợp lệ.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/foods");
                break;
            }
            case "edit": {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String name = request.getParameter("name");
                    String description = request.getParameter("description");
                    double price = Double.parseDouble(request.getParameter("price"));
                    int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                    int status = Integer.parseInt(request.getParameter("status"));

                    if (price < 0) {
                        throw new IllegalArgumentException("Giá phải lớn hơn hoặc bằng 0.");
                    }

                    String uploadDir = getServletContext().getRealPath("/uploads/foods");
                    Part filePart = request.getPart("image");
                    String fileName = FileUploadUtil.saveFile(filePart, uploadDir);

                    // If no new file uploaded, keep the existing image
                    if (fileName == null) {
                        Food oldFood = foodDAO.findById(id);
                        if (oldFood != null) {
                            fileName = oldFood.getImage();
                        }
                    }

                    Food food = new Food();
                    food.setId(id);
                    food.setName(name);
                    food.setDescription(description);
                    food.setPrice(price);
                    food.setCategoryId(categoryId);
                    food.setImage(fileName);
                    food.setStatus(status);

                    boolean success = foodDAO.update(food);
                    if (success) {
                        session.setAttribute("success", "Đã cập nhật món ăn thành công!");
                    } else {
                        session.setAttribute("error", "Cập nhật món ăn thất bại. Vui lòng thử lại.");
                    }
                } catch (IllegalArgumentException e) {
                    session.setAttribute("error", e.getMessage() != null ? e.getMessage() : "Dữ liệu món ăn không hợp lệ.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/foods");
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/admin/foods");
                break;
        }
    }

    private void listFoods(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Food> foods = foodDAO.findAll();
        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("foods", foods);
        request.setAttribute("categories", categories);
        request.setAttribute("pageTitle", "Quản lý món ăn");

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

        request.getRequestDispatcher("/views/admin/foods.jsp").forward(request, response);
    }
}
