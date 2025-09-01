package dao;

import InterFace.IGenericDAO;
import modelo.*;
import util.MySQLConexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// Implementación de la interfaz genérica para la entidad Cita
public class CitasDAO implements IGenericDAO<Cita> {

    @Override
    public int agregar(Cita cita) throws SQLException {
        Connection cn = MySQLConexion.getConexion();
        String sql = "INSERT INTO citas (iddoctor, idcliente, fecha, mensaje, estado) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement st = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

        st.setInt(1, cita.getIdDoctor());
        st.setInt(2, cita.getIdCliente());
        st.setTimestamp(3, cita.getFecha()); // Asume que es un Timestamp
        st.setString(4, cita.getMensaje());
        st.setString(5, cita.getEstado());

        st.executeUpdate();
        ResultSet rs = st.getGeneratedKeys();
        rs.next();
        return rs.getInt(1); // Retorna el ID generado
    }

    @Override
    public List<Cita> listar() throws SQLException {
        Connection cn = MySQLConexion.getConexion();
        String sql = "SELECT * FROM citas";
        PreparedStatement st = cn.prepareStatement(sql);
        ResultSet rs = st.executeQuery();

        List<Cita> citas = new ArrayList<>();
        while (rs.next()) {
            Cita cita = new Cita();
            cita.setId(rs.getInt("id"));
            cita.setIdDoctor(rs.getInt("iddoctor"));
            cita.setIdCliente(rs.getInt("idcliente"));
            cita.setFecha(rs.getTimestamp("fecha"));
            cita.setMensaje(rs.getString("mensaje"));
            cita.setEstado(rs.getString("estado"));
            citas.add(cita);
        }
        return citas;
    }

    @Override
    public void actualizar(Cita cita) throws SQLException {
        Connection cn = MySQLConexion.getConexion();
        String sql = "UPDATE citas SET iddoctor = ?, idcliente = ?, fecha = ?, mensaje = ?, estado = ? WHERE id = ?";
        PreparedStatement st = cn.prepareStatement(sql);

        st.setInt(1, cita.getIdDoctor());
        st.setInt(2, cita.getIdCliente());
        st.setTimestamp(3, cita.getFecha());
        st.setString(4, cita.getMensaje());
        st.setString(5, cita.getEstado());
        st.setInt(6, cita.getId());

        st.executeUpdate();
    }

    @Override
    public void eliminar(int id) throws SQLException {
        Connection cn = MySQLConexion.getConexion();
        String sql = "DELETE FROM citas WHERE id = ?";
        PreparedStatement st = cn.prepareStatement(sql);

        st.setInt(1, id);
        st.executeUpdate();
    }

    // Método para ejecutar el procedimiento almacenado 'realizar_cita'
    public void realizarCita(Cliente cliente, int idDoctor, Timestamp fecha, String mensaje, String estado) throws SQLException {
        Connection cn = MySQLConexion.getConexion();
        String sql = "{CALL realizar_cita(?, ?, ?, ?, ?, ?, ?, ?)}";

        try (CallableStatement cs = cn.prepareCall(sql)) {
            // Establecer los parámetros para el procedimiento almacenado
            cs.setString(1, cliente.getNombre());
            cs.setString(2, cliente.getApellidos());
            cs.setString(3, cliente.getCorreo());
            cs.setString(4, cliente.getDireccion());
            cs.setInt(5, idDoctor);
            cs.setTimestamp(6, fecha); // Cambiado el orden para que coincida con el procedimiento
            cs.setString(7, mensaje);
            cs.setString(8, estado); // Asegúrate de que este sea el orden correcto

            cs.execute();
            System.out.println("Cita registrada con éxito.");
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    // Versión para nuevas citas (sin idCita)
    public boolean verificarDisponibilidad(int idDoctor, Timestamp fecha) throws SQLException {
        return verificarDisponibilidad(idDoctor, fecha, -1); // Usa -1 como id ficticio
    }

    // Versión para edición de citas (con id)
    public boolean verificarDisponibilidad(int idDoctor, Timestamp fecha, int id) throws SQLException {
        // Obtener la fecha y la hora actual
        Timestamp ahora = new Timestamp(System.currentTimeMillis());

        // Verificar que la fecha seleccionada sea en el futuro
        if (fecha.before(ahora)) {
            return false;
        }

        // Obtener día de la semana y hora de la fecha solicitada
        int dayOfWeek = fecha.toLocalDateTime().getDayOfWeek().getValue(); // 1=Lunes, ..., 7=Domingo
        int hour = fecha.toLocalDateTime().getHour();

        // Validar el horario laboral:
        if ((dayOfWeek >= 1 && dayOfWeek <= 5 && (hour < 9 || hour >= 18 || (hour >= 13 && hour < 14))) // Lunes a Viernes
                || (dayOfWeek == 6 && (hour < 9 || hour >= 13)) // Sábados
                || dayOfWeek == 7) { // Domingo
            return false;
        }

        // Comprobar si ya existe una cita en el mismo horario para el doctor, ignorando la cita actual
        String sql = "SELECT COUNT(*) FROM citas WHERE iddoctor = ? AND fecha = ? AND id != ?";
        try (Connection cn = MySQLConexion.getConexion(); PreparedStatement st = cn.prepareStatement(sql)) {
            st.setInt(1, idDoctor);
            st.setTimestamp(2, fecha);
            st.setInt(3, id);  // Ignorar la cita actual en la verificación
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        }
        return false;
    }

}
