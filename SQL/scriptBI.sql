/*
Script Bussiness Inteligence
*/

USE GD2C2023
GO

/* ------- PROCEDURE PARA RESETEAR CREACION DE FUNCIONES Y TABLAS DEL MODELO BI ------- */

EXEC MANGO_DB.ResetearBI;
GO

/* ------- CREACION DE LAS FUNCIONES ------- */
CREATE FUNCTION MANGO_DB.getCuatrimestre (@fecha DATE)
RETURNS SMALLINT
AS BEGIN
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

CREATE FUNCTION MANGO_DB.getRangoM2 (@metrosCuadrados NUMERIC(18,2))
RETURNS NVARCHAR(6)
AS
BEGIN
	DECLARE @rango NVARCHAR(6)
	SET @rango =
		CASE 
			WHEN @metrosCuadrados < 35.00 THEN '<35'
			WHEN @metrosCuadrados >= 35.00 AND @metrosCuadrados < 55.00 THEN '35-55'
			WHEN @metrosCuadrados >= 55.00 AND @metrosCuadrados < 75.00 THEN '55-75'
			WHEN @metrosCuadrados >= 75.00 AND @metrosCuadrados < 100.00 THEN '75-100'
			WHEN @metrosCuadrados >= 100.00 THEN '>100'
		END

	RETURN @rango
END
GO

CREATE FUNCTION MANGO_DB.getRangoEtario (@fechaNacimiento DATE)
RETURNS NVARCHAR(6)
AS
BEGIN
	DECLARE @EdadActual INT
	DECLARE @rango NVARCHAR(6) 

	SET @EdadActual = CAST(DATEDIFF(DAY, @fechaNacimiento, GETDATE()) / 365.25 AS INT)

	SET @rango =
		CASE 
			WHEN @EdadActual < 25 THEN '<25'
			WHEN @EdadActual >= 25 AND @EdadActual < 35 THEN '25-35'
			WHEN @EdadActual >= 35 AND @EdadActual < 50 THEN '35-50'
			WHEN @EdadActual >= 50 THEN '>50'
		END

	RETURN @rango
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
	codigo NUMERIC(18,0) PRIMARY KEY,
    nombre NVARCHAR(100)
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

/* ------- CREACION DE LOS HECHOS ------- */

CREATE TABLE MANGO_DB.BI_Hecho_Anuncio (
	id_ubicacion NUMERIC(18,0),
	id_tiempo NUMERIC(18,0),
	id_sucursal NUMERIC(18,0),
	id_rango_etario_agente NUMERIC(18,0),
	id_tipo_inmueble NUMERIC(18,0),
	id_ambientes NUMERIC(18,0),
	id_rango_m2 NUMERIC(18,0),
	id_tipo_operacion NUMERIC(18,0),
	id_tipo_moneda NUMERIC(18,0),
	
	sumatoria_precio NUMERIC(18,2) NULL, -- VISTAS: 2
	sumatoria_duracion NUMERIC(18,0) NULL, -- VISTAS: 1
	cantidad_operaciones_concretadas NUMERIC(18,0) NULL, -- VISTAS: 1
	--sumatoria_monto_por_cierre NUMERIC(18,2) NULL, -- VISTAS: 9
	cantidad_anuncios_totales NUMERIC(18,0) NULL -- VISTAS: 2

	FOREIGN KEY (id_ubicacion) REFERENCES MANGO_DB.BI_Ubicacion(id),
    FOREIGN KEY (id_tiempo) REFERENCES MANGO_DB.BI_Tiempo(id),
    FOREIGN KEY (id_sucursal) REFERENCES MANGO_DB.BI_Sucursal(codigo),
    FOREIGN KEY (id_rango_etario_agente) REFERENCES MANGO_DB.BI_Rango_etario(id),
    FOREIGN KEY (id_tipo_inmueble) REFERENCES MANGO_DB.BI_Tipo_Inmueble(id),
    FOREIGN KEY (id_ambientes) REFERENCES MANGO_DB.BI_Ambientes(id),
    FOREIGN KEY (id_rango_m2) REFERENCES MANGO_DB.BI_Rango_m2(id),
    FOREIGN KEY (id_tipo_operacion) REFERENCES MANGO_DB.BI_Tipo_Operacion(id),
    FOREIGN KEY (id_tipo_moneda) REFERENCES MANGO_DB.BI_Tipo_Moneda(id),

	PRIMARY KEY (id_ubicacion, id_tiempo, id_rango_etario_agente, id_tipo_inmueble, id_ambientes, id_rango_m2, id_tipo_operacion, id_tipo_moneda)
);


CREATE TABLE MANGO_DB.BI_Hecho_Venta (
	id_tipo_inmueble NUMERIC(18,0),
	id_ubicacion NUMERIC(18,0),
	id_tiempo NUMERIC(18,0),
	id_sucursal NUMERIC(18,0),
	id_rango_m2	NUMERIC(18,0),
	id_tipo_moneda NUMERIC(18,0),
	id_ambientes NUMERIC(18,0),

	sumatoria_precio_venta NUMERIC(18,2) NULL, -- VISTA: 6
	sumatoria_m2_inmueble NUMERIC(18,2) NULL,

	sumatoria_comisiones NUMERIC(18,2) NULL, -- VISTAS: 7
	cantidad_ventas_concretadas NUMERIC(18,0) NULL -- VISTAS: 6, 7, 8

	FOREIGN KEY (id_tipo_inmueble) REFERENCES MANGO_DB.BI_Tipo_Inmueble(id),
    FOREIGN KEY (id_ubicacion) REFERENCES MANGO_DB.BI_Ubicacion(id),
	FOREIGN KEY (id_tiempo) REFERENCES MANGO_DB.BI_Tiempo(id),
	FOREIGN KEY (id_sucursal) REFERENCES MANGO_DB.BI_Sucursal(codigo),
    FOREIGN KEY (id_rango_m2) REFERENCES MANGO_DB.BI_Rango_m2(id),
	FOREIGN KEY (id_ambientes) REFERENCES MANGO_DB.BI_Ambientes(id),

	PRIMARY KEY (id_tipo_inmueble, id_ubicacion, id_tiempo, id_sucursal, id_rango_m2, id_ambientes)
);

