/*
Script Bussiness Inteligence
*/

USE GD2C2023

/* ------- CREACION DE LAS DIMENSIONES ------- */

CREATE TABLE BI_Tiempo (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE BI_Ubicación(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE BI_Sucursal(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE BI_Rango_etario_agentes_inquilinos(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE BI_Tipo_Inmueble(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE BI_Ambientes(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE BI_Rango_m2(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE BI_Tipo_Operación(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE BI_Tipo_Moneda (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);


/* ------- CREACION DE LAS VISTAS DE LAS DIMENSIONES ------- */

CREATE VIEW duracion_promedio_anuncios_publicados (tiempo)							-- PARA TIPO_OPERACION, UBICACION Y AMBIENTES
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION

CREATE VIEW precio_promedio_de_anuncios_de_inmuebles (precio)						-- PARA TIPO_OPERACION, TIPO_INMUEBLE, RANGO_M2, TIPO_MONEDA Y ¿TIEMPO?
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION

CREATE VIEW cinco_barrios_mas_elegidos_para_alquilar (ubicacion)					-- PARA UBICACION, RANGO ETARIO Y TAL VEZ TIPO_OPERACION?
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION

CREATE VIEW porcentaje_incumplimiento_pagos_de_alquileres_en_termino (porcentaje)	-- PARA TIPO_OPERACION? Y TIEMPO
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION

CREATE VIEW porcentaje_promedio_incremento_valor_de_alquileres (porcentaje)			-- PARA TIEMPO Y ????
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION

CREATE VIEW precio_promedio_de_m2_de_la_venta (precio)								-- PARA TIPO_INMUEBLE, UBICACION, TIEMPO, TIPO_OPERACION Y ¿SUCURSAL?
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION

CREATE VIEW valor_promedio_de_la_comision (valor)									-- PARA TIPO_OPERACION, SUCURSAL Y ¿TIEMPO??
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION

CREATE VIEW porcentaje_de_operaciones_concretadas (operaciones)						-- PARA TIPO_OPERACION, SUCURSAL, RANGO ETARIO Y ¿TIEMPO?
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION

CREATE VIEW monto_total_de_cierre_de_contratos_por_tipo_de_operación (total)		-- PARA TIPO_OPERACION, TIEMPO, SUCURSAL Y TIPO_MONEDA
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION


/* ------- CARGA DE LAS VISTAS DE LAS DIMENSIONES ------- */



/* ------- CARGA DE LAS DIMENSIONES ------- */
