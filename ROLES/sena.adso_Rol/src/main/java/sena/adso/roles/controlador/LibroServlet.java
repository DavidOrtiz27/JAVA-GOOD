package sena.adso.roles.controlador;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sena.adso.roles.dao.LibroDAO;
import sena.adso.roles.dao.PrestamoDAO;
import sena.adso.roles.modelo.Libro;
import sena.adso.roles.modelo.LibroFiccion;
import sena.adso.roles.modelo.LibroNoFiccion;
import sena.adso.roles.modelo.LibroReferencia;

@WebServlet("/admin/libros/*")
public class LibroServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private LibroDAO libroDAO;
	private PrestamoDAO prestamoDAO;

	@Override
	public void init() throws ServletException {
		super.init();
		libroDAO = new LibroDAO();
		prestamoDAO = new PrestamoDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("LibroServlet.doGet - Iniciando");
		String action = request.getPathInfo();
		System.out.println("Acción solicitada: " + action);

		try {
			// Si no hay acción específica, redirigir a listar
			if (action == null || action.equals("/")) {
				System.out.println("Redirigiendo a listar (acción no especificada)");
				response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
				return;
			}

			// Eliminar el slash inicial si existe
			if (action.startsWith("/")) {
				action = action.substring(1);
			}
			System.out.println("Acción procesada: " + action);

			switch (action) {
				case "listar":
					System.out.println("Procesando acción: listar");
					listarLibros(request, response);
					break;
				case "nuevo":
					System.out.println("Procesando acción: nuevo");
					mostrarFormularioNuevo(request, response);
					break;
				case "editar":
					System.out.println("Procesando acción: editar");
					mostrarFormularioEditar(request, response);
					break;
				case "ver":
					System.out.println("Procesando acción: ver");
					verLibro(request, response);
					break;
				default:
					System.out.println("Acción no reconocida: " + action);
					response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
					break;
			}
		} catch (SQLException e) {
			System.err.println("Error en doGet: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
			request.getRequestDispatcher("/WEB-INF/errors/500.jsp").forward(request, response);
		} catch (Exception e) {
			System.err.println("Error inesperado en doGet: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("error", "Error inesperado: " + e.getMessage());
			request.getRequestDispatcher("/WEB-INF/errors/500.jsp").forward(request, response);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("LibroServlet.doPost - Iniciando procesamiento de POST");
		request.setCharacterEncoding("UTF-8");
		String accion = request.getParameter("accion");
		System.out.println("Acción recibida: " + accion);

		try {
			if (accion == null || accion.trim().isEmpty()) {
				System.err.println("No se especificó una acción");
				request.getSession().setAttribute("mensaje", "No se especificó una acción");
				request.getSession().setAttribute("tipo", "danger");
				response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
				return;
			}

			switch (accion) {
				case "crear":
					System.out.println("Procesando acción: crear");
					crearLibro(request, response);
					break;
				case "actualizar":
					System.out.println("Procesando acción: actualizar");
					actualizarLibro(request, response);
					break;
				case "eliminar":
					System.out.println("Procesando acción: eliminar");
					eliminarLibro(request, response);
					break;
				default:
					System.err.println("Acción no reconocida: " + accion);
					request.getSession().setAttribute("mensaje", "Acción no reconocida: " + accion);
					request.getSession().setAttribute("tipo", "danger");
					response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
					break;
			}
		} catch (Exception e) {
			System.err.println("Error en doPost: " + e.getMessage());
			e.printStackTrace();
			request.getSession().setAttribute("mensaje", "Error al procesar la solicitud: " + e.getMessage());
			request.getSession().setAttribute("tipo", "danger");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		}
	}

	private void listarLibros(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		System.out.println("Listando libros...");
		try {
			List<Libro> libros = libroDAO.listarTodos();
			System.out.println("Libros encontrados: " + libros.size());
			request.setAttribute("libros", libros);
			request.getRequestDispatcher("/WEB-INF/admin/libros/listar.jsp").forward(request, response);
		} catch (SQLException e) {
			System.err.println("Error al listar libros: " + e.getMessage());
			e.printStackTrace();
			request.getSession().setAttribute("mensaje", "Error al cargar la lista de libros: " + e.getMessage());
			request.getSession().setAttribute("tipo", "danger");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		} catch (Exception e) {
			System.err.println("Error inesperado al listar libros: " + e.getMessage());
			e.printStackTrace();
			request.getSession().setAttribute("mensaje", "Error inesperado al cargar la lista de libros: " + e.getMessage());
			request.getSession().setAttribute("tipo", "danger");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		}
	}

	private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("LibroServlet.mostrarFormularioNuevo - Iniciando");
		try {
			// Limpiar cualquier atributo anterior
			request.removeAttribute("error");
			request.removeAttribute("libro");
			request.removeAttribute("tipo");
			request.removeAttribute("genero");
			request.removeAttribute("premiosLiterarios");
			request.removeAttribute("areaTematica");
			request.removeAttribute("publicoObjetivo");
			request.removeAttribute("campoAcademico");
			request.removeAttribute("consultaInterna");
			
			System.out.println("Redirigiendo a formulario de nuevo libro");
			String rutaJSP = "/WEB-INF/admin/libros/nuevo.jsp";
			System.out.println("Ruta del JSP: " + rutaJSP);
			
			// Verificar si el archivo existe
			File jspFile = new File(getServletContext().getRealPath(rutaJSP));
			if (!jspFile.exists()) {
				System.err.println("Error: El archivo JSP no existe en la ruta: " + jspFile.getAbsolutePath());
				throw new ServletException("El archivo JSP no existe: " + rutaJSP);
			}
			
			request.getRequestDispatcher(rutaJSP).forward(request, response);
		} catch (Exception e) {
			System.err.println("Error al mostrar formulario de nuevo libro: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		}
	}

	private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		System.out.println("LibroServlet.mostrarFormularioEditar - Iniciando");
		try {
			int id = Integer.parseInt(request.getParameter("id"));
			System.out.println("ID del libro a editar: " + id);
			
			Libro libro = libroDAO.buscarPorId(id);
			if (libro == null) {
				System.err.println("Libro no encontrado con ID: " + id);
				request.getSession().setAttribute("mensaje", "Libro no encontrado");
				request.getSession().setAttribute("tipo", "danger");
				response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
				return;
			}
			
			System.out.println("Libro encontrado: " + libro.getTitulo());
			System.out.println("Tipo de libro: " + libro.getTipoLibro());
			
			// Establecer el libro y su tipo
			request.setAttribute("libro", libro);
			request.getRequestDispatcher("/WEB-INF/admin/libros/editar.jsp").forward(request, response);
		} catch (NumberFormatException e) {
			System.err.println("Error al parsear ID: " + e.getMessage());
			request.getSession().setAttribute("mensaje", "ID de libro inválido");
			request.getSession().setAttribute("tipo", "danger");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		} catch (SQLException e) {
			System.err.println("Error de base de datos: " + e.getMessage());
			e.printStackTrace();
			request.getSession().setAttribute("mensaje", "Error al cargar el formulario de edición: " + e.getMessage());
			request.getSession().setAttribute("tipo", "danger");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		} catch (Exception e) {
			System.err.println("Error inesperado: " + e.getMessage());
			e.printStackTrace();
			request.getSession().setAttribute("mensaje", "Error inesperado al cargar el formulario de edición");
			request.getSession().setAttribute("tipo", "danger");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
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
				response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
				return;
			}
			System.out.println("Libro encontrado: " + libro.getTitulo());
			request.setAttribute("libro", libro);
			request.getRequestDispatcher("/WEB-INF/admin/libros/ver.jsp").forward(request, response);
		} catch (NumberFormatException e) {
			request.setAttribute("error", "ID de libro inválido");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		}
	}

	private void crearLibro(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
		System.out.println("Guardando nuevo libro...");
		String tipo = request.getParameter("tipo");
		System.out.println("Tipo de libro: " + tipo);

		try {
			// Validar longitud del ISBN
			String isbn = request.getParameter("isbn");
			if (isbn != null && isbn.length() > 13) {
				request.getSession().setAttribute("mensaje", "El ISBN no puede tener más de 13 caracteres");
				request.getSession().setAttribute("tipo", "danger");
				request.getRequestDispatcher("/WEB-INF/admin/libros/nuevo.jsp").forward(request, response);
				return;
			}

			Libro libro = crearLibroDesdeRequest(request, tipo);
			System.out.println("Libro creado: " + libro.getTitulo());
			
			if (libroDAO.existeIsbn(libro.getIsbn())) {
				request.getSession().setAttribute("mensaje", "Ya existe un libro con ese ISBN");
				request.getSession().setAttribute("tipo", "danger");
				request.getRequestDispatcher("/WEB-INF/admin/libros/nuevo.jsp").forward(request, response);
				return;
			}

			if (libroDAO.insertar(libro)) {
				request.getSession().setAttribute("mensaje", "Libro creado exitosamente");
				request.getSession().setAttribute("tipo", "success");
				response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
			} else {
				request.getSession().setAttribute("mensaje", "Error al guardar el libro");
				request.getSession().setAttribute("tipo", "danger");
				request.getRequestDispatcher("/WEB-INF/admin/libros/nuevo.jsp").forward(request, response);
			}
		} catch (SQLException e) {
			System.err.println("Error al guardar libro: " + e.getMessage());
			e.printStackTrace();
			request.getSession().setAttribute("mensaje", "Error al guardar el libro: " + e.getMessage());
			request.getSession().setAttribute("tipo", "danger");
			request.getRequestDispatcher("/WEB-INF/admin/libros/nuevo.jsp").forward(request, response);
		} catch (Exception e) {
			System.err.println("Error inesperado: " + e.getMessage());
			e.printStackTrace();
			request.getSession().setAttribute("mensaje", "Error inesperado al guardar el libro");
			request.getSession().setAttribute("tipo", "danger");
			request.getRequestDispatcher("/WEB-INF/admin/libros/nuevo.jsp").forward(request, response);
		}
	}

	private void actualizarLibro(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
		System.out.println("LibroServlet.actualizarLibro - Iniciando actualización");
		try {
			int id = Integer.parseInt(request.getParameter("id"));
			System.out.println("ID del libro a actualizar: " + id);
			
			String tipo = request.getParameter("tipo");
			System.out.println("Tipo de libro: " + tipo);
			
			// Imprimir todos los parámetros recibidos
			System.out.println("Parámetros recibidos:");
			System.out.println("- Título: " + request.getParameter("titulo"));
			System.out.println("- ISBN: " + request.getParameter("isbn"));
			System.out.println("- Autor: " + request.getParameter("autor"));
			System.out.println("- Ejemplares: " + request.getParameter("ejemplaresDisponibles"));
			System.out.println("- Tipo: " + tipo);
			
			if (tipo.equals("Ficcion")) {
				System.out.println("- Género: " + request.getParameter("genero"));
				System.out.println("- Premios: " + request.getParameter("premiosLiterarios"));
			} else if (tipo.equals("NoFiccion")) {
				System.out.println("- Área temática: " + request.getParameter("areaTematica"));
				System.out.println("- Público objetivo: " + request.getParameter("publicoObjetivo"));
			} else if (tipo.equals("Referencia")) {
				System.out.println("- Campo académico: " + request.getParameter("campoAcademico"));
				System.out.println("- Consulta interna: " + request.getParameter("consultaInterna"));
			}
			
			Libro libro = crearLibroDesdeRequest(request, tipo);
			libro.setId(id);
			
			System.out.println("Datos del libro a actualizar:");
			System.out.println("- Título: " + libro.getTitulo());
			System.out.println("- ISBN: " + libro.getIsbn());
			System.out.println("- Autor: " + libro.getAutor());
			System.out.println("- Ejemplares: " + libro.getEjemplaresDisponibles());
			
			// Intentar actualizar
			if (libroDAO.actualizar(libro)) {
				System.out.println("Libro actualizado exitosamente");
				request.setAttribute("mensaje", "Libro actualizado correctamente");
				request.setAttribute("tipo", "success");
				response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
			} else {
				System.err.println("Error al actualizar el libro en la base de datos");
				request.setAttribute("error", "Error al actualizar el libro");
				request.setAttribute("libro", libro);
				request.setAttribute("tipo", tipo);
				
				// Establecer atributos específicos según el tipo
				if (libro instanceof LibroFiccion) {
					LibroFiccion ficcion = (LibroFiccion) libro;
					request.setAttribute("genero", ficcion.getGenero());
					request.setAttribute("premiosLiterarios", ficcion.getPremiosLiterarios());
				} else if (libro instanceof LibroNoFiccion) {
					LibroNoFiccion noFiccion = (LibroNoFiccion) libro;
					request.setAttribute("areaTematica", noFiccion.getAreaTematica());
					request.setAttribute("publicoObjetivo", noFiccion.getPublicoObjetivo());
				} else if (libro instanceof LibroReferencia) {
					LibroReferencia referencia = (LibroReferencia) libro;
					request.setAttribute("campoAcademico", referencia.getCampoAcademico());
					request.setAttribute("consultaInterna", referencia.isConsultaInterna());
				}
				
				request.getRequestDispatcher("/WEB-INF/admin/libros/editar.jsp").forward(request, response);
			}
		} catch (NumberFormatException e) {
			System.err.println("Error al parsear ID: " + e.getMessage());
			request.setAttribute("error", "ID de libro inválido");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		} catch (SQLException e) {
			System.err.println("Error de base de datos: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("error", "Error al actualizar el libro: " + e.getMessage());
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		}
	}

	private void eliminarLibro(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		System.out.println("Eliminando libro...");
		try {
			int id = Integer.parseInt(request.getParameter("id"));
			System.out.println("ID del libro a eliminar: " + id);
			
			// Verificar si el libro existe
			Libro libro = libroDAO.buscarPorId(id);
			if (libro == null) {
				request.getSession().setAttribute("mensaje", "El libro no existe");
				request.getSession().setAttribute("tipo", "danger");
				response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
				return;
			}

			// Verificar si el libro tiene préstamos
			if (libroDAO.tienePrestamos(id)) {
				request.getSession().setAttribute("mensaje", "No se puede eliminar el libro porque tiene préstamos asociados. Primero debe devolver todos los préstamos.");
				request.getSession().setAttribute("tipo", "warning");
				response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
				return;
			}
			
			boolean resultado = libroDAO.eliminar(id);
			if (resultado) {
				request.getSession().setAttribute("mensaje", "Libro eliminado correctamente");
				request.getSession().setAttribute("tipo", "success");
			} else {
				request.getSession().setAttribute("mensaje", "Error al eliminar el libro");
				request.getSession().setAttribute("tipo", "danger");
			}
			
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		} catch (NumberFormatException e) {
			System.err.println("Error al parsear ID: " + e.getMessage());
			request.getSession().setAttribute("mensaje", "ID de libro inválido");
			request.getSession().setAttribute("tipo", "danger");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		} catch (SQLException e) {
			System.err.println("Error de base de datos: " + e.getMessage());
			e.printStackTrace();
			request.getSession().setAttribute("mensaje", "Error al eliminar el libro: " + e.getMessage());
			request.getSession().setAttribute("tipo", "danger");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		} catch (Exception e) {
			System.err.println("Error inesperado: " + e.getMessage());
			e.printStackTrace();
			request.getSession().setAttribute("mensaje", "Error inesperado al eliminar el libro");
			request.getSession().setAttribute("tipo", "danger");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		}
	}

	private Libro crearLibroDesdeRequest(HttpServletRequest request, String tipo) {
		System.out.println("LibroServlet.crearLibroDesdeRequest - Iniciando");
		System.out.println("Tipo de libro: " + tipo);
		
		String titulo = request.getParameter("titulo");
		String isbn = request.getParameter("isbn");
		String autor = request.getParameter("autor");
		int ejemplaresDisponibles = Integer.parseInt(request.getParameter("ejemplaresDisponibles"));
		
		System.out.println("Datos básicos:");
		System.out.println("- Título: " + titulo);
		System.out.println("- ISBN: " + isbn);
		System.out.println("- Autor: " + autor);
		System.out.println("- Ejemplares: " + ejemplaresDisponibles);

		Libro libro;
		switch (tipo) {
			case "Ficcion":
				System.out.println("Creando libro de ficción...");
				LibroFiccion ficcion = new LibroFiccion();
				ficcion.setTitulo(titulo);
				ficcion.setIsbn(isbn);
				ficcion.setAutor(autor);
				ficcion.setEjemplaresDisponibles(ejemplaresDisponibles);
				ficcion.setEjemplaresTotales(ejemplaresDisponibles);
				ficcion.setGenero(request.getParameter("genero"));
				ficcion.setPremiosLiterarios(request.getParameter("premiosLiterarios"));
				System.out.println("Campos específicos de ficción:");
				System.out.println("- Género: " + ficcion.getGenero());
				System.out.println("- Premios: " + ficcion.getPremiosLiterarios());
				libro = ficcion;
				break;
				
			case "NoFiccion":
				System.out.println("Creando libro de no ficción...");
				LibroNoFiccion noFiccion = new LibroNoFiccion();
				noFiccion.setTitulo(titulo);
				noFiccion.setIsbn(isbn);
				noFiccion.setAutor(autor);
				noFiccion.setEjemplaresDisponibles(ejemplaresDisponibles);
				noFiccion.setEjemplaresTotales(ejemplaresDisponibles);
				noFiccion.setAreaTematica(request.getParameter("areaTematica"));
				noFiccion.setPublicoObjetivo(request.getParameter("publicoObjetivo"));
				System.out.println("Campos específicos de no ficción:");
				System.out.println("- Área temática: " + noFiccion.getAreaTematica());
				System.out.println("- Público objetivo: " + noFiccion.getPublicoObjetivo());
				libro = noFiccion;
				break;
				
			case "Referencia":
				System.out.println("Creando libro de referencia...");
				LibroReferencia referencia = new LibroReferencia();
				referencia.setTitulo(titulo);
				referencia.setIsbn(isbn);
				referencia.setAutor(autor);
				referencia.setEjemplaresDisponibles(ejemplaresDisponibles);
				referencia.setEjemplaresTotales(ejemplaresDisponibles);
				referencia.setCampoAcademico(request.getParameter("campoAcademico"));
				referencia.setConsultaInterna(request.getParameter("consultaInterna") != null);
				System.out.println("Campos específicos de referencia:");
				System.out.println("- Campo académico: " + referencia.getCampoAcademico());
				System.out.println("- Consulta interna: " + referencia.isConsultaInterna());
				libro = referencia;
				break;
				
			default:
				System.err.println("Tipo de libro no válido: " + tipo);
				throw new IllegalArgumentException("Tipo de libro no válido: " + tipo);
		}

		libro.setTitulo(titulo);
		libro.setIsbn(isbn);
		libro.setAutor(autor);
		libro.setEjemplaresDisponibles(ejemplaresDisponibles);
		libro.setEjemplaresTotales(ejemplaresDisponibles);

		return libro;
	}

	private void editarLibro(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
		System.out.println("Editando libro...");
		try {
			int id = Integer.parseInt(request.getParameter("id"));
			System.out.println("ID del libro a editar: " + id);
			
			// Verificar si el libro existe
			Libro libro = libroDAO.buscarPorId(id);
			if (libro == null) {
				request.getSession().setAttribute("mensaje", "El libro no existe");
				request.getSession().setAttribute("tipo", "danger");
				response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
				return;
			}
			
			// Obtener los datos del formulario
			String titulo = request.getParameter("titulo");
			String autor = request.getParameter("autor");
			String isbn = request.getParameter("isbn");
			int ejemplaresTotales = Integer.parseInt(request.getParameter("ejemplares"));
			
			// Verificar si el ISBN ya existe para otro libro
			if (!isbn.equals(libro.getIsbn()) && libroDAO.existeIsbn(isbn)) {
				request.getSession().setAttribute("mensaje", "Ya existe un libro con ese ISBN");
				request.getSession().setAttribute("tipo", "danger");
				response.sendRedirect(request.getContextPath() + "/admin/libros/editar?id=" + id);
				return;
			}
			
			// Actualizar el libro
			libro.setTitulo(titulo);
			libro.setAutor(autor);
			libro.setIsbn(isbn);
			libro.setEjemplaresTotales(ejemplaresTotales);
			
			if (libroDAO.actualizar(libro)) {
				request.getSession().setAttribute("mensaje", "Libro actualizado correctamente");
				request.getSession().setAttribute("tipo", "success");
				response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
			} else {
				request.getSession().setAttribute("mensaje", "Error al actualizar el libro");
				request.getSession().setAttribute("tipo", "danger");
				response.sendRedirect(request.getContextPath() + "/admin/libros/editar?id=" + id);
			}
		} catch (NumberFormatException e) {
			System.err.println("Error al parsear ID: " + e.getMessage());
			request.getSession().setAttribute("mensaje", "ID de libro inválido");
			request.getSession().setAttribute("tipo", "danger");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		} catch (SQLException e) {
			System.err.println("Error de base de datos: " + e.getMessage());
			e.printStackTrace();
			request.getSession().setAttribute("mensaje", "Error al actualizar el libro: " + e.getMessage());
			request.getSession().setAttribute("tipo", "danger");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		} catch (Exception e) {
			System.err.println("Error inesperado: " + e.getMessage());
			e.printStackTrace();
			request.getSession().setAttribute("mensaje", "Error inesperado al actualizar el libro");
			request.getSession().setAttribute("tipo", "danger");
			response.sendRedirect(request.getContextPath() + "/admin/libros/listar");
		}
	}
}
