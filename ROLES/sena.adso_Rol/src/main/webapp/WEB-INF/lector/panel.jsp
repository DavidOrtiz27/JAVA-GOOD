<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Panel Lector - Biblioteca Duitama</title>

    <!-- Estilos Bootstrap e íconos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    
    <style>
        .sidebar {
            min-height: 100vh;
            background: #2c3e50;
            color: white;
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,.8);
            padding: 1rem;
            margin: 0.2rem 0;
            border-radius: 0.5rem;
        }
        .sidebar .nav-link:hover {
            color: white;
            background: rgba(255,255,255,.1);
        }
        .sidebar .nav-link.active {
            background: #34495e;
            color: white;
        }
        .sidebar .nav-link i {
            margin-right: 0.5rem;
        }
        .main-content {
            background: #f8f9fa;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>

<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0 sidebar">
                <div class="d-flex flex-column p-3">
                    <a href="${pageContext.request.contextPath}/lector/panel" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
                        <i class="bi bi-book fs-4 me-2"></i>
                        <span class="fs-4">Biblioteca</span>
                    </a>
                    <hr class="text-white">
                    <ul class="nav nav-pills flex-column mb-auto">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/lector/panel" class="nav-link active">
                                <i class="bi bi-speedometer2"></i>Panel Principal
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/lector/catalogo/listar" class="nav-link text-white">
                                <i class="bi bi-book"></i>Catálogo
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/lector/prestamos/historial" class="nav-link text-white">
                                <i class="bi bi-journal-text"></i>Mis Préstamos
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/cambiar-password" class="nav-link text-white">
                                <i class="bi bi-key"></i>Cambiar Contraseña
                            </a>
                        </li>
                    </ul>
                    <hr class="text-white">
                    <div class="dropdown">
                        <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-person-circle fs-4 me-2"></i>
                            <strong>${sessionScope.usuario.nombre}</strong>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark text-small shadow" aria-labelledby="dropdownUser1">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/cambiar-password">
                                <i class="bi bi-key me-2"></i>Cambiar Contraseña
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right me-2"></i>Cerrar Sesión
                            </a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Contenido principal -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Bienvenido, ${sessionScope.usuario.nombre}</h1>
                </div>

                <!-- Mensajes -->
                <c:if test="${not empty mensaje}">
                    <div class="alert alert-${tipo} alert-dismissible fade show" role="alert">
                        ${mensaje}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Tarjetas de Acceso Rápido -->
                <div class="row g-4 py-3">
                    <!-- Catálogo -->
                    <div class="col-md-6">
                        <div class="card h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center mb-3">
                                    <i class="bi bi-book fs-1 text-primary me-3"></i>
                                    <div>
                                        <h5 class="card-title mb-1">Catálogo de Libros</h5>
                                        <p class="card-text text-muted">Explora nuestra colección de libros</p>
                                    </div>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/lector/catalogo/listar" class="btn btn-primary">
                                        Ver Catálogo
                                    </a>
                                    <a href="${pageContext.request.contextPath}/lector/catalogo/buscar" class="btn btn-outline-primary">
                                        Buscar Libros
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Mis Préstamos -->
                    <div class="col-md-6">
                        <div class="card h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center mb-3">
                                    <i class="bi bi-journal-text fs-1 text-success me-3"></i>
                                    <div>
                                        <h5 class="card-title mb-1">Mis Préstamos</h5>
                                        <p class="card-text text-muted">Gestiona tus préstamos activos y revisa tu historial</p>
                                    </div>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/lector/prestamos/historial" class="btn btn-success">
                                        Ver Préstamos
                                    </a>
                                    <a href="${pageContext.request.contextPath}/lector/prestamos/historial?tab=activos" class="btn btn-outline-success">
                                        Préstamos Activos
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Libros Recientes -->
                <div class="row mt-4">
                    <div class="col-12">
                        <h3 class="mb-3">Libros Disponibles</h3>
                        <div class="row row-cols-1 row-cols-md-3 g-4">
                            <c:forEach items="${libros}" var="libro" varStatus="status">
                                <c:if test="${status.index < 6}">
                                    <div class="col">
                                        <div class="card h-100">
                                            <div class="card-body">
                                                <h5 class="card-title">${libro.titulo}</h5>
                                                <h6 class="card-subtitle mb-2 text-muted">${libro.autor}</h6>
                                                <p class="card-text">
                                                    <small class="text-muted">
                                                        Disponibles: ${libro.ejemplaresDisponibles}
                                                    </small>
                                                </p>
                                                <a href="${pageContext.request.contextPath}/lector/catalogo/ver?id=${libro.id}" class="btn btn-outline-primary btn-sm">
                                                    Ver Detalles
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