CREATE TABLE MANGO_DB.BI_Hecho_Alquiler(
	id_rango_etario_inquilino NUMERIC(18,0),
	id_rango_etario_agente NUMERIC(18,0),
	id_tiempo NUMERIC(18,0),
	id_ubicacion NUMERIC(18,0),
	id_ambientes NUMERIC(18,0),
	id_tipo_inmueble NUMERIC(18,0),
	id_rango_m2 NUMERIC(18,0),
	id_sucursal NUMERIC(18,0),
	id_tipo_moneda NUMERIC(18,0),

	-- Seria alquileres dados de alta en realidad
	cantidad_alquileres_concretados INT NULL, -- VISTAS: 3, 7, 8
	sumatoria_comisiones NUMERIC(18,2) NULL -- VISTAS: 7

	FOREIGN KEY (id_rango_etario_inquilino) REFERENCES MANGO_DB.BI_Rango_etario(id),
	FOREIGN KEY (id_rango_etario_agente) REFERENCES MANGO_DB.BI_Rango_etario(id),
	FOREIGN KEY (id_tiempo) REFERENCES MANGO_DB.BI_Tiempo(id),
	FOREIGN KEY (id_sucursal) REFERENCES MANGO_DB.BI_sucursal(codigo),
	FOREIGN KEY (id_tipo_inmueble) REFERENCES MANGO_DB.BI_Tipo_Inmueble(id),
    FOREIGN KEY (id_ubicacion) REFERENCES MANGO_DB.BI_Ubicacion(id),
    FOREIGN KEY (id_rango_m2) REFERENCES MANGO_DB.BI_Rango_m2(id),
	FOREIGN KEY (id_ambientes) REFERENCES MANGO_DB.BI_Ambientes(id),
	FOREIGN KEY (id_tipo_moneda) REFERENCES MANGO_DB.BI_tipo_moneda(id),

	PRIMARY KEY (id_rango_etario_inquilino, id_tiempo, id_sucursal, id_rango_etario_agente, id_ubicacion, id_ambientes, id_tipo_inmueble, id_rango_m2, id_tipo_moneda)
);


CREATE TABLE MANGO_DB.BI_Hecho_Pago_Alquiler(
	id_rango_etario_inquilino NUMERIC(18,0),
	id_rango_etario_agente NUMERIC(18,0),
	id_tiempo NUMERIC(18,0),
	id_ubicacion NUMERIC(18,0),
	id_ambientes NUMERIC(18,0),
	id_tipo_inmueble NUMERIC(18,0),
	id_rango_m2 NUMERIC(18,0),
	id_sucursal NUMERIC(18,0),
	
	total_porcentaje_aumentos NUMERIC(18,0) NULL, -- VISTAS: 5
	cantidad_pagos_en_termino NUMERIC(18,0) NULL, -- VISTAS: 4
	cantidad_porcentajes_aumentos NUMERIC(18,2) NULL, -- VISTAS: 5
	cantidad_pagos_incumplidos NUMERIC(18,0) NULL, -- VISTAS: 4

	FOREIGN KEY (id_rango_etario_inquilino) REFERENCES MANGO_DB.BI_Rango_etario(id),
	FOREIGN KEY (id_rango_etario_agente) REFERENCES MANGO_DB.BI_Rango_etario(id),
	FOREIGN KEY (id_tiempo) REFERENCES MANGO_DB.BI_Tiempo(id),
	FOREIGN KEY (id_sucursal) REFERENCES MANGO_DB.BI_sucursal(codigo),
	FOREIGN KEY (id_tipo_inmueble) REFERENCES MANGO_DB.BI_Tipo_Inmueble(id),
    FOREIGN KEY (id_ubicacion) REFERENCES MANGO_DB.BI_Ubicacion(id),
    FOREIGN KEY (id_rango_m2) REFERENCES MANGO_DB.BI_Rango_m2(id),
	FOREIGN KEY (id_ambientes) REFERENCES MANGO_DB.BI_Ambientes(id),

	PRIMARY KEY (id_rango_etario_inquilino, id_tiempo, id_sucursal, id_rango_etario_agente, id_ubicacion, id_ambientes, id_tipo_inmueble, id_rango_m2)
);


/* ------- CARGA DE LAS DIMENSIONES ------- */

-- BI_Tiempo
    INSERT INTO MANGO_DB.BI_tiempo (anio, cuatrimestre, mes)
    (SELECT DISTINCT
        YEAR(fecha_inicio) as 'anio',
        MANGO_DB.getCuatrimestre(fecha_inicio) as 'cuatrimestre',
		MONTH(fecha_inicio) as 'mes'
    FROM MANGO_DB.alquiler
    UNION
    SELECT DISTINCT
        YEAR(fecha_fin) as 'anio',
        MANGO_DB.getCuatrimestre(fecha_fin),
		MONTH(fecha_fin)
    FROM MANGO_DB.alquiler
        UNION
    SELECT DISTINCT
        YEAR(fecha_publicacion) as 'anio',
        MANGO_DB.getCuatrimestre(fecha_publicacion),
		MONTH(fecha_publicacion)
    FROM MANGO_DB.anuncio
        UNION
    SELECT DISTINCT
        YEAR(fecha) as 'anio',
        MANGO_DB.getCuatrimestre(fecha),
		MONTH(fecha)
    FROM MANGO_DB.venta
        UNION
    SELECT DISTINCT
        YEAR(fecha_pago) as 'anio',
        MANGO_DB.getCuatrimestre(fecha_pago),
		MONTH(fecha_pago)
    FROM MANGO_DB.pago_alquiler
        UNION
    SELECT DISTINCT
        YEAR(fecha_vencimiento) as 'anio',
        MANGO_DB.getCuatrimestre(fecha_vencimiento),
		MONTH(fecha_vencimiento)
    FROM MANGO_DB.pago_alquiler)
	ORDER BY anio

