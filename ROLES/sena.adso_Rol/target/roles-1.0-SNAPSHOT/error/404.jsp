<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es" class="h-100">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>404 - Página no encontrada</title>

    <!-- Estilos Bootstrap e íconos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    
    <style>
        body {
            background-color: #f8f9fa;
        }
        .auth-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-container {
            text-align: center;
            padding: 2rem;
        }
        .error-code {
            font-size: 6rem;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 1rem;
        }
        .error-message {
            font-size: 1.5rem;
            color: #34495e;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="container">
            <div class="error-container">
                <h1 class="error-code">404</h1>
                <p class="error-message">¡Ups! La página que buscas no existe.</p>
                <p class="text-muted mb-4">Parece que te has aventurado en territorio desconocido.</p>
                <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary">
                    <i class="bi bi-house-door me-2"></i>Volver al inicio
                </a>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 