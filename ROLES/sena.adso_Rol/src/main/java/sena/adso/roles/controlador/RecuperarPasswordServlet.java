package sena.adso.roles.controlador;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sena.adso.roles.dao.UsuarioDAO;
import sena.adso.roles.modelo.Usuario;
import sena.adso.roles.util.EmailUtil;

@WebServlet("/auth/recuperar-password")
public class RecuperarPasswordServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/auth/recuperar-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String mensaje = "";

        // Validar que se haya proporcionado el email
        if (email == null || email.trim().isEmpty()) {
            mensaje = "Por favor, ingrese su correo electrónico";
            request.setAttribute("mensaje", mensaje);
            request.setAttribute("tipo", "danger");
            request.getRequestDispatcher("/WEB-INF/auth/recuperar-password.jsp").forward(request, response);
            return;
        }

        try {
            // Buscar usuario por email
            Usuario usuario = usuarioDAO.buscarPorEmail(email);
            
            if (usuario != null) {
                // Generar nueva contraseña temporal
                String nuevaPassword = EmailUtil.generarPasswordTemporal();
                
                // Actualizar contraseña en la base de datos
                usuario.setPassword(nuevaPassword);
                boolean actualizado = usuarioDAO.actualizarPassword(usuario);

                if (actualizado) {
                    // Enviar nueva contraseña por correo
                    boolean enviado = EmailUtil.enviarCorreoRecuperacion(email, nuevaPassword);
                    
                    if (enviado) {
                        mensaje = "Se ha enviado una nueva contraseña a su correo electrónico";
                        request.setAttribute("tipo", "success");
                    } else {
                        mensaje = "Error al enviar el correo. Por favor, contacte al administrador";
                        request.setAttribute("tipo", "danger");
                    }
                } else {
                    mensaje = "Error al actualizar la contraseña. Por favor, intente nuevamente";
                    request.setAttribute("tipo", "danger");
                }
            } else {
                // Por seguridad, no revelar si el email existe o no
                mensaje = "Si el correo está registrado, recibirá las instrucciones de recuperación";
                request.setAttribute("tipo", "info");
            }
            
        } catch (Exception e) {
            mensaje = "Error en el sistema. Por favor, intente más tarde";
            request.setAttribute("tipo", "danger");
            e.printStackTrace();
        }

        request.setAttribute("mensaje", mensaje);
        request.getRequestDispatcher("/WEB-INF/auth/recuperar-password.jsp").forward(request, response);
    }
}