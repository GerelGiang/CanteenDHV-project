<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Font Awesome 6 CDN -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

<%-- Resolve current servlet path for active-link detection --%>
<c:set var="currentPath" value="${pageContext.request.servletPath}"/>
<c:set var="currentQuery" value="${pageContext.request.queryString}"/>
<c:set var="currentURL" value="${pageContext.request.requestURI}"/>

<!-- Admin Sidebar -->
<aside class="admin-sidebar">
    <!-- Brand -->
    <div class="sidebar-brand">
        <a href="${pageContext.request.contextPath}/admin/dashboard">
            <img class="brand-logo" src="${pageContext.request.contextPath}/assets/images/logo_dhv.jpg" alt="Logo DHV Canteen">
            <span class="brand-text">Trang quản trị</span>
        </a>
    </div>

    <!-- Navigation -->
    <nav class="sidebar-nav">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link ${currentURL.endsWith('/admin/dashboard') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-chart-line"></i>
                    <span>Bảng điều khiển</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentURL.endsWith('/admin/foods') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/foods">
                    <i class="fas fa-utensils"></i>
                    <span>Quản lý món ăn</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentURL.endsWith('/admin/categories') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/categories">
                    <i class="fas fa-list"></i>
                    <span>Quản lý danh mục</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentURL.endsWith('/admin/orders') && (empty currentQuery || !currentQuery.contains('action=counter')) ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/orders">
                    <i class="fas fa-receipt"></i>
                    <span>Quản lý đơn hàng</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${not empty currentQuery && currentQuery.contains('action=counter') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/orders?action=counter">
                    <i class="fas fa-cash-register"></i>
                    <span>Bán hàng tại quầy</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentURL.endsWith('/admin/users') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/users">
                    <i class="fas fa-users"></i>
                    <span>Quản lý sinh viên</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentURL.endsWith('/admin/reports') ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/admin/reports">
                    <i class="fas fa-chart-bar"></i>
                    <span>Thống kê</span>
                </a>
            </li>
        </ul>

        <!-- Divider -->
        <hr class="sidebar-divider">

        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-home"></i>
                    <span>Về trang chủ</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-danger-light" href="${pageContext.request.contextPath}/auth?action=logout">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Đăng xuất</span>
                </a>
            </li>
        </ul>
    </nav>

    <!-- Admin info at bottom -->
    <div class="sidebar-footer">
        <div class="admin-info">
            <div class="admin-avatar">
                <i class="fas fa-user-shield"></i>
            </div>
            <div class="admin-details">
                <span class="admin-name">${sessionScope.user.fullName}</span>
                <small class="admin-role">Quản trị viên</small>
            </div>
        </div>
    </div>
</aside>

<style>
    .admin-sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: 260px;
        height: 100vh;
        background: linear-gradient(180deg, #1e1e2f 0%, #2d2d44 100%);
        color: #a0a0b0;
        display: flex;
        flex-direction: column;
        z-index: 1000;
        overflow-y: auto;
        transition: width 0.3s;
    }

    /* Brand */
    .sidebar-brand {
        padding: 1.25rem 1.5rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    }
    .sidebar-brand a {
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    .brand-logo {
        width: 40px;
        height: 40px;
        object-fit: cover;
        border-radius: 12px;
        background: #ffffff;
        padding: 4px;
        box-shadow: 0 4px 14px rgba(0, 0, 0, 0.25);
    }
    .brand-text {
        font-size: 1.15rem;
        font-weight: 700;
        background: linear-gradient(90deg, #667eea, #a78bfa);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    /* Navigation */
    .sidebar-nav {
        flex: 1;
        padding: 0.75rem 0;
    }
    .sidebar-nav .nav-link {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.65rem 1.5rem;
        color: #a0a0b0;
        font-size: 0.9rem;
        font-weight: 500;
        border-left: 3px solid transparent;
        transition: all 0.2s;
    }
    .sidebar-nav .nav-link i {
        width: 20px;
        text-align: center;
        font-size: 0.95rem;
    }
    .sidebar-nav .nav-link:hover {
        color: #fff;
        background: rgba(255, 255, 255, 0.05);
        border-left-color: rgba(102, 126, 234, 0.5);
    }
    .sidebar-nav .nav-link.active {
        color: #fff;
        background: rgba(102, 126, 234, 0.15);
        border-left-color: #667eea;
    }
    .sidebar-nav .nav-link.text-danger-light {
        color: #e57373;
    }
    .sidebar-nav .nav-link.text-danger-light:hover {
        color: #ff5252;
        background: rgba(229, 115, 115, 0.1);
        border-left-color: #e57373;
    }

    /* Divider */
    .sidebar-divider {
        border-color: rgba(255, 255, 255, 0.08);
        margin: 0.5rem 1.5rem;
    }

    /* Footer / Admin Info */
    .sidebar-footer {
        padding: 1rem 1.5rem;
        border-top: 1px solid rgba(255, 255, 255, 0.08);
    }
    .admin-info {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    .admin-avatar {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background: linear-gradient(135deg, #667eea, #764ba2);
        display: flex;
        align-items: center;
        justify-content: center;
        color: #fff;
        font-size: 0.85rem;
    }
    .admin-details {
        display: flex;
        flex-direction: column;
    }
    .admin-name {
        color: #e0e0e0;
        font-weight: 600;
        font-size: 0.85rem;
    }
    .admin-role {
        color: #888;
        font-size: 0.7rem;
    }

    /* Main content offset */
    .admin-content {
        margin-left: 260px;
        min-height: 100vh;
        background: #f4f6fa;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .admin-sidebar {
            width: 70px;
        }
        .admin-sidebar .brand-text,
        .admin-sidebar .nav-link span,
        .admin-sidebar .admin-details,
        .admin-sidebar .sidebar-footer small {
            display: none;
        }
        .sidebar-brand {
            padding: 1.25rem 0.75rem;
            justify-content: center;
        }
        .sidebar-nav .nav-link {
            padding: 0.75rem;
            justify-content: center;
        }
        .sidebar-nav .nav-link i {
            font-size: 1.1rem;
        }
        .admin-content {
            margin-left: 70px;
        }
        .admin-avatar {
            margin: 0 auto;
        }
        .sidebar-footer {
            padding: 1rem 0.5rem;
            display: flex;
            justify-content: center;
        }
    }
</style>
