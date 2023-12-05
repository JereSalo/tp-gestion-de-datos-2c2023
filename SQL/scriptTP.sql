/* ------- CREACION DEL SCHEMA ------- */
USE GD2C2023

IF NOT EXISTS (SELECT schema_id FROM sys.schemas WHERE name = 'MANGO_DB')
BEGIN
    -- Crea el schema
    EXEC('CREATE SCHEMA MANGO_DB;'); 
    PRINT 'Esquema "MANGO_DB" creado con exito.';
END
ELSE
BEGIN
    PRINT 'El esquema "MANGO_DB" ya existe en la base de datos.';
END

-- DROP SCHEMA MANGO_DB
-- DROP PROCEDURE MANGO_DB.BorrarTablas
-- EXEC MANGO_DB.ResetearTransaccional;


/* ------- INICIO DE CREACION DE TABLAS ------- */
CREATE TABLE MANGO_DB.tipo_inmueble (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE MANGO_DB.estado (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	estado NVARCHAR(100)
);

CREATE TABLE MANGO_DB.ambientes (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	detalle NVARCHAR(100)
);

CREATE TABLE MANGO_DB.disposicion (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	disposicion NVARCHAR(100)
);

CREATE TABLE MANGO_DB.orientacion (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	orientacion NVARCHAR(100)
);

CREATE TABLE MANGO_DB.barrio (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	nombre NVARCHAR(100)
);

CREATE TABLE MANGO_DB.propietario (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	nombre NVARCHAR(100),
	apellido NVARCHAR(100),
	dni NUMERIC(18,0),
	fecha_registro DATETIME,
	telefono NUMERIC(18,0),
	mail NVARCHAR(255),
	fecha_nac DATETIME
);

CREATE INDEX ix1_pago_propietario ON MANGO_DB.propietario (dni);


CREATE TABLE MANGO_DB.moneda (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	descripcion NVARCHAR(100)
);

CREATE TABLE MANGO_DB.tipo_operacion (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE MANGO_DB.estado_anuncio (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	estado NVARCHAR(100)
);
	
CREATE TABLE MANGO_DB.inquilino (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	nombre NVARCHAR(100),
	apellido NVARCHAR(100),
	dni NVARCHAR(100),
	fecha_registro DATETIME,
	telefono NUMERIC(18,0),
	mail NVARCHAR(100),
	fecha_nac DATETIME
);

CREATE INDEX ix1_inquilino ON MANGO_DB.inquilino (apellido, dni);

CREATE TABLE MANGO_DB.provincia (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY, --Con el identity hago que sea autoincremental, empieza en 1 y suma de a 1
	nombre NVARCHAR(100)
);

CREATE TABLE MANGO_DB.localidad (
    id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100),
    id_provincia NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_provincia) REFERENCES MANGO_DB.provincia(id)
);
					  
CREATE TABLE MANGO_DB.sucursal (
    codigo NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100),
    direccion NVARCHAR(100),
    telefono NVARCHAR(100),
    id_localidad NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_localidad) REFERENCES MANGO_DB.localidad(id)
);

CREATE TABLE MANGO_DB.agente (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	nombre NVARCHAR(100),
	apellido NVARCHAR(100),
	dni NUMERIC(18,0),
	fecha_registro DATETIME,
	telefono NUMERIC(18,0),
	mail NVARCHAR(255),
	fecha_nac DATETIME,
	id_sucursal NUMERIC(18,0)

	FOREIGN KEY (id_sucursal) REFERENCES MANGO_DB.sucursal(codigo)
);

CREATE TABLE MANGO_DB.detalle_alq (
    cod_detalle_alq NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
    cod_alquiler NUMERIC(18,0),
    nro_periodo_fin NUMERIC(18,0),
    precio NUMERIC(18,2),
    nro_periodo_in NUMERIC(18,0)
);

CREATE INDEX ix1_detalle_alq ON MANGO_DB.detalle_alq (cod_alquiler);

CREATE TABLE MANGO_DB.medio_pago (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	descripcion NVARCHAR(100)
);
					  
CREATE TABLE MANGO_DB.comprador (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	nombre NVARCHAR(100),
	apellido NVARCHAR(100),
	dni NUMERIC(18,0),
	fecha_registro DATETIME,
	telefono NUMERIC(18,0),
	mail NVARCHAR(255),
	fecha_nac DATETIME
);

