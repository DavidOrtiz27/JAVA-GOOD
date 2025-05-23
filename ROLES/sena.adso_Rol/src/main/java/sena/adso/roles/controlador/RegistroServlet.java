package sena.adso.roles.controlador;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sena.adso.roles.dao.UsuarioDAO;
import sena.adso.roles.modelo.Usuario;
import sena.adso.roles.modelo.RolUsuario;
import sena.adso.roles.util.EmailUtil;

@WebServlet(name = "RegistroServlet", urlPatterns = {"/auth/registro"})
public class RegistroServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/auth/registro.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String rol = request.getParameter("rol");

        try {
            // Validar campos obligatorios
            if (!validarCampos(nombre, email, rol)) {
                setMensajeError(request, "Por favor, complete todos los campos del formulario");
                request.getRequestDispatcher("/WEB-INF/auth/registro.jsp").forward(request, response);
                return;
            }

            // Validar rol
            if (!validarRol(rol)) {
                setMensajeError(request, "El rol seleccionado no es válido");
                request.getRequestDispatcher("/WEB-INF/auth/registro.jsp").forward(request, response);
                return;
            }

            // Verificar si el email ya existe
            if (usuarioDAO.existeEmail(email)) {
                setMensajeError(request, "El correo electrónico ya está registrado");
                request.getRequestDispatcher("/WEB-INF/auth/registro.jsp").forward(request, response);
                return;
            }

            // Generar contraseña temporal
            String password = EmailUtil.generarPasswordTemporal();

            // Crear y registrar nuevo usuario
            Usuario nuevoUsuario = new Usuario(nombre, email, password, rol);
            boolean registrado = usuarioDAO.registrarUsuario(nuevoUsuario);

            if (registrado) {
                // Enviar credenciales por correo
                boolean enviado = EmailUtil.enviarCredencialesRegistro(email, nombre, password);

                if (enviado) {
                    setMensajeExito(request,
                        "Registro exitoso. Se han enviado las credenciales a su correo electrónico");
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                } else {
                    setMensajeAdvertencia(request,
                        "Registro exitoso, pero hubo un problema al enviar las credenciales por correo");
                }
            } else {
                setMensajeError(request, "Error al registrar el usuario. Por favor, intente nuevamente");
            }

        } catch (SQLException e) {
            setMensajeError(request, "Error en el sistema. Por favor, intente más tarde");
            e.printStackTrace();
        }

        // Mantener los datos del formulario en caso de error
        request.setAttribute("nombre", nombre);
        request.setAttribute("email", email);
        request.setAttribute("rolSeleccionado", rol);
        request.getRequestDispatcher("/WEB-INF/auth/registro.jsp").forward(request, response);
    }

    private boolean validarCampos(String nombre, String email, String rol) {
        return nombre != null && !nombre.trim().isEmpty() &&
               email != null && !email.trim().isEmpty() &&
               rol != null && !rol.trim().isEmpty();
    }

    private boolean validarRol(String rol) {
        return rol.equals(RolUsuario.BIBLIOTECARIO) || rol.equals(RolUsuario.LECTOR);
    }

    private void setMensajeError(HttpServletRequest request, String mensaje) {
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipo", "danger");
    }

    private void setMensajeExito(HttpServletRequest request, String mensaje) {
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipo", "success");
    }

    private void setMensajeAdvertencia(HttpServletRequest request, String mensaje) {
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipo", "warning");
    }
}
