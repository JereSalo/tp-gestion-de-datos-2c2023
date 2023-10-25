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

CREATE TABLE MANGO_DB.propietario_x_inmueble (
	id_propietario NUMERIC(18,0),
	id_inmueble NUMERIC(18,0),
	
	CONSTRAINT PK_ClaveCompuesta1 PRIMARY KEY(id_propietario, id_inmueble)
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
    id NUMERIC(18,0) PRIMARY KEY,
    nombre NVARCHAR(100),
    direccion NVARCHAR(100),
    telefono NVARCHAR(100),
    id_localidad NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_localidad) REFERENCES MANGO_DB.localidad(id)
);

CREATE TABLE MANGO_DB.detalle_alq (
    cod_detalle_alq NUMERIC(18,0),
    cod_alquiler NUMERIC(18,0),
    nro_periodo_fin NUMERIC(18,0),
    precio NUMERIC(18,2),
    nro_periodo_in NUMERIC(18,0),
    
	CONSTRAINT PK_ClaveCompuesta2 PRIMARY KEY(cod_detalle_alq, cod_alquiler)
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
    id NUMERIC(18,0) PRIMARY KEY,
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
    id NUMERIC(18,0) PRIMARY KEY,
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
    id NUMERIC(18,0) PRIMARY KEY,
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
    id NUMERIC(18,0) PRIMARY KEY,
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
    id NUMERIC(18,0) PRIMARY KEY,
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

/* ------- FIN MIGRACION DE DATOS ------- */