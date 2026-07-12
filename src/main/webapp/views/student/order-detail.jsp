<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Chi tiết đơn hàng #${order.id} - DHV Canteen" scope="request"/>
<%@ include file="/common/header.jsp" %>

<main class="container py-4" style="min-height: 60vh;">
    <%-- Back button --%>
    <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-primary mb-3">
        <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách đơn hàng
    </a>

    <div class="row">
        <%-- Order info card --%>
        <div class="col-lg-4 mb-4">
            <div class="card border-0 shadow-sm surface-panel" style="border-radius: var(--radius-md);">
                <div class="card-header border-0 text-white" style="background: var(--primary-gradient); border-radius: var(--radius-md) var(--radius-md) 0 0;">
                    <h5 class="mb-0" style="font-family: var(--font-display); font-weight: 700;">
                        <i class="fas fa-info-circle me-2"></i>Thông tin đơn hàng
                    </h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <small class="text-muted d-block">Mã đơn</small>
                        <strong style="font-size: 1.2rem; font-family: var(--font-display);">#${order.id}</strong>
                    </div>

                    <div class="mb-3">
                        <small class="text-muted d-block">Ngày đặt</small>
                        <strong><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></strong>
                    </div>

                    <div class="mb-3">
                        <small class="text-muted d-block">Trạng thái</small>
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
                    </div>

                    <div class="mb-3">
                        <small class="text-muted d-block">Hình thức đặt</small>
                        <c:choose>
                            <c:when test="${order.orderType == 'online'}">
                                <span><i class="fas fa-globe me-1 text-info"></i>Trực tuyến</span>
                            </c:when>
                            <c:otherwise>
                                <span><i class="fas fa-store me-1 text-secondary"></i>Tại quầy</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${not empty order.note}">
                        <div class="mb-3">
                            <small class="text-muted d-block">Ghi chú</small>
                            <span>${order.note}</span>
                        </div>
                    </c:if>

                    <hr>

                    <div class="d-flex justify-content-between align-items-center">
                        <strong style="font-family: var(--font-display); font-size: 1.1rem;">Tổng cộng:</strong>
                        <strong class="gradient-text" style="font-size: 1.4rem; font-family: var(--font-display);">
                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/>₫
                        </strong>
                    </div>

                    <%-- Cancel button for pending orders --%>
                    <c:if test="${order.status == 'pending'}">
                        <hr>
                        <a href="${pageContext.request.contextPath}/orders?action=cancel&id=${order.id}"
                           class="btn btn-danger w-100"
                           onclick="return confirm('Bạn có chắc muốn hủy đơn #${order.id}?');">
                            <i class="fas fa-ban me-1"></i>Hủy đơn hàng
                        </a>
                    </c:if>
                </div>
            </div>
        </div>

        <%-- Order details table --%>
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm surface-panel" style="border-radius: var(--radius-md);">
                <div class="card-header border-0" style="background: var(--bg-warm); border-radius: var(--radius-md) var(--radius-md) 0 0;">
                    <h5 class="mb-0" style="font-family: var(--font-display); font-weight: 700; color: var(--text-primary);">
                        <i class="fas fa-list-ul me-2 gradient-text"></i>Danh sách món
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr style="background: var(--bg-warm);">
                                    <th style="padding: 0.75rem 1rem;">#</th>
                                    <th style="padding: 0.75rem 1rem;">Tên món</th>
                                    <th class="text-end" style="padding: 0.75rem 1rem;">Đơn giá</th>
                                    <th class="text-center" style="padding: 0.75rem 1rem;">Số lượng</th>
                                    <th class="text-end" style="padding: 0.75rem 1rem;">Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="detail" items="${order.orderDetails}" varStatus="loop">
                                    <tr>
                                        <td style="padding: 0.75rem 1rem;">${loop.index + 1}</td>
                                        <td style="padding: 0.75rem 1rem;">
                                            <strong>${detail.foodName}</strong>
                                        </td>
                                        <td class="text-end" style="padding: 0.75rem 1rem;">
                                            <fmt:formatNumber value="${detail.price}" pattern="#,##0"/>₫
                                        </td>
                                        <td class="text-center" style="padding: 0.75rem 1rem;">
                                            <span class="badge bg-light text-dark" style="font-size: 0.9rem;">
                                                ${detail.quantity}
                                            </span>
                                        </td>
                                        <td class="text-end" style="padding: 0.75rem 1rem;">
                                            <strong class="cart-item-price">
                                                <fmt:formatNumber value="${detail.subtotal}" pattern="#,##0"/>₫
                                            </strong>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr style="background: var(--bg-warm);">
                                    <td colspan="4" class="text-end" style="padding: 1rem;">
                                        <strong style="font-family: var(--font-display); font-size: 1.1rem;">Tổng cộng:</strong>
                                    </td>
                                    <td class="text-end" style="padding: 1rem;">
                                        <strong class="gradient-text" style="font-size: 1.25rem; font-family: var(--font-display);">
                                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/>₫
                                        </strong>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/common/footer.jsp" %>
