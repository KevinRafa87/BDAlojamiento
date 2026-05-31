# Sistema de Gestión de Alojamientos

Este repositorio contiene el script de consultas de una base de datos para un sistema de gestión de alojamientos de alquiler vacacional

## Motor de Base de Datos Utilizado
* **PostgreSQL** 

##  Esquema de la Base de Datos
El sistema está compuesto por 6 tablas principales interconectadas:

1. **propietarios**: Almacena los datos de los dueños de los inmuebles.
2. **alojamientos**: Casas, apartamentos o habitaciones disponibles (conectado a *propietarios*).
3. **huespedes**: Información de los clientes que realizan reservas.
4. **reservas**: El puente que conecta a un *huésped* con un *alojamiento* en fechas específicas.
5. **pagos**: Registro del dinero recibido por cada *reserva*.
6. **resenas**: Calificaciones y comentarios de los *huéspedes* sobre los *alojamientos*.

### Relaciones clave:
* Un propietario puede tener muchos alojamientos (`1 a N`).
* Un alojamiento puede tener muchas reservas (`1 a N`).
* Un huésped puede hacer muchas reservas (`1 a N`).
* Cada reserva genera un pago y puede recibir una reseña (`1 a 1`).

## Cómo ejecutar el script
1. Ejecuta el archivo `Consultar_alojamientos.sql` en tu cliente SQL favorito (pgAdmin, DBeaver, etc.).
