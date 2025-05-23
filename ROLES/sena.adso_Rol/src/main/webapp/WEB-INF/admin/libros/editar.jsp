<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="sena.adso.roles.modelo.Libro"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Libro</title>
    <link href="/biblioteca/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container mt-5">
    <h2>Editar Libro</h2>

    <form action="${pageContext.request.contextPath}/bibliotecario/libros/actualizar" method="post">
        <input type="hidden" name="id" value="${libro.id}" />

        <div class="mb-3">
            <label for="titulo" class="form-label">Título:</label>
            <input type="text" class="form-control" id="titulo" name="titulo" value="${libro.titulo}" required />
        </div>

        <div class="mb-3">
            <label for="isbn" class="form-label">ISBN:</label>
            <input type="text" class="form-control" id="isbn" name="isbn" value="${libro.isbn}" required />
        </div>

        <div class="mb-3">
            <label for="autor" class="form-label">Autor:</label>
            <input type="text" class="form-control" id="autor" name="autor" value="${libro.autor}" required />
        </div>

        <div class="mb-3">
            <label for="ejemplaresDisponibles" class="form-label">Ejemplares disponibles:</label>
            <input type="number" class="form-control" id="ejemplaresDisponibles" name="ejemplaresDisponibles" value="${libro.ejemplaresDisponibles}" required />
        </div>

        <div class="mb-3">
            <label for="tipo" class="form-label">Tipo:</label>
            <input type="text" class="form-control" id="tipo" name="tipo" value="${libro.tipo}" readonly />
        </div>

        <button type="submit" class="btn btn-primary">Guardar cambios</button>
        <a href="${pageContext.request.contextPath}/bibliotecario/libros/listar" class="btn btn-secondary">Cancelar</a>
    </form>
</div>
</body>
</html>
