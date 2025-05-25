package sena.adso.roles.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase utilitaria para gestionar la conexión a la base de datos MySQL
 */
public class ConexionBD {
    // Parámetros de conexión
    private static final String JDBC_URL = "jdbc:mysql://localhost:3307/biblioteca?useSSL=false&serverTimezone=UTC";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "";
    
    /**
     * Establece y retorna una conexión a la base de datos
     * @return Objeto Connection con la conexión establecida
     * @throws SQLException si ocurre un error al conectar
     */
    public static Connection getConnection() throws SQLException {
        try {
            System.out.println("=== Iniciando conexión a la base de datos XAMPP ===");
            System.out.println("URL: " + JDBC_URL);
            System.out.println("Usuario: " + JDBC_USER);
            
            // Registrar el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✓ Driver MySQL cargado correctamente");
            
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            System.out.println("✓ Conexión establecida correctamente con XAMPP MySQL");
            return conn;
        } catch (ClassNotFoundException ex) {
            System.out.println("✗ Error al cargar el driver de MySQL: " + ex.getMessage());
            throw new SQLException("Error al cargar el driver de MySQL", ex);
        } catch (SQLException ex) {
            System.out.println("✗ Error al conectar a la base de datos XAMPP: " + ex.getMessage());
            System.out.println("Código de error SQL: " + ex.getErrorCode());
            System.out.println("Estado SQL: " + ex.getSQLState());
            throw ex;
        }
    }
    
    /**
     * Cierra una conexión a la base de datos
     * @param conn Conexión a cerrar
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("✓ Conexión cerrada correctamente");
            } catch (SQLException ex) {
                System.out.println("✗ Error al cerrar la conexión: " + ex.getMessage());
            }
        }
    }
}