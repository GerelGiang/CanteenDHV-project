<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty category ? 'Sửa danh mục' : 'Thêm danh mục'} - DHV Canteen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body>

<%@ include file="/common/admin-sidebar.jsp" %>

<div class="admin-content">
    <%@ include file="/common/admin-header.jsp" %>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm surface-panel" style="border-radius: var(--radius-md);">
                <div class="card-header bg-white border-0 pt-4 pb-2 px-4">
                    <h5 class="mb-0" style="font-family: var(--font-display); font-weight: 700;">
                        <i class="fas ${not empty category ? 'fa-edit' : 'fa-plus-circle'} me-2" style="color: var(--primary-orange);"></i>
                        ${not empty category ? 'Sửa danh mục' : 'Thêm danh mục'}
                    </h5>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/admin/categories" method="post" enctype="multipart/form-data" class="form-canteen">
                        <input type="hidden" name="action" value="${not empty category ? 'edit' : 'add'}">
                        <c:if test="${not empty category}">
                            <input type="hidden" name="id" value="${category.id}">
                        </c:if>

                        <div class="mb-3">
                            <label for="name" class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="name" name="name"
                                   value="${not empty category ? category.name : ''}"
                                   placeholder="Nhập tên danh mục" required>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" rows="3"
                                      placeholder="Nhập mô tả">${not empty category ? category.description : ''}</textarea>
                        </div>

                        <div class="mb-4">
                            <label for="image" class="form-label">Hình ảnh</label>
                            <input type="file" class="form-control" id="image" name="image" accept="image/*">
                            <c:if test="${not empty category && not empty category.image}">
                                <div class="mt-2">
                                    <small class="text-muted">Ảnh hiện tại: ${category.image}</small>
                                    <div class="mt-1">
                                        <img src="${pageContext.request.contextPath}/uploads/categories/${category.image}" alt="Ảnh hiện tại" style="max-width:200px; max-height:200px; border-radius:8px;">
                                    </div>
                                    <small class="text-muted">Để trống nếu muốn giữ ảnh hiện tại</small>
                                </div>
                            </c:if>
                            <div id="imagePreview" class="mt-2" style="display:none">
                                <img id="previewImg" src="" alt="Xem trước" style="max-width:200px; max-height:200px; border-radius:8px;">
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-canteen">
                                <i class="fas fa-save me-2"></i>${not empty category ? 'Cập nhật' : 'Thêm mới'}
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline-secondary" style="border-radius: var(--radius-pill);">
                                <i class="fas fa-arrow-left me-2"></i>Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.querySelector('input[name="image"]').addEventListener('change', function(e) {
    var preview = document.getElementById('imagePreview');
    var img = document.getElementById('previewImg');
    if (this.files && this.files[0]) {
        var reader = new FileReader();
        reader.onload = function(ev) {
            img.src = ev.target.result;
            preview.style.display = 'block';
        };
        reader.readAsDataURL(this.files[0]);
    } else {
        preview.style.display = 'none';
    }
});
</script>
</body>
</html>
