<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Trang chủ - DHV Canteen" scope="request"/>

<%@ include file="/common/header.jsp" %>

<!-- ===================== HERO SECTION ===================== -->
<section class="hero">
    <div class="container">
        <h1>DHV Canteen</h1>
        <p>Đặt món nhanh chóng, tiện lợi cho sinh viên</p>
        <div class="d-flex justify-content-center gap-3 flex-wrap">
            <a href="${pageContext.request.contextPath}/foods" class="btn btn-lg"
               style="background: white; color: var(--primary-orange); font-weight: 700; border-radius: var(--radius-pill);">
                <i class="fas fa-utensils me-2"></i>Xem thực đơn
            </a>
            <a href="${pageContext.request.contextPath}/foods" class="btn btn-lg btn-outline-light"
               style="border-radius: var(--radius-pill); font-weight: 700;">
                <i class="fas fa-shopping-cart me-2"></i>Đặt món ngay
            </a>
        </div>
    </div>
</section>

<!-- ===================== CATEGORIES SECTION ===================== -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="gradient-text" style="font-size: 2rem; font-weight: 800;">Danh mục món ăn</h2>
            <p class="text-muted">Khám phá các nhóm món phong phú tại căn tin</p>
        </div>

        <div class="row g-4">
            <c:forEach var="cat" items="${categories}">
                <div class="col-6 col-md-4 col-lg-3">
                    <a href="${pageContext.request.contextPath}/foods?category=${cat.id}"
                       class="text-decoration-none">
                        <div class="card border-0 shadow-hover text-center p-4"
                             style="border-radius: var(--radius-lg); background: white; height: 100%;">
                            <div class="mb-3">
                                <c:choose>
                                    <c:when test="${not empty cat.image}">
                                        <img src="${pageContext.request.contextPath}/uploads/categories/${cat.image}"
                                             alt="${cat.name}"
                                             style="width: 80px; height: 80px; object-fit: cover; border-radius: var(--radius-md);">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/no-image.svg"
                                             alt="Chưa có ảnh"
                                             style="width: 80px; height: 80px; object-fit: cover; border-radius: var(--radius-md);">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <h5 style="font-family: var(--font-display); font-weight: 700; color: var(--text-primary); font-size: 1rem;">
                                ${cat.name}
                            </h5>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- ===================== TOP SELLING SECTION ===================== -->
<section class="py-5" style="background: var(--bg-warm);">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="gradient-text" style="font-size: 2rem; font-weight: 800;">Món ăn nổi bật</h2>
            <p class="text-muted">Những món được sinh viên yêu thích nhất</p>
        </div>

        <div class="row food-grid-row">
            <c:forEach var="food" items="${topFoods}">
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="food-card">
                        <div class="card-img-top">
                            <c:choose>
                                <c:when test="${not empty food.image}">
                                    <img src="${pageContext.request.contextPath}/uploads/foods/${food.image}"
                                         alt="${food.name}" class="food-image">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/assets/images/no-image.svg"
                                         alt="Chưa có ảnh" class="food-image">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">${food.name}</h5>
                            <c:if test="${not empty food.description}">
                                <p class="card-text">
                                    <c:choose>
                                        <c:when test="${food.description.length() > 60}">
                                            ${food.description.substring(0, 60)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${food.description}
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </c:if>
                            <div class="d-flex align-items-center justify-content-between mt-auto">
                                <span class="food-price">
                                    <fmt:formatNumber value="${food.price}" pattern="#,##0"/>&#8363;
                                </span>
                                <c:if test="${not empty food.categoryName}">
                                    <span class="badge" style="background: rgba(255,107,53,0.1); color: var(--primary-orange);
                                                               font-size: 0.75rem; border-radius: var(--radius-pill);">
                                        ${food.categoryName}
                                    </span>
                                </c:if>
                            </div>
                        </div>
                        <div class="card-footer">
                            <a href="${pageContext.request.contextPath}/cart?action=add&id=${food.id}"
                               class="btn btn-canteen btn-sm w-100">
                                <i class="fas fa-cart-plus me-1"></i>Thêm vào giỏ
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty topFoods}">
            <div class="empty-state">
                <i class="fas fa-utensils d-block"></i>
                <h5>Chưa có dữ liệu</h5>
                <p>Các món nổi bật sẽ hiển thị khi đã có đơn hàng.</p>
            </div>
        </c:if>

        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/foods" class="btn btn-outline-primary btn-lg">
                Xem tất cả món ăn <i class="fas fa-arrow-right ms-2"></i>
            </a>
        </div>
    </div>
</section>

<!-- ===================== ABOUT / FEATURES SECTION ===================== -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="gradient-text" style="font-size: 2rem; font-weight: 800;">Vì sao chọn chúng tôi?</h2>
            <p class="text-muted">Căn tin luôn nỗ lực mang đến trải nghiệm tốt nhất cho sinh viên</p>
        </div>

        <div class="row g-4">
            <!-- Feature 1 -->
            <div class="col-md-4">
                <div class="card border-0 text-center p-4 shadow-hover h-100"
                     style="border-radius: var(--radius-lg); background: white;">
                    <div class="mx-auto mb-3"
                         style="width: 72px; height: 72px; border-radius: 50%; background: rgba(76,175,80,0.1);
                                display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-leaf fa-2x" style="color: var(--success);"></i>
                    </div>
                    <h5 style="font-family: var(--font-display); font-weight: 700;">Món ăn tươi ngon</h5>
                    <p class="text-muted mb-0">
                        Nguyên liệu tươi sạch, chế biến mỗi ngày, bảo đảm an toàn vệ sinh thực phẩm.
                    </p>
                </div>
            </div>
            <!-- Feature 2 -->
            <div class="col-md-4">
                <div class="card border-0 text-center p-4 shadow-hover h-100"
                     style="border-radius: var(--radius-lg); background: white;">
                    <div class="mx-auto mb-3"
                         style="width: 72px; height: 72px; border-radius: 50%; background: rgba(255,107,53,0.1);
                                display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-tags fa-2x" style="color: var(--primary-orange);"></i>
                    </div>
                    <h5 style="font-family: var(--font-display); font-weight: 700;">Giá cả hợp lý</h5>
                    <p class="text-muted mb-0">
                        Mức giá phù hợp với sinh viên, dễ dàng lựa chọn theo ngân sách.
                    </p>
                </div>
            </div>
            <!-- Feature 3 -->
            <div class="col-md-4">
                <div class="card border-0 text-center p-4 shadow-hover h-100"
                     style="border-radius: var(--radius-lg); background: white;">
                    <div class="mx-auto mb-3"
                         style="width: 72px; height: 72px; border-radius: 50%; background: rgba(33,150,243,0.1);
                                display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-bolt fa-2x" style="color: var(--info);"></i>
                    </div>
                    <h5 style="font-family: var(--font-display); font-weight: 700;">Phục vụ nhanh chóng</h5>
                    <p class="text-muted mb-0">
                        Đặt món trực tuyến, nhận món nhanh, không cần chờ đợi lâu.
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/common/footer.jsp" %>
