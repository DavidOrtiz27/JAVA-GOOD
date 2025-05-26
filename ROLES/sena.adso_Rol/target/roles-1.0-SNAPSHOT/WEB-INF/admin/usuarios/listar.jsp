<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Usuarios - Biblioteca Duitama</title>

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
                            <a href="${pageContext.request.contextPath}/admin/libros" class="nav-link text-white">
                                <i class="bi bi-book"></i>Libros
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/prestamos" class="nav-link text-white">
                                <i class="bi bi-journal-text"></i>Préstamos
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/usuarios" class="nav-link active">
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
                    <h1 class="h2">Gestión de Usuarios</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/usuarios/nuevo" class="btn btn-primary">
                            <i class="bi bi-plus-circle me-2"></i>Nuevo Usuario
                        </a>
                    </div>
                </div>

                <!-- Mensajes -->
                <c:if test="${not empty mensaje}">
                    <div class="alert alert-${tipo} alert-dismissible fade show" role="alert">
                        ${mensaje}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Pestañas -->
                <ul class="nav nav-tabs mb-4" id="userTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="todos-tab" data-bs-toggle="tab" data-bs-target="#todos" type="button" role="tab">
                            Todos
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="bibliotecarios-tab" data-bs-toggle="tab" data-bs-target="#bibliotecarios" type="button" role="tab">
                            Bibliotecarios
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="lectores-tab" data-bs-toggle="tab" data-bs-target="#lectores" type="button" role="tab">
                            Lectores
                        </button>
                    </li>
                </ul>

                <!-- Contenido de las pestañas -->
                <div class="tab-content" id="userTabsContent">
                    <!-- Pestaña Todos -->
                    <div class="tab-pane fade show active" id="todos" role="tabpanel">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nombre</th>
                                        <th>Email</th>
                                        <th>Rol</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${bibliotecarios}" var="usuario">
                                        <tr>
                                            <td>${usuario.id}</td>
                                            <td>${usuario.nombre}</td>
                                            <td>${usuario.email}</td>
                                            <td>${usuario.rol}</td>
                                            <td>
                                                <div class="btn-group">
                                                    <a href="${pageContext.request.contextPath}/admin/usuarios/editar?id=${usuario.id}" class="btn btn-sm btn-primary">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-danger" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#eliminarModal"
                                                            data-id="${usuario.id}"
                                                            data-nombre="${usuario.nombre}"
                                                            data-email="${usuario.email}"
                                                            data-rol="${usuario.rol}">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:forEach items="${lectores}" var="usuario">
                                        <tr>
                                            <td>${usuario.id}</td>
                                            <td>${usuario.nombre}</td>
                                            <td>${usuario.email}</td>
                                            <td>${usuario.rol}</td>
                                            <td>
                                                <div class="btn-group">
                                                    <a href="${pageContext.request.contextPath}/admin/usuarios/editar?id=${usuario.id}" class="btn btn-sm btn-primary">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-danger" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#eliminarModal"
                                                            data-id="${usuario.id}"
                                                            data-nombre="${usuario.nombre}"
                                                            data-email="${usuario.email}"
                                                            data-rol="${usuario.rol}">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Pestaña Bibliotecarios -->
                    <div class="tab-pane fade" id="bibliotecarios" role="tabpanel">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nombre</th>
                                        <th>Email</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${bibliotecarios}" var="usuario">
                                        <tr>
                                            <td>${usuario.id}</td>
                                            <td>${usuario.nombre}</td>
                                            <td>${usuario.email}</td>
                                            <td>
                                                <div class="btn-group">
                                                    <a href="${pageContext.request.contextPath}/admin/usuarios/editar?id=${usuario.id}" class="btn btn-sm btn-primary">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-danger" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#eliminarModal"
                                                            data-id="${usuario.id}"
                                                            data-nombre="${usuario.nombre}"
                                                            data-email="${usuario.email}"
                                                            data-rol="${usuario.rol}">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Pestaña Lectores -->
                    <div class="tab-pane fade" id="lectores" role="tabpanel">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nombre</th>
                                        <th>Email</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${lectores}" var="usuario">
                                        <tr>
                                            <td>${usuario.id}</td>
                                            <td>${usuario.nombre}</td>
                                            <td>${usuario.email}</td>
                                            <td>
                                                <div class="btn-group">
                                                    <a href="${pageContext.request.contextPath}/admin/usuarios/editar?id=${usuario.id}" class="btn btn-sm btn-primary">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-danger" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#eliminarModal"
                                                            data-id="${usuario.id}"
                                                            data-nombre="${usuario.nombre}"
                                                            data-email="${usuario.email}"
                                                            data-rol="${usuario.rol}">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Modal de Eliminación -->
    <div class="modal fade" id="eliminarModal" tabindex="-1" aria-labelledby="eliminarModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="eliminarModalLabel">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>¿Está seguro que desea eliminar al siguiente usuario?</p>
                    <div class="card mb-3">
                        <div class="card-body">
                            <h6 class="card-subtitle mb-2 text-muted">Información del Usuario</h6>
                            <p class="card-text"><strong>ID:</strong> <span id="modal-usuario-id"></span></p>
                            <p class="card-text"><strong>Nombre:</strong> <span id="modal-usuario-nombre"></span></p>
                            <p class="card-text"><strong>Email:</strong> <span id="modal-usuario-email"></span></p>
                            <p class="card-text"><strong>Rol:</strong> <span id="modal-usuario-rol"></span></p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <form action="${pageContext.request.contextPath}/admin/usuarios/eliminar" method="post" style="display: inline;">
                        <input type="hidden" name="id" id="modal-usuario-id-input">
                        <button type="submit" class="btn btn-danger">Eliminar</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Script para manejar el modal de eliminación
        document.addEventListener('DOMContentLoaded', function() {
            const eliminarModal = document.getElementById('eliminarModal');
            if (eliminarModal) {
                eliminarModal.addEventListener('show.bs.modal', function(event) {
                    const button = event.relatedTarget;
                    const id = button.getAttribute('data-id');
                    const nombre = button.getAttribute('data-nombre');
                    const email = button.getAttribute('data-email');
                    const rol = button.getAttribute('data-rol');

                    document.getElementById('modal-usuario-id').textContent = id;
                    document.getElementById('modal-usuario-nombre').textContent = nombre;
                    document.getElementById('modal-usuario-email').textContent = email;
                    document.getElementById('modal-usuario-rol').textContent = rol;
                    document.getElementById('modal-usuario-id-input').value = id;
                });
            }
        });
    </script>
</body>
</html>
