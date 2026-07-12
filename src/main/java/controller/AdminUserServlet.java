package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UserDAO;
import model.User;

public class AdminUserServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "toggleStatus": {
                int id = Integer.parseInt(request.getParameter("id"));
                int currentStatus = Integer.parseInt(request.getParameter("currentStatus"));
                int newStatus = (currentStatus == 1) ? 0 : 1;
                boolean updated = userDAO.updateStatus(id, newStatus);

                HttpSession session = request.getSession();
                if (updated) {
                    if (newStatus == 1) {
                        session.setAttribute("success", "Đã mở khóa tài khoản thành công!");
                    } else {
                        session.setAttribute("success", "Đã khóa tài khoản thành công!");
                    }
                } else {
                    session.setAttribute("error", "Cập nhật trạng thái thất bại. Vui lòng thử lại.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/users");
                break;
            }
            default:
                listUsers(request, response);
                break;
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> students = userDAO.findAllStudents();
        request.setAttribute("students", students);
        request.setAttribute("pageTitle", "Quản lý sinh viên");

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

        request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
    }
}
