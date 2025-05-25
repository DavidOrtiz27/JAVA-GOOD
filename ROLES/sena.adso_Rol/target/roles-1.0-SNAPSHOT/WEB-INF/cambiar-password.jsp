<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es" class="h-100">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Cambiar Contraseña - Biblioteca Duitama</title>

    <!-- Estilos Bootstrap e íconos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/WEB-INF/css/styles.css" rel="stylesheet"/>
</head>

<body>
    <div class="auth-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-6 col-lg-5">
                    <div class="card">
                        <div class="card-header text-center">
                            <h4 class="mb-0">
                                <i class="bi bi-key me-2"></i>Cambiar Contraseña
                            </h4>
                        </div>
                        <div class="card-body p-4">
                            <c:if test="${not empty mensaje}">
                                <div class="alert alert-${tipoMensaje} alert-dismissible fade show" role="alert">
                                    ${mensaje}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/cambiar-password" method="post" class="needs-validation" novalidate>
                                <div class="mb-3 position-relative">
                                    <label for="passwordActual" class="form-label">Contraseña Actual</label>
                                    <input type="password" class="form-control" id="passwordActual" name="passwordActual" required>
                                    <i class="bi bi-eye password-toggle" onclick="togglePassword('passwordActual')"></i>
                                    <div class="invalid-feedback">
                                        Por favor ingrese su contraseña actual.
                                    </div>
                                </div>

                                <div class="mb-3 position-relative">
                                    <label for="nuevaPassword" class="form-label">Nueva Contraseña</label>
                                    <input type="password" class="form-control" id="nuevaPassword" name="nuevaPassword" 
                                           pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$" required>
                                    <i class="bi bi-eye password-toggle" onclick="togglePassword('nuevaPassword')"></i>
                                    <div class="invalid-feedback">
                                        La contraseña debe tener al menos 8 caracteres, una letra y un número.
                                    </div>
                                </div>

                                <div class="mb-4 position-relative">
                                    <label for="confirmarPassword" class="form-label">Confirmar Nueva Contraseña</label>
                                    <input type="password" class="form-control" id="confirmarPassword" name="confirmarPassword" required>
                                    <i class="bi bi-eye password-toggle" onclick="togglePassword('confirmarPassword')"></i>
                                    <div class="invalid-feedback">
                                        Las contraseñas no coinciden.
                                    </div>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-check-circle me-2"></i>Cambiar Contraseña
                                    </button>
                                    <a href="${pageContext.request.contextPath}/lector/panel" class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-left me-2"></i>Volver al Panel
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Función para mostrar/ocultar contraseña
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const icon = input.nextElementSibling;
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('bi-eye');
                icon.classList.add('bi-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('bi-eye-slash');
                icon.classList.add('bi-eye');
            }
        }

        // Validación del formulario
        (function () {
            'use strict'
            const forms = document.querySelectorAll('.needs-validation');
            
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }

                    // Validar que las contraseñas coincidan
                    const nuevaPassword = document.getElementById('nuevaPassword');
                    const confirmarPassword = document.getElementById('confirmarPassword');
                    
                    if (nuevaPassword.value !== confirmarPassword.value) {
                        confirmarPassword.setCustomValidity('Las contraseñas no coinciden');
                        event.preventDefault();
                        event.stopPropagation();
                    } else {
                        confirmarPassword.setCustomValidity('');
                    }

                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html> 