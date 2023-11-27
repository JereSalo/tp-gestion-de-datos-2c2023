/*
Script Bussiness Inteligence
*/

USE GD2C2023
GO

/* ------- DROPEO DE LAS FUNCIONES SI EXISTEN ------- */
EXEC MANGO_DB.BorrarFuncionesBI;
GO

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
			WHEN @EdadActual >= 25 AND @EdadActual < 55 THEN '25-35'
			WHEN @EdadActual >= 55 AND @EdadActual < 75 THEN '35-50'
			WHEN @EdadActual >= 100 THEN '>50'
		END

	RETURN @rango
END
GO

/* ------- DROPEO DE HECHOS Y DIMENSIONES SI EXISTEN ------- */

EXEC MANGO_DB.BorrarTablasBI; -- Esto después lo sacamos, es para que podamos ejecutarlo varias veces sin problemas...


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

-- POR AHORA PLANTEAMOS CREAR 3 HECHOS, DE ANUNCIOS, DE VENTAS (CON PAGO DE VENTAS) 
-- Y DE ALQUILERES (CON CADA PAGO DE ALQUILER)

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
	
	sumatoria_precio NUMERIC(18,2) NULL,
	sumatoria_duracion NUMERIC(18,0) NULL,
	cantidad_operaciones_concretadas NUMERIC(18,0) NULL,
	sumatoria_monto_por_cierre NUMERIC(18,2) NULL,
	cantidad_anuncios_totales NUMERIC(18,2) NULL

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

CREATE TABLE MANGO_DB.BI_Hecho_Venta(
	id_tipo_inmueble NUMERIC(18,0),
	id_ubicacion NUMERIC(18,0),
	id_tiempo NUMERIC(18,0),
	id_sucursal NUMERIC(18,0),
	id_rango_m2	NUMERIC(18,0),

	sumatoria_m2_inmueble NUMERIC(18,2) NULL,
	sumatoria_precio_venta NUMERIC(18,2) NULL,
	sumatoria_comisiones NUMERIC(18,2) NULL,
	cantidad_ventas_concretadas NUMERIC(18,2) NULL

	FOREIGN KEY (id_tipo_inmueble) REFERENCES MANGO_DB.BI_Tipo_Inmueble(id),
    FOREIGN KEY (id_ubicacion) REFERENCES MANGO_DB.BI_Ubicacion(id),
	FOREIGN KEY (id_tiempo) REFERENCES MANGO_DB.BI_Tiempo(id),
	FOREIGN KEY (id_sucursal) REFERENCES MANGO_DB.BI_Sucursal(codigo),
    FOREIGN KEY (id_rango_m2) REFERENCES MANGO_DB.BI_Rango_m2(id),

	PRIMARY KEY (id_tipo_inmueble, id_ubicacion, id_tiempo, id_sucursal, id_rango_m2)
);

CREATE TABLE MANGO_DB.BI_Hecho_Alquiler(
	id_rango_etario_inquilino NUMERIC(18,0),
	id_tiempo NUMERIC(18,0),
	id_sucursal NUMERIC(18,0),

	cantidad_alquileres_concretados INT NULL,
	sumatoria_comisiones NUMERIC(18,2) NULL

	FOREIGN KEY (id_rango_etario_inquilino) REFERENCES MANGO_DB.BI_Rango_etario(id),
	FOREIGN KEY (id_tiempo) REFERENCES MANGO_DB.BI_Tiempo(id),
	FOREIGN KEY (id_sucursal) REFERENCES MANGO_DB.BI_Tiempo(id),

	PRIMARY KEY (id_rango_etario_inquilino, id_tiempo, id_sucursal)
);

CREATE TABLE MANGO_DB.BI_Hecho_Pago_Alquiler(
	id_tiempo NUMERIC(18,0) PRIMARY KEY,
	
	total_porcentaje_aumentos NUMERIC(18,0) NULL,
	cantidad_pagos_en_termino NUMERIC(18,0) NULL,
	cantidad_porcentajes_aumentos NUMERIC(18,2) NULL,
	cantidad_pagos_incumplidos NUMERIC(18,2) NULL,

	FOREIGN KEY (id_tiempo) REFERENCES MANGO_DB.BI_Tiempo(id)
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
									   id_rango_m2, id_tipo_moneda, id_rango_etario_agente, sumatoria_duracion, 
									   sumatoria_precio, id_sucursal)
