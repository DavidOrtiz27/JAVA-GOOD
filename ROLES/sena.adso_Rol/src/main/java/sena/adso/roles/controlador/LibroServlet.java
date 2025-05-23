package sena.adso.roles.controlador;

import sena.adso.roles.dao.LibroDAO;
import sena.adso.roles.modelo.Libro;
import sena.adso.roles.modelo.LibroFiccion;
import sena.adso.roles.modelo.LibroNoFiccion;
import sena.adso.roles.modelo.LibroReferencia;
import sena.adso.roles.modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "LibroServlet", urlPatterns = {"/bibliotecario/libros/*", "/lector/catalogo/*"})
public class LibroServlet extends HttpServlet {

    private LibroDAO libroDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        libroDAO = new LibroDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = extraerAccion(request);

        try {
            switch (accion) {
                case "listar":
                    listarLibros(request, response);
                    break;
                case "nuevo":
                    if (esBibliotecario(request)) {
                        mostrarFormularioNuevo(request, response);
                    } else {
                        accesoDenegado(response, request);
                    }
                    break;
                case "agregar": // Agregar este caso
                    if (esBibliotecario(request)) {
                        mostrarFormularioNuevo(request, response);
                    } else {
                        accesoDenegado(response, request);
                    }
                    break;
                case "editar":
                    if (esBibliotecario(request)) {
                        mostrarFormularioEditar(request, response);
                    } else {
                        accesoDenegado(response, request);
                    }
                    break;
                case "ver":
                    verDetalles(request, response);
                    break;
                case "buscar":
                    buscarLibros(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = extraerAccion(request);

        try {
            switch (accion) {
                case "guardar":
                    if (esBibliotecario(request)) {
                        guardarLibro(request, response);
                    } else {
                        accesoDenegado(response, request);
                    }
                    break;
                case "actualizar":
                    if (esBibliotecario(request)) {
                        actualizarLibro(request, response);
                    } else {
                        accesoDenegado(response, request);
                    }
                    break;
                case "eliminar":
                    if (esBibliotecario(request)) {
                        eliminarLibro(request, response);
                    } else {
                        accesoDenegado(response, request);
                    }
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private String extraerAccion(HttpServletRequest request) {
        // Extrae la acción a partir del pathInfo (p.ej., /listar, /nuevo, /guardar...)
        String path = request.getPathInfo();
        if (path == null || path.equals("/")) {
            return "listar";
        }
        return path.substring(1); // Quita la barra inicial
    }

    private boolean esBibliotecario(HttpServletRequest request) {
        HttpSession sesion = request.getSession(false);
        if (sesion == null) return false;
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");
        return usuario != null && "bibliotecario".equalsIgnoreCase(usuario.getRol());
    }

    private void accesoDenegado(HttpServletResponse response, HttpServletRequest request)
            throws IOException, ServletException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        request.getRequestDispatcher("/acceso-denegado.jsp").forward(request, response);
    }

    // Métodos para manejar las solicitudes GET

    private void listarLibros(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Libro> libros = libroDAO.listarTodos();
        request.setAttribute("libros", libros);
        request.getRequestDispatcher("/WEB-INF/admin/libros/listar.jsp").forward(request, response);
    }

    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/admin/libros/agregar.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Libro libro = libroDAO.buscarPorId(id);
            if (libro == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Libro no encontrado");
                return;
            }
            request.setAttribute("libro", libro);
            request.getRequestDispatcher("/WEB-INF/libros/editar.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        }
    }

    private void verDetalles(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Libro libro = libroDAO.buscarPorId(id);
            if (libro == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Libro no encontrado");
                return;
            }
            request.setAttribute("libro", libro);
            request.getRequestDispatcher("/WEB-INF/libros/detalles.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        }
    }

    private void buscarLibros(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String criterio = request.getParameter("criterio");
        List<Libro> libros = libroDAO.buscarPorTitulo(criterio);
        request.setAttribute("libros", libros);
        request.getRequestDispatcher("/WEB-INF/libros/listar.jsp").forward(request, response);
    }

    // Métodos para manejar las solicitudes POST

    private void guardarLibro(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String titulo = request.getParameter("titulo");
        String isbn = request.getParameter("isbn");
        String autor = request.getParameter("autor");
        String tipoStr = request.getParameter("tipo");
        String ejemplaresStr = request.getParameter("ejemplares");

        if (titulo == null || isbn == null || autor == null || tipoStr == null || ejemplaresStr == null
                || titulo.isEmpty() || isbn.isEmpty() || autor.isEmpty() || tipoStr.isEmpty() || ejemplaresStr.isEmpty()) {
            request.setAttribute("mensaje", "Todos los campos son obligatorios");
            request.setAttribute("tipo", "danger");
            request.getRequestDispatcher("/WEB-INF/admin/libros/agregar.jsp").forward(request, response);
            return;
        }

        try {
            int ejemplares = Integer.parseInt(ejemplaresStr);
            Libro libro;

            switch (tipoStr) {
                case "Ficcion":
                    String genero = request.getParameter("genero");
                    String premiosLiterarios = request.getParameter("premios_literarios");
                    libro = new LibroFiccion(titulo, isbn, autor, ejemplares, genero, premiosLiterarios);
                    break;
                case "NoFiccion":
                    String areaTematica = request.getParameter("area_tematica");
                    String publicoObjetivo = request.getParameter("publico_objetivo");
                    libro = new LibroNoFiccion(titulo, isbn, autor, ejemplares, areaTematica, publicoObjetivo);
                    break;
                case "Referencia":
                    String campoAcademico = request.getParameter("campo_academico");
                    boolean consultaInterna = Boolean.parseBoolean(request.getParameter("consulta_interna"));
                    libro = new LibroReferencia(titulo, isbn, autor, ejemplares, campoAcademico, consultaInterna);
                    break;
                default:
                    request.setAttribute("mensaje", "Tipo de libro no válido");
                    request.setAttribute("tipo", "danger");
                    request.getRequestDispatcher("/WEB-INF/admin/libros/agregar.jsp").forward(request, response);
                    return;
            }

            if (libroDAO.existeIsbn(isbn)) {
                request.setAttribute("mensaje", "Ya existe un libro con ese ISBN");
                request.setAttribute("tipo", "danger");
                request.getRequestDispatcher("/WEB-INF/admin/libros/agregar.jsp").forward(request, response);
                return;
            }

            boolean resultado = libroDAO.insertar(libro);

            if (resultado) {
                response.sendRedirect(request.getContextPath() + "/bibliotecario//libros/listar");
            } else {
                request.setAttribute("mensaje", "Error al guardar el libro");
                request.setAttribute("tipo", "danger");
                request.getRequestDispatcher("/WEB-INF/libros/listar.jsp").forward(request, response);
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("mensaje", "Número de ejemplares inválido");
            request.setAttribute("tipo", "danger");
            request.getRequestDispatcher("/WEB-INF/libros/agregar.jsp").forward(request, response);
        }
    }

    private void actualizarLibro(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String titulo = request.getParameter("titulo");
            String isbn = request.getParameter("isbn");
            String autor = request.getParameter("autor");
            String tipoStr = request.getParameter("tipo");
            int ejemplares = Integer.parseInt(request.getParameter("ejemplares"));

            Libro libro;

            switch (tipoStr) {
                case "Ficcion":
                    String genero = request.getParameter("genero");
                    String premiosLiterarios = request.getParameter("premios_literarios");
                    libro = new LibroFiccion(titulo, isbn, autor, ejemplares, genero, premiosLiterarios);
                    break;
                case "NoFiccion":
                    String areaTematica = request.getParameter("area_tematica");
                    String publicoObjetivo = request.getParameter("publico_objetivo");
                    libro = new LibroNoFiccion(titulo, isbn, autor, ejemplares, areaTematica, publicoObjetivo);
                    break;
                case "Referencia":
                    String campoAcademico = request.getParameter("campo_academico");
                    boolean consultaInterna = Boolean.parseBoolean(request.getParameter("consulta_interna"));
                    libro = new LibroReferencia(titulo, isbn, autor, ejemplares, campoAcademico, consultaInterna);
                    break;
                default:
                    request.setAttribute("mensaje", "Tipo de libro no válido");
                    request.setAttribute("tipo", "danger");
                    request.getRequestDispatcher("/WEB-INF/admin/libros/editar.jsp").forward(request, response);
                    return;
            }

            libro.setId(id);

            boolean resultado = libroDAO.actualizar(libro);

            if (resultado) {
                // Redirigir con el id para cargar el libro actualizado
                response.sendRedirect(request.getContextPath() + "/bibliotecario/libros/editar?id=" + id);
            } else {
                request.setAttribute("mensaje", "Error al actualizar el libro");
                request.setAttribute("tipo", "danger");
                request.getRequestDispatcher("/WEB-INF/admin/libros/listar.jsp").forward(request, response);
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("mensaje", "ID o número de ejemplares inválidos");
            request.setAttribute("tipo", "danger");
            request.getRequestDispatcher("/WEB-INF/admin/libros/listar.jsp").forward(request, response);
        }
    }


    private void eliminarLibro(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean resultado = libroDAO.eliminar(id);
            if (resultado) {
                response.sendRedirect(request.getContextPath() + "/bibliotecario/libros/listar");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al eliminar el libro");
            }
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        }
    }
}
