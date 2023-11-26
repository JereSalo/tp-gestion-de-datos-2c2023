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