CREATE INDEX ix1_comprador ON MANGO_DB.comprador (fecha_registro);

CREATE TABLE MANGO_DB.caracteristica (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	detalle NVARCHAR(100)
);

CREATE TABLE MANGO_DB.inmueble (
    codigo NUMERIC(18,0) PRIMARY KEY,
    nombre NVARCHAR(100),
    descripcion NVARCHAR(100),
    direccion NVARCHAR(100),
    superficie_total NUMERIC(18,2),
    antiguedad NUMERIC(18,0),
    expensas NUMERIC(18,2),
	id_localidad NUMERIC(18,0) NOT NULL,
    id_barrio NUMERIC(18,0) NOT NULL,
   /* id_caracteristica NUMERIC(18,0) NOT NULL,		-- YA NO ES NECESARIA LA FK YA QUE SE COMUNICA POR ID DEL INMUEBLE CON CARACTERISTICAS_X_INMUEBLE*/
    id_tipo_inmueble NUMERIC(18,0) NOT NULL,
    id_cantidad_ambientes NUMERIC(18,0) NOT NULL,
    id_orientacion NUMERIC(18,0) NOT NULL,
    id_disposicion NUMERIC(18,0) NOT NULL,
    id_estado NUMERIC(18,0) NOT NULL,
    id_propietario NUMERIC(18,0) NOT NULL,

    FOREIGN KEY (id_localidad) REFERENCES MANGO_DB.localidad(id),
    FOREIGN KEY (id_barrio) REFERENCES MANGO_DB.barrio(id),
    FOREIGN KEY (id_tipo_inmueble) REFERENCES MANGO_DB.tipo_inmueble(id),
    FOREIGN KEY (id_cantidad_ambientes) REFERENCES MANGO_DB.ambientes(id),
    FOREIGN KEY (id_orientacion) REFERENCES MANGO_DB.orientacion(id),
    FOREIGN KEY (id_disposicion) REFERENCES MANGO_DB.disposicion(id),
    FOREIGN KEY (id_estado) REFERENCES MANGO_DB.estado(id),
    FOREIGN KEY (id_propietario) REFERENCES MANGO_DB.propietario(id),
);

CREATE INDEX ix1_inmueble ON MANGO_DB.inmueble (direccion, id_barrio, id_propietario, id_cantidad_ambientes);

CREATE TABLE MANGO_DB.caracteristicas_x_inmueble (
	id_inmueble NUMERIC(18,0),
	id_caracteristica NUMERIC(18, 0)

	CONSTRAINT pk_id_inmueble PRIMARY KEY (id_inmueble, id_caracteristica),

	FOREIGN KEY (id_inmueble) REFERENCES MANGO_DB.inmueble(codigo),
	FOREIGN KEY (id_caracteristica) REFERENCES MANGO_DB.caracteristica(id)
);

CREATE TABLE MANGO_DB.anuncio (
    codigo NUMERIC(18,0) PRIMARY KEY,
    id_inmueble NUMERIC(18,0) NOT NULL,
    id_agente NUMERIC(18,0) NOT NULL,
    fecha_publicacion DATETIME,
    precio_publicado NUMERIC(18,2),
    costo_anuncio NUMERIC(18,2),
    fecha_finalizacion DATETIME,
    id_tipo_operacion NUMERIC(18,0) NOT NULL,
    id_moneda NUMERIC(18,0) NOT NULL,
    id_estado NUMERIC(18,0) NOT NULL,
    tipo_periodo NVARCHAR(100),
    
    FOREIGN KEY (id_inmueble) REFERENCES MANGO_DB.inmueble(codigo),
    FOREIGN KEY (id_agente) REFERENCES MANGO_DB.agente (id),
    FOREIGN KEY (id_tipo_operacion) REFERENCES MANGO_DB.tipo_operacion(id),
    FOREIGN KEY (id_moneda) REFERENCES MANGO_DB.moneda(id),
    FOREIGN KEY (id_estado) REFERENCES MANGO_DB.estado(id)
);

CREATE INDEX ix1_anuncio ON MANGO_DB.anuncio (id_inmueble, id_agente, id_tipo_operacion);

