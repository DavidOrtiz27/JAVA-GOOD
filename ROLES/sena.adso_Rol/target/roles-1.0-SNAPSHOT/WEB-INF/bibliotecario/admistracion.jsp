<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Administración de Biblioteca</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="#">Sistema de Biblioteca</a>
        <div class="ms-auto">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-light">Cerrar Sesión</a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h2 class="text-center mb-4">Panel de Administración</h2>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-body text-center">
                    <i class="bi bi-book display-4 text-primary mb-2"></i>
                    <h5 class="card-title">Gestión de Libros</h5>
                    <p class="card-text">Agregar, editar y administrar el catálogo de libros.</p>
                    <a href="${pageContext.request.contextPath}/bibliotecario/libros/agregar" class="btn btn-primary">Agregar
                        Libro</a>
                    <a href="${pageContext.request.contextPath}/bibliotecario/libros/listar"
                       class="btn btn-outline-primary mt-2">Ver Catálogo</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-body text-center">
                    <i class="bi bi-people display-4 text-primary mb-2"></i>
                    <h5 class="card-title">Gestión de Préstamos</h5>
                    <p class="card-text">Administrar préstamos y devoluciones de libros.</p>
                    <a href="${pageContext.request.contextPath}/bibliotecario/prestamos/nuevo" class="btn btn-primary">Nuevo
                        Préstamo</a>
                    <a href="${pageContext.request.contextPath}/bibliotecario/prestamos/listar"
                       class="btn btn-outline-primary mt-2">Ver Préstamos</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-body text-center">
                    <i class="bi bi-person-badge display-4 text-primary mb-2"></i>
                    <h5 class="card-title">Gestión de Usuarios</h5>
                    <p class="card-text">Administrar usuarios y sus permisos.</p>
                    <a href="${pageContext.request.contextPath}/bibliotecario/usuarios/registro"
                       class="btn btn-primary">Registrar Usuario</a>
                    <a href="${pageContext.request.contextPath}/bibliotecario/usuarios/listar"
                       class="btn btn-outline-primary mt-2">Ver Usuarios</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>