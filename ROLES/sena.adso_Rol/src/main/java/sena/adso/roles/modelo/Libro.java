package sena.adso.roles.modelo;

public abstract class Libro {
    private int id;
    private String titulo;
    private String isbn;
    private String autor;
    private int ejemplaresDisponibles;
    private int ejemplaresTotales;
    private boolean prestado;
    private String tipo;

    // Constructor por defecto
    public Libro() {
        this.prestado = false;
    }

    // Constructor con parámetros
    public Libro(String titulo, String isbn, String autor, int ejemplaresDisponibles) {
        this();
        this.titulo = titulo;
        this.isbn = isbn;
        this.autor = autor;
        this.ejemplaresDisponibles = ejemplaresDisponibles;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getAutor() {
        return autor;
    }

    public void setAutor(String autor) {
        this.autor = autor;
    }

    public int getEjemplaresDisponibles() {
        return ejemplaresDisponibles;
    }

    public void setEjemplaresDisponibles(int ejemplaresDisponibles) {
        this.ejemplaresDisponibles = ejemplaresDisponibles;
    }

    public int getEjemplaresTotales() {
        return ejemplaresTotales;
    }

    public void setEjemplaresTotales(int ejemplaresTotales) {
        this.ejemplaresTotales = ejemplaresTotales;
    }

    public boolean isPrestado() {
        return prestado;
    }

    public void setPrestado(boolean prestado) {
        this.prestado = prestado;
    }

    // Método abstracto que debe ser implementado por las clases hijas
    public abstract String getTipoLibro();

    // Método para obtener el estado como texto (para usar en JSP)
    public String getEstado() {
        if (estaDisponible()) {
            return "Disponible";
        } else {
            return "No disponible";
        }
    }

    // Métodos de utilidad
    public boolean estaDisponible() {
        return ejemplaresDisponibles > 0;
    }

    public void prestar() {
        if (estaDisponible()) {
            ejemplaresDisponibles--;
        }
    }

    public void devolver() {
        ejemplaresDisponibles++;
    }

    @Override
    public String toString() {
        return "Libro{" +
                "id=" + id +
                ", titulo='" + titulo + '\'' +
                ", isbn='" + isbn + '\'' +
                ", autor='" + autor + '\'' +
                ", ejemplaresDisponibles=" + ejemplaresDisponibles +
                ", ejemplaresTotales=" + ejemplaresTotales +
                ", prestado=" + prestado +
                '}';
    }
}
