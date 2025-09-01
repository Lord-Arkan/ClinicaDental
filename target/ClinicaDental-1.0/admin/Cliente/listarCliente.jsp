<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lista de Clientes</title>
        <!-- Bootstrap CSS -->
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">
         <!-- SweetAlert CSS & JS -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body>
        <%@include file="../header.jsp" %>

        <div class="container my-5" data-aos="fade-up">
            <h2 class="text-center mb-4">Lista de Pacientes</h2>
            <div class="text-end mb-3">
                <a href="ControlCliente?opc=2" class="btn btn-primary">Agregar Cliente</a>
            </div>

            <div class="table-responsive">
                <table id="tabla" class="table table-striped table-bordered">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Apellidos</th>
                            <th>Correo</th>
                            <th>Dirección</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cliente" items="${listaClientes}">
                            <tr>
                                <td>${cliente.id}</td>
                                <td>${cliente.nombre}</td>
                                <td>${cliente.apellidos}</td>
                                <td>${cliente.correo}</td>
                                <td>${cliente.direccion}</td>
                                <td>
                                    <a href="ControlCliente?opc=3&id=${cliente.id}" class="btn btn-warning btn-sm me-1">Editar</a>
                                    <a href="ControlCliente?opc=5&id=${cliente.id}" 
                                       class="btn btn-danger btn-sm"
                                        onclick="event.preventDefault(); confirmarEliminacion(${cliente.id});">Eliminar</a>
                                    <a href="ControlCliente?opc=6&id=${cliente.id}" class="btn btn-success btn-sm me-1">Historial</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
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
                       "info": "Mostrando _START_ a _END_ de _TOTAL_ Pacientes",
                       "infoEmpty": "Mostrando 0 a 0 de 0 citas",
                       "infoFiltered": "(Filtrado de _MAX_ total Pacientes)",
                       "infoPostFix": "",
                       "thousands": ",",
                       "lengthMenu": "Mostrar _MENU_ Pacientes",
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
           
            // Confirmación de eliminación con SweetAlert
            function confirmarEliminacion(id) {
                Swal.fire({
                    title: '¿Estás seguro?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Sí, eliminar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = 'ControlCliente?opc=5&id=' + id;
                    }
                });
            }
        </script>

        <%@include file="../footer.jsp" %>
    </body>
</html>

