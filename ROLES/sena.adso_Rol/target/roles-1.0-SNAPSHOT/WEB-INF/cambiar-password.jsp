<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Cambiar Contraseña - Biblioteca Duitama</title>

    <!-- Estilos Bootstrap e íconos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    
    <style>
        .sidebar {
            min-height: 100vh;
            background: #2c3e50;
            color: white;
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,.8);
            padding: 1rem;
            margin: 0.2rem 0;
            border-radius: 0.5rem;
        }
        .sidebar .nav-link:hover {
            color: white;
            background: rgba(255,255,255,.1);
        }
        .sidebar .nav-link.active {
            background: #34495e;
            color: white;
        }
        .sidebar .nav-link i {
            margin-right: 0.5rem;
        }
        .main-content {
            background: #f8f9fa;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .password-toggle {
            cursor: pointer;
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        .form-floating {
            position: relative;
        }
        .form-floating > .form-control {
            padding-right: 40px;
        }
    </style>
</head>

<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0 sidebar">
                <div class="d-flex flex-column p-3">
                    <a href="${pageContext.request.contextPath}/lector/panel" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
                        <i class="bi bi-book fs-4 me-2"></i>
                        <span class="fs-4">Biblioteca</span>
                    </a>
                    <hr class="text-white">
                    <ul class="nav nav-pills flex-column mb-auto">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/lector/panel" class="nav-link text-white">
                                <i class="bi bi-speedometer2"></i>Panel Principal
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/lector/catalogo/listar" class="nav-link text-white">
                                <i class="bi bi-book"></i>Catálogo
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/lector/prestamos/historial" class="nav-link text-white">
                                <i class="bi bi-journal-text"></i>Mis Préstamos
                            </a>
                        </li>
                    </ul>
                    <hr class="text-white">
                    <div class="dropdown">
                        <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-person-circle fs-4 me-2"></i>
                            <strong>${sessionScope.usuario.nombre}</strong>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark text-small shadow" aria-labelledby="dropdownUser1">
                            <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/cambiar-password">
                                <i class="bi bi-key me-2"></i>Cambiar Contraseña
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right me-2"></i>Cerrar Sesión
                            </a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Contenido principal -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Cambiar Contraseña</h1>
                </div>

                <!-- Mensajes -->
                <c:if test="${not empty mensaje}">
                    <div class="alert alert-${tipo} alert-dismissible fade show" role="alert">
                        ${mensaje}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Formulario de cambio de contraseña -->
                <div class="row justify-content-center">
                    <div class="col-md-8 col-lg-6">
                        <div class="card">
                            <div class="card-body p-4">
                                <form action="${pageContext.request.contextPath}/cambiar-password" method="post" class="needs-validation" novalidate>
                                    <div class="mb-4">
                                        <div class="form-floating position-relative">
                                            <input type="password" class="form-control" id="passwordActual" name="passwordActual" 
                                                   required>
                                            <label for="passwordActual">Contraseña Actual</label>
                                            <i class="bi bi-eye password-toggle" onclick="togglePassword('passwordActual')"></i>
                                            <div class="invalid-feedback">
                                                Por favor ingrese su contraseña actual.
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <div class="form-floating position-relative">
                                            <input type="password" class="form-control" id="nuevaPassword" name="nuevaPassword" 
                                                   required minlength="8">
                                            <label for="nuevaPassword">Nueva Contraseña</label>
                                            <i class="bi bi-eye password-toggle" onclick="togglePassword('nuevaPassword')"></i>
                                            <div class="invalid-feedback">
                                                La contraseña debe tener al menos 8 caracteres.
                                            </div>
                                        </div>
                                        <div class="form-text">
                                            La contraseña debe tener al menos 8 caracteres.
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <div class="form-floating position-relative">
                                            <input type="password" class="form-control" id="confirmarPassword" name="confirmarPassword" 
                                                   required minlength="8">
                                            <label for="confirmarPassword">Confirmar Nueva Contraseña</label>
                                            <i class="bi bi-eye password-toggle" onclick="togglePassword('confirmarPassword')"></i>
                                            <div class="invalid-feedback">
                                                Las contraseñas no coinciden.
                                            </div>
                                        </div>
                                    </div>

                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary btn-lg">
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
            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const icon = input.nextElementSibling.nextElementSibling;
            
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
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }

                    // Validar que las contraseñas coincidan
                    const nuevaPassword = document.getElementById('nuevaPassword')
                    const confirmarPassword = document.getElementById('confirmarPassword')
                    
                    if (nuevaPassword.value !== confirmarPassword.value) {
                        confirmarPassword.setCustomValidity('Las contraseñas no coinciden')
                        event.preventDefault()
                        event.stopPropagation()
                    } else {
                        confirmarPassword.setCustomValidity('')
                    }

                    form.classList.add('was-validated')
                }, false)
            })
        })()
    </script>
</body>
</html> 