CREATE TABLE MANGO_DB.alquiler (
    codigo NUMERIC(18,0) PRIMARY KEY,
    fecha_inicio DATETIME,
    fecha_fin DATETIME,
    cant_periodos NUMERIC(18,0),
    deposito NUMERIC(18,2),
    comision NUMERIC(18,2),
    gastos_averigua NUMERIC(18,2),
    estado NVARCHAR(100),
    id_anuncio NUMERIC(18,0) NOT NULL,
    id_inquilino NUMERIC(18,0) NOT NULL,
    id_sucursal NUMERIC(18,0) NOT NULL,

    FOREIGN KEY (id_anuncio) REFERENCES MANGO_DB.anuncio(codigo),
    FOREIGN KEY (id_inquilino) REFERENCES MANGO_DB.inquilino(id),
	FOREIGN KEY (id_sucursal) REFERENCES MANGO_DB.sucursal(codigo)
);

CREATE INDEX ix1_alquiler ON MANGO_DB.alquiler (estado);

CREATE TABLE MANGO_DB.venta (
    codigo NUMERIC(18,0) PRIMARY KEY,
    fecha DATETIME,
    precio_venta NUMERIC(18,2),
    moneda NVARCHAR(100),
    comision NUMERIC(18,2),
    id_anuncio NUMERIC(18,0) NOT NULL,
    id_comprador NUMERIC(18,0) NOT NULL,
	id_sucursal NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_anuncio) REFERENCES MANGO_DB.anuncio(codigo),
    FOREIGN KEY (id_comprador) REFERENCES MANGO_DB.comprador(id),
	FOREIGN KEY (id_sucursal) REFERENCES MANGO_DB.sucursal(codigo),
);

CREATE INDEX ix1_venta ON MANGO_DB.venta (id_anuncio, id_comprador);

CREATE TABLE MANGO_DB.pago_venta (
    id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
    importe NUMERIC(18,2),
    moneda NVARCHAR(100),
    cotizacion NUMERIC(18,2),
    id_medio_pago NUMERIC(18,0) NOT NULL,
	cod_venta NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_medio_pago) REFERENCES MANGO_DB.medio_pago(id),
	FOREIGN KEY (cod_venta) REFERENCES MANGO_DB.venta(codigo)
);

CREATE INDEX ix1_pago_venta ON MANGO_DB.pago_venta (cod_venta);

CREATE TABLE MANGO_DB.pago_alquiler (
	codigo NUMERIC(18,0) PRIMARY KEY,
    id_alquiler NUMERIC(18,0) NOT NULL,
    fecha_pago DATETIME,
    fecha_vencimiento DATETIME,
    nro_periodo NUMERIC(18,0),
    fec_ini DATETIME,
    fec_fin DATETIME,
    importe NUMERIC(18,0),
    id_medio_pago NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_alquiler) REFERENCES MANGO_DB.alquiler(codigo),
    FOREIGN KEY (id_medio_pago) REFERENCES MANGO_DB.medio_pago(id)
);

CREATE INDEX ix1_pago_alquiler ON MANGO_DB.pago_alquiler (id_alquiler, id_medio_pago, fecha_pago, fecha_vencimiento);

/* ------- FIN DE CREACION DE TABLAS ------- */

/* ------- INICIO MIGRACION DE DATOS ------- */

-- MANGO_DB.tipo_inmueble
INSERT INTO MANGO_DB.tipo_inmueble (tipo)
SELECT DISTINCT m.INMUEBLE_TIPO_INMUEBLE 
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_TIPO_INMUEBLE IS NOT NULL

-- MANGO_DB.estado
INSERT INTO MANGO_DB.estado (estado)
SELECT DISTINCT m.INMUEBLE_ESTADO
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_ESTADO IS NOT NULL

-- MANGO_DB.ambientes
INSERT INTO MANGO_DB.ambientes
SELECT DISTINCT m.INMUEBLE_CANT_AMBIENTES
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_CANT_AMBIENTES IS NOT NULL

-- MANGO_DB.disposicion
INSERT INTO MANGO_DB.disposicion (disposicion)
SELECT DISTINCT m.INMUEBLE_DISPOSICION
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_DISPOSICION IS NOT NULL

-- MANGO_DB.orientacion
INSERT INTO MANGO_DB.orientacion (orientacion)
SELECT DISTINCT m.INMUEBLE_ORIENTACION
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_ORIENTACION IS NOT NULL

