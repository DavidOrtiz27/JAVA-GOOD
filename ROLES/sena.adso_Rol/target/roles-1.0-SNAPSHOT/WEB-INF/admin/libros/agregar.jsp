<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <title>Registrar Libro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="container mt-4">
    <h2>Registrar Nuevo Libro</h2>

    <!-- Mensajes -->
    <c:if test="${not empty mensaje}">
        <div class="alert alert-${tipo}">${mensaje}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/bibliotecario/libros/listar" method="post" id="formLibro">
        <div class="mb-3">
            <label for="titulo" class="form-label">Título:</label>
            <input type="text" class="form-control" id="titulo" name="titulo" required />
        </div>

        <div class="mb-3">
            <label for="isbn" class="form-label">ISBN:</label>
            <input type="text" class="form-control" id="isbn" name="isbn" required />
        </div>

        <div class="mb-3">
            <label for="autor" class="form-label">Autor:</label>
            <input type="text" class="form-control" id="autor" name="autor" required />
        </div>

        <div class="mb-3">
            <label for="ejemplares" class="form-label">Número de Ejemplares:</label>
            <input type="number" min="1" class="form-control" id="ejemplares" name="ejemplares" required />
        </div>

        <div class="mb-3">
            <label for="tipo" class="form-label">Tipo de Libro:</label>
            <select id="tipo" name="tipo" class="form-select" required>
                <option value="" selected disabled>Seleccione tipo</option>
                <option value="Ficcion">Ficción</option>
                <option value="NoFiccion">No Ficción</option>
                <option value="Referencia">Referencia</option>
            </select>
        </div>

        <!-- Campos específicos por tipo -->
        <div id="campos-ficcion" class="d-none">
            <div class="mb-3">
                <label for="genero" class="form-label">Género:</label>
                <input type="text" class="form-control" id="genero" name="genero" />
            </div>
            <div class="mb-3">
                <label for="premios_literarios" class="form-label">Premios Literarios:</label>
                <input type="text" class="form-control" id="premios_literarios" name="premios_literarios" />
            </div>
        </div>

        <div id="campos-no-ficcion" class="d-none">
            <div class="mb-3">
                <label for="area_tematica" class="form-label">Área Temática:</label>
                <input type="text" class="form-control" id="area_tematica" name="area_tematica" />
            </div>
            <div class="mb-3">
                <label for="publico_objetivo" class="form-label">Público Objetivo:</label>
                <input type="text" class="form-control" id="publico_objetivo" name="publico_objetivo" />
            </div>
        </div>

        <div id="campos-referencia" class="d-none">
            <div class="mb-3">
                <label for="campo_academico" class="form-label">Campo Académico:</label>
                <input type="text" class="form-control" id="campo_academico" name="campo_academico" />
            </div>
            <div class="form-check mb-3">
                <input type="checkbox" class="form-check-input" id="consulta_interna" name="consulta_interna" value="true" />
                <label class="form-check-label" for="consulta_interna">Solo consulta interna (no préstamo)</label>
            </div>
        </div>

        <button type="submit" class="btn btn-primary">Registrar</button>
        <a href="${pageContext.request.contextPath}/admin/libros/listar" class="btn btn-secondary">Cancelar</a>
    </form>
</div>

<script>
    $(document).ready(function () {
        function ocultarTodos() {
            $('#campos-ficcion').addClass('d-none');
            $('#campos-no-ficcion').addClass('d-none');
            $('#campos-referencia').addClass('d-none');

            // Limpiar campos específicos cuando se ocultan
            $('#campos-ficcion input').val('');
            $('#campos-no-ficcion input').val('');
            $('#campos-referencia input[type="text"]').val('');
            $('#consulta_interna').prop('checked', false);
        }

        $('#tipo').change(function () {
            ocultarTodos();

            let tipo = $(this).val();
            if (tipo === 'Ficcion') {
                $('#campos-ficcion').removeClass('d-none');
            } else if (tipo === 'NoFiccion') {
                $('#campos-no-ficcion').removeClass('d-none');
            } else if (tipo === 'Referencia') {
                $('#campos-referencia').removeClass('d-none');
            }
        });

        // Al cargar la página (por si se mantiene selección)
        if ($('#tipo').val()) {
            $('#tipo').trigger('change');
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>