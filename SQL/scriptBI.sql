/*
Script Bussiness Inteligence
*/

USE GD2C2023

/* ------- CREACION DE LAS FUNCIONES ------- */
CREATE FUNCTION MANGO_DB.getCuatrimestre (@fecha DATE)
RETURNS SMALLINT
AS
BEGIN
	DECLARE @cuatrimestre SMALLINT

	SET @cuatrimestre =
		CASE 
			WHEN MONTH(@fecha) BETWEEN 1 AND 4 THEN 1
			WHEN MONTH(@fecha) BETWEEN 5 AND 9 THEN 2
			WHEN MONTH(@fecha) BETWEEN 10 AND 12 THEN 3
		END

	RETURN @cuatrimestre
END
GO

/* ------- CREACION DE LAS DIMENSIONES ------- */
CREATE TABLE MANGO_DB.BI_Tiempo (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	anio NUMERIC(18,0),
	cuatrimestre SMALLINT CHECK (cuatrimestre BETWEEN 1 AND 3),
	mes NUMERIC(18,0) CHECK (mes BETWEEN 1 AND 12)
);

CREATE TABLE MANGO_DB.BI_Ubicacion(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	provincia NVARCHAR(100),
	localidad NVARCHAR(100),
	barrio NVARCHAR(100)
);

CREATE TABLE MANGO_DB.BI_Sucursal(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	codigo NUMERIC(18,0),
    nombre NVARCHAR(100)
    -- direccion NVARCHAR(100), -- Probablemente innecesario, no veo que lo pidan.
);

CREATE TABLE MANGO_DB.BI_Rango_etario(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	rango NVARCHAR(100)
);

