package sena.adso.roles.controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import sena.adso.roles.modelo.Usuario;
import sena.adso.roles.dao.UsuarioDAO;

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
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("usuario") != null) {
            redirigirSegunRol((Usuario) session.getAttribute("usuario"), request, response);
            return;
        }

        request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email").trim();
        String password = request.getParameter("password").trim();

        if (email.isEmpty() || password.isEmpty()) {
            enviarErrorLogin(request, response, "Por favor, ingrese email y contraseña", "warning");
            return;
        }

        try {
            Usuario usuario = usuarioDAO.validarUsuario(email, password);

            if (usuario == null) {
                enviarErrorLogin(request, response, "Credenciales inválidas", "danger");
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            session.setAttribute("rol", usuario.getRol().toLowerCase());
            session.setMaxInactiveInterval(30 * 60); // 30 minutos

            redirigirSegunRol(usuario, request, response);

        } catch (Exception e) {
            System.err.println("Error en autenticación: " + e.getMessage());
            enviarErrorLogin(request, response, "Error en el servidor. Intente más tarde.", "danger");
        }
    }

    private void redirigirSegunRol(Usuario usuario, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String contextPath = request.getContextPath();
        String rol = usuario.getRol().toLowerCase();

        switch (rol) {
            case "bibliotecario":
                response.sendRedirect(contextPath + "/admin/panelAdmin");
                break;
            case "lector":
                response.sendRedirect(contextPath + "/lector/panel");
                break;
            default:
                response.sendRedirect(contextPath + "/auth/login?error=rol_invalido");
        }
    }

    private void enviarErrorLogin(HttpServletRequest request, HttpServletResponse response,
            String mensaje, String tipo) throws ServletException, IOException {
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipo", tipo);
        request.setAttribute("email", request.getParameter("email"));
        request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
    }
}
