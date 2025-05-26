<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Devolver Libro - Biblioteca Duitama</title>

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
            margin-bottom: 2rem;
        }
    </style>
</head>

<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0 sidebar">
                <div class="d-flex flex-column p-3">
                    <a href="/roles_war_exploded/admin/panel" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
                        <i class="bi bi-book fs-4 me-2"></i>
                        <span class="fs-4">Biblioteca</span>
                    </a>
                    <hr class="text-white">
                    <ul class="nav nav-pills flex-column mb-auto">
                        <li class="nav-item">
                            <a href="/roles_war_exploded/admin/panel" class="nav-link text-white">
                                <i class="bi bi-speedometer2"></i>Panel Principal
                            </a>
                        </li>
                        <li>
                            <a href="/roles_war_exploded/admin/libros" class="nav-link text-white">
                                <i class="bi bi-book"></i>Libros
                            </a>
                        </li>
                        <li>
                            <a href="/roles_war_exploded/admin/prestamos" class="nav-link active">
                                <i class="bi bi-journal-text"></i>Préstamos
                            </a>
                        </li>
                        <li>
                            <a href="/roles_war_exploded/admin/usuarios" class="nav-link text-white">
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
                            <li><a class="dropdown-item" href="/roles_war_exploded/cambiar-password">
                                <i class="bi bi-key me-2"></i>Cambiar Contraseña
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="/roles_war_exploded/logout">
                                <i class="bi bi-box-arrow-right me-2"></i>Cerrar Sesión
                            </a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Contenido principal -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Devolver Libro</h1>
                </div>

                <!-- Mensajes -->
                <c:if test="${not empty sessionScope.mensaje}">
                    <div class="alert alert-${sessionScope.tipo} alert-dismissible fade show" role="alert">
                        ${sessionScope.mensaje}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="mensaje" scope="session"/>
                    <c:remove var="tipo" scope="session"/>
                </c:if>

                <!-- Formulario de devolución -->
                <div class="card">
                    <div class="card-body">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle-fill me-2"></i>
                            Confirme los detalles del préstamo antes de proceder con la devolución.
                        </div>
                        
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h5 class="card-title">Detalles del Préstamo</h5>
                                <dl class="row">
                                    <dt class="col-sm-4">Libro:</dt>
                                    <dd class="col-sm-8">${prestamo.tituloLibro}</dd>
                                    
                                    <dt class="col-sm-4">Usuario:</dt>
                                    <dd class="col-sm-8">${prestamo.nombreUsuario}</dd>
                                    
                                    <dt class="col-sm-4">Fecha Préstamo:</dt>
                                    <dd class="col-sm-8">
                                        <fmt:formatDate value="${prestamo.fechaPrestamo}" pattern="dd/MM/yyyy"/>
                                    </dd>
                                    
                                    <dt class="col-sm-4">Fecha Devolución:</dt>
                                    <dd class="col-sm-8">
                                        <fmt:formatDate value="${prestamo.fechaDevolucion}" pattern="dd/MM/yyyy"/>
                                    </dd>
                                </dl>
                            </div>
                        </div>

                        <form action="/roles_war_exploded/admin/prestamos/devolver" method="post">
                            <input type="hidden" name="id" value="${prestamo.id}">
                            <input type="hidden" name="accion" value="devolver">
                            
                            <div class="d-flex justify-content-end gap-2">
                                <a href="/roles_war_exploded/admin/prestamos?accion=listar" class="btn btn-secondary">
                                    <i class="bi bi-x-circle me-2"></i>Cancelar
                                </a>
                                <button type="submit" class="btn btn-success">
                                    <i class="bi bi-check-circle me-2"></i>Confirmar Devolución
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 