SELECT a.id_tipo_operacion, u.id, amb.id, biti.id, tipoInmu.id, rangoM2.id, tipoMon.id, rangEtAg.id,
	   SUM(CAST(DATEDIFF(DAY, a.fecha_publicacion, a.fecha_finalizacion) AS NUMERIC(18,0))) AS sumatoriaDias,
	   SUM(a.precio_publicado) AS precioPublicado,
	   bis.codigo
FROM MANGO_DB.anuncio a LEFT JOIN MANGO_DB.tipo_operacion tiO ON (a.id_tipo_operacion = tiO.id)
						LEFT JOIN MANGO_DB.BI_Tipo_Operacion tipoOp ON (tipoOp.tipo = tiO.tipo)
						LEFT JOIN MANGO_DB.inmueble i ON (a.id_inmueble = i.codigo)
						LEFT JOIN MANGO_DB.barrio bar ON (bar.id = i.id_barrio)
						LEFT JOIN MANGO_DB.localidad loc ON (loc.id = i.id_localidad)
						LEFT JOIN MANGO_DB.provincia prov ON (prov.id = loc.id_provincia)
						LEFT JOIN MANGO_DB.BI_Ubicacion u ON (u.barrio = bar.nombre AND u.localidad = loc.nombre AND u.provincia = prov.nombre)
						LEFT JOIN MANGO_DB.ambientes ambi ON (ambi.id = i.id_cantidad_ambientes)
						LEFT JOIN MANGO_DB.BI_Ambientes amb ON (amb.detalle = ambi.detalle)
						LEFT JOIN MANGO_DB.BI_tiempo biti ON (biti.anio = YEAR(a.fecha_publicacion) AND
															biti.mes = MONTH(a.fecha_publicacion) AND
															biti.cuatrimestre = MANGO_DB.getCuatrimestre(a.fecha_publicacion))
						LEFT JOIN MANGO_DB.tipo_inmueble tipI ON (tipI.id = i.id_tipo_inmueble)
						LEFT JOIN MANGO_DB.BI_Tipo_Inmueble tipoInmu ON (tipoInmu.tipo = tipI.tipo)
						LEFT JOIN MANGO_DB.BI_Rango_m2 rangoM2 ON (rangoM2.rango = MANGO_DB.getRangoM2(i.superficie_total))
						LEFT JOIN MANGO_DB.moneda mon ON (mon.id = a.id_moneda)
						LEFT JOIN MANGO_DB.BI_Tipo_Moneda tipoMon ON (tipoMon.descripcion = mon.descripcion)
						LEFT JOIN MANGO_DB.agente agente ON (agente.id = a.id_agente)
						LEFT JOIN MANGO_DB.BI_Rango_etario rangEtAg ON (rangEtAg.rango = MANGO_DB.getRangoEtario(agente.fecha_nac))
						LEFT JOIN MANGO_DB.sucursal s ON (s.codigo = agente.id_sucursal)
						LEFT JOIN MANGO_DB.BI_Sucursal bis ON (bis.codigo = s.codigo)

GROUP BY a.id_tipo_operacion, u.id, amb.id, biti.id, tipoInmu.id, rangoM2.id, tipoMon.id, rangEtAg.id, bis.codigo;

UPDATE MANGO_DB.BI_Hecho_Anuncio
SET cantidad_operaciones_concretadas = (SELECT COUNT(a.fecha_finalizacion)
										FROM MANGO_DB.anuncio a
										WHERE a.fecha_finalizacion IS NOT NULL
										)
						
UPDATE MANGO_DB.BI_Hecho_Anuncio
SET sumatoria_monto_por_cierre = (SELECT SUM(a.precio_publicado)
									FROM MANGO_DB.anuncio a
									WHERE a.fecha_finalizacion IS NOT NULL
									)


-- BI_Hecho_Venta
-- CHEQUEAR cantidad_ventas_concretadas SI ES COUNT(*)
INSERT INTO MANGO_DB.BI_Hecho_Venta (id_tipo_inmueble, id_ubicacion, id_tiempo, id_sucursal, id_rango_m2,
									 sumatoria_m2_inmueble, sumatoria_precio_venta, sumatoria_comisiones,
									 cantidad_ventas_concretadas)
