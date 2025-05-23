package sena.adso.roles.filtro;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

import sena.adso.roles.modelo.Usuario;

/**
 * Filtro de autenticación y autorización por rol para rutas protegidas.
 * Aplica a rutas: /administracion/* (Bibliotecario) y /lector/* (Lector).
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/administracion/*", "/lector/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No se requiere inicialización adicional
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false); // No crear nueva sesión si no existe
        String contextPath = httpRequest.getContextPath();

        String requestURI = httpRequest.getRequestURI();
        String loginURI = contextPath + "/public/login.jsp";
        String accesoDenegadoURI = contextPath + "/private/acceso-denegado.jsp";

        boolean isLoginRequest = requestURI.equals(loginURI);
        boolean isLoggedIn = session != null && session.getAttribute("usuario") != null;

        if (isLoggedIn || isLoginRequest) {

            if (isLoggedIn) {
                Usuario usuario = (Usuario) session.getAttribute("usuario");

                // Verificación de rol según la ruta
                if (requestURI.startsWith(contextPath + "/administracion/") && !usuario.esBibliotecario()) {
                    httpResponse.sendRedirect(accesoDenegadoURI);
                    return;
                }

                if (requestURI.startsWith(contextPath + "/lector/") && !usuario.esLector()) {
                    httpResponse.sendRedirect(accesoDenegadoURI);
                    return;
                }
            }

            // Usuario autenticado o es login, continuar
            chain.doFilter(request, response);

        } else {
            // No autenticado, redirigir al login
            httpResponse.sendRedirect(loginURI);
        }
    }

    @Override
    public void destroy() {
        // No se requiere limpieza adicional
    }
}
