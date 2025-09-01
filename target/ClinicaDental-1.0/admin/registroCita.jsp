<%@page import="modelo.*"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Registrar Cita</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <%@include file="header.jsp" %>
        <style>
            /* Estilos para el formulario */


            .card {
                background: #ffffff;
                border: none;
                border-radius: 15px;
                box-shadow: 0px 10px 30px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease-in-out;
            }

            .card:hover {
                transform: translateY(-10px);
            }

            .form-control {
                border-radius: 30px;
                transition: all 0.3s ease;
            }

            .form-control:focus {
                box-shadow: 0px 0px 5px #2a5298;
                border-color: #2a5298;
            }

            .btn {
                border-radius: 30px;
                transition: background 0.3s;
            }

            .btn:hover {
                background: #1e3c72;
                color: #fff;
            }

            /* Modal */
            .modal-content {
                border-radius: 15px;
                animation: fadeIn 0.4s;
            }

            .modal-content, .modal-body, .list-group-item {
                color: #000 !important; /* Asegura el color de texto negro */
                font-size: 1em;         /* Tamaño de fuente suficiente para visibilidad */
                visibility: visible;
                display: block;
            }


            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            /* Animaciones de entrada de los elementos */
            .form-group {
                animation: slideIn 0.5s ease;
            }

            @keyframes slideIn {
                from {
                    transform: translateY(20px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
        </style>
    </head>
    <body>
        <section data-aos="fade-up">
            <div class="container">
                <div class="text-center mb-4">
                    <h2 class="text-blue">Registrar Cita</h2>
                </div>
                <div id="errorMensaje" class="alert alert-danger text-center" style="display: none;">
                    El horario seleccionado no está disponible. El horario laboral es de Lunes a Viernes de 9:00 a 13:00 y de 14:00 a 18:00, y los Sábados de 9:00 a 13:00.
                </div>
                <div class="card p-5">
                    <form id="citaForm" onsubmit="verificarYRegistrarCita(event)">
                        <input type="hidden" name="opc" value="1">
                        <input type="hidden" name="estado" value="Pendiente">
                        <div class="form-group mb-4 text-center">
                            <label class="font-weight-bold">Paciente:</label>
                            <button type="button" class="btn btn-outline-primary" 
                                    onclick="document.getElementById('clienteModal').style.display = 'block'">
                                Seleccionar Paciente
                            </button>
                            <button type="button" class="btn btn-outline-success ml-2"
                                    onclick="document.getElementById('nuevoClienteModal').style.display = 'block'">
                                Registrar Nuevo Paciente
                            </button>
                            <input type="hidden" name="idCliente" id="idCliente">
                            <br><br>
                            <span id="clienteSeleccionado" class="ml-2 text-secondary"></span>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="especialidad">Especialidad:</label>
                                <select id="especialidad" name="idEspecialidad" class="form-control" onchange="cargarDoctores()" required>
                                    <option value="" disabled selected>Seleccione una especialidad</option>
                                    <% for (Especialidad especialidad : (List<Especialidad>) request.getAttribute("especialidades")) {%>
                                    <option value="<%= especialidad.getId()%>"><%= especialidad.getTipo()%></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="doctor">Doctor:</label>
                                <select id="doctor" name="idDoctor" class="form-control" required>
                                    <option value="" disabled selected>Seleccione un doctor</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="fecha">Fecha:</label>
                            <input type="datetime-local" id="fecha" name="fecha" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="mensaje">Mensaje:</label>
                            <textarea name="mensaje" class="form-control" rows="3" placeholder="Escribe un mensaje" required></textarea>
                        </div>
                        <div class="form-group text-center">
                            <button type="submit" class="btn btn-success btn-lg">
                                Registrar Cita
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <div id="clienteModal" class="modal" tabindex="-1" role="dialog" style="display:none;">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Seleccionar Cliente</h5>
                            <button type="button" class="close" onclick="document.getElementById('clienteModal').style.display = 'none'">
                                <span>&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <input type="text" id="buscarCliente" class="form-control mb-3" placeholder="Buscar cliente por nombre o apellido" onkeyup="filtrarClientes()">
                            <ul id="listaClientes" class="list-group">
                                <% List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
                                    for (Cliente cliente : clientes) {%>
                                <li class="list-group-item list-group-item-action" 
                                    onclick="seleccionarCliente(<%= cliente.getId()%>, '<%= cliente.getNombre()%> <%= cliente.getApellidos()%>')">
                                    <%= cliente.getNombre()%> <%= cliente.getApellidos()%>
                                </li>
                                <% }%>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div id="nuevoClienteModal" class="modal" tabindex="-1" role="dialog" style="display:none;">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Registrar Nuevo Cliente</h5>
                            <button type="button" class="close" onclick="document.getElementById('nuevoClienteModal').style.display = 'none'">
                                <span>&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <form id="nuevoClienteForm" onsubmit="registrarCliente(event)">
                                <div class="form-group">
                                    <label for="nombre">Nombre:</label>
                                    <input type="text" id="nombre" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="apellidos">Apellidos:</label>
                                    <input type="text" id="apellidos" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="correo">Correo:</label>
                                    <input type="email" id="correo" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="direccion">Dirección:</label>
                                    <input type="text" id="direccion" class="form-control" required>
                                </div>
                                <button type="submit" class="btn btn-primary">Guardar Cliente</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
                            <div class="card-body">
                            <%@ include file="Calendario2.jsp" %>
                        </div>
        </section>

        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
        <script>
                                function cargarDoctores() {
                                    var especialidadId = document.getElementById("especialidad").value;
                                    var doctorSelect = document.getElementById("doctor");

                                    fetch("ControlCit?opc=2&especialidadId=" + especialidadId)
                                            .then(response => response.json())
                                            .then(data => {
                                                doctorSelect.innerHTML = ""; // Limpiar opciones anteriores
                                                data.forEach(doctor => {
                                                    var option = document.createElement("option");
                                                    option.value = doctor.id;
                                                    option.text = doctor.nombre + " " + doctor.apellidos;
                                                    doctorSelect.add(option);
                                                });
                                            })
                                            .catch(error => console.error("Error al cargar doctores:", error));
                                }

                                function seleccionarCliente(id, nombreCompleto) {
                                    document.getElementById("idCliente").value = id;
                                    document.getElementById("clienteSeleccionado").innerText = nombreCompleto;
                                    document.getElementById("clienteModal").style.display = 'none';
                                }

                                function filtrarClientes() {
                                    var input = document.getElementById("buscarCliente");
                                    var filter = input.value.toLowerCase();
                                    var lista = document.getElementById("listaClientes");
                                    var items = lista.getElementsByTagName("li");

                                    for (var i = 0; i < items.length; i++) {
                                        var nombreCompleto = items[i].textContent || items[i].innerText;
                                        if (nombreCompleto.toLowerCase().indexOf(filter) > -1) {
                                            items[i].style.display = "";
                                        } else {
                                            items[i].style.display = "none";
                                        }
                                    }
                                }

                                function registrarCliente(event) {
                                    event.preventDefault();

                                    // Obtener los valores de los campos del formulario
                                    var nombre = document.getElementById("nombre").value;
                                    var apellidos = document.getElementById("apellidos").value;
                                    var correo = document.getElementById("correo").value;
                                    var direccion = document.getElementById("direccion").value;

                                    // Enviar datos al backend usando fetch
                                    fetch('ControlCit?opc=3', {
                                        method: 'POST',
                                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                        body: 'nombre=' + encodeURIComponent(nombre) +
                                                '&apellidos=' + encodeURIComponent(apellidos) +
                                                '&correo=' + encodeURIComponent(correo) +
                                                '&direccion=' + encodeURIComponent(direccion)
                                    })
                                            .then(response => response.json())
                                            .then(clienteId => {
                                                if (clienteId.error) {
                                                    // Si el cliente ya existe, mostrar un mensaje
                                                    Swal.fire("Cliente ya registrado", "Este cliente ya se encuentra registrado.", "warning");
                                                } else {
                                                    console.log("Nuevo ID de cliente:", clienteId);
                                                    document.getElementById("idCliente").value = clienteId;
                                                    document.getElementById("clienteSeleccionado").innerText = nombre + " " + apellidos;
                                                    document.getElementById("nuevoClienteModal").style.display = 'none';
                                                    alert("Cliente registrado con éxito.");
                                                }
                                            })
                                            .catch(error => console.error("Error al registrar cliente:", error));
                                }


                                function verificarYRegistrarCita(event) {
                                    event.preventDefault();
                                    const idDoctor = document.getElementById("doctor").value;
                                    const idCliente = document.getElementById("idCliente").value;
                                    const fecha = document.getElementById("fecha").value;
                                    const mensaje = document.getElementById("citaForm").elements["mensaje"].value;

                                    if (!idDoctor || !idCliente) {
                                        Swal.fire("Atención", "Seleccione un doctor y un paciente.", "warning");
                                        return;
                                    }

                                    // Construcción manual del cuerpo de la solicitud con concatenación de cadenas
                                    const body = "idDoctor=" + encodeURIComponent(idDoctor) +
                                            "&idCliente=" + encodeURIComponent(idCliente) +
                                            "&fecha=" + encodeURIComponent(fecha) +
                                            "&mensaje=" + encodeURIComponent(mensaje) +
                                            "&estado=Pendiente";

                                    fetch("ControlCit?opc=1", {
                                        method: "POST",
                                        headers: {"Content-Type": "application/x-www-form-urlencoded"},
                                        body: body
                                    })
                                            .then(response => response.json())
                                            .then(json => {
                                                if (json.success) {
                                                    Swal.fire({
                                                        title: "Cita registrada",
                                                        text: "La cita ha sido registrada exitosamente.",
                                                        icon: "success",
                                                        confirmButtonText: "OK"
                                                    }).then(() => {
                                                        window.location.reload();
                                                    });
                                                } else {
                                                    document.getElementById("errorMensaje").style.display = "block";
                                                    Swal.fire("Horario No Disponible", "Selecciona un horario disponible.", "error");
                                                }
                                            })
                                            .catch(error => {
                                                console.error("Error al registrar la cita:", error);
                                                Swal.fire("Error", "Hubo un problema al intentar registrar la cita.", "error");
                                            });
                                }
        </script>
        <%@include file="footer.jsp" %>
    </body>
</html>



