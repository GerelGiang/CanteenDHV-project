package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.CategoryDAO;
import dao.FoodDAO;
import model.Category;
import model.Food;

public class FoodServlet extends HttpServlet {

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

        // Read filter parameters
        String categoryParam = request.getParameter("category");
        String keyword = request.getParameter("keyword");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");
        String sort = request.getParameter("sort");

        // Parse optional params
        Integer categoryId = null;
        Double minPrice = null;
        Double maxPrice = null;

        if (categoryParam != null && !categoryParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryParam);
            } catch (NumberFormatException e) {
                // ignore invalid category
            }
        }
        if (minPriceParam != null && !minPriceParam.trim().isEmpty()) {
            try {
                minPrice = Double.parseDouble(minPriceParam);
            } catch (NumberFormatException e) {
                // ignore
            }
        }
        if (maxPriceParam != null && !maxPriceParam.trim().isEmpty()) {
            try {
                maxPrice = Double.parseDouble(maxPriceParam);
            } catch (NumberFormatException e) {
                // ignore
            }
        }

        // Load all categories for sidebar filter
        List<Category> categories = categoryDAO.findAll();

        // Load foods based on filter params
        List<Food> foods;

        boolean hasSearchParams = (keyword != null && !keyword.trim().isEmpty())
                || minPrice != null || maxPrice != null
                || (sort != null && !sort.trim().isEmpty());

        if (hasSearchParams || categoryId != null) {
            // Use advanced search
            foods = foodDAO.searchAvailable(keyword, categoryId, minPrice, maxPrice, sort);
        } else {
            // Default: all available foods
            foods = foodDAO.findAvailable();
        }

        // Set request attributes
        request.setAttribute("foods", foods);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("keyword", keyword);
        request.setAttribute("minPrice", minPriceParam);
        request.setAttribute("maxPrice", maxPriceParam);
        request.setAttribute("sort", sort);

        // Forward to menu page
        request.getRequestDispatcher("/views/student/menu.jsp").forward(request, response);
    }
}
