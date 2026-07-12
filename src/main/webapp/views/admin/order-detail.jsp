<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${order.id} - DHV Canteen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body>

<%@ include file="/common/admin-sidebar.jsp" %>

<div class="admin-content">
    <%@ include file="/common/admin-header.jsp" %>

    <!-- Back Button -->
    <div class="mb-4">
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary" style="border-radius: var(--radius-pill);">
            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
        </a>
    </div>

    <div class="row g-4">
        <!-- Order Info -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm surface-panel" style="border-radius: var(--radius-md);">
                <div class="card-header bg-white border-0 pt-4 pb-2 px-4">
                    <h5 class="mb-0" style="font-family: var(--font-display); font-weight: 700;">
                        <i class="fas fa-info-circle me-2" style="color: var(--primary-orange);"></i>Thông tin đơn hàng
                    </h5>
                </div>
                <div class="card-body px-4 pb-4">
                    <table class="table table-borderless mb-0">
                        <tr>
                            <td class="text-muted" style="width: 140px;">Mã đơn:</td>
                            <td><strong>#${order.id}</strong></td>
                        </tr>
                        <tr>
                            <td class="text-muted">Khách hàng:</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty order.userName}">
                                        <strong>${order.userName}</strong>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Khách mua tại quầy</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted">Hình thức đặt:</td>
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
                        </tr>
                        <tr>
                            <td class="text-muted">Ngày đặt:</td>
                            <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                        </tr>
                        <tr>
                            <td class="text-muted">Trạng thái:</td>
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
                        </tr>
                        <c:if test="${not empty order.note}">
                            <tr>
                                <td class="text-muted">Ghi chú:</td>
                                <td>${order.note}</td>
                            </tr>
                        </c:if>
                    </table>
                </div>
            </div>
        </div>

        <!-- Status Update -->
        <div class="col-lg-6">
            <c:if test="${order.status != 'completed' && order.status != 'cancelled'}">
                <div class="card border-0 shadow-sm surface-panel" style="border-radius: var(--radius-md);">
                    <div class="card-header bg-white border-0 pt-4 pb-2 px-4">
                        <h5 class="mb-0" style="font-family: var(--font-display); font-weight: 700;">
                            <i class="fas fa-exchange-alt me-2" style="color: var(--info);"></i>Cập nhật trạng thái
                        </h5>
                    </div>
                    <div class="card-body px-4 pb-4">
                        <div class="d-flex flex-wrap gap-2">
                            <c:if test="${order.status == 'pending'}">
                                <a href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=confirmed"
                                   class="btn btn-info text-white">
                                    <i class="fas fa-check me-2"></i>Xác nhận đơn
                                </a>
                            </c:if>
                            <c:if test="${order.status == 'pending' || order.status == 'confirmed'}">
                                <a href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=preparing"
                                   class="btn btn-warning text-white">
                                    <i class="fas fa-fire me-2"></i>Bắt đầu chuẩn bị
                                </a>
                            </c:if>
                            <c:if test="${order.status == 'preparing' || order.status == 'confirmed'}">
                                <a href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=completed"
                                   class="btn btn-success">
                                    <i class="fas fa-check-double me-2"></i>Hoàn thành
                                </a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=cancelled"
                               class="btn btn-danger"
                               onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?');">
                                <i class="fas fa-times me-2"></i>Hủy đơn
                            </a>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Order Items -->
    <div class="card border-0 shadow-sm surface-panel mt-4" style="border-radius: var(--radius-md);">
        <div class="card-header bg-white border-0 pt-4 pb-2 px-4">
            <h5 class="mb-0" style="font-family: var(--font-display); font-weight: 700;">
                <i class="fas fa-shopping-basket me-2" style="color: var(--primary-orange);"></i>Danh sách món
            </h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-canteen mb-0">
                    <thead>
                        <tr>
                            <th>Tên món</th>
                            <th>Đơn giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="detail" items="${order.orderDetails}">
                            <tr>
                                <td><strong>${detail.foodName}</strong></td>
                                <td><fmt:formatNumber value="${detail.price}" pattern="#,##0"/> VND</td>
                                <td>${detail.quantity}</td>
                                <td><strong style="color: var(--primary-orange);"><fmt:formatNumber value="${detail.subtotal}" pattern="#,##0"/> VND</strong></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr style="background: rgba(255, 107, 53, 0.05);">
                            <td colspan="3" class="text-end" style="font-family: var(--font-display); font-weight: 700; font-size: 1.1rem;">
                                Tổng cộng:
                            </td>
                            <td style="font-family: var(--font-display); font-weight: 800; font-size: 1.2rem; color: var(--primary-orange);">
                                <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/> VND
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
