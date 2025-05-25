<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es" class="h-100">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Catálogo - Biblioteca Duitama</title>

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
                            <a href="${pageContext.request.contextPath}/lector/panel" class="nav-link text-white">
                                <i class="bi bi-speedometer2"></i>Panel Principal
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/lector/catalogo" class="nav-link active">
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
                    <h1 class="h2">Catálogo de Libros</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#filtrosModal">
                            <i class="bi bi-funnel me-2"></i>Filtros
                        </button>
                    </div>
                </div>

                <!-- Barra de búsqueda -->
                <div class="row mb-4">
                    <div class="col-md-8 mx-auto">
                        <form action="${pageContext.request.contextPath}/lector/catalogo" method="get" class="d-flex">
                            <input type="text" name="busqueda" class="form-control form-control-lg" 
                                   placeholder="Buscar por título, autor o categoría..." 
                                   value="${param.busqueda}">
                            <button type="submit" class="btn btn-primary ms-2">
                                <i class="bi bi-search"></i>
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Grid de libros -->
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                    <c:forEach items="${libros}" var="libro">
                        <div class="col">
                            <div class="card h-100">
                                <img src="${libro.portada}" class="card-img-top book-cover" alt="${libro.titulo}">
                                <div class="card-body">
                                    <h5 class="card-title">${libro.titulo}</h5>
                                    <p class="card-text">
                                        <strong>Autor:</strong> ${libro.autor}<br>
                                        <strong>Categoría:</strong> ${libro.categoria}<br>
                                        <strong>Disponibles:</strong> ${libro.ejemplaresDisponibles}
                                    </p>
                                </div>
                                <div class="card-footer bg-transparent border-0">
                                    <div class="d-grid gap-2">
                                        <a href="${pageContext.request.contextPath}/lector/catalogo/ver?id=${libro.id}" 
                                           class="btn btn-outline-primary">
                                            <i class="bi bi-eye me-2"></i>Ver Detalles
                                        </a>
                                        <c:if test="${libro.ejemplaresDisponibles > 0}">
                                            <form action="${pageContext.request.contextPath}/prestamo" method="post">
                                                <input type="hidden" name="idLibro" value="${libro.id}">
                                                <button type="submit" class="btn btn-success w-100">
                                                    <i class="bi bi-book me-2"></i>Solicitar Préstamo
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Paginación -->
                <nav class="mt-4">
                    <ul class="pagination justify-content-center">
                        <c:if test="${paginaActual > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?pagina=${paginaActual - 1}&busqueda=${param.busqueda}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>
                        
                        <c:forEach begin="1" end="${totalPaginas}" var="i">
                            <li class="page-item ${i == paginaActual ? 'active' : ''}">
                                <a class="page-link" href="?pagina=${i}&busqueda=${param.busqueda}">${i}</a>
                            </li>
                        </c:forEach>
                        
                        <c:if test="${paginaActual < totalPaginas}">
                            <li class="page-item">
                                <a class="page-link" href="?pagina=${paginaActual + 1}&busqueda=${param.busqueda}">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </main>
        </div>
    </div>

    <!-- Modal de Filtros -->
    <div class="modal fade" id="filtrosModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Filtros de Búsqueda</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/lector/catalogo" method="get">
                        <div class="mb-3">
                            <label class="form-label">Categoría</label>
                            <select name="categoria" class="form-select">
                                <option value="">Todas las categorías</option>
                                <c:forEach items="${categorias}" var="categoria">
                                    <option value="${categoria}" ${param.categoria == categoria ? 'selected' : ''}>
                                        ${categoria}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Tipo de Libro</label>
                            <select name="tipo" class="form-select">
                                <option value="">Todos los tipos</option>
                                <option value="Ficcion" ${param.tipo == 'Ficcion' ? 'selected' : ''}>Ficción</option>
                                <option value="NoFiccion" ${param.tipo == 'NoFiccion' ? 'selected' : ''}>No Ficción</option>
                                <option value="Referencia" ${param.tipo == 'Referencia' ? 'selected' : ''}>Referencia</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Disponibilidad</label>
                            <select name="disponibilidad" class="form-select">
                                <option value="">Todos</option>
                                <option value="disponible" ${param.disponibilidad == 'disponible' ? 'selected' : ''}>Disponibles</option>
                                <option value="prestado" ${param.disponibilidad == 'prestado' ? 'selected' : ''}>Prestados</option>
                            </select>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">Aplicar Filtros</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 