package sena.adso.roles.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sena.adso.roles.dao.LibroDAO;
import sena.adso.roles.dao.PrestamoDAO;
import sena.adso.roles.dao.UsuarioDAO;
import sena.adso.roles.modelo.Prestamo;
import sena.adso.roles.modelo.Usuario;

@WebServlet("/admin/panel")
public class BibliotecarioPanelServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LibroDAO libroDAO;
    private PrestamoDAO prestamoDAO;
    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        libroDAO = new LibroDAO();
        prestamoDAO = new PrestamoDAO();
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("\n=== BibliotecarioPanelServlet.doGet ===");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        
        try {
            // Verificar sesión
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("usuario") == null) {
                System.out.println("No hay sesión activa, redirigiendo a login");
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }

            // Verificar rol
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            if (!usuario.esBibliotecario()) {
                System.out.println("Usuario no es bibliotecario, redirigiendo a acceso denegado");
                response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
                return;
            }

            // Cargar datos para el panel
            int totalLibros = libroDAO.contarTotal();
            int prestamosActivos = prestamoDAO.contarPrestamosActivos();
            int usuariosActivos = usuarioDAO.contarUsuariosActivos();
            int prestamosVencidos = prestamoDAO.contarPrestamosVencidos();
            List<Prestamo> ultimosPrestamos = prestamoDAO.listarUltimosPrestamos(5);

            // Agregar datos a la request
            request.setAttribute("totalLibros", totalLibros);
            request.setAttribute("prestamosActivos", prestamosActivos);
            request.setAttribute("usuariosActivos", usuariosActivos);
            request.setAttribute("prestamosVencidos", prestamosVencidos);
            request.setAttribute("ultimosPrestamos", ultimosPrestamos);

            // Forward al JSP del panel
            System.out.println("Mostrando panel de bibliotecario");
            request.getRequestDispatcher("/WEB-INF/admin/panel.jsp").forward(request, response);
            System.out.println("=== Fin BibliotecarioPanelServlet.doGet ===\n");
        } catch (SQLException e) {
            System.err.println("Error al cargar datos del panel: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar los datos del panel");
            request.getRequestDispatcher("/WEB-INF/errors/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 