/*----- INICIO CREACION FUNCION PARA TOMAR LAS CARACTERISTICAS -----*/
GO
CREATE FUNCTION MANGO_DB.CARACTERISTICAS(@NOMBRE_COLUMNA VARCHAR(50))
RETURNS VARCHAR(20)
AS BEGIN
DECLARE @RETORNO VARCHAR(20)

DECLARE @posicionGuionBajo INT = LEN(@NOMBRE_COLUMNA) - CHARINDEX('_', REVERSE(@NOMBRE_COLUMNA)) + 1

SET @RETORNO = SUBSTRING(@NOMBRE_COLUMNA, @posicionGuionBajo + 1, LEN(@NOMBRE_COLUMNA) - @posicionGuionBajo)

RETURN @RETORNO
END
GO
/*----- FIN CREACION FUNCION PARA TOMAR LAS CARACTERISTICAS -----*/

-- MANGO_DB.caracteristica
INSERT INTO MANGO_DB.caracteristica (detalle)
SELECT DISTINCT MANGO_DB.CARACTERISTICAS('INMUEBLE_CARACTERISTICA_WIFI')
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_CODIGO IS NOT NULL AND m.INMUEBLE_CARACTERISTICA_WIFI = 1
UNION
SELECT DISTINCT MANGO_DB.CARACTERISTICAS('INMUEBLE_CARACTERISTICA_CABLE')
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_CODIGO IS NOT NULL AND m.INMUEBLE_CARACTERISTICA_CABLE = 1
UNION
SELECT DISTINCT MANGO_DB.CARACTERISTICAS('INMUEBLE_CARACTERISTICA_CALEFACCION')
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_CODIGO IS NOT NULL AND m.INMUEBLE_CARACTERISTICA_CALEFACCION = 1
UNION
SELECT DISTINCT MANGO_DB.CARACTERISTICAS('INMUEBLE_CARACTERISTICA_GAS')
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_CODIGO IS NOT NULL AND m.INMUEBLE_CARACTERISTICA_GAS = 1

-- MANGO_DB.barrio
INSERT INTO MANGO_DB.barrio (nombre)
SELECT DISTINCT m.INMUEBLE_BARRIO
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_BARRIO IS NOT NULL

-- MANGO_DB.propietario
INSERT INTO MANGO_DB.propietario (dni, nombre, apellido, fecha_registro, telefono, mail, fecha_nac)
SELECT DISTINCT m.PROPIETARIO_DNI, m.PROPIETARIO_NOMBRE, m.PROPIETARIO_APELLIDO, m.PROPIETARIO_FECHA_REGISTRO, m.PROPIETARIO_TELEFONO, m.PROPIETARIO_MAIL, m.PROPIETARIO_FECHA_NAC
FROM gd_esquema.Maestra m
WHERE m.PROPIETARIO_DNI IS NOT NULL

-- MANGO_DB.moneda
INSERT INTO MANGO_DB.moneda (descripcion)
SELECT DISTINCT m.ANUNCIO_MONEDA
FROM gd_esquema.Maestra m

-- MANGO_DB.tipo_operacion 
INSERT INTO MANGO_DB.tipo_operacion (tipo)
SELECT DISTINCT m.ANUNCIO_TIPO_OPERACION
FROM gd_esquema.Maestra m

-- MANGO_DB.estado_anuncio
INSERT INTO MANGO_DB.estado_anuncio (estado)
SELECT DISTINCT m.ANUNCIO_ESTADO
FROM gd_esquema.Maestra m

-- MANGO_DB.inquilino
INSERT INTO MANGO_DB.inquilino (nombre, apellido, dni, fecha_registro,telefono, mail, fecha_nac)
SELECT DISTINCT m.INQUILINO_NOMBRE, m.INQUILINO_APELLIDO, m.INQUILINO_DNI, m.INQUILINO_FECHA_REGISTRO, m.INQUILINO_TELEFONO, m.INQUILINO_MAIL, m.INQUILINO_FECHA_NAC
FROM gd_esquema.Maestra m
WHERE m.INQUILINO_DNI IS NOT NULL

-- MANGO_DB.provincia
INSERT INTO MANGO_DB.provincia (nombre)
SELECT DISTINCT m.INMUEBLE_PROVINCIA
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_PROVINCIA IS NOT NULL

