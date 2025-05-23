<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - Biblioteca Duitama</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <style>
        body {
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        .login-container {
            max-width: 400px;
            width: 100%;
            padding: 2rem;
            background-color: white;
            border-radius: 0.5rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
        }

        .logo {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-floating {
            margin-bottom: 1rem;
        }

        .alert {
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="logo">
        <i class="bi bi-journal-bookmark-fill" style="font-size: 3rem; color: #0d6efd;"></i>
        <h2 class="mt-2">Biblioteca Duitama</h2>
    </div>

    <!-- Mostrar mensajes de error o advertencia -->
    <c:if test="${not empty mensaje}">
        <div class="alert alert-${tipo} alert-dismissible fade show" role="alert">
            ${mensaje}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/auth/login" method="post">
        <div class="form-floating">
            <input type="email" class="form-control" id="email" name="email"
                   placeholder="Correo electrónico" value="${email}" required>
            <label for="email">Correo electrónico</label>
        </div>

        <div class="form-floating">
            <input type="password" class="form-control" id="password" name="password"
                   placeholder="Contraseña" required>
            <label for="password">Contraseña</label>
        </div>

        <div class="d-grid gap-2">
            <button type="submit" class="btn btn-primary btn-lg">
                <i class="bi bi-box-arrow-in-right"></i> Iniciar Sesión
            </button>
        </div>

        <div class="mt-3 text-center">
            <a href="${pageContext.request.contextPath}/auth/password" class="text-decoration-none">
                ¿Olvidaste tu contraseña?
            </a>
        </div>

        <hr class="my-4">

        <div class="text-center">
            <p class="text-muted">¿No tienes una cuenta?</p>
            <a href="${pageContext.request.contextPath}/auth/registro" class="btn btn-outline-primary">
                <i class="bi bi-person-plus"></i> Regístrate
            </a>
        </div>
    </form>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
