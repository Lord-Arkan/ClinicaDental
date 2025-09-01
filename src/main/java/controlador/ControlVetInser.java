package controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.CitasDAO;
import dao.DoctorDAO;
import dao.EspecialidadDAO;
import modelo.*;

/**
 * Servlet para la gestión de inserción de citas en el sistema de una
 * veterinaria. Este controlador maneja la carga de especialidades, doctores y
 * el registro de citas con validaciones de disponibilidad.
 */
public class ControlVetInser extends HttpServlet {
    // DAOs para acceso a datos

    EspecialidadDAO especialidadDAO = new EspecialidadDAO();
    DoctorDAO doctorDAO = new DoctorDAO();
    CitasDAO citasDAO = new CitasDAO();

    /**
     * Procesa las solicitudes HTTP GET y POST. Realiza acciones como cargar
     * especialidades, doctores, y registrar citas.
     *
     * @param request el objeto {@link HttpServletRequest} que contiene la
     * solicitud del cliente.
     * @param response el objeto {@link HttpServletResponse} que contiene la
     * respuesta al cliente.
     * @throws ServletException si ocurre un error relacionado con el servlet.
     * @throws IOException si ocurre un error de entrada/salida.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            List<Especialidad> especialidades = especialidadDAO.listar();
            request.setAttribute("especialidades", especialidades);

            String idEspecialidadStr = request.getParameter("idEspecialidad");
            if (idEspecialidadStr != null && !idEspecialidadStr.trim().isEmpty()) {
                int idEspecialidad = Integer.parseInt(idEspecialidadStr);
                List<Doctor> doctores = doctorDAO.listarPorEspecialidad(idEspecialidad);
                request.setAttribute("doctores", doctores);
                request.setAttribute("idEspecialidad", idEspecialidadStr);
            }

            String idDoctorStr = request.getParameter("idDoctor");
            if (idDoctorStr != null) {
                request.setAttribute("idDoctor", idDoctorStr);
            }

            // Validación y procesamiento solo si la acción es "registrar"
            if ("registrar".equals(action)
                    && idDoctorStr != null && !idDoctorStr.trim().isEmpty()
                    && request.getParameter("txtFechaCita") != null && !request.getParameter("txtFechaCita").trim().isEmpty()
                    && request.getParameter("txtNombreCliente") != null
                    && request.getParameter("txtApellidosCliente") != null) {
                registrarCita(request, response);
            } else {
                // Enviar al formulario si no se ha enviado la acción de registro
                request.getRequestDispatcher("/Cita.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error al cargar los datos: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * Registra una nueva cita en el sistema. Valida que la fecha y hora sean
     * válidas y estén disponibles.
     *
     * @param request el objeto {@link HttpServletRequest}.
     * @param response el objeto {@link HttpServletResponse}.
     * @throws ServletException si ocurre un error al procesar la solicitud.
     * @throws IOException si ocurre un error de entrada/salida.
     */
    private void registrarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener la fecha de la cita desde el formulario
            String fechaCitaStr = request.getParameter("txtFechaCita");
            if (fechaCitaStr != null && !fechaCitaStr.trim().isEmpty()) {
                // Formatear la fecha para convertirla en Timestamp
                fechaCitaStr = fechaCitaStr.replace("T", " ") + ":00";
                Timestamp fechaCita = Timestamp.valueOf(fechaCitaStr);

                // Obtener detalles del cliente desde el formulario
                String nombreCliente = request.getParameter("txtNombreCliente");
                String apellidosCliente = request.getParameter("txtApellidosCliente");
                String correoCliente = request.getParameter("txtCorreoCliente");
                String direccionCliente = request.getParameter("txtDireccionCliente");

                // Crear el objeto cliente con los datos obtenidos
                Cliente cliente = new Cliente(nombreCliente, apellidosCliente, correoCliente, direccionCliente);

                // Obtener el ID del doctor, mensaje y estado de la cita
                int idDoctor = Integer.parseInt(request.getParameter("idDoctor"));
                String mensajeCita = request.getParameter("txtMensajeCita");
                String estadoCita = request.getParameter("txtEstadoCita");

                // Verificar disponibilidad de la cita (llama a la sobrecarga sin idCita para nuevas citas)
                if (!citasDAO.verificarDisponibilidad(idDoctor, fechaCita)) {
                    // Si el horario no está disponible, enviar un mensaje de error al usuario
                    request.setAttribute("errorMessage", "La fecha y hora seleccionadas no están disponibles.");
                    request.getRequestDispatcher("/Cita.jsp").forward(request, response);
                    return;
                }

                // Registrar la cita en la base de datos si está disponible
                citasDAO.realizarCita(cliente, idDoctor, fechaCita, mensajeCita, estadoCita);

                // Redirigir a la página de confirmación tras el registro exitoso
                request.getRequestDispatcher("/pagConfirmacionInsercion.jsp").forward(request, response);
            } else {
                // Manejar el caso en el que no se proporcione una fecha válida
                request.setAttribute("errorMessage", "Debe proporcionar una fecha válida para la cita.");
                request.getRequestDispatcher("/Cita.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            // Manejar excepciones de SQL y redirigir a una página de error si ocurre un problema
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error al registrar la cita: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * Maneja solicitudes HTTP GET.
     *
     * @param request el objeto {@link HttpServletRequest}.
     * @param response el objeto {@link HttpServletResponse}.
     * @throws ServletException si ocurre un error relacionado con el servlet.
     * @throws IOException si ocurre un error de entrada/salida.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Maneja solicitudes HTTP POST.
     *
     * @param request el objeto {@link HttpServletRequest}.
     * @param response el objeto {@link HttpServletResponse}.
     * @throws ServletException si ocurre un error relacionado con el servlet.
     * @throws IOException si ocurre un error de entrada/salida.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Devuelve una breve descripción del servlet.
     *
     * @return una descripción breve del servlet.
     */
    @Override
    public String getServletInfo() {
        return "Servlet para la inserción de datos en la veterinaria";
    }
}
