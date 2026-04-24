# Configuración de Aiven MySQL

Guía para levantar la base de datos en la nube durante desarrollo.

> **Importante:** Aiven es para **desarrollo**. La entrega final del
> proyecto exige MySQL local (XAMPP o Docker) — ver PDF §4.
> El mismo `schema.sql` funciona en ambos.

## Por qué Aiven

- Plan gratuito sin tarjeta de crédito.
- MySQL 8 nativo.
- Todos los miembros del equipo comparten la misma BD.
- La app móvil funciona desde cualquier red.

**Limitación a tener en cuenta:** los servicios gratuitos se apagan tras
periodos largos sin uso y tardan ~30 segundos en reactivarse.

## Paso 1: Crear cuenta

1. Entra a https://aiven.io y haz clic en **Get started free**.
2. Regístrate con tu correo institucional o con GitHub.
3. Confirma el correo de verificación.

## Paso 2: Crear el servicio MySQL

1. En la consola, clic en **Create service**.
2. Selecciona **Aiven for MySQL**.
3. En *Service tier* elige **Free**.
4. El cloud y la región los asigna Aiven automáticamente en el plan gratuito.
5. En *Service name* escribe: `sacad-db`.
6. Clic en **Create service**.
7. Espera 2-3 minutos hasta que el estado cambie de *Rebuilding* (azul)
   a *Running* (verde).

## Paso 3: Obtener credenciales

Entra al servicio. En la pestaña **Overview** encontrarás:

```
Host:          sacad-db-<tu-usuario>.aivencloud.com
Port:          <número de 5 dígitos>
User:          avnadmin
Password:      AVNS_xxxxxxxxxxxxxxxxx
Database:      defaultdb
SSL Mode:      REQUIRED
```

Guárdalos en un lugar seguro. Los usarás en dos lugares:

- MySQL Workbench (para administrar la BD)
- Archivo `.env` del backend (para que la API se conecte)

## Paso 4: Descargar el certificado SSL

Aiven obliga conexiones cifradas.

1. En **Overview**, busca el botón **Show CA certificate** o **Download**.
2. Guarda el archivo como `ca.pem` en `backend/certs/`.
3. Confirma que `backend/certs/` esté en el `.gitignore`.

## Paso 5: Conectar con MySQL Workbench

1. Descarga Workbench: https://dev.mysql.com/downloads/workbench/
2. Clic en **+** para nueva conexión.
3. Llena los datos:
   - Connection Name: `SACAD Aiven`
   - Hostname: el host de Aiven
   - Port: el puerto de Aiven
   - Username: `avnadmin`
   - Password: clic en *Store in Keychain* y pega
4. Pestaña **SSL**:
   - Use SSL: `Require`
   - SSL CA File: selecciona el `ca.pem` descargado
5. **Test Connection** → debe decir "Successful".

## Paso 6: Importar el schema

1. Abre la conexión en Workbench.
2. Selecciona la base `defaultdb` en el panel izquierdo.
3. **File → Open SQL Script** → abre `database/schema.sql`.
4. Ejecuta con `Ctrl+Shift+Enter`.
5. Refresca el panel de tablas. Deben aparecer:
   - `carrera`
   - `edificio`
   - `examen`
   - `profesor`
   - `salon`
   - `sesion_token`
   - `unidad_aprendizaje`
   - `usuario`

## Paso 7: Generar el hash de admin

Desde la terminal (necesitas PHP instalado):

```bash
php -r "echo password_hash('Admin1234', PASSWORD_BCRYPT);"
```

Copia el resultado. Luego edita `database/seeds.sql` y reemplaza
la línea con `REEMPLAZA_ESTE_HASH` por el hash real.

## Paso 8: Importar los seeds

En Workbench, abre `database/seeds.sql` y ejecútalo.

Verifica con una consulta rápida:

```sql
SELECT id_usuario, nombre_usuario, correo, rol FROM usuario;
SELECT clave, nombre FROM carrera;
SELECT COUNT(*) AS total_examenes FROM examen;
```

## Troubleshooting

**"SSL connection error"**
Revisa que el archivo `ca.pem` esté en la ruta correcta y que en
Workbench hayas configurado *Use SSL: Require*.

**"Access denied for user"**
Copia las credenciales desde Aiven de nuevo — a veces se rotan o
hay caracteres que se pelearon al copiar.

**"Can't connect to MySQL server"**
Verifica que el servicio esté en estado *Running* (verde) en Aiven.
Si estuvo inactivo mucho tiempo, se apaga y tarda un momento en volver.

**"Access denied; you need SUPER privilege"**
Normal en el plan gratis: Aiven no te da privilegios root. Por eso
`schema.sql` no hace `CREATE DATABASE` — usa la `defaultdb` existente.
