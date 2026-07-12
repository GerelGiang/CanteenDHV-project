<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="vi_VN" scope="session"/>

<%-- Current date --%>
<jsp:useBean id="now" class="java.util.Date"/>

<!-- Admin Top Bar -->
<div class="admin-topbar">
    <div class="topbar-left">
        <!-- Breadcrumb -->
        <c:if test="${not empty requestScope.breadcrumb}">
            <nav aria-label="breadcrumb" class="topbar-breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-home"></i>
                        </a>
                    </li>
                    <c:forEach var="crumb" items="${requestScope.breadcrumb}">
                        <c:choose>
                            <c:when test="${not empty crumb.url}">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}${crumb.url}">${crumb.label}</a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="breadcrumb-item active" aria-current="page">${crumb.label}</li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </ol>
            </nav>
        </c:if>

        <!-- Page Title -->
        <h4 class="topbar-title mb-0">
            ${not empty requestScope.pageTitle ? requestScope.pageTitle : 'Bảng điều khiển'}
        </h4>
    </div>

    <div class="topbar-right">
        <!-- Current Date -->
        <div class="topbar-date d-none d-md-flex">
            <i class="fas fa-calendar-alt me-1"></i>
            <fmt:formatDate value="${now}" pattern="EEEE, dd/MM/yyyy" />
        </div>

        <!-- Admin User Dropdown -->
        <div class="dropdown">
            <a class="topbar-user dropdown-toggle" href="#" id="adminUserDropdown"
               role="button" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="topbar-avatar">
                    <i class="fas fa-user-shield"></i>
                </div>
                <span class="d-none d-md-inline topbar-username">
                    ${sessionScope.user.fullName}
                </span>
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="adminUserDropdown">
                <li>
                    <span class="dropdown-item-text">
                        <strong>${sessionScope.user.fullName}</strong><br>
                        <small class="text-muted">${sessionScope.user.email}</small>
                    </span>
                </li>
                <li><hr class="dropdown-divider"></li>
                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home me-2"></i>Về trang chủ
                    </a>
                </li>
                <li>
                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth?action=logout">
                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                    </a>
                </li>
            </ul>
        </div>
    </div>
</div>

<style>
    .admin-topbar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0.75rem 1.5rem;
        background: #fff;
        border-bottom: 1px solid #e8e8e8;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
    }

    .topbar-left {
        display: flex;
        flex-direction: column;
        gap: 0.15rem;
    }
    .topbar-breadcrumb .breadcrumb {
        font-size: 0.75rem;
    }
    .topbar-breadcrumb .breadcrumb-item a {
        color: #888;
        text-decoration: none;
    }
    .topbar-breadcrumb .breadcrumb-item a:hover {
        color: #667eea;
    }
    .topbar-breadcrumb .breadcrumb-item.active {
        color: #555;
    }
    .topbar-title {
        font-size: 1.2rem;
        font-weight: 700;
        color: #2d2d44;
    }

    .topbar-right {
        display: flex;
        align-items: center;
        gap: 1.25rem;
    }
    .topbar-date {
        align-items: center;
        font-size: 0.85rem;
        color: #888;
    }

    .topbar-user {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        text-decoration: none;
        color: #444;
        padding: 0.35rem 0.75rem;
        border-radius: 0.5rem;
        transition: background 0.2s;
    }
    .topbar-user:hover {
        background: #f0f0f0;
        color: #333;
    }
    .topbar-avatar {
        width: 34px;
        height: 34px;
        border-radius: 50%;
        background: linear-gradient(135deg, #667eea, #764ba2);
        display: flex;
        align-items: center;
        justify-content: center;
        color: #fff;
        font-size: 0.8rem;
    }
    .topbar-username {
        font-weight: 600;
        font-size: 0.88rem;
    }

    .admin-topbar .dropdown-menu {
        border: none;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.12);
        border-radius: 0.5rem;
        min-width: 220px;
    }
    .admin-topbar .dropdown-item {
        font-size: 0.88rem;
        padding: 0.45rem 1rem;
    }
    .admin-topbar .dropdown-item:hover {
        background: #f5f5f5;
    }
</style>
