package sena.adso.roles.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import sena.adso.roles.modelo.Prestamo;
import sena.adso.roles.modelo.Usuario;
import sena.adso.roles.dao.PrestamoDAO;
import sena.adso.roles.dao.LibroDAO;

@WebServlet(name = "PrestamoServlet", urlPatterns = {"/bibliotecario/prestamos/*", "/lector/prestamos/*"})
public class PrestamoServlet extends HttpServlet {
    
    private PrestamoDAO prestamoDAO;
    private LibroDAO libroDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        prestamoDAO = new PrestamoDAO();
        libroDAO = new LibroDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = extraerAccion(request);
        
        try {
            switch (accion) {
                case "listar":
                    listarPrestamos(request, response);
                    break;
                case "nuevo":
                    if (esBibliotecario(request)) {
                        mostrarFormularioPrestamo(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
                    }
                    break;
                case "devolver":
                    if (esBibliotecario(request)) {
                        mostrarFormularioDevolucion(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
                    }
                    break;
                case "historial":
                    verHistorial(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            manejarError(request, response, e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!esBibliotecario(request)) {
            response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
            return;
        }
        
        String accion = extraerAccion(request);
        
        try {
            switch (accion) {
                case "realizar":
                    realizarPrestamo(request, response);
                    break;
                case "devolver":
                    procesarDevolucion(request, response);
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
        if (pathInfo == null || pathInfo.equals("/")) {
            return "listar";
        }
        return pathInfo.substring(1);
    }
    
    private void listarPrestamos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        List<Prestamo> prestamos;
        
        if (esBibliotecario(request)) {
            prestamos = prestamoDAO.listarTodos();
        } else {
            prestamos = prestamoDAO.listarPorUsuario(usuario.getId());
        }
        
        request.setAttribute("prestamos", prestamos);
        String vista = esBibliotecario(request) ? 
                      "/WEB-INF/bibliotecario/prestamos.jsp" : 
                      "/WEB-INF/lector/mis-prestamos.jsp";
        request.getRequestDispatcher(vista).forward(request, response);
    }
    
    private void mostrarFormularioPrestamo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        request.setAttribute("librosDisponibles", libroDAO.listarDisponibles());
        request.getRequestDispatcher("/WEB-INF/bibliotecario/formulario-prestamo.jsp")
               .forward(request, response);
    }
    
    private void realizarPrestamo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            int libroId = Integer.parseInt(request.getParameter("libro_id"));
            int usuarioId = Integer.parseInt(request.getParameter("usuario_id"));
            Date fechaPrestamo = new Date(System.currentTimeMillis());
            
            if (prestamoDAO.tienePrestamosPendientes(usuarioId)) {
                request.setAttribute("mensaje", "El usuario tiene préstamos pendientes de devolución");
                request.setAttribute("tipo", "warning");
                mostrarFormularioPrestamo(request, response);
                return;
            }
            
            if (!libroDAO.estaDisponible(libroId)) {
                request.setAttribute("mensaje", "El libro no está disponible para préstamo");
                request.setAttribute("tipo", "warning");
                mostrarFormularioPrestamo(request, response);
                return;
            }
            
            Prestamo prestamo = new Prestamo();
            prestamo.setLibroId(libroId);
            prestamo.setUsuarioId(usuarioId);
            prestamo.setFechaPrestamo(fechaPrestamo);
            prestamo.setEstado("ACTIVO");
            
            boolean resultado = prestamoDAO.crear(prestamo);
            if (resultado) {
                libroDAO.actualizarDisponibilidad(libroId, false);
                request.setAttribute("mensaje", "Préstamo realizado correctamente");
                request.setAttribute("tipo", "success");
            } else {
                request.setAttribute("mensaje", "Error al realizar el préstamo");
                request.setAttribute("tipo", "danger");
            }
            
            listarPrestamos(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "Datos de préstamo inválidos");
            request.setAttribute("tipo", "danger");
            mostrarFormularioPrestamo(request, response);
        }
    }
    
    private void mostrarFormularioDevolucion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            int prestamoId = Integer.parseInt(request.getParameter("id"));
            Prestamo prestamo = prestamoDAO.buscarPorId(prestamoId);
            
            if (prestamo != null && "ACTIVO".equals(prestamo.getEstado())) {
                request.setAttribute("prestamo", prestamo);
                request.getRequestDispatcher("/WEB-INF/bibliotecario/formulario-devolucion.jsp")
                       .forward(request, response);
            } else {
                request.setAttribute("mensaje", "Préstamo no encontrado o ya devuelto");
                request.setAttribute("tipo", "warning");
                listarPrestamos(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "ID de préstamo inválido");
            request.setAttribute("tipo", "danger");
            listarPrestamos(request, response);
        }
    }
    
    private void procesarDevolucion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            int prestamoId = Integer.parseInt(request.getParameter("id"));
            Prestamo prestamo = prestamoDAO.buscarPorId(prestamoId);
            
            if (prestamo != null && "ACTIVO".equals(prestamo.getEstado())) {
                prestamo.setFechaDevolucion(new Date(System.currentTimeMillis()));
                prestamo.setEstado("DEVUELTO");
                
                boolean resultado = prestamoDAO.actualizar(prestamo);
                if (resultado) {
                    libroDAO.actualizarDisponibilidad(prestamo.getLibroId(), true);
                    request.setAttribute("mensaje", "Devolución procesada correctamente");
                    request.setAttribute("tipo", "success");
                } else {
                    request.setAttribute("mensaje", "Error al procesar la devolución");
                    request.setAttribute("tipo", "danger");
                }
            } else {
                request.setAttribute("mensaje", "Préstamo no encontrado o ya devuelto");
                request.setAttribute("tipo", "warning");
            }
            
            listarPrestamos(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "ID de préstamo inválido");
            request.setAttribute("tipo", "danger");
            listarPrestamos(request, response);
        }
    }
    
    private void verHistorial(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        List<Prestamo> historial;
        
        if (esBibliotecario(request)) {
            historial = prestamoDAO.listarHistorialCompleto();
        } else {
            historial = prestamoDAO.listarHistorialUsuario(usuario.getId());
        }
        
        request.setAttribute("historial", historial);
        String vista = esBibliotecario(request) ? 
                      "/WEB-INF/bibliotecario/historial-prestamos.jsp" : 
                      "/WEB-INF/lector/mi-historial.jsp";
        request.getRequestDispatcher(vista).forward(request, response);
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
}