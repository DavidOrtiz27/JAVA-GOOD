package sena.adso.roles.controlador;



import sena.adso.roles.dao.UsuarioDAO;
import sena.adso.roles.modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/admin/usuarios/listar"})
public class usuarioResgistradoServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Obtener la lista de usuarios desde la base de datos
	    List<Usuario> listaUsuarios = null;
	    try {
		    listaUsuarios = usuarioDAO.listarUsuarios();
	    } catch (SQLException e) {
		    throw new RuntimeException(e);
	    }

        request.setAttribute("usuarios", listaUsuarios);

        request.getRequestDispatcher("/WEB-INF/admin/usuarios/listar.jsp").forward(request, response);
    }
}
