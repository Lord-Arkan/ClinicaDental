package dao;

import InterFace.IGenericDAO;
import modelo.Empleado;
import util.MySQLConexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase DAO para la entidad {@link Empleado}. Implementa las operaciones de la
 * interfaz genérica {@link IGenericDAO}. Proporciona métodos para realizar
 * operaciones CRUD sobre la tabla "empleado" en la base de datos.
 */
public class EmpleadoDao implements IGenericDAO<Empleado> {

    /**
     * Lista todos los empleados registrados en la base de datos.
     *
     * @return una lista de objetos {@link Empleado} que representa a todos los
     * empleados en la base de datos.
     */
    @Override
    public List<Empleado> listar() {
        List<Empleado> lista = new ArrayList<>();
        try (Connection con = MySQLConexion.getConexion(); PreparedStatement ps = con.prepareStatement("SELECT * FROM empleado"); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Empleado emp = new Empleado();
                emp.setId(rs.getInt("id"));
                emp.setDni(rs.getString("dni"));
                emp.setNom(rs.getString("nom"));
                emp.setEdad(rs.getString("edad"));
                emp.setTel(rs.getString("tel"));
                emp.setEstado(rs.getString("estado"));
                emp.setRol(rs.getString("rol"));
                emp.setUser(rs.getString("user"));
                emp.setPass(rs.getString("pass"));
                lista.add(emp);
            }
        } catch (SQLException ex) {
            System.out.println("Error al listar empleados: " + ex.getMessage());
        }
        return lista;
    }

    /**
     * Agrega un nuevo empleado a la base de datos.
     *
     * @param emp el objeto {@link Empleado} que se desea agregar.
     * @return el ID generado para el nuevo empleado, o -1 si no se pudo
     * insertar.
     * @throws SQLException si ocurre un error al ejecutar la consulta.
     */
    @Override
    public int agregar(Empleado emp) throws SQLException {
        String sql = "INSERT INTO empleado (dni, nom, edad, tel, estado, rol, user, pass) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = MySQLConexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, emp.getDni());
            ps.setString(2, emp.getNom());
            ps.setString(3, emp.getEdad());
            ps.setString(4, emp.getTel());
            ps.setString(5, emp.getEstado());
            ps.setString(6, emp.getRol());
            ps.setString(7, emp.getUser());
            ps.setString(8, emp.getPass());

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // Retorna el ID generado
            }
        }
        return -1;
    }

    /**
     * Actualiza la información de un empleado existente en la base de datos.
     *
     * @param emp el objeto {@link Empleado} con los datos actualizados.
     * @throws SQLException si ocurre un error al ejecutar la consulta.
     */
    @Override
    public void actualizar(Empleado emp) throws SQLException {
        String sql = "UPDATE empleado SET dni = ?, nom = ?, edad = ?, tel = ?, estado = ?, rol = ?, user = ?, pass = ? WHERE id = ?";
        try (Connection con = MySQLConexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, emp.getDni());
            ps.setString(2, emp.getNom());
            ps.setString(3, emp.getEdad());
            ps.setString(4, emp.getTel());
            ps.setString(5, emp.getEstado());
            ps.setString(6, emp.getRol());
            ps.setString(7, emp.getUser());
            ps.setString(8, emp.getPass());
            ps.setInt(9, emp.getId());

            ps.executeUpdate();
        }
    }

    /**
     * Elimina un empleado de la base de datos.
     *
     * @param id el ID del empleado a eliminar.
     * @throws SQLException si ocurre un error al ejecutar la consulta.
     */
    @Override
    public void eliminar(int id) throws SQLException {
        String sql = "DELETE FROM empleado WHERE id = ?";
        try (Connection con = MySQLConexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    /**
     * Obtiene un empleado por su ID.
     *
     * @param id el ID del empleado a buscar.
     * @return un objeto {@link Empleado} con los datos del empleado, o
     * {@code null} si no se encuentra.
     */
    public Empleado obtenerPorId(int id) {
        Empleado emp = null;
        String sql = "SELECT * FROM empleado WHERE id = ?";
        try (Connection con = MySQLConexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    emp = new Empleado();
                    emp.setId(rs.getInt("id"));
                    emp.setDni(rs.getString("dni"));
                    emp.setNom(rs.getString("nom"));
                    emp.setEdad(rs.getString("edad"));
                    emp.setTel(rs.getString("tel"));
                    emp.setEstado(rs.getString("estado"));
                    emp.setRol(rs.getString("rol"));
                    emp.setUser(rs.getString("user"));
                    emp.setPass(rs.getString("pass"));
                }
            }
        } catch (SQLException ex) {
            System.out.println("Error al obtener empleado por ID: " + ex.getMessage());
        }
        return emp;
    }

    /**
     * Valida un usuario y su contraseña.
     *
     * @param user el nombre de usuario.
     * @param pass la contraseña.
     * @return un objeto {@link Empleado} si las credenciales son correctas, o
     * {@code null} si no lo son.
     */
    public Empleado validarUsuario(String user, String pass) {
        Empleado emp = null;
        String sql = "SELECT * FROM empleado WHERE user = ? AND pass = ?";
        try (Connection con = MySQLConexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    emp = new Empleado();
                    emp.setId(rs.getInt("id"));
                    emp.setDni(rs.getString("dni"));
                    emp.setNom(rs.getString("nom"));
                    emp.setEdad(rs.getString("edad"));
                    emp.setTel(rs.getString("tel"));
                    emp.setEstado(rs.getString("estado"));
                    emp.setRol(rs.getString("rol"));
                    emp.setUser(rs.getString("user"));
                    emp.setPass(rs.getString("pass"));
                }
            }
        } catch (SQLException ex) {
            System.out.println("Error al validar el usuario: " + ex.getMessage());
        }
        return emp;
    }

    /**
     * Verifica si ya existe un empleado con el mismo nombre de usuario o DNI.
     *
     * @param user el nombre de usuario del empleado.
     * @param dni el DNI del empleado.
     * @return {@code true} si el empleado existe, {@code false} si no existe.
     */
    public boolean empleadoExiste(String user, String dni) {
        String sql = "SELECT * FROM empleado WHERE user = ? OR dni = ?";
        try (Connection con = MySQLConexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user);
            ps.setString(2, dni);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();  // Si hay algún resultado, significa que el empleado ya existe
            }
        } catch (SQLException ex) {
            return false;
        }
    }

}
