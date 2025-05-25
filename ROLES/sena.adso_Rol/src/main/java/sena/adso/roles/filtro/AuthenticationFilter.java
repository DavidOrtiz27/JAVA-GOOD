package sena.adso.roles.filtro;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sena.adso.roles.modelo.Usuario;

/**
 * Filtro de autenticación y autorización por rol para rutas protegidas.
 * Aplica a rutas: /admin/* (Bibliotecario) y /lector/* (Lector).
 */
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String loginURI = contextPath + "/auth/login";
        String accesoDenegadoURI = contextPath + "/acceso-denegado.jsp";

        // Imprimir información de depuración
        System.out.println("\n=== AuthenticationFilter ===");
        System.out.println("Request URI: " + requestURI);
        System.out.println("Context Path: " + contextPath);
        System.out.println("Method: " + httpRequest.getMethod());

        // Verificar si es una ruta de autenticación o recursos estáticos
        if (requestURI.startsWith(contextPath + "/auth/") || 
            requestURI.startsWith(contextPath + "/resources/") ||
            requestURI.endsWith(".css") || 
            requestURI.endsWith(".js") || 
            requestURI.endsWith(".jpg") || 
            requestURI.endsWith(".png")) {
            System.out.println("Ruta pública detectada, permitiendo acceso");
            chain.doFilter(request, response);
            return;
        }

        // Verificar sesión
        HttpSession session = httpRequest.getSession(false);
        System.out.println("Session ID: " + (session != null ? session.getId() : "no session"));
        
        if (session == null || session.getAttribute("usuario") == null) {
            System.out.println("No hay sesión activa, redirigiendo a login");
            httpResponse.sendRedirect(loginURI);
            return;
        }

        // Verificar rol del usuario
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        System.out.println("Usuario en sesión: " + usuario.getEmail() + " con rol: " + usuario.getRol());

        // Verificar permisos según la ruta
        if (requestURI.startsWith(contextPath + "/admin/")) {
            if (!usuario.esBibliotecario()) {
                System.out.println("Acceso denegado: Usuario no es bibliotecario");
                httpResponse.sendRedirect(accesoDenegadoURI);
                return;
            }
            System.out.println("Acceso permitido para bibliotecario");
        } else if (requestURI.startsWith(contextPath + "/lector/")) {
            if (!usuario.esLector()) {
                System.out.println("Acceso denegado: Usuario no es lector");
                httpResponse.sendRedirect(accesoDenegadoURI);
                return;
            }
            System.out.println("Acceso permitido para lector");
        }

        // Usuario autenticado y autorizado
        System.out.println("Continuando con la petición...");
        chain.doFilter(request, response);
        System.out.println("=== Fin AuthenticationFilter ===\n");
    }

    @Override
    public void destroy() {
        // No se requiere limpieza adicional
    }
}