CREATE TABLE MANGO_DB.BI_Tipo_Inmueble(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE MANGO_DB.BI_Ambientes(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	detalle NVARCHAR(100)
);

CREATE TABLE MANGO_DB.BI_Rango_m2(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	rango NVARCHAR(100)
);

CREATE TABLE MANGO_DB.BI_Tipo_Operacion(
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE MANGO_DB.BI_Tipo_Moneda (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	descripcion NVARCHAR(100)
);

CREATE TABLE MANGO_DB.BI_Alquiler (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
)


/* ------- CREACION DE LOS HECHOS ------- */

-- POR AHORA PLANTEAMOS CREAR 3 HECHOS, DE ANUNCIOS, DE VENTAS (CON PAGO DE VENTAS) 
-- Y DE ALQUILERES (CON CADA PAGO DE ALQUILER)

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
	--fecha_publicacion DATETIME,
	--precio_publicado NUMERIC(18,2),
	--fecha_finalizacion DATETIME,

	FOREIGN KEY (id_ubicacion) REFERENCES MANGO_DB.BI_Ubicacion(id),
    FOREIGN KEY (id_tiempo) REFERENCES MANGO_DB.BI_Tiempo(id),
    FOREIGN KEY (id_sucursal) REFERENCES MANGO_DB.BI_Sucursal(id),
    FOREIGN KEY (id_rango_etario_agente) REFERENCES MANGO_DB.BI_Rango_etario(id),
    FOREIGN KEY (id_tipo_inmueble) REFERENCES MANGO_DB.BI_Tipo_Inmueble(id),
    FOREIGN KEY (id_ambientes) REFERENCES MANGO_DB.BI_Ambientes(id),
    FOREIGN KEY (id_rango_m2) REFERENCES MANGO_DB.BI_Rango_m2(id),
    FOREIGN KEY (id_tipo_operacion) REFERENCES MANGO_DB.BI_Tipo_Operacion(id),
    FOREIGN KEY (id_tipo_moneda) REFERENCES MANGO_DB.BI_Tipo_Moneda(id),

	PRIMARY KEY (id_ubicacion, id_tiempo, id_sucursal, id_rango_etario, id_tipo_inmueble, id_ambientes, id_rango_m2, id_tipo_operacion, id_tipo_moneda)
);

CREATE TABLE MANGO_DB.BI_Hecho_Venta(
	--id_anuncio NUMERIC(18,0) 		-- EN REALIDAD SERIAN TODAS LAS PK DEL HECHO ANUNCIO
	id_moneda NUMERIC(18,0),
	id_tiempo NUMERIC(18,0),
	id_medio_pago NUMERIC(18,0),
	id_rango_m2 NUMERIC(18,0),
	id_tipo_inmueble NUMERIC(18,0),

	precio_venta NUMERIC(18,2),
	comision NUMERIC(18,2),
	cotizacion NUMERIC(18,2),
	pago_venta_importe NUMERIC(18,2),
);

CREATE TABLE MANGO_DB.BI_Hecho_Alquiler(

);

/* ------- CARGA DE LAS DIMENSIONES ------- */

-- Tenemos que sacar los datos de las tablas del esquema transaccional

-- Tiempo (VER si falta alguna fecha o si sobra)
    INSERT INTO MANGO_DB.BI_tiempo (anio, cuatrimestre, mes)
    (SELECT DISTINCT
        YEAR(fecha_inicio) as 'anio',
        (CASE WHEN MONTH(fecha_inicio) IN (1,2,3,4)    THEN 1
              WHEN MONTH(fecha_inicio) IN (5,6,7,8)    THEN 2
              WHEN MONTH(fecha_inicio) IN (9,10,11,12) THEN 3 END) as 'cuatrimestre',
		MONTH(fecha_inicio) as 'mes'
    FROM MANGO_DB.alquiler
    UNION
    SELECT DISTINCT
        YEAR(fecha_fin),
        (CASE WHEN MONTH(fecha_fin) IN (1,2,3,4)    THEN 1
              WHEN MONTH(fecha_fin) IN (5,6,7,8)    THEN 2
              WHEN MONTH(fecha_fin) IN (9,10,11,12) THEN 3 END),
		MONTH(fecha_fin)
    FROM MANGO_DB.alquiler
        UNION
    SELECT DISTINCT
        YEAR(fecha_publicacion),
        (CASE WHEN MONTH(fecha_publicacion) IN (1,2,3,4)    THEN 1
              WHEN MONTH(fecha_publicacion) IN (5,6,7,8)    THEN 2
              WHEN MONTH(fecha_publicacion) IN (9,10,11,12) THEN 3 END),
		MONTH(fecha_publicacion)
    FROM MANGO_DB.anuncio
        UNION
    SELECT DISTINCT
        YEAR(fecha),
        (CASE WHEN MONTH(fecha) IN (1,2,3,4)    THEN 1
              WHEN MONTH(fecha) IN (5,6,7,8)    THEN 2
              WHEN MONTH(fecha) IN (9,10,11,12) THEN 3 END),
		MONTH(fecha)
    FROM MANGO_DB.venta
        UNION
    SELECT DISTINCT
        YEAR(fecha_pago),
        (CASE WHEN MONTH(fecha_pago) IN (1,2,3,4)    THEN 1
              WHEN MONTH(fecha_pago) IN (5,6,7,8)    THEN 2
              WHEN MONTH(fecha_pago) IN (9,10,11,12) THEN 3 END),
		MONTH(fecha_pago)
    FROM MANGO_DB.pago_alquiler
        UNION
    SELECT DISTINCT
        YEAR(fecha_vencimiento),
        (CASE WHEN MONTH(fecha_vencimiento) IN (1,2,3,4)    THEN 1
              WHEN MONTH(fecha_vencimiento) IN (5,6,7,8)    THEN 2
              WHEN MONTH(fecha_vencimiento) IN (9,10,11,12) THEN 3 END),
		MONTH(fecha_vencimiento)
    FROM MANGO_DB.pago_alquiler)
	ORDER BY anio

-- Ubicacion

INSERT INTO MANGO_DB.BI_Ubicacion (provincia, localidad, barrio)
SELECT DISTINCT p.nombre as provincia, l.nombre as localidad, b.nombre as barrio
FROM MANGO_DB.inmueble i JOIN MANGO_DB.localidad l ON i.id_localidad = l.id
						JOIN MANGO_DB.provincia p ON l.id_provincia = p.id
						JOIN MANGO_DB.barrio b ON b.id = i.id_barrio

-- Sucursal

INSERT INTO MANGO_DB.BI_Sucursal (codigo, nombre)
SELECT DISTINCT s.codigo, s.nombre
FROM MANGO_DB.sucursal s

-- BI_Rango_etario

INSERT INTO MANGO_DB.BI_Rango_etario (rango)
VALUES ('<25'), ('25-35'), ('35-50'), ('>50')

-- BI_Tipo_Inmueble

INSERT INTO MANGO_DB.BI_Tipo_Inmueble (tipo)
SELECT DISTINCT i.tipo
FROM MANGO_DB.tipo_inmueble i

-- BI_Ambientes

INSERT INTO MANGO_DB.BI_Ambientes (detalle)
SELECT DISTINCT a.detalle
FROM MANGO_DB.ambientes a

-- BI_Rango_m2
INSERT INTO MANGO_DB.BI_Rango_m2 (rango)
VALUES ('<35'), ('35-55'), ('55-75'), ('75-100'), ('>100')

-- BI_Tipo_Operacion

INSERT INTO MANGO_DB.BI_tipo_operacion (tipo)
SELECT DISTINCT o.tipo
FROM MANGO_DB.tipo_operacion o

-- BI_Tipo_Moneda

INSERT INTO MANGO_DB.BI_Tipo_Moneda (descripcion)
SELECT DISTINCT m.descripcion
FROM MANGO_DB.moneda m


/* ------- CARGA DEL HECHO ------- */
/*
INSERT INTO MANGO_DB.BI_Hecho (id_ubicacion, id_tiempo, id_sucursal, id_rango_etario, 
								id_tipo_inmueble, id_ambientes, id_rango_m2, id_tipo_operacion,
								id_tipo_moneda, id_anuncio)
SELECT DISTINCT u.id, t.id, s.id, re.id, ti.id, a.id, rm.id, to.id, m.id, an.id
FROM MANGO_DB.BI_Ubicacion u JOIN MANGO_DB.BI_Tiempo t
*/


/* ------- CREACION DE LAS VISTAS DE LAS DIMENSIONES ------- */
-- TODO Acomodar con las tablas de los hechos
CREATE VIEW duracion_promedio_anuncios_publicados 
(duracionPromedio, tipoOperacion, barrio, ambientes, cuatrimestre, anio)
AS 
SELECT  AVG(DATEDIFF(DAY, BI_anun.fecha_publicacion, BI_anun.fecha_finalizacion)) 'Duracion promedio', 
		BI_to.tipo 'Tipo operacion', BI_b.nombre 'Barrio', BI_amb.detalle 'Ambientes', 
		MANGO_DB.getCuatrimestre(BI_anun.fecha_publicacion) 'Cuatrimestre', YEAR(BI_anun.fecha_publicacion) 'Anio'
FROM MANGO_DB.anuncio BI_anun
		LEFT JOIN MANGO_DB.tipo_operacion BI_to ON BI_to.id = BI_anun.id_tipo_operacion
		LEFT JOIN MANGO_DB.inmueble BI_inm ON BI_inm.codigo = BI_anun.id_inmueble
		LEFT JOIN MANGO_DB.barrio BI_b ON BI_b.id = BI_inm.id_barrio
		LEFT JOIN MANGO_DB.ambientes BI_amb ON BI_amb.id = BI_inm.id_cantidad_ambientes
GROUP BY BI_to.tipo, BI_b.nombre, BI_amb.detalle, YEAR(BI_anun.fecha_publicacion), MANGO_DB.getCuatrimestre(BI_anun.fecha_publicacion)
ORDER BY YEAR(BI_anun.fecha_publicacion), MANGO_DB.getCuatrimestre(BI_anun.fecha_publicacion), BI_to.tipo, BI_b.nombre, BI_amb.detalle

--WITH CHECK OPTION

-- TODO ARREGLAR LOS CASE HORRIBLES ESTOS --
CREATE VIEW precio_promedio_de_anuncios_de_inmuebles (precio_promedio, tipo_operacion, anio, cuatrimestre, tipo_inmueble, rango_m2, divisa)	
AS 
SELECT AVG(a.precio_publicado) AS precio_promedio,
		m.descripcion, 
		tipOp.tipo AS tipo_operacion, 
		t.tipo AS tipo_inmueble,
		CASE 
			WHEN i.superficie_total < 35 THEN '< 35'
			WHEN i.superficie_total >= 35 AND i.superficie_total < 55 THEN '35 - 55'
			WHEN i.superficie_total >= 55 AND i.superficie_total < 75 THEN '55 - 75'
			WHEN i.superficie_total >= 75 AND i.superficie_total < 100 THEN '75 - 100'
			WHEN i.superficie_total > 100 THEN '> 100'
		END AS rangoSuperficie,
		YEAR(a.fecha_publicacion) AS anio, 
		CASE 
			WHEN MONTH(a.fecha_publicacion) BETWEEN 1 AND 4 THEN 1
			WHEN MONTH(a.fecha_publicacion) BETWEEN 5 AND 9 THEN 2
			WHEN MONTH(a.fecha_publicacion) BETWEEN 10 AND 12 THEN 3
		END AS cuatrimestre
FROM MANGO_DB.anuncio a INNER JOIN MANGO_DB.inmueble i ON a.id_inmueble = i.codigo
						INNER JOIN MANGO_DB.tipo_inmueble t ON i.id_tipo_inmueble = t.id
						INNER JOIN MANGO_DB.moneda m ON a.id_moneda = m.id
						INNER JOIN MANGO_DB.tipo_operacion tipOp ON a.id_tipo_operacion = tipOp.id
GROUP BY tipOp.tipo, 
         YEAR(a.fecha_publicacion), 
         CASE 
             WHEN MONTH(a.fecha_publicacion) BETWEEN 1 AND 4 THEN 1
             WHEN MONTH(a.fecha_publicacion) BETWEEN 5 AND 9 THEN 2
             WHEN MONTH(a.fecha_publicacion) BETWEEN 10 AND 12 THEN 3
         END,
         t.tipo,
         CASE 
             WHEN i.superficie_total < 35 THEN '< 35'
             WHEN i.superficie_total >= 35 AND i.superficie_total < 55 THEN '35 - 55'
             WHEN i.superficie_total >= 55 AND i.superficie_total < 75 THEN '55 - 75'
             WHEN i.superficie_total >= 75 AND i.superficie_total < 100 THEN '75 - 100'
             WHEN i.superficie_total > 100 THEN '> 100'
         END,
         m.descripcion
ORDER BY YEAR(a.fecha_publicacion) ASC, cuatrimestre, t.tipo, tipOp.tipo, m.descripcion, rangoSuperficie

CREATE VIEW cinco_barrios_mas_elegidos_para_alquilar (ubicacion)		-- PARA UBICACION, RANGO ETARIO Y TAL VEZ TIPO_OPERACION?
AS 
SELECT TOP 5 u.barrio 
FROM MANGO_DB.BI_Ubicacion u JOIN MANGO_DB.BI_Tiempo t ON ()
--WITH CHECK OPTION

CREATE VIEW porcentaje_incumplimiento_pagos_de_alquileres_en_termino (porcentaje)	-- PARA TIPO_OPERACION? Y TIEMPO
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION

CREATE VIEW porcentaje_promedio_incremento_valor_de_alquileres (porcentaje)		-- PARA TIEMPO Y ????
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION

CREATE VIEW precio_promedio_de_m2_de_la_venta (precio)							-- PARA TIPO_INMUEBLE, UBICACION, TIEMPO, TIPO_OPERACION Y �SUCURSAL?
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION

CREATE VIEW valor_promedio_de_la_comision (valor)								-- PARA TIPO_OPERACION, SUCURSAL Y �TIEMPO??
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION

CREATE VIEW porcentaje_de_operaciones_concretadas (operaciones)					-- PARA TIPO_OPERACION, SUCURSAL, RANGO ETARIO Y �TIEMPO?
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION

CREATE VIEW monto_total_de_cierre_de_contratos_por_tipo_de_operacion (total)	-- PARA TIPO_OPERACION, TIEMPO, SUCURSAL Y TIPO_MONEDA
AS 
SELECT * FROM gd_esquema.Maestra
--WITH CHECK OPTION


