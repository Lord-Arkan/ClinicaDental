<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="dao.GraficoDao" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONArray" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Reportes</title>
        <%@include file="header.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .form-group {
                margin-bottom: 1.2rem;
            }
            .form-control {
                width: 80%; /* Reducción del tamaño de los controles */
                margin: 0 auto;
            }
            .container {
                margin-top: 2rem;
            }
            .card-body {
                padding: 2rem;
            }
            .card-title {
                font-size: 1.5rem;
            }
        </style>
    </head>
    <body>
        <section id="reportes" class="admin-section section" data-aos="fade-up">
           

            <!-- Card para el gráfico de Citas Vencidas por Mes -->
            <div class="container my-5 d-flex justify-content-center">
                <div class="card shadow-sm border-0" style="width: 100%; max-width: 1000px;">
                    <div class="card-body">
                        <h3 class="card-title text-center mb-4">Citas Vencidas por Mes</h3>
                        
                        <!-- Formulario para seleccionar el año y el tipo de gráfico -->
                        <form id="form-reporte" class="text-center">
                            <div class="form-group">
                                <label for="year">Ingresa el año:</label>
                                <input type="number" name="year" id="year" class="form-control" style="width: 60%;" placeholder="Ej: 2023">
                            </div>
                            <div class="form-group">
                                <label for="chartType">Selecciona el tipo de gráfico:</label>
                                <select name="chartType" id="chartType" class="form-control">
                                    <option value="line">Lineal</option>
                                    <option value="bar">Barras</option>
                                    <option value="pie">Torta</option>
                                </select>
                            </div>
                        </form>

                        <!-- Gráfico -->
                        <canvas id="citasVencidasPorMesChart" width="900" height="400"></canvas>
                    </div>
                </div>
            </div>

        </section>

        <%
            // Obtener parámetros del formulario (año y tipo de gráfico)
            String yearParam = request.getParameter("year");
            String chartTypeParam = request.getParameter("chartType");

            // Comprobar que se recibió un tipo de gráfico
            if (chartTypeParam != null && !chartTypeParam.isEmpty()) {
                int year = (yearParam != null && !yearParam.isEmpty()) ? Integer.parseInt(yearParam) : 0;

                // Obtener datos de citas vencidas por mes para el año seleccionado (si se pasó el año)
                GraficoDao graficoDao = new GraficoDao();
                Map<String, Integer> citasPorMes = (year > 0) ? graficoDao.contarCitasVencidasPorMesPorAno(year) : graficoDao.contarCitasVencidasPorMesUltimoAno();

                // Convertir los datos a formato JSON para pasarlos a JavaScript
                String mesesJson = new JSONArray(new ArrayList<>(citasPorMes.keySet())).toString();
                String totalesJson = new JSONArray(new ArrayList<>(citasPorMes.values())).toString();
                request.setAttribute("mesesJson", mesesJson);
                request.setAttribute("totalesJson", totalesJson);
            }
        %>

        <script>
            // Definir una paleta de colores para los gráficos
            const colorPalette = [
                'rgba(255, 99, 132, 0.8)', 'rgba(54, 162, 235, 0.8)', 'rgba(255, 206, 86, 0.8)', 'rgba(75, 192, 192, 0.8)',
                'rgba(153, 102, 255, 0.8)', 'rgba(255, 159, 64, 0.8)', 'rgba(255, 99, 71, 0.8)', 'rgba(0, 255, 255, 0.8)',
                'rgba(255, 20, 147, 0.8)', 'rgba(34, 139, 34, 0.8)', 'rgba(255, 165, 0, 0.8)', 'rgba(75, 0, 130, 0.8)'
            ];

            // Obtener el tipo de gráfico desde el parámetro JSP
            const chartType = '<%= chartTypeParam %>'; // "line", "bar" o "pie"
            const mesesJson = '<%= request.getAttribute("mesesJson") %>';
            const totalesJson = '<%= request.getAttribute("totalesJson") %>';

            // Convertir las cadenas JSON en objetos JavaScript
            const meses = JSON.parse(mesesJson); // Meses en formato JSON
            const citas = JSON.parse(totalesJson); // Totales de citas vencidas en formato JSON

            const ctx = document.getElementById('citasVencidasPorMesChart').getContext('2d');

            // Crear el gráfico con el tipo seleccionado
            let citasVencidasPorMesChart = new Chart(ctx, {
                type: chartType, // Usar el tipo seleccionado en el formulario
                data: {
                    labels: meses,
                    datasets: [{
                        label: 'Citas Vencidas',
                        data: citas,
                        backgroundColor: chartType === 'pie' ? colorPalette : colorPalette[0], // Para "pie", usar todos los colores
                        borderColor: chartType !== 'pie' ? colorPalette[0] : 'rgba(0,0,0,0)', // Bordes para otros tipos de gráficos
                        fill: chartType !== 'pie', // No rellenar para gráfico de torta
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top',
                            labels: {
                                fontSize: 14
                            }
                        }
                    },
                    scales: chartType !== 'pie' ? {
                        x: {
                            scaleLabel: {
                                display: true,
                                labelString: 'Mes',
                                fontSize: 16
                            }
                        },
                        y: {
                            ticks: {
                                beginAtZero: true
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'Citas Vencidas',
                                fontSize: 16
                            }
                        }
                    } : {}
                }
            });

            // Actualizar el gráfico cuando se cambie el tipo
            document.getElementById('chartType').addEventListener('change', function() {
                const newChartType = this.value;

                // Actualizar el gráfico sin recargar la página
                citasVencidasPorMesChart.destroy(); // Destruir el gráfico anterior
                citasVencidasPorMesChart = new Chart(ctx, {
                    type: newChartType,
                    data: {
                        labels: meses,
                        datasets: [{
                            label: 'Citas Vencidas',
                            data: citas,
                            backgroundColor: newChartType === 'pie' ? colorPalette : colorPalette[0],
                            borderColor: newChartType !== 'pie' ? colorPalette[0] : 'rgba(0,0,0,0)',
                            fill: newChartType !== 'pie',
                            tension: 0.1
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                display: true,
                                position: 'top',
                                labels: {
                                    fontSize: 14
                                }
                            }
                        },
                        scales: newChartType !== 'pie' ? {
                            x: {
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Mes',
                                    fontSize: 16
                                }
                            },
                            y: {
                                ticks: {
                                    beginAtZero: true
                                },
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Citas Vencidas',
                                    fontSize: 16
                                }
                            }
                        } : {}
                    }
                });
            });
        </script>

        <%@include file="footer.jsp" %>
    </body>
</html>

