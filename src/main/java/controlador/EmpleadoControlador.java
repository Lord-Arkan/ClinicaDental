package controlador;

import dao.EmpleadoDao;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Empleado;

/**
 * Servlet encargado de manejar las operaciones CRUD para la entidad Empleado.
 * Este controlador procesa solicitudes HTTP para listar, agregar, buscar,
 * modificar y eliminar empleados.
 */
public class EmpleadoControlador extends HttpServlet {
    // Instancia de la entidad Empleado

    Empleado emp = new Empleado();

    // DAO para operaciones con la base de datos
    EmpleadoDao dao = new EmpleadoDao();

    /**
     * Procesa las solicitudes HTTP GET y POST.
     *
     * @param request el objeto {@link HttpServletRequest} que contiene la
     * solicitud del cliente.
     * @param response el objeto {@link HttpServletResponse} que contiene la
     * respuesta al cliente.
     * @throws ServletException si ocurre un error relacionado con el servlet.
     * @throws IOException si ocurre un error de entrada/salida.
     * @throws SQLException si ocurre un error con la base de datos.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int op = Integer.parseInt(request.getParameter("opc"));
        switch (op) {
            case 1:
                listarEmpleados(request, response);
                break;
            case 2:
                adicionarEmpleado(request, response);

                break;
            case 3:
                buscarEmpleado(request, response);
                break;
            case 4:
                modificarEmpleado(request, response);
                break;
            case 5:
                eliminarEmpleado(request, response);
                break;
        }
    }

    /**
     * Lista todos los empleados y redirige a la vista correspondiente.
     *
     * @param request el objeto {@link HttpServletRequest}.
     * @param response el objeto {@link HttpServletResponse}.
     * @throws ServletException si ocurre un error al procesar la solicitud.
     * @throws IOException si ocurre un error de entrada/salida.
     */
    protected void listarEmpleados(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("dato", dao.listar());
        request.setAttribute("empleado", emp);
        request.setAttribute("titulo", "Registrar");
        request.setAttribute("nro", 2);
        String pag = "/admin/usuarios.jsp";
        request.getRequestDispatcher(pag).forward(request, response);
    }

    /**
     * Agrega un nuevo empleado a la base de datos.
     *
     * @param request el objeto {@link HttpServletRequest}.
     * @param response el objeto {@link HttpServletResponse}.
     * @throws ServletException si ocurre un error al procesar la solicitud.
     * @throws IOException si ocurre un error de entrada/salida.
     * @throws SQLException si ocurre un error al interactuar con la base de
     * datos.
     */
    protected void adicionarEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        // Obtener los parámetros del formulario
        String dni = request.getParameter("txtdni");
        String user = request.getParameter("txtuser");

        // Verificar si el empleado ya existe
        if (dao.empleadoExiste(user, dni)) {
            // Si el empleado existe, redirigir con un mensaje de error
            response.sendRedirect("EmpleadoControlador?opc=1&error=1");
            return;  // Salir del método si el empleado ya existe
        }

        // Crear un nuevo objeto Empleado con los datos del formulario
        Empleado e = new Empleado();
        e.setDni(dni);
        e.setNom(request.getParameter("txtnom"));
        e.setEdad(request.getParameter("txtedad"));
        e.setTel(request.getParameter("txttel"));
        e.setEstado(request.getParameter("txtestado"));
        e.setRol(request.getParameter("txtrol"));
        e.setUser(user);
        e.setPass(request.getParameter("txtpass"));

        // Agregar el nuevo empleado a la base de datos
        dao.agregar(e);

        // Redirigir a la lista de empleados con un parámetro de éxito
        response.sendRedirect("EmpleadoControlador?opc=1&success=1");
    }

    /**
     * Elimina un empleado de la base de datos.
     *
     * @param request el objeto {@link HttpServletRequest}.
     * @param response el objeto {@link HttpServletResponse}.
     * @throws ServletException si ocurre un error al procesar la solicitud.
     * @throws IOException si ocurre un error de entrada/salida.
     * @throws SQLException si ocurre un error al interactuar con la base de
     * datos.
     */
    protected void eliminarEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        dao.eliminar(id);
        request.setAttribute("dato", dao.listar());
        request.setAttribute("empleado", new Empleado());
        request.setAttribute("titulo", "Registrar");
        request.setAttribute("nro", 2);
        String pag = "/admin/usuarios.jsp";
        request.getRequestDispatcher(pag).forward(request, response);
    }

    /**
     * Busca un empleado por su ID y redirige a la vista para modificarlo.
     *
     * @param request el objeto {@link HttpServletRequest}.
     * @param response el objeto {@link HttpServletResponse}.
     * @throws ServletException si ocurre un error al procesar la solicitud.
     * @throws IOException si ocurre un error de entrada/salida.
     */
    protected void buscarEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("dato", dao.listar());
        request.setAttribute("empleado", dao.obtenerPorId(id));
        request.setAttribute("titulo", "Actualizar");
        request.setAttribute("nro", 4);
        String pag = "/admin/usuarios.jsp";
        request.getRequestDispatcher(pag).forward(request, response);

    }

    /**
     * Modifica los datos de un empleado existente en la base de datos.
     *
     * @param request el objeto {@link HttpServletRequest}.
     * @param response el objeto {@link HttpServletResponse}.
     * @throws ServletException si ocurre un error al procesar la solicitud.
     * @throws IOException si ocurre un error de entrada/salida.
     * @throws SQLException si ocurre un error al interactuar con la base de
     * datos.
     */
    protected void modificarEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        Empleado e = new Empleado();
        e.setId(Integer.parseInt(request.getParameter("txtid")));
        e.setDni(request.getParameter("txtdni"));
        e.setNom(request.getParameter("txtnom"));
        e.setEdad(request.getParameter("txtedad"));
        e.setTel(request.getParameter("txttel"));
        e.setEstado(request.getParameter("txtestado"));
        e.setRol(request.getParameter("txtrol"));
        e.setUser(request.getParameter("txtuser"));
        e.setPass(request.getParameter("txtpass"));
        dao.actualizar(e);

        // Redirige con un parámetro que indique el éxito de la operación
        response.sendRedirect("EmpleadoControlador?opc=1&success=1");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(EmpleadoControlador.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(EmpleadoControlador.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
