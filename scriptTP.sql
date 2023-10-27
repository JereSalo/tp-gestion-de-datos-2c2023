/* ------- CREACION DEL SCHEMA ------- */
USE GD2C2023

IF NOT EXISTS (SELECT schema_id FROM sys.schemas WHERE name = 'MANGO_DB')
BEGIN
    -- Crea el schema
    EXEC('CREATE SCHEMA MANGO_DB;'); 
    PRINT 'Esquema "MANGO_DB" creado con éxito.';
END
ELSE
BEGIN
    PRINT 'El esquema "MANGO_DB" ya existe en la base de datos.';
END

/* ------- INICIO DE CREACION DE TABLAS ------- */
--Aclaracion importante: a las pk compuestas les puse numeros xq sino tira error xq se intentan sobreescribir

CREATE TABLE MANGO_DB.tipo_inmueble (
	id NUMERIC(18,0) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE MANGO_DB.estado (
	id NUMERIC(18,0) PRIMARY KEY,
	estado NVARCHAR(100)
);

CREATE TABLE MANGO_DB.ambientes (
	id NUMERIC(18,0) PRIMARY KEY,
	detalle NVARCHAR(100)
);

CREATE TABLE MANGO_DB.disposicion (
	id NUMERIC(18,0) PRIMARY KEY,
	disposicion NVARCHAR(100)
);

CREATE TABLE MANGO_DB.orientacion (
	id NUMERIC(18,0) PRIMARY KEY,
	orientacion NVARCHAR(100)
);

CREATE TABLE MANGO_DB.caracteristicas_inmueble (
	id NUMERIC(18,0) PRIMARY KEY,
	wifi NUMERIC(18,0),
	cable NUMERIC(18,0),
	calefaccion NUMERIC(18,0),
	gas NUMERIC(18,0)
);

CREATE TABLE MANGO_DB.barrio (
	id NUMERIC(18,0) PRIMARY KEY,
	nombre NVARCHAR(100)
);

CREATE TABLE MANGO_DB.propietario (
	id NUMERIC(18,0) PRIMARY KEY,
	nombre NVARCHAR(100),
	apellido NVARCHAR(100),
	dni NUMERIC(18,0),
	fecha_registro DATETIME,
	telefono NUMERIC(18,0),
	mail NVARCHAR(255),
	fecha_nac DATETIME
);

CREATE TABLE MANGO_DB.moneda (
	id NUMERIC(18,0) PRIMARY KEY,
	descripcion NVARCHAR(100)
);

CREATE TABLE MANGO_DB.tipo_operacion (
	id NUMERIC(18,0) PRIMARY KEY,
	tipo NVARCHAR(100)
);

CREATE TABLE MANGO_DB.agente (
	id NUMERIC(18,0) PRIMARY KEY,
	nombre NVARCHAR(100),
	apellido NVARCHAR(100),
	dni NUMERIC(18,0),
	fecha_registro DATETIME,
	telefono NUMERIC(18,0),
	mail NVARCHAR(255),
	fecha_nac DATETIME
);

CREATE TABLE MANGO_DB.estado_anuncio (
	id NUMERIC(18,0) PRIMARY KEY,
	estado NVARCHAR(100)
);
	
CREATE TABLE MANGO_DB.inquilino (
	id NUMERIC(18,0) PRIMARY KEY,
	nombre NVARCHAR(100),
	apellido NVARCHAR(100),
	dni NVARCHAR(100),
	fecha_registro DATETIME,
	telefono NUMERIC(18,0),
	mail NVARCHAR(100),
	fecha_nac DATETIME
);

CREATE TABLE MANGO_DB.provincia (
	id NUMERIC(18,0) PRIMARY KEY,
	nombre NVARCHAR(100)
);

CREATE TABLE MANGO_DB.localidad (
    id NUMERIC(18,0) PRIMARY KEY,
    nombre NVARCHAR(100),
    id_provincia NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_provincia) REFERENCES MANGO_DB.provincia(id)
);
					  
CREATE TABLE MANGO_DB.sucursal (
    codigo NUMERIC(18,0) PRIMARY KEY,
    nombre NVARCHAR(100),
    direccion NVARCHAR(100),
    telefono NVARCHAR(100),
    id_localidad NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_localidad) REFERENCES MANGO_DB.localidad(id)
);

CREATE TABLE MANGO_DB.detalle_alq (
    cod_detalle_alq NUMERIC(18,0) PRIMARY KEY,
    cod_alquiler NUMERIC(18,0),
    nro_periodo_fin NUMERIC(18,0),
    precio NUMERIC(18,2),
    nro_periodo_in NUMERIC(18,0)
);

CREATE TABLE MANGO_DB.medio_pago (
	id NUMERIC(18,0) PRIMARY KEY,
	descripcion NVARCHAR(100)
);
					  
