package sena.adso.roles.controlador;

import sena.adso.roles.modelo.Libro;
import sena.adso.roles.dao.LibroDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "LectorPanelServlet", urlPatterns = {"/lector/panel"})
public class LectorPanelServlet extends HttpServlet {

    private LibroDAO libroDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        libroDAO = new LibroDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Intentar obtener la lista de libros
            List<Libro> libros = libroDAO.listarTodos();
            request.setAttribute("libros", libros);

            // Enviar a JSP
            request.getRequestDispatcher("/WEB-INF/lector/panel.jsp").forward(request, response);

        } catch (Exception e) {
            // Registrar el error para diagnóstico (opcionalmente usar Logger)
            e.printStackTrace();

            // Responder con error 500
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al obtener la lista de libros");
        }
    }
}
