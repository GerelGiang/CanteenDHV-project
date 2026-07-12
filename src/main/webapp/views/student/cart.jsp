<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Giỏ hàng - DHV Canteen" scope="request"/>
<%@ include file="/common/header.jsp" %>

<main class="container py-4" style="min-height: 60vh;">
    <h2 class="mb-4" style="font-family: var(--font-display); font-weight: 800;">
        <i class="fas fa-shopping-cart me-2 gradient-text"></i>Giỏ hàng của bạn
    </h2>

    <c:choose>
        <%-- Empty cart state --%>
        <c:when test="${empty sessionScope.cart || sessionScope.cart.size() == 0}">
            <div class="empty-state">
                <i class="fas fa-shopping-basket" style="font-size: 4rem; color: var(--primary-orange); opacity: 0.3;"></i>
                <h5 class="mt-3">Giỏ hàng đang trống</h5>
                <p class="text-muted">Bạn chưa thêm món nào vào giỏ hàng.</p>
                <a href="${pageContext.request.contextPath}/foods" class="btn btn-canteen btn-lg mt-2">
                    <i class="fas fa-utensils me-2"></i>Xem thực đơn
                </a>
            </div>
        </c:when>

        <%-- Cart has items --%>
        <c:otherwise>
            <div class="row">
                <%-- Cart items column --%>
                <div class="col-lg-8 mb-4">
                    <div class="table-canteen">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th style="width: 50px;">#</th>
                                    <th style="width: 70px;">Ảnh</th>
                                    <th>Món ăn</th>
                                    <th class="text-end">Đơn giá</th>
                                    <th class="text-center" style="width: 140px;">Số lượng</th>
                                    <th class="text-end">Tạm tính</th>
                                    <th class="text-center" style="width: 60px;">Xóa</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${sessionScope.cart}" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.food.image}">
                                                    <img src="${pageContext.request.contextPath}/uploads/foods/${item.food.image}"
                                                         alt="${item.food.name}"
                                                         class="rounded"
                                                         style="width: 50px; height: 50px; object-fit: cover;">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/assets/images/no-image.svg"
                                                         alt="Chưa có ảnh"
                                                         class="rounded"
                                                         style="width: 50px; height: 50px; object-fit: cover;">
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="cart-item-name">${item.food.name}</span>
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${item.food.price}" pattern="#,##0"/>₫
                                        </td>
                                        <td class="text-center">
                                            <div class="qty-stepper mx-auto">
                                                <a href="${pageContext.request.contextPath}/cart?action=decrease&id=${item.food.id}"
                                                   style="text-decoration: none;">
                                                    <button type="button" title="Giảm">
                                                        <i class="fas fa-minus" style="font-size: 0.7rem;"></i>
                                                    </button>
                                                </a>
                                                <span class="qty-value">${item.quantity}</span>
                                                <a href="${pageContext.request.contextPath}/cart?action=increase&id=${item.food.id}"
                                                   style="text-decoration: none;">
                                                    <button type="button" title="Tăng">
                                                        <i class="fas fa-plus" style="font-size: 0.7rem;"></i>
                                                    </button>
                                                </a>
                                            </div>
                                        </td>
                                        <td class="text-end">
                                            <strong class="cart-item-price">
                                                <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/>₫
                                            </strong>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/cart?action=remove&id=${item.food.id}"
                                               class="btn btn-sm btn-outline-danger"
                                               title="Xóa khỏi giỏ hàng"
                                               onclick="return confirm('Bạn có chắc muốn xóa món này khỏi giỏ hàng?');">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <%-- Cart actions --%>
                    <div class="surface-toolbar d-flex flex-column flex-md-row justify-content-between align-items-stretch align-items-md-center gap-3 mt-3 p-3">
                        <a href="${pageContext.request.contextPath}/foods" class="btn btn-outline-primary">
                            <i class="fas fa-arrow-left me-1"></i>Tiếp tục chọn món
                        </a>
                        <a href="${pageContext.request.contextPath}/cart?action=clear"
                           class="btn btn-outline-danger"
                           onclick="return confirm('Bạn có chắc muốn xóa toàn bộ món trong giỏ hàng?');">
                            <i class="fas fa-trash me-1"></i>Xóa tất cả
                        </a>
                    </div>
                </div>

                <%-- Order summary column --%>
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm surface-panel" style="border-radius: var(--radius-md); position: sticky; top: 80px;">
                        <div class="card-header border-0 text-white" style="background: var(--primary-gradient); border-radius: var(--radius-md) var(--radius-md) 0 0;">
                            <h5 class="mb-0" style="font-family: var(--font-display); font-weight: 700;">
                                <i class="fas fa-receipt me-2"></i>Tóm tắt đơn hàng
                            </h5>
                        </div>
                        <div class="card-body">
                            <%-- Summary of items --%>
                            <c:forEach var="item" items="${sessionScope.cart}">
                                <div class="d-flex justify-content-between mb-2" style="font-size: 0.9rem;">
                                    <span class="text-muted">
                                        ${item.food.name} x${item.quantity}
                                    </span>
                                    <span><fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/>₫</span>
                                </div>
                            </c:forEach>

                            <hr>

                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <strong style="font-family: var(--font-display); font-size: 1.1rem;">Tổng cộng:</strong>
                                <strong class="gradient-text" style="font-size: 1.3rem; font-family: var(--font-display);">
                                    <fmt:formatNumber value="${cartTotal}" pattern="#,##0"/>₫
                                </strong>
                            </div>

                            <%-- Checkout form --%>
                            <form action="${pageContext.request.contextPath}/orders" method="post">
                                <input type="hidden" name="action" value="place">

                                <div class="mb-3">
                                    <label for="note" class="form-label" style="font-weight: 600; font-size: 0.9rem;">
                                        <i class="fas fa-sticky-note me-1"></i>Ghi chú
                                    </label>
                                    <textarea class="form-control" id="note" name="note" rows="3"
                                              placeholder="Ví dụ: Không cay, thêm sốt..."
                                              style="border-radius: var(--radius-sm);"></textarea>
                                </div>

                                <button type="button" class="btn btn-canteen w-100 btn-lg"
                                        data-bs-toggle="modal" data-bs-target="#confirmOrderModal">
                                    <i class="fas fa-check-circle me-2"></i>Đặt hàng
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Confirm order modal --%>
            <div class="modal fade" id="confirmOrderModal" tabindex="-1" aria-labelledby="confirmOrderLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header" style="background: var(--primary-gradient);">
                            <h5 class="modal-title text-white" id="confirmOrderLabel">
                                <i class="fas fa-clipboard-check me-2"></i>Xác nhận đặt hàng
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Đóng"></button>
                        </div>
                        <div class="modal-body">
                            <p class="mb-3">Bạn có chắc muốn đặt đơn hàng này?</p>

                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th>Món ăn</th>
                                            <th class="text-center">SL</th>
                                            <th class="text-end">Tạm tính</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${sessionScope.cart}">
                                            <tr>
                                                <td>${item.food.name}</td>
                                                <td class="text-center">${item.quantity}</td>
                                                <td class="text-end"><fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/>₫</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td colspan="2"><strong>Tổng cộng:</strong></td>
                                            <td class="text-end">
                                                <strong class="gradient-text">
                                                    <fmt:formatNumber value="${cartTotal}" pattern="#,##0"/>₫
                                                </strong>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-1"></i>Hủy
                            </button>
                            <form action="${pageContext.request.contextPath}/orders" method="post" id="placeOrderForm" style="display: inline;">
                                <input type="hidden" name="action" value="place">
                                <input type="hidden" name="note" id="modalNote" value="">
                                <button type="submit" class="btn btn-canteen">
                                    <i class="fas fa-check me-1"></i>Xác nhận đặt hàng
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                // Sync note from textarea to modal hidden input
                document.getElementById('confirmOrderModal').addEventListener('show.bs.modal', function () {
                    var noteValue = document.getElementById('note').value;
                    document.getElementById('modalNote').value = noteValue;
                });
            </script>
        </c:otherwise>
    </c:choose>
</main>

<%@ include file="/common/footer.jsp" %>
