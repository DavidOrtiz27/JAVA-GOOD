CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    email VARCHAR(100),
    password VARCHAR(255),
    rol VARCHAR(20)
);

CREATE TABLE libros (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(20),
    titulo VARCHAR(200),
    isbn VARCHAR(13),
    autor VARCHAR(100),
    ejemplares_disponibles INT,
    ejemplares_totales INT,
    prestado BOOLEAN,
    -- Campos específicos según el tipo
    genero VARCHAR(50),
    premios_literarios TEXT,
    area_tematica VARCHAR(100),
    publico_objetivo VARCHAR(100),
    campo_academico VARCHAR(100),
    consulta_interna BOOLEAN
);

CREATE TABLE prestamos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    libro_id INT,
    usuario_id INT,
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    estado VARCHAR(20),
    FOREIGN KEY (libro_id) REFERENCES libros(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);