-- BI_Ubicacion

INSERT INTO MANGO_DB.BI_Ubicacion (provincia, localidad, barrio)
SELECT DISTINCT p.nombre as provincia, l.nombre as localidad, b.nombre as barrio
FROM MANGO_DB.inmueble i JOIN MANGO_DB.localidad l ON i.id_localidad = l.id
						JOIN MANGO_DB.provincia p ON l.id_provincia = p.id
						JOIN MANGO_DB.barrio b ON b.id = i.id_barrio

-- BI_Sucursal

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

INSERT INTO MANGO_DB.BI_Tipo_Operacion (tipo)
SELECT DISTINCT o.tipo
FROM MANGO_DB.tipo_operacion o

-- BI_Tipo_Moneda

INSERT INTO MANGO_DB.BI_Tipo_Moneda (descripcion)
SELECT DISTINCT m.descripcion
FROM MANGO_DB.moneda m


-- HASTA ACA SE PUEDE EJECUTAR MULTIPLES VECES Y PARECE ANDAR TODO JOYA

/* ------- CARGA DE LOS HECHOS ------- */

-- BI_Hecho_Anuncio ACLARACION: CARGAR LA FECHA DE ALTA en id tiempo
INSERT INTO MANGO_DB.BI_Hecho_Anuncio (id_tipo_operacion, id_ubicacion, id_ambientes, id_tiempo, id_tipo_inmueble, 
									   id_rango_m2, id_tipo_moneda, id_rango_etario_agente, id_sucursal, sumatoria_duracion, 
									   sumatoria_precio, cantidad_anuncios_totales, cantidad_operaciones_concretadas)
SELECT a.id_tipo_operacion, u.id, amb.id, biti.id, tipoInmu.id, rangoM2.id, tipoMon.id, rangEtAg.id, bis.codigo,
	   SUM(DATEDIFF(DAY, a.fecha_publicacion, a.fecha_finalizacion)),
	   SUM(a.precio_publicado), COUNT(*), SUM(CASE WHEN ea.estado IN ('Vendido','Alquilado') THEN 1 ELSE 0 END)
FROM MANGO_DB.anuncio a 
	-- INICIO JOIN CON TABLAS BI 
	-- (TIEMPO, UBICACION, SUCURSAL, RANGO ETARIO AGENTE, RANGO ETARIO INQUILINO, TIPO INMUEBLE, AMBIENTES, RANGO M2, TIPO MONEDA)
						JOIN MANGO_DB.tipo_operacion tiO ON (a.id_tipo_operacion = tiO.id)
						JOIN MANGO_DB.BI_Tipo_Operacion tipoOp ON (tipoOp.tipo = tiO.tipo)
						JOIN MANGO_DB.BI_tiempo biti ON (biti.anio = YEAR(a.fecha_publicacion) AND biti.mes = MONTH(a.fecha_publicacion) AND biti.cuatrimestre = MANGO_DB.getCuatrimestre(a.fecha_publicacion))
						JOIN MANGO_DB.inmueble i ON (a.id_inmueble = i.codigo)
						JOIN MANGO_DB.barrio bar ON (bar.id = i.id_barrio)
						JOIN MANGO_DB.localidad loc ON (loc.id = i.id_localidad)
						JOIN MANGO_DB.provincia prov ON (prov.id = loc.id_provincia)
						JOIN MANGO_DB.BI_Ubicacion u ON (u.barrio = bar.nombre AND u.localidad = loc.nombre AND u.provincia = prov.nombre)
						JOIN MANGO_DB.ambientes ambi ON (ambi.id = i.id_cantidad_ambientes)
						JOIN MANGO_DB.BI_Ambientes amb ON (amb.detalle = ambi.detalle)
						JOIN MANGO_DB.tipo_inmueble tipI ON (tipI.id = i.id_tipo_inmueble)
						JOIN MANGO_DB.BI_Tipo_Inmueble tipoInmu ON (tipoInmu.tipo = tipI.tipo)
						JOIN MANGO_DB.BI_Rango_m2 rangoM2 ON (rangoM2.rango = MANGO_DB.getRangoM2(i.superficie_total))
						JOIN MANGO_DB.moneda mon ON (mon.id = a.id_moneda)
						JOIN MANGO_DB.BI_Tipo_Moneda tipoMon ON (tipoMon.descripcion = mon.descripcion)
						JOIN MANGO_DB.agente agente ON (agente.id = a.id_agente)
						JOIN MANGO_DB.BI_Rango_etario rangEtAg ON (rangEtAg.rango = MANGO_DB.getRangoEtario(agente.fecha_nac))
						JOIN MANGO_DB.sucursal s ON (s.codigo = agente.id_sucursal)
						JOIN MANGO_DB.BI_Sucursal bis ON (bis.codigo = s.codigo)
						JOIN MANGO_DB.estado_anuncio ea ON (ea.id = a.id_estado)
						
GROUP BY a.id_tipo_operacion, u.id, amb.id, biti.id, tipoInmu.id, rangoM2.id, tipoMon.id, rangEtAg.id, bis.codigo;


-- SELECT * FROM MANGO_DB.BI_Hecho_Anuncio


-- BI_Hecho_Venta
INSERT INTO MANGO_DB.BI_Hecho_Venta (id_tipo_inmueble, id_ubicacion, id_tiempo, id_sucursal, id_rango_m2, id_tipo_moneda, id_ambientes,
									 sumatoria_m2_inmueble, sumatoria_precio_venta, sumatoria_comisiones,
									 cantidad_ventas_concretadas)
