<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Inicio de Sesión - Clínica Dental</title>

        <!-- Estilos de Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Bootstrap Icons CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

        <!-- SweetAlert CSS y JS -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <!-- Estilos adicionales -->
        <style>
            /* Fondo con degradado y animación */
            body {
                background: linear-gradient(135deg, #3498db, #8e44ad);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                animation: gradientMove 5s infinite alternate;
                margin: 0;
            }

            @keyframes gradientMove {
                0% {
                    background-position: 0% 50%;
                }
                100% {
                    background-position: 100% 50%;
                }
            }

            /* Tarjeta de login */
            .login-container {
                background-color: rgba(255, 255, 255, 0.9);
                padding: 2rem;
                border-radius: 15px;
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
                width: 100%;
                max-width: 400px;
                text-align: center;
                opacity: 0;
                transform: scale(0.9);
                animation: popIn 0.6s ease-out forwards;
            }

            @keyframes popIn {
                from {
                    opacity: 0;
                    transform: scale(0.7);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }

            /* Imagen y título */
            .login-container img {
                width: 100px;
                margin-bottom: 1rem;
                animation: bounceIn 1s ease;
            }

            @keyframes bounceIn {
                0%, 20%, 50%, 80%, 100% {
                    transform: translateY(0);
                }
                40% {
                    transform: translateY(-20px);
                }
                60% {
                    transform: translateY(-10px);
                }
            }

            .login-container h3 {
                font-family: 'Poppins', sans-serif;
                margin-bottom: 2rem;
                color: #333;
            }

            /* Estilos de input y label flotante */
            .form-floating {
                position: relative;
            }

            .form-floating input {
                padding-right: 45px;
                border: 1px solid #ddd;
                transition: box-shadow 0.3s ease;
            }

            .form-floating input:focus {
                box-shadow: 0 0 8px rgba(52, 152, 219, 0.5);
            }

            .form-floating .toggle-password {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                cursor: pointer;
            }

            .forgot-password {
                margin-top: 1rem;
            }

            .forgot-password a {
                color: #007bff;
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .forgot-password a:hover {
                color: #0056b3;
            }

            /* Botón de inicio de sesión */
            .btn-primary {
                width: 100%;
                background-color: #007bff;
                border-color: #007bff;
                transition: transform 0.2s ease;
            }

            .btn-primary:hover {
                transform: scale(1.05);
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <!-- Imagen del logotipo o clínica -->
            <img src="https://img.icons8.com/clouds/100/000000/tooth.png" alt="Logotipo Clínica Dental">
            <h3>Iniciar Sesión</h3>

            <!-- Dentro de tu formulario en admin/index.jsp -->
            <form action="${pageContext.request.contextPath}/login" method="POST">
                <!-- Usuario -->
                <div class="form-floating mb-3">
                    <input name="txtuser" type="text" class="form-control" id="txtuser" placeholder="Correo electrónico" required>
                    <label for="txtuser">Correo Electrónico</label>
                </div>

                <!-- Contraseña con el botón para mostrar/ocultar -->
                <div class="form-floating mb-3">
                    <input name="txtpass" type="password" class="form-control" id="password" placeholder="Contraseña" required>
                    <label for="txtpass">Contraseña</label>
                    <i class="bi bi-eye-slash toggle-password" onclick="togglePasswordVisibility()"></i>
                </div>

                <!-- Botón de Iniciar Sesión -->
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary">Iniciar Sesión</button>
                </div>

                <!-- Opción de Recuperar Contraseña -->
                <div class="forgot-password">
                    
                </div>
            </form>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Script para el botón de mostrar/ocultar contraseña -->
        <script>
                        function togglePasswordVisibility() {
                            var passwordInput = document.getElementById('password');
                            var icon = document.querySelector('.toggle-password');
                            if (passwordInput.type === 'password') {
                                passwordInput.type = 'text';
                                icon.classList.remove('bi-eye-slash');
                                icon.classList.add('bi-eye');
                            } else {
                                passwordInput.type = 'password';
                                icon.classList.remove('bi-eye');
                                icon.classList.add('bi-eye-slash');
                            }
                        }
        </script>

        <!-- Mostrar mensaje de error con SweetAlert si loginError es true -->
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var loginError = "<%= request.getAttribute("loginError")%>";
                if (loginError === "Inactivo") {
                    Swal.fire({
                        icon: 'error',
                        title: 'Acceso denegado',
                        text: 'Tu cuenta está inactiva. Contacta con el administrador.',
                        confirmButtonText: 'Aceptar'
                    });
                } else if (loginError === "credentials") {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error de inicio de sesión',
                        text: 'Usuario o contraseña incorrectos',
                        confirmButtonText: 'Aceptar'
                    });
                }
            });
        </script>
    </body>
</html>
