package dao;

import InterFace.IGenericDAO;
import modelo.Cliente;
import util.MySQLConexion;

import java.sql.*;
import java.util.*;

/**
 * Clase que implementa la interfaz genérica {@code IGenericDAO} para la entidad
 * {@code Cliente}. Proporciona métodos para realizar operaciones CRUD sobre la
 * tabla {@code cliente} en la base de datos.
 */
public class ClienteDAO implements IGenericDAO<Cliente> {

    /**
     * Agrega un nuevo cliente a la base de datos.
     *
     * @param cliente el objeto {@code Cliente} que se desea agregar.
     * @return el ID generado para el nuevo cliente.
     * @throws SQLException si ocurre un error al ejecutar la consulta.
     */
    @Override
    public int agregar(Cliente cliente) throws SQLException {
        Connection cn = MySQLConexion.getConexion();
        String sql = "INSERT INTO cliente (nombre, apellidos, correo, direccion) VALUES (?,?,?,?)";
        PreparedStatement st = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

        st.setString(1, cliente.getNombre());
        st.setString(2, cliente.getApellidos());
        st.setString(3, cliente.getCorreo());
        st.setString(4, cliente.getDireccion());

        st.executeUpdate();
        ResultSet rs = st.getGeneratedKeys();
        rs.next();
        return rs.getInt(1); // Retorna el ID generado
    }

    // Método para agregar un nuevo cliente y devolver su ID
    public int agregarCliente(Cliente cliente) throws SQLException {
        return agregar(cliente); // Reutilizamos el método existente para insertar
    }

    /**
     * Lista todos los clientes registrados en la base de datos.
     *
     * @return una lista de objetos {@code Cliente}.
     * @throws SQLException si ocurre un error al ejecutar la consulta.
     */
    @Override
    public List<Cliente> listar() throws SQLException {
        Connection cn = MySQLConexion.getConexion();
        String sql = "SELECT * FROM cliente";
        PreparedStatement st = cn.prepareStatement(sql);
        ResultSet rs = st.executeQuery();

        List<Cliente> clientes = new ArrayList<>();
        while (rs.next()) {
            Cliente cliente = new Cliente();
            cliente.setId(rs.getInt("id"));
            cliente.setNombre(rs.getString("nombre"));
            cliente.setApellidos(rs.getString("apellidos"));
            cliente.setCorreo(rs.getString("correo"));
            cliente.setDireccion(rs.getString("direccion"));
            clientes.add(cliente);
        }
        return clientes;
    }

    /**
     * Actualiza la información de un cliente existente en la base de datos.
     *
     * @param cliente el objeto {@code Cliente} con la información actualizada.
     * @throws SQLException si ocurre un error al ejecutar la consulta o si el
     * cliente no existe.
     */
    @Override
    public void actualizar(Cliente cliente) throws SQLException {
        String sql = "UPDATE cliente SET nombre = ?, apellidos = ?, correo = ?, direccion = ? WHERE id = ?";
        try (Connection cn = MySQLConexion.getConexion(); PreparedStatement st = cn.prepareStatement(sql)) {

            st.setString(1, cliente.getNombre());
            st.setString(2, cliente.getApellidos());
            st.setString(3, cliente.getCorreo());
            st.setString(4, cliente.getDireccion());
            st.setInt(5, cliente.getId());

            int rowsUpdated = st.executeUpdate();
            System.out.println("Filas actualizadas en Cliente: " + rowsUpdated);
            if (rowsUpdated == 0) {
                throw new SQLException("No se pudo actualizar el cliente, ID no encontrado.");
            }
        }
    }

    /**
     * Elimina un cliente de la base de datos.
     *
     * @param id el ID del cliente que se desea eliminar.
     * @throws SQLException si ocurre un error al ejecutar la consulta.
     */
    @Override
    public void eliminar(int id) throws SQLException {
        Connection cn = MySQLConexion.getConexion();
        String sql = "DELETE FROM cliente WHERE id = ?";
        PreparedStatement st = cn.prepareStatement(sql);

        st.setInt(1, id);
        st.executeUpdate();
    }

    /**
     * Muestra el historial de citas de un cliente, incluyendo el nombre
     * completo del doctor.
     *
     * @param idCliente el ID del cliente cuyo historial se desea consultar.
     * @return una lista de mapas con información sobre las citas del cliente.
     */
    // Método modificado para obtener historial de citas por cliente con nombre completo del doctor
    public List<Map<String, Object>> mostrarHistorialCitasPorCliente(int idCliente) {
        Connection cn = MySQLConexion.getConexion();
        List<Map<String, Object>> lista = new ArrayList<>();
        try {
            String sql = "SELECT c.id, CONCAT(d.nombre, ' ', d.apellidos) AS doctor, c.fecha, c.mensaje, c.estado "
                    + "FROM citas c "
                    + "JOIN doctor d ON c.iddoctor = d.id "
                    + "WHERE c.idcliente = ?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("doctor", rs.getString("doctor")); // Nombre completo del doctor
                map.put("fecha", rs.getTimestamp("fecha"));
                map.put("mensaje", rs.getString("mensaje"));
                map.put("estado", rs.getString("estado"));
                lista.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log para depuración
        }
        return lista;
    }

    /**
     * Obtiene un cliente por su ID.
     *
     * @param idCliente el ID del cliente que se desea consultar.
     * @return un objeto {@code Cliente} si se encuentra, o {@code null} si no
     * existe.
     */
    public Cliente obtenerClientePorId(int idCliente) {
        Connection cn = MySQLConexion.getConexion();
        String sql = "SELECT id, nombre, apellidos, correo, direccion FROM cliente WHERE id = ?";
        try (PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Cliente cliente = new Cliente();
                    cliente.setId(rs.getInt("id"));
                    cliente.setNombre(rs.getString("nombre"));
                    cliente.setApellidos(rs.getString("apellidos"));
                    cliente.setCorreo(rs.getString("correo"));
                    cliente.setDireccion(rs.getString("direccion"));
                    return cliente;
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log de error para depuración
        }
        return null; // Retorna null si no encuentra el cliente
    }

    /**
     * Verifica si un cliente ya existe en la base de datos, comparando el
     * nombre, apellido y correo.
     *
     * @param nombre el nombre del cliente a verificar.
     * @param apellidos los apellidos del cliente a verificar.
     * @param correo el correo electrónico del cliente a verificar.
     * @return {@code true} si el cliente ya existe (es decir, si hay un cliente
     * con el mismo nombre, apellidos y correo en la base de datos),
     * {@code false} en caso contrario.
     * @throws SQLException si ocurre un error al realizar la consulta a la base
     * de datos.
     */
    public boolean clienteExiste(String nombre, String apellidos, String correo) throws SQLException {
        String sql = "SELECT COUNT(*) FROM cliente WHERE nombre = ? AND apellidos = ? AND correo = ?";
        try (Connection cn = MySQLConexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, apellidos);
            ps.setString(3, correo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;  // Si el conteo es mayor a 0, los 3 campos coinciden
                }
            }
        }
        return false;  // Ningún cliente con todos los datos coincidentes
    }
public boolean especialidadExiste(String tipo) throws SQLException {
    String sql = "SELECT 1 FROM especialidad WHERE tipo = ?";
    try (Connection cn = MySQLConexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setString(1, tipo);
        try (ResultSet rs = ps.executeQuery()) {
            return rs.next();  // Devuelve true si existe, false si no
        }
    }
}

}
