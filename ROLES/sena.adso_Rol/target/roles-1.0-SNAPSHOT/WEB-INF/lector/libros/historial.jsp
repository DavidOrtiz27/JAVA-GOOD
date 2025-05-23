<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="sena.adso.roles.modelo.Libro" %>

<%
    // Supongamos que el atributo "historialLibros" es un List<Libro> pasado desde el Servlet
    List<Libro> libros = (List<Libro>) request.getAttribute("historialLibros");
    if (libros == null) {
        libros = new java.util.ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Historial de Libros</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background: #f8f9fa;
            padding: 2rem;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .table-wrapper {
            background: #ffffff;
            padding: 2rem;
            border-radius: 0.5rem;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        h1 {
            color: #343a40;
            margin-bottom: 1.5rem;
        }
        #searchInput {
            max-width: 400px;
            margin-bottom: 1rem;
        }
        .no-results {
            text-align: center;
            padding: 1rem;
            color: #6c757d;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container table-wrapper">
        <h1>Historial de Libros</h1>

        <input type="text" id="searchInput" class="form-control" placeholder="Buscar por título o autor..." />

        <table class="table table-hover table-bordered align-middle">
            <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Título</th>
                    <th>Autor</th>
                    <th>Fecha de Préstamo</th>
                    <th>Fecha de Devolución</th>
                    <th>Estado</th>
                </tr>
            </thead>
            <tbody id="librosTableBody">
                <%
                    int index = 1;
                    for (Libro libro : libros) {
                %>
                <tr>
                    <td><%= index++ %></td>
                    <td><%= libro.getTitulo() %></td>
                    <td><%= libro.getAutor() %></td>
                    <td><%= libro.getFechaPrestamo() != null ? libro.getFechaPrestamo() : "N/A" %></td>
                    <td><%= libro.getFechaDevolucion() != null ? libro.getFechaDevolucion() : "N/A" %></td>
                    <td>
                        <span class="badge <%= libro.isDevuelto() ? "bg-success" : "bg-warning text-dark" %>">
                            <%= libro.isDevuelto() ? "Devuelto" : "Pendiente" %>
                        </span>
                    </td>
                </tr>
                <%
                    }
                    if (libros.isEmpty()) {
                %>
                <tr><td colspan="6" class="no-results">No hay registros en el historial.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Bootstrap JS Bundle CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Script para filtro sencillo -->
    <script>
        const searchInput = document.getElementById('searchInput');
        const tableBody = document.getElementById('librosTableBody');

        searchInput.addEventListener('keyup', function() {
            const filter = this.value.toLowerCase();
            const rows = tableBody.getElementsByTagName('tr');
            let visibleCount = 0;

            Array.from(rows).forEach(row => {
                const title = row.cells[1].textContent.toLowerCase();
                const author = row.cells[2].textContent.toLowerCase();
                if (title.includes(filter) || author.includes(filter)) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });

            // Mostrar mensaje si no hay resultados
            if (visibleCount === 0) {
                if (!document.querySelector('.no-results')) {
                    const tr = document.createElement('tr');
                    tr.classList.add('no-results');
                    tr.innerHTML = '<td colspan="6">No se encontraron libros que coincidan con la búsqueda.</td>';
                    tableBody.appendChild(tr);
                }
            } else {
                const noResultsRow = document.querySelector('.no-results');
                if (noResultsRow) {
                    noResultsRow.remove();
                }
            }
        });
    </script>
</body>
</html>
