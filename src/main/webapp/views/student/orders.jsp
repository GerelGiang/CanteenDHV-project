<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Đơn hàng của tôi - DHV Canteen" scope="request"/>
<%@ include file="/common/header.jsp" %>

<main class="container py-4" style="min-height: 60vh;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 style="font-family: var(--font-display); font-weight: 800; margin-bottom: 0;">
            <i class="fas fa-receipt me-2 gradient-text"></i>Đơn hàng của tôi
        </h2>
        <a href="${pageContext.request.contextPath}/foods" class="btn btn-outline-primary">
            <i class="fas fa-utensils me-1"></i>Xem thực đơn
        </a>
    </div>

    <c:choose>
        <%-- No orders --%>
        <c:when test="${empty orders}">
            <div class="empty-state">
                <i class="fas fa-clipboard-list" style="font-size: 4rem; color: var(--primary-orange); opacity: 0.3;"></i>
                <h5 class="mt-3">Bạn chưa có đơn hàng nào</h5>
                <p class="text-muted">Hãy chọn món từ thực đơn của chúng tôi!</p>
                <a href="${pageContext.request.contextPath}/foods" class="btn btn-canteen btn-lg mt-2">
                    <i class="fas fa-utensils me-2"></i>Xem thực đơn
                </a>
            </div>
        </c:when>

        <%-- Orders table --%>
        <c:otherwise>
            <div class="surface-panel p-0 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-canteen mb-0">
                        <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Ngày đặt</th>
                                <th class="text-end">Tổng tiền</th>
                                <th class="text-center">Hình thức</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>
                                        <strong>#${order.id}</strong>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td class="text-end">
                                        <strong class="cart-item-price">
                                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/>₫
                                        </strong>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${order.orderType == 'online'}">
                                                <span class="badge bg-info bg-opacity-10 text-info">
                                                    <i class="fas fa-globe me-1"></i>Trực tuyến
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary">
                                                    <i class="fas fa-store me-1"></i>Tại quầy
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${order.status == 'pending'}">
                                                <span class="badge-pending">
                                                    <i class="fas fa-clock me-1"></i>Chờ xác nhận
                                                </span>
                                            </c:when>
                                            <c:when test="${order.status == 'confirmed'}">
                                                <span class="badge-confirmed">
                                                    <i class="fas fa-check me-1"></i>Đã xác nhận
                                                </span>
                                            </c:when>
                                            <c:when test="${order.status == 'preparing'}">
                                                <span class="badge-preparing">
                                                    <i class="fas fa-fire me-1"></i>Đang chuẩn bị
                                                </span>
                                            </c:when>
                                            <c:when test="${order.status == 'completed'}">
                                                <span class="badge-completed">
                                                    <i class="fas fa-check-double me-1"></i>Hoàn thành
                                                </span>
                                            </c:when>
                                            <c:when test="${order.status == 'cancelled'}">
                                                <span class="badge-cancelled">
                                                    <i class="fas fa-times me-1"></i>Đã hủy
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/orders?action=detail&id=${order.id}"
                                           class="btn btn-sm btn-outline-primary me-1" title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <c:if test="${order.status == 'pending'}">
                                            <a href="${pageContext.request.contextPath}/orders?action=cancel&id=${order.id}"
                                               class="btn btn-sm btn-outline-danger" title="Hủy đơn"
                                               onclick="return confirm('Bạn có chắc muốn hủy đơn #${order.id}?');">
                                                <i class="fas fa-ban"></i>
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<%@ include file="/common/footer.jsp" %>
