package sena.adso.roles.util;

import java.io.PrintStream;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 * Clase utilitaria para el envío de correos electrónicos
 */
public class EmailUtil {
    // Configuración del servidor de correo (Gmail)
    private static final String HOST = "smtp.gmail.com";
    private static final String PORT = "587";
    private static final String USERNAME = "osmanaranguren@gmail.com"; // Cambiar por un correo real
    private static final String PASSWORD = "alwrfolphkyidnii"; // Usar contraseña de aplicación
    // Flag para activar/desactivar depuración
    private static final boolean DEBUG = true;

    /**
     * Envía un correo electrónico para recuperación de contraseña
     * @param destinatario Dirección de correo del destinatario
     * @param nuevaPassword Nueva contraseña generada
     * @return true si el envío fue exitoso, false en caso contrario
     */
    public static boolean enviarCorreoRecuperacion(String destinatario, String nuevaPassword) {
        // Configurar propiedades del servidor SMTP
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        
        // Configuración adicional para evitar errores de conexión
        props.put("mail.smtp.connectiontimeout", "5000");
        props.put("mail.smtp.timeout", "5000");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        
        try {
            // Crear sesión con autenticación
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(USERNAME, PASSWORD);
                }
            });

            // Activar depuración si está habilitada
            if (DEBUG) {
                session.setDebug(true);
                session.setDebugOut(new PrintStream(System.out));
                System.out.println("Enviando correo de recuperación a: " + destinatario);
                System.out.println("Usando correo remitente: " + USERNAME);
                System.out.println("Usando contraseña de aplicación: " + PASSWORD.replaceAll(".", "*"));
            }

            // Crear mensaje
            Message mensaje = new MimeMessage(session);
            mensaje.setFrom(new InternetAddress(USERNAME));
            mensaje.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            mensaje.setSubject("Recuperación de Contraseña - Sistema de Roles");

            // Contenido del mensaje
            String contenido = "<html><body>"
                    + "<h2>Recuperación de Contraseña</h2>"
                    + "<p>Estimado usuario,</p>"
                    + "<p>Hemos recibido una solicitud para recuperar su contraseña. "
                    + "Su nueva contraseña temporal es: <strong>" + nuevaPassword + "</strong></p>"
                    + "<p>Por favor, cambie esta contraseña después de iniciar sesión por motivos de seguridad.</p>"
                    + "<p>Si usted no solicitó este cambio, por favor ignore este mensaje.</p>"
                    + "<p>Saludos,<br>Equipo de Soporte</p>"
                    + "</body></html>";

            mensaje.setContent(contenido, "text/html; charset=utf-8");

            // Enviar mensaje
            Transport.send(mensaje);
            if (DEBUG) {
                System.out.println("Correo de recuperación enviado exitosamente a: " + destinatario);
            }
            return true;
        } catch (MessagingException e) {
            System.out.println("Error al enviar correo de recuperación a " + destinatario + ": " + e.getMessage());
            if (DEBUG) {
                e.printStackTrace();
            }
            return false;
        } catch (Exception e) {
            System.out.println("Error inesperado al enviar correo de recuperación: " + e.getMessage());
            if (DEBUG) {
                e.printStackTrace();
            }
            return false;
        }
    }

    /**
     * Envía un correo electrónico con las credenciales de registro
     * @param destinatario Dirección de correo del destinatario
     * @param username Nombre de usuario generado
     * @param password Contraseña generada
     * @return true si el envío fue exitoso, false en caso contrario
     */
    public static boolean enviarCredencialesRegistro(String destinatario, String username, String password) {
        // Configurar propiedades del servidor SMTP
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        
        // Configuración adicional para evitar errores de conexión
        props.put("mail.smtp.connectiontimeout", "5000");
        props.put("mail.smtp.timeout", "5000");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

        try {
            // Crear sesión con autenticación
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(USERNAME, PASSWORD);
                }
            });
            
            // Activar depuración si está habilitada
            if (DEBUG) {
                session.setDebug(true);
                session.setDebugOut(new PrintStream(System.out));
                System.out.println("Enviando correo de credenciales a: " + destinatario);
                System.out.println("Usando correo remitente: " + USERNAME);
                System.out.println("Usando contraseña de aplicación: " + PASSWORD.replaceAll(".", "*"));
            }
            
            // Crear mensaje
            Message mensaje = new MimeMessage(session);
            mensaje.setFrom(new InternetAddress(USERNAME));
            mensaje.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            mensaje.setSubject("Credenciales de Acceso - Sistema de Roles");
            
            // Contenido del mensaje
            String contenido = "<html><body>"
                    + "<h2>Bienvenido al Sistema de Roles</h2>"
                    + "<p>Estimado usuario,</p>"
                    + "<p>Su cuenta ha sido creada exitosamente. A continuación, encontrará sus credenciales de acceso:</p>"
                    + "<p><strong>Usuario:</strong> " + username + "</p>"
                    + "<p><strong>Contraseña:</strong> " + password + "</p>"
                    + "<p>Por favor, cambie esta contraseña después de iniciar sesión por motivos de seguridad.</p>"
                    + "<p>Saludos,<br>Equipo de Soporte</p>"
                    + "</body></html>";
            
            mensaje.setContent(contenido, "text/html; charset=utf-8");
            
            // Enviar mensaje
            Transport.send(mensaje);
            if (DEBUG) {
                System.out.println("Correo de credenciales enviado exitosamente a: " + destinatario);
            }
            return true;
        } catch (MessagingException e) {
            System.out.println("Error al enviar correo de credenciales a " + destinatario + ": " + e.getMessage());
            if (DEBUG) {
                e.printStackTrace();
            }
            return false;
        } catch (Exception e) {
            System.out.println("Error inesperado al enviar correo de credenciales: " + e.getMessage());
            if (DEBUG) {
                e.printStackTrace();
            }
            return false;
        }
    }
    
    /**
     * Genera una contraseña aleatoria para recuperación
     * @return Contraseña generada
     */
    public static String generarPasswordTemporal() {
        String caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%";
        StringBuilder sb = new StringBuilder(10);
        for (int i = 0; i < 10; i++) {
            int index = (int) (Math.random() * caracteres.length());
            sb.append(caracteres.charAt(index));
        }
        return sb.toString();
    }
    
    /**
     * Método para probar el envío de correo con la configuración actual
     * @param destinatario Dirección de correo para probar
     * @return true si el envío fue exitoso, false en caso contrario
     */
    public static boolean probarConexion(String destinatario) {
        try {
            System.out.println("Probando conexión de correo con: " + HOST + ":" + PORT);
            System.out.println("Cuenta remitente: " + USERNAME);
            
            return enviarCorreoRecuperacion(destinatario, "PRUEBA-CONEXION-" + System.currentTimeMillis());
        } catch (Exception e) {
            System.out.println("Error en prueba de conexión: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
