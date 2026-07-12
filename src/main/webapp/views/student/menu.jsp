<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Thực đơn - DHV Canteen" scope="request"/>

<%@ include file="/common/header.jsp" %>

<style>
    .filter-sidebar {
        background: white;
        border-radius: var(--radius-lg);
        box-shadow: 0 14px 30px rgba(15, 23, 42, 0.08);
        border: 1px solid rgba(102, 126, 234, 0.12);
        padding: var(--space-lg);
        position: sticky;
        top: 80px;
    }
    .filter-sidebar h6 {
        font-family: var(--font-display);
        font-weight: 700;
        color: var(--text-primary);
        margin-bottom: var(--space-md);
        padding-bottom: var(--space-sm);
        border-bottom: 2px solid rgba(255,107,53,0.15);
    }
    .filter-sidebar .form-label {
        font-weight: 600;
        font-size: 0.85rem;
        color: var(--text-secondary);
    }
    .category-list .category-item {
        display: block;
        padding: 0.5rem 0.75rem;
        border-radius: var(--radius-sm);
        color: var(--text-secondary);
        font-weight: 500;
        font-size: 0.9rem;
        transition: all var(--transition-fast);
        text-decoration: none;
        margin-bottom: 2px;
    }
    .category-list .category-item:hover {
        background: rgba(255,107,53,0.06);
        color: var(--primary-orange);
    }
    .category-list .category-item.active {
        background: var(--primary-gradient);
        color: white;
        font-weight: 600;
    }
    .result-count {
        font-family: var(--font-display);
        font-weight: 600;
        color: var(--text-secondary);
        font-size: 0.95rem;
    }
    .result-count span {
        font-weight: 800;
        color: var(--primary-orange);
    }
</style>

<!-- ===================== MENU PAGE ===================== -->
<section class="py-4">
    <div class="container">
        <!-- Page heading -->
        <div class="mb-4">
            <h2 class="gradient-text" style="font-size: 2rem; font-weight: 800;">
                <i class="fas fa-utensils me-2"></i>Thực đơn
            </h2>
            <p class="text-muted mb-0">Khám phá những món ngon tại căn tin trường học</p>
        </div>

        <div class="row g-4">
            <!-- ========== LEFT SIDEBAR: FILTERS ========== -->
            <div class="col-md-3">
                <form action="${pageContext.request.contextPath}/foods" method="GET" id="filterForm">
                    <div class="filter-sidebar">

                        <!-- Search box -->
                        <h6><i class="fas fa-search me-2"></i>Tìm kiếm</h6>
                        <div class="mb-4">
                            <div class="input-group">
                                <input type="text" class="form-control" name="keyword"
                                       placeholder="Tìm món ăn..."
                                       value="${keyword}">
                                <button class="btn btn-canteen" type="submit">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Category filter -->
                        <h6><i class="fas fa-th-list me-2"></i>Danh mục</h6>
                        <div class="category-list mb-4">
                            <a href="${pageContext.request.contextPath}/foods"
                               class="category-item ${empty selectedCategory ? 'active' : ''}">
                                <i class="fas fa-border-all me-2"></i>Tất cả
                            </a>
                            <c:forEach var="cat" items="${categories}">
                                <a href="javascript:void(0);"
                                   onclick="selectCategory(${cat.id})"
                                   class="category-item ${selectedCategory == cat.id ? 'active' : ''}">
                                    <i class="fas fa-angle-right me-2"></i>${cat.name}
                                </a>
                            </c:forEach>
                        </div>

                        <!-- Hidden category input -->
                        <input type="hidden" name="category" id="categoryInput"
                               value="${selectedCategory}">

                        <!-- Price range -->
                        <h6><i class="fas fa-money-bill-wave me-2"></i>Khoảng giá</h6>
                        <div class="row g-2 mb-4">
                            <div class="col-6">
                                <label class="form-label">Từ</label>
                                <input type="number" class="form-control form-control-sm"
                                       name="minPrice" placeholder="0"
                                       value="${minPrice}" min="0">
                            </div>
                            <div class="col-6">
                                <label class="form-label">Đến</label>
                                <input type="number" class="form-control form-control-sm"
                                       name="maxPrice" placeholder="500000"
                                       value="${maxPrice}" min="0">
                            </div>
                        </div>

                        <!-- Sort -->
                        <h6><i class="fas fa-sort me-2"></i>Sắp xếp</h6>
                        <div class="mb-4">
                            <select class="form-select form-select-sm" name="sort">
                                <option value="" ${empty sort ? 'selected' : ''}>Mặc định</option>
                                <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>Giá: thấp đến cao</option>
                                <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>Giá: cao đến thấp</option>
                                <option value="name_asc" ${sort == 'name_asc' ? 'selected' : ''}>Tên A-Z</option>
                                <option value="name_desc" ${sort == 'name_desc' ? 'selected' : ''}>Tên Z-A</option>
                            </select>
                        </div>

                        <!-- Apply button -->
                        <button type="submit" class="btn btn-canteen w-100">
                            <i class="fas fa-filter me-2"></i>Áp dụng bộ lọc
                        </button>

                        <!-- Reset link -->
                        <div class="text-center mt-2">
                            <a href="${pageContext.request.contextPath}/foods"
                               class="text-muted" style="font-size: 0.85rem;">
                                <i class="fas fa-undo me-1"></i>Xóa bộ lọc
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- ========== RIGHT CONTENT: FOOD GRID ========== -->
            <div class="col-md-9">
                <!-- Result count -->
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <p class="result-count mb-0">
                        Tìm thấy <span>${foods.size()}</span> món
                    </p>
                </div>

                <!-- Food grid -->
                <c:choose>
                    <c:when test="${not empty foods}">
                        <div class="row food-grid-row">
                            <c:forEach var="food" items="${foods}">
                                <div class="col-6 col-lg-4">
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
                                                        <c:when test="${fn:length(food.description) > 80}">
                                                            ${fn:substring(food.description, 0, 80)}...
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${food.description}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </c:if>
                                            <div class="d-flex align-items-center justify-content-between mt-auto mb-2">
                                                <span class="food-price">
                                                    <fmt:formatNumber value="${food.price}" pattern="#,##0"/>&#8363;
                                                </span>
                                                <c:if test="${not empty food.categoryName}">
                                                    <span class="badge"
                                                          style="background: rgba(255,107,53,0.1); color: var(--primary-orange);
                                                                 font-size: 0.72rem; border-radius: var(--radius-pill);">
                                                        ${food.categoryName}
                                                    </span>
                                                </c:if>
                                            </div>
                                            <div class="d-flex align-items-center gap-2">
                                                <c:choose>
                                                    <c:when test="${food.status == 1}">
                                                        <span class="badge-status available">
                                                            <i class="fas fa-check-circle me-1"></i>Còn bán
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status unavailable">
                                                            <i class="fas fa-times-circle me-1"></i>Hết bán
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
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
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state" style="padding: 4rem 2rem;">
                            <i class="fas fa-search d-block" style="font-size: 3.5rem; opacity: 0.3;"></i>
                            <h5 class="mt-3">Không tìm thấy món nào</h5>
                            <p>Hãy thử thay đổi bộ lọc hoặc từ khóa tìm kiếm.</p>
                            <a href="${pageContext.request.contextPath}/foods" class="btn btn-outline-primary">
                                <i class="fas fa-undo me-2"></i>Xem tất cả món
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</section>

<script>
    function selectCategory(categoryId) {
        document.getElementById('categoryInput').value = categoryId;
        document.getElementById('filterForm').submit();
    }
</script>

<%@ include file="/common/footer.jsp" %>