SELECT DISTINCT bti.id, biubi.id, biti.id, bis.id, birg.id, SUM(inm.superficie_total), 
		SUM(v.precio_venta), SUM(v.comision), COUNT(*)
FROM MANGO_DB.venta v LEFT JOIN MANGO_DB.anuncio a ON (v.id_anuncio = a.codigo)
						LEFT JOIN MANGO_DB.inmueble inm ON (a.id_inmueble = inm.codigo)
						LEFT JOIN MANGO_DB.tipo_Inmueble ti ON (inm.id_tipo_inmueble = ti.id)
						LEFT JOIN MANGO_DB.BI_Tipo_Inmueble bti ON (bti.tipo = ti.tipo)
						LEFT JOIN MANGO_DB.localidad l ON (l.id = inm.id_localidad)
						LEFT JOIN MANGO_DB.BI_Ubicacion biubi ON (biubi.localidad = l.nombre)
						LEFT JOIN MANGO_DB.BI_tiempo biti ON (biti.anio = YEAR(v.fecha) AND
															biti.mes = MONTH(v.fecha) AND
															biti.cuatrimestre = MANGO_DB.getCuatrimestre(v.fecha))
						LEFT JOIN MANGO_DB.sucursal suc ON (suc.id_localidad = l.id)
						LEFT JOIN MANGO_DB.BI_Sucursal bis ON (bis.codigo = suc.codigo)
						LEFT JOIN MANGO_DB.BI_Rango_m2 birg ON (birg.rango = MANGO_DB.getRangoM2(inm.superficie_total))
GROUP BY bti.id, biubi.id, biti.id, bis.id, inm.superficie_total


-- BI_Hecho_Alquiler 
INSERT INTO MANGO_DB.BI_Hecho_Alquiler(id_rango_etario_inquilino, id_tiempo, id_sucursal,
										cantidad_alquileres_concretados, sumatoria_comisiones)
SELECT birg.id, biti.id, bis.id, COUNT(*), SUM(alq.comision)
FROM MANGO_DB.alquiler alq LEFT JOIN MANGO_DB.inquilino inq ON (alq.id_inquilino = inq.id)
						LEFT JOIN MANGO_DB.BI_Rango_Etario birg ON (birg.rango = MANGO_DB.getRangoEtario(inq.fecha_nac))
						LEFT JOIN MANGO_DB.BI_Tiempo biti ON (biti.anio = YEAR(alq.fecha_inicio) AND
															biti.mes = MONTH(alq.fecha_inicio) AND
															biti.cuatrimestre = MANGO_DB.getCuatrimestre(alq.fecha_inicio))
						LEFT JOIN MANGO_DB.BI_Sucursal bis ON (bis.codigo = alq.id_sucursal) -- Aca el sql putea, alq no tiene id_sucursal
GROUP BY birg.id, biti.id, bis.id, biti.cuatrimestre, biti.anio 

-- BI_Hecho_Pago_Alquiler
INSERT INTO MANGO_DB.BI_Hecho_Pago_Alquiler(id_tiempo, total_porcentaje_aumentos, cantidad_pagos_en_termino,
											cantidad_porcentajes_aumentos, cantidad_pagos_incumplidos)
SELECT biti.id, SUM((pag_al.importe - pag_al_ant.importe)/pag_al_ant.importe*100) AS total_porcentaje_aumentos,
		COUNT(*) AS cantidad_porcentajes_aumentos,
		COUNT(pag_al_ant.id) AS cantidad_porcentajes_aumentos,
		SUM(CASE WHEN (pag_al.fecha_pago >= pag_al.fecha_vencimiento) then 1 else 0 END) AS cantidad_pagos_incumplidos