-- MANGO_DB.localidad 
INSERT INTO MANGO_DB.localidad (nombre, id_provincia)
SELECT DISTINCT m.INMUEBLE_LOCALIDAD as nombre, (SELECT id FROM MANGO_DB.provincia p WHERE p.nombre = m.INMUEBLE_PROVINCIA) as id_provincia
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_LOCALIDAD is not null
UNION
SELECT DISTINCT m.SUCURSAL_LOCALIDAD, (SELECT id FROM MANGO_DB.provincia p WHERE p.nombre = m.SUCURSAL_PROVINCIA)
FROM gd_esquema.Maestra m
WHERE m.SUCURSAL_LOCALIDAD is not null
ORDER BY 1

-- MANGO_DB.sucursal
SET IDENTITY_INSERT MANGO_DB.sucursal ON;
INSERT INTO MANGO_DB.sucursal (codigo, nombre, direccion, telefono, id_localidad)
SELECT DISTINCT m.SUCURSAL_CODIGO, m.SUCURSAL_NOMBRE, m.SUCURSAL_DIRECCION, m.SUCURSAL_TELEFONO
, (SELECT id FROM MANGO_DB.localidad l WHERE m.SUCURSAL_LOCALIDAD = l.nombre AND m.SUCURSAL_PROVINCIA = (SELECT nombre FROM MANGO_DB.provincia p WHERE p.id = l.id_provincia)) as id_localidad
FROM gd_esquema.Maestra m
SET IDENTITY_INSERT MANGO_DB.sucursal OFF;

-- MANGO_DB.agente
INSERT INTO MANGO_DB.agente (nombre, apellido, dni, fecha_registro, telefono, mail, fecha_nac, id_sucursal)
SELECT DISTINCT m.AGENTE_NOMBRE, m.AGENTE_APELLIDO, m.AGENTE_DNI, m.AGENTE_FECHA_REGISTRO, m.AGENTE_TELEFONO, m.AGENTE_MAIL, m.AGENTE_FECHA_NAC, m.SUCURSAL_CODIGO
FROM gd_esquema.Maestra m
WHERE m.SUCURSAL_CODIGO is not null

-- MANGO_DB.detalle_alq
INSERT INTO MANGO_DB.detalle_alq (cod_alquiler, nro_periodo_fin, precio, nro_periodo_in)
SELECT DISTINCT m.ALQUILER_CODIGO, m.DETALLE_ALQ_NRO_PERIODO_FIN, m.DETALLE_ALQ_PRECIO, m.DETALLE_ALQ_NRO_PERIODO_INI
FROM gd_esquema.Maestra m
WHERE m.DETALLE_ALQ_NRO_PERIODO_FIN IS NOT NULL

-- MANGO_DB.medio_pago
INSERT INTO MANGO_DB.medio_pago(descripcion)
SELECT DISTINCT m.PAGO_VENTA_MEDIO_PAGO
FROM gd_esquema.Maestra m
WHERE m.PAGO_VENTA_MEDIO_PAGO IS NOT NULL

-- MANGO_DB.comprador
INSERT INTO MANGO_DB.comprador (nombre, apellido, dni, fecha_registro, telefono, mail, fecha_nac)
SELECT DISTINCT m.COMPRADOR_NOMBRE, m.COMPRADOR_APELLIDO, m.COMPRADOR_DNI, m.COMPRADOR_FECHA_REGISTRO, m.COMPRADOR_TELEFONO, m.COMPRADOR_MAIL, m.COMPRADOR_FECHA_NAC
FROM gd_esquema.Maestra m
WHERE m.COMPRADOR_DNI IS NOT NULL

-- MANGO_DB.inmueble
INSERT INTO MANGO_DB.inmueble (codigo, nombre, descripcion, direccion, superficie_total, antiguedad, expensas, 
							   id_localidad, id_barrio, id_tipo_inmueble, id_cantidad_ambientes,
							   id_orientacion, id_disposicion, id_estado, id_propietario)