CREATE TABLE MANGO_DB.comprador (
	id NUMERIC(18,0) PRIMARY KEY,
	nombre NVARCHAR(100),
	apellido NVARCHAR(100),
	dni NUMERIC(18,0),
	fecha_registro DATETIME,
	telefono NUMERIC(18,0),
	mail NVARCHAR(255),
	fecha_nac DATETIME
);

CREATE TABLE MANGO_DB.pago_venta (
    id NUMERIC(18,0) PRIMARY KEY,
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
    id_operacion NUMERIC(18,0) NOT NULL,
    id_disposicion NUMERIC(18,0) NOT NULL,
    id_estado NUMERIC(18,0) NOT NULL,
    id_propietario NUMERIC(18,0) NOT NULL,

    FOREIGN KEY (id_localidad) REFERENCES MANGO_DB.localidad(id),
    FOREIGN KEY (id_barrio) REFERENCES MANGO_DB.barrio(id),
    FOREIGN KEY (id_caracteristicas) REFERENCES MANGO_DB.caracteristicas_inmueble(id),
    FOREIGN KEY (id_tipo_inmueble) REFERENCES MANGO_DB.tipo_inmueble(id),
    FOREIGN KEY (id_cantidad_ambientes) REFERENCES MANGO_DB.ambientes(id),
    FOREIGN KEY (id_operacion) REFERENCES MANGO_DB.tipo_operacion(id),
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
    
    FOREIGN KEY (id_inmueble) REFERENCES MANGO_DB.inmueble(id),
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
    
    FOREIGN KEY (id_anuncio) REFERENCES MANGO_DB.anuncio(id),
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
    
    FOREIGN KEY (id_anuncio) REFERENCES MANGO_DB.anuncio(id),
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
    
    FOREIGN KEY (id_alquiler) REFERENCES MANGO_DB.alquiler(id),
    FOREIGN KEY (id_medio_pago) REFERENCES MANGO_DB.medio_pago(id)
);

/* ------- FIN DE CREACION DE TABLAS ------- */

/* ------- INICIO MIGRACION DE DATOS ------- */
SELECT * FROM gd_esquema.Maestra

-- MANGO_DB.tipo_inmueble
INSERT INTO MANGO_DB.tipo_inmueble (id, tipo)
SELECT DISTINCT m.INMUEBLE_CODIGO, m.INMUEBLE_TIPO_INMUEBLE 
FROM gd_esquema.Maestra m

-- MANGO_DB.estado
INSERT INTO MANGO_DB.estado (id, estado)
SELECT DISTINCT m.INMUEBLE_CODIGO, m.INMUEBLE_ESTADO
FROM gd_esquema.Maestra m

-- MANGO_DB.ambientes
INSERT INTO MANGO_DB.ambientes (id, detalle)
SELECT DISTINCT m.INMUEBLE_CODIGO, m.INMUEBLE_CANT_AMBIENTES
FROM gd_esquema.Maestra m

-- MANGO_DB.disposicion
INSERT INTO MANGO_DB.disposicion (id, disposicion)
SELECT DISTINCT m.INMUEBLE_CODIGO, m.INMUEBLE_DISPOSICION
FROM gd_esquema.Maestra m

-- MANGO_DB.orientacion
INSERT INTO MANGO_DB.orientacion (id, orientacion)
SELECT DISTINCT m.INMUEBLE_CODIGO, m.INMUEBLE_ORIENTACION
FROM gd_esquema.Maestra m

-- MANGO_DB.caracteristicas_inmueble
INSERT INTO MANGO_DB.caracteristicas_inmueble (id, wifi, cable, calefaccion, gas)
SELECT DISTINCT m.INMUEBLE_CODIGO, m.INMUEBLE_CARACTERISTICA_WIFI, m.INMUEBLE_CARACTERISTICA_CABLE, m.INMUEBLE_CARACTERISTICA_CALEFACCION, m.INMUEBLE_CARACTERISTICA_GAS
FROM gd_esquema.Maestra m

-- MANGO_DB.barrio
INSERT INTO MANGO_DB.barrio (id, nombre)
SELECT DISTINCT m.INMUEBLE_CODIGO, m.INMUEBLE_BARRIO
FROM gd_esquema.Maestra m

-- MANGO_DB.propietario
INSERT INTO MANGO_DB.propietario (id, nombre, apellido, dni, fecha_registro, telefono, mail, fecha_nac)
SELECT DISTINCT m.INMUEBLE_CODIGO, m.PROPIETARIO_NOMBRE, m.PROPIETARIO_APELLIDO, m.PROPIETARIO_DNI, m.PROPIETARIO_FECHA_REGISTRO, m.PROPIETARIO_TELEFONO, m.PROPIETARIO_MAIL, m.PROPIETARIO_FECHA_NAC
FROM gd_esquema.Maestra m
WHERE m.INMUEBLE_CODIGO IS NOT NULL

