<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Mis Préstamos - Biblioteca Duitama</title>

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
        }
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .nav-tabs .nav-link {
            color: #495057;
            border: none;
            padding: 1rem 1.5rem;
            font-weight: 500;
        }
        .nav-tabs .nav-link.active {
            color: #2c3e50;
            background: none;
            border-bottom: 3px solid #2c3e50;
        }
        .nav-tabs .nav-link:hover {
            border-color: transparent;
            color: #2c3e50;
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
                            <a href="${pageContext.request.contextPath}/lector/panel" class="nav-link text-white">
                                <i class="bi bi-speedometer2"></i>Panel Principal
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/lector/catalogo/listar" class="nav-link text-white">
                                <i class="bi bi-book"></i>Catálogo
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/lector/prestamos/historial" class="nav-link active">
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
                    <h1 class="h2">Mis Préstamos</h1>
                </div>

                <!-- Mensajes -->
                <c:if test="${not empty mensaje}">
                    <div class="alert alert-${tipo} alert-dismissible fade show" role="alert">
                        ${mensaje}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Pestañas -->
                <ul class="nav nav-tabs mb-4" id="prestamosTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="activos-tab" data-bs-toggle="tab" data-bs-target="#activos" type="button" role="tab">
                            <i class="bi bi-journal-text me-2"></i>Préstamos Activos
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="historial-tab" data-bs-toggle="tab" data-bs-target="#historial" type="button" role="tab">
                            <i class="bi bi-clock-history me-2"></i>Historial
                        </button>
                    </li>
                </ul>

                <!-- Contenido de las pestañas -->
                <div class="tab-content" id="prestamosTabsContent">
                    <!-- Pestaña Préstamos Activos -->
                    <div class="tab-pane fade show active" id="activos" role="tabpanel">
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th>Libro</th>
                                                <th>Fecha Préstamo</th>
                                                <th>Fecha Devolución</th>
                                                <th>Estado</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${prestamos}" var="prestamo">
                                                <c:if test="${prestamo.estado == 'ACTIVO'}">
                                                    <tr>
                                                        <td>${prestamo.tituloLibro}</td>
                                                        <td><fmt:formatDate value="${prestamo.fechaPrestamo}" pattern="dd/MM/yyyy"/></td>
                                                        <td><fmt:formatDate value="${prestamo.fechaDevolucion}" pattern="dd/MM/yyyy"/></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${prestamo.fechaDevolucion.before(now)}">
                                                                    <span class="badge bg-danger">
                                                                        <i class="bi bi-exclamation-circle me-1"></i>Vencido
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-success">
                                                                        <i class="bi bi-check-circle me-1"></i>Activo
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Pestaña Historial -->
                    <div class="tab-pane fade" id="historial" role="tabpanel">
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th>Libro</th>
                                                <th>Fecha Préstamo</th>
                                                <th>Fecha Devolución</th>
                                                <th>Estado</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${prestamos}" var="prestamo">
                                                <c:if test="${prestamo.estado == 'DEVUELTO'}">
                                                    <tr>
                                                        <td>${prestamo.tituloLibro}</td>
                                                        <td><fmt:formatDate value="${prestamo.fechaPrestamo}" pattern="dd/MM/yyyy"/></td>
                                                        <td><fmt:formatDate value="${prestamo.fechaDevolucion}" pattern="dd/MM/yyyy"/></td>
                                                        <td>
                                                            <span class="badge bg-secondary">
                                                                <i class="bi bi-check-circle me-1"></i>Devuelto
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Mensaje si no hay préstamos -->
                <c:if test="${empty prestamos}">
                    <div class="alert alert-info" role="alert">
                        <i class="bi bi-info-circle me-2"></i>
                        No tienes préstamos registrados.
                    </div>
                </c:if>
            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 