FROM MANGO_DB.pago_alquiler pag_al JOIN MANGO_DB.BI_Tiempo biti ON (biti.anio = YEAR(pag_al.fec_ini) AND
														biti.mes = MONTH(pag_al.fec_ini) AND
														biti.cuatrimestre = MANGO_DB.getCuatrimestre(pag_al.fec_ini))
								   JOIN MANGO_DB.alquiler ea ON pag_al.id_alquiler = ea.id
								   LEFT JOIN MANGO_DB.pago_alquiler pag_al_ant ON pag_al_ant.id_alquiler = pag_al.id_alquiler AND
								   												  YEAR(pag_al_ant.fecha_pago) = YEAR(pag_al.fecha_pago) AND
																				  MONTH(pag_al_ant.fecha_pago) = MONTH(pag_al.fecha_pago) AND
																				  pag_al_ant.importe < pag_al.importe AND
																				  GETDATE() < pag_al.fecha_fin
WHERE pag_al.fecha_pago IS NOT NULL								   
GROUP BY biti.id		

/* ------- CREACION DE LAS VISTAS EN FUNCION DE LAS DIMENSIONES ------- */

-- VISTA 1
-- TODO ACOMODAR LOS NOMBRES
GO
CREATE VIEW MANGO_DB.duracion_promedio_anuncios AS
SELECT 
	bi_ha.sumatoria_duracion / COUNT(*) AS 'Duracion promedio',
	bi_to.tipo AS 'Tipo operacion',
	bi_ubi.barrio,
	bi_tiempo.cuatrimestre,
	bi_tiempo.anio,
	bi_amb.detalle AS 'Ambientes'
FROM BI_Hecho_Anuncio bi_ha
	LEFT JOIN MANGO_DB.BI_Tipo_Operacion bi_to ON bi_to.id = bi_ha.id_tipo_operacion
	LEFT JOIN MANGO_DB.BI_Ubicacion bi_ubi ON bi_ubi.id = bi_ha.id_ubicacion
	LEFT JOIN MANGO_DB.BI_Tiempo bi_t ON bi_t.id = bi_ha.id_tiempo
	LEFT JOIN MANGO_DB.BI_Ambientes bi_amb ON bi_amb.id = bi_ha.id_ambientes
GROUP BY bi_to.tipo, bi_ubi.barrio, bi_tiempo.cuatrimestre, bi_tiempo.anio, bi_tiempo_cuatrimestre, bi_amb.detalle
ORDER BY bi_to.tipo, bi_ubi.barrio, bi_tiempo.cuatrimestre, bi_tiempo.anio, bi_tiempo_cuatrimestre
GO

-- VISTA 2
-- TODO ACOMODAR LOS NOMBRES
GO
CREATE VIEW MANGO_DB.precio_promedio_anuncios AS
SELECT 
	sumatoria_precio / COUNT(*) AS 'Precio promedio',
	bi_to.tipo AS 'Tipo operacion',
	bi_ti.tipo AS 'Tipo inmueble',
	bi_rango.rango AS 'Rango M2',
	bi_tiempo.cuatrimestre,
	bi_tiempo.anio
FROM BI_Hecho_Anuncio bi_ha
	LEFT JOIN MANGO_DB.BI_Tipo_Operacion bi_to ON bi_to.id = bi_ha.id_tipo_operacion
	LEFT JOIN MANGO_DB.BI_Tipo_Inmueble bi_ti ON bi_ti.id = bi_ha.id_tipo_inmueble
	LEFT JOIN MANGO_DB.BI_Tiempo bi_time ON bi_time.id = bi_ha.id_tiempo
	LEFT JOIN MANGO_DB.BI_Rango_m2 bi_rango ON bi_rango.id = bi_ha.id_rango_m2
GROUP BY sumatoria_precio, COUNT(*), bi_to.tipo, bi_ti.tipo, bi_rango.rango, bi_tiempo.cuatrimestre, bi_tiempo.anio
ORDER BY bi_to.tipo, bi_ubi.barrio, bi_ha.id_tipo_inmueble, bi_tiempo.cuatrimestre, bi_tiempo.anio, bi_tiempo_cuatrimestre
GO

-- VISTA 3
-- TODO ACOMODAR LOS NOMBRES-- PROBAR PORQUE NO SE SI FUNCIONA COMO CREO!!
GO
CREATE VIEW MANGO_DB.barrios_mas_elegidos_alquiler AS
SELECT TOP 5
	bi_ubi.barrio AS 'Barrio',
	bi_re.rango AS 'Rango etario',
	bi_ti.cuatrimestre AS 'Cuatrimestre',
	bi_ti.anio AS 'Anio'
