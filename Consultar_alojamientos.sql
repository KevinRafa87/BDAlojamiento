-- 1. Insertar un nuevo propietario

INSERT INTO propietarios(nombre, apellido, email, telefono)
VALUES('Kevin','Valenzuela','kevi_valenzuela47@gmail.com', '+503-7123-4567');

-- 2 Insertar un alojamiento vinculado

INSERT INTO alojamientos(id_propietario, nombre, descripcion, tipo, direccion, ciudad, 
                         pais, precio_noche, capacidad_personas, num_habitaciones, num_banos,
						 activo)
VALUES(6, 'Casa en Apaneca', 'Casa urbana en el centro del pueblo', 'casa', 'calle principal frente al parque',

       'Apaneca','El Salvador', 40,4,3,2, true);

-- 3. Insertar huespedes y reservas

INSERT INTO huespedes(nombre, apellido, email, telefono, nacionalidad)
VALUES('Jose', 'Alas', 'jose.alas@gmail.com', '+503-7687-4567', 'El Salvador');

-- Reservas

INSERT INTO reservas(id_alojamiento, id_huesped, fecha_entrada, fecha_salida, 
                     num_personas, precio_total,estado)
VALUES(11,11, '2026-05-31', '2026-06-01',3,40,'confirmado');


-- 4. Insertar pago
SELECT * FROM PAGOS

INSERT INTO pagos(id_reserva, monto, metodo_pago, estado_pago)
VALUES(15, 40, 'tarjeta','completado');

-- 5. seleccionar alojamiento activos
Select nombre, tipo, ciudad, capacidad_personas,  precio_noche
FROM alojamientos
WHERE activo=true;

-- 6 Seleccionar huespedes por pais

SELECT nombre, apellido, email
FROM huespedes
WHERE nacionalidad='El Salvador';

-- 7 Seleccionar  reservas por fechas

SELECT id_reserva, id_huesped, fecha_entrada, 
               fecha_salida,precio_total, estado
FROM reservas
WHERE fecha_entrada  BETWEEN '2026-01-01' and '2026-12-31';

--8 Actualizar precio

UPDATE alojamientos
SET precio_noche=60
WHERE id_alojamiento=11;

-- 9 Actualizar estado de reservas

UPDATE  reservas
SET estado='pendiente'
WHERE id_reserva=15

--10 Eliminar resenas
SELECT *FROM resenas
DELETE FROM resenas
WHERE id_resena=5

--11 Consultar con un inner join reservas + huespedes

SELECT r.id_reserva, 
       h.nombre, h.apellido, 
	   h.nacionalidad,
	   r.fecha_entrada, 
	   r.fecha_salida,
	   r.precio_total,
	   r.estado
FROM reservas r
INNER JOIN huespedes h ON r.id_huesped = h.id_huesped;

--12  JOIN - Alojamiento completo (INNER JOIN múltiple)

SELECT a.nombre AS alojamiento, p.nombre || ' ' || p.apellido AS propietario, 
r.id_reserva, 
r.fecha_entrada,
r.precio_total
FROM alojamientos a
INNER JOIN propietarios p ON a.id_propietario = p.id_propietario
INNER JOIN reservas r ON a.id_alojamiento = r.id_alojamiento;

--13 JOIN pagos y reservas (JOIN COMPLETADO)


SELECT pa.id_pago, h.nombre || ' ' || h.apellido AS huesped,
re.precio_total AS total_reserva, pa.monto AS monto_pagado, 
pa.estado_pago
FROM pagos pa
INNER JOIN reservas re ON pa.id_reserva = re.id_reserva
INNER JOIN huespedes h ON re.id_huesped = h.id_huesped;

--14 LEFT JOIN SIN RESENAS (INNCLUYE NULL)

SELECT a.id_alojamiento, a.nombre AS alojamiento, 
        re.calificacion, re.comentario,
		re.id_resena
FROM alojamientos a
LEFT JOIN resenas re ON a.id_alojamiento = re.id_alojamiento;

-- 15 LEFT JOIN SIN RESERVAS (FILTRAR NULL)
SELECT 
    a.nombre AS alojamiento,
    a.ciudad,
	a.descripcion,
	a.tipo,
	a.pais,
	r.id_reserva,
	a.id_alojamiento
FROM alojamientos a
LEFT JOIN reservas r ON a.id_alojamiento = r.id_alojamiento
WHERE r.id_reserva IS NULL;

--16  AGG  TOTAL INGRESOS SUM
SELECT 
    a.nombre AS alojamiento,
    a.ciudad,
    SUM(p.monto) AS total_ingresos_percibidos
FROM pagos p
INNER JOIN reservas r ON p.id_reserva = r.id_reserva
INNER JOIN alojamientos a ON r.id_alojamiento = a.id_alojamiento
WHERE p.estado_pago = 'completado'
GROUP BY a.id_alojamiento, a.nombre, a.ciudad
ORDER BY total_ingresos_percibidos DESC;

-- 17 AGG PROMEDIO RANTING AVG
SELECT 
    a.nombre AS alojamiento,
    a.ciudad,
    ROUND(AVG(re.calificacion), 2) AS promedio_rating
FROM resenas re
INNER JOIN alojamientos a ON re.id_alojamiento = a.id_alojamiento
GROUP BY a.id_alojamiento, a.nombre, a.ciudad
ORDER BY promedio_rating DESC;

-- 18 AGG TOP ALOJAMIENTO COUNT +LIMIT
SELECT 
    a.nombre AS alojamiento,
    a.tipo,
    COUNT(r.id_reserva) AS cantidad_reservas
FROM reservas r
INNER JOIN alojamientos a ON r.id_alojamiento = a.id_alojamiento
GROUP BY a.id_alojamiento, a.nombre, a.tipo
ORDER BY cantidad_reservas DESC
LIMIT 6;

--19 HAVING MAS DE TRES RESERVACIONES GRUP BY + HAVING
SELECT 
    h.nombre || ' ' || h.apellido AS huesped,
    h.email,
    COUNT(r.id_reserva) AS total_reservas
FROM reservas r
INNER JOIN huespedes h ON r.id_huesped = h.id_huesped
GROUP BY h.id_huesped, h.nombre, h.apellido, h.email
HAVING COUNT(r.id_reserva) > 3
ORDER BY total_reservas DESC;

-- 20 SUBCONSULTA ALOJAMIENTO MAS CARO SUBQUERY

SELECT id_alojamiento, nombre, precio_noche, ciudad
FROM alojamientos
WHERE precio_noche = (SELECT MAX(precio_noche) FROM alojamientos);