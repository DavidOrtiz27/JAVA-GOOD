<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Registro - Biblioteca Duitama</title>

    <!-- Estilos Bootstrap e íconos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    
    <style>
        body {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }
        
        .register-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            width: 100%;
            max-width: 900px;
            min-height: 600px;
            display: flex;
        }
        
        .register-image {
            background: url('https://images.unsplash.com/photo-1507842217343-583bb7270b66?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80') center/cover;
            flex: 1;
            display: none;
        }
        
        .register-form {
            flex: 1;
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .register-header h1 {
            color: #2c3e50;
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .register-header p {
            color: #7f8c8d;
            font-size: 1rem;
        }
        
        .form-floating {
            margin-bottom: 1.5rem;
        }
        
        .form-floating > .form-control {
            padding: 1rem 0.75rem;
            height: calc(3.5rem + 2px);
            line-height: 1.25;
        }
        
        .form-floating > label {
            padding: 1rem 0.75rem;
        }
        
        .btn-register {
            background: #3498db;
            border: none;
            padding: 0.8rem;
            font-size: 1.1rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-register:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
        
        .register-footer {
            text-align: center;
            margin-top: 2rem;
        }
        
        .register-footer a {
            color: #3498db;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        
        .register-footer a:hover {
            color: #2980b9;
        }
        
        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #7f8c8d;
            z-index: 10;
        }
        
        .alert {
            border-radius: 10px;
            margin-bottom: 1.5rem;
        }
        
        .form-select {
            height: calc(3.5rem + 2px);
            padding: 1rem 0.75rem;
        }
        
        @media (min-width: 768px) {
            .register-image {
                display: block;
            }
        }
    </style>
</head>

<body>
    <div class="register-container">
        <div class="register-image"></div>
        <div class="register-form">
            <div class="register-header">
                <h1>Crear Cuenta</h1>
                <p>Únete a nuestra biblioteca digital</p>
            </div>

            <!-- Mensajes -->
            <c:if test="${not empty mensaje}">
                <div class="alert alert-${tipoMensaje} alert-dismissible fade show" role="alert">
                    ${mensaje}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth/registro" method="post" class="needs-validation" novalidate>
                <div class="form-floating">
                    <input type="text" class="form-control" id="nombre" name="nombre" 
                           placeholder="Nombre completo" required>
                    <label for="nombre">Nombre Completo</label>
                    <div class="invalid-feedback">
                        Por favor ingrese su nombre completo.
                    </div>
                </div>

                <div class="form-floating">
                    <input type="email" class="form-control" id="email" name="email" 
                           placeholder="nombre@ejemplo.com" required>
                    <label for="email">Correo Electrónico</label>
                    <div class="invalid-feedback">
                        Por favor ingrese un correo electrónico válido.
                    </div>
                </div>

                <div class="form-floating">
                    <select class="form-select" id="rol" name="rol" required>
                        <option value="">Seleccione un rol</option>
                        <option value="LECTOR">Lector</option>
                        <option value="BIBLIOTECARIO">Bibliotecario</option>
                    </select>
                    <label for="rol">Rol</label>
                    <div class="invalid-feedback">
                        Por favor seleccione un rol.
                    </div>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary btn-register">
                        <i class="bi bi-person-plus me-2"></i>Crear Cuenta
                    </button>
                </div>
            </form>

            <div class="register-footer">
                <p>¿Ya tienes una cuenta? <a href="${pageContext.request.contextPath}/auth/login">Inicia sesión aquí</a></p>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validación del formulario
        (function () {
            'use strict'
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
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