SELECT DISTINCT m.INMUEBLE_CODIGO, m.INMUEBLE_NOMBRE, m.INMUEBLE_DESCRIPCION, m.INMUEBLE_DIRECCION, m.INMUEBLE_SUPERFICIETOTAL,
	   m.INMUEBLE_ANTIGUEDAD, INMUEBLE_EXPESAS
	   ,(SELECT l.id
		FROM MANGO_DB.localidad l JOIN MANGO_DB.provincia p ON l.id_provincia = p.id
		WHERE m.INMUEBLE_LOCALIDAD = l.nombre AND m.INMUEBLE_PROVINCIA = p.nombre)
	   ,(SELECT b.id
		FROM MANGO_DB.barrio b
		WHERE m.INMUEBLE_BARRIO = nombre)
	   ,(SELECT id 
	   FROM MANGO_DB.tipo_inmueble
	   WHERE m.INMUEBLE_TIPO_INMUEBLE = tipo)
	   ,(SELECT id FROM MANGO_DB.ambientes
	   WHERE m.INMUEBLE_CANT_AMBIENTES = detalle),
	   (SELECT id FROM MANGO_DB.orientacion
	   WHERE m.INMUEBLE_ORIENTACION = orientacion)
	   ,(SELECT id FROM MANGO_DB.disposicion
	   WHERE m.INMUEBLE_DISPOSICION = disposicion)
	   ,(SELECT id FROM MANGO_DB.estado
	   WHERE m.INMUEBLE_ESTADO = estado)
	   ,(SELECT id FROM MANGO_DB.propietario P
	   WHERE m.PROPIETARIO_DNI = P.dni)
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_CODIGO IS NOT NULL

-- MANGO_DB.anuncio
INSERT INTO MANGO_DB.anuncio (codigo, id_inmueble, id_agente, fecha_publicacion, precio_publicado,
							  costo_anuncio, fecha_finalizacion, id_tipo_operacion, id_moneda, id_estado, 
							  tipo_periodo)
SELECT DISTINCT m.ANUNCIO_CODIGO, 
	   (SELECT DISTINCT codigo FROM MANGO_DB.inmueble
	   WHERE m.INMUEBLE_CODIGO = codigo) as cod_inmueble,
	   (SELECT id FROM MANGO_DB.agente 
	   WHERE m.AGENTE_DNI = dni) as agente_dni,
	   m.ANUNCIO_FECHA_PUBLICACION, m.ANUNCIO_PRECIO_PUBLICADO, m.ANUNCIO_COSTO_ANUNCIO,
	   m.ANUNCIO_FECHA_FINALIZACION, 
	   (SELECT id FROM MANGO_DB.tipo_operacion
	   WHERE m.ANUNCIO_TIPO_OPERACION = tipo) as tipo_operacion,
	   (SELECT id FROM MANGO_DB.moneda
	   WHERE m.ANUNCIO_MONEDA = descripcion) as moneda,
	   (SELECT id FROM MANGO_DB.estado_anuncio
	   WHERE m.ANUNCIO_ESTADO = estado) as estado_anuncio,	   
	   m.ANUNCIO_TIPO_PERIODO
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_CODIGO is not null

-- MANGO_DB.caracteristicas_x_inmueble
INSERT INTO MANGO_DB.caracteristicas_x_inmueble(id_inmueble, id_caracteristica)
SELECT i.codigo, c.id
FROM gd_esquema.Maestra m JOIN MANGO_DB.caracteristica c ON c.detalle = 'WIFI'
						  JOIN MANGO_DB.inmueble i ON i.codigo = m.INMUEBLE_CODIGO
WHERE m.INMUEBLE_CARACTERISTICA_WIFI = 1 AND m.INMUEBLE_CODIGO is not null
GROUP BY c.id, i.codigo
UNION
SELECT i.codigo, c.id
FROM gd_esquema.Maestra m JOIN MANGO_DB.caracteristica c ON c.detalle = 'CABLE'
						  JOIN MANGO_DB.inmueble i ON i.codigo = m.INMUEBLE_CODIGO
WHERE m.INMUEBLE_CARACTERISTICA_CABLE = 1 AND m.INMUEBLE_CODIGO is not null
GROUP BY c.id, i.codigo
UNION
SELECT i.codigo, c.id
FROM gd_esquema.Maestra m JOIN MANGO_DB.caracteristica c ON c.detalle = 'CALEFACCION'
						  JOIN MANGO_DB.inmueble i ON i.codigo = m.INMUEBLE_CODIGO
WHERE m.INMUEBLE_CARACTERISTICA_CALEFACCION = 1 AND m.INMUEBLE_CODIGO is not null
GROUP BY c.id, i.codigo
UNION
SELECT i.codigo, c.id
FROM gd_esquema.Maestra m JOIN MANGO_DB.caracteristica c ON c.detalle = 'GAS'
						  JOIN MANGO_DB.inmueble i ON i.codigo = m.INMUEBLE_CODIGO
