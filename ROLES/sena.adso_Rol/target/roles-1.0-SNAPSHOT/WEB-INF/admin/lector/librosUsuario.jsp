<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es" class="h-100">
<head>
    <meta charset="UTF-8" />
    <title>Listado de Libros - Biblioteca Duitama</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet" />

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
    </style>
</head>

<body class="d-flex flex-column h-100 bg-light">

<!-- Navbar -->
<nav class="navbar navbar-expand navbar-dark bg-dark shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/lector/inicio">
            <i class="bi bi-house-fill"></i> Biblioteca Duitama
        </a>

        <div class="d-flex align-items-center ms-auto">
            <span class="navbar-text text-white me-3">
                <i class="bi bi-person-circle"></i> ${sessionScope.usuario.nombre}
            </span>
            <a href="${pageContext.request.contextPath}/logout.jsp" class="btn btn-outline-light btn-sm">
                <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión
            </a>
        </div>
    </div>
</nav>

<main class="flex-grow-1 py-1">
    <div class="container-fluid">
        <h1 class="mb-4 text-center fw-bold text-secondary">Listado de Libros</h1>

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
                                                    <c:when test="${libro.consultaInterna}">No</c:when>
                                                    <c:otherwise>Si</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </c:when>
                                        <c:otherwise>
                                            <td colspan="6" class="text-center">-</td>
                                        </c:otherwise>
                                    </c:choose>
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

<!-- Scripts -->
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
    });
</script>

</body>
</html>
