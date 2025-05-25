<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Nuevo Libro - Biblioteca Duitama</title>

    <!-- Estilos Bootstrap e íconos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet"/>
    
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
        }
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>

<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0 sidebar">
                <div class="d-flex flex-column p-3">
                    <a href="${pageContext.request.contextPath}/admin/panel" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
                        <i class="bi bi-book fs-4 me-2"></i>
                        <span class="fs-4">Biblioteca</span>
                    </a>
                    <hr class="text-white">
                    <ul class="nav nav-pills flex-column mb-auto">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/panel" class="nav-link text-white">
                                <i class="bi bi-speedometer2"></i>Panel Principal
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/libros/listar" class="nav-link active">
                                <i class="bi bi-book"></i>Libros
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/prestamos/listar" class="nav-link text-white">
                                <i class="bi bi-journal-text"></i>Préstamos
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/usuarios/listar" class="nav-link text-white">
                                <i class="bi bi-people"></i>Usuarios
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
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/cambiar-password">
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
                    <h1 class="h2">Nuevo Libro</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/libros/listar" class="btn btn-secondary">
                            <i class="bi bi-arrow-left me-2"></i>Volver
                        </a>
                    </div>
                </div>

                <!-- Mensajes -->
                <c:if test="${not empty sessionScope.mensaje}">
                    <div class="alert alert-${sessionScope.tipo} alert-dismissible fade show" role="alert">
                        ${sessionScope.mensaje}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="mensaje" scope="session"/>
                    <c:remove var="tipo" scope="session"/>
                </c:if>

                <!-- Formulario de nuevo libro -->
                <div class="card">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/libros" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="accion" value="crear"/>
                            <!-- Campos básicos -->
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="titulo" class="form-label">Título *</label>
                                    <input type="text" class="form-control" id="titulo" name="titulo" required>
                                    <div class="invalid-feedback">
                                        Por favor ingrese el título del libro
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="autor" class="form-label">Autor *</label>
                                    <input type="text" class="form-control" id="autor" name="autor" required>
                                    <div class="invalid-feedback">
                                        Por favor ingrese el autor del libro
                                    </div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="isbn" class="form-label">ISBN *</label>
                                    <input type="text" class="form-control" id="isbn" name="isbn" required>
                                    <div class="invalid-feedback">
                                        Por favor ingrese el ISBN del libro
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label for="tipo" class="form-label">Tipo de Libro *</label>
                                    <select class="form-select" id="tipo" name="tipo" required onchange="mostrarCamposEspecificos()">
                                        <option value="">Seleccione un tipo</option>
                                        <option value="Ficcion">Ficción</option>
                                        <option value="NoFiccion">No Ficción</option>
                                        <option value="Referencia">Referencia</option>
                                    </select>
                                    <div class="invalid-feedback">
                                        Por favor seleccione un tipo de libro
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label for="ejemplaresDisponibles" class="form-label">Ejemplares Disponibles *</label>
                                    <input type="number" class="form-control" id="ejemplaresDisponibles" name="ejemplaresDisponibles" 
                                           min="1" required>
                                    <div class="invalid-feedback">
                                        Por favor ingrese el número de ejemplares disponibles
                                    </div>
                                </div>
                            </div>

                            <!-- Campos específicos para Ficción -->
                            <div id="camposFiccion" style="display: none;">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="genero" class="form-label">Género *</label>
                                        <input type="text" class="form-control" id="genero" name="genero">
                                        <div class="invalid-feedback">
                                            Por favor ingrese el género del libro
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="premiosLiterarios" class="form-label">Premios Literarios</label>
                                        <input type="text" class="form-control" id="premiosLiterarios" name="premiosLiterarios">
                                    </div>
                                </div>
                            </div>

                            <!-- Campos específicos para No Ficción -->
                            <div id="camposNoFiccion" style="display: none;">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="areaTematica" class="form-label">Área Temática *</label>
                                        <input type="text" class="form-control" id="areaTematica" name="areaTematica">
                                        <div class="invalid-feedback">
                                            Por favor ingrese el área temática
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="publicoObjetivo" class="form-label">Público Objetivo *</label>
                                        <input type="text" class="form-control" id="publicoObjetivo" name="publicoObjetivo">
                                        <div class="invalid-feedback">
                                            Por favor ingrese el público objetivo
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Campos específicos para Referencia -->
                            <div id="camposReferencia" style="display: none;">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="campoAcademico" class="form-label">Campo Académico *</label>
                                        <input type="text" class="form-control" id="campoAcademico" name="campoAcademico">
                                        <div class="invalid-feedback">
                                            Por favor ingrese el campo académico
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-check mt-4">
                                            <input class="form-check-input" type="checkbox" id="consultaInterna" name="consultaInterna">
                                            <label class="form-check-label" for="consultaInterna">
                                                Consulta Interna
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/admin/libros/listar" class="btn btn-secondary">
                                    Cancelar
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-plus-circle me-2"></i>Crear Libro
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Función para mostrar/ocultar campos específicos según el tipo de libro
        function mostrarCamposEspecificos() {
            const tipo = document.getElementById('tipo').value;
            
            // Ocultar todos los campos específicos
            document.getElementById('camposFiccion').style.display = 'none';
            document.getElementById('camposNoFiccion').style.display = 'none';
            document.getElementById('camposReferencia').style.display = 'none';
            
            // Mostrar los campos correspondientes al tipo seleccionado
            if (tipo === 'Ficcion') {
                document.getElementById('camposFiccion').style.display = 'block';
            } else if (tipo === 'NoFiccion') {
                document.getElementById('camposNoFiccion').style.display = 'block';
            } else if (tipo === 'Referencia') {
                document.getElementById('camposReferencia').style.display = 'block';
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
                    form.classList.add('was-validated')
                }, false)
            })
        })()
    </script>
</body>
</html>