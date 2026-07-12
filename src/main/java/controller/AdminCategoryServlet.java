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
import util.FileUploadUtil;
import model.Category;

public class AdminCategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
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
            case "add":
                request.setAttribute("pageTitle", "Thêm danh mục");
                request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);
                break;
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Category category = categoryDAO.findById(editId);
                if (category != null) {
                    request.setAttribute("category", category);
                    request.setAttribute("pageTitle", "Sửa danh mục");
                    request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);
                } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("error", "Không tìm thấy danh mục.");
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                }
                break;
            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                boolean deleted = categoryDAO.delete(deleteId);
                HttpSession session = request.getSession();
                if (deleted) {
                    session.setAttribute("success", "Đã xóa danh mục thành công!");
                } else {
                    session.setAttribute("error", "Không thể xóa danh mục đang có món ăn.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                break;
            default:
                listCategories(request, response);
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

                    String uploadDir = getServletContext().getRealPath("/uploads/categories");
                    Part filePart = request.getPart("image");
                    String fileName = FileUploadUtil.saveFile(filePart, uploadDir);

                    Category category = new Category();
                    category.setName(name);
                    category.setDescription(description);
                    category.setImage(fileName);

                    boolean success = categoryDAO.insert(category);
                    if (success) {
                        session.setAttribute("success", "Đã thêm danh mục thành công!");
                    } else {
                        session.setAttribute("error", "Thêm danh mục thất bại. Vui lòng thử lại.");
                    }
                } catch (IllegalArgumentException e) {
                    session.setAttribute("error", e.getMessage() != null ? e.getMessage() : "Dữ liệu danh mục không hợp lệ.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                break;
            }
            case "edit": {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String name = request.getParameter("name");
                    String description = request.getParameter("description");

                    String uploadDir = getServletContext().getRealPath("/uploads/categories");
                    Part filePart = request.getPart("image");
                    String fileName = FileUploadUtil.saveFile(filePart, uploadDir);

                    // If no new file uploaded, keep the existing image
                    if (fileName == null) {
                        Category oldCategory = categoryDAO.findById(id);
                        if (oldCategory != null) {
                            fileName = oldCategory.getImage();
                        }
                    }

                    Category category = new Category();
                    category.setId(id);
                    category.setName(name);
                    category.setDescription(description);
                    category.setImage(fileName);

                    boolean success = categoryDAO.update(category);
                    if (success) {
                        session.setAttribute("success", "Đã cập nhật danh mục thành công!");
                    } else {
                        session.setAttribute("error", "Cập nhật danh mục thất bại. Vui lòng thử lại.");
                    }
                } catch (IllegalArgumentException e) {
                    session.setAttribute("error", e.getMessage() != null ? e.getMessage() : "Dữ liệu danh mục không hợp lệ.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                break;
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);
        request.setAttribute("pageTitle", "Quản lý danh mục");

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

        request.getRequestDispatcher("/views/admin/categories.jsp").forward(request, response);
    }
}
