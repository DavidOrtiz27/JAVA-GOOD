<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="es" class="h-100">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Recuperar Contraseña - Biblioteca Duitama</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <!-- Estilos personalizados -->
    <link rel="stylesheet" href="css/style.css">
</head>

<body class="d-flex flex-column h-100 bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="../../index.jsp">
            <i class="bi bi-journal-bookmark-fill"></i> Biblioteca Duitama
        </a>
    </div>
</nav>

<main class="flex-shrink-0 d-flex align-items-center justify-content-center" style="min-height: 90vh;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-lg border-0 rounded">
                    <div class="card-body p-4">
                        <h3 class="text-center mb-4 fw-bold">Recuperar Contraseña</h3>

                        <!-- Mensajes de error/éxito -->
                        <c:if test="${not empty mensaje}">
                            <div class="alert alert-${tipo} alert-dismissible fade show" role="alert">
                                ${mensaje}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" 
                                        aria-label="Close"></button>
                            </div>
                        </c:if>

                        <p class="text-muted text-center mb-4">
                            Ingresa tu correo electrónico para recuperar tu contraseña
                        </p>

                        <form action="${pageContext.request.contextPath}/WEB-INF/auth/recuperar-password.jsp" method="post">
                            <div class="mb-4">
                                <label for="email" class="form-label">Correo electrónico</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-envelope-fill"></i>
                                    </span>
                                    <input type="email" id="email" name="email"
                                           class="form-control"
                                           placeholder="Ingresa tu correo"
                                           required>
                                </div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-send-fill me-1"></i> Enviar Instrucciones
                                </button>
                                <a href="${pageContext.request.contextPath}/public/login"
                                   class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i> Volver al Login
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="footer mt-auto py-3 bg-dark">
    <div class="container text-center text-white">
        <p class="mb-0">© 2025 Municipalidad de Duitama - Biblioteca Municipal</p>
    </div>
</footer>

</body>
</html>