WHERE m.INMUEBLE_CARACTERISTICA_GAS = 1 AND m.INMUEBLE_CODIGO is not null
GROUP BY c.id, i.codigo

-- MANGO_DB.alquiler
INSERT INTO MANGO_DB.alquiler (codigo, fecha_inicio, fecha_fin, cant_periodos, deposito, comision, gastos_averigua,
							   estado, id_anuncio, id_inquilino, id_sucursal)
SELECT DISTINCT m.ALQUILER_CODIGO, m.ALQUILER_FECHA_INICIO, m.ALQUILER_FECHA_FIN, m.ALQUILER_CANT_PERIODOS,
	   m.ALQUILER_DEPOSITO, m.ALQUILER_COMISION, m.ALQUILER_GASTOS_AVERIGUA, m.ALQUILER_ESTADO
	   ,(SELECT codigo FROM MANGO_DB.anuncio WHERE m.ANUNCIO_CODIGO = codigo)
	   ,(SELECT id FROM MANGO_DB.inquilino WHERE m.INQUILINO_DNI = dni AND m.INQUILINO_TELEFONO = telefono), 
	   m.SUCURSAL_CODIGO
FROM gd_esquema.Maestra m
WHERE m.ALQUILER_CODIGO IS NOT NULL

-- MANGO_DB.venta
-- FALTA id_pago_venta
INSERT INTO MANGO_DB.venta (codigo, fecha, precio_venta, moneda, comision, id_anuncio, id_comprador, id_sucursal)
SELECT DISTINCT m.VENTA_CODIGO, m.VENTA_FECHA, m.VENTA_PRECIO_VENTA, m.VENTA_MONEDA, m.VENTA_COMISION,
	   (SELECT codigo FROM MANGO_DB.anuncio WHERE m.ANUNCIO_CODIGO = codigo)
	   ,(SELECT id FROM MANGO_DB.comprador WHERE m.COMPRADOR_DNI = dni AND m.COMPRADOR_TELEFONO = telefono),
	   m.SUCURSAL_CODIGO
FROM gd_esquema.Maestra m
WHERE m.VENTA_CODIGO IS NOT NULL

-- MANGO_DB.pago_venta 
INSERT INTO MANGO_DB.pago_venta (importe, moneda, cotizacion, id_medio_pago, cod_venta)
SELECT DISTINCT m.PAGO_VENTA_IMPORTE, (SELECT DISTINCT mo.id FROM MANGO_DB.moneda mo WHERE mo.descripcion = m.PAGO_VENTA_MONEDA) as id_moneda, m.PAGO_VENTA_COTIZACION, 
	(SELECT DISTINCT mp.id 
	FROM MANGO_DB.medio_pago mp 
	WHERE mp.descripcion = m.PAGO_VENTA_MEDIO_PAGO) AS id_medio_pago
	, m.VENTA_CODIGO
FROM gd_esquema.Maestra m
WHERE m.PAGO_VENTA_IMPORTE IS NOT NULL

-- MANGO_DB.pago_alquiler
INSERT INTO MANGO_DB.pago_alquiler (codigo, id_alquiler, fecha_pago, fecha_vencimiento, nro_periodo,
									fec_ini, fec_fin, importe, id_medio_pago)
SELECT m.PAGO_ALQUILER_CODIGO,
	   (SELECT codigo FROM MANGO_DB.alquiler WHERE codigo = ALQUILER_CODIGO),
	   m.PAGO_ALQUILER_FECHA, m.PAGO_ALQUILER_FECHA_VENCIMIENTO, m.PAGO_ALQUILER_NRO_PERIODO,
	   m.PAGO_ALQUILER_FEC_INI, m.PAGO_ALQUILER_FEC_FIN, m.PAGO_ALQUILER_IMPORTE,
	   (SELECT id FROM MANGO_DB.medio_pago
	   WHERE descripcion = m.PAGO_ALQUILER_MEDIO_PAGO)
FROM gd_esquema.Maestra m
WHERE m.PAGO_ALQUILER_CODIGO IS NOT NULL
/* ------- FIN MIGRACION DE DATOS ------- */
