<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es" class="h-100">
<head>
    <meta charset="UTF-8" />
    <title>Listado de Libros - Biblioteca Duitama</title>

    <!-- Estilos Bootstrap e íconos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet" />

    <!-- Estilos personalizados -->
    <style>
        table {
            background-color: #fff;
            width: 100% !important;
            min-width: 1200px;
        }
        thead {
            background-color: #343a40;
            color: white;
        }
        th:nth-child(2), td:nth-child(2) { min-width: 220px; }
        th:nth-child(4), td:nth-child(4) { min-width: 180px; }
        th:nth-child(7), td:nth-child(7),
        th:nth-child(8), td:nth-child(8),
        th:nth-child(9), td:nth-child(9),
        th:nth-child(10), td:nth-child(10),
        th:nth-child(11), td:nth-child(11),
        th:nth-child(12), td:nth-child(12) { min-width: 140px; }
        th:last-child, td:last-child {
            min-width: 110px;
            text-align: center;
        }
    </style>
</head>

<body class="d-flex flex-column h-100 bg-light">

<!-- Navbar -->
<nav class="navbar navbar-expand navbar-dark bg-dark shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/panelAdmin">
            <i class="bi bi-house-fill"></i> Biblioteca Duitama
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/panelAdmin">
                        <i class="bi bi-speedometer2"></i> Inicio
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/bibliotecario/prestamos">
                        <i class="bi bi-journal-bookmark-fill"></i> Préstamos
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/bibliotecario/usuarios">
                        <i class="bi bi-people-fill"></i> Usuarios
                    </a>
                </li>
            </ul>

            <div class="d-flex align-items-center">
                <span class="navbar-text text-white me-3">
                    <i class="bi bi-person-circle"></i> ${sessionScope.usuario.nombre}
                </span>
                <a href="${pageContext.request.contextPath}/logout.jsp" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión
                </a>
            </div>
        </div>
    </div>
</nav>

<!-- Contenido principal -->
<main class="flex-grow-1 py-1">
    <div class="container-fluid">
        <h1 class="mb-4 text-center fw-bold text-secondary">Listado de Libros</h1>

        <div class="mb-4 text-end">
            <a href="${pageContext.request.contextPath}/bibliotecario/libros/agregar" class="btn btn-primary">
                <i class="bi bi-plus-circle me-1"></i> Agregar Nuevo Libro
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty libros}">
                <div class="table-responsive">
                    <table id="tablaLibros" class="table table-bordered table-striped table-hover align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Título</th>
                                <th>ISBN</th>
                                <th>Autor</th>
                                <th>Ejemplares Disponibles</th>
                                <th>Tipo</th>
                                <th>Premios Literarios (Ficción)</th>
                                <th>Género (Ficción)</th>
                                <th>Área Temática (No Ficción)</th>
                                <th>Público Objetivo (No Ficción)</th>
                                <th>Campo Académico (Referencia)</th>
                                <th>Disponible para Préstamo (Referencia)</th>
                                <th>Opciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="libro" items="${libros}">
                                <tr>
                                    <td>${libro.id}</td>
                                    <td>${libro.titulo}</td>
                                    <td>${libro.isbn}</td>
                                    <td>${libro.autor}</td>
                                    <td>${libro.ejemplaresDisponibles}</td>
                                    <td>${libro.tipoLibro}</td>

                                    <c:choose>
                                        <c:when test="${libro.tipoLibro == 'Ficcion'}">
                                            <td>${libro.premiosLiterarios}</td>
                                            <td>${libro.genero}</td>
                                            <td>-</td><td>-</td><td>-</td><td>-</td>
                                        </c:when>
                                        <c:when test="${libro.tipoLibro == 'NoFiccion'}">
                                            <td>-</td><td>-</td>
                                            <td>${libro.areaTematica}</td>
                                            <td>${libro.publicoObjetivo}</td>
                                            <td>-</td><td>-</td>
                                        </c:when>
                                        <c:when test="${libro.tipoLibro == 'Referencia'}">
                                            <td>-</td><td>-</td><td>-</td><td>-</td>
                                            <td>${libro.campoAcademico}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${libro.consultaInterna}">Si</c:when>
                                                    <c:otherwise>No</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </c:when>
                                        <c:otherwise>
                                            <td colspan="6" class="text-center">-</td>
                                        </c:otherwise>
                                    </c:choose>

                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/libros/editar?id=${libro.id}" class="btn btn-sm btn-warning" title="Editar">
                                            <i class="bi bi-pencil-fill"></i>
                                        </a>
                                        <button
                                            type="button"
                                            class="btn btn-sm btn-danger ms-1 btn-eliminar"
                                            title="Eliminar"
                                            data-id="${libro.id}"
                                            data-titulo="${libro.titulo}">
                                            <i class="bi bi-trash-fill"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                    No hay libros registrados en el sistema.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<!-- Modal Eliminar -->
<div class="modal fade" id="modalEliminarLibro" tabindex="-1" aria-labelledby="modalEliminarLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form id="formEliminarLibro" method="post" action="${pageContext.request.contextPath}/bibliotecario/libros/eliminar">
            <input type="hidden" name="id" id="idEliminarLibro" />
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    ¿Está seguro que desea eliminar este libro?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-danger">Eliminar</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Scripts -->
<script>
    function abrirModalEliminar(idLibro) {
        document.getElementById('idEliminarLibro').value = idLibro;
        var modalEliminar = new bootstrap.Modal(document.getElementById('modalEliminarLibro'));
        modalEliminar.show();
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function () {
        $('#tablaLibros').DataTable({
            language: {
                url: "//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json"
            }
        });

        $('.btn-eliminar').on('click', function () {
            const id = $(this).data('id');
            abrirModalEliminar(id);
        });
    });
</script>

</body>
</html>
