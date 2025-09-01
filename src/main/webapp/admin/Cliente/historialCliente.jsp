<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Historial de Citas del Paciente: </title>
        <!-- Bootstrap CSS -->
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">
    </head>
    <body>
        <%@ include file="../header.jsp" %>

        <div class="container my-5" data-aos="fade-up">
            <h2 class="text-center mb-4">${titulo}</h2>

            <div class="table-responsive">
                <table id="tabla" class="table table-striped table-bordered">
                    <thead class="table-dark">
                        <tr>
                            <th>ID Cita</th>
                            <th>Doctor</th>
                            <th>Fecha</th>
                            <th>Hora</th>
                            <th>Mensaje</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cita" items="${citas}">
                            <tr>
                                <td>${cita.id}</td>
                                <td>${cita.doctor}</td>
                                <!-- Formatear Fecha -->
                                <td>
                                    <fmt:formatDate value="${cita.fecha}" pattern="dd-MM-yyyy"/>
                                </td>
                                <!-- Formatear Hora en 12 horas con AM/PM -->
                                <td>
                                    <fmt:formatDate value="${cita.fecha}" pattern="hh:mm a"/>
                                </td>
                                <td>${cita.mensaje}</td>
                                <td>${cita.estado}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="text-center mt-4">
                <a href="ControlCliente?opc=1" class="btn btn-secondary">Volver a la lista de clientes</a>
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
                        "info": "Mostrando _START_ a _END_ de _TOTAL_ citas",
                        "infoEmpty": "Mostrando 0 a 0 de 0 citas",
                        "infoFiltered": "(Filtrado de _MAX_ total citas)",
                        "infoPostFix": "",
                        "thousands": ",",
                        "lengthMenu": "Mostrar _MENU_ citas",
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
        </script>
        <%@ include file="../footer.jsp" %>
    </body>
</html>
