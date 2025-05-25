package sena.adso.roles.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sena.adso.roles.dao.LibroDAO;
import sena.adso.roles.modelo.Libro;

@WebServlet("/lector/catalogo/*")
public class CatalogoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LibroDAO libroDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        libroDAO = new LibroDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("CatalogoServlet.doGet - Iniciando");
        String action = request.getPathInfo();
        System.out.println("Acción solicitada: " + action);

        try {
            // Si no hay acción específica, redirigir a listar
            if (action == null || action.equals("/")) {
                response.sendRedirect(request.getContextPath() + "/lector/catalogo/listar");
                return;
            }

            switch (action) {
                case "/listar":
                    listarLibros(request, response);
                    break;
                case "/buscar":
                    buscarLibros(request, response);
                    break;
                case "/ver":
                    verLibro(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/lector/catalogo/listar");
                    break;
            }
        } catch (SQLException e) {
            System.err.println("Error en doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud");
            request.getRequestDispatcher("/WEB-INF/errors/500.jsp").forward(request, response);
        }
    }

    private void listarLibros(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        System.out.println("Listando libros del catálogo...");
        try {
            List<Libro> libros = libroDAO.listarTodos();
            System.out.println("Libros encontrados: " + libros.size());
            request.setAttribute("libros", libros);
            request.getRequestDispatcher("/WEB-INF/lector/catalogo/listar.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("Error al listar libros: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar el catálogo");
            request.getRequestDispatcher("/WEB-INF/errors/500.jsp").forward(request, response);
        }
    }

    private void buscarLibros(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        System.out.println("Buscando libros...");
        String termino = request.getParameter("q");
        try {
            List<Libro> libros = libroDAO.buscarPorTermino(termino);
            System.out.println("Libros encontrados: " + libros.size());
            request.setAttribute("libros", libros);
            request.setAttribute("termino", termino);
            request.getRequestDispatcher("/WEB-INF/lector/catalogo/listar.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("Error al buscar libros: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al buscar libros");
            request.getRequestDispatcher("/WEB-INF/errors/500.jsp").forward(request, response);
        }
    }

    private void verLibro(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        System.out.println("Mostrando detalles del libro");
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            System.out.println("ID del libro a ver: " + id);
            Libro libro = libroDAO.buscarPorId(id);
            if (libro == null) {
                request.setAttribute("error", "Libro no encontrado");
                response.sendRedirect(request.getContextPath() + "/lector/catalogo/listar");
                return;
            }
            System.out.println("Libro encontrado: " + libro.getTitulo());
            request.setAttribute("libro", libro);
            request.getRequestDispatcher("/WEB-INF/lector/catalogo/ver.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de libro inválido");
            response.sendRedirect(request.getContextPath() + "/lector/catalogo/listar");
        }
    }
} 