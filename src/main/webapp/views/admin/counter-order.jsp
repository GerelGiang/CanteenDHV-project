<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bán hàng tại quầy - DHV Canteen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .pos-food-item {
            background: #fff;
            border: 1px solid rgba(102, 126, 234, 0.14);
            border-radius: var(--radius-md);
            padding: 1rem;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
            box-shadow: 0 10px 22px rgba(15, 23, 42, 0.07);
        }
        .pos-food-item:hover {
            border-color: var(--primary-orange);
            box-shadow: 0 18px 36px rgba(15, 23, 42, 0.13);
            transform: translateY(-4px);
        }
        .pos-food-name {
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 0.25rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .pos-food-price {
            color: var(--primary-orange);
            font-weight: 700;
            font-family: var(--font-display);
            font-size: 0.85rem;
        }
        .pos-order-panel {
            background: #fff;
            border-radius: var(--radius-md);
            box-shadow: 0 14px 30px rgba(15, 23, 42, 0.08);
            border: 1px solid rgba(102, 126, 234, 0.12);
            display: flex;
            flex-direction: column;
            height: calc(100vh - 140px);
        }
        .pos-order-header {
            padding: 1rem 1.25rem;
            border-bottom: 1px solid rgba(0,0,0,0.06);
            font-family: var(--font-display);
            font-weight: 700;
        }
        .pos-order-items {
            flex: 1;
            overflow-y: auto;
            padding: 0.75rem 1.25rem;
        }
        .pos-order-item {
            display: flex;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid rgba(0,0,0,0.04);
        }
        .pos-order-item:last-child {
            border-bottom: none;
        }
        .pos-order-footer {
            padding: 1rem 1.25rem;
            border-top: 1px solid rgba(0,0,0,0.06);
        }
        .category-tab {
            border: none;
            background: #f0f0f0;
            border-radius: var(--radius-pill);
            padding: 0.4rem 1rem;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .category-tab.active {
            background: var(--primary-gradient);
            color: #fff;
        }
    </style>
</head>
<body>

<%@ include file="/common/admin-sidebar.jsp" %>

<div class="admin-content" style="padding: 1rem;">
    <%@ include file="/common/admin-header.jsp" %>

    <div class="row g-3">
        <!-- Left Panel: Food Grid -->
        <div class="col-md-7">
            <!-- Category Tabs -->
            <div class="d-flex flex-wrap gap-2 mb-3">
                <button class="category-tab active" onclick="filterCategory('all', this)">Tất cả</button>
                <c:forEach var="cat" items="${categories}">
                    <button class="category-tab" onclick="filterCategory('${cat.id}', this)">${cat.name}</button>
                </c:forEach>
            </div>

            <!-- Food Grid -->
            <div class="row g-3" id="foodGrid">
                <c:forEach var="food" items="${foods}">
                    <div class="col-lg-3 col-md-4 col-6 food-grid-item" data-category="${food.categoryId}">
                        <div class="pos-food-item"
                             data-food-id="${food.id}"
                             data-food-name="${fn:escapeXml(food.name)}"
                             data-food-price="${food.price}"
                             onclick="addToOrderFromCard(this)">
                            <c:choose>
                                <c:when test="${not empty food.image}">
                                    <img src="${pageContext.request.contextPath}/uploads/foods/${food.image}" alt="${food.name}"
                                         style="width: 60px; height: 60px; object-fit: cover; border-radius: var(--radius-sm); margin-bottom: 0.5rem;">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/assets/images/no-image.svg" alt="Chưa có ảnh"
                                         style="width: 60px; height: 60px; object-fit: cover; border-radius: var(--radius-sm); margin-bottom: 0.5rem;">
                                </c:otherwise>
                            </c:choose>
                            <div class="pos-food-name">${food.name}</div>
                            <div class="pos-food-price"><fmt:formatNumber value="${food.price}" pattern="#,##0"/>₫</div>
                            <button class="btn btn-sm btn-canteen mt-2 w-100" style="font-size: 0.8rem; padding: 0.25rem 0.5rem;">
                                <i class="fas fa-plus me-1"></i>Thêm
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Right Panel: Current Order -->
        <div class="col-md-5">
            <form action="${pageContext.request.contextPath}/admin/orders" method="post" id="counterOrderForm">
                <input type="hidden" name="action" value="placeCounter">

                <div class="pos-order-panel">
                    <div class="pos-order-header d-flex justify-content-between align-items-center">
                        <span><i class="fas fa-shopping-cart me-2" style="color: var(--primary-orange);"></i>Đơn hàng hiện tại</span>
                        <button type="button" class="btn btn-sm btn-outline-danger" style="border-radius: var(--radius-pill);"
                                onclick="clearOrder()">
                            <i class="fas fa-trash me-1"></i>Xóa tất cả
                        </button>
                    </div>

                    <div class="pos-order-items" id="orderItems">
                        <div class="text-center text-muted py-5" id="emptyOrderMsg">
                            <i class="fas fa-shopping-basket fa-2x mb-2 opacity-50"></i>
                            <p class="mb-0">Chưa có món nào</p>
                            <small>Bấm vào món ăn để thêm vào đơn</small>
                        </div>
                    </div>

                    <!-- Hidden inputs container -->
                    <div id="hiddenInputs"></div>

                    <div class="pos-order-footer">
                        <div class="mb-3">
                            <label class="form-label" style="font-weight: 600; font-size: 0.85rem;">Ghi chú</label>
                            <input type="text" class="form-control form-control-sm" name="note" placeholder="Ghi chú đơn hàng...">
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-3"
                             style="font-family: var(--font-display); font-size: 1.2rem; font-weight: 800;">
                            <span>Tổng cộng:</span>
                            <span style="color: var(--primary-orange);" id="totalAmount">0 VND</span>
                        </div>

                        <button type="submit" class="btn btn-canteen w-100" id="submitBtn" disabled>
                            <i class="fas fa-check-circle me-2"></i>Tạo đơn hàng
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Order data
    var orderItems = {};
    var emptyOrderMarkup = ''
        + '<div class="text-center text-muted py-5" id="emptyOrderMsg">'
        + '<i class="fas fa-shopping-basket fa-2x mb-2 opacity-50"></i>'
        + '<p class="mb-0">Chưa có món nào</p>'
        + '<small>Bấm vào món ăn để thêm vào đơn</small>'
        + '</div>';

    function formatPrice(price) {
        return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    function addToOrderFromCard(cardEl) {
        addToOrder(
            parseInt(cardEl.dataset.foodId, 10),
            cardEl.dataset.foodName,
            parseFloat(cardEl.dataset.foodPrice)
        );
    }

    function addToOrder(foodId, foodName, foodPrice) {
        if (orderItems[foodId]) {
            orderItems[foodId].quantity++;
        } else {
            orderItems[foodId] = {
                id: foodId,
                name: foodName,
                price: foodPrice,
                quantity: 1
            };
        }
        renderOrder();
    }

    function removeFromOrder(foodId) {
        delete orderItems[foodId];
        renderOrder();
    }

    function updateQuantity(foodId, delta) {
        if (orderItems[foodId]) {
            orderItems[foodId].quantity += delta;
            if (orderItems[foodId].quantity <= 0) {
                delete orderItems[foodId];
            }
        }
        renderOrder();
    }

    function clearOrder() {
        orderItems = {};
        renderOrder();
    }

    function renderOrder() {
        var itemsContainer = document.getElementById('orderItems');
        var hiddenInputs = document.getElementById('hiddenInputs');
        var totalEl = document.getElementById('totalAmount');
        var submitBtn = document.getElementById('submitBtn');

        var keys = Object.keys(orderItems);

        if (keys.length === 0) {
            itemsContainer.innerHTML = emptyOrderMarkup;
            hiddenInputs.innerHTML = '';
            totalEl.textContent = '0 VND';
            submitBtn.disabled = true;
            return;
        }

        var html = '';
        var hiddenHtml = '';
        var total = 0;

        for (var i = 0; i < keys.length; i++) {
            var item = orderItems[keys[i]];
            var subtotal = item.price * item.quantity;
            total += subtotal;

            html += '<div class="pos-order-item">'
                + '<div class="flex-grow-1">'
                + '<div style="font-weight: 600; font-size: 0.9rem;">' + item.name + '</div>'
                + '<small class="text-muted">' + formatPrice(item.price) + ' VND</small>'
                + '</div>'
                + '<div class="d-flex align-items-center gap-2">'
                + '<div class="qty-stepper">'
                + '<button type="button" onclick="updateQuantity(' + item.id + ', -1)"><i class="fas fa-minus" style="font-size:0.7rem;"></i></button>'
                + '<span class="qty-value">' + item.quantity + '</span>'
                + '<button type="button" onclick="updateQuantity(' + item.id + ', 1)"><i class="fas fa-plus" style="font-size:0.7rem;"></i></button>'
                + '</div>'
                + '<strong style="min-width: 80px; text-align: right; color: var(--primary-orange);">' + formatPrice(subtotal) + ' VND</strong>'
                + '<button type="button" class="btn btn-sm text-danger" onclick="removeFromOrder(' + item.id + ')" style="padding:0.2rem;">'
                + '<i class="fas fa-times"></i>'
                + '</button>'
                + '</div>'
                + '</div>';

            hiddenHtml += '<input type="hidden" name="foodIds" value="' + item.id + '">';
            hiddenHtml += '<input type="hidden" name="quantities" value="' + item.quantity + '">';
        }

        itemsContainer.innerHTML = html;
        hiddenInputs.innerHTML = hiddenHtml;
        totalEl.textContent = formatPrice(total) + ' VND';
        submitBtn.disabled = false;
    }

    function filterCategory(categoryId, btn) {
        // Update active tab
        document.querySelectorAll('.category-tab').forEach(function(tab) {
            tab.classList.remove('active');
        });
        btn.classList.add('active');

        // Filter food items
        document.querySelectorAll('.food-grid-item').forEach(function(item) {
            if (categoryId === 'all' || item.getAttribute('data-category') === categoryId) {
                item.style.display = '';
            } else {
                item.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>
