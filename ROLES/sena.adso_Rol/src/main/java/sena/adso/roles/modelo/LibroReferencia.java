package sena.adso.roles.modelo;

public class LibroReferencia extends Libro {
    private String campoAcademico;
    private boolean consultaInterna;
    
    public LibroReferencia(String titulo, String isbn, String autor, 
                          int ejemplaresDisponibles, String campoAcademico, 
                          boolean consultaInterna) {
        super(titulo, isbn, autor, ejemplaresDisponibles);
        this.campoAcademico = campoAcademico;
        this.consultaInterna = consultaInterna;
    }
    
    // Getters y Setters específicos
    public String getCampoAcademico() { return campoAcademico; }
    public void setCampoAcademico(String campoAcademico) { 
        this.campoAcademico = campoAcademico; 
    }
    
    public boolean isConsultaInterna() { return consultaInterna; }
    public void setConsultaInterna(boolean consultaInterna) { 
        this.consultaInterna = consultaInterna; 
    }
    
    @Override
    public String getTipoLibro() {
        return "Referencia";
    }
}