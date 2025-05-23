package sena.adso.roles.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import sena.adso.roles.modelo.Usuario;
import sena.adso.roles.dao.UsuarioDAO;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/bibliotecario/inicio/*"})
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
        List<Usuario> usuarios = usuarioDAO.listarUsuarios();
        request.setAttribute("usuarios", usuarios);
        request.getRequestDispatcher("/bibliotecario/usuarios.jsp").forward(request, response);
    }
    
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Usuario usuario = usuarioDAO.buscarPorId(id);
            
            if (usuario != null) {
                request.setAttribute("usuario", usuario);
                request.getRequestDispatcher("/WEB-INF/bibliotecario/editar-usuario.jsp").forward(request, response);
            } else {
                setMensajeError(request, "Usuario no encontrado");
                listarUsuarios(request, response);
            }
        } catch (NumberFormatException e) {
            setMensajeError(request, "ID de usuario inválido");
            listarUsuarios(request, response);
        }
    }
    
    private void actualizarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String rol = request.getParameter("rol");
        
        if (!validarCampos(nombre, email, rol)) {
            setMensajeError(request, "Todos los campos son obligatorios");
            mostrarFormularioEditar(request, response);
            return;
        }
        
        Usuario usuario = usuarioDAO.buscarPorId(id);
        if (usuario != null) {
            usuario.setNombre(nombre);
            usuario.setEmail(email);
            usuario.setRol(rol);
            
            if (usuarioDAO.actualizarUsuario(usuario)) {
                setMensajeExito(request, "Usuario actualizado correctamente");
            } else {
                setMensajeError(request, "Error al actualizar el usuario");
            }
        } else {
            setMensajeError(request, "Usuario no encontrado");
        }
        
        listarUsuarios(request, response);
    }
    
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            if (usuarioDAO.eliminarUsuario(id)) {
                setMensajeExito(request, "Usuario eliminado correctamente");
            } else {
                setMensajeError(request, "Error al eliminar el usuario");
            }
        } catch (NumberFormatException e) {
            setMensajeError(request, "ID de usuario inválido");
        }
        
        listarUsuarios(request, response);
    }
    
    private boolean validarCampos(String nombre, String email, String rol) {
        return nombre != null && !nombre.trim().isEmpty() &&
               email != null && !email.trim().isEmpty() &&
               rol != null && !rol.trim().isEmpty();
    }
    
    private void setMensajeError(HttpServletRequest request, String mensaje) {
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipo", "danger");
    }
    
    private void setMensajeExito(HttpServletRequest request, String mensaje) {
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipo", "success");
    }
    
    private void manejarError(HttpServletRequest request, HttpServletResponse response, SQLException e)
            throws ServletException, IOException {
        e.printStackTrace();
        setMensajeError(request, "Error en la base de datos. Por favor, inténtelo más tarde.");
        request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
    }
}