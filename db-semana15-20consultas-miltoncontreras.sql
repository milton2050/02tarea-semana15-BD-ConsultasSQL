-- ==================================================
-- 20 CONSULTAS SQL - MIILTON CONTRERAS
-- ==================================================

-- 01. INSERT - Insertar propietario
INSERT INTO propietarios (nombre, apellido, email, telefono)
VALUES ('Roberto', 'Hernández', 'roberto.h@email.com', '+503-7890-1234');

select * from propietarios where nombre='Roberto';


-- 02. INSERT - Insertar alojamiento vinculado
INSERT INTO alojamientos (id_propietario, nombre, tipo, direccion, ciudad, pais, precio_noche, capacidad_personas, num_habitaciones, num_banos)
VALUES (6, 'Apartamento Vista Hermosa', 'apartamento', 'Av. Magnolias #456', 'San Salvador', 'El Salvador', 85.00, 4, 2, 2);

select * from alojamientos where id_propietario=6;

-- 03. INSERT - Huésped y reserva
INSERT INTO huespedes (nombre, apellido, email, nacionalidad)
VALUES ('Carlos', 'Gutiérrez', 'carlos.g@email.com', 'Costa Rica');

select * from huespedes where nombre='Carlos';

INSERT INTO reservas (id_alojamiento, id_huesped, fecha_entrada, fecha_salida, num_personas, precio_total)
VALUES (11, 11, '2026-06-10', '2026-06-15', 3, 425.00);

select * from reservas where id_alojamiento=11;

-- 04. INSERT - Insertar pago
INSERT INTO pagos (id_reserva, monto, metodo_pago)
VALUES (15, 425.00, 'tarjeta');

select * from pagos where id_reserva=15;


-- 05. SELECT - Alojamientos activos
SELECT nombre, tipo, ciudad, precio_noche
FROM alojamientos
WHERE activo = true;

-- 06. SELECT - Huéspedes por país
SELECT nombre, apellido, email, nacionalidad
FROM huespedes
WHERE nacionalidad = 'Estados Unidos';


-- 07. SELECT - Reservas por fechas (BETWEEN)
SELECT id_reserva, fecha_entrada, fecha_salida, precio_total
FROM reservas
WHERE fecha_entrada BETWEEN '2025-07-01' AND '2025-08-31';


-- 08. UPDATE - Actualizar precio
UPDATE alojamientos
SET precio_noche = 50.00
WHERE id_alojamiento = 1;

select * from alojamientos where id_alojamiento=1;

-- 09. UPDATE - Estado reserva
UPDATE reservas
SET estado = 'completada'
WHERE id_reserva = 5;

select * from reservas where id_reserva=5;

-- 10. DELETE - Eliminar reseña
DELETE FROM resenas
WHERE id_resena = 3;

select * from resenas where id_resena=3;

-- 11. JOIN - Reservas + huésped (INNER JOIN)
SELECT 
    r.id_reserva,
    r.fecha_entrada,
    r.precio_total,
    h.nombre,
    h.apellido,
    h.nacionalidad
FROM reservas r
INNER JOIN huespedes h ON r.id_huesped = h.id_huesped;


-- 12. JOIN - Alojamiento completo (INNER JOIN múltiple)
SELECT 
    a.nombre AS alojamiento,
    a.ciudad,
    p.nombre AS propietario,
    r.fecha_entrada
FROM alojamientos a
INNER JOIN propietarios p ON a.id_propietario = p.id_propietario
INNER JOIN reservas r ON a.id_alojamiento = r.id_alojamiento;


-- 13. JOIN - Pagos + reservas (JOIN combinado)
SELECT 
    pag.monto,
    pag.metodo_pago,
    r.fecha_entrada,
    h.nombre AS huesped
FROM pagos pag
INNER JOIN reservas r ON pag.id_reserva = r.id_reserva
INNER JOIN huespedes h ON r.id_huesped = h.id_huesped;


-- 14. LEFT JOIN - Sin reseñas (incluye nulls)
SELECT 
    a.nombre AS alojamiento,
    COUNT(res.id_resena) AS total_resenas
FROM alojamientos a
LEFT JOIN resenas res ON a.id_alojamiento = res.id_alojamiento
GROUP BY a.nombre
HAVING COUNT(res.id_resena) = 0;


-- 15. LEFT JOIN - Sin reservas (filtrar null)
SELECT 
    a.nombre AS alojamiento,
    a.ciudad
FROM alojamientos a
LEFT JOIN reservas r ON a.id_alojamiento = r.id_alojamiento
WHERE r.id_reserva IS NULL;


-- 16. AGG - Total ingresos (SUM)
SELECT 
    a.nombre AS alojamiento,
    SUM(r.precio_total) AS ingresos_totales
FROM alojamientos a
INNER JOIN reservas r ON a.id_alojamiento = r.id_alojamiento
GROUP BY a.nombre;


-- 17. AGG - Promedio rating (AVG)
SELECT 
    a.nombre AS alojamiento,
    AVG(res.calificacion) AS promedio_calificacion
FROM alojamientos a
INNER JOIN resenas res ON a.id_alojamiento = res.id_alojamiento
GROUP BY a.nombre;


-- 18. AGG - Top alojamientos (COUNT + LIMIT)
SELECT 
    a.nombre AS alojamiento,
    COUNT(r.id_reserva) AS total_reservas
FROM alojamientos a
INNER JOIN reservas r ON a.id_alojamiento = r.id_alojamiento
GROUP BY a.nombre
ORDER BY total_reservas DESC
LIMIT 5;


-- 19. HAVING - Más de 3 reservas (GROUP BY + HAVING)
SELECT 
    a.nombre AS alojamiento,
    COUNT(r.id_reserva) AS total_reservas
FROM alojamientos a
INNER JOIN reservas r ON a.id_alojamiento = r.id_alojamiento
GROUP BY a.nombre
HAVING COUNT(r.id_reserva) > 1;


-- 20. Subconsulta - Alojamiento más caro (Subquery)
SELECT nombre, precio_noche
FROM alojamientos
WHERE precio_noche = (SELECT MAX(precio_noche) FROM alojamientos);