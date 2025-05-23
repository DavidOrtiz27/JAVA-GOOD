<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="es" class="h-100">
<head>
    <meta charset="utf-8">
    <meta name="description" content="Portal de la Biblioteca Municipal de Duitama">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Biblioteca Duitama</title>
    <link rel="icon" href="${pageContext.request.contextPath}/resources/img/favicon.ico" type="image/x-icon">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <!-- Estilos personalizados -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">

    <style>
        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url('${pageContext.request.contextPath}/resources/img/biblioteca.jpg') center/cover no-repeat;
            padding: 100px 0;
            color: white;
        }

        .feature-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: #0d6efd;
        }

        .card-feature {
            transition: transform 0.3s ease;
            cursor: pointer;
        }

        .card-feature:hover {
            transform: translateY(-5px);
        }
    </style>
</head>

<body class="d-flex flex-column h-100">

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="bi bi-journal-bookmark-fill"></i> Biblioteca Duitama
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/auth/login">
                        <i class="bi bi-box-arrow-in-right"></i> Iniciar Sesión
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/auth/registro">
                        <i class="bi bi-person-plus"></i> Registrarse
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<main class="flex-shrink-0">
    <!-- HERO -->
    <section class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 fw-bold mb-4">Bienvenido a la Biblioteca Municipal de Duitama</h1>
            <p class="lead mb-4">Descubre un mundo de conocimiento y cultura a tu alcance</p>
            <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary btn-lg px-4 gap-3">
                    <i class="bi bi-box-arrow-in-right"></i> Iniciar Sesión
                </a>
                <a href="${pageContext.request.contextPath}/auth/registro" class="btn btn-outline-light btn-lg px-4">
                    <i class="bi bi-person-plus"></i> Registrarse
                </a>
            </div>
        </div>
    </section>

    <!-- SERVICIOS -->
    <section class="py-5 bg-light">
        <div class="container">
            <h2 class="text-center mb-5">Nuestros Servicios</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card h-100 border-0 shadow-sm card-feature">
                        <div class="card-body text-center">
                            <i class="bi bi-book feature-icon"></i>
                            <h3 class="h5 card-title">Catálogo Digital</h3>
                            <p class="card-text">Accede a nuestra extensa colección de libros desde cualquier dispositivo.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100 border-0 shadow-sm card-feature">
                        <div class="card-body text-center">
                            <i class="bi bi-laptop feature-icon"></i>
                            <h3 class="h5 card-title">Préstamos en Línea</h3>
                            <p class="card-text">Reserva y gestiona tus préstamos de forma fácil y rápida.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100 border-0 shadow-sm card-feature">
                        <div class="card-body text-center">
                            <i class="bi bi-calendar-event feature-icon"></i>
                            <h3 class="h5 card-title">Eventos Culturales</h3>
                            <p class="card-text">Mantente informado sobre nuestras actividades y eventos.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<!-- FOOTER -->
<footer class="footer mt-auto py-3 bg-dark">
    <div class="container text-center text-white">
        <p class="mb-1">© 2025 Municipalidad de Duitama - Biblioteca Municipal</p>
        <p class="mb-0 text-muted">
            <small>Dirección: Calle Principal #123, Duitama, Boyacá</small>
        </p>
    </div>
</footer>

</body>
</html>