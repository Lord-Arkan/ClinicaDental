<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Detalles de la Cita</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.css" />
        <link rel="stylesheet" href="styles.css"> <!-- Tu propio archivo de estilos -->
    </head>
    <%@include file="../header.jsp" %>
    <body>
        <section>
            <div class="container mt-5" data-aos="fade-up">
                <h1 class="mb-4 text-center">Detalles de la Cita</h1>
                <div class="card shadow-sm rounded p-4">
                    <div class="card-body">
                        
                        <!-- Sección de Detalles del Cliente -->
                        <div class="row mb-4">
                            <div class="col-md-12" data-aos="fade-right">
                                <h5 class="text-primary border-bottom pb-2 mb-3">Detalles del Cliente</h5>
                            </div>
                            <div class="col-md-4 mb-3" data-aos="fade-up" data-aos-delay="100">
                                <p><strong>Nombre del Cliente:</strong> ${cliente.nombre} ${cliente.apellidos}</p>
                            </div>
                            <div class="col-md-4 mb-3" data-aos="fade-up" data-aos-delay="200">
                                <p><strong>Correo del Cliente:</strong> ${cliente.correo}</p>
                            </div>
                            <div class="col-md-4 mb-3" data-aos="fade-up" data-aos-delay="300">
                                <p><strong>Dirección del Cliente:</strong> ${cliente.direccion}</p>
                            </div>
                        </div>

                        <!-- Sección de Detalles del Doctor -->
                        <div class="row mb-4">
                            <div class="col-md-12" data-aos="fade-left">
                                <h5 class="text-primary border-bottom pb-2 mb-3">Detalles del Doctor</h5>
                            </div>
                            <div class="col-md-6 mb-3" data-aos="fade-up" data-aos-delay="100">
                                <p><strong>Doctor:</strong> ${doctor.nombre} ${doctor.apellidos}</p>
                            </div>
                            <div class="col-md-6 mb-3" data-aos="fade-up" data-aos-delay="200">
                                <p><strong>Especialidad:</strong> ${especialidad.tipo}</p>
                            </div>
                        </div>

                        <!-- Sección de Información de la Cita -->
                        <div class="row mb-4">
                            <div class="col-md-12" data-aos="fade-right">
                                <h5 class="text-primary border-bottom pb-2 mb-3">Información de la Cita</h5>
                            </div>
                            <div class="col-md-4 mb-3" data-aos="fade-up" data-aos-delay="100">
                                <p><strong>Fecha:</strong> <span id="fecha"></span></p>
                            </div>
                            <div class="col-md-4 mb-3" data-aos="fade-up" data-aos-delay="200">
                                <p><strong>Hora:</strong> <span id="hora"></span></p>
                            </div>
                            <div class="col-md-4 mb-3" data-aos="fade-up" data-aos-delay="300">
                                <p><strong>Estado:</strong> 
                                    <span class="badge ${cita.estado == 'Cancelado' ? 'bg-danger' : 'bg-success'}">
                                        ${cita.estado}
                                    </span>
                                </p>
                            </div>
                            <div class="col-md-12 mb-3" data-aos="fade-up" data-aos-delay="400">
                                <p><strong>Mensaje:</strong> ${cita.mensaje}</p>
                            </div>
                        </div>

                        <!-- Botón de regreso -->
                        <div class="text-center mt-4" data-aos="zoom-in">
                            <a href="ControlCita?opc=1" class="btn btn-primary btn-lg">
                                <i class="bi bi-arrow-left"></i> Volver al listado de citas
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Scripts para AOS -->
        <script src="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.js"></script>
        <script>
            AOS.init();  // Inicializar AOS para las animaciones

            // Formatear y mostrar la fecha y hora de la cita
            const fechaCompleta = '${cita.fecha}'; // Formato esperado: yyyy-MM-dd HH:mm:ss

            function formatearFechaHora(fechaCompleta) {
                const fecha = new Date(fechaCompleta);
                const opcionesFecha = {year: 'numeric', month: 'long', day: 'numeric'};
                const opcionesHora = {hour: 'numeric', minute: '2-digit', hour12: true};

                const fechaFormateada = fecha.toLocaleDateString('es-ES', opcionesFecha);
                const horaFormateada = fecha.toLocaleTimeString('es-ES', opcionesHora);

                document.getElementById('fecha').innerText = fechaFormateada;
                document.getElementById('hora').innerText = horaFormateada;
            }

            formatearFechaHora(fechaCompleta);
        </script>
    </body>
    <%@include file="../footer.jsp" %>
</html>





