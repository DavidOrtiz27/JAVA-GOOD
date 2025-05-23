<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es" class="h-100">
<head>
    <meta charset="UTF-8" />
    <title>Catálogo de Libros e Historial - Biblioteca Duitama</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />

    <!-- Estilos personalizados -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />

    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet" />
</head>
<body class="d-flex flex-column h-100 bg-light">

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

<main class="flex-grow-1 py-5">
    <div class="container">
        <h2 class="text-center fw-bold mb-5">Gestión de Libros e Historial</h2>

        <!-- Nav tabs -->
        <ul class="nav nav-tabs mb-4" id="miTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="libros-tab" data-bs-toggle="tab" data-bs-target="#libros" type="button" role="tab" aria-controls="libros" aria-selected="true">
                    <i class="bi bi-book"></i> Libros
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="historial-tab" data-bs-toggle="tab" data-bs-target="#historial" type="button" role="tab" aria-controls="historial" aria-selected="false">
                    <i class="bi bi-clock-history"></i> Historial
                </button>
            </li>
        </ul>

        <!-- Tab panes -->
        <div class="tab-content" id="miTabContent">
            <!-- Tab Libros -->
            <div class="tab-pane fade show active" id="libros" role="tabpanel" aria-labelledby="libros-tab">
                <div class="card shadow border-0 rounded-4">
                    <div class="card-body p-4">
                        <div class="table-responsive">
                            <table id="tablaLibros" class="table table-striped table-hover align-middle">
                                <thead class="table-primary text-center">
                                <tr>
                                    <th>ID</th>
                                    <th>Título</th>
                                    <th>Tipo</th>
                                    <th>Autor</th>
                                    <th>Género</th>
                                    <th>Premios</th>
                                    <th>Área Temática</th>
                                    <th>Público Objetivo</th>
                                    <th>Consulta Interna</th>
                                    <th>Acciones</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="libro" items="${libros}">
                                    <tr>
                                        <td class="text-center">${libro.id}</td>
                                        <td>${libro.titulo}</td>
                                        <td class="text-center">${libro.tipoLibro}</td>
                                        <td>${libro.autor}</td>

                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${libro.tipoLibro == 'Ficcion'}">${libro.genero}</c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${libro.tipoLibro == 'Ficcion'}">${libro.premiosLiterarios}</c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${libro.tipoLibro == 'NoFiccion'}">${libro.areaTematica}</c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${libro.tipoLibro == 'NoFiccion'}">${libro.publicoObjetivo}</c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${libro.tipoLibro == 'Referencia'}">
                                                    <c:choose>
                                                        <c:when test="${not libro.consultaInterna}">Sí</c:when>
                                                        <c:otherwise>No</c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-center">
                                            <form action="${pageContext.request.contextPath}/prestamo" method="post" class="d-inline">
                                                <input type="hidden" name="idLibro" value="${libro.id}" />
                                                <button type="submit" class="btn btn-sm btn-success" title="Solicitar Préstamo">
                                                    <i class="bi bi-hand-index-thumb"></i> Solicitar
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tab Historial -->
            <div class="tab-pane fade" id="historial" role="tabpanel" aria-labelledby="historial-tab">
                <div class="card shadow border-0 rounded-4 p-4">
                    <h4>Historial</h4>
                    <p>Aquí puedes mostrar el historial de préstamos o cualquier otro historial que tengas.</p>
                    <!-- Agrega aquí tu tabla o contenido del historial -->
                </div>
            </div>
        </div>

    </div>
</main>

<!-- Bootstrap Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery para DataTables -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function () {
        $('#tablaLibros').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.4/i18n/es-ES.json'
            },
            lengthMenu: [5, 10, 25, 50],
            pageLength: 10,
            columnDefs: [
                { orderable: false, targets: [9] } // La columna de acciones no se ordena
            ]
        });
    });
</script>

</body>
</html>
