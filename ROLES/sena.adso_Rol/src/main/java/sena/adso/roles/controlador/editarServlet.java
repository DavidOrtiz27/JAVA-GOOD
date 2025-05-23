package sena.adso.roles.controlador;

import sena.adso.roles.dao.LibroDAO;
import sena.adso.roles.modelo.Libro;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/libros/editar")
public class editarServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                LibroDAO libroDAO = new LibroDAO();
                Libro libro = libroDAO.buscarPorId(id);

                if (libro != null) {
                    request.setAttribute("libro", libro);
                    request.getRequestDispatcher("/WEB-INF/admin/libros/editar.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException | SQLException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String titulo = request.getParameter("titulo");
            String isbn = request.getParameter("isbn");
            String autor = request.getParameter("autor");
            int ejemplares = Integer.parseInt(request.getParameter("ejemplares_disponibles"));

            Libro libro = new Libro() {
                @Override
                public String getTipoLibro() {
                    return "";
                }
            };
            libro.setId(id);
            libro.setTitulo(titulo);
            libro.setIsbn(isbn);
            libro.setAutor(autor);
            libro.setEjemplaresDisponibles(ejemplares);

            LibroDAO libroDAO = new LibroDAO();
            libroDAO.actualizar(libro);

            response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Error al actualizar el libro", e);
        }
    }
}
