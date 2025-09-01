package controlador;

import dao.*;
import modelo.*;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class ControlCit extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String opcParam = request.getParameter("opc");
        int op = opcParam != null ? Integer.parseInt(opcParam) : 0;

        switch (op) {
            case 1:
                registrarCita(request, response);
                break;
            case 2:
                listarDoctoresPorEspecialidad(request, response);
                break;
            case 3:
                registrarCliente(request, response); // Nueva opción para registrar cliente
                break;
            case 4:
                verificarDisponibilidadAjax(request, response); // Verificación de disponibilidad
                break;
            default:
                mostrarFormularioRegistro(request, response);
                break;
        }
    }

    protected void mostrarFormularioRegistro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ClienteDAO clienteDAO = new ClienteDAO();
            EspecialidadDAO especialidadDAO = new EspecialidadDAO();

            List<Cliente> clientes = clienteDAO.listar();
            List<Especialidad> especialidades = especialidadDAO.listar();

            request.setAttribute("clientes", clientes);
            request.setAttribute("especialidades", especialidades);

            request.getRequestDispatcher("/admin/registroCita.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

     protected void registrarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        try {
            int idDoctor = Integer.parseInt(request.getParameter("idDoctor"));
            int idCliente = Integer.parseInt(request.getParameter("idCliente"));
            String fechaStr = request.getParameter("fecha");
            
            if (fechaStr.contains("T")) {
                fechaStr = fechaStr.replace("T", " ");
            }
            Timestamp fecha = Timestamp.valueOf(fechaStr + ":00");
            
            CitasDAO citasDAO = new CitasDAO();
            if (!citasDAO.verificarDisponibilidad(idDoctor, fecha)) {
                response.getWriter().write("{\"success\":false}");
                return;
            }

            String mensaje = request.getParameter("mensaje");
            String estado = request.getParameter("estado");

            Cita cita = new Cita();
            cita.setIdDoctor(idDoctor);
            cita.setIdCliente(idCliente);
            cita.setFecha(fecha);
            cita.setMensaje(mensaje);
            cita.setEstado(estado);

            int idGenerado = citasDAO.agregar(cita);

            response.getWriter().write("{\"success\":true, \"citaId\":" + idGenerado + "}");
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false}");
            e.printStackTrace();
        }
    }

    protected void listarDoctoresPorEspecialidad(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int especialidadId = Integer.parseInt(request.getParameter("especialidadId"));
        DoctorDAO doctorDAO = new DoctorDAO();

        try {
            List<Doctor> doctores = doctorDAO.listarPorEspecialidad(especialidadId);
            response.setContentType("application/json");
            response.getWriter().write(new Gson().toJson(doctores));
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

   protected void registrarCliente(HttpServletRequest request, HttpServletResponse response) throws IOException {
    try {
        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String correo = request.getParameter("correo");
        String direccion = request.getParameter("direccion");

        // Verificar si el cliente ya existe
        ClienteDAO clienteDAO = new ClienteDAO();
        if (clienteDAO.clienteExiste(nombre, apellidos, correo)) {
            // Si el cliente existe, enviar un mensaje de error
            response.setStatus(HttpServletResponse.SC_CONFLICT); // Código 409 (conflicto)
            response.getWriter().write("{\"error\":\"El cliente ya está registrado.\"}");
            return;
        }

        // Si no existe, continuar con el registro del cliente
        Cliente cliente = new Cliente(nombre, apellidos, correo, direccion);
        int clienteId = clienteDAO.agregarCliente(cliente);

        response.setContentType("application/json");
        response.getWriter().write(new Gson().toJson(clienteId));
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al registrar el cliente");
    }
}


    protected void verificarDisponibilidadAjax(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int idDoctor = Integer.parseInt(request.getParameter("idDoctor"));
        String fechaStr = request.getParameter("fecha");
        if (fechaStr.contains("T")) {
            fechaStr = fechaStr.replace("T", " ");
        }
        Timestamp fecha = Timestamp.valueOf(fechaStr + ":00");

        CitasDAO citasDAO = new CitasDAO();
        boolean disponible;
        try {
            disponible = citasDAO.verificarDisponibilidad(idDoctor, fecha);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al verificar disponibilidad");
            return;
        }

        response.setContentType("application/json");
        response.getWriter().write(new Gson().toJson(disponible));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Controlador para el registro de citas";
    }
}
