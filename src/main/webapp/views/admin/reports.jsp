<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống kê doanh thu - DHV Canteen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .chart-container {
            background: #fff;
            border-radius: var(--radius-md);
            padding: 1.5rem;
            box-shadow: 0 14px 30px rgba(15, 23, 42, 0.08);
            border: 1px solid rgba(102, 126, 234, 0.12);
        }
        .chart-bar-container {
            display: flex;
            align-items: flex-end;
            gap: 4px;
            height: 250px;
            padding: 0 0.5rem;
            border-bottom: 2px solid #eee;
        }
        .chart-bar-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            height: 100%;
            justify-content: flex-end;
        }
        .chart-bar {
            width: 100%;
            max-width: 30px;
            background: var(--primary-gradient);
            border-radius: 4px 4px 0 0;
            transition: all 0.3s;
            min-height: 2px;
            position: relative;
        }
        .chart-bar:hover {
            opacity: 0.8;
        }
        .chart-bar-value {
            font-size: 0.65rem;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 4px;
            white-space: nowrap;
        }
        .chart-labels {
            display: flex;
            gap: 4px;
            padding: 0.5rem;
        }
        .chart-label {
            flex: 1;
            text-align: center;
            font-size: 0.6rem;
            color: var(--text-secondary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
</head>
<body>

<%@ include file="/common/admin-sidebar.jsp" %>

<div class="admin-content">
    <%@ include file="/common/admin-header.jsp" %>

    <!-- Date Range Filter -->
    <div class="card border-0 shadow-sm surface-toolbar mb-4" style="border-radius: var(--radius-md);">
        <div class="card-body py-3">
            <form class="row g-3 align-items-end" method="get" action="${pageContext.request.contextPath}/admin/reports">
                <div class="col-md-3">
                    <label class="form-label" style="font-weight: 600; font-size: 0.85rem;">Từ ngày</label>
                    <input type="date" class="form-control" name="startDate" value="${startDate}">
                </div>
                <div class="col-md-3">
                    <label class="form-label" style="font-weight: 600; font-size: 0.85rem;">Đến ngày</label>
                    <input type="date" class="form-control" name="endDate" value="${endDate}">
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-canteen">
                        <i class="fas fa-filter me-2"></i>Lọc dữ liệu
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Stat Cards -->
    <div class="row g-4 mb-4">
        <div class="col-xl-4 col-md-4">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(76, 175, 80, 0.1); color: var(--success);">
                    <i class="fas fa-money-bill-wave"></i>
                </div>
                <div class="stat-number" style="color: var(--success);">
                    <fmt:formatNumber value="${revenue}" pattern="#,##0"/> VND
                </div>
                <div class="stat-label">Tổng doanh thu</div>
            </div>
        </div>
        <div class="col-xl-4 col-md-4">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(33, 150, 243, 0.1); color: var(--info);">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <div class="stat-number" style="color: var(--info);">
                    ${orderCount}
                </div>
                <div class="stat-label">Tổng đơn hàng</div>
            </div>
        </div>
        <div class="col-xl-4 col-md-4">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(76, 175, 80, 0.1); color: var(--success);">
                    <i class="fas fa-check-double"></i>
                </div>
                <div class="stat-number" style="color: var(--success);">
                    ${completedCount}
                </div>
                <div class="stat-label">Đơn hoàn thành</div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Revenue Chart -->
        <div class="col-xl-8">
            <div class="chart-container">
                <h5 class="mb-3" style="font-family: var(--font-display); font-weight: 700;">
                    <i class="fas fa-chart-bar me-2" style="color: var(--primary-orange);"></i>Doanh thu theo ngày (30 ngày gần nhất)
                </h5>

                <c:choose>
                    <c:when test="${not empty dailyRevenue}">
                        <%-- Calculate max revenue for scaling --%>
                        <c:set var="maxRevenue" value="0"/>
                        <c:forEach var="entry" items="${dailyRevenue}">
                            <c:if test="${entry.value > maxRevenue}">
                                <c:set var="maxRevenue" value="${entry.value}"/>
                            </c:if>
                        </c:forEach>

                        <div class="chart-bar-container">
                            <c:forEach var="entry" items="${dailyRevenue}">
                                <div class="chart-bar-wrapper">
                                    <div class="chart-bar-value">
                                        <fmt:formatNumber value="${entry.value / 1000}" pattern="#,##0"/>k
                                    </div>
                                    <div class="chart-bar"
                                         style="height: ${maxRevenue > 0 ? (entry.value / maxRevenue * 220) : 2}px;"
                                         title="${entry.key}: ${entry.value} VND">
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="chart-labels">
                            <c:forEach var="entry" items="${dailyRevenue}">
                                <div class="chart-label">
                                    ${entry.key.substring(8)}
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted py-5">
                            <i class="fas fa-chart-bar fa-3x mb-3 opacity-50"></i>
                            <p>Chưa có dữ liệu doanh thu</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Top Selling Foods -->
        <div class="col-xl-4">
            <div class="card border-0 shadow-sm surface-panel" style="border-radius: var(--radius-md);">
                <div class="card-header bg-white border-0 pt-3 pb-2 px-4">
                    <h5 class="mb-0" style="font-family: var(--font-display); font-weight: 700;">
                        <i class="fas fa-fire me-2" style="color: var(--primary-orange);"></i>Bán chạy nhất
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-canteen mb-0">
                            <thead>
                                <tr>
                                    <th>Tên món</th>
                                    <th>SL đã bán</th>
                                    <th>Doanh thu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="food" items="${topFoods}" varStatus="loop">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <span class="badge rounded-pill me-2"
                                                      style="background: var(--primary-gradient); width: 22px; height: 22px; display: inline-flex; align-items: center; justify-content: center; font-size: 0.7rem;">
                                                    ${loop.index + 1}
                                                </span>
                                                <strong style="font-size: 0.85rem;">${food.name}</strong>
                                            </div>
                                        </td>
                                        <td style="font-weight: 600;">-</td>
                                        <td>
                                            <strong style="color: var(--primary-orange); font-size: 0.85rem;">
                                                <fmt:formatNumber value="${food.price}" pattern="#,##0"/> VND
                                            </strong>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty topFoods}">
                                    <tr>
                                        <td colspan="3" class="text-center text-muted py-3">
                                            Chưa có dữ liệu
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
