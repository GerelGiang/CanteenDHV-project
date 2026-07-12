document.addEventListener('DOMContentLoaded', function() {

    // ===== NAVBAR SCROLL EFFECT =====
    const navbar = document.querySelector('.navbar-canteen');
    if (navbar) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
    }

    // ===== FADE IN ANIMATION ON SCROLL =====
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.food-card, .stat-card, .fade-in').forEach(function(el) {
        observer.observe(el);
    });

    // ===== COUNTER ANIMATION FOR STAT NUMBERS =====
    function animateCounter(el) {
        const target = parseInt(el.getAttribute('data-target')) || 0;
        const duration = 1500;
        const start = 0;
        const startTime = performance.now();

        function update(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            const eased = 1 - Math.pow(1 - progress, 3);
            const current = Math.floor(eased * (target - start) + start);
            el.textContent = current.toLocaleString('vi-VN');
            if (progress < 1) {
                requestAnimationFrame(update);
            } else {
                el.textContent = target.toLocaleString('vi-VN');
            }
        }
        requestAnimationFrame(update);
    }

    const counterObserver = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                animateCounter(entry.target);
                counterObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.5 });

    document.querySelectorAll('[data-counter]').forEach(function(el) {
        counterObserver.observe(el);
    });

    // ===== CONFIRM DELETE DIALOGS =====
    document.querySelectorAll('[data-confirm]').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            var message = this.getAttribute('data-confirm') || 'Bạn có chắc chắn muốn thực hiện thao tác này?';
            if (!confirm(message)) {
                e.preventDefault();
            }
        });
    });

    // ===== AUTO-HIDE ALERTS =====
    document.querySelectorAll('.alert-dismissible').forEach(function(alert) {
        setTimeout(function() {
            var bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            if (bsAlert) bsAlert.close();
        }, 5000);
    });

    // ===== QUANTITY STEPPER (Cart) =====
    document.querySelectorAll('.qty-stepper').forEach(function(stepper) {
        var minusBtn = stepper.querySelector('.qty-minus');
        var plusBtn = stepper.querySelector('.qty-plus');
        var input = stepper.querySelector('.qty-input');

        if (minusBtn) {
            minusBtn.addEventListener('click', function() {
                var val = parseInt(input.value) || 1;
                if (val > 1) input.value = val - 1;
            });
        }
        if (plusBtn) {
            plusBtn.addEventListener('click', function() {
                var val = parseInt(input.value) || 1;
                input.value = val + 1;
            });
        }
    });

    // ===== PRICE FORMAT HELPER =====
    window.formatVND = function(amount) {
        return new Intl.NumberFormat('vi-VN').format(amount) + '₫';
    };

    // ===== COUNTER ORDER (POS) FUNCTIONS =====
    window.counterOrder = {
        items: [],

        addItem: function(id, name, price) {
            var existing = this.items.find(function(item) { return item.id === id; });
            if (existing) {
                existing.quantity++;
            } else {
                this.items.push({ id: id, name: name, price: price, quantity: 1 });
            }
            this.render();
        },

        removeItem: function(id) {
            this.items = this.items.filter(function(item) { return item.id !== id; });
            this.render();
        },

        updateQuantity: function(id, qty) {
            var item = this.items.find(function(i) { return i.id === id; });
            if (item) {
                item.quantity = Math.max(1, qty);
            }
            this.render();
        },

        getTotal: function() {
            return this.items.reduce(function(sum, item) {
                return sum + (item.price * item.quantity);
            }, 0);
        },

        render: function() {
            var listEl = document.getElementById('counter-order-items');
            var totalEl = document.getElementById('counter-order-total');
            var hiddenEl = document.getElementById('counter-order-hidden');
            var submitBtn = document.getElementById('counter-submit-btn');

            if (!listEl) return;

            if (this.items.length === 0) {
                listEl.innerHTML = '<div class="text-center text-muted py-4"><i class="fas fa-shopping-basket fa-2x mb-2"></i><p>Chưa có món nào</p></div>';
                if (submitBtn) submitBtn.disabled = true;
            } else {
                var html = '';
                var self = this;
                this.items.forEach(function(item) {
                    html += '<div class="counter-item d-flex justify-content-between align-items-center py-2 border-bottom">';
                    html += '<div class="flex-grow-1"><strong>' + item.name + '</strong><br><small class="text-muted">' + formatVND(item.price) + '</small></div>';
                    html += '<div class="d-flex align-items-center gap-2">';
                    html += '<button type="button" class="btn btn-sm btn-outline-secondary" onclick="counterOrder.updateQuantity(' + item.id + ',' + (item.quantity - 1) + ')">-</button>';
                    html += '<span class="fw-bold">' + item.quantity + '</span>';
                    html += '<button type="button" class="btn btn-sm btn-outline-secondary" onclick="counterOrder.updateQuantity(' + item.id + ',' + (item.quantity + 1) + ')">+</button>';
                    html += '<button type="button" class="btn btn-sm btn-outline-danger" onclick="counterOrder.removeItem(' + item.id + ')"><i class="fas fa-times"></i></button>';
                    html += '</div></div>';
                });
                listEl.innerHTML = html;
                if (submitBtn) submitBtn.disabled = false;
            }

            if (totalEl) {
                totalEl.textContent = formatVND(this.getTotal());
            }

            if (hiddenEl) {
                hiddenEl.innerHTML = '';
                this.items.forEach(function(item) {
                    hiddenEl.innerHTML += '<input type="hidden" name="foodId" value="' + item.id + '">';
                    hiddenEl.innerHTML += '<input type="hidden" name="quantity" value="' + item.quantity + '">';
                });
            }
        }
    };

    // ===== SIDEBAR TOGGLE (Mobile) =====
    var sidebarToggle = document.getElementById('sidebarToggle');
    var sidebar = document.querySelector('.admin-sidebar');
    var overlay = document.querySelector('.sidebar-overlay');

    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('show');
            if (overlay) overlay.classList.toggle('show');
        });
    }
    if (overlay) {
        overlay.addEventListener('click', function() {
            sidebar.classList.remove('show');
            overlay.classList.remove('show');
        });
    }

    // ===== IMAGE PREVIEW =====
    document.querySelectorAll('input[data-preview]').forEach(function(input) {
        input.addEventListener('input', function() {
            var previewId = this.getAttribute('data-preview');
            var preview = document.getElementById(previewId);
            if (preview) {
                preview.src = this.value || '';
                preview.style.display = this.value ? 'block' : 'none';
            }
        });
    });

    // ===== SEARCH DEBOUNCE =====
    var searchInput = document.getElementById('searchInput');
    if (searchInput) {
        var debounceTimer;
        searchInput.addEventListener('input', function() {
            clearTimeout(debounceTimer);
            var form = this.closest('form');
            debounceTimer = setTimeout(function() {
                if (form) form.submit();
            }, 500);
        });
    }

    // ===== TOOLTIP INIT =====
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.forEach(function(el) {
        new bootstrap.Tooltip(el);
    });

    // ===== SIMPLE BAR CHART (Reports) =====
    window.renderBarChart = function(containerId, data, maxVal) {
        var container = document.getElementById(containerId);
        if (!container || !data) return;

        var html = '<div class="bar-chart">';
        var max = maxVal || Math.max.apply(null, data.map(function(d) { return d.value; })) || 1;

        data.forEach(function(d) {
            var height = Math.max(2, (d.value / max) * 100);
            html += '<div class="bar-chart-item">';
            html += '<div class="bar-chart-bar" style="height:' + height + '%;" title="' + formatVND(d.value) + '"></div>';
            html += '<div class="bar-chart-label">' + d.label + '</div>';
            html += '</div>';
        });
        html += '</div>';
        container.innerHTML = html;
    };

});
