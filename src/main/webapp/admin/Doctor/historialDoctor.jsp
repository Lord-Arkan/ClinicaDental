<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${titulo}</title>
        <!-- Bootstrap CSS -->
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">
    </head>
    <body>
        <%@include file="../header.jsp" %>

        <div class="container my-5" data-aos="fade-up">
            <h1 class="text-center mb-4">${titulo}</h1>

            <!-- Tabla de historial de citas -->
            <table id="tabla" class="table table-bordered table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Cliente</th>
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
                            <td>${cita.cliente}</td>
                            <!-- Separar la fecha en formato dd-MM-yyyy -->
                            <td><fmt:formatDate value="${cita.fecha}" pattern="dd-MM-yyyy" /></td>
                            <!-- Mostrar la hora en formato de 12 horas con AM/PM -->
                            <td><fmt:formatDate value="${cita.fecha}" pattern="hh:mm a" /></td>
                            <td>${cita.mensaje}</td>
                            <td>
                                <span class="badge 
                                      <c:choose>
                                          <c:when test="${cita.estado == 'Pendiente'}">bg-warning text-dark</c:when>
                                          <c:when test="${cita.estado == 'Completada'}">bg-success</c:when>
                                          <c:when test="${cita.estado == 'Cancelada'}">bg-danger</c:when>
                                          <c:otherwise>bg-secondary</c:otherwise>
                                      </c:choose>
                                      ">
                                    ${cita.estado}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${citas.isEmpty()}">
                        <tr>
                            <td colspan="6" class="text-center">No hay citas registradas para este doctor.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

            <!-- Botón de regreso -->
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/ControlDoctor?opc=1" class="btn btn-secondary">Regresar</a>
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
                        "info": "Mostrando _START_ a _END_ de _TOTAL_ Citas",
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
        <%@include file="../footer.jsp" %>
    </body>
</html>

