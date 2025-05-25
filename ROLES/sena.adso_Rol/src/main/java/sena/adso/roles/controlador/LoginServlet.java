package sena.adso.roles.controlador;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sena.adso.roles.dao.UsuarioDAO;
import sena.adso.roles.modelo.Usuario;

@WebServlet("/auth/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("\n=== LoginServlet.doGet ===");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        
        // Verificar si hay una sesión activa
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            System.out.println("Usuario en sesión: " + usuario.getEmail() + " con rol: " + usuario.getRol());
            
            // Redirigir según el rol
            String contextPath = request.getContextPath();
            if (usuario.esBibliotecario()) {
                System.out.println("Redirigiendo bibliotecario a panel");
                response.sendRedirect(contextPath + "/admin/panel");
                return;
            } else if (usuario.esLector()) {
                System.out.println("Redirigiendo lector a panel");
                response.sendRedirect(contextPath + "/lector/panel");
                return;
            }
        }

        // Si no hay sesión o el rol no es válido, mostrar el formulario de login
        System.out.println("Mostrando formulario de login");
        request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
        System.out.println("=== Fin LoginServlet.doGet ===\n");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("\n=== LoginServlet.doPost ===");
        String email = request.getParameter("email").trim();
        String password = request.getParameter("password").trim();

        System.out.println("Intento de login para email: " + email);

        // Validar campos vacíos
        if (email.isEmpty() || password.isEmpty()) {
            System.out.println("Campos vacíos");
            enviarErrorLogin(request, response, "Por favor, ingrese email y contraseña", "warning");
            return;
        }

        try {
            // Validar credenciales
            Usuario usuario = usuarioDAO.validarUsuario(email, password);
            if (usuario == null) {
                System.out.println("Credenciales inválidas");
                enviarErrorLogin(request, response, "Credenciales inválidas", "danger");
                return;
            }

            System.out.println("Usuario autenticado: " + usuario.getEmail() + " con rol: " + usuario.getRol());
            
            // Invalidar sesión anterior si existe
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                System.out.println("Invalidando sesión anterior: " + oldSession.getId());
                oldSession.invalidate();
            }

            // Crear nueva sesión
            HttpSession session = request.getSession(true);
            System.out.println("Nueva sesión creada: " + session.getId());
            session.setAttribute("usuario", usuario);
            session.setAttribute("rol", usuario.getRol().toLowerCase());
            session.setMaxInactiveInterval(30 * 60); // 30 minutos

            // Redirigir según el rol
            String contextPath = request.getContextPath();
            if (usuario.esBibliotecario()) {
                System.out.println("Redirigiendo bibliotecario a panel");
                response.sendRedirect(contextPath + "/admin/panel");
                return;
            } else if (usuario.esLector()) {
                System.out.println("Redirigiendo lector a panel");
                response.sendRedirect(contextPath + "/lector/panel");
                return;
            } else {
                System.out.println("Rol inválido");
                response.sendRedirect(contextPath + "/auth/login?error=rol_invalido");
                return;
            }

        } catch (Exception e) {
            System.err.println("Error en autenticación: " + e.getMessage());
            enviarErrorLogin(request, response, "Error en el servidor. Intente más tarde.", "danger");
        }
        System.out.println("=== Fin LoginServlet.doPost ===\n");
    }

    private void enviarErrorLogin(HttpServletRequest request, HttpServletResponse response,
            String mensaje, String tipo) throws ServletException, IOException {
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipo", tipo);
        request.setAttribute("email", request.getParameter("email"));
        request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
    }
}
