package sena.adso.roles.modelo;

public class Usuario {
	private int id;
	private String nombre;
	private String email;
	private String password;
	private String rol;  // "Bibliotecario" o "Lector"
	private boolean passwordTemporal;
	// Constructor vacío
	public Usuario() {
	}

	// Constructor
	public Usuario(String nombre, String email, String password, String rol) {
		this.nombre = nombre;
		this.email = email;
		this.password = password;
		this.rol = rol;
	}

	// Constructor con ID
	public Usuario(int id, String nombre, String email, String password, String rol) {
		this(nombre, email, password, rol);
		this.id = id;
	}

	// Getters y Setters
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getRol() {
		return rol;
	}

	public void setRol(String rol) {
		this.rol = rol;
	}

	// Métodos de verificación de rol
	public boolean esBibliotecario() {
		return "Bibliotecario".equals(this.rol);
	}

	public boolean esLector() {
		return "Lector".equals(this.rol);
	}

	public boolean isPasswordTemporal() {
        return passwordTemporal;
    }

    public void setPasswordTemporal(boolean passwordTemporal) {
        this.passwordTemporal = passwordTemporal;
    }
}