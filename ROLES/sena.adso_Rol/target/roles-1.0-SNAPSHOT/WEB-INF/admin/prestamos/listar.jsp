<%--
  Created by IntelliJ IDEA.
  User: jd
  Date: 23/5/25
  Time: 10:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Préstamos - Biblioteca Duitama</title>

    <!-- Estilos Bootstrap e íconos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    <link href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.bootstrap5.min.css" rel="stylesheet"/>
    
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
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        /* Estilos mejorados para DataTables */
        .dataTables_wrapper {
            padding: 1.5rem;
            font-size: 1.1rem;
            width: 100%;
        }
        .dataTables_wrapper .dataTables_filter {
            margin-bottom: 1.5rem;
        }
        .dataTables_wrapper .dataTables_filter input {
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 0.5rem 1rem;
            font-size: 1rem;
            width: 300px;
        }
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 0.5rem 2.5rem 0.5rem 1rem;
            font-size: 1rem;
        }
        .dataTables_wrapper .dataTables_info {
            padding-top: 1.5rem;
            font-size: 1rem;
        }
        .dataTables_wrapper .dataTables_paginate {
            padding-top: 1.5rem;
        }
        .dataTables_wrapper .dataTables_paginate .paginate_button {
            padding: 0.5rem 1rem;
            margin: 0 0.2rem;
            font-size: 1rem;
        }
        .table {
            font-size: 1.1rem;
            width: 100% !important;
        }
        .table th {
            font-weight: 600;
            padding: 1rem;
            background-color: #f8f9fa;
            white-space: nowrap;
        }
        .table td {
            padding: 1rem;
            vertical-align: middle;
        }
        .badge {
            font-size: 0.9rem;
            padding: 0.5rem 1rem;
        }
        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 1rem;
        }
        .nav-tabs .nav-link {
            font-size: 1.1rem;
            padding: 1rem 1.5rem;
        }
        .h2 {
            font-size: 2rem;
            font-weight: 600;
        }
        .table-responsive {
            width: 100%;
            margin-bottom: 1rem;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }
        .tab-content {
            padding: 1rem 0;
        }
        .tab-pane {
            padding: 1rem 0;
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
                            <a href="${pageContext.request.contextPath}/admin/panel" class="nav-link text-white">
                                <i class="bi bi-speedometer2"></i>Panel Principal
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/libros" class="nav-link text-white">
                                <i class="bi bi-book"></i>Libros
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/prestamos" class="nav-link active">
                                <i class="bi bi-journal-text"></i>Préstamos
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/usuarios" class="nav-link text-white">
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

            <!-- Contenido principal -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Gestión de Préstamos</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/prestamos/nuevo" class="btn btn-primary">
                            <i class="bi bi-plus-circle me-2"></i>Nuevo Préstamo
                        </a>
                    </div>
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

                <!-- Pestañas -->
                <ul class="nav nav-tabs mb-4" id="prestamosTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="activos-tab" data-bs-toggle="tab" data-bs-target="#activos" type="button" role="tab" aria-controls="activos" aria-selected="true">
                            <i class="bi bi-book me-2"></i>Préstamos Activos
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="vencidos-tab" data-bs-toggle="tab" data-bs-target="#vencidos" type="button" role="tab" aria-controls="vencidos" aria-selected="false">
                            <i class="bi bi-exclamation-triangle me-2"></i>Préstamos Vencidos
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="historial-tab" data-bs-toggle="tab" data-bs-target="#historial" type="button" role="tab" aria-controls="historial" aria-selected="false">
                            <i class="bi bi-clock-history me-2"></i>Historial
                        </button>
                    </li>
                </ul>

                <!-- Contenido de las pestañas -->
                <div class="tab-content" id="prestamosTabsContent">
                    <!-- Préstamos Activos -->
                    <div class="tab-pane fade show active" id="activos" role="tabpanel" aria-labelledby="activos-tab">
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table id="tablaActivos" class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Libro</th>
                                                <th>Usuario</th>
                                                <th>Fecha Préstamo</th>
                                                <th>Fecha Devolución</th>
                                                <th>Estado</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${prestamosActivos}" var="prestamo">
                                                <tr>
                                                    <td>${prestamo.id}</td>
                                                    <td>${prestamo.tituloLibro}</td>
                                                    <td>${prestamo.nombreUsuario}</td>
                                                    <td><fmt:formatDate value="${prestamo.fechaPrestamo}" pattern="dd/MM/yyyy"/></td>
                                                    <td><fmt:formatDate value="${prestamo.fechaDevolucion}" pattern="dd/MM/yyyy"/></td>
                                                    <td>
                                                        <span class="badge bg-success">Activo</span>
                                                    </td>
                                                    <td>
                                                        <button type="button" class="btn btn-sm btn-success" 
                                                                onclick="confirmarDevolucion('${prestamo.id}')">
                                                            <i class="bi bi-check-circle"></i> Devolver
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Préstamos Vencidos -->
                    <div class="tab-pane fade" id="vencidos" role="tabpanel" aria-labelledby="vencidos-tab">
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table id="tablaVencidos" class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Libro</th>
                                                <th>Usuario</th>
                                                <th>Fecha Préstamo</th>
                                                <th>Fecha Devolución</th>
                                                <th>Estado</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${prestamosVencidos}" var="prestamo">
                                                <tr>
                                                    <td>${prestamo.id}</td>
                                                    <td>${prestamo.tituloLibro}</td>
                                                    <td>${prestamo.nombreUsuario}</td>
                                                    <td><fmt:formatDate value="${prestamo.fechaPrestamo}" pattern="dd/MM/yyyy"/></td>
                                                    <td><fmt:formatDate value="${prestamo.fechaDevolucion}" pattern="dd/MM/yyyy"/></td>
                                                    <td>
                                                        <span class="badge bg-danger">Vencido</span>
                                                    </td>
                                                    <td>
                                                        <button type="button" class="btn btn-sm btn-success" 
                                                                onclick="confirmarDevolucion('${prestamo.id}')">
                                                            <i class="bi bi-check-circle"></i> Devolver
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Historial -->
                    <div class="tab-pane fade" id="historial" role="tabpanel" aria-labelledby="historial-tab">
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table id="tablaHistorial" class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Libro</th>
                                                <th>Usuario</th>
                                                <th>Fecha Préstamo</th>
                                                <th>Fecha Devolución</th>
                                                <th>Estado</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${historial}" var="prestamo">
                                                <tr>
                                                    <td>${prestamo.id}</td>
                                                    <td>${prestamo.tituloLibro}</td>
                                                    <td>${prestamo.nombreUsuario}</td>
                                                    <td><fmt:formatDate value="${prestamo.fechaPrestamo}" pattern="dd/MM/yyyy"/></td>
                                                    <td><fmt:formatDate value="${prestamo.fechaDevolucion}" pattern="dd/MM/yyyy"/></td>
                                                    <td>
                                                        <span class="badge bg-secondary">Devuelto</span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Modal de Confirmación de Devolución -->
    <div class="modal fade" id="modalConfirmarDevolucion" tabindex="-1" aria-labelledby="modalConfirmarDevolucionLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="modalConfirmarDevolucionLabel">Confirmar Devolución</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle-fill me-2"></i>
                        ¿Está seguro que desea registrar la devolución de este libro?
                    </div>
                    <div class="card mb-3">
                        <div class="card-body">
                            <h6 class="card-title" id="modalPrestamoLibro"></h6>
                            <p class="mb-1"><strong>Usuario:</strong> <span id="modalPrestamoUsuario"></span></p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <form id="formDevolver" action="${pageContext.request.contextPath}/admin/prestamos/devolver" method="post" style="display: inline;">
                        <input type="hidden" name="id" id="prestamoIdDevolver">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-circle me-2"></i>Confirmar Devolución
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>

    <script>
        $(document).ready(function() {
            // Inicializar DataTables para cada tabla
            $('#tablaActivos, #tablaVencidos, #tablaHistorial').DataTable({
                responsive: true,
                language: {
                    "decimal": "",
                    "emptyTable": "No hay datos disponibles",
                    "info": "Mostrando _START_ a _END_ de _TOTAL_ registros",
                    "infoEmpty": "Mostrando 0 a 0 de 0 registros",
                    "infoFiltered": "(filtrado de _MAX_ registros totales)",
                    "infoPostFix": "",
                    "thousands": ",",
                    "lengthMenu": "Mostrar _MENU_ registros",
                    "loadingRecords": "Cargando...",
                    "processing": "Procesando...",
                    "search": "Buscar:",
                    "zeroRecords": "No se encontraron registros coincidentes",
                    "paginate": {
                        "first": "Primero",
                        "last": "Último",
                        "next": "Siguiente",
                        "previous": "Anterior"
                    },
                    "aria": {
                        "sortAscending": ": activar para ordenar columna ascendente",
                        "sortDescending": ": activar para ordenar columna descendente"
                    }
                },
                pageLength: 10,
                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "Todos"]],
                order: [[0, 'desc']],
                columnDefs: [
                    {
                        targets: -1,
                        orderable: false
                    }
                ]
            });
        });

        function confirmarDevolucion(id) {
            console.log("ID del préstamo:", id);
            if (id && id !== '') {
                // Redirigir directamente a la página de devolución
                window.location.href = '/roles_war_exploded/admin/prestamos?accion=devolver&id=' + id;
            } else {
                alert("Error: No se pudo obtener el ID del préstamo");
            }
        }
    </script>
</body>
</html>