SELECT DISTINCT bti.id 'id_tipo_inmueble', biubi.id 'id_ubicacion', biti.id 'id_tiempo', bis.codigo 'id_sucursal', birg.id 'id_rango_m2', bimon.id 'id_moneda', biamb.id 'id_ambientes', SUM(inm.superficie_total) 'sumatoria_m2_inmueble', 
		SUM(v.precio_venta) 'sumatoria_precio_venta', SUM(v.comision) 'sumatoria_comisiones', COUNT(*) 'cantidad_ventas_concretadas'
FROM MANGO_DB.venta v 
	-- INICIO JOIN CON TABLAS BI 
	-- (TIEMPO, UBICACION, SUCURSAL, RANGO ETARIO AGENTE, RANGO ETARIO INQUILINO, TIPO INMUEBLE, AMBIENTES, RANGO M2, TIPO MONEDA)
						LEFT JOIN MANGO_DB.anuncio a ON (v.id_anuncio = a.codigo)
						LEFT JOIN MANGO_DB.agente ag ON (ag.id = a.id_agente)
						LEFT JOIN MANGO_DB.inmueble inm ON (a.id_inmueble = inm.codigo)
						LEFT JOIN MANGO_DB.tipo_Inmueble ti ON (inm.id_tipo_inmueble = ti.id)
						LEFT JOIN MANGO_DB.BI_Tipo_Inmueble bti ON (bti.tipo = ti.tipo)
						JOIN MANGO_DB.barrio bar ON (bar.id = inm.id_barrio)
						JOIN MANGO_DB.localidad loc ON (loc.id = inm.id_localidad)
						JOIN MANGO_DB.provincia prov ON (prov.id = loc.id_provincia) -- creo q el de provincia ta demás pero no nos caga así que lo dejo
						LEFT JOIN MANGO_DB.BI_Ubicacion biubi ON (biubi.barrio = bar.nombre AND biubi.localidad = loc.nombre AND biubi.provincia = prov.nombre)
						LEFT JOIN MANGO_DB.BI_tiempo biti ON (biti.anio = YEAR(v.fecha) AND	biti.mes = MONTH(v.fecha) AND biti.cuatrimestre = MANGO_DB.getCuatrimestre(v.fecha))
						LEFT JOIN MANGO_DB.sucursal suc ON (suc.codigo = ag.id_sucursal)
						LEFT JOIN MANGO_DB.BI_Sucursal bis ON (bis.codigo = suc.codigo)
						LEFT JOIN MANGO_DB.BI_Rango_m2 birg ON (birg.rango = MANGO_DB.getRangoM2(inm.superficie_total))
						LEFT JOIN MANGO_DB.moneda mon ON (mon.descripcion = v.moneda)
						LEFT JOIN MANGO_DB.BI_Tipo_Moneda bimon ON (bimon.id = mon.id)
						LEFT JOIN MANGO_DB.ambientes amb ON (amb.id = inm.id_cantidad_ambientes)
						LEFT JOIN MANGO_DB.BI_Ambientes biamb ON (biamb.detalle = amb.detalle) 
GROUP BY bti.id, biubi.id, biti.id, bis.codigo, birg.id, bimon.id, biamb.id

-- SELECT * FROM MANGO_DB.BI_Hecho_Venta

-- BI_Hecho_Alquiler 
INSERT INTO MANGO_DB.BI_Hecho_Alquiler
(id_rango_etario_agente, id_rango_etario_inquilino, id_tiempo, id_ubicacion, id_ambientes, id_tipo_inmueble, 
id_rango_m2, id_sucursal, id_tipo_moneda, cantidad_alquileres_concretados, sumatoria_comisiones)
SELECT 
	bi_rg_agente.id,
	bi_rg_inq.id,
	biti.id, 
	bi_ubi.id,
	bi_amb.id,
	bi_tinm.id,
	bi_rm2.id,
	bis.codigo,
	bi_mon.id,
	COUNT(*), 
	SUM(alq.comision)
FROM MANGO_DB.alquiler alq 
	-- JOINS CON TABLAS DEL DOMINIO PARA PODER JOINEAR CON LAS DIMENSIONES
	LEFT JOIN MANGO_DB.anuncio anunc ON anunc.codigo = alq.id_anuncio
	-- Para tipo_inmueble, ambientes
	LEFT JOIN MANGO_DB.inmueble inm ON inm.codigo = anunc.id_inmueble
	LEFT JOIN MANGO_DB.tipo_inmueble tipo_inm ON tipo_inm.id = inm.id_tipo_inmueble
	LEFT JOIN MANGO_DB.ambientes amb ON amb.id = inm.id_cantidad_ambientes
	-- Para ubicacion
	LEFT JOIN MANGO_DB.barrio bar ON bar.id = inm.id_barrio
	LEFT JOIN MANGO_DB.localidad loc ON loc.id = inm.id_localidad
	LEFT JOIN MANGO_DB.provincia prov ON prov.id = loc.id_provincia
	-- Para los rangos etarios
	LEFT JOIN MANGO_DB.inquilino inq ON (alq.id_inquilino = inq.id)
	LEFT JOIN MANGO_DB.agente agent ON agent.id = anunc.id_agente

	-- INICIO JOIN CON TABLAS BI
	LEFT JOIN MANGO_DB.BI_Tiempo biti ON (biti.anio = YEAR(alq.fecha_inicio) AND
										  biti.mes = MONTH(alq.fecha_inicio) AND
										  biti.cuatrimestre = MANGO_DB.getCuatrimestre(alq.fecha_inicio))
	LEFT JOIN MANGO_DB.BI_Sucursal bis ON (bis.codigo = alq.id_sucursal)
	LEFT JOIN MANGO_DB.BI_Ubicacion bi_ubi ON (bi_ubi.barrio = bar.nombre AND 
											   bi_ubi.localidad = loc.nombre AND
											   bi_ubi.provincia = prov.nombre)
	LEFT JOIN MANGO_DB.BI_Rango_etario bi_rg_agente ON bi_rg_agente.rango = MANGO_DB.getRangoEtario(agent.fecha_nac)
	LEFT JOIN MANGO_DB.BI_Rango_etario bi_rg_inq ON bi_rg_inq.rango = MANGO_DB.getRangoEtario(inq.fecha_nac)
	LEFT JOIN MANGO_DB.BI_Ambientes bi_amb ON bi_amb.detalle = amb.detalle
	LEFT JOIN MANGO_DB.BI_Tipo_Inmueble bi_tinm ON bi_tinm.tipo = tipo_inm.tipo
	LEFT JOIN MANGO_DB.BI_Rango_m2 bi_rm2 ON bi_rm2.rango = MANGO_DB.getRangoM2(inm.superficie_total)
	LEFT JOIN MANGO_DB.moneda mon ON (mon.id = anunc.id_moneda)
	LEFT JOIN MANGO_DB.BI_Tipo_Moneda bi_mon ON (bi_mon.descripcion = mon.descripcion)
