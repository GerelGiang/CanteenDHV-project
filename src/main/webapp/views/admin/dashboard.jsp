<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển - DHV Canteen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body>

<%@ include file="/common/admin-sidebar.jsp" %>

<div class="admin-content">
    <%@ include file="/common/admin-header.jsp" %>

    <!-- Stat Cards Row 1 -->
    <div class="row g-4 mb-4">
        <div class="col-xl-3 col-md-6">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(76, 175, 80, 0.1); color: var(--success);">
                    <i class="fas fa-money-bill-wave"></i>
                </div>
                <div class="stat-number" style="color: var(--success);">
                    <fmt:formatNumber value="${todayRevenue}" pattern="#,##0"/> VND
                </div>
                <div class="stat-label">Doanh thu hôm nay</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(33, 150, 243, 0.1); color: var(--info);">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <div class="stat-number" style="color: var(--info);">
                    ${todayOrders}
                </div>
                <div class="stat-label">Đơn hàng hôm nay</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(255, 107, 53, 0.1); color: var(--primary-orange);">
                    <i class="fas fa-utensils"></i>
                </div>
                <div class="stat-number" style="color: var(--primary-orange);">
                    ${totalFoods}
                </div>
                <div class="stat-label">Tổng số món ăn</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(156, 39, 176, 0.1); color: #9C27B0;">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <div class="stat-number" style="color: #9C27B0;">
                    ${totalStudents}
                </div>
                <div class="stat-label">Tổng số sinh viên</div>
            </div>
        </div>
    </div>

    <!-- Stat Cards Row 2 -->
    <div class="row g-4 mb-4">
        <div class="col-xl-6 col-md-6">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(76, 175, 80, 0.1); color: var(--success);">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-number" style="color: var(--success);">
                    <fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/> VND
                </div>
                <div class="stat-label">Tổng doanh thu</div>
            </div>
        </div>
        <div class="col-xl-6 col-md-6">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(255, 152, 0, 0.1); color: var(--warning);">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-number" style="color: var(--warning);">
                    ${pendingOrders}
                </div>
                <div class="stat-label">Đơn chờ xác nhận</div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Recent Orders -->
        <div class="col-xl-8">
            <div class="card border-0 shadow-sm surface-panel" style="border-radius: var(--radius-md);">
                <div class="card-header bg-white border-0 pt-3 pb-2 px-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="mb-0" style="font-family: var(--font-display); font-weight: 700;">
                            <i class="fas fa-receipt me-2 text-primary"></i>Đơn hàng gần đây
                        </h5>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-outline-primary" style="border-radius: var(--radius-pill);">
                            Xem tất cả
                        </a>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-canteen mb-0">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày đặt</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${recentOrders}">
                                    <tr>
                                        <td><strong>#${order.id}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty order.userName}">
                                                    ${order.userName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Tại quầy</span>
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
                                            <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${order.id}"
                                               class="btn btn-sm btn-outline-primary" style="border-radius: var(--radius-pill);">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentOrders}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-4">
                                            <i class="fas fa-inbox fa-2x mb-2 d-block opacity-50"></i>
                                            Chưa có đơn hàng
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top Selling Foods -->
        <div class="col-xl-4">
            <div class="card border-0 shadow-sm surface-panel overflow-hidden" style="border-radius: var(--radius-md);">
                <div class="card-header bg-white border-0 pt-3 pb-2 px-4">
                    <h5 class="mb-0" style="font-family: var(--font-display); font-weight: 700;">
                        <i class="fas fa-fire me-2" style="color: var(--primary-orange);"></i>Bán chạy nhất
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="list-group list-group-flush">
                        <c:forEach var="food" items="${topFoods}" varStatus="loop">
                            <div class="list-group-item border-0 d-flex align-items-center px-4 py-3">
                                <div class="me-3">
                                    <span class="badge rounded-pill"
                                          style="background: var(--primary-gradient); width: 28px; height: 28px; display: flex; align-items: center; justify-content: center; font-size: 0.8rem;">
                                        ${loop.index + 1}
                                    </span>
                                </div>
                                <div class="flex-grow-1">
                                    <div style="font-weight: 600; font-size: 0.9rem;">${food.name}</div>
                                    <small class="text-muted">
                                        <fmt:formatNumber value="${food.price}" pattern="#,##0"/> VND
                                    </small>
                                </div>
                                <div class="text-end">
                                    <small class="text-muted">Hạng ${loop.index + 1}</small>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty topFoods}">
                            <div class="text-center text-muted py-4">
                                <i class="fas fa-utensils fa-2x mb-2 d-block opacity-50"></i>
                                Chưa có dữ liệu
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
