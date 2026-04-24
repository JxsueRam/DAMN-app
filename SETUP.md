# Guía de inicio para el equipo

Este documento explica cómo configurar el proyecto SACAD en tu computadora
y cómo trabajar con el equipo sin pisar cambios de nadie.

## 1. Requisitos previos

Instala según lo que te toque desarrollar:

### Para TODOS
- **Git**: https://git-scm.com/download/win
- **VS Code**: https://code.visualstudio.com/

### Si trabajas en el backend PHP
- **XAMPP** (incluye PHP 8 y Apache): https://www.apachefriends.org/
- **MySQL Workbench**: https://dev.mysql.com/downloads/workbench/
- **Postman** (para probar la API): https://www.postman.com/downloads/

### Si trabajas en la app Flutter
- **Flutter SDK**: https://docs.flutter.dev/get-started/install/windows
- **Android Studio** (para el emulador): https://developer.android.com/studio
- Ejecuta `flutter doctor` en PowerShell para verificar la instalación

### Si trabajas en el frontend web
- Ya con VS Code es suficiente. Recomendado: extensión **Live Server**.

## 2. Clonar el repositorio

Abre PowerShell en la carpeta donde guardes tus proyectos y ejecuta:

```powershell
git clone https://github.com/JxsueRam/DAMN-app.git
cd DAMN-app
```

## 3. Configurar tu identidad en Git (una sola vez)

```powershell
git config --global user.name "Tu Nombre"
git config --global user.email "tu-correo@ipn.mx"
```

## 4. Pedirle al Tech Lead las credenciales de Aiven

El archivo `.env` con las credenciales de la base de datos **NO está en el repo**
(por seguridad). Pídeselas por privado al líder técnico y créate tu propio
archivo `.env` en la carpeta `backend/` con este contenido:

```env
DB_HOST=sacad-db-xxxxx.aivencloud.com
DB_PORT=12345
DB_NAME=defaultdb
DB_USER=avnadmin
DB_PASSWORD=LaClaveRealDeAiven
```

Además, pide el certificado SSL (`ca.pem`) y colócalo en `backend/certs/`.

## 5. Flujo de trabajo con ramas

### Regla de oro
**NUNCA trabajes directamente en `main`.** `main` es la rama estable que
siempre debe funcionar. Todo cambio se hace en una rama nueva.

### Convención de nombres de ramas

| Prefijo    | Cuándo usarlo               | Ejemplo                    |
|------------|-----------------------------|----------------------------|
| `feature/` | Funcionalidad nueva         | `feature/login-flutter`    |
| `fix/`     | Corregir un bug             | `fix/validacion-correo`    |
| `docs/`    | Solo documentación          | `docs/manual-usuario`      |
| `chore/`   | Tareas técnicas, limpieza   | `chore/actualizar-deps`    |

### Flujo típico para cada tarea

```powershell
# 1. Actualiza main antes de empezar
git checkout main
git pull origin main

# 2. Crea tu rama para la nueva tarea
git checkout -b feature/nombre-de-tu-tarea

# 3. Trabaja y haz commits pequeños y descriptivos
git add archivos/que/modificaste
git commit -m "feat(auth): agrega validacion del formulario"

# 4. Sube tu rama a GitHub
git push -u origin feature/nombre-de-tu-tarea

# 5. Abre un Pull Request desde github.com
#    - base: main
#    - compare: feature/nombre-de-tu-tarea
#    - Pide a un compañero que lo revise

# 6. Cuando el PR sea aprobado y mergeado, actualiza tu main
git checkout main
git pull origin main
```

## 6. Convenciones de commits

Usa el formato **Conventional Commits**:

```
<tipo>(<area>): <descripción breve en presente>
```

Ejemplos buenos:
- `feat(auth): agrega endpoint de login con JWT`
- `fix(db): corrige error en foreign key de examen`
- `docs(api): documenta el endpoint de carreras`
- `chore(deps): actualiza http a 1.2.2`

Ejemplos malos (no hagan esto):
- `cambios` — ¿qué cambios?
- `arreglé algo` — ¿qué arreglaste?
- `commit final final ahora sí` — el PDF §5.3 explícitamente prohíbe esto

## 7. Antes de pedir ayuda

Si algo no funciona, corre esto primero y pégalo en el chat del equipo:

```powershell
git status
git log --oneline -5
git branch
```

Con esa información es mucho más fácil ayudarte.

## 8. Estructura del proyecto

```
DAMN-app/
├── lib/                  ← App Flutter (código Dart)
├── android/ ios/ web/    ← Configuración por plataforma de Flutter
├── backend/              ← API REST en PHP
│   ├── api/              ← Endpoints (auth, examenes, etc.)
│   ├── config/           ← Conexión a BD
│   ├── utils/            ← Funciones auxiliares
│   └── certs/            ← Certificados SSL (NO subir a Git)
├── database/             ← Scripts SQL
│   ├── schema.sql        ← Estructura de tablas
│   └── seeds.sql         ← Datos de prueba
├── docs/                 ← Documentación técnica
└── pubspec.yaml          ← Dependencias de Flutter
```

## 9. ¿Dudas?

Avísale al Tech Lead (Josué) por el grupo de WhatsApp del equipo.
