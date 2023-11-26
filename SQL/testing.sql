USE GD2C2023

-- Selects para ver uno por uno que onda :)
SELECT * FROM MANGO_DB.agente
SELECT * FROM MANGO_DB.alquiler
SELECT * FROM MANGO_DB.ambientes
SELECT * FROM MANGO_DB.anuncio
SELECT * FROM MANGO_DB.barrio
SELECT * FROM MANGO_DB.caracteristicas_x_inmueble
SELECT * FROM MANGO_DB.caracteristica
SELECT * FROM MANGO_DB.comprador
SELECT * FROM MANGO_DB.detalle_alq
SELECT * FROM MANGO_DB.disposicion
SELECT * FROM MANGO_DB.estado
SELECT * FROM MANGO_DB.estado_anuncio
SELECT * FROM MANGO_DB.inmueble
SELECT * FROM MANGO_DB.inquilino
SELECT * FROM MANGO_DB.localidad
SELECT * FROM MANGO_DB.medio_pago
SELECT * FROM MANGO_DB.moneda
SELECT * FROM MANGO_DB.orientacion
SELECT * FROM MANGO_DB.pago_alquiler
SELECT * FROM MANGO_DB.pago_venta
SELECT * FROM MANGO_DB.propietario
SELECT * FROM MANGO_DB.provincia
SELECT * FROM MANGO_DB.sucursal
SELECT * FROM MANGO_DB.tipo_inmueble
SELECT * FROM MANGO_DB.tipo_operacion
SELECT * FROM MANGO_DB.venta


SELECT DISTINCT PROPIETARIO_DNI, PROPIETARIO_NOMBRE FROM gd_esquema.Maestra WHERE PROPIETARIO_DNI is not null


SELECT DISTINCT PROPIETARIO_DNI, PROPIETARIO_NOMBRE, COUNT(*) cantidad
FROM gd_esquema.Maestra
WHERE PROPIETARIO_DNI IS NOT NULL
GROUP BY PROPIETARIO_DNI, PROPIETARIO_NOMBRE
HAVING COUNT(*) > 1



-- BI TESTING

-- Caso de prueba para fecha de pago posterior a fecha de vencimiento. CLIENTE IRRESPONSABLE!
BEGIN TRANSACTION

UPDATE MANGO_DB.pago_alquiler
SET fecha_vencimiento = getdate() WHERE codigo = 178

SELECT * FROM MANGO_DB.pago_alquiler WHERE fecha_pago > fecha_vencimiento
ROLLBACK TRANSACTION




SELECT COUNT(*) FROM MANGO_DB.anuncio a JOIN MANGO_DB.inmueble i ON i.codigo = a.id_inmueble
GROUP BY a.id_tipo_operacion, i.id_barrio, i.id_cantidad_ambientes, YEAR(a.fecha_publicacion)

SELECT TOP 5 id_barrio
FROM MANGO_DB.alquiler a JOIN MANGO_DB.anuncio an ON an.codigo = a.id_anuncio
JOIN MANGO_DB.inmueble i ON i.codigo = an.id_inmueble


-- Voy a probar hacer la carga del hecho de anuncio

/*

CREATE TABLE MANGO_DB.BI_Hecho_anuncio (
	id_ubicacion NUMERIC(18,0), 	-- Barrio necesario
	id_tiempo NUMERIC(18,0), 		-- Cuatri y año
	id_sucursal NUMERIC(18,0),
	id_rango_etario_agente NUMERIC(18,0),
	id_tipo_inmueble NUMERIC(18,0),
	id_ambientes NUMERIC(18,0),
	id_rango_m2 NUMERIC(18,0),
	id_tipo_operacion NUMERIC(18,0),
	id_tipo_moneda NUMERIC(18,0),
	
	sumatoria_precio NUMERIC(18,2),
	sumatoria_duracion NUMERIC(18,0),
	cantidad_anuncios NUMERIC(18,0),

*/


-- Pero primero en realidad tengo que cargar ubicacion...