GROUP BY bi_rg_agente.id, bi_rg_inq.id, biti.id, bi_ubi.id, bi_amb.id, bi_tinm.id, bi_rm2.id, bis.codigo, bi_mon.id

-- SELECT * FROM MANGO_DB.BI_Hecho_Alquiler

/*
SELECT mone.descripcion, COUNT(*) AS 'Cantidad de alquileres'
FROM MANGO_DB.alquiler alq
	LEFT JOIN MANGO_DB.anuncio anunc ON anunc.codigo = alq.id_anuncio
	LEFT JOIN MANGO_DB.moneda mone ON mone.id = anunc.id_moneda
GROUP BY mone.descripcion 


SELECT * FROM MANGO_DB.BI_Tiempo

-- 12.842 alquileres en total
SELECT COUNT(*) FROM MANGO_DB.alquiler

SELECT anio, mes 
FROM MANGO_DB.BI_Tiempo
WHERE anio = '2030'



SELECT * FROM MANGO_DB.BI_Rango_etario
/*
id_rango_etario_inquilino, id_tiempo, id_sucursal, cantidad_alquileres_concretados, sumatoria_comisiones
*/
SELECT * FROM MANGO_DB.alquiler
*/

-- BI_Hecho_Pago_Alquiler

INSERT INTO MANGO_DB.BI_Hecho_Pago_Alquiler(id_tiempo, id_sucursal, id_ubicacion, id_rango_etario_agente, id_rango_etario_inquilino, id_ambientes, id_tipo_inmueble, id_rango_m2, 
											total_porcentaje_aumentos, cantidad_pagos_en_termino, cantidad_porcentajes_aumentos, cantidad_pagos_incumplidos)
SELECT biti.id, bis.codigo, bi_ubi.id, bi_rg_agente.id, bi_rg_inq.id, bi_amb.id, bi_tinm.id, bi_rm2.id,
		SUM((pag_al.importe - pag_al_ant.importe)/pag_al_ant.importe*100) AS total_porcentaje_aumentos,
		COUNT(*) AS cantidad_pagos_en_termino,
		COUNT(pag_al_ant.codigo) AS cantidad_porcentajes_aumentos,
		SUM(CASE WHEN (pag_al.fecha_pago >= pag_al.fecha_vencimiento) then 1 else 0 END) AS cantidad_pagos_incumplidos
FROM MANGO_DB.alquiler a
						-- JOINS CON TABLAS DEL DOMINIO PARA PODER JOINEAR CON LAS DIMENSIONES
						LEFT JOIN MANGO_DB.pago_alquiler pag_al ON a.codigo = pag_al.id_alquiler
						LEFT JOIN MANGO_DB.alquiler alq ON alq.codigo = pag_al.id_alquiler
						LEFT JOIN MANGO_DB.anuncio anunc ON anunc.codigo = alq.id_anuncio
						-- Para tipo_inmueble, ambientes
						LEFT JOIN MANGO_DB.inmueble inm ON inm.codigo = anunc.id_inmueble
						LEFT JOIN MANGO_DB.tipo_inmueble tipo_inm ON tipo_inm.id = inm.id_tipo_inmueble
						LEFT JOIN MANGO_DB.ambientes amb ON amb.id = inm.id_cantidad_ambientes
						-- Para ubicacion
						LEFT JOIN MANGO_DB.barrio bar ON bar.id = inm.id_barrio
						LEFT JOIN MANGO_DB.localidad loc ON loc.id = inm.id_localidad
						LEFT JOIN MANGO_DB.provincia prov ON prov.id = loc.id_provincia
						-- Para los rangos etarios
						LEFT JOIN MANGO_DB.inquilino inq ON (alq.id_inquilino = inq.id)
						LEFT JOIN MANGO_DB.agente agent ON agent.id = anunc.id_agente

						-- INICIO JOIN CON TABLAS BI
						LEFT JOIN MANGO_DB.BI_Sucursal bis ON (bis.codigo = alq.id_sucursal) -- TA BIEN
						LEFT JOIN MANGO_DB.BI_Ubicacion bi_ubi ON (bi_ubi.barrio = bar.nombre AND 
																   bi_ubi.localidad = loc.nombre AND
																   bi_ubi.provincia = prov.nombre)
						LEFT JOIN MANGO_DB.BI_Rango_etario bi_rg_agente ON bi_rg_agente.rango = MANGO_DB.getRangoEtario(agent.fecha_nac)
						LEFT JOIN MANGO_DB.BI_Rango_etario bi_rg_inq ON bi_rg_inq.rango = MANGO_DB.getRangoEtario(inq.fecha_nac)
						LEFT JOIN MANGO_DB.BI_Ambientes bi_amb ON bi_amb.detalle = amb.detalle
						LEFT JOIN MANGO_DB.BI_Tipo_Inmueble bi_tinm ON bi_tinm.tipo = tipo_inm.tipo
						LEFT JOIN MANGO_DB.BI_Rango_m2 bi_rm2 ON bi_rm2.rango = MANGO_DB.getRangoM2(inm.superficie_total)

						LEFT JOIN MANGO_DB.BI_Tiempo biti ON (biti.anio = YEAR(pag_al.fec_ini) AND
														biti.mes = MONTH(pag_al.fec_ini) AND
														biti.cuatrimestre = MANGO_DB.getCuatrimestre(pag_al.fec_ini))
						LEFT JOIN MANGO_DB.pago_alquiler pag_al_ant ON pag_al_ant.id_alquiler = pag_al.id_alquiler AND
								   												  YEAR(pag_al_ant.fecha_pago) = YEAR(pag_al.fecha_pago) AND
																				  MONTH(pag_al_ant.fecha_pago) = MONTH(pag_al.fecha_pago) AND
																				  pag_al_ant.importe < pag_al.importe AND
																				  GETDATE() < pag_al.fec_fin
