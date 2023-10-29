/* ------- CREACION DEL SCHEMA ------- */
USE GD2C2023

IF NOT EXISTS (SELECT schema_id FROM sys.schemas WHERE name = 'MANGO_DB')
BEGIN
    -- Crea el schema
	DROP SCHEMA MANGO_DB
    EXEC('CREATE SCHEMA MANGO_DB;'); 
    PRINT 'Esquema "MANGO_DB" creado con �xito.';
END
ELSE
BEGIN
    PRINT 'El esquema "MANGO_DB" ya existe en la base de datos.';
END

EXEC MANGO_DB.BorrarTablas;


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

CREATE TABLE MANGO_DB.caracteristicas_inmueble (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	wifi NUMERIC(18,0),
	cable NUMERIC(18,0),
	calefaccion NUMERIC(18,0),
	gas NUMERIC(18,0)
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

CREATE TABLE MANGO_DB.moneda (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	descripcion NVARCHAR(100)
);

CREATE TABLE MANGO_DB.tipo_operacion (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE MANGO_DB.agente (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	nombre NVARCHAR(100),
	apellido NVARCHAR(100),
	dni NUMERIC(18,0),
	fecha_registro DATETIME,
	telefono NUMERIC(18,0),
	mail NVARCHAR(255),
	fecha_nac DATETIME
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

CREATE TABLE MANGO_DB.provincia (
	id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY, --Con el identiti hago que sea autoincremental, empieza en 1 y suma de a 1
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

CREATE TABLE MANGO_DB.detalle_alq (
    cod_detalle_alq NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
    cod_alquiler NUMERIC(18,0),
    nro_periodo_fin NUMERIC(18,0),
    precio NUMERIC(18,2),
    nro_periodo_in NUMERIC(18,0)
);

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

CREATE TABLE MANGO_DB.pago_venta (
    id NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
    importe NUMERIC(18,2),
    moneda NVARCHAR(100),
    cotizacion NUMERIC(18,2),
    id_medio_pago NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_medio_pago) REFERENCES MANGO_DB.medio_pago(id)
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
    id_caracteristicas NUMERIC(18,0) NOT NULL,
    id_tipo_inmueble NUMERIC(18,0) NOT NULL,
    id_cantidad_ambientes NUMERIC(18,0) NOT NULL,
    id_orientacion NUMERIC(18,0) NOT NULL,
    id_disposicion NUMERIC(18,0) NOT NULL,
    id_estado NUMERIC(18,0) NOT NULL,
    id_propietario NUMERIC(18,0) NOT NULL,

    FOREIGN KEY (id_localidad) REFERENCES MANGO_DB.localidad(id),
    FOREIGN KEY (id_barrio) REFERENCES MANGO_DB.barrio(id),
    FOREIGN KEY (id_caracteristicas) REFERENCES MANGO_DB.caracteristicas_inmueble(id),
    FOREIGN KEY (id_tipo_inmueble) REFERENCES MANGO_DB.tipo_inmueble(id),
    FOREIGN KEY (id_cantidad_ambientes) REFERENCES MANGO_DB.ambientes(id),
    FOREIGN KEY (id_orientacion) REFERENCES MANGO_DB.orientacion(id),
    FOREIGN KEY (id_disposicion) REFERENCES MANGO_DB.disposicion(id),
    FOREIGN KEY (id_estado) REFERENCES MANGO_DB.estado(id),
    FOREIGN KEY (id_propietario) REFERENCES MANGO_DB.propietario(id)
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
    duracion NUMERIC(18,0),
    
    FOREIGN KEY (id_anuncio) REFERENCES MANGO_DB.anuncio(codigo),
    FOREIGN KEY (id_inquilino) REFERENCES MANGO_DB.inquilino(id)
);

CREATE TABLE MANGO_DB.venta (
    codigo NUMERIC(18,0) PRIMARY KEY,
    fecha DATETIME,
    precio_venta NUMERIC(18,2),
    moneda NVARCHAR(100),
    comision NUMERIC(18,2),
    id_anuncio NUMERIC(18,0) NOT NULL,
    id_comprador NUMERIC(18,0) NOT NULL,
    id_pago_venta NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_anuncio) REFERENCES MANGO_DB.anuncio(codigo),
    FOREIGN KEY (id_comprador) REFERENCES MANGO_DB.comprador(id),
    FOREIGN KEY (id_pago_venta) REFERENCES MANGO_DB.pago_venta(id)
);

CREATE TABLE MANGO_DB.pago_alquiler (
	codigo NUMERIC(18,0) PRIMARY KEY,
    id_alquiler NUMERIC(18,0) NOT NULL,
    fecha_pago DATETIME,
    fecha_vencimiento DATETIME,
    nro_periodo NUMERIC(18,0),
    desc_periodo NVARCHAR(100),
    fec_ini DATETIME,
    fec_fin DATETIME,
    importe NUMERIC(18,0),
    id_medio_pago NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_alquiler) REFERENCES MANGO_DB.alquiler(codigo),
    FOREIGN KEY (id_medio_pago) REFERENCES MANGO_DB.medio_pago(id)
);

/* ------- FIN DE CREACION DE TABLAS ------- */

/* ------- INICIO MIGRACION DE DATOS ------- */
SELECT * FROM gd_esquema.Maestra

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
INSERT INTO MANGO_DB.ambientes (detalle)
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

-- MANGO_DB.caracteristicas_inmueble
INSERT INTO MANGO_DB.caracteristicas_inmueble (wifi, cable, calefaccion, gas)
SELECT DISTINCT m.INMUEBLE_CARACTERISTICA_WIFI, m.INMUEBLE_CARACTERISTICA_CABLE, m.INMUEBLE_CARACTERISTICA_CALEFACCION, m.INMUEBLE_CARACTERISTICA_GAS
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_CODIGO IS NOT NULL

-- MANGO_DB.barrio
INSERT INTO MANGO_DB.barrio (nombre)
SELECT DISTINCT m.INMUEBLE_BARRIO
FROM gd_esquema.Maestra m

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

-- MANGO_DB.agente
INSERT INTO MANGO_DB.agente (nombre, apellido, dni, fecha_registro, telefono, mail, fecha_nac)
SELECT DISTINCT m.AGENTE_NOMBRE, m.AGENTE_APELLIDO, m.AGENTE_DNI, m.AGENTE_FECHA_REGISTRO, m.AGENTE_TELEFONO, m.AGENTE_MAIL, m.AGENTE_FECHA_NAC
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
-- (ESTO HAY QUE HACERLO CON CURSORES O UNA FUNCION PARA VER DE QUE PROVINCIA ES CADA LOCALIDAD)
INSERT INTO MANGO_DB.localidad (nombre, id_provincia)
SELECT DISTINCT m.INMUEBLE_LOCALIDAD, m.INMUEBLE_PROVINCIA
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_LOCALIDAD IS NOT NULL

-- MANGO_DB.sucursal
-- Hay que hacer lo mismo que en localidad pero para ver en que localidad est� la direccion
INSERT INTO MANGO_DB.sucursal (id, nombre, direccion, telefono, id_localidad)
SELECT m.SUCURSAL_CODIGO, m.SUCURSAL_NOMBRE, m.SUCURSAL_DIRECCION, m.SUCURSAL_TELEFONO, (SELECT id 
																						 FROM MANGO_DB.localidad) 
FROM gd_esquema.Maestra m

-- MANGO_DB.detalle_alq
-- Chequear CAMPOS NULL, QUE HACEMOS??? PUSE EL WHERE PARA ANULAR ESO, CHEQUEAR ENUNCIADO
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
-- CHEQUEAR A QUIEN HAY QUE HACERLE DISTINCT, TAL VEZ AL DNI?
INSERT INTO MANGO_DB.comprador (nombre, apellido, dni, fecha_registro, telefono, mail, fecha_nac)
SELECT DISTINCT m.COMPRADOR_NOMBRE, m.COMPRADOR_APELLIDO, m.COMPRADOR_DNI, m.COMPRADOR_FECHA_REGISTRO, m.COMPRADOR_FECHA_NAC
FROM gd_esquema.Maestra m
WHERE m.COMPRADOR_DNI IS NOT NULL

-- MANGO_DB.pago_venta 
-- CHEQUEAR subquery para FK, parece que sirve a simple vista
INSERT INTO MANGO_DB.pago_venta (importe, moneda, cotizacion, id_medio_pago)
SELECT DISTINCT m.PAGO_VENTA_IMPORTE, m.PAGO_VENTA_MONEDA, m.PAGO_VENTA_COTIZACION, (SELECT DISTINCT p.id 
																			FROM MANGO_DB.medio_pago p
																			WHERE p.descripcion = m.PAGO_VENTA_MONEDA) AS id_medio_pago
FROM gd_esquema.Maestra m

-- MANGO_DB.inmueble
-- FALTA id_localidad, usar procedure
-- FALTA SUBQUERY PARA PROPIETARIO
INSERT INTO MANGO_DB.inmueble (codigo, nombre, descripcion, direccion, superficie_total, antiguedad, expensas, 
							   id_localidad, id_barrio, id_caracteristicas, id_tipo_inmueble, id_cantidad_ambientes,
							   id_operacion, id_disposicion, id_estado, id_propietario)
SELECT m.INMUEBLE_CODIGO, m.INMUEBLE_NOMBRE, m.INMUEBLE_DESCRIPCION, m.INMUEBLE_DIRECCION, m.INMUEBLE_SUPERFICIETOTAL,
	   m.INMUEBLE_ANTIGUEDAD, INMUEBLE_EXPESAS, (SELECT b.id
												 FROM MANGO_DB.barrio b
												 WHERE m.INMUEBLE_BARRIO = nombre),
	   (SELECT c.id
	   FROM MANGO_DB.caracteristicas_inmueble c
	   WHERE m.INMUEBLE_CARACTERISTICA_WIFI = c.wifi AND m.INMUEBLE_CARACTERISTICA_CABLE = c.cable AND
	   m.INMUEBLE_CARACTERISTICA_CALEFACCION = c.cable AND m.INMUEBLE_CARACTERISTICA_GAS = c.gas),
	   (SELECT id 
	   FROM MANGO_DB.tipo_inmueble
	   WHERE m.INMUEBLE_TIPO_INMUEBLE = tipo),
	   (SELECT id FROM MANGO_DB.ambientes
	   WHERE m.INMUEBLE_CANT_AMBIENTES = detalle),
	   (SELECT id FROM MANGO_DB.orientacion
	   WHERE m.INMUEBLE_ORIENTACION = orientacion),
	   (SELECT id FROM MANGO_DB.disposicion
	   WHERE m.INMUEBLE_DISPOSICION = disposicion),
	   (SELECT id FROM MANGO_DB.estado
	   WHERE m.INMUEBLE_ESTADO = estado)
	   --(SELECT id FROM MANGO_DB.propietario
	   --WHERE m.PROP = nombre)

FROM gd_esquema.Maestra m

-- MANGO_DB.anuncio
-- FALTA id_inmueble, id_agente
INSERT INTO MANGO_DB.anuncio (codigo, id_inmueble, id_agente, fecha_publicacion, precio_publicado,
							  costo_anuncio, fecha_finalizacion, id_tipo_operacion, id_moneda, id_estado, 
							  tipo_periodo)
SELECT m.ANUNCIO_CODIGO, 
	   --(SELECT * FROM MANGO_DB.inmueble),	-- agente e inmueble terminar
	   --(SELECT * FROM MANGO_DB.agente),
	   m.ANUNCIO_FECHA_PUBLICACION, m.ANUNCIO_PRECIO_PUBLICADO, m.ANUNCIO_COSTO_ANUNCIO,
	   m.ANUNCIO_FECHA_FINALIZACION, 
	   (SELECT id FROM MANGO_DB.tipo_operacion
	   WHERE m.ANUNCIO_TIPO_OPERACION = tipo),
	   (SELECT id FROM MANGO_DB.moneda
	   WHERE m.ANUNCIO_MONEDA = descripcion),
	   (SELECT id FROM MANGO_DB.estado
	   WHERE m.ANUNCIO_ESTADO = estado),	   
	   m.ANUNCIO_TIPO_PERIODO
FROM gd_esquema.Maestra m

-- MANGO_DB.alquiler
-- FALTA ID_ANUNCIO, ID_INQUILINO, DURACION
INSERT INTO MANGO_DB.alquiler (codigo, fecha_inicio, fecha_fin, cant_periodos, deposito, comision, gastos_averigua,
							   estado, id_anuncio, id_inquilino, duracion)
SELECT m.ALQUILER_CODIGO, m.ALQUILER_FECHA_INICIO, m.ALQUILER_FECHA_FIN, m.ALQUILER_CANT_PERIODOS,
	   m.ALQUILER_DEPOSITO, m.ALQUILER_COMISION, m.ALQUILER_GASTOS_AVERIGUA, m.ALQUILER_ESTADO,
	   --(SELECT * FROM MANGO_DB.anuncio),
	   --(SELECT * FROM MANGO_DB.inquilino)
	   --m.DURACION		xd? De donde sale

FROM gd_esquema.Maestra m

-- MANGO_DB.venta
-- FALTA id_anuncio, id_comprador, id_pago_venta
INSERT INTO MANGO_DB.venta (codigo, fecha, precio_venta, moneda, comision, id_anuncio, id_comprador,
							id_pago_venta)
SELECT m.VENTA_CODIGO, m.VENTA_FECHA, m.VENTA_PRECIO_VENTA, m.VENTA_MONEDA, m.VENTA_COMISION,
	   (SELECT * FROM MANGO_DB.anuncio),
	   (SELECT * FROM MANGO_DB.comprador),
	   (SELECT * FROM MANGO_DB.pago_venta)
FROM gd_esquema.Maestra m

-- MANGO_DB.pago_alquiler
-- FALTA id_alquiler
-- FALTA id_medio_pago, chequear
INSERT INTO MANGO_DB.pago_alquiler (codigo, id_alquiler, fecha_pago, fecha_vencimiento, nro_periodo, desc_periodo,
									fec_ini, fec_fin, importe, id_medio_pago)
SELECT m.PAGO_ALQUILER_CODIGO,
	   --(SELECT * FROM MANGO_DB.alquiler),
	   m.PAGO_ALQUILER_FECHA, m.PAGO_ALQUILER_FECHA_VENCIMIENTO, m.PAGO_ALQUILER_NRO_PERIODO,
	   m.PAGO_ALQUILER_FEC_INI, m.PAGO_ALQUILER_FEC_FIN, m.PAGO_ALQUILER_IMPORTE,
	   (SELECT id FROM MANGO_DB.medio_pago
	   WHERE descripcion = m.PAGO_ALQUILER_MEDIO_PAGO)
FROM gd_esquema.Maestra m
/* ------- FIN MIGRACION DE DATOS ------- */