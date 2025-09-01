<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lista de Doctores</title>
        <!-- Bootstrap CSS -->
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">
        <!-- SweetAlert CSS & JS -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            // Abrir el modal si el parámetro modalOpen=true
            window.onload = function () {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('modalOpen') === 'true') {
                    const modal = new bootstrap.Modal(document.getElementById('especialidadModal'));
                    modal.show();
                }
            };
        </script>
    </head>
    <body>
        <%@include file="../header.jsp" %>

        <div class="container my-5" data-aos="fade-up">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1 class="mb-0">Lista de Doctores</h1>
                <div>
                    <!-- Botones de agregar doctores y especialidades -->
                    <a href="${pageContext.request.contextPath}/ControlDoctor?opc=2" class="btn btn-primary me-2">Agregar Nuevo Doctor</a>
                    <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#especialidadModal">Agregar Especialidad</button>
                </div>
            </div>

            <!-- Tabla de Doctores -->
            <table id="tabla" class="table table-bordered table-hover mt-4">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Apellidos</th>
                        <th>Edad</th>
                        <th>Especialidad</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="doctor" items="${listaDoctores}">
                        <tr>
                            <td>${doctor.id}</td>
                            <td>${doctor.nombre}</td>
                            <td>${doctor.apellidos}</td>
                            <td>${doctor.edad}</td>
                            <td>
                                <c:forEach var="especialidad" items="${especialidades}">
                                    <c:if test="${especialidad.id == doctor.idEspecialidad}">
                                        ${especialidad.tipo}
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <a href="ControlDoctor?opc=3&id=${doctor.id}" class="btn btn-sm btn-primary">Editar</a>
                                <a hidden="null" href="ControlDoctor?opc=5&id=${doctor.id}&idEspecialidad=${doctor.idEspecialidad}" 
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('¿Estás seguro de eliminar este doctor?')">Eliminar</a>
                                <a href="#" class="btn btn-sm btn-danger"
                                   onclick="event.preventDefault(); confirmarEliminacion(${doctor.id}, ${doctor.idEspecialidad});">Eliminar</a>
                                <a href="ControlDoctor?opc=9&id=${doctor.id}" class="btn btn-info btn-sm">Historial</a>

                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Modal para listar y agregar especialidades -->
            <div class="modal fade" id="especialidadModal" tabindex="-1" aria-labelledby="especialidadModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5>Agregar Nueva Especialidad</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <!-- Formulario para agregar especialidad -->
                            <form action="${pageContext.request.contextPath}/ControlDoctor?opc=7" method="post">
                                <div class="mb-3">
                                    <label for="tipo" class="form-label">Tipo de Especialidad:</label>
                                    <input type="text" id="tipo" name="tipo" class="form-control" required>
                                </div>
                                <button type="submit" class="btn btn-primary">Agregar Especialidad</button>
                            </form>

                            <hr>

                            <h5>Lista de Especialidades</h5>
                            <!-- Tabla de especialidades -->
                            <table class="table table-bordered mt-3">
                                <thead class="table-secondary">
                                    <tr>
                                        <th>ID</th>
                                        <th>Tipo</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="especialidad" items="${especialidades}">
                                        <tr>
                                            <td>${especialidad.id}</td>
                                            <td>${especialidad.tipo}</td>
                                            <td>
                                                <a href="#" class="btn btn-sm btn-danger"
                                                   onclick="event.preventDefault(); confirmarEliminacionEspecialidad(${especialidad.id});">Eliminar</a>



                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- jQuery (necesario para DataTables) -->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <!-- Bootstrap JS -->
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
        <!-- DataTables JS -->
        <script src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>
        <!-- Inicialización de DataTables -->
        <script>
                                                       $(document).ready(function () {
                                                           $('#tabla').DataTable({
                                                               "language": {
                                                                   "decimal": "",
                                                                   "emptyTable": "No hay información",
                                                                   "info": "Mostrando _START_ a _END_ de _TOTAL_ Doctores",
                                                                   "infoEmpty": "Mostrando 0 a 0 de 0 citas",
                                                                   "infoFiltered": "(Filtrado de _MAX_ total Doctores)",
                                                                   "infoPostFix": "",
                                                                   "thousands": ",",
                                                                   "lengthMenu": "Mostrar _MENU_ Doctores",
                                                                   "loadingRecords": "Cargando...",
                                                                   "processing": "Procesando...",
                                                                   "search": "Buscar:",
                                                                   "zeroRecords": "No se encontraron resultados",
                                                                   "paginate": {
                                                                       "first": "Primero",
                                                                       "last": "Último",
                                                                       "next": "Siguiente",
                                                                       "previous": "Anterior"
                                                                   },
                                                                   "aria": {
                                                                       "sortAscending": ": activar para ordenar la columna de manera ascendente",
                                                                       "sortDescending": ": activar para ordenar la columna de manera descendente"
                                                                   }
                                                               },
                                                               "pageLength": 10,
                                                               "lengthMenu": [5, 10, 20, 50],
                                                               "order": [[0, "desc"]]  // Ordenar por la primera columna (ID Cita) de forma descendente por defecto
                                                           });
                                                       });

                                                       // Confirmación de eliminación con SweetAlert para doctores
                                                       function confirmarEliminacion(id, idEspecialidad) {
                                                           Swal.fire({
                                                               title: '¿Está seguro de eliminar este doctor?',
                                                               text: "Esta acción no se puede deshacer.",
                                                               icon: 'warning',
                                                               showCancelButton: true,
                                                               confirmButtonText: 'Sí, eliminar',
                                                               cancelButtonText: 'Cancelar'
                                                           }).then((result) => {
                                                               if (result.isConfirmed) {
                                                                   // Construir la URL de eliminación con id e idEspecialidad
                                                                   window.location.href = 'ControlDoctor?opc=5&id=' + id + '&idEspecialidad=' + idEspecialidad;
                                                               }
                                                           });
                                                       }

                                                       // Confirmación de eliminación con SweetAlert para especialidades
                                                       function confirmarEliminacionEspecialidad(id) {
                                                           Swal.fire({
                                                               title: '¿Está seguro de eliminar esta especialidad?',
                                                               text: "Esta acción no se puede deshacer.",
                                                               icon: 'warning',
                                                               showCancelButton: true,
                                                               confirmButtonText: 'Sí, eliminar',
                                                               cancelButtonText: 'Cancelar'
                                                           }).then((result) => {
                                                               if (result.isConfirmed) {
                                                                   // Construir la URL de eliminación para especialidad y redirigir
                                                                   window.location.href = 'ControlDoctor?opc=8&id=' + id;
                                                               }
                                                           });
                                                       }
                                                       window.onload = function () {
                                                           const urlParams = new URLSearchParams(window.location.search);
                                                           if (urlParams.get('modalOpen') === 'true') {
                                                               const modal = new bootstrap.Modal(document.getElementById('especialidadModal'));
                                                               modal.show();
                                                           }

                                                           // Verificar si el parámetro de error existe
                                                           if (urlParams.has('error')) {
                                                               Swal.fire({
                                                                   title: '¡Error!',
                                                                   text: urlParams.get('error'), // Mensaje de error pasado en la URL
                                                                   icon: 'error',
                                                                   confirmButtonText: 'Cerrar'
                                                               });
                                                           }
                                                       };

        </script>
        <%@include file="../footer.jsp" %>
    </body>
</html>
