<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="es" class="h-100">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cambiar Contraseña - Biblioteca Duitama</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <!-- Estilos personalizados -->
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        .password-strength {
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }
        .password-requirements {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 0.5rem;
        }
        .requirement-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.25rem;
        }
        .requirement-item i {
            font-size: 0.75rem;
        }
        .requirement-met {
            color: #198754;
        }
        .requirement-pending {
            color: #6c757d;
        }
    </style>
</head>

<body class="d-flex flex-column h-100 bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">
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
                        <h3 class="text-center mb-4 fw-bold">
                            <c:choose>
                                <c:when test="${passwordTemporal}">
                                    Cambio Obligatorio de Contraseña
                                </c:when>
                                <c:otherwise>
                                    Cambiar Contraseña
                                </c:otherwise>
                            </c:choose>
                        </h3>

                        <!-- Mensajes de error/éxito -->
                        <c:if test="${not empty mensaje}">
                            <div class="alert alert-${tipo} alert-dismissible fade show" role="alert">
                                ${mensaje}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" 
                                        aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Alerta de contraseña temporal -->
                        <c:if test="${passwordTemporal}">
                            <div class="alert alert-warning" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                Por seguridad, debe cambiar su contraseña temporal por una nueva.
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/cambiar-password" method="post" id="passwordForm">
                            <!-- Usuario -->
                            <div class="mb-3">
                                <label for="username" class="form-label">Usuario</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-person-fill"></i>
                                    </span>
                                    <input type="text" class="form-control" id="username" name="username"
                                           value="${username}" readonly>
                                </div>
                            </div>

                            <!-- Contraseña Actual (si no es temporal) -->
                            <c:if test="${!passwordTemporal}">
                                <div class="mb-3">
                                    <label for="passwordActual" class="form-label">Contraseña Actual</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-white">
                                            <i class="bi bi-lock-fill"></i>
                                        </span>
                                        <input type="password" class="form-control" id="passwordActual" 
                                               name="passwordActual" required>
                                        <button class="btn btn-outline-secondary" type="button" 
                                                onclick="togglePassword('passwordActual')">
                                            <i class="bi bi-eye-fill"></i>
                                        </button>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Nueva Contraseña -->
                            <div class="mb-3">
                                <label for="passwordNuevo" class="form-label">Nueva Contraseña</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-key-fill"></i>
                                    </span>
                                    <input type="password" class="form-control" id="passwordNuevo" 
                                           name="passwordNuevo" required
                                           pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$">
                                    <button class="btn btn-outline-secondary" type="button" 
                                            onclick="togglePassword('passwordNuevo')">
                                        <i class="bi bi-eye-fill"></i>
                                    </button>
                                </div>
                                <div class="password-requirements mt-2">
                                    <div class="requirement-item">
                                        <i class="bi bi-circle-fill" id="length-check"></i>
                                        Mínimo 6 caracteres
                                    </div>
                                    <div class="requirement-item">
                                        <i class="bi bi-circle-fill" id="letter-check"></i>
                                        Al menos una letra
                                    </div>
                                    <div class="requirement-item">
                                        <i class="bi bi-circle-fill" id="number-check"></i>
                                        Al menos un número
                                    </div>
                                </div>
                            </div>

                            <!-- Confirmar Nueva Contraseña -->
                            <div class="mb-4">
                                <label for="passwordConfirmar" class="form-label">Confirmar Nueva Contraseña</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-key-fill"></i>
                                    </span>
                                    <input type="password" class="form-control" id="passwordConfirmar" 
                                           name="passwordConfirmar" required>
                                    <button class="btn btn-outline-secondary" type="button" 
                                            onclick="togglePassword('passwordConfirmar')">
                                        <i class="bi bi-eye-fill"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle-fill me-1"></i>
                                    Cambiar Contraseña
                                </button>
                                
                                <c:if test="${!passwordTemporal}">
                                    <a href="${pageContext.request.contextPath}/login" 
                                       class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-left me-1"></i>
                                        Cancelar
                                    </a>
                                </c:if>
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

<!-- Script para la validación de contraseña -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const passwordNuevo = document.getElementById('passwordNuevo');
    const passwordConfirmar = document.getElementById('passwordConfirmar');
    const form = document.getElementById('passwordForm');
    
    // Función para actualizar los indicadores de requisitos
    function updateRequirements(password) {
        const lengthCheck = document.getElementById('length-check');
        const letterCheck = document.getElementById('letter-check');
        const numberCheck = document.getElementById('number-check');
        
        // Verificar longitud
        if(password.length >= 6) {
            lengthCheck.classList.remove('text-muted');
            lengthCheck.classList.add('text-success');
        } else {
            lengthCheck.classList.remove('text-success');
            lengthCheck.classList.add('text-muted');
        }
        
        // Verificar letra
        if(/[A-Za-z]/.test(password)) {
            letterCheck.classList.remove('text-muted');
            letterCheck.classList.add('text-success');
        } else {
            letterCheck.classList.remove('text-success');
            letterCheck.classList.add('text-muted');
        }
        
        // Verificar número
        if(/\d/.test(password)) {
            numberCheck.classList.remove('text-muted');
            numberCheck.classList.add('text-success');
        } else {
            numberCheck.classList.remove('text-success');
            numberCheck.classList.add('text-muted');
        }
    }
    
    // Evento para verificar la contraseña mientras se escribe
    passwordNuevo.addEventListener('input', function() {
        updateRequirements(this.value);
    });
    
    // Validación del formulario
    form.addEventListener('submit', function(e) {
        if(passwordNuevo.value !== passwordConfirmar.value) {
            e.preventDefault();
            alert('Las contraseñas no coinciden');
        }
    });
});

// Función para mostrar/ocultar contraseña
function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    const icon = input.nextElementSibling.querySelector('i');
    
    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.remove('bi-eye-fill');
        icon.classList.add('bi-eye-slash-fill');
    } else {
        input.type = 'password';
        icon.classList.remove('bi-eye-slash-fill');
        icon.classList.add('bi-eye-fill');
    }
}
</script>

</body>
</html>