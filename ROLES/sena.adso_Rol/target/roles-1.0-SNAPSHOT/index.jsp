<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Biblioteca Duitama - Inicio</title>

    <!-- Estilos Bootstrap e íconos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    
    <style>
        body {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .hero-section {
            background: url('https://images.unsplash.com/photo-1507842217343-583bb7270b66?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80') center/cover;
            height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
        }

        .hero-content {
            position: relative;
            z-index: 1;
            color: white;
            text-align: center;
            padding: 2rem;
        }

        .hero-content h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }

        .hero-content p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
        }

        .btn-hero {
            background: #3498db;
            border: none;
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 500;
            transition: all 0.3s ease;
            margin: 0.5rem;
        }

        .btn-hero:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }

        .features-section {
            background: white;
            padding: 5rem 0;
        }

        .feature-card {
            text-align: center;
            padding: 2rem;
            border-radius: 15px;
            background: white;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            height: 100%;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .feature-icon {
            font-size: 3rem;
            color: #3498db;
            margin-bottom: 1.5rem;
        }

        .feature-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: #2c3e50;
        }

        .feature-text {
            color: #7f8c8d;
            font-size: 1.1rem;
        }

        .footer {
            background: #2c3e50;
            color: white;
            padding: 3rem 0;
            margin-top: auto;
        }

        .footer-content {
            text-align: center;
        }

        .footer-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .footer-text {
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 2rem;
        }

        .social-links {
            margin-bottom: 2rem;
        }

        .social-links a {
            color: white;
            font-size: 1.5rem;
            margin: 0 1rem;
            transition: color 0.3s ease;
        }

        .social-links a:hover {
            color: #3498db;
        }

        .copyright {
            color: rgba(255, 255, 255, 0.6);
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .hero-content h1 {
                font-size: 2.5rem;
            }
            
            .hero-content p {
                font-size: 1rem;
            }
        }
    </style>
</head>

<body>
    <!-- Sección Hero -->
    <section class="hero-section">
        <div class="container">
            <div class="hero-content">
                <h1>Bienvenido a la Biblioteca Duitama</h1>
                <p>Tu puerta de entrada al conocimiento y la cultura</p>
                <div>
                    <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary btn-hero">
                        <i class="bi bi-box-arrow-in-right me-2"></i>Iniciar Sesión
                    </a>
                    <a href="${pageContext.request.contextPath}/auth/registro" class="btn btn-outline-light btn-hero">
                        <i class="bi bi-person-plus me-2"></i>Registrarse
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Sección de Características -->
    <section class="features-section">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="feature-card">
                        <i class="bi bi-book feature-icon"></i>
                        <h3 class="feature-title">Amplio Catálogo</h3>
                        <p class="feature-text">Accede a miles de libros y recursos digitales de diferentes géneros y temas.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <i class="bi bi-clock feature-icon"></i>
                        <h3 class="feature-title">Préstamos Flexibles</h3>
                        <p class="feature-text">Sistema de préstamos con plazos adaptables y renovaciones fáciles.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <i class="bi bi-people feature-icon"></i>
                        <h3 class="feature-title">Comunidad Activa</h3>
                        <p class="feature-text">Únete a una comunidad de lectores y comparte tu pasión por la lectura.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <h2 class="footer-title">Biblioteca Duitama</h2>
                <p class="footer-text">Tu espacio para el conocimiento y la cultura</p>
                <div class="social-links">
                    <a href="#"><i class="bi bi-facebook"></i></a>
                    <a href="#"><i class="bi bi-twitter"></i></a>
                    <a href="#"><i class="bi bi-instagram"></i></a>
                    <a href="#"><i class="bi bi-envelope"></i></a>
                </div>
                <p class="copyright">© 2024 Biblioteca Duitama. Todos los derechos reservados.</p>
            </div>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>