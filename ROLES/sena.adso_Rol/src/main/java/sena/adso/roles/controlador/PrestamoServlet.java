package sena.adso.roles.controlador;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sena.adso.roles.dao.LibroDAO;
import sena.adso.roles.dao.PrestamoDAO;
import sena.adso.roles.dao.UsuarioDAO;
import sena.adso.roles.modelo.Libro;
import sena.adso.roles.modelo.Prestamo;
import sena.adso.roles.modelo.Usuario;

@WebServlet(name = "PrestamoServlet", urlPatterns = {
    "/lector/prestamos/*",
    "/admin/prestamos/*"
})
public class PrestamoServlet extends HttpServlet {
    
    private PrestamoDAO prestamoDAO;
    private LibroDAO libroDAO;
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        prestamoDAO = new PrestamoDAO();
        libroDAO = new LibroDAO();
        usuarioDAO = new UsuarioDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String accion = request.getParameter("accion");
        String pathInfo = request.getPathInfo();
        
        // Si la ruta es /nuevo, mostrar el formulario de nuevo préstamo
        if (pathInfo != null && pathInfo.equals("/nuevo")) {
            if (usuario.esBibliotecario()) {
                try {
                    mostrarFormularioPrestamo(request, response);
                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("mensaje", "Error al cargar el formulario: " + e.getMessage());
                    request.setAttribute("tipo", "danger");
                    response.sendRedirect(request.getContextPath() + "/admin/prestamos");
                }
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/lector/panel");
                return;
            }
        }
        
        if (accion == null) accion = "listar";
        
        try {
            switch (accion) {
                case "listar":
                    listarPrestamos(request, response);
                    break;
                    
                case "historial":
                    if (usuario.esBibliotecario()) {
                        // Para bibliotecarios: mostrar historial completo
                        List<Prestamo> historial = prestamoDAO.listarTodos().stream()
                            .filter(p -> "DEVUELTO".equals(p.getEstado()))
                            .collect(Collectors.toList());
                        request.setAttribute("prestamos", historial);
                        request.setAttribute("now", new java.sql.Date(System.currentTimeMillis()));
                        request.getRequestDispatcher("/WEB-INF/admin/prestamos/historial.jsp").forward(request, response);
                    } else {
                        // Para lectores: mostrar su historial personal
                        List<Prestamo> historial = prestamoDAO.listarPorUsuario(usuario.getId()).stream()
                            .filter(p -> "DEVUELTO".equals(p.getEstado()))
                            .collect(Collectors.toList());
                        request.setAttribute("prestamos", historial);
                        request.setAttribute("now", new java.sql.Date(System.currentTimeMillis()));
                        request.getRequestDispatcher("/WEB-INF/lector/prestamos/historial.jsp").forward(request, response);
                    }
                    break;
                    
                case "devolver":
                    if (usuario.esBibliotecario()) {
                        String idParam = request.getParameter("id");
                        if (idParam != null && !idParam.trim().isEmpty()) {
                            mostrarFormularioDevolucion(request, response);
                        } else {
                            response.sendRedirect(request.getContextPath() + "/admin/prestamos?accion=listar");
                        }
                    } else {
                        response.sendRedirect(request.getContextPath() + "/lector/panel");
                    }
                    break;
                    
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/prestamos?accion=listar");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al procesar la solicitud: " + e.getMessage());
            request.setAttribute("tipo", "danger");
            response.sendRedirect(request.getContextPath() + "/admin/prestamos?accion=listar");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!esBibliotecario(request)) {
            response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
            return;
        }
        
        String accion = request.getParameter("accion");
        System.out.println("PrestamoServlet.doPost - Acción: " + accion);
        
