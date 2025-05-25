package sena.adso.roles.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import sena.adso.roles.modelo.Libro;
import sena.adso.roles.modelo.LibroFiccion;
import sena.adso.roles.modelo.LibroNoFiccion;
import sena.adso.roles.modelo.LibroReferencia;
import sena.adso.roles.util.ConexionBD;

public class LibroDAO {

    public List<Libro> listarTodos() throws SQLException {
        List<Libro> libros = new ArrayList<>();
        String sql = "SELECT * FROM libros ORDER BY titulo";
        
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Libro libro = crearLibroDesdeResultSet(rs);
                libro.setEjemplaresDisponibles(rs.getInt("ejemplares_disponibles"));
                libro.setEjemplaresTotales(rs.getInt("ejemplares_totales"));
                libros.add(libro);
            }
        }
        return libros;
    }

    public Libro buscarPorId(int id) throws SQLException {
        System.out.println("LibroDAO.buscarPorId - Iniciando búsqueda para ID: " + id);
        String sql = "SELECT * FROM libros WHERE id = ?";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            System.out.println("Ejecutando consulta SQL: " + sql);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println("Libro encontrado en la base de datos:");
                    System.out.println("- ID: " + rs.getInt("id"));
                    System.out.println("- Título: " + rs.getString("titulo"));
                    System.out.println("- Tipo: " + rs.getString("tipo"));
                    System.out.println("- Género: " + rs.getString("genero"));
                    System.out.println("- Premios: " + rs.getString("premios_literarios"));
                    System.out.println("- Área temática: " + rs.getString("area_tematica"));
                    System.out.println("- Público objetivo: " + rs.getString("publico_objetivo"));
                    System.out.println("- Campo académico: " + rs.getString("campo_academico"));
                    System.out.println("- Consulta interna: " + rs.getBoolean("consulta_interna"));
                    
                    return crearLibroDesdeResultSet(rs);
                }
            }
        }
        System.out.println("No se encontró ningún libro con ID: " + id);
        return null;
    }

    public List<Libro> buscarPorTitulo(String titulo) throws SQLException {
        List<Libro> libros = new ArrayList<>();
        String sql = "SELECT * FROM libros WHERE titulo LIKE ?";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + titulo + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    libros.add(crearLibroDesdeResultSet(rs));
                }
            }
        }
        return libros;
    }

    public boolean insertar(Libro libro) throws SQLException {
        String sql = "INSERT INTO libros (tipo, titulo, isbn, autor, ejemplares_disponibles, ejemplares_totales, prestado, " +
                    "genero, premios_literarios, area_tematica, publico_objetivo, campo_academico, consulta_interna) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            prepararStatement(stmt, libro);

            int filasAfectadas = stmt.executeUpdate();
            if (filasAfectadas > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        libro.setId(rs.getInt(1));
                    }
                }
                return true;
            }
            return false;
        }
    }

    public boolean actualizar(Libro libro) throws SQLException {
        System.out.println("LibroDAO.actualizar - Iniciando actualización");
        System.out.println("ID del libro: " + libro.getId());
        System.out.println("Tipo de libro: " + libro.getTipoLibro());
        
        if (libro.getId() <= 0) {
            System.err.println("Error: ID de libro inválido");
            return false;
        }

        String sql = "UPDATE libros SET titulo = ?, isbn = ?, autor = ?, ejemplares_disponibles = ?, " +
                    "tipo = ?, genero = ?, premios_literarios = ?, area_tematica = ?, " +
                    "publico_objetivo = ?, campo_academico = ?, consulta_interna = ? " +
                    "WHERE id = ?";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            System.out.println("Preparando sentencia SQL para actualización");
            
            // Parámetros básicos
            stmt.setString(1, libro.getTitulo());
            stmt.setString(2, libro.getIsbn());
            stmt.setString(3, libro.getAutor());
            stmt.setInt(4, libro.getEjemplaresDisponibles());
            
            // Parámetros específicos según el tipo
            String tipo = libro.getTipoLibro();
            stmt.setString(5, tipo);
            
            System.out.println("Datos a actualizar:");
            System.out.println("- Título: " + libro.getTitulo());
            System.out.println("- ISBN: " + libro.getIsbn());
            System.out.println("- Autor: " + libro.getAutor());
            System.out.println("- Ejemplares: " + libro.getEjemplaresDisponibles());
            System.out.println("- Tipo: " + tipo);
            
            if (tipo.equals("Ficcion")) {
                LibroFiccion ficcion = (LibroFiccion) libro;
                stmt.setString(6, ficcion.getGenero());
                stmt.setString(7, ficcion.getPremiosLiterarios());
                stmt.setNull(8, Types.VARCHAR);
                stmt.setNull(9, Types.VARCHAR);
                stmt.setNull(10, Types.VARCHAR);
                stmt.setNull(11, Types.BOOLEAN);
                System.out.println("- Género: " + ficcion.getGenero());
                System.out.println("- Premios: " + ficcion.getPremiosLiterarios());
            } else if (tipo.equals("NoFiccion")) {
                LibroNoFiccion noFiccion = (LibroNoFiccion) libro;
                stmt.setNull(6, Types.VARCHAR);
                stmt.setNull(7, Types.VARCHAR);
                stmt.setString(8, noFiccion.getAreaTematica());
                stmt.setString(9, noFiccion.getPublicoObjetivo());
                stmt.setNull(10, Types.VARCHAR);
                stmt.setNull(11, Types.BOOLEAN);
                System.out.println("- Área temática: " + noFiccion.getAreaTematica());
                System.out.println("- Público objetivo: " + noFiccion.getPublicoObjetivo());
            } else if (tipo.equals("Referencia")) {
                LibroReferencia referencia = (LibroReferencia) libro;
                stmt.setNull(6, Types.VARCHAR);
                stmt.setNull(7, Types.VARCHAR);
                stmt.setNull(8, Types.VARCHAR);
                stmt.setNull(9, Types.VARCHAR);
                stmt.setString(10, referencia.getCampoAcademico());
                stmt.setBoolean(11, referencia.isConsultaInterna());
                System.out.println("- Campo académico: " + referencia.getCampoAcademico());
                System.out.println("- Consulta interna: " + referencia.isConsultaInterna());
            }
            
            // ID del libro
            stmt.setInt(12, libro.getId());
            
            System.out.println("Ejecutando actualización...");
            int filasAfectadas = stmt.executeUpdate();
            System.out.println("Filas afectadas: " + filasAfectadas);
            
            return filasAfectadas > 0;
        } catch (SQLException e) {
            System.err.println("Error SQL al actualizar libro: " + e.getMessage());
            System.err.println("Código de error: " + e.getErrorCode());
            System.err.println("Estado SQL: " + e.getSQLState());
            e.printStackTrace();
            throw e;
        }
    }

    public boolean eliminar(int id) throws SQLException {
        String sql = "DELETE FROM libros WHERE id = ?";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean existeIsbn(String isbn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM libros WHERE isbn = ?";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, isbn);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean tienePrestamosActivos(int libroId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM prestamos WHERE libro_id = ? AND estado = 'ACTIVO'";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, libroId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    private Libro crearLibroDesdeResultSet(ResultSet rs) throws SQLException {
        System.out.println("LibroDAO.crearLibroDesdeResultSet - Iniciando");
        String tipo = rs.getString("tipo");
        System.out.println("Tipo de libro desde BD: " + tipo);
        
        Libro libro = null;

        // Propiedades comunes
        int id = rs.getInt("id");
        String titulo = rs.getString("titulo");
        String isbn = rs.getString("isbn");
        String autor = rs.getString("autor");
        int ejemplaresDisponibles = rs.getInt("ejemplares_disponibles");
        boolean prestado = rs.getBoolean("prestado");

        System.out.println("Datos básicos del libro:");
        System.out.println("- ID: " + id);
        System.out.println("- Título: " + titulo);
        System.out.println("- ISBN: " + isbn);
        System.out.println("- Autor: " + autor);
        System.out.println("- Ejemplares: " + ejemplaresDisponibles);
        System.out.println("- Prestado: " + prestado);

        switch (tipo) {
            case "Ficcion":
                System.out.println("Creando LibroFiccion");
                LibroFiccion ficcion = new LibroFiccion();
                String genero = rs.getString("genero");
                String premios = rs.getString("premios_literarios");
                System.out.println("Datos específicos de ficción:");
                System.out.println("- Género: " + genero);
                System.out.println("- Premios: " + premios);
                
                ficcion.setId(id);
                ficcion.setTitulo(titulo);
                ficcion.setIsbn(isbn);
                ficcion.setAutor(autor);
                ficcion.setEjemplaresDisponibles(ejemplaresDisponibles);
                ficcion.setPrestado(prestado);
                ficcion.setGenero(genero != null ? genero : "");
                ficcion.setPremiosLiterarios(premios != null ? premios : "");
                
                libro = ficcion;
                break;
                
            case "NoFiccion":
                System.out.println("Creando LibroNoFiccion");
                LibroNoFiccion noFiccion = new LibroNoFiccion();
                String areaTematica = rs.getString("area_tematica");
                String publicoObjetivo = rs.getString("publico_objetivo");
                System.out.println("Datos específicos de no ficción:");
                System.out.println("- Área temática: " + areaTematica);
                System.out.println("- Público objetivo: " + publicoObjetivo);
                
                noFiccion.setId(id);
                noFiccion.setTitulo(titulo);
                noFiccion.setIsbn(isbn);
                noFiccion.setAutor(autor);
                noFiccion.setEjemplaresDisponibles(ejemplaresDisponibles);
                noFiccion.setPrestado(prestado);
                noFiccion.setAreaTematica(areaTematica != null ? areaTematica : "");
                noFiccion.setPublicoObjetivo(publicoObjetivo != null ? publicoObjetivo : "");
                
                libro = noFiccion;
                break;
                
            case "Referencia":
                System.out.println("Creando LibroReferencia");
                LibroReferencia referencia = new LibroReferencia();
                String campoAcademico = rs.getString("campo_academico");
                boolean consultaInterna = rs.getBoolean("consulta_interna");
                System.out.println("Datos específicos de referencia:");
                System.out.println("- Campo académico: " + campoAcademico);
                System.out.println("- Consulta interna: " + consultaInterna);
                
                referencia.setId(id);
                referencia.setTitulo(titulo);
                referencia.setIsbn(isbn);
                referencia.setAutor(autor);
                referencia.setEjemplaresDisponibles(ejemplaresDisponibles);
                referencia.setPrestado(prestado);
                referencia.setCampoAcademico(campoAcademico != null ? campoAcademico : "");
                referencia.setConsultaInterna(consultaInterna);
                
                libro = referencia;
                break;
                
            default:
                System.err.println("Tipo de libro desconocido: " + tipo);
                throw new SQLException("Tipo de libro desconocido: " + tipo);
        }

        System.out.println("Libro creado exitosamente:");
        System.out.println("- ID: " + libro.getId());
        System.out.println("- Título: " + libro.getTitulo());
        System.out.println("- Tipo: " + libro.getTipoLibro());

        return libro;
    }

    private void prepararStatement(PreparedStatement stmt, Libro libro) throws SQLException {
        System.out.println("Preparando statement para el libro...");
        stmt.setString(1, libro.getTipoLibro());
        stmt.setString(2, libro.getTitulo());
        stmt.setString(3, libro.getIsbn());
        stmt.setString(4, libro.getAutor());
        stmt.setInt(5, libro.getEjemplaresDisponibles());
        stmt.setInt(6, libro.getEjemplaresTotales());
        stmt.setBoolean(7, libro.isPrestado());

        // Establecer todos los campos específicos como NULL primero
        stmt.setNull(8, Types.VARCHAR);  // genero
        stmt.setNull(9, Types.VARCHAR);  // premios_literarios
        stmt.setNull(10, Types.VARCHAR); // area_tematica
        stmt.setNull(11, Types.VARCHAR); // publico_objetivo
        stmt.setNull(12, Types.VARCHAR); // campo_academico
        stmt.setNull(13, Types.BOOLEAN); // consulta_interna

        // Luego establecer los campos específicos según el tipo
        if (libro instanceof LibroFiccion) {
            System.out.println("Configurando campos para LibroFiccion");
            LibroFiccion ficcion = (LibroFiccion) libro;
            stmt.setString(8, ficcion.getGenero());
            stmt.setString(9, ficcion.getPremiosLiterarios());
        } else if (libro instanceof LibroNoFiccion) {
            System.out.println("Configurando campos para LibroNoFiccion");
            LibroNoFiccion noFiccion = (LibroNoFiccion) libro;
            stmt.setString(10, noFiccion.getAreaTematica());
            stmt.setString(11, noFiccion.getPublicoObjetivo());
        } else if (libro instanceof LibroReferencia) {
            System.out.println("Configurando campos para LibroReferencia");
            LibroReferencia referencia = (LibroReferencia) libro;
            stmt.setString(12, referencia.getCampoAcademico());
            stmt.setBoolean(13, referencia.isConsultaInterna());
        }
    }

    public List<Libro> listarDisponibles() throws SQLException {
        List<Libro> libros = new ArrayList<>();
        String sql = "SELECT * FROM libros WHERE ejemplares_disponibles > 0";

        try (Connection conn = ConexionBD.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                libros.add(crearLibroDesdeResultSet(rs));
            }
        }
        return libros;
    }

    public boolean estaDisponible(int libroId) throws SQLException {
        String sql = "SELECT ejemplares_disponibles FROM libros WHERE id = ?";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, libroId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("ejemplares_disponibles") > 0;
                }
            }
        }
        return false;
    }

    public void actualizarDisponibilidad(int libroId, boolean disponible) throws SQLException {
        String sql = "UPDATE libros SET ejemplares_disponibles = ejemplares_disponibles + ? WHERE id = ?";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, disponible ? 1 : -1);
            stmt.setInt(2, libroId);

            stmt.executeUpdate();
        }
    }

    public int contarTotal() throws SQLException {
        String sql = "SELECT COUNT(*) FROM libros";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        }
    }

    public List<Libro> buscarPorTermino(String termino) throws SQLException {
        List<Libro> libros = new ArrayList<>();
        String sql = "SELECT * FROM libros WHERE LOWER(titulo) LIKE LOWER(?) OR LOWER(autor) LIKE LOWER(?) OR LOWER(isbn) LIKE LOWER(?)";
        
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String terminoBusqueda = "%" + termino + "%";
            stmt.setString(1, terminoBusqueda);
            stmt.setString(2, terminoBusqueda);
            stmt.setString(3, terminoBusqueda);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    libros.add(crearLibroDesdeResultSet(rs));
                }
            }
        }
        return libros;
    }
}