<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="es" class="h-100">
<head>
    <meta charset="UTF-8">
    <title>Panel de Administración - Biblioteca Duitama</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Estilos personalizados -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="d-flex flex-column h-100 bg-light">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            <i class="bi bi-journal-bookmark-fill"></i> Biblioteca Duitama
        </a>
        <div class="ms-auto d-flex align-items-center">
            <span class="text-white me-3">
                ${sessionScope.usuario.nombre}
            </span>
            <a href="${pageContext.request.contextPath}/logout.jsp" class="btn btn-outline-light">
                <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión
            </a>
        </div>
    </div>
</nav>

<!-- Contenido principal -->
<main class="flex-grow-1 py-5">
    <div class="container">
        <h2 class="text-center fw-bold mb-5">Panel de Administración</h2>

        <div class="row g-4 justify-content-center">
            <!-- Gestión de Libros -->
            <div class="col-md-4">
                <div class="card shadow h-100 border-0 rounded-4">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-book display-4 text-primary mb-3"></i>
                        <h5 class="card-title fw-bold">Gestión de Libros</h5>
                        <p class="card-text">Agregar, editar y administrar el catálogo de libros.</p>
                        <a href="${pageContext.request.contextPath}/libros/agregar.jsp" class="btn btn-primary mb-2">
                            <i class="bi bi-plus-circle me-1"></i> Agregar Libro
                        </a><br>
                        <a href="${pageContext.request.contextPath}/libros/listar.jsp" class="btn btn-outline-primary">
                            <i class="bi bi-card-list me-1"></i> Ver Catálogo
                        </a>
                    </div>
                </div>
            </div>

            <!-- Gestión de Préstamos -->
            <div class="col-md-4">
                <div class="card shadow h-100 border-0 rounded-4">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-people display-4 text-success mb-3"></i>
                        <h5 class="card-title fw-bold">Gestión de Préstamos</h5>
                        <p class="card-text">Administrar préstamos y devoluciones de libros.</p>
                        <a href="${pageContext.request.contextPath}/prestamos/nuevo.jsp" class="btn btn-success mb-2">
                            <i class="bi bi-plus-circle me-1"></i> Nuevo Préstamo
                        </a><br>
                        <a href="${pageContext.request.contextPath}/prestamos/listar.jsp" class="btn btn-outline-success">
                            <i class="bi bi-clock-history me-1"></i> Ver Préstamos
                        </a>
                    </div>
                </div>
            </div>

            <!-- Gestión de Usuarios -->
            <div class="col-md-4">
                <div class="card shadow h-100 border-0 rounded-4">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-person-badge display-4 text-warning mb-3"></i>
                        <h5 class="card-title fw-bold">Gestión de Usuarios</h5>
                        <p class="card-text">Administrar usuarios y sus permisos.</p>
                        <a href="${pageContext.request.contextPath}/bibliotecario/usuarios/registro.jsp" class="btn btn-warning text-dark mb-2">
                            <i class="bi bi-person-plus-fill me-1"></i> Registrar Usuario
                        </a><br>
                        <a href="${pageContext.request.contextPath}/bibliotecario/usuarios/listar.jsp" class="btn btn-outline-warning text-dark">
                            <i class="bi bi-list-ul me-1"></i> Ver Usuarios
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="footer mt-auto py-3 bg-dark text-white">
    <div class="container text-center">
        <p class="mb-0">© 2025 Municipalidad de Duitama - Biblioteca Municipal</p>
    </div>
</footer>

</body>
</html>
