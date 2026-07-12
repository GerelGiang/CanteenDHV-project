<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - DHV Canteen</title>
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
            padding: 40px;
            width: 100%;
            max-width: 480px;
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
            margin-bottom: 28px;
        }

        .auth-logo .logo-icon {
            width: 86px;
            height: 86px;
            border-radius: 22px;
            display: inline-block;
            margin-bottom: 14px;
            object-fit: cover;
            background: #ffffff;
            padding: 6px;
            box-shadow: 0 12px 28px rgba(102, 126, 234, 0.28);
        }

        .auth-logo h2 {
            font-family: 'Nunito', 'Segoe UI', Tahoma, Arial, sans-serif;
            font-weight: 800;
            font-size: 22px;
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
            padding: 11px 16px;
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

        .btn-register {
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

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.45);
            color: #ffffff;
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .auth-footer {
            text-align: center;
            margin-top: 20px;
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
            margin-bottom: 18px;
        }

        .password-hint {
            font-size: 12px;
            color: #98a2b3;
            margin-top: 4px;
        }

        .invalid-feedback {
            font-size: 13px;
        }
    </style>
</head>
<body>

<div class="auth-container">
    <!-- Logo area -->
    <div class="auth-logo">
        <img class="logo-icon" src="${pageContext.request.contextPath}/assets/images/logo_dhv.jpg" alt="Logo DHV Canteen">
        <h2>Tạo tài khoản</h2>
        <p>Đăng ký để đặt món tại căn tin</p>
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

    <!-- Register form -->
    <form action="${pageContext.request.contextPath}/auth" method="post" id="registerForm" novalidate>
        <input type="hidden" name="action" value="register">

        <div class="mb-form-group">
            <label for="fullName" class="form-label">Họ và tên <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-person"></i></span>
                <input type="text" class="form-control" id="fullName" name="fullName"
                       placeholder="Nhập họ và tên" value="${fullName}" required>
            </div>
        </div>

        <div class="mb-form-group">
            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                <input type="email" class="form-control" id="email" name="email"
                       placeholder="Nhập email của bạn" value="${email}" required>
            </div>
        </div>

        <div class="mb-form-group">
            <label for="phone" class="form-label">Số điện thoại</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                <input type="tel" class="form-control" id="phone" name="phone"
                       placeholder="Nhập số điện thoại" value="${phone}">
            </div>
        </div>

        <div class="mb-form-group">
            <label for="password" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                <input type="password" class="form-control" id="password" name="password"
                       placeholder="Nhập mật khẩu" required minlength="6">
            </div>
            <div class="password-hint">Mật khẩu phải có ít nhất 6 ký tự</div>
        </div>

        <div class="mb-form-group">
            <label for="confirmPassword" class="form-label">Xác nhận mật khẩu <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                       placeholder="Nhập lại mật khẩu" required>
            </div>
            <div class="invalid-feedback" id="passwordError" style="display:none; color:#b42318;">
                Mật khẩu xác nhận không khớp.
            </div>
        </div>

        <button type="submit" class="btn btn-register">
            <i class="bi bi-person-plus me-2"></i>Đăng ký
        </button>
    </form>

    <div class="auth-footer">
        Đã có tài khoản?
        <a href="${pageContext.request.contextPath}/auth?action=login">Đăng nhập</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        var password = document.getElementById('password').value;
        var confirmPassword = document.getElementById('confirmPassword').value;
        var fullName = document.getElementById('fullName').value.trim();
        var email = document.getElementById('email').value.trim();
        var errorDiv = document.getElementById('passwordError');

        // Reset
        errorDiv.style.display = 'none';

        // Check required fields
        if (fullName === '' || email === '' || password === '' || confirmPassword === '') {
            e.preventDefault();
            alert('Vui lòng điền đầy đủ các trường bắt buộc.');
            return;
        }

        // Check password length
        if (password.length < 6) {
            e.preventDefault();
            alert('Mật khẩu phải có ít nhất 6 ký tự.');
            return;
        }

        // Check password match
        if (password !== confirmPassword) {
            e.preventDefault();
            errorDiv.style.display = 'block';
            document.getElementById('confirmPassword').focus();
            return;
        }
    });

    // Real-time password match check
    document.getElementById('confirmPassword').addEventListener('input', function() {
        var password = document.getElementById('password').value;
        var confirmPassword = this.value;
        var errorDiv = document.getElementById('passwordError');

        if (confirmPassword !== '' && password !== confirmPassword) {
            errorDiv.style.display = 'block';
        } else {
            errorDiv.style.display = 'none';
        }
    });
</script>
</body>
</html>