FROM BI_Hecho_Alquiler bi_ha
	LEFT JOIN BI_Ubicacion bi_ubi ON bi_ubi.id = bi_ha.id_ubicacion
	LEFT JOIN MANGO_DB.BI_Rango_Etario bi_re ON bi_re.id = bi_ha.id_rango_etario
	LEFT JOIN MANGO_DB.BI_Tiempo bi_ti ON bi_ti.id = bi_ha.id_tiempo
GROUP BY biMANGO_DB._ubi.barrio, bi_re.rango, bi_ti.cuatrimestre, bi_ti.cuatrimestre, bi_ti.anio
ORDER BY bi_ha.cantidad_alquileres_concretados
GO

-- VISTA 4
-- TODO ACOMODAR LOS NOMBRES
GO
CREATE VIEW MANGO_DB.porcentaje_incumplimiento_pagos_alquileres AS
SELECT 
	((bi_hpa.cantidad_pagos_totales - bi_hpa.cantidad_pagos_en_termino) * 100) / bi_hpa.cantidad_pagos_totales AS 'Porcentaje incumplimiento',
	bi_tie.cuatrimestre AS 'Cuatrimestre',
	bi_tie.anio AS 'Anio'
FROM BI_Hecho_Pago_Alquiler bi_hpa
	LEFT JOIN BI_Tiempo bi_tie ON bi_tie.id = bi_hpa.idTiempo
GO

-- VISTA 5
GO
CREATE VIEW MANGO_DB.porcentaje_promedio_incremento_valor_alquileres AS
SELECT t.mes, t.anio, sum(bi_pag_al.total_porcentaje_aumentos) / sum(bi_pag_al.cantidad_porcentajes_aumentos) AS porcentaje_prom_incremento, sum(bi_pag_al.total_porcentaje_aumentos) AS total_porcentaje_aumentos, sum(bi_pag_al.cantidad_porcentajes_aumentos) AS cantidad_porcentajes_aumentos
FROM MANGO_DB.BI_Hecho_Pago_Alquiler bi_pag_al
    JOIN MANGO_DB.BI_Tiempo t ON bi_pag_al.id_tiempo = t.id
WHERE bi_pag_al.cantPorcentajesAumento != 0
GROUP BY t.mes, t.anio
GO

-- VISTA 6
-- TODO ACOMODAR LOS NOMBRES
GO
CREATE VIEW MANGO_DB.precio_promedio_m2 AS
SELECT
	bi_hv.sumatoriaMetrosCuadradosInmueble / bi_hv.cantidadInmueblesPorM2 AS 'Promedio',
	bi_ti.tipo AS 'Tipo de inmueble',
	bi_tie.cuatrimestre AS 'Cuatrimestre',
	bi_tie.anio AS 'Anio'
FROM MANGO_DB.BI_Hecho_Venta bi_hv
	LEFT JOIN MANGO_DB.BI_Rango_m2 bi_rango ON bi_rango.id = bi_hv.idRangom2
	LEFT JOIN MANGO_DB.BI_Tipo_Inmueble bi_ti ON bi_ti.id = bi_hv.idTipoInmueble
	LEFT JOIN MANGO_DB.BI_Tiempo bi_tie ON bi_tie.id = bi_hv.idTiempo
GROUP BY bi_ti.tipo ,bi_tie.cuatrimestre, bi_tie.anio
GO

-- VISTA 7
-- TODO ACOMODAR LOS NOMBRES
-- SI NO FUNCIONA, CAMBIAR LOS NOMBRES DE LAS COLUMNAS EN COMUN Y NO HACERLAS STRING SINO NOMBRE DIRECTO
GO
CREATE VIEW MANGO_DB.comision_promedio AS
SELECT 'Comision promedio', 'Tipo operacion', 'Sucursal', 'Cuatrimestre', 'Anio'
FROM (
	SELECT 
		bi_ha.sumatoria_comisiones / bi_ha.cantidad_alquileres_concretados AS 'Comision promedio',
		'Alquiler' AS 'Tipo operacion',
		bi_s.nombre AS 'Sucursal',
		bi_tie.cuatrimestre AS 'Cuatrimestre',
		bi_tie.anio AS 'Anio'
	FROM BI_Hecho_Alquiler bi_ha
		LEFT JOIN BI_Sucursal bi_s ON bi_s.id = bi_ha.id_sucursal
		LEFT JOIN BI_Tiempo bi_tie ON bi_tie.id = bi_ha.id_tiempo
	GROUP BY bi_ha.sumatoria_comisiones, bi_ha.cantidad_alquileres_concretados, bi_s.nombre, bi_tie.cuatrimestre, bi_tie.anio
	) AS Tabla_alquileres
