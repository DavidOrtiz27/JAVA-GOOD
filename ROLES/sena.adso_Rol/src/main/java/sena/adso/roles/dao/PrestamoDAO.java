package sena.adso.roles.dao;

import sena.adso.roles.modelo.Prestamo;
import sena.adso.roles.util.ConexionBD;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PrestamoDAO {
    
    // Listar todos los préstamos (activos y devueltos)
    public List<Prestamo> listarTodos() throws SQLException {
        List<Prestamo> prestamos = new ArrayList<>();
        String sql = "SELECT p.*, l.titulo as titulo_libro, u.nombre as nombre_usuario " +
                    "FROM prestamos p " +
                    "JOIN libros l ON p.libro_id = l.id " +
                    "JOIN usuarios u ON p.usuario_id = u.id " +
                    "ORDER BY p.fecha_prestamo DESC";
        
        try (Connection conn = ConexionBD.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                prestamos.add(crearPrestamoDesdeResultSet(rs));
            }
        }
        return prestamos;
    }
    
    // Listar préstamos de un usuario específico
    public List<Prestamo> listarPorUsuario(int usuarioId) throws SQLException {
        List<Prestamo> prestamos = new ArrayList<>();
        String sql = "SELECT p.*, l.titulo as titulo_libro, u.nombre as nombre_usuario " +
                    "FROM prestamos p " +
                    "JOIN libros l ON p.libro_id = l.id " +
                    "JOIN usuarios u ON p.usuario_id = u.id " +
                    "WHERE p.usuario_id = ? AND p.estado = 'ACTIVO' " +
                    "ORDER BY p.fecha_prestamo DESC";
        
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    prestamos.add(crearPrestamoDesdeResultSet(rs));
                }
            }
        }
        return prestamos;
    }
    
    // Crear nuevo préstamo
    public boolean crear(Prestamo prestamo) throws SQLException {
        String sql = "INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, estado) " +
                    "VALUES (?, ?, ?, 'ACTIVO')";
        
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, prestamo.getLibroId());
            stmt.setInt(2, prestamo.getUsuarioId());
            stmt.setDate(3, prestamo.getFechaPrestamo());
            
            int filasAfectadas = stmt.executeUpdate();
            if (filasAfectadas > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        prestamo.setId(rs.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        }
    }
    
    // Actualizar préstamo (usado para devoluciones)
    public boolean actualizar(Prestamo prestamo) throws SQLException {
        String sql = "UPDATE prestamos SET fecha_devolucion = ?, estado = ? WHERE id = ?";
        
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, prestamo.getFechaDevolucion());
            stmt.setString(2, prestamo.getEstado());
            stmt.setInt(3, prestamo.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    // Buscar préstamo por ID
    public Prestamo buscarPorId(int id) throws SQLException {
        String sql = "SELECT p.*, l.titulo as titulo_libro, u.nombre as nombre_usuario " +
                    "FROM prestamos p " +
                    "JOIN libros l ON p.libro_id = l.id " +
                    "JOIN usuarios u ON p.usuario_id = u.id " +
                    "WHERE p.id = ?";
        
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return crearPrestamoDesdeResultSet(rs);
                }
            }
        }
        return null;
    }
    
    // Verificar préstamos pendientes
    public boolean tienePrestamosPendientes(int usuarioId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM prestamos WHERE usuario_id = ? AND estado = 'ACTIVO'";
        
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    private Prestamo crearPrestamoDesdeResultSet(ResultSet rs) throws SQLException {
        Prestamo prestamo = new Prestamo();
        prestamo.setId(rs.getInt("id"));
        prestamo.setLibroId(rs.getInt("libro_id"));
        prestamo.setUsuarioId(rs.getInt("usuario_id"));
        prestamo.setFechaPrestamo(rs.getDate("fecha_prestamo"));
        prestamo.setFechaDevolucion(rs.getDate("fecha_devolucion"));
        prestamo.setEstado(rs.getString("estado"));
        prestamo.setTituloLibro(rs.getString("titulo_libro"));
        prestamo.setNombreUsuario(rs.getString("nombre_usuario"));
        return prestamo;
    }

    public List<Prestamo> listarHistorialCompleto() throws SQLException {
        List<Prestamo> prestamos = new ArrayList<>();
        String sql = "SELECT p.*, l.titulo as titulo_libro, u.nombre as nombre_usuario " +
                    "FROM prestamos p " +
                    "JOIN libros l ON p.libro_id = l.id " +
                    "JOIN usuarios u ON p.usuario_id = u.id " +
                    "WHERE p.estado = 'DEVUELTO' " +
                    "ORDER BY p.fecha_devolucion DESC";
        
        try (Connection conn = ConexionBD.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                prestamos.add(crearPrestamoDesdeResultSet(rs));
            }
        }
        return prestamos;
    }

    public List<Prestamo> listarHistorialUsuario(int usuarioId) throws SQLException {
        List<Prestamo> prestamos = new ArrayList<>();
        String sql = "SELECT p.*, l.titulo as titulo_libro, u.nombre as nombre_usuario " +
                    "FROM prestamos p " +
                    "JOIN libros l ON p.libro_id = l.id " +
                    "JOIN usuarios u ON p.usuario_id = u.id " +
                    "WHERE p.usuario_id = ? AND p.estado = 'DEVUELTO' " +
                    "ORDER BY p.fecha_devolucion DESC";
        
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    prestamos.add(crearPrestamoDesdeResultSet(rs));
                }
            }
        }
        return prestamos;
    }
}