package controlador;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.*;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;
import modelo.*;

public class ControlCita extends HttpServlet {

    CrudCitaDAO obj = new CrudCitaDAO();  // Ajustado para usar CrudCitaDAO
    DoctorDAO obj1 = new DoctorDAO(); // Usado para listar doctores
    EspecialidadDAO obj2 = new EspecialidadDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int op = Integer.parseInt(request.getParameter("opc"));
        switch (op) {
            case 1:
                mostrarDatos(request, response);
                break;
            case 2:
                actualizarDatos(request, response);
                break;
            case 3:
                eliminarDatos(request, response);
                break;
            case 4:
                cargarFormularioEdicion(request, response);
                break;
            case 5:
                cargarDetalles(request, response);
                break;
            case 6:  // Nuevo caso para cargar doctores por especialidad
                cargarDoctoresPorEspecialidad(request, response);
                break;
            default:
                mostrarDatos(request, response);
                break;
        }
    }

    protected void mostrarDatos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener los datos desde el CrudCitaDAO
        List<Map<String, Object>> citasCompletas = obj.mostrarCita();  // Asegúrate de que mostrarCita devuelve los datos completos de las citas
        request.setAttribute("citasCompletas", citasCompletas);  // Pasar la lista de citas completas a la JSP
        request.setAttribute("mensaje", "Datos listados correctamente.");

        String pag = "/admin/Cita/Citas.jsp";  // Define tu página JSP de resultados
        request.getRequestDispatcher(pag).forward(request, response);
    }

    protected void actualizarDatos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("Ejecutando actualizarDatos...");

            // Verificar los valores recibidos desde el formulario
            String nombreCliente = request.getParameter("nombreCliente");
            System.out.println("Nombre Cliente Recibido: " + nombreCliente);

            // Crear y poblar los objetos
            Cliente cliente = new Cliente();
            cliente.setId(Integer.parseInt(request.getParameter("idCliente")));
            cliente.setNombre(nombreCliente);
            cliente.setApellidos(request.getParameter("apellidosCliente"));
            cliente.setCorreo(request.getParameter("correoCliente"));
            cliente.setDireccion(request.getParameter("direccionCliente"));

            // Obtener la fecha del formulario y convertirla
            String fechaFormulario = request.getParameter("fechaCita");
            System.out.println("Fecha recibida: " + fechaFormulario);
            String fechaFormateada = fechaFormulario.replace("T", " ") + ":00";
            Timestamp fechaCita = Timestamp.valueOf(fechaFormateada);

            int idCita = Integer.parseInt(request.getParameter("idCita"));
            int idDoctor = Integer.parseInt(request.getParameter("idDoctor"));
            int idEspecialidad = Integer.parseInt(request.getParameter("idEspecialidad"));
            String mensaje = request.getParameter("mensajeCita");
            String estado = request.getParameter("estadoCita");

            // Verificar disponibilidad
            CitasDAO cit = new CitasDAO();
            if (!cit.verificarDisponibilidad(idDoctor, fechaCita, idCita)) {
                // Si el horario no está disponible, retornar un mensaje de error y redirigir
                request.setAttribute("mensaje", "El horario seleccionado no está disponible. Por favor, elige otro horario.");
                cargarFormularioEdicion(request, response);
                return;
            }

            // Llamar al método del CrudCitaDAO para actualizar los datos de la cita
            obj.editarCita(idCita, idEspecialidad, idDoctor, fechaCita, mensaje, estado);

            // Mostrar la lista actualizada
            mostrarDatos(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al actualizar los datos.");
            request.getRequestDispatcher("/admin/Cita/EditarCita.jsp").forward(request, response);
        }
    }

    protected void eliminarDatos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idCliente = Integer.parseInt(request.getParameter("idCliente"));
        int idCita = Integer.parseInt(request.getParameter("idCita"));

        // Llama al método del CrudCitaDAO para eliminar los datos
        obj.eliminarCita(idCliente, idCita);

        // Después de eliminar los datos, vuelve a cargar los datos
        mostrarDatos(request, response);
    }

    protected void cargarFormularioEdicion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idCita = Integer.parseInt(request.getParameter("idCita"));

            // Obtener los datos de la cita, incluyendo el cliente, doctor y mensaje.
            Map<String, Object> datosRelacionados = obj.obtenerDatosRelacionados(idCita);
            Cita cita = (Cita) datosRelacionados.get("cita");
            int idDoctor = cita.getIdDoctor();

            // Consultar el `idEspecialidad` basado en el `idDoctor` de la cita
            Doctor doctor = obj1.obtenerDoctorPorId(idDoctor);
            int idEspecialidadSeleccionada = doctor.getIdEspecialidad();

            // Obtener todas las especialidades y los doctores de la especialidad del doctor asignado a la cita
            List<Especialidad> listaEspecialidades = obj2.listar();
            List<Doctor> listaDoctores = obj1.listarPorEspecialidad(idEspecialidadSeleccionada);

            // Pasar los datos necesarios a la JSP de edición
            request.setAttribute("cliente", datosRelacionados.get("cliente"));
            request.setAttribute("especialidades", listaEspecialidades);
            request.setAttribute("doctores", listaDoctores);
            request.setAttribute("cita", cita);
            request.setAttribute("especialidadSeleccionada", idEspecialidadSeleccionada);

            request.getRequestDispatcher("/admin/Cita/EditarCita.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al cargar los datos.");
            mostrarDatos(request, response);
        }
    }

    protected void cargarDetalles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idCita = Integer.parseInt(request.getParameter("idCita"));

            // Llamar al CrudCitaDAO para obtener los datos relacionados a partir del idCita
            Map<String, Object> datosRelacionados = obj.obtenerDatosRelacionados(idCita);

            // Pasar los datos al detalle de la cita
            request.setAttribute("cliente", datosRelacionados.get("cliente"));
            request.setAttribute("especialidad", datosRelacionados.get("especialidad"));
            request.setAttribute("doctor", datosRelacionados.get("doctor"));
            request.setAttribute("cita", datosRelacionados.get("cita"));

            // Redirigir al detalle de la cita
            request.getRequestDispatcher("/admin/Cita/DetalleCita.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al cargar los datos.");
            mostrarDatos(request, response);  // Volver a la lista de citas en caso de error
        }
    }

    protected void cargarDoctoresPorEspecialidad(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int idEspecialidad = Integer.parseInt(request.getParameter("idEspecialidad"));
        try {
            List<Doctor> listaDoctores = obj1.listarPorEspecialidad(idEspecialidad);

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(new Gson().toJson(listaDoctores));
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al cargar doctores");
        }
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
        processRequest(request, response);
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
        processRequest(request, response);
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
