<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="vi_VN" scope="session"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'DHV Canteen'}</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">

    <style>
        .navbar-canteen {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
            padding: 0.5rem 1rem;
        }
        .navbar-canteen .navbar-brand {
            display: flex;
            align-items: center;
            gap: 0.7rem;
            font-size: 1.4rem;
            font-weight: 700;
            color: #ffffff !important;
            -webkit-text-fill-color: #ffffff;
            text-decoration: none;
        }
        .navbar-canteen .brand-logo {
            width: 42px;
            height: 42px;
            object-fit: cover;
            border-radius: 12px;
            background: #ffffff;
            padding: 4px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        .navbar-canteen .brand-name {
            letter-spacing: 0.02em;
        }
        .navbar-canteen .nav-link {
            color: rgba(255, 255, 255, 0.85) !important;
            font-weight: 500;
            transition: color 0.2s;
            padding: 0.5rem 1rem;
        }
        .navbar-canteen .nav-link:hover,
        .navbar-canteen .nav-link.active {
            color: #fff !important;
        }
        .navbar-canteen .btn-outline-light {
            border-color: rgba(255, 255, 255, 0.5);
            font-weight: 500;
        }
        .navbar-canteen .btn-outline-light:hover {
            background-color: rgba(255, 255, 255, 0.15);
        }
        .navbar-canteen .btn-warning {
            font-weight: 600;
        }
        .cart-badge {
            position: relative;
        }
        .cart-badge .badge {
            position: absolute;
            top: -5px;
            right: -10px;
            font-size: 0.65rem;
        }
        .navbar-canteen .dropdown-menu {
            border: none;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
            border-radius: 0.5rem;
        }
        .navbar-canteen .dropdown-item:hover {
            background-color: #f0f0f0;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark navbar-canteen sticky-top">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <img class="brand-logo" src="${pageContext.request.contextPath}/assets/images/logo_dhv.jpg" alt="Logo DHV Canteen">
            <span class="brand-name">DHV Canteen</span>
        </a>

        <!-- Hamburger toggle -->
        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse" data-bs-target="#navbarMain"
                aria-controls="navbarMain" aria-expanded="false"
                aria-label="Chuyển đổi điều hướng">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarMain">
            <!-- Left nav -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home me-1"></i>Trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/foods">
                        <i class="fas fa-utensils me-1"></i>Thực đơn
                    </a>
                </li>
            </ul>

            <!-- Right nav -->
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <c:choose>
                    <%-- User is logged in --%>
                    <c:when test="${sessionScope.user != null}">
                        <%-- Student-only links --%>
                        <c:if test="${sessionScope.user.role == 'student'}">
                            <li class="nav-item">
                                <a class="nav-link cart-badge" href="${pageContext.request.contextPath}/cart">
                                    <i class="fas fa-shopping-cart me-1"></i>Giỏ hàng
                                    <c:if test="${sessionScope.cart != null && sessionScope.cart.size() > 0}">
                                        <span class="badge bg-danger rounded-pill">
                                            ${sessionScope.cart.size()}
                                        </span>
                                    </c:if>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/orders">
                                    <i class="fas fa-receipt me-1"></i>Đơn hàng
                                </a>
                            </li>
                        </c:if>

                        <%-- Admin-only link --%>
                        <c:if test="${sessionScope.user.role == 'admin'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="fas fa-cogs me-1"></i>Quản trị
                                </a>
                            </li>
                        </c:if>

                        <%-- User dropdown --%>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown"
                               role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user-circle me-1"></i>${sessionScope.user.fullName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li>
                                    <span class="dropdown-item-text text-muted">
                                        <small><i class="fas fa-envelope me-1"></i>${sessionScope.user.email}</small>
                                    </span>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth?action=logout">
                                        <i class="fas fa-sign-out-alt me-1"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>

                    <%-- User is not logged in --%>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="btn btn-outline-light me-2" href="${pageContext.request.contextPath}/auth?action=login">
                                <i class="fas fa-sign-in-alt me-1"></i>Đăng nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-warning" href="${pageContext.request.contextPath}/auth?action=register">
                                <i class="fas fa-user-plus me-1"></i>Đăng ký
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- Flash messages -->
<c:if test="${not empty sessionScope.successMessage}">
    <div class="container mt-3">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-1"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
        </div>
    </div>
    <c:remove var="successMessage" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.errorMessage}">
    <div class="container mt-3">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-1"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
        </div>
    </div>
    <c:remove var="errorMessage" scope="session"/>
</c:if>