WHERE pag_al.fecha_pago IS NOT NULL -- hace falta esto? No lo saqué por las dudas
GROUP BY biti.id, bis.codigo, bi_ubi.id, bi_rg_agente.id, bi_rg_inq.id, bi_amb.id, bi_tinm.id, bi_rm2.id
GO

-- SELECT * FROM MANGO_DB.BI_Hecho_Pago_Alquiler

/* ------- CREACION DE LAS VISTAS EN FUNCION DE LAS DIMENSIONES ------- */

-- VISTA 1
CREATE VIEW MANGO_DB.BI_duracion_promedio_anuncios AS
SELECT 
	(SUM(bi_ha.sumatoria_duracion) / COUNT(*)) AS 'Duracion promedio',
	bi_to.tipo AS 'Tipo operacion',
	bi_ubi.barrio,
	bi_t.cuatrimestre,
	bi_t.anio,
	bi_amb.detalle AS 'Ambientes'
FROM MANGO_DB.BI_Hecho_Anuncio bi_ha
	LEFT JOIN MANGO_DB.BI_Tipo_Operacion bi_to ON bi_to.id = bi_ha.id_tipo_operacion
	LEFT JOIN MANGO_DB.BI_Ubicacion bi_ubi ON bi_ubi.id = bi_ha.id_ubicacion
	LEFT JOIN MANGO_DB.BI_Tiempo bi_t ON bi_t.id = bi_ha.id_tiempo
	LEFT JOIN MANGO_DB.BI_Ambientes bi_amb ON bi_amb.id = bi_ha.id_ambientes
GROUP BY bi_to.tipo, bi_ubi.barrio, bi_t.anio, bi_t.cuatrimestre, bi_amb.detalle
GO

-- VISTA 2
-- TODO ACOMODAR LOS NOMBRES

CREATE VIEW MANGO_DB.BI_precio_promedio_anuncios AS
SELECT 
	(sumatoria_precio / COUNT(*)) AS 'Precio promedio',
	bi_to.tipo AS 'Tipo operacion',
	bi_ti.tipo AS 'Tipo inmueble',
	bi_rango.rango AS 'Rango M2',
	bi_t.cuatrimestre,
	bi_t.anio
FROM MANGO_DB.BI_Hecho_Anuncio bi_ha
	LEFT JOIN MANGO_DB.BI_Tipo_Operacion bi_to ON bi_to.id = bi_ha.id_tipo_operacion
	LEFT JOIN MANGO_DB.BI_Tipo_Inmueble bi_ti ON bi_ti.id = bi_ha.id_tipo_inmueble
	LEFT JOIN MANGO_DB.BI_Tiempo bi_t ON bi_t.id = bi_ha.id_tiempo
	LEFT JOIN MANGO_DB.BI_Rango_m2 bi_rango ON bi_rango.id = bi_ha.id_rango_m2
GROUP BY sumatoria_precio, bi_to.tipo, bi_ti.tipo, bi_rango.rango, bi_t.cuatrimestre, bi_t.anio
GO

-- VISTA 3
-- TODO ACOMODAR LOS NOMBRES-- PROBAR PORQUE NO SE SI FUNCIONA COMO CREO!!
CREATE VIEW MANGO_DB.BI_barrios_mas_elegidos_alquiler AS
SELECT TOP 5
	bi_ubi.barrio AS 'Barrio',
	bi_re.rango AS 'Rango etario',
	bi_ti.cuatrimestre AS 'Cuatrimestre',
	bi_ti.anio AS 'Anio'
FROM MANGO_DB.BI_Hecho_Alquiler bi_ha
	LEFT JOIN MANGO_DB.BI_Rango_Etario bi_re ON bi_re.id = bi_ha.id_rango_etario_inquilino
	LEFT JOIN MANGO_DB.BI_Tiempo bi_ti ON bi_ti.id = bi_ha.id_tiempo
	LEFT JOIN MANGO_DB.BI_Hecho_Anuncio bi_han ON bi_han.id_tiempo = bi_ti.id
	LEFT JOIN MANGO_DB.BI_Ubicacion bi_ubi ON bi_ubi.id = bi_han.id_ubicacion
GROUP BY bi_ubi.barrio, bi_re.rango, bi_ti.cuatrimestre, bi_ti.cuatrimestre, bi_ti.anio, bi_ha.cantidad_alquileres_concretados
ORDER BY bi_ha.cantidad_alquileres_concretados DESC -- Faltaba esta linea antes
GO

-- VISTA 4
-- CORREGIDA
CREATE VIEW MANGO_DB.BI_porcentaje_incumplimiento_pagos_alquileres AS
SELECT 
	(SUM(bi_hpa.cantidad_pagos_incumplidos) * 100 ) / (SUM(bi_hpa.cantidad_pagos_en_termino) + SUM(bi_hpa.cantidad_pagos_incumplidos)) AS 'Porcentaje incumplimiento',
	bi_tie.mes AS 'Mes',
	bi_tie.anio AS 'Anio'
