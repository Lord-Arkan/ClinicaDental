<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Agregar Nuevo Cliente</title>
        <!-- Incluir SweetAlert -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body>
        <%@include file="../header.jsp" %>

        <div class="container my-5" data-aos="fade-up">
            <h2 class="text-center mb-4">Agregar Nuevo Paciente</h2>

            <form id="formCliente" class="border p-4 shadow rounded">
                <input type="hidden" name="opc" value="2"/>
                <div id="error-container"></div> <!-- Contenedor para mostrar el mensaje de error -->

                <div class="mb-3">
                    <label for="nombre" class="form-label">Nombre:</label>
                    <input type="text" name="nombre" id="nombre" class="form-control" placeholder="Ingresa el nombre"  required/>
                </div>

                <div class="mb-3">
                    <label for="apellidos" class="form-label">Apellidos:</label>
                    <input type="text" name="apellidos" id="apellidos" class="form-control" placeholder="Ingresa los apellidos" required/>
                </div>

                <div class="mb-3">
                    <label for="correo" class="form-label">Correo:</label>
                    <input type="email" name="correo" id="correo" class="form-control" placeholder="Ingresa el correo electrónico" required/>
                </div>

                <div class="mb-3">
                    <label for="direccion" class="form-label">Dirección:</label>
                    <input type="text" name="direccion" id="direccion" class="form-control" placeholder="Ingresa la dirección" required/>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary">Agregar Cliente</button>
                    <a href="ControlCliente?opc=1" class="btn btn-secondary ms-2">Volver a la lista de clientes</a>
                </div>
            </form>
        </div>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <script>
            $(document).ready(function () {
                // Enviar formulario usando AJAX
                $('#formCliente').submit(function (event) {
                    event.preventDefault(); // Prevenir el comportamiento por defecto del formulario

                    // Limpiar el contenedor de errores
                    $('#error-container').empty();

                    // Enviar los datos por AJAX
                    $.ajax({
                        url: 'ControlCliente',
                        type: 'POST',
                        data: $(this).serialize(),
                        success: function (response) {
                            if (response.error) {
                                // Mostrar SweetAlert si hay un error
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: response.error
                                });
                            } else {
                                // Si no hay error, redirigir
                                window.location.href = 'ControlCliente?opc=1';
                            }
                        },
                        error: function () {
                            // Manejo de errores de AJAX
                            Swal.fire({
                                icon: 'error',
                                title: 'Error de conexión',
                                text: 'No se pudo procesar la solicitud.'
                            });
                        }
                    });
                });
            });
        </script>


        <%@include file="../footer.jsp" %>
    </body>
</html>

