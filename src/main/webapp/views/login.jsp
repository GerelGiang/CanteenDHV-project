<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - DHV Canteen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', Tahoma, Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
        }

        .auth-container {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            padding: 48px 40px;
            width: 100%;
            max-width: 440px;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .auth-logo {
            text-align: center;
            margin-bottom: 32px;
        }

        .auth-logo .logo-icon {
            width: 90px;
            height: 90px;
            border-radius: 22px;
            display: inline-block;
            margin-bottom: 16px;
            object-fit: cover;
            background: #ffffff;
            padding: 6px;
            box-shadow: 0 12px 28px rgba(102, 126, 234, 0.28);
        }

        .auth-logo h2 {
            font-family: 'Nunito', 'Segoe UI', Tahoma, Arial, sans-serif;
            font-weight: 800;
            font-size: 24px;
            color: #1a1a2e;
            margin-bottom: 4px;
        }

        .auth-logo p {
            color: #6c757d;
            font-size: 14px;
            margin: 0;
        }

        .form-label {
            font-weight: 600;
            color: #344054;
            font-size: 14px;
            margin-bottom: 6px;
        }

        .form-control {
            border: 1.5px solid #d0d5dd;
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 15px;
            transition: all 0.2s ease;
            background: #f9fafb;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.15);
            background: #ffffff;
        }

        .form-control::placeholder {
            color: #98a2b3;
        }

        .input-group-text {
            background: #f9fafb;
            border: 1.5px solid #d0d5dd;
            border-right: none;
            border-radius: 10px 0 0 10px;
            color: #667085;
        }

        .input-group .form-control {
            border-left: none;
            border-radius: 0 10px 10px 0;
        }

        .input-group:focus-within .input-group-text {
            border-color: #667eea;
        }

        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 13px;
            font-size: 16px;
            font-weight: 700;
            font-family: 'Nunito', sans-serif;
            color: #ffffff;
            width: 100%;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.35);
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.45);
            color: #ffffff;
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .auth-footer {
            text-align: center;
            margin-top: 24px;
            font-size: 14px;
            color: #667085;
        }

        .auth-footer a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .auth-footer a:hover {
            text-decoration: underline;
        }

        .alert {
            border-radius: 10px;
            border: none;
            font-size: 14px;
            padding: 12px 16px;
        }

        .alert-danger {
            background: #fef3f2;
            color: #b42318;
        }

        .alert-success {
            background: #ecfdf3;
            color: #027a48;
        }

        .mb-form-group {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="auth-container">
    <!-- Logo area -->
    <div class="auth-logo">
        <img class="logo-icon" src="${pageContext.request.contextPath}/assets/images/logo_dhv.jpg" alt="Logo DHV Canteen">
        <h2>DHV Canteen</h2>
        <p>Đăng nhập để tiếp tục</p>
    </div>

    <!-- Error message -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-circle me-2"></i>${error}
        </div>
    </c:if>

    <!-- Success message -->
    <c:if test="${not empty success}">
        <div class="alert alert-success">
            <i class="bi bi-check-circle me-2"></i>${success}
        </div>
    </c:if>

    <!-- Success from registration redirect -->
    <c:if test="${param.registered == 'true'}">
        <div class="alert alert-success">
            <i class="bi bi-check-circle me-2"></i>Đăng ký thành công! Vui lòng đăng nhập.
        </div>
    </c:if>

    <!-- Login form -->
    <form action="${pageContext.request.contextPath}/auth" method="post">
        <input type="hidden" name="action" value="login">

        <div class="mb-form-group">
            <label for="email" class="form-label">Email</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                <input type="email" class="form-control" id="email" name="email"
                       placeholder="Nhập email của bạn" required>
            </div>
        </div>

        <div class="mb-form-group">
            <label for="password" class="form-label">Mật khẩu</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                <input type="password" class="form-control" id="password" name="password"
                       placeholder="Nhập mật khẩu" required>
            </div>
        </div>

        <button type="submit" class="btn btn-login">
            <i class="bi bi-box-arrow-in-right me-2"></i>Đăng nhập
        </button>
    </form>

    <div class="auth-footer">
        Chưa có tài khoản?
        <a href="${pageContext.request.contextPath}/auth?action=register">Đăng ký ngay</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