-- MANGO_DB.moneda
INSERT INTO MANGO_DB.moneda (id, descripcion)
SELECT DISTINCT m.ANUNCIO_CODIGO, m.ANUNCIO_MONEDA
FROM gd_esquema.Maestra m

-- MANGO_DB.tipo_operacion 
INSERT INTO MANGO_DB.tipo_operacion (id, tipo)
SELECT DISTINCT m.ANUNCIO_CODIGO, m.ANUNCIO_TIPO_OPERACION
FROM gd_esquema.Maestra m

-- MANGO_DB.agente
INSERT INTO MANGO_DB.agente (id, nombre, apellido, dni, fecha_registro, telefono,mail, fecha_nac)
SELECT DISTINCT m.ANUNCIO_CODIGO, m.AGENTE_NOMBRE, m.AGENTE_APELLIDO, m.AGENTE_DNI, m.AGENTE_FECHA_REGISTRO, m.AGENTE_TELEFONO, m.AGENTE_MAIL, m.AGENTE_FECHA_NAC
FROM gd_esquema.Maestra m

-- MANGO_DB.estado_anuncio
INSERT INTO MANGO_DB.estado_anuncio (id, estado)
SELECT DISTINCT m.ANUNCIO_CODIGO, m.ANUNCIO_ESTADO
FROM gd_esquema.Maestra m

-- MANGO_DB.inquilino
INSERT INTO MANGO_DB.inquilino (id, nombre, apellido, dni, fecha_registro,telefono, mail, fecha_nac)
SELECT DISTINCT m.ALQUILER_CODIGO, m.INQUILINO_NOMBRE, m.INQUILINO_APELLIDO, m.INQUILINO_DNI, m.INQUILINO_FECHA_REGISTRO, m.INQUILINO_TELEFONO, m.INQUILINO_MAIL, m.INQUILINO_FECHA_NAC
FROM gd_esquema.Maestra m
WHERE m.ALQUILER_CODIGO IS NOT NULL

-- MANGO_DB.provincia
DECLARE @inmueble_provincia NVARCHAR(100), @contador INT
DECLARE cursorProvincia CURSOR FOR
	SELECT DISTINCT m.INMUEBLE_PROVINCIA
	FROM gd_esquema.Maestra m
	WHERE m.INMUEBLE_PROVINCIA IS NOT NULL

SET @contador = 1

OPEN cursorProvincia
FETCH NEXT FROM cursorProvincia INTO @inmueble_provincia
WHILE(@@FETCH_STATUS = 0)
BEGIN	
	INSERT INTO MANGO_DB.provincia (id, nombre)
	VALUES(@contador, @inmueble_provincia)

	SET @contador += 1

FETCH NEXT FROM cursorProvincia INTO @id
END
CLOSE cursorProvincia
DEALLOCATE cursorProvincia

-- MANGO_DB.localidad
INSERT INTO MANGO_DB.localidad (id, nombre, id_provincia)
SELECT m.INMUEBLE_CODIGO, m.INMUEBLE_LOCALIDAD,
FROM gd_esquema.Maestra m

INSERT INTO MANGO_DB.sucursal (id, nombre, direccion, telefono, id_localidad)
SELECT m.SUCURSAL_CODIGO, m.SUCURSAL_NOMBRE, m.SUCURSAL_DIRECCION, m.SUCURSAL_TELEFONO, 
FROM gd_esquema.Maestra m

--FALTA ID cod_detalle_alq
INSERT INTO MANGO_DB.detalle_alq (cod_detalle_alq, cod_alquiler, nro_periodo_fin, precio, nro_periodo_in)
SELECT m.ALQUILER_CODIGO, m.DETALLE_ALQ_NRO_PERIODO_FIN, m.DETALLE_ALQ_PRECIO, m.DETALLE_ALQ_NRO_PERIODO_INI
FROM gd_esquema.Maestra m

-- FALTA ID
INSERT INTO MANGO_DB.medio_pago (id, descripcion)
SELECT m.PAGO_VENTA_MEDIO_PAGO
FROM gd_esquema.Maestra m



-- FALTA ID
INSERT INTO MANGO_DB.comprador (id, nombre, apellido, dni, fecha_registro, telefono, mail, fecha_nac)
SELECT m.COMPRADOR_NOMBRE, m.COMPRADOR_APELLIDO, m.COMPRADOR_DNI, m.COMPRADOR_FECHA_REGISTRO, m.COMPRADOR_FECHA_NAC
FROM gd_esquema.Maestra m

INSERT INTO MANGO_DB.pago_venta (id, importe, moneda, cotizacion, id_medio_pago)
SELECT m.PAGO_VENTA_IMPORTE, m.PAGO_VENTA_MONEDA, m.PAGO_VENTA_COTIZACION, id_medio_pago 
FROM gd_esquema.Maestra m


/* ------- FIN MIGRACION DE DATOS ------- */