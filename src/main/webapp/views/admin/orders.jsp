<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng - DHV Canteen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body>

<%@ include file="/common/admin-sidebar.jsp" %>

<div class="admin-content">
    <%@ include file="/common/admin-header.jsp" %>

    <!-- Flash Messages -->
    <c:if test="${not empty success}">
        <div class="alert alert-canteen alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-canteen alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Header Bar -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h5 class="mb-0" style="font-family: var(--font-display); font-weight: 700;">
            <i class="fas fa-receipt me-2" style="color: var(--primary-orange);"></i>Danh sách đơn hàng
        </h5>
        <a href="${pageContext.request.contextPath}/admin/orders?action=counter" class="btn btn-canteen">
            <i class="fas fa-cash-register me-2"></i>Bán tại quầy
        </a>
    </div>

    <!-- Status Filter Tabs -->
    <div class="surface-toolbar mb-4 p-3">
        <div class="d-flex flex-wrap gap-2">
            <a href="${pageContext.request.contextPath}/admin/orders"
               class="btn btn-sm ${empty param.status ? 'btn-primary' : 'btn-outline-secondary'}" style="border-radius: var(--radius-pill);">
                Tất cả
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=pending"
               class="btn btn-sm ${param.status == 'pending' ? 'btn-warning' : 'btn-outline-warning'}" style="border-radius: var(--radius-pill);">
                Chờ xác nhận
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=confirmed"
               class="btn btn-sm ${param.status == 'confirmed' ? 'btn-info' : 'btn-outline-info'}" style="border-radius: var(--radius-pill);">
                Đã xác nhận
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=preparing"
               class="btn btn-sm ${param.status == 'preparing' ? 'btn-primary' : 'btn-outline-primary'}" style="border-radius: var(--radius-pill);">
                Đang chuẩn bị
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=completed"
               class="btn btn-sm ${param.status == 'completed' ? 'btn-success' : 'btn-outline-success'}" style="border-radius: var(--radius-pill);">
                Hoàn thành
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=cancelled"
               class="btn btn-sm ${param.status == 'cancelled' ? 'btn-danger' : 'btn-outline-danger'}" style="border-radius: var(--radius-pill);">
                Đã hủy
            </a>
        </div>
    </div>

    <!-- Table -->
    <div class="surface-panel p-0 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-canteen mb-0">
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>Hình thức</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Ngày đặt</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <!-- Filter by status if param is set -->
                        <c:if test="${empty param.status || order.status == param.status}">
                            <tr>
                                <td><strong>#${order.id}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty order.userName}">
                                            ${order.userName}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-light text-dark" style="font-weight: 500;">
                                                <i class="fas fa-store me-1"></i>Tại quầy
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.orderType == 'counter'}">
                                            <span class="badge bg-secondary">Tại quầy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-info">Trực tuyến</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><strong><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/> VND</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status == 'pending'}">
                                            <span class="badge-pending">Chờ xác nhận</span>
                                        </c:when>
                                        <c:when test="${order.status == 'confirmed'}">
                                            <span class="badge-confirmed">Đã xác nhận</span>
                                        </c:when>
                                        <c:when test="${order.status == 'preparing'}">
                                            <span class="badge-preparing">Đang chuẩn bị</span>
                                        </c:when>
                                        <c:when test="${order.status == 'completed'}">
                                            <span class="badge-completed">Hoàn thành</span>
                                        </c:when>
                                        <c:when test="${order.status == 'cancelled'}">
                                            <span class="badge-cancelled">Đã hủy</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <div class="d-flex gap-1 align-items-center">
                                        <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${order.id}"
                                           class="btn btn-sm btn-outline-primary" style="border-radius: var(--radius-pill);"
                                           title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </a>

                                        <!-- Status update dropdown (only for non-terminal statuses) -->
                                        <c:if test="${order.status != 'completed' && order.status != 'cancelled'}">
                                            <div class="dropdown">
                                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button"
                                                        data-bs-toggle="dropdown" style="border-radius: var(--radius-pill);">
                                                    <i class="fas fa-exchange-alt"></i>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-end">
                                                    <c:if test="${order.status == 'pending'}">
                                                        <li>
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=confirmed">
                                                                <i class="fas fa-check me-2 text-info"></i>Xác nhận
                                                            </a>
                                                        </li>
                                                    </c:if>
                                                    <c:if test="${order.status == 'pending' || order.status == 'confirmed'}">
                                                        <li>
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=preparing">
                                                                <i class="fas fa-fire me-2" style="color: var(--primary-orange);"></i>Chuẩn bị
                                                            </a>
                                                        </li>
                                                    </c:if>
                                                    <c:if test="${order.status == 'preparing' || order.status == 'confirmed'}">
                                                        <li>
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=completed">
                                                                <i class="fas fa-check-double me-2 text-success"></i>Hoàn thành
                                                            </a>
                                                        </li>
                                                    </c:if>
                                                    <li><hr class="dropdown-divider"></li>
                                                    <li>
                                                        <a class="dropdown-item text-danger"
                                                           href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=cancelled"
                                                           onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?');">
                                                            <i class="fas fa-times me-2"></i>Hủy đơn
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">
                                <i class="fas fa-receipt fa-2x mb-2 d-block opacity-50"></i>
                                Chưa có đơn hàng
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
