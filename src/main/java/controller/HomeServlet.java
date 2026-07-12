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

public class HomeServlet extends HttpServlet {

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

        // Load top selling foods (limit 8)
        List<Food> topFoods = foodDAO.findTopSelling(8);

        // Load all categories
        List<Category> categories = categoryDAO.findAll();

        // Set request attributes
        request.setAttribute("topFoods", topFoods);
        request.setAttribute("categories", categories);

        // Forward to home page
        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }
}
