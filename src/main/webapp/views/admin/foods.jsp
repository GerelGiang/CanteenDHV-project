<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý món ăn - DHV Canteen</title>
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
            <i class="fas fa-utensils me-2" style="color: var(--primary-orange);"></i>Danh sách món ăn
        </h5>
        <a href="${pageContext.request.contextPath}/admin/foods?action=add" class="btn btn-canteen">
            <i class="fas fa-plus me-2"></i>Thêm món ăn
        </a>
    </div>

    <!-- Filter Bar -->
    <div class="card border-0 shadow-sm surface-toolbar mb-4" style="border-radius: var(--radius-md);">
        <div class="card-body py-3">
            <form class="row g-3 align-items-end" method="get" action="${pageContext.request.contextPath}/admin/foods">
                <div class="col-md-4">
                    <label class="form-label" style="font-weight: 600; font-size: 0.85rem;">Danh mục</label>
                    <select class="form-select" name="categoryId" onchange="this.form.submit()">
                        <option value="">Tất cả danh mục</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}" ${param.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-5">
                    <label class="form-label" style="font-weight: 600; font-size: 0.85rem;">Tìm kiếm</label>
                    <div class="input-group">
                        <input type="text" class="form-control" name="keyword" value="${param.keyword}"
                               placeholder="Tìm theo tên món...">
                        <button class="btn btn-outline-secondary" type="submit" style="border-radius: 0 var(--radius-pill) var(--radius-pill) 0;">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Table -->
    <div class="surface-panel p-0 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-canteen mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Ảnh</th>
                        <th>Tên món</th>
                        <th>Danh mục</th>
                        <th>Giá</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="food" items="${foods}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty food.image}">
                                        <img src="${pageContext.request.contextPath}/uploads/foods/${food.image}" alt="${food.name}"
                                             style="width: 50px; height: 50px; object-fit: cover; border-radius: var(--radius-sm);">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/no-image.svg" alt="Chưa có ảnh"
                                             style="width: 50px; height: 50px; object-fit: cover; border-radius: var(--radius-sm);">
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><strong>${food.name}</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty food.categoryName}">
                                        <span class="badge bg-light text-dark" style="font-weight: 500;">${food.categoryName}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><strong style="color: var(--primary-orange);"><fmt:formatNumber value="${food.price}" pattern="#,##0"/> VND</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${food.status == 1}">
                                        <span class="badge-status available">Còn bán</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-status unavailable">Hết bán</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/foods?action=edit&id=${food.id}"
                                   class="btn btn-sm btn-warning me-1" title="Sửa">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/foods?action=delete&id=${food.id}"
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('Bạn có chắc muốn xóa món ăn này?');"
                                   title="Xóa">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty foods}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">
                                <i class="fas fa-utensils fa-2x mb-2 d-block opacity-50"></i>
                                Chưa có món ăn
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
