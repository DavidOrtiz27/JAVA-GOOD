package sena.adso.roles.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sena.adso.roles.dao.UsuarioDAO;
import sena.adso.roles.modelo.Usuario;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/admin/usuarios/*"})
public class UsuarioServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = extraerAccion(request);
        
        try {
            switch (accion) {
                case "listar":
                    listarUsuarios(request, response);
                    break;
                case "nuevo":
                    mostrarFormularioNuevo(request, response);
                    break;
                case "editar":
                    mostrarFormularioEditar(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            manejarError(request, response, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = extraerAccion(request);
        
        try {
            switch (accion) {
                case "crear":
                    crearUsuario(request, response);
                    break;
                case "actualizar":
                    actualizarUsuario(request, response);
                    break;
                case "eliminar":
                    eliminarUsuario(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            manejarError(request, response, e);
        }
    }
    
    private String extraerAccion(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            return "listar";
        }
        return pathInfo.substring(1);
    }
    
    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Usuario> todosUsuarios = usuarioDAO.listarUsuarios();
        
        // Agrupar usuarios por rol
        List<Usuario> bibliotecarios = todosUsuarios.stream()
            .filter(u -> "bibliotecario".equalsIgnoreCase(u.getRol()))
            .collect(Collectors.toList());
            
        List<Usuario> lectores = todosUsuarios.stream()
            .filter(u -> "lector".equalsIgnoreCase(u.getRol()))
            .collect(Collectors.toList());
            
        List<Usuario> administradores = todosUsuarios.stream()
            .filter(u -> "admin".equalsIgnoreCase(u.getRol()))
            .collect(Collectors.toList());
        
        request.setAttribute("bibliotecarios", bibliotecarios);
        request.setAttribute("lectores", lectores);
        request.setAttribute("administradores", administradores);
        request.getRequestDispatcher("/WEB-INF/admin/usuarios/listar.jsp").forward(request, response);
    }

    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/admin/usuarios/nuevo.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Usuario usuario = usuarioDAO.buscarPorId(id);
        if (usuario != null) {
            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("/WEB-INF/admin/usuarios/editar.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios/listar");
        }
    }

    private void crearUsuario(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rol = request.getParameter("rol");

        if (validarCampos(nombre, email, password, rol)) {
            Usuario usuario = new Usuario();
            usuario.setNombre(nombre);
            usuario.setEmail(email);
            usuario.setPassword(password);
            usuario.setRol(rol);

            boolean resultado = usuarioDAO.registrarUsuario(usuario);
            if (resultado) {
                setMensajeExito(request, "Usuario creado correctamente");
            } else {
                setMensajeError(request, "Error al crear el usuario");
            }
        } else {
            setMensajeError(request, "Todos los campos son obligatorios");
        }
        response.sendRedirect(request.getContextPath() + "/admin/usuarios/listar");
    }

    private void actualizarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String rol = request.getParameter("rol");

        if (validarCampos(nombre, email, rol)) {
            Usuario usuario = new Usuario();
            usuario.setId(id);
            usuario.setNombre(nombre);
            usuario.setEmail(email);
            usuario.setRol(rol);

            boolean resultado = usuarioDAO.actualizarUsuario(usuario);
            if (resultado) {
                setMensajeExito(request, "Usuario actualizado correctamente");
            } else {
                setMensajeError(request, "Error al actualizar el usuario");
            }
        } else {
            setMensajeError(request, "Todos los campos son obligatorios");
        }
        response.sendRedirect(request.getContextPath() + "/admin/usuarios/listar");
    }

    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Verificar que el usuario no sea el último administrador
        Usuario usuarioAEliminar = usuarioDAO.buscarPorId(id);
        if (usuarioAEliminar != null && "admin".equalsIgnoreCase(usuarioAEliminar.getRol())) {
            List<Usuario> administradores = usuarioDAO.buscarPorRol("admin");
            if (administradores.size() <= 1) {
                request.setAttribute("mensaje", "No se puede eliminar el último administrador del sistema");
                request.setAttribute("tipo", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/usuarios/listar");
                return;
            }
        }
        
        boolean resultado = usuarioDAO.eliminarUsuario(id);
        if (resultado) {
            request.setAttribute("mensaje", "Usuario eliminado correctamente");
            request.setAttribute("tipo", "success");
        } else {
            request.setAttribute("mensaje", "Error al eliminar el usuario");
            request.setAttribute("tipo", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/admin/usuarios/listar");
    }
    
    private boolean validarCampos(String... campos) {
        for (String campo : campos) {
            if (campo == null || campo.trim().isEmpty()) {
                return false;
            }
        }
        return true;
    }
    
    private void setMensajeError(HttpServletRequest request, String mensaje) {
        request.getSession().setAttribute("mensaje", mensaje);
        request.getSession().setAttribute("tipo", "danger");
    }
    
    private void setMensajeExito(HttpServletRequest request, String mensaje) {
        request.getSession().setAttribute("mensaje", mensaje);
        request.getSession().setAttribute("tipo", "success");
    }
    
    private void manejarError(HttpServletRequest request, HttpServletResponse response, SQLException e)
            throws ServletException, IOException {
        e.printStackTrace();
        setMensajeError(request, "Error en la base de datos. Por favor, inténtelo más tarde.");
        request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
    }
}