        try {
            switch (accion) {
                case "crear":
                    realizarPrestamo(request, response);
                    break;
                case "devolver":
                    procesarDevolucion(request, response);
                    break;
                case "eliminar":
                    eliminarPrestamo(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            manejarError(request, response, e);
        }
    }
    
    private String extraerAccion(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        System.out.println("PrestamoServlet.extraerAccion - PathInfo: " + pathInfo);
        
        if (pathInfo == null || pathInfo.equals("/")) {
            return "listar";
        }
        
        // Eliminar el slash inicial y obtener la primera parte de la ruta
        String[] partes = pathInfo.substring(1).split("/");
        System.out.println("PrestamoServlet.extraerAccion - Acción extraída: " + partes[0]);
        return partes[0];
    }
    
    private void listarPrestamos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        
        if (esBibliotecario(request)) {
            // Obtener todos los préstamos
            List<Prestamo> todosPrestamos = prestamoDAO.listarTodos();
            
            // Filtrar préstamos activos
            List<Prestamo> prestamosActivos = todosPrestamos.stream()
                .filter(p -> "ACTIVO".equals(p.getEstado()))
                .collect(Collectors.toList());
            
            // Filtrar préstamos vencidos (activos con fecha de devolución pasada)
            List<Prestamo> prestamosVencidos = prestamosActivos.stream()
                .filter(p -> p.getFechaDevolucion().before(new java.sql.Date(System.currentTimeMillis())))
                .collect(Collectors.toList());
            
            // Filtrar historial (préstamos devueltos)
            List<Prestamo> historial = todosPrestamos.stream()
                .filter(p -> "DEVUELTO".equals(p.getEstado()))
                .collect(Collectors.toList());
            
            request.setAttribute("prestamosActivos", prestamosActivos);
            request.setAttribute("prestamosVencidos", prestamosVencidos);
            request.setAttribute("historial", historial);
            request.setAttribute("now", new java.sql.Date(System.currentTimeMillis()));
            
            request.getRequestDispatcher("/WEB-INF/admin/prestamos/listar.jsp").forward(request, response);
        } else {
            // Para lectores: mostrar sus préstamos
            List<Prestamo> prestamos = prestamoDAO.listarPorUsuario(usuario.getId());
            request.setAttribute("prestamos", prestamos);
            request.setAttribute("now", new java.sql.Date(System.currentTimeMillis()));
            request.getRequestDispatcher("/WEB-INF/lector/prestamos/historial.jsp").forward(request, response);
        }
    }
    
    private void mostrarFormularioPrestamo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            System.out.println("PrestamoServlet.mostrarFormularioPrestamo - Iniciando");
            List<Libro> libros = libroDAO.listarDisponibles();
            System.out.println("Libros disponibles encontrados: " + libros.size());
            for (Libro libro : libros) {
                System.out.println("- Libro: " + libro.getId() + " - " + libro.getTitulo());
            }
            
            List<Usuario> usuarios = usuarioDAO.buscarPorRol("lector");
            System.out.println("Usuarios lectores encontrados: " + usuarios.size());
            for (Usuario usuario : usuarios) {
                System.out.println("- Usuario: " + usuario.getId() + " - " + usuario.getNombre());
            }
            
