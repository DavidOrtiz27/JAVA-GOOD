package sena.adso.roles.controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet que maneja el proceso de cierre de sesión
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    /**
     * Maneja las solicitudes GET al servlet de logout
     * Invalida la sesión actual y redirige al login
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Invalidar la sesión
            session.invalidate();
        }
        
        // Redirigir a la página de login
        response.sendRedirect(request.getContextPath() + "/public/login.jsp");
    }

    /**
     * Maneja las solicitudes POST al servlet de logout
     * Redirige al método doGet
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}