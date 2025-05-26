<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Panel de Control - Biblioteca Duitama</title>

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
            transition: transform 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .stat-card {
            background: linear-gradient(45deg, #2c3e50, #34495e);
            color: white;
        }
        .stat-card .icon {
            font-size: 2.5rem;
            opacity: 0.8;
        }
    </style>
</head>

<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0 sidebar">
                <div class="d-flex flex-column p-3">
                    <a href="${pageContext.request.contextPath}/admin/panel" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
                        <i class="bi bi-book fs-4 me-2"></i>
                        <span class="fs-4">Biblioteca</span>
                    </a>
                    <hr class="text-white">
                    <ul class="nav nav-pills flex-column mb-auto">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/panel" class="nav-link active">
                                <i class="bi bi-speedometer2"></i>Panel Principal
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/libros" class="nav-link text-white">
                                <i class="bi bi-book"></i>Libros
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/prestamos" class="nav-link text-white">
                                <i class="bi bi-journal-text"></i>Préstamos
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/usuarios/listar" class="nav-link text-white">
                                <i class="bi bi-people"></i>Usuarios
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

            <!-- Contenido Principal -->
            <main class="col-md-9 col-lg-10 px-md-4 py-4">
                <!-- Tarjetas de estadísticas -->
                <div class="row g-4 mb-4">
                    <div class="col-md-3">
                        <div class="card stat-card h-100">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title mb-0">Total Libros</h6>
                                        <h2 class="mt-2 mb-0">${totalLibros}</h2>
                                    </div>
                                    <div class="icon">
                                        <i class="bi bi-book"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card h-100">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title mb-0">Préstamos Activos</h6>
                                        <h2 class="mt-2 mb-0">${prestamosActivos}</h2>
                                    </div>
                                    <div class="icon">
                                        <i class="bi bi-journal-text"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card h-100">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title mb-0">Usuarios Activos</h6>
                                        <h2 class="mt-2 mb-0">${usuariosActivos}</h2>
                                    </div>
                                    <div class="icon">
                                        <i class="bi bi-people"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card h-100">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title mb-0">Préstamos Vencidos</h6>
                                        <h2 class="mt-2 mb-0">${prestamosVencidos}</h2>
                                    </div>
                                    <div class="icon">
                                        <i class="bi bi-exclamation-triangle"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Últimos préstamos -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Últimos Préstamos</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Libro</th>
                                        <th>Usuario</th>
                                        <th>Fecha Préstamo</th>
                                        <th>Estado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${ultimosPrestamos}" var="prestamo">
                                        <tr>
                                            <td>${prestamo.id}</td>
                                            <td>${prestamo.tituloLibro}</td>
                                            <td>${prestamo.nombreUsuario}</td>
                                            <td>${prestamo.fechaPrestamo}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${prestamo.estado == 'ACTIVO'}">
                                                        <span class="badge bg-success">Activo</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Devuelto</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
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