<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.*"%>
<%@page import="dao.ReportesDAO"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
    String ajax = request.getParameter("ajax");
    if ("true".equals(ajax)) {
        long fechaInicioMillis = Long.parseLong(request.getParameter("fechaInicio"));
        long fechaFinMillis = Long.parseLong(request.getParameter("fechaFin"));

        Date fechaInicio = new Date(fechaInicioMillis);
        Date fechaFin = new Date(fechaFinMillis);

        ReportesDAO reportesDAO = new ReportesDAO();
        List<Map<String, Object>> citas = reportesDAO.obtenerCitasEnRango(fechaInicio, fechaFin);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String json = new Gson().toJson(citas);
        response.getWriter().write(json);
        return;
    }

    int mes;
    int año;
    int diaInicioSemana;

    try {
        mes = Integer.parseInt(request.getParameter("mes"));
        año = Integer.parseInt(request.getParameter("año"));
        diaInicioSemana = Integer.parseInt(request.getParameter("diaInicioSemana"));
    } catch (NumberFormatException e) {
        Calendar calendar = Calendar.getInstance();
        mes = calendar.get(Calendar.MONTH) + 1;
        año = calendar.get(Calendar.YEAR);
        calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
        diaInicioSemana = calendar.get(Calendar.DAY_OF_MONTH);
    }

    String[] nombresMes = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};
    String nombreMes = nombresMes[mes - 1];

    Calendar calendar = Calendar.getInstance();
    calendar.set(Calendar.YEAR, año);
    calendar.set(Calendar.MONTH, mes - 1);
    calendar.set(Calendar.DAY_OF_MONTH, diaInicioSemana);

    Date fechaInicioSemana = calendar.getTime();
    calendar.add(Calendar.DAY_OF_MONTH, 6);
    Date fechaFinSemana = calendar.getTime();

    calendar.setTime(fechaInicioSemana);
    List<Integer> diasSemanaActual = new ArrayList<>();
    List<String> mesesDiasSemanaActual = new ArrayList<>();
    List<Integer> añosDiasSemanaActual = new ArrayList<>();

    for (int i = 0; i < 7; i++) {
        diasSemanaActual.add(calendar.get(Calendar.DAY_OF_MONTH));
        mesesDiasSemanaActual.add(nombresMes[calendar.get(Calendar.MONTH)]);
        añosDiasSemanaActual.add(calendar.get(Calendar.YEAR));
        calendar.add(Calendar.DAY_OF_MONTH, 1);
    }

    calendar.setTime(fechaInicioSemana);
    calendar.add(Calendar.DAY_OF_MONTH, -7);
    int diaInicioSemanaAnterior = calendar.get(Calendar.DAY_OF_MONTH);
    int mesAnterior = calendar.get(Calendar.MONTH) + 1;
    int añoAnterior = calendar.get(Calendar.YEAR);

    calendar.setTime(fechaInicioSemana);
    calendar.add(Calendar.DAY_OF_MONTH, 7);
    int diaInicioSemanaSiguiente = calendar.get(Calendar.DAY_OF_MONTH);
    int mesSiguiente = calendar.get(Calendar.MONTH) + 1;
    int añoSiguiente = calendar.get(Calendar.YEAR);

    ReportesDAO reportesDAO = new ReportesDAO();
    List<Map<String, Object>> citas = reportesDAO.obtenerCitasEnRango(fechaInicioSemana, fechaFinSemana);

    Map<String, List<Map<String, Object>>> citasPorDia = new HashMap<>();
    for (Map<String, Object> cita : citas) {
        Calendar citaCalendar = Calendar.getInstance();
        citaCalendar.setTime((java.util.Date) cita.get("fecha"));
        String claveDia = new SimpleDateFormat("yyyy-MM-dd").format(citaCalendar.getTime());

        citasPorDia.putIfAbsent(claveDia, new ArrayList<>());
        citasPorDia.get(claveDia).add(cita);
    }

    String[] diasSemana = {"Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"};
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <style>
            .calendario {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                gap: 0;
            }
            .dia-card {
                padding: 20px;
                background-color: #ffffff;
                border: 1px solid #ced4da;
                min-height: 150px;
                text-align: center;
            }
            .header-dia {
                text-align: center;
                font-weight: bold;
                color: #007bff;
                border: 1px solid #ced4da;
                background-color: #f8f9fa;
                padding: 10px 0;
            }
            .cita {
                padding: 10px;
                margin-top: 10px;
                background-color: #f0f4f8;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .cita p {
                margin: 0;
                font-size: 0.9rem;
                color: #333;
            }
        </style>
    </head>
    <body style="background-color: #f5f7fa;">
        <div class="container my-5">
            <h2 class="text-center mb-4 font-weight-bold"><%= año%></h2>
            <div class="text-center mb-4">
                <a href="?mes=<%= mesAnterior%>&año=<%= añoAnterior%>&diaInicioSemana=<%= diaInicioSemanaAnterior%>" class="btn btn-primary">Semana Anterior</a>
                <span class="mx-3 font-weight-bold">Semana del <%= diasSemanaActual.get(0)%> al <%= diasSemanaActual.get(6)%> de <%= nombreMes%> <%= año%></span>
                <a href="?mes=<%= mesSiguiente%>&año=<%= añoSiguiente%>&diaInicioSemana=<%= diaInicioSemanaSiguiente%>" class="btn btn-primary">Semana Siguiente</a>
            </div>

            <div class="calendario mb-3">
                <% for (int i = 0; i < 7; i++) {%>
                <div class="header-dia"><%= diasSemana[i]%></div>
                <% } %>
            </div>

            <div class="calendario">
                <% for (int i = 0; i < 7; i++) {%>
                <div class="dia-card" data-dia="<%= new SimpleDateFormat("yyyy-MM-dd").format(fechaInicioSemana)%>">
                    <h6 class="text-primary font-weight-bold"><%= diasSemanaActual.get(i)%> de <%= mesesDiasSemanaActual.get(i)%> </h6>
                    <%
                        calendar.set(Calendar.YEAR, añosDiasSemanaActual.get(i));
                        calendar.set(Calendar.MONTH, Arrays.asList(nombresMes).indexOf(mesesDiasSemanaActual.get(i)));
                        calendar.set(Calendar.DAY_OF_MONTH, diasSemanaActual.get(i));

                        String claveDia = new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());

                        if (citasPorDia.containsKey(claveDia)) {
                            for (Map<String, Object> cita : citasPorDia.get(claveDia)) {%>
                    <div class="cita">
                        
                        <p>Dr. <%= cita.get("doctor")%></p>
                        <p><%= cita.get("hora")%></p>
                    </div>
                    <%       }
        } else { %>
                    <p class="text-muted font-italic">Sin citas</p>
                    <%   } %>
                </div>
                <% }%>
            </div>

        </div>

        <script>
            function actualizarCitas() {
                const fechaInicio = new Date("<%= fechaInicioSemana.getTime()%>").getTime();
                const fechaFin = new Date("<%= fechaFinSemana.getTime()%>").getTime();

                fetch(`calendario2.jsp?fechaInicio=${fechaInicio}&fechaFin=${fechaFin}&ajax=true`)
                        .then(response => response.json())
                        .then(data => {
                            document.querySelectorAll(".dia-card").forEach(card => card.innerHTML = "<p class='text-muted font-italic'>Sin citas</p>");
                            data.forEach(cita => {
                                const fechaCita = new Date(cita.fecha);
                                const claveDia = fechaCita.toISOString().split('T')[0];
                                const diaCard = document.querySelector(`.dia-card[data-dia='${claveDia}']`);
                                if (diaCard) {
                                    diaCard.innerHTML += `
                            <div class="cita">
                                <p class="font-weight-bold">${cita.cliente}</p>
                                <p>${cita.hora}</p>
                            </div>
                        `;
                                }
                            });
                        })
                        .catch(error => console.error('Error al actualizar citas:', error));
            }

            // Llama a actualizarCitas cada 60 segundos
            setInterval(actualizarCitas, 60000);

        </script>
    </body>
</html>

