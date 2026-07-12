<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Footer -->
<footer class="gradient-bg text-white mt-auto">
    <div class="container py-4">
        <div class="row align-items-center">
            <!-- Brand & Copyright -->
            <div class="col-md-4 text-center text-md-start mb-3 mb-md-0">
                <div class="footer-brand mb-2">
                    <img class="footer-logo" src="${pageContext.request.contextPath}/assets/images/logo_dhv.jpg" alt="Logo DHV Canteen">
                    <h5 class="mb-0">DHV Canteen</h5>
                </div>
                
            </div>

            <!-- Contact Info -->
            <div class="col-md-4 text-center mb-3 mb-md-0">
                <p class="mb-1 small">
                    <i class="fas fa-phone me-1"></i>Hotline: 028 7100 0888
                </p>
                <p class="mb-1 small">
                    <i class="fas fa-envelope me-1"></i>DHVcantin@truonghoc.edu.vn
                </p>
                <p class="mb-0 small">
                    <i class="fas fa-map-marker-alt me-1"></i>736 Nguyễn Trãi, Chợ Lớn, TP.HCM
                </p>
            </div>

            <!-- Social Links -->
            <div class="col-md-4 text-center text-md-end">
                <p class="mb-2 small">Kết nối với chúng tôi</p>
                <a href="#" class="text-white me-3" title="Facebook">
                    <i class="fab fa-facebook-f fa-lg"></i>
                </a>
                <a href="#" class="text-white me-3" title="Instagram">
                    <i class="fab fa-instagram fa-lg"></i>
                </a>
                <a href="#" class="text-white me-3" title="YouTube">
                    <i class="fab fa-youtube fa-lg"></i>
                </a>
                <a href="#" class="text-white" title="Thư điện tử">
                    <i class="fas fa-envelope fa-lg"></i>
                </a>
            </div>
        </div>

        <hr class="my-3 opacity-25">

    </div>

    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .footer-brand {
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
        }
        .footer-logo {
            width: 46px;
            height: 46px;
            object-fit: cover;
            border-radius: 12px;
            background: #ffffff;
            padding: 4px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        footer a.text-white {
            opacity: 0.8;
            transition: opacity 0.2s;
        }
        footer a.text-white:hover {
            opacity: 1;
        }
        @media (max-width: 768px) {
            .footer-brand {
                justify-content: center;
            }
        }
    </style>
</footer>

<!-- Bootstrap 5 JS Bundle (Popper included) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

</body>
</html>
