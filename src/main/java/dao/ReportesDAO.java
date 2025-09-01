package dao;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import util.MySQLConexion;

public class ReportesDAO {

    public int contarClientesRegistrados() {
        int totalClientes = 0;
        String sql = "{CALL contarClientesRegistrados()}";

        try (Connection cn = MySQLConexion.getConexion(); CallableStatement cs = cn.prepareCall(sql); ResultSet rs = cs.executeQuery()) {

            if (rs.next()) {
                totalClientes = rs.getInt("total_clientes");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalClientes;
    }

    public int contarCitasPendientesHoy() {
        int totalPendientes = 0;
        String sql = "{CALL contarCitasPendientesHoy()}";

        try (Connection cn = MySQLConexion.getConexion(); CallableStatement cs = cn.prepareCall(sql); ResultSet rs = cs.executeQuery()) {

            if (rs.next()) {
                totalPendientes = rs.getInt("total_pendientes_hoy");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalPendientes;
    }

    public int contarCitasVencidasHoy() {
        int totalVencidas = 0;
        String sql = "{CALL contarCitasVencidasHoy()}";

        try (Connection cn = MySQLConexion.getConexion(); CallableStatement cs = cn.prepareCall(sql); ResultSet rs = cs.executeQuery()) {

            if (rs.next()) {
                totalVencidas = rs.getInt("total_vencidas_hoy");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalVencidas;
    }

    public List<Map<String, Object>> obtenerCitasEnRango(java.util.Date fechaInicio, java.util.Date fechaFin) {
        List<Map<String, Object>> citas = new ArrayList<>();
        String sql = "SELECT c.fecha, c.estado, d.nombre AS doctor_nombre, d.apellidos AS doctor_apellidos, cl.nombre AS cliente_nombre, cl.apellidos AS cliente_apellidos "
                + "FROM citas c "
                + "JOIN doctor d ON c.iddoctor = d.id "
                + "JOIN cliente cl ON c.idcliente = cl.id "
                + "WHERE c.fecha BETWEEN ? AND ? AND c.estado = 'Pendiente' "
                + "ORDER BY c.fecha ASC"; // Orden ascendente por fecha y hora

        try (Connection cn = MySQLConexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            // Ajuste de fechaInicio a las 00:00:00
            Calendar cal = Calendar.getInstance();
            cal.setTime(fechaInicio);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            fechaInicio = cal.getTime();

            // Ajuste de fechaFin a las 23:59:59
            cal.setTime(fechaFin);
            cal.set(Calendar.HOUR_OF_DAY, 23);
            cal.set(Calendar.MINUTE, 59);
            cal.set(Calendar.SECOND, 59);
            fechaFin = cal.getTime();

            ps.setTimestamp(1, new java.sql.Timestamp(fechaInicio.getTime()));
            ps.setTimestamp(2, new java.sql.Timestamp(fechaFin.getTime()));
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> cita = new HashMap<>();
                Timestamp fecha = rs.getTimestamp("fecha");
                cita.put("fecha", fecha);
                cita.put("hora", new SimpleDateFormat("hh:mm a").format(fecha)); // Formato 12 horas AM/PM
                cita.put("estado", rs.getString("estado"));
                cita.put("doctor", rs.getString("doctor_nombre") + " " + rs.getString("doctor_apellidos"));
                cita.put("cliente", rs.getString("cliente_nombre") + " " + rs.getString("cliente_apellidos"));
                citas.add(cita);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }

  

}
