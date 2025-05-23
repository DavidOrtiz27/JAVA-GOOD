package sena.adso.roles.modelo;

public class LibroFiccion extends Libro {
    private String genero;
    private String premiosLiterarios;

    public LibroFiccion(String titulo, String isbn, String autor,
                       int ejemplaresDisponibles, String genero,
                       String premiosLiterarios) {
        super(titulo, isbn, autor, ejemplaresDisponibles);
        this.genero = genero;
        this.premiosLiterarios = premiosLiterarios;
    }

    // Getters y Setters específicos
    public String getGenero() { return genero; }
    public void setGenero(String genero) { this.genero = genero; }

    public String getPremiosLiterarios() { return premiosLiterarios; }
    public void setPremiosLiterarios(String premiosLiterarios) {
        this.premiosLiterarios = premiosLiterarios;
    }

    @Override
    public String getTipoLibro() {
        return "Ficcion";
    }
}