UNION
SELECT 'Comision promedio', 'Tipo operacion', 'Sucursal', 'Cuatrimestre', 'Anio'
FROM (
	SELECT
		bi_hv.sumatoria_comisiones / bi_hv.cantidad_ventas_concretadas AS 'Comision promedio',
		'Venta' AS 'Tipo operacion',
		bi_s.nombre AS 'Sucursal',
		bi_tie.cuatrimestre AS 'Cuatrimestre',
		bi_tie.anio AS 'Anio'
	FROM BI_Hecho_Venta bi_hv
		LEFT JOIN BI_Sucursal bi_s ON bi_s.id = bi_hv.id_sucursal
		LEFT JOIN BI_Tiempo bi_tie ON bi_tie.id = bi_hv.id_tiempo
	GROUP BY bi_ha.sumatoria_comisiones, bi_ha.cantidad_ventas_concretadas, bi_s.nombre, bi_tie.cuatrimestre, bi_tie.anio
	) AS Tabla_ventas
GO

-- VISTA 8
GO
CREATE VIEW MANGO_DB.porcentaje_operaciones_concretadas AS
SELECT 
	(bi_hanc.cantidad_operaciones_concretadas * 100) / bi_hanc.cantidad_anuncios_totales AS 'Porcentaje', 
	bi_to.tipo AS 'Tipo operacion', 
	bi_s.nombre AS 'Sucursal', 
	bi_rangoE.rango AS 'Rango etario', 
	bi_tie.anio AS 'Anio'
FROM BI_Hecho_Anuncio bi_hanc
	LEFT JOIN BI_Tipo_Operacion bi_to ON bi_to.id = bi_hanc.id_tipo_operacion
	LEFT JOIN BI_Sucursal bi_s ON bi_s.id = bi_hanc.id_sucursal
	LEFT JOIN BI_Rango_etario bi_rangoE ON bi_rangoE.id = bi_hanc.id_rango_etario_agente
	LEFT JOIN BI_Tiempo bi_tie ON bi_tie.id = bi_hanc.id_tiempo
GROUP BY bi_tie.anio, bi_rangoE.rango, bi_s.nombre, bi_to.tipo, bi_hanc.cantidad_anuncios_totales
GO
-- Agregar cantidad_anuncios_totales y id_sucursal EN BI_Hecho_Anuncio

-- VISTA 9
-- TODO ACOMODAR LOS NOMBRES
GO
CREATE VIEW MANGO_DB.monto_total_de_cierre AS
SELECT 
	bi_hanc.sumatoria_monto_por_cierre AS 'Monto total',
	bi_to.tipo AS 'Tipo operacion',
	bi_tie.cuatrimestre AS 'Cuatrimestre',
	bi_suc.nombre AS 'Sucursal',
	bi_moneda.descripcion AS 'Tipo de moneda'
FROM BI_Hecho_Anuncio bi_hanc
	LEFT JOIN BI_Tipo_Operacion bi_to ON bi_to.id = bi_hanc.id_tipo_operacion
	LEFT JOIN BI_tiempo bi_tie ON bi_tie.id = bi_hanc.id_tiempo
	LEFT JOIN BI_Sucursal bi_suc ON bi_suc.id = bi_hanc.id_sucursal
	LEFT JOIN BI_Tipo_Moneda bi_moneda ON bi_moneda.id = bi_hanc.id_tipo_moneda
GROUP BY bi_hanc.sumatoria_monto_por_cierre, bi_to.tipo, bi_tie.cuatrimestre, bi_suc.nombre, bi_moneda.descripcion
GO

-- Borrado de las funciones: Solo para poder volver a ejecutar el mismo .sql sin tocar nada

DROP FUNCTION MANGO_DB.getCuatrimestre
DROP FUNCTION MANGO_DB.getRangoM2
DROP FUNCTION MANGO_DB.getRangoEtario

