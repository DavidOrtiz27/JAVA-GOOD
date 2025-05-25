<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es" class="h-100">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Panel de Lector - Biblioteca Duitama</title>

    <!-- Estilos Bootstrap e íconos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/WEB-INF/css/styles.css" rel="stylesheet"/>
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
                            <a href="${pageContext.request.contextPath}/lector/catalogo" class="nav-link text-white">
                                <i class="bi bi-book"></i>Catálogo
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/lector/prestamos" class="nav-link text-white">
                                <i class="bi bi-journal-text"></i>Mis Préstamos
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
                    <h1 class="h2">Panel de Lector</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/lector/catalogo" class="btn btn-primary">
                            <i class="bi bi-search me-2"></i>Explorar Catálogo
                        </a>
                    </div>
                </div>

                <!-- Tarjetas de resumen -->
                <div class="row g-4 mb-4">
                    <div class="col-md-6">
                        <div class="card h-100">
                            <div class="card-body text-center">
                                <i class="bi bi-book text-primary card-icon"></i>
                                <h5 class="card-title">Préstamos Activos</h5>
                                <p class="card-text display-6">${prestamosActivos}</p>
                                <a href="${pageContext.request.contextPath}/lector/prestamos" class="btn btn-outline-primary">
                                    Ver Detalles
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card h-100">
                            <div class="card-body text-center">
                                <i class="bi bi-clock-history text-success card-icon"></i>
                                <h5 class="card-title">Historial de Préstamos</h5>
                                <p class="card-text display-6">${totalPrestamos}</p>
                                <a href="${pageContext.request.contextPath}/lector/prestamos/historial" class="btn btn-outline-success">
                                    Ver Historial
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Préstamos activos -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-bookmark-check me-2"></i>Mis Préstamos Activos
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Libro</th>
                                        <th>Fecha Préstamo</th>
                                        <th>Fecha Devolución</th>
                                        <th>Estado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${prestamosActivos}" var="prestamo">
                                        <tr>
                                            <td>${prestamo.libro.titulo}</td>
                                            <td>${prestamo.fechaPrestamo}</td>
                                            <td>${prestamo.fechaDevolucion}</td>
                                            <td>
                                                <span class="badge bg-success">Activo</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Libros recomendados -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-stars me-2"></i>Libros Recomendados
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row row-cols-1 row-cols-md-3 g-4">
                            <c:forEach items="${librosRecomendados}" var="libro">
                                <div class="col">
                                    <div class="card h-100">
                                        <div class="card-body">
                                            <h5 class="card-title">${libro.titulo}</h5>
                                            <p class="card-text">${libro.autor}</p>
                                            <p class="card-text">
                                                <small class="text-muted">${libro.categoria}</small>
                                            </p>
                                        </div>
                                        <div class="card-footer bg-transparent border-0">
                                            <a href="${pageContext.request.contextPath}/lector/catalogo/ver?id=${libro.id}" 
                                               class="btn btn-outline-primary btn-sm">
                                                Ver Detalles
                                            </a>
                                        </div>
                                    </div>
                                </div>
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