            request.setAttribute("libros", libros);
            request.setAttribute("usuarios", usuarios);
            System.out.println("Atributos establecidos en la request");
            request.getRequestDispatcher("/WEB-INF/admin/prestamos/nuevo.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("Error en mostrarFormularioPrestamo: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/prestamos");
        }
    }
    
    private void realizarPrestamo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            System.out.println("PrestamoServlet.realizarPrestamo - Iniciando");
            int libroId = Integer.parseInt(request.getParameter("libro_id"));
            int usuarioId = Integer.parseInt(request.getParameter("usuario_id"));
            String fechaDevolucionStr = request.getParameter("fecha_devolucion");
            System.out.println("Datos recibidos - Libro ID: " + libroId + ", Usuario ID: " + usuarioId + ", Fecha Devolución: " + fechaDevolucionStr);
            
            java.sql.Date fechaPrestamo = new java.sql.Date(System.currentTimeMillis());
            java.sql.Date fechaDevolucion = java.sql.Date.valueOf(fechaDevolucionStr);
            System.out.println("Fecha de préstamo: " + fechaPrestamo);
            System.out.println("Fecha de devolución: " + fechaDevolucion);
            
            // Verificar si el usuario ya tiene 5 libros prestados
            int prestamosActivos = prestamoDAO.contarPrestamosActivosUsuario(usuarioId);
            if (prestamosActivos >= 5) {
                System.out.println("Usuario ha alcanzado el límite de préstamos");
                request.setAttribute("mensaje", "El usuario ha alcanzado el límite de 5 libros prestados");
                request.setAttribute("tipo", "warning");
                mostrarFormularioPrestamo(request, response);
                return;
            }
            
            // Verificar disponibilidad del libro
            Libro libro = libroDAO.buscarPorId(libroId);
            if (libro == null || libro.getEjemplaresDisponibles() <= 0) {
                System.out.println("Libro no está disponible");
                request.setAttribute("mensaje", "El libro no está disponible para préstamo");
                request.setAttribute("tipo", "warning");
                mostrarFormularioPrestamo(request, response);
                return;
            }
            
            Prestamo prestamo = new Prestamo();
            prestamo.setLibroId(libroId);
            prestamo.setUsuarioId(usuarioId);
            prestamo.setFechaPrestamo(fechaPrestamo);
            prestamo.setFechaDevolucion(fechaDevolucion);
            prestamo.setEstado("ACTIVO");
            System.out.println("Préstamo creado con estado: " + prestamo.getEstado());
            
            boolean resultado = prestamoDAO.crear(prestamo);
            System.out.println("Resultado de creación de préstamo: " + resultado);
            
            if (resultado) {
                // Actualizar ejemplares disponibles
                libro.setEjemplaresDisponibles(libro.getEjemplaresDisponibles() - 1);
                libroDAO.actualizar(libro);
                System.out.println("Ejemplares disponibles actualizados");
                request.setAttribute("mensaje", "Préstamo realizado correctamente");
                request.setAttribute("tipo", "success");
            } else {
                System.out.println("Error al crear el préstamo");
                request.setAttribute("mensaje", "Error al realizar el préstamo");
                request.setAttribute("tipo", "danger");
            }
            
            listarPrestamos(request, response);
            
        } catch (NumberFormatException e) {
            System.err.println("Error en realizarPrestamo - Datos inválidos: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensaje", "Datos de préstamo inválidos");
            request.setAttribute("tipo", "danger");
            mostrarFormularioPrestamo(request, response);
        }
    }
    
    private void mostrarFormularioDevolucion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            String idParam = request.getParameter("id");
            System.out.println("PrestamoServlet.mostrarFormularioDevolucion - ID del préstamo: " + idParam);
            
            if (idParam == null || idParam.trim().isEmpty()) {
                request.getSession().setAttribute("mensaje", "ID de préstamo no proporcionado");
                request.getSession().setAttribute("tipo", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/prestamos?accion=listar");
                return;
            }

            int prestamoId = Integer.parseInt(idParam);
            Prestamo prestamo = prestamoDAO.buscarPorId(prestamoId);
            System.out.println("Préstamo encontrado: " + (prestamo != null ? "Sí" : "No"));
            
            if (prestamo != null && "ACTIVO".equals(prestamo.getEstado())) {
                // Cargar datos adicionales del préstamo
                Libro libro = libroDAO.buscarPorId(prestamo.getLibroId());
                Usuario usuario = usuarioDAO.buscarPorId(prestamo.getUsuarioId());
                
                if (libro != null && usuario != null) {
                    prestamo.setTituloLibro(libro.getTitulo());
                    prestamo.setNombreUsuario(usuario.getNombre());
                }
                
                request.setAttribute("prestamo", prestamo);
                System.out.println("Redirigiendo a devolver.jsp");
                request.getRequestDispatcher("/WEB-INF/admin/prestamos/devolver.jsp")
                       .forward(request, response);
            } else {
                request.getSession().setAttribute("mensaje", "Préstamo no encontrado o ya devuelto");
                request.getSession().setAttribute("tipo", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/prestamos?accion=listar");
            }
        } catch (NumberFormatException e) {
            System.err.println("Error en mostrarFormularioDevolucion: " + e.getMessage());
            request.getSession().setAttribute("mensaje", "ID de préstamo inválido");
            request.getSession().setAttribute("tipo", "danger");
            response.sendRedirect(request.getContextPath() + "/admin/prestamos?accion=listar");
        }
    }
    
    private void procesarDevolucion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            System.out.println("PrestamoServlet.procesarDevolucion - Iniciando");
            int prestamoId = Integer.parseInt(request.getParameter("id"));
            System.out.println("ID del préstamo a devolver: " + prestamoId);
            
            Prestamo prestamo = prestamoDAO.buscarPorId(prestamoId);
            System.out.println("Préstamo encontrado: " + (prestamo != null ? "Sí" : "No"));
            
            if (prestamo != null && "ACTIVO".equals(prestamo.getEstado())) {
                // Establecer la fecha de devolución actual
                prestamo.setFechaDevolucion(new Date(System.currentTimeMillis()));
                prestamo.setEstado("DEVUELTO");
                
                boolean resultado = prestamoDAO.actualizar(prestamo);
                System.out.println("Resultado de actualización: " + resultado);
                
                if (resultado) {
                    // Actualizar ejemplares disponibles del libro
                    Libro libro = libroDAO.buscarPorId(prestamo.getLibroId());
                    if (libro != null) {
                        libro.setEjemplaresDisponibles(libro.getEjemplaresDisponibles() + 1);
                        boolean libroActualizado = libroDAO.actualizar(libro);
                        System.out.println("Libro actualizado: " + libroActualizado);
                        
                        request.getSession().setAttribute("mensaje", "Devolución procesada correctamente");
                        request.getSession().setAttribute("tipo", "success");
                    } else {
                        System.out.println("No se encontró el libro asociado");
                        request.getSession().setAttribute("mensaje", "Error: No se encontró el libro asociado");
                        request.getSession().setAttribute("tipo", "danger");
                    }
                } else {
                    System.out.println("Error al actualizar el préstamo");
                    request.getSession().setAttribute("mensaje", "Error al procesar la devolución");
                    request.getSession().setAttribute("tipo", "danger");
                }
            } else {
                System.out.println("Préstamo no encontrado o ya devuelto");
                request.getSession().setAttribute("mensaje", "Préstamo no encontrado o ya devuelto");
                request.getSession().setAttribute("tipo", "warning");
            }
            
            // Redirigir a la lista de préstamos
            response.sendRedirect(request.getContextPath() + "/admin/prestamos?accion=listar");
            
        } catch (NumberFormatException e) {
            System.err.println("Error en procesarDevolucion: " + e.getMessage());
            request.getSession().setAttribute("mensaje", "ID de préstamo inválido");
            request.getSession().setAttribute("tipo", "danger");
            response.sendRedirect(request.getContextPath() + "/admin/prestamos?accion=listar");
        }
    }
    
    private void verHistorial(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        List<Prestamo> prestamos = prestamoDAO.listarPorUsuario(usuario.getId());
        request.setAttribute("prestamos", prestamos);
        request.setAttribute("now", new java.sql.Date(System.currentTimeMillis()));
        request.getRequestDispatcher("/WEB-INF/lector/prestamos/historial.jsp").forward(request, response);
    }
    
    private boolean esBibliotecario(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            return "Bibliotecario".equals(usuario.getRol());
        }
        return false;
    }
    
    private void manejarError(HttpServletRequest request, HttpServletResponse response, SQLException e)
            throws ServletException, IOException {
        e.printStackTrace();
        request.setAttribute("mensaje", "Error en la base de datos. Por favor, inténtelo más tarde.");
        request.setAttribute("tipo", "danger");
        request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
    }

    private void eliminarPrestamo(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Prestamo prestamo = prestamoDAO.buscarPorId(id);
            
            if (prestamo != null && "ACTIVO".equals(prestamo.getEstado())) {
                // Actualizar ejemplares disponibles antes de eliminar
                Libro libro = libroDAO.buscarPorId(prestamo.getLibroId());
                if (libro != null) {
                    libro.setEjemplaresDisponibles(libro.getEjemplaresDisponibles() + 1);
                    libroDAO.actualizar(libro);
                }
            }
            
            boolean eliminado = prestamoDAO.eliminar(id);
            
            if (eliminado) {
                request.getSession().setAttribute("mensaje", "Préstamo eliminado correctamente");
                request.getSession().setAttribute("tipo", "success");
            } else {
                request.getSession().setAttribute("mensaje", "Error al eliminar el préstamo");
                request.getSession().setAttribute("tipo", "danger");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensaje", "ID de préstamo inválido");
            request.getSession().setAttribute("tipo", "danger");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/prestamos/listar");
    }
}