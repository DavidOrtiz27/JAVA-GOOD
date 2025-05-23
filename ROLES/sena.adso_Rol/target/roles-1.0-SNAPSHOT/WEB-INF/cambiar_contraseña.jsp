<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cambiar Contraseña - Biblioteca SENA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        
        .password-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
            max-width: 500px;
            width: 90%;
            margin: auto;
        }
        
        .password-header {
            background: #0d6efd;
            color: white;
            padding: 2rem;
            text-align: center;
        }
        
        .password-form {
            padding: 2rem;
        }
        
        .password-requirements {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="password-container">
            <div class="password-header">
                <i class="fas fa-key fa-3x mb-3"></i>
                <h2>Cambiar Contraseña</h2>
                <p class="mb-0">Usuario: ${nombre}</p>
            </div>
            
            <div class="password-form">
                <c:if test="${not empty mensaje}">
                    <div class="alert alert-${tipo} alert-dismissible fade show" role="alert">
                        <i class="fas fa-info-circle me-2"></i>${mensaje}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/cambiar-password" 
                      method="post" class="needs-validation" novalidate>
                    
                    <div class="form-floating mb-3">
                        <input type="password" class="form-control" id="passwordActual" 
                               name="passwordActual" placeholder="Contraseña actual" required>
                        <label for="passwordActual">Contraseña actual</label>
                    </div>
                    
                    <div class="form-floating mb-3">
                        <input type="password" class="form-control" id="passwordNuevo" 
                               name="passwordNuevo" placeholder="Nueva contraseña" required>
                        <label for="passwordNuevo">Nueva contraseña</label>
                        <div class="password-requirements">
                            La contraseña debe tener al menos 8 caracteres
                        </div>
                    </div>
                    
                    <div class="form-floating mb-4">
                        <input type="password" class="form-control" id="passwordConfirmar" 
                               name="passwordConfirmar" placeholder="Confirmar contraseña" required>
                        <label for="passwordConfirmar">Confirmar nueva contraseña</label>
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Guardar cambios
                        </button>
                        <a href="${pageContext.request.contextPath}/dashboard" 
                           class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Volver
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validación del formulario
        (function() {
            'use strict'
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms)
                .forEach(function(form) {
                    form.addEventListener('submit', function(event) {
                        if (!form.checkValidity()) {
                            event.preventDefault()
                            event.stopPropagation()
                        }
                        form.classList.add('was-validated')
                    }, false)
                })
        })()
    </script>
</body>
</html>