FROM MANGO_DB.BI_Hecho_Pago_Alquiler bi_hpa
	LEFT JOIN MANGO_DB.BI_Tiempo bi_tie ON bi_tie.id = bi_hpa.id_tiempo
GROUP BY bi_tie.anio, bi_tie.mes
GO

-- VISTA 5
CREATE VIEW MANGO_DB.BI_porcentaje_promedio_incremento_valor_alquileres AS
SELECT 
	t.mes,
	t.anio, 
	-- Tenemos que ver si manejamos los aumentos en porcentaje o en monto
	-- Ya que eso nos cambia como se hace esta vista. Si es en porcentaje, ya estaria lista
	SUM(bi_pag_al.total_porcentaje_aumentos) / SUM(bi_pag_al.cantidad_porcentajes_aumentos) AS "Porcentaje promedio de incremento"
FROM MANGO_DB.BI_Hecho_Pago_Alquiler bi_pag_al
    JOIN MANGO_DB.BI_Tiempo t ON bi_pag_al.id_tiempo = t.id
WHERE bi_pag_al.cantidad_porcentajes_aumentos != 0
GROUP BY t.mes, t.anio
GO

-- VISTA 6
CREATE VIEW MANGO_DB.BI_precio_promedio_m2 AS
SELECT
	SUM(bi_hv.sumatoria_precio_venta) / SUM(bi_hv.sumatoria_precio_venta) AS 'Promedio',
	bi_ti.tipo AS 'Tipo de inmueble',
	bi_ubi.localidad AS 'Localidad',
	bi_tie.cuatrimestre AS 'Cuatrimestre',
	bi_tie.anio AS 'Anio'
FROM MANGO_DB.BI_Hecho_Venta bi_hv
	LEFT JOIN MANGO_DB.BI_Rango_m2 bi_rango ON bi_rango.id = bi_hv.id_rango_m2
	LEFT JOIN MANGO_DB.BI_Tipo_Inmueble bi_ti ON bi_ti.id = bi_hv.id_tipo_inmueble
	LEFT JOIN MANGO_DB.BI_Tiempo bi_tie ON bi_tie.id = bi_hv.id_tiempo
	LEFT JOIN MANGO_DB.BI_Ubicacion bi_ubi ON bi_ubi.id = bi_hv.id_ubicacion
GROUP BY bi_ti.tipo ,bi_tie.cuatrimestre, bi_tie.anio, bi_ubi.localidad
GO

-- VISTA 7
-- TODO ACOMODAR LOS NOMBRES
-- SI NO FUNCIONA, CAMBIAR LOS NOMBRES DE LAS COLUMNAS EN COMUN Y NO HACERLAS STRING SINO NOMBRE DIRECTO
CREATE VIEW MANGO_DB.BI_comision_promedio AS
SELECT Tabla_alquileres.[Comision promedio] AS 'Comision promedio', Tabla_alquileres.[Tipo operacion] AS 'Tipo operacion',
	   Tabla_alquileres.Sucursal AS 'Sucursal', Tabla_alquileres.Cuatrimestre AS 'Cuatrimestre', Tabla_alquileres.Anio AS 'Anio'
FROM (
	SELECT 
		bi_ha.sumatoria_comisiones / bi_ha.cantidad_alquileres_concretados AS 'Comision promedio',
		'Alquiler' AS 'Tipo operacion',
		bi_s.nombre AS 'Sucursal',
		bi_tie.cuatrimestre AS 'Cuatrimestre',
		bi_tie.anio AS 'Anio'
	FROM MANGO_DB.BI_Hecho_Alquiler bi_ha
		LEFT JOIN MANGO_DB.BI_Sucursal bi_s ON bi_s.codigo = bi_ha.id_sucursal
		LEFT JOIN MANGO_DB.BI_Tiempo bi_tie ON bi_tie.id = bi_ha.id_tiempo
	GROUP BY bi_ha.sumatoria_comisiones, bi_ha.cantidad_alquileres_concretados, bi_s.nombre, bi_tie.cuatrimestre, bi_tie.anio
	) AS Tabla_alquileres
UNION
SELECT Tabla_ventas.[Comision promedio] AS 'Comision promedio', Tabla_ventas.[Tipo operacion] AS 'Tipo operacion',
	   Tabla_ventas.Sucursal AS 'Sucursal', Tabla_ventas.Cuatrimestre AS 'Cuatrimestre', Tabla_ventas.Anio AS 'Anio'
FROM (
	SELECT
		bi_hv.sumatoria_comisiones / bi_hv.cantidad_ventas_concretadas AS 'Comision promedio',
		'Venta' AS 'Tipo operacion',
		bi_s.nombre AS 'Sucursal',
		bi_tie.cuatrimestre AS 'Cuatrimestre',
		bi_tie.anio AS 'Anio'
	FROM MANGO_DB.BI_Hecho_Venta bi_hv
		LEFT JOIN MANGO_DB.BI_Sucursal bi_s ON bi_s.codigo = bi_hv.id_sucursal
		LEFT JOIN MANGO_DB.BI_Tiempo bi_tie ON bi_tie.id = bi_hv.id_tiempo
	GROUP BY bi_hv.sumatoria_comisiones, bi_hv.cantidad_ventas_concretadas, bi_s.nombre, bi_tie.cuatrimestre, bi_tie.anio
	) AS Tabla_ventas
GO


-- VISTA 8
CREATE VIEW MANGO_DB.BI_porcentaje_operaciones_concretadas AS
SELECT 
	(bi_hanc.cantidad_operaciones_concretadas * 100) / bi_hanc.cantidad_anuncios_totales AS 'Porcentaje', 
	bi_to.tipo AS 'Tipo operacion', 
	bi_s.nombre AS 'Sucursal', 
	bi_rangoE.rango AS 'Rango etario', 
	bi_tie.anio AS 'Anio'
