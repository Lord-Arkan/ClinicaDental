<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Editar Cita</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.css" />
    </head>
    <%@include file="../header.jsp" %>
    <body>
        <section data-aos="fade-up">
            <div class="container section-title mb-5" data-aos="fade-up">
                <div class="container mt-5">
                    <h1 class="mb-4 text-center">Editar Cita</h1>

                    <c:if test="${not empty mensaje}">
                        <div class="alert alert-info" role="alert">
                            ${mensaje}
                        </div>
                    </c:if>

                    <form action="ControlCita" method="post" class="card p-4 shadow-sm">
                        <input type="hidden" name="opc" value="2">
                        <input type="hidden" name="idCita" value="${cita.id}">
                        <input type="hidden" name="idCliente" value="${cliente.id}">

                        <!-- Agrupar los campos en filas de 3 columnas -->
                        <div class="row">
                            <div class="col-md-4 mb-3" data-aos="fade-right">
                                <label for="nombreCliente" class="form-label">Nombre del Cliente:</label>
                                <input type="text" id="nombreCliente" name="nombreCliente" class="form-control" value="${cliente.nombre}" disabled required>
                            </div>

                            <div class="col-md-4 mb-3" data-aos="fade-down">
                                <label for="apellidosCliente" class="form-label">Apellidos del Cliente:</label>
                                <input type="text" id="apellidosCliente" name="apellidosCliente" class="form-control" value="${cliente.apellidos}" disabled required>
                            </div>

                            <div class="col-md-4 mb-3" data-aos="fade-left" >
                                <label for="correoCliente" class="form-label">Correo del Cliente:</label>
                                <input type="email" id="correoCliente" name="correoCliente" class="form-control" value="${cliente.correo}" disabled required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3" data-aos="fade-right">
                                <label for="direccionCliente" class="form-label">Dirección del Cliente:</label>
                                <input type="text" id="direccionCliente" name="direccionCliente" class="form-control" value="${cliente.direccion}" disabled required>
                            </div>

                            <div class="col-md-4 mb-3" data-aos="fade-down">
                                <label for="idEspecialidad" class="form-label">Especialidad:</label>
                                <select id="idEspecialidad" name="idEspecialidad" class="form-select" required onchange="actualizarDoctores()">
                                    <c:forEach var="especialidad" items="${especialidades}">
                                        <option value="${especialidad.id}" ${especialidad.id == especialidadSeleccionada ? 'selected' : ''}>
                                            ${especialidad.tipo}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-4 mb-3" data-aos="fade-left">
                                <label for="idDoctor" class="form-label">Doctor:</label>
                                <select id="idDoctor" name="idDoctor" class="form-select" required>
                                    <c:forEach var="doctor" items="${doctores}">
                                        <option value="${doctor.id}" ${doctor.id == cita.idDoctor ? 'selected' : ''}>
                                            ${doctor.nombre} ${doctor.apellidos}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3" data-aos="fade-right">
                                <label for="fechaCita" class="form-label">Fecha y Hora de la Cita:</label>
                                <input type="datetime-local" id="fechaCita" name="fechaCita" class="form-control"
                                       value="${cita.fecha.toLocalDateTime().toString().substring(0, 16)}" required>
                            </div>


                            <div class="col-md-4 mb-3" data-aos="fade-left">
                                <label for="estadoCita" class="form-label">Estado:</label>
                                <select id="estadoCita" name="estadoCita" class="form-select" required>
                                    <option value="Pendiente" ${cita.estado == 'Pendiente' ? 'selected' : ''}>Pendiente</option>
                                    <option value="Atendido" ${cita.estado == 'Atendido' ? 'selected' : ''}>Atendido</option>
                                    <option value="Cancelado" ${cita.estado == 'Cancelado' ? 'selected' : ''}>Cancelado</option>
                                </select>
                            </div>
                        </div>

                        <!-- Campo de Mensaje en una fila completa -->
                        <div class="row">
                            <div class="col-md-12 mb-3" data-aos="fade-up">
                                <label for="mensajeCita" class="form-label">Mensaje:</label>
                                <textarea id="mensajeCita" name="mensajeCita" rows="5" class="form-control">${cita.mensaje}</textarea>
                            </div>
                        </div>

                        <!-- Botones de Acción -->
                        <div class="text-center mt-4" data-aos="zoom-in">
                            <button type="submit" class="btn btn-success btn-lg">
                                <i class="bi bi-save"></i> Actualizar Cita
                            </button>
                            <a href="ControlCita?opc=1" class="btn btn-secondary btn-lg ms-2">
                                <i class="bi bi-arrow-left"></i> Volver al listado de citas
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </section>
        <script src="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.js"></script>
        <script>
                                AOS.init();  // Inicializar AOS para aplicar animaciones

                                function actualizarDoctores() {
                                    var idEspecialidad = document.getElementById("idEspecialidad").value;
                                    fetch("ControlCita?opc=6&idEspecialidad=" + idEspecialidad)
                                            .then(response => response.json())
                                            .then(data => {
                                                var doctorSelect = document.getElementById("idDoctor");
                                                doctorSelect.innerHTML = ""; // Limpiar opciones anteriores

                                                data.forEach(function (doctor) {
                                                    var option = document.createElement("option");
                                                    option.value = doctor.id;
                                                    option.text = doctor.nombre + " " + doctor.apellidos;
                                                    doctorSelect.add(option);
                                                });
                                            })
                                            .catch(error => console.error("Error al cargar doctores:", error));
                                }
        </script>
    </body>
    <%@include file="../footer.jsp" %>
</html>




