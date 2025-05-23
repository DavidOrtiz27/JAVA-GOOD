package sena.adso.roles.modelo;

public class LibroNoFiccion extends Libro {
    private String areaTematica;
    private String publicoObjetivo;
    
    // Constructor predeterminado necesario para JPA/Hibernate
    public LibroNoFiccion() {
        super();
        setTipo("NoFiccion");
    }
    
    // Constructor principal
    public LibroNoFiccion(String titulo, String isbn, String autor, 
                         int ejemplaresDisponibles, String areaTematica, 
                         String publicoObjetivo) {
        super();
        setTitulo(titulo);
        setIsbn(isbn);
        setAutor(autor);
        setEjemplaresDisponibles(ejemplaresDisponibles);
        setTipo("NoFiccion");
        this.areaTematica = areaTematica;
        this.publicoObjetivo = publicoObjetivo;
    }
    
    // Getters y Setters específicos
    public String getAreaTematica() { 
        return areaTematica; 
    }
    
    public void setAreaTematica(String areaTematica) { 
        this.areaTematica = areaTematica; 
    }
    
    public String getPublicoObjetivo() { 
        return publicoObjetivo; 
    }
    
    public void setPublicoObjetivo(String publicoObjetivo) { 
        this.publicoObjetivo = publicoObjetivo; 
    }
    
    @Override
    public String getTipoLibro() {
        return "NoFiccion";
    }
    
    // Método para validar los campos específicos
    public boolean validarCamposEspecificos() {
        return areaTematica != null && !areaTematica.trim().isEmpty() &&
               publicoObjetivo != null && !publicoObjetivo.trim().isEmpty();
    }
    
    // Método para crear una descripción detallada
    @Override
    public String toString() {
        return String.format("Libro No Ficción: %s (ISBN: %s) - Área: %s, Público: %s",
                           getTitulo(), getIsbn(), areaTematica, publicoObjetivo);
    }
}