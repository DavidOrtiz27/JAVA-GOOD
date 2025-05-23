package sena.adso.roles.dao;

import sena.adso.roles.modelo.*;
import sena.adso.roles.util.ConexionBD;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LibroDAO {

    public List<Libro> listarTodos() throws SQLException {
        List<Libro> libros = new ArrayList<>();
        String sql = "SELECT * FROM libros";

        try (Connection conn = ConexionBD.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                libros.add(crearLibroDesdeResultSet(rs));
            }
        }
        return libros;
    }

    public Libro buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM libros WHERE id = ?";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return crearLibroDesdeResultSet(rs);
                }
            }
        }
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
        String sql = "INSERT INTO libros (tipo, titulo, isbn, autor, ejemplares_disponibles, prestado, " +
                    "genero, premios_literarios, area_tematica, publico_objetivo, campo_academico, consulta_interna) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
        String sql = "UPDATE libros SET tipo = ?, titulo = ?, isbn = ?, autor = ?, " +
                    "ejemplares_disponibles = ?, prestado = ?, genero = ?, premios_literarios = ?, " +
                    "area_tematica = ?, publico_objetivo = ?, campo_academico = ?, consulta_interna = ? " +
                    "WHERE id = ?";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            prepararStatement(stmt, libro);
            stmt.setInt(13, libro.getId());

            return stmt.executeUpdate() > 0;
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
        Libro libro;
        String tipo = rs.getString("tipo");
        String titulo = rs.getString("titulo");
        String isbn = rs.getString("isbn");
        String autor = rs.getString("autor");
        int ejemplaresDisponibles = rs.getInt("ejemplares_disponibles");

        switch (tipo) {
            case "Ficcion":
                libro = new LibroFiccion(titulo, isbn, autor, ejemplaresDisponibles,
                        rs.getString("genero"), rs.getString("premios_literarios"));
                break;
            case "NoFiccion":
                libro = new LibroNoFiccion(titulo, isbn, autor, ejemplaresDisponibles,
                        rs.getString("area_tematica"), rs.getString("publico_objetivo"));
                break;
            case "Referencia":
                libro = new LibroReferencia(titulo, isbn, autor, ejemplaresDisponibles,
                        rs.getString("campo_academico"), rs.getBoolean("consulta_interna"));
                break;
            default:
                return null;
        }

        libro.setId(rs.getInt("id"));
        libro.setPrestado(rs.getBoolean("prestado"));
        return libro;
    }

private void prepararStatement(PreparedStatement stmt, Libro libro) throws SQLException {
    stmt.setString(1, libro.getTipoLibro());
    stmt.setString(2, libro.getTitulo());
    stmt.setString(3, libro.getIsbn());
    stmt.setString(4, libro.getAutor());
    stmt.setInt(5, libro.getEjemplaresDisponibles());
    stmt.setBoolean(6, libro.isPrestado());

    // Establecer todos los campos específicos como NULL primero
    stmt.setNull(7, Types.VARCHAR);  // genero
    stmt.setNull(8, Types.VARCHAR);  // premios_literarios
    stmt.setNull(9, Types.VARCHAR);  // area_tematica
    stmt.setNull(10, Types.VARCHAR); // publico_objetivo
    stmt.setNull(11, Types.VARCHAR); // campo_academico
    stmt.setNull(12, Types.BOOLEAN); // consulta_interna

    // Luego establecer los campos específicos según el tipo
    if (libro instanceof LibroFiccion) {
        LibroFiccion ficcion = (LibroFiccion) libro;
        stmt.setString(7, ficcion.getGenero());
        stmt.setString(8, ficcion.getPremiosLiterarios());
    } else if (libro instanceof LibroNoFiccion) {
        LibroNoFiccion noFiccion = (LibroNoFiccion) libro;
        stmt.setString(9, noFiccion.getAreaTematica());
        stmt.setString(10, noFiccion.getPublicoObjetivo());
    } else if (libro instanceof LibroReferencia) {
        LibroReferencia referencia = (LibroReferencia) libro;
        stmt.setString(11, referencia.getCampoAcademico());
        stmt.setBoolean(12, referencia.isConsultaInterna());
    }
}

    public List<Libro> listarDisponibles() throws SQLException {
        List<Libro> libros = new ArrayList<>();
        String sql = "SELECT * FROM libros WHERE ejemplares_disponibles > 0 AND prestado = false";

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
        String sql = "SELECT ejemplares_disponibles, prestado FROM libros WHERE id = ?";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, libroId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("ejemplares_disponibles") > 0 && !rs.getBoolean("prestado");
                }
            }
        }
        return false;
    }

    public void actualizarDisponibilidad(int libroId, boolean disponible) throws SQLException {
        String sql = "UPDATE libros SET prestado = ?, ejemplares_disponibles = ejemplares_disponibles + ? WHERE id = ?";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, !disponible);
            stmt.setInt(2, disponible ? 1 : -1);
            stmt.setInt(3, libroId);

            stmt.executeUpdate();
        }
    }
}