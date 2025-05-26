package sena.adso.roles.controlador;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sena.adso.roles.dao.UsuarioDAO;
import sena.adso.roles.modelo.Usuario;

@WebServlet("/cambiar-password")
public class CambiarPasswordServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        request.setAttribute("nombre", usuario.getNombre());
        request.getRequestDispatcher("/WEB-INF/cambiar-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String passwordActual = request.getParameter("passwordActual");
        String passwordNuevo = request.getParameter("nuevaPassword");
        String passwordConfirmar = request.getParameter("confirmarPassword");
        
        try {
            // Validar campos obligatorios
            if (passwordActual == null || passwordActual.isEmpty() ||
                passwordNuevo == null || passwordNuevo.isEmpty() ||
                passwordConfirmar == null || passwordConfirmar.isEmpty()) {
                
                setMensajeError(request, "Todos los campos son obligatorios");
                mostrarFormulario(request, response, usuario);
                return;
            }
            
            // Validar contraseña actual
            Usuario usuarioValidado = usuarioDAO.validarUsuario(usuario.getEmail(), passwordActual);
            if (usuarioValidado == null) {
                setMensajeError(request, "La contraseña actual es incorrecta");
                mostrarFormulario(request, response, usuario);
                return;
            }
            
            // Validar nueva contraseña
            if (!passwordNuevo.equals(passwordConfirmar)) {
                setMensajeError(request, "Las nuevas contraseñas no coinciden");
                mostrarFormulario(request, response, usuario);
                return;
            }
            
            if (passwordNuevo.length() < 8) {
                setMensajeError(request, "La nueva contraseña debe tener al menos 8 caracteres");
                mostrarFormulario(request, response, usuario);
                return;
            }
            
            // Actualizar contraseña
            usuario.setPassword(passwordNuevo);
            if (usuarioDAO.actualizarPassword(usuario)) {
                session.setAttribute("usuario", usuario);
                
                // Redirigir según el rol
                String destino = usuario.esBibliotecario() ? "/admin/panel" : "/lector/panel";
                setMensajeExito(request, "Contraseña actualizada exitosamente");
                response.sendRedirect(request.getContextPath() + destino);
                return;
            } else {
                setMensajeError(request, "Error al actualizar la contraseña");
            }
            
        } catch (Exception e) {
            setMensajeError(request, "Error en el sistema. Por favor, intente más tarde");
            e.printStackTrace();
        }
        
        mostrarFormulario(request, response, usuario);
    }
    
    private void mostrarFormulario(HttpServletRequest request, 
                                 HttpServletResponse response, 
                                 Usuario usuario) 
            throws ServletException, IOException {
        request.setAttribute("nombre", usuario.getNombre());
        request.getRequestDispatcher("/WEB-INF/cambiar-password.jsp").forward(request, response);
    }
    
    private void setMensajeError(HttpServletRequest request, String mensaje) {
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipo", "danger");
    }
    
    private void setMensajeExito(HttpServletRequest request, String mensaje) {
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipo", "success");
    }
}