##  Resumen
Setup inicial del proyecto SACAD. Se agrega la estructura base para el backend 
y la base de datos, sin tocar el proyecto Flutter existente.

##  Cambios incluidos
- **Estructura de carpetas**: `database/`, `backend/`, `docs/`
- **Base de datos**: `schema.sql` con 8 tablas (usuario, carrera, examen, etc.)
- **Seeds**: datos de prueba con carreras de ESCOM y exámenes de ejemplo
- **Documentación**: guía de configuración de Aiven MySQL
- **.gitignore**: reglas para proteger credenciales y certificados

##  Requerimientos  cubiertos
- §5.4 Estandarización de nombres (minúsculas y singular) ✅
- §5.3 Commits atómicos y descriptivos ✅
- §2 Diseño preparado para sentencias preparadas (PDO) ✅

##  Siguiente paso
Implementar el backend PHP que consuma esta base de datos.
