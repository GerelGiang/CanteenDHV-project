package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AuthServlet extends HttpServlet {

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
            action = "login";
        }

        switch (action) {
            case "login":
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
                break;
            case "register":
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                break;
            case "logout":
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                response.sendRedirect(request.getContextPath() + "/home");
                break;
            default:
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "login";
        }

        switch (action) {
            case "login":
                processLogin(request, response);
                break;
            case "register":
                processRegister(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/auth?action=login");
                break;
        }
    }

    private void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate input
        if (email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email và mật khẩu.");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        email = email.trim();

        // Hash password and find user
        String hashedPassword = UserDAO.hashPassword(password);
        User user = userDAO.findByEmail(email);

        // Validate: user exists, password matches, status active
        if (user == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        if (!hashedPassword.equals(user.getPassword())) {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        if (user.getStatus() != 1) {
            request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        // Login successful - set session
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // Redirect based on role
        if ("admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/foods");
        }
    }

    private void processRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");

        // Validate required fields
        if (fullName == null || fullName.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ các trường bắt buộc.");
            preserveRegisterForm(request, fullName, email, phone);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        fullName = fullName.trim();
        email = email.trim();
        phone = (phone != null) ? phone.trim() : "";

        // Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            preserveRegisterForm(request, fullName, email, phone);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        // Validate password length
        if (password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            preserveRegisterForm(request, fullName, email, phone);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        // Check email already exists
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email này đã được đăng ký. Vui lòng dùng email khác.");
            preserveRegisterForm(request, fullName, email, phone);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        // Create user object
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(password); // UserDAO.insert() handles hashing
        user.setPhone(phone);
        user.setRole("student");
        user.setStatus(1);

        // Insert into database
        boolean success = userDAO.insert(user);

        if (success) {
            request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/auth?action=login&registered=true");
        } else {
            request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
            preserveRegisterForm(request, fullName, email, phone);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }
    }

    private void preserveRegisterForm(HttpServletRequest request,
                                       String fullName, String email, String phone) {
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
    }
}
