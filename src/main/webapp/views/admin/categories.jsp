<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh mục - DHV Canteen</title>
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
            <i class="fas fa-list me-2" style="color: var(--primary-orange);"></i>Danh sách danh mục
        </h5>
        <a href="${pageContext.request.contextPath}/admin/categories?action=add" class="btn btn-canteen">
            <i class="fas fa-plus me-2"></i>Thêm danh mục
        </a>
    </div>

    <!-- Table -->
    <div class="surface-panel p-0 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-canteen mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Tên danh mục</th>
                        <th>Mô tả</th>
                        <th>Hình ảnh</th>
                        <th>Ngày tạo</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="cat" items="${categories}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td><strong>${cat.name}</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty cat.description}">
                                        ${cat.description}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Chưa có mô tả</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty cat.image}">
                                        <img src="${pageContext.request.contextPath}/uploads/categories/${cat.image}" alt="${cat.name}"
                                             style="width: 50px; height: 50px; object-fit: cover; border-radius: var(--radius-sm);">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/no-image.svg" alt="Chưa có ảnh"
                                             style="width: 50px; height: 50px; object-fit: cover; border-radius: var(--radius-sm);">
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <fmt:formatDate value="${cat.createdAt}" pattern="dd/MM/yyyy"/>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/categories?action=edit&id=${cat.id}"
                                   class="btn btn-sm btn-warning me-1" title="Sửa">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/categories?action=delete&id=${cat.id}"
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('Bạn có chắc muốn xóa danh mục này?');"
                                   title="Xóa">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty categories}">
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">
                                <i class="fas fa-folder-open fa-2x mb-2 d-block opacity-50"></i>
                                Chưa có danh mục
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