FROM MANGO_DB.BI_Hecho_Anuncio bi_hanc
	LEFT JOIN MANGO_DB.BI_Tipo_Operacion bi_to ON bi_to.id = bi_hanc.id_tipo_operacion
	LEFT JOIN MANGO_DB.BI_Sucursal bi_s ON bi_s.codigo = bi_hanc.id_sucursal
	LEFT JOIN MANGO_DB.BI_Rango_etario bi_rangoE ON bi_rangoE.id = bi_hanc.id_rango_etario_agente
	LEFT JOIN MANGO_DB.BI_Tiempo bi_tie ON bi_tie.id = bi_hanc.id_tiempo
GROUP BY bi_tie.anio, bi_rangoE.rango, bi_s.nombre, bi_to.tipo, bi_hanc.cantidad_anuncios_totales, bi_hanc.cantidad_operaciones_concretadas
GO
-- Agregar cantidad_anuncios_totales y id_sucursal EN BI_Hecho_Anuncio

-- VISTA 9
-- TODO ACOMODAR LOS NOMBRES
CREATE VIEW MANGO_DB.BI_monto_total_de_cierre AS
SELECT 
	bi_hanc.sumatoria_precio AS 'Monto total',
	bi_to.tipo AS 'Tipo operacion',
	bi_tie.cuatrimestre AS 'Cuatrimestre',
	bi_tie.anio AS 'Anio',
	bi_suc.nombre AS 'Sucursal',
	bi_moneda.descripcion AS 'Tipo de moneda'
FROM MANGO_DB.BI_Hecho_Anuncio bi_hanc
	LEFT JOIN MANGO_DB.BI_Tipo_Operacion bi_to ON bi_to.id = bi_hanc.id_tipo_operacion
	LEFT JOIN MANGO_DB.BI_tiempo bi_tie ON bi_tie.id = bi_hanc.id_tiempo
	LEFT JOIN MANGO_DB.BI_Sucursal bi_suc ON bi_suc.codigo = bi_hanc.id_sucursal
	LEFT JOIN MANGO_DB.BI_Tipo_Moneda bi_moneda ON bi_moneda.id = bi_hanc.id_tipo_moneda
GROUP BY bi_hanc.sumatoria_precio, bi_to.tipo, bi_tie.cuatrimestre, bi_suc.nombre, bi_moneda.descripcion, bi_tie.anio
GO

-- Borrado de las funciones: Solo para poder volver a ejecutar el mismo .sql sin tocar nada

DROP FUNCTION MANGO_DB.getCuatrimestre
DROP FUNCTION MANGO_DB.getRangoM2
DROP FUNCTION MANGO_DB.getRangoEtario

/*
DROP VIEW MANGO_DB.BI_duracion_promedio_anuncios
DROP VIEW MANGO_DB.BI_barrios_mas_elegidos_alquiler
DROP VIEW MANGO_DB.BI_porcentaje_incumplimiento_pagos_alquileres
DROP VIEW MANGO_DB.BI_porcentaje_promedio_incremento_valor_alquileres
DROP VIEW MANGO_DB.BI_precio_promedio_m2
DROP VIEW MANGO_DB.BI_monto_total_de_cierre
DROP VIEW MANGO_DB.BI_comision_promedio
DROP VIEW MANGO_DB.BI_porcentaje_operaciones_concretadas
DROP VIEW MANGO_DB.BI_precio_promedio_anuncios
*/


/*
--EXEC MANGO_DB.ResetearBI
-- ESTOS 3 SELECT ERAN LOS QUE DABAN PROBLEMAS, SEGURAMENTE SE MODIFICARON, MAS QUE NADA HECHO ALQUILER
SELECT * FROM MANGO_DB.BI_Hecho_Alquiler -- 29 vs 12329
SELECT * FROM MANGO_DB.BI_Hecho_Pago_Alquiler -- 29 vs 22
SELECT * FROM MANGO_DB.BI_Hecho_Venta  -- 4014 vs 4057

-- 1
SELECT * FROM MANGO_DB.BI_duracion_promedio_anuncios ORDER BY [Duracion promedio] DESC
SELECT * FROM ANDY_Y_SUS_SEMINARAS.VistaDuracionPromedioAnuncios
-- 2
SELECT * FROM MANGO_DB.BI_precio_promedio_anuncios
SELECT * FROM ANDY_Y_SUS_SEMINARAS.VistaPrecioPromedioAnuncios
-- 3
SELECT * FROM MANGO_DB.BI_barrios_mas_elegidos_alquiler
SELECT * FROM ANDY_Y_SUS_SEMINARAS.VistaBarriosMasElegidosAlquilar
-- 4
SELECT * FROM MANGO_DB.BI_porcentaje_incumplimiento_pagos_alquileres
SELECT * FROM ANDY_Y_SUS_SEMINARAS.VistaPorcentajeIncumplimientoPagos
-- 5
SELECT * FROM MANGO_DB.BI_porcentaje_promedio_incremento_valor_alquileres
SELECT * FROM ANDY_Y_SUS_SEMINARAS.VistaPorcentajePromedioIncrementoAlquileres
-- 6
SELECT * FROM MANGO_DB.BI_precio_promedio_m2
SELECT * FROM ANDY_Y_SUS_SEMINARAS.VistaPrecioPromedioM2Ventas
-- 7
SELECT * FROM MANGO_DB.BI_comision_promedio
SELECT * FROM ANDY_Y_SUS_SEMINARAS.VistaValorPromedioComision
-- 8
SELECT * FROM MANGO_DB.BI_porcentaje_operaciones_concretadas
SELECT * FROM ANDY_Y_SUS_SEMINARAS.VistaPorcentajeOperacionesConcretadas
-- 9
SELECT * FROM MANGO_DB.BI_monto_total_de_cierre
SELECT * FROM ANDY_Y_SUS_SEMINARAS.BI_Vista_CierreContratos
*/
