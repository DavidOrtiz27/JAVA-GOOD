<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Editar Libro - Biblioteca Duitama</title>

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
                            <a href="${pageContext.request.contextPath}/admin/prestamos" class="nav-link text-white">
                                <i class="bi bi-journal-text"></i>Préstamos
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/usuarios" class="nav-link text-white">
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
                    <h1 class="h2">Editar Libro</h1>
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

                <!-- Formulario -->
                <div class="card">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/libros" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="accion" value="actualizar">
                            <input type="hidden" name="id" value="${libro.id}">
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="titulo" class="form-label">Título *</label>
                                    <input type="text" class="form-control" id="titulo" name="titulo" 
                                           value="${libro.titulo}" required>
                                    <div class="invalid-feedback">
                                        Por favor ingrese el título del libro
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="autor" class="form-label">Autor *</label>
                                    <input type="text" class="form-control" id="autor" name="autor" 
                                           value="${libro.autor}" required>
                                    <div class="invalid-feedback">
                                        Por favor ingrese el autor del libro
                                    </div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="isbn" class="form-label">ISBN *</label>
                                    <input type="text" class="form-control" id="isbn" name="isbn" 
                                           value="${libro.isbn}" required>
                                    <div class="invalid-feedback">
                                        Por favor ingrese el ISBN del libro
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label for="tipo" class="form-label">Tipo de Libro *</label>
                                    <select class="form-select" id="tipo" name="tipo" required onchange="mostrarCamposEspecificos()">
                                        <option value="">Seleccione un tipo</option>
                                        <option value="Ficcion" ${libro.tipoLibro == 'Ficcion' ? 'selected' : ''}>Ficción</option>
                                        <option value="NoFiccion" ${libro.tipoLibro == 'NoFiccion' ? 'selected' : ''}>No Ficción</option>
                                        <option value="Referencia" ${libro.tipoLibro == 'Referencia' ? 'selected' : ''}>Referencia</option>
                                    </select>
                                    <div class="invalid-feedback">
                                        Por favor seleccione un tipo de libro
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label for="ejemplaresDisponibles" class="form-label">Ejemplares Disponibles *</label>
                                    <input type="number" class="form-control" id="ejemplaresDisponibles" name="ejemplaresDisponibles" 
                                           value="${libro.ejemplaresDisponibles}" min="1" required>
                                    <div class="invalid-feedback">
                                        Por favor ingrese el número de ejemplares disponibles
                                    </div>
                                </div>
                            </div>

                            <!-- Campos específicos para Ficción -->
                            <div id="camposFiccion" style="display: ${libro.tipoLibro == 'Ficcion' ? 'block' : 'none'};">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="genero" class="form-label">Género *</label>
                                        <input type="text" class="form-control" id="genero" name="genero" 
                                               value="${libro.tipoLibro == 'Ficcion' ? libro.genero : ''}" 
                                               ${libro.tipoLibro == 'Ficcion' ? 'required' : ''}>
                                        <div class="invalid-feedback">
                                            Por favor ingrese el género del libro
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="premiosLiterarios" class="form-label">Premios Literarios</label>
                                        <input type="text" class="form-control" id="premiosLiterarios" name="premiosLiterarios" 
                                               value="${libro.tipoLibro == 'Ficcion' ? libro.premiosLiterarios : ''}">
                                    </div>
                                </div>
                            </div>

                            <!-- Campos específicos para No Ficción -->
                            <div id="camposNoFiccion" style="display: ${libro.tipoLibro == 'NoFiccion' ? 'block' : 'none'};">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="areaTematica" class="form-label">Área Temática *</label>
                                        <input type="text" class="form-control" id="areaTematica" name="areaTematica" 
                                               value="${libro.tipoLibro == 'NoFiccion' ? libro.areaTematica : ''}" 
                                               ${libro.tipoLibro == 'NoFiccion' ? 'required' : ''}>
                                        <div class="invalid-feedback">
                                            Por favor ingrese el área temática
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="publicoObjetivo" class="form-label">Público Objetivo *</label>
                                        <input type="text" class="form-control" id="publicoObjetivo" name="publicoObjetivo" 
                                               value="${libro.tipoLibro == 'NoFiccion' ? libro.publicoObjetivo : ''}" 
                                               ${libro.tipoLibro == 'NoFiccion' ? 'required' : ''}>
                                        <div class="invalid-feedback">
                                            Por favor ingrese el público objetivo
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Campos específicos para Referencia -->
                            <div id="camposReferencia" style="display: ${libro.tipoLibro == 'Referencia' ? 'block' : 'none'};">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="campoAcademico" class="form-label">Campo Académico *</label>
                                        <input type="text" class="form-control" id="campoAcademico" name="campoAcademico" 
                                               value="${libro.tipoLibro == 'Referencia' ? libro.campoAcademico : ''}" 
                                               ${libro.tipoLibro == 'Referencia' ? 'required' : ''}>
                                        <div class="invalid-feedback">
                                            Por favor ingrese el campo académico
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-check mt-4">
                                            <input class="form-check-input" type="checkbox" id="consultaInterna" name="consultaInterna"
                                                   ${libro.tipoLibro == 'Referencia' && libro.consultaInterna ? 'checked' : ''}>
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
                                    <i class="bi bi-save me-2"></i>Guardar Cambios
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
            console.log('Tipo de libro seleccionado:', tipo);
            
            // Ocultar todos los campos específicos
            document.getElementById('camposFiccion').style.display = 'none';
            document.getElementById('camposNoFiccion').style.display = 'none';
            document.getElementById('camposReferencia').style.display = 'none';
            
            // Desactivar todos los campos específicos primero
            document.getElementById('genero').required = false;
            document.getElementById('premiosLiterarios').required = false;
            document.getElementById('areaTematica').required = false;
            document.getElementById('publicoObjetivo').required = false;
            document.getElementById('campoAcademico').required = false;
            
            // Mostrar y configurar los campos correspondientes al tipo seleccionado
            if (tipo === 'Ficcion') {
                document.getElementById('camposFiccion').style.display = 'block';
                document.getElementById('genero').required = true;
            } else if (tipo === 'NoFiccion') {
                document.getElementById('camposNoFiccion').style.display = 'block';
                document.getElementById('areaTematica').required = true;
                document.getElementById('publicoObjetivo').required = true;
            } else if (tipo === 'Referencia') {
                document.getElementById('camposReferencia').style.display = 'block';
                document.getElementById('campoAcademico').required = true;
            }
        }

        // Ejecutar al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Página cargada, inicializando campos específicos...');
            
            // Obtener el tipo de libro actual
            const tipoSelect = document.getElementById('tipo');
            const tipoActual = tipoSelect.value;
            console.log('Tipo de libro actual:', tipoActual);
            
            // Mostrar los campos específicos según el tipo actual
            if (tipoActual === 'Ficcion') {
                document.getElementById('camposFiccion').style.display = 'block';
                document.getElementById('genero').required = true;
                console.log('Valor del género:', document.getElementById('genero').value);
                console.log('Valor de premios:', document.getElementById('premiosLiterarios').value);
            } else if (tipoActual === 'NoFiccion') {
                document.getElementById('camposNoFiccion').style.display = 'block';
                document.getElementById('areaTematica').required = true;
                document.getElementById('publicoObjetivo').required = true;
                console.log('Valor del área temática:', document.getElementById('areaTematica').value);
                console.log('Valor del público objetivo:', document.getElementById('publicoObjetivo').value);
            } else if (tipoActual === 'Referencia') {
                document.getElementById('camposReferencia').style.display = 'block';
                document.getElementById('campoAcademico').required = true;
                console.log('Valor del campo académico:', document.getElementById('campoAcademico').value);
                console.log('Valor de consulta interna:', document.getElementById('consultaInterna').checked);
            }
            
            // Validación del formulario
            const form = document.querySelector('.needs-validation');
            form.addEventListener('submit', function(event) {
                console.log('Validando formulario...');
                
                // Verificar campos básicos
                const titulo = document.getElementById('titulo').value.trim();
                const autor = document.getElementById('autor').value.trim();
                const isbn = document.getElementById('isbn').value.trim();
                const ejemplares = document.getElementById('ejemplaresDisponibles').value.trim();
                const tipo = document.getElementById('tipo').value;
                
                console.log('Campos básicos:', { titulo, autor, isbn, ejemplares, tipo });
                
                // Verificar campos específicos según el tipo
                let camposValidos = true;
                
                if (tipo === 'Ficcion') {
                    const genero = document.getElementById('genero').value.trim();
                    const premios = document.getElementById('premiosLiterarios').value.trim();
                    console.log('Campos de ficción:', { genero, premios });
                    
                    if (!genero) {
                        document.getElementById('genero').classList.add('is-invalid');
                        camposValidos = false;
                    } else {
                        document.getElementById('genero').classList.remove('is-invalid');
                    }
                } else if (tipo === 'NoFiccion') {
                    const areaTematica = document.getElementById('areaTematica').value.trim();
                    const publicoObjetivo = document.getElementById('publicoObjetivo').value.trim();
                    console.log('Campos de no ficción:', { areaTematica, publicoObjetivo });
                    
                    if (!areaTematica) {
                        document.getElementById('areaTematica').classList.add('is-invalid');
                        camposValidos = false;
                    } else {
                        document.getElementById('areaTematica').classList.remove('is-invalid');
                    }
                    
                    if (!publicoObjetivo) {
                        document.getElementById('publicoObjetivo').classList.add('is-invalid');
                        camposValidos = false;
                    } else {
                        document.getElementById('publicoObjetivo').classList.remove('is-invalid');
                    }
                } else if (tipo === 'Referencia') {
                    const campoAcademico = document.getElementById('campoAcademico').value.trim();
                    const consultaInterna = document.getElementById('consultaInterna').checked;
                    console.log('Campos de referencia:', { campoAcademico, consultaInterna });
                    
                    if (!campoAcademico) {
                        document.getElementById('campoAcademico').classList.add('is-invalid');
                        camposValidos = false;
                    } else {
                        document.getElementById('campoAcademico').classList.remove('is-invalid');
                    }
                }
                
                // Verificar campos básicos
                if (!titulo) {
                    document.getElementById('titulo').classList.add('is-invalid');
                    camposValidos = false;
                } else {
                    document.getElementById('titulo').classList.remove('is-invalid');
                }
                
                if (!autor) {
                    document.getElementById('autor').classList.add('is-invalid');
                    camposValidos = false;
                } else {
                    document.getElementById('autor').classList.remove('is-invalid');
                }
                
                if (!isbn) {
                    document.getElementById('isbn').classList.add('is-invalid');
                    camposValidos = false;
                } else {
                    document.getElementById('isbn').classList.remove('is-invalid');
                }
                
                if (!ejemplares || ejemplares < 1) {
                    document.getElementById('ejemplaresDisponibles').classList.add('is-invalid');
                    camposValidos = false;
                } else {
                    document.getElementById('ejemplaresDisponibles').classList.remove('is-invalid');
                }
                
                if (!tipo) {
                    document.getElementById('tipo').classList.add('is-invalid');
                    camposValidos = false;
                } else {
                    document.getElementById('tipo').classList.remove('is-invalid');
                }
                
                if (!camposValidos) {
                    event.preventDefault();
                    event.stopPropagation();
                    console.log('Formulario inválido - Por favor complete todos los campos requeridos');
                } else {
                    console.log('Formulario válido, enviando...');
                }
                form.classList.add('was-validated');
            });
        });
    </script>
</body>
</html>
