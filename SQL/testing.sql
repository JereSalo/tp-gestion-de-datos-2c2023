USE GD2C2023

-- Selects para ver uno por uno que onda :)
SELECT * FROM MANGO_DB.agente
SELECT * FROM MANGO_DB.alquiler
SELECT * FROM MANGO_DB.ambientes
SELECT * FROM MANGO_DB.anuncio
SELECT * FROM MANGO_DB.barrio
SELECT * FROM MANGO_DB.caracteristicas_inmueble
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
-- Hasta aca
SELECT * FROM MANGO_DB.pago_alquiler
SELECT * FROM MANGO_DB.pago_venta
SELECT * FROM MANGO_DB.propietario
SELECT * FROM MANGO_DB.provincia -- No
SELECT * FROM MANGO_DB.sucursal -- No
SELECT * FROM MANGO_DB.tipo_inmueble -- No
SELECT * FROM MANGO_DB.tipo_operacion -- No
SELECT * FROM MANGO_DB.venta


SELECT DISTINCT PROPIETARIO_DNI, PROPIETARIO_NOMBRE FROM gd_esquema.Maestra WHERE PROPIETARIO_DNI is not null


SELECT DISTINCT PROPIETARIO_DNI, PROPIETARIO_NOMBRE, COUNT(*) cantidad
FROM gd_esquema.Maestra
WHERE PROPIETARIO_DNI IS NOT NULL
GROUP BY PROPIETARIO_DNI, PROPIETARIO_NOMBRE
HAVING COUNT(*) > 1



-- SELECT * de las tablas BI_Hecho_Anuncio, BI_Hecho_Venta, BI_Hecho_Alquiler, BI_Hecho_Pago_Alquiler
SELECT * FROM MANGO_DB.BI_Hecho_Anuncio;
SELECT * FROM MANGO_DB.BI_Hecho_Venta;
SELECT * FROM MANGO_DB.BI_Hecho_Alquiler;
SELECT * FROM MANGO_DB.BI_Hecho_Pago_Alquiler;

-- SELECT * de las tablas BI_Tiempo, BI_Ubicacion, BI_Sucursal, BI_Rango_etario
SELECT * FROM MANGO_DB.BI_Tiempo;
SELECT * FROM MANGO_DB.BI_Ubicacion;
SELECT * FROM MANGO_DB.BI_Sucursal;
SELECT * FROM MANGO_DB.BI_Rango_etario;

-- SELECT * de las tablas BI_Tipo_Inmueble, BI_Ambientes, BI_Rango_m2, BI_Tipo_Operacion
SELECT * FROM MANGO_DB.BI_Tipo_Inmueble;
SELECT * FROM MANGO_DB.BI_Ambientes;
SELECT * FROM MANGO_DB.BI_Rango_m2;
SELECT * FROM MANGO_DB.BI_Tipo_Operacion;

-- SELECT * de las tablas BI_Tipo_Moneda, BI_Alquiler
SELECT * FROM MANGO_DB.BI_Tipo_Moneda;
SELECT * FROM MANGO_DB.BI_Alquiler;
