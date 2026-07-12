<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sinh viên - DHV Canteen</title>
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
            <i class="fas fa-user-graduate me-2" style="color: var(--primary-orange);"></i>Danh sách sinh viên
        </h5>
    </div>

    <!-- Search Bar -->
    <div class="card border-0 shadow-sm surface-toolbar mb-4" style="border-radius: var(--radius-md);">
        <div class="card-body py-3">
            <div class="row">
                <div class="col-md-6">
                    <div class="input-group">
                        <input type="text" class="form-control" id="searchInput"
                               placeholder="Tìm theo tên hoặc email..." onkeyup="searchUsers()">
                        <span class="input-group-text" style="border-radius: 0 var(--radius-pill) var(--radius-pill) 0;">
                            <i class="fas fa-search"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Table -->
    <div class="surface-panel p-0 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-canteen mb-0" id="usersTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Họ và tên</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Trạng thái</th>
                        <th>Ngày đăng ký</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="student" items="${students}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td><strong>${student.fullName}</strong></td>
                            <td>${student.email}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty student.phone}">
                                        ${student.phone}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${student.status == 1}">
                                        <span class="badge-completed">Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-cancelled">Đã khóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <fmt:formatDate value="${student.createdAt}" pattern="dd/MM/yyyy"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${student.status == 1}">
                                        <a href="${pageContext.request.contextPath}/admin/users?action=toggleStatus&id=${student.id}&currentStatus=${student.status}"
                                           class="btn btn-sm btn-danger"
                                           onclick="return confirm('Bạn có chắc muốn khóa tài khoản này?');"
                                           style="border-radius: var(--radius-pill);">
                                            <i class="fas fa-lock me-1"></i>Khóa
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/admin/users?action=toggleStatus&id=${student.id}&currentStatus=${student.status}"
                                           class="btn btn-sm btn-success"
                                           onclick="return confirm('Bạn có chắc muốn mở khóa tài khoản này?');"
                                           style="border-radius: var(--radius-pill);">
                                            <i class="fas fa-unlock me-1"></i>Mở khóa
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty students}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">
                                <i class="fas fa-users fa-2x mb-2 d-block opacity-50"></i>
                                Chưa có sinh viên
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function searchUsers() {
        var input = document.getElementById('searchInput').value.toLowerCase();
        var table = document.getElementById('usersTable');
        var rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');

        for (var i = 0; i < rows.length; i++) {
            var name = rows[i].getElementsByTagName('td')[1];
            var email = rows[i].getElementsByTagName('td')[2];
            if (name && email) {
                var nameText = name.textContent.toLowerCase();
                var emailText = email.textContent.toLowerCase();
                if (nameText.indexOf(input) > -1 || emailText.indexOf(input) > -1) {
                    rows[i].style.display = '';
                } else {
                    rows[i].style.display = 'none';
                }
            }
        }
    }
</script>
</body>
</html>
