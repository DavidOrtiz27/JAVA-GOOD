package sena.adso.roles.controlador; // Ajusta este paquete según tu proyecto

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/administracion/*")
public class AdministracionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getPathInfo(); // Obtiene lo que sigue a /administracion/

        if (path == null) {
            // Si no se especifica destino, redirige a la lista de libros por defecto
            response.sendRedirect(request.getContextPath() + "/bibliotecario/libros/libros");
            return;
        }

        switch (path) {
            case "/libros":
                response.sendRedirect(request.getContextPath() + "/bibliotecario/libros/libros");
                break;
            case "/usuarios":
                response.sendRedirect(request.getContextPath() + "/bibliotecario/usuarios/listar");
                break;
            default:
                // En caso de ruta no reconocida, redirige a libros por defecto
                response.sendRedirect(request.getContextPath() + "/bibliotecario/libros/listar");
                break;
        }
    }
}
