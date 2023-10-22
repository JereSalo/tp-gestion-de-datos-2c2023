CREATE TABLE tipo_inmueble (id NUMERIC(18,0) PRIMARY KEY,
							tipo NVARCHAR(100))

CREATE TABLE estado (id NUMERIC(18,0) PRIMARY KEY,
							estado NVARCHAR(100))

CREATE TABLE ambientes (id NUMERIC(18,0) PRIMARY KEY,
							detalle NVARCHAR(100))

CREATE TABLE disposicion (id NUMERIC(18,0) PRIMARY KEY,
							disposicion NVARCHAR(100))

CREATE TABLE orientacion (id NUMERIC(18,0) PRIMARY KEY,
							orientacion NVARCHAR(100))

CREATE TABLE caracteristicas_inmueble (id NUMERIC(18,0) PRIMARY KEY,
							wifi NUMERIC(18,0),
							cable NUMERIC(18,0),
							calefaccion NUMERIC(18,0),
							gas NUMERIC(18,0))

CREATE TABLE barrio (id NUMERIC(18,0) PRIMARY KEY,
							nombre NVARCHAR(100))

CREATE TABLE propietario_x_inmueble (id_propietario NUMERIC(18,0),
									 id_inmueble NUMERIC(18,0),
									 CONSTRAINT PK_ClaveCompuesta PRIMARY KEY(id_propietario, id_inmueble))

CREATE TABLE propietario (id NUMERIC(18,0) PRIMARY KEY,
						  nombre NVARCHAR(100),
						  apellido NVARCHAR(100),
						  dni NUMERIC(18,0),
						  fecha_registro DATETIME,
						  telefono NUMERIC(18,0),
						  mail NVARCHAR(255),
						  fecha_nac DATETIME)

CREATE TABLE anuncio (
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
    
    FOREIGN KEY (id_inmueble) REFERENCES inmueble(id),
    FOREIGN KEY (id_agente) REFERENCES agente (id),
    FOREIGN KEY (id_tipo_operacion) REFERENCES tipo_operacion(id),
    FOREIGN KEY (id_moneda) REFERENCES moneda(id),
    FOREIGN KEY (id_estado) REFERENCES estado(id)
);


CREATE TABLE estado_anuncio (id NUMERIC(18,0) PRIMARY KEY,
							 estado NVARCHAR(100))

CREATE TABLE moneda (id NUMERIC(18,0) PRIMARY KEY,
					 descripcion NVARCHAR(100))

CREATE TABLE tipo_operacion (id NUMERIC(18,0) PRIMARY KEY,
							 tipo NVARCHAR(100))

CREATE TABLE agente (id NUMERIC(18,0) PRIMARY KEY,
					 nombre NVARCHAR(100),
					 apellido NVARCHAR(100),
					 dni NUMERIC(18,0),
					 fecha_registro DATETIME,
					 telefono NUMERIC(18,0),
					 mail NVARCHAR(255),
					 fecha_nac DATETIME)

CREATE TABLE sucursal (
    id NUMERIC(18,0) PRIMARY KEY,
    nombre NVARCHAR(100),
    direccion NVARCHAR(100),
    telefono NVARCHAR(100),
    id_localidad NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_localidad) REFERENCES localidad(id)
);


CREATE TABLE inquilino (id NUMERIC(18,0) PRIMARY KEY,
						nombre NVARCHAR(100),
						apellido NVARCHAR(100),
						dni NVARCHAR(100),
						fecha_registro DATETIME,
						telefono NUMERIC(18,0),
						mail NVARCHAR(100),
						fecha_nac DATETIME)

CREATE TABLE pago_alquiler (
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
    
    FOREIGN KEY (id_alquiler) REFERENCES alquiler(id),
    FOREIGN KEY (id_medio_pago) REFERENCES medio_pago(id)
);


CREATE TABLE localidad (
    id NUMERIC(18,0) PRIMARY KEY,
    nombre NVARCHAR(100),
    id_provincia NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_provincia) REFERENCES provincia(id)
);


CREATE TABLE provincia (id NUMERIC(18,0) PRIMARY KEY,
						nombre NVARCHAR(100))



					  
CREATE TABLE detalle_alq (
    cod_detalle_alq NUMERIC(18,0),
    cod_alquiler NUMERIC(18,0),
	
    nro_periodo_fin NUMERIC(18,0),
    precio NUMERIC(18,2),
    nro_periodo_in NUMERIC(18,0),
    
	CONSTRAINT PK_ClaveCompuesta PRIMARY KEY(cod_detalle_alq, cod_alquiler)
);


CREATE TABLE medio_pago (id NUMERIC(18,0) PRIMARY KEY,
						 descripcion NVARCHAR(100))
					  
CREATE TABLE comprador (id NUMERIC(18,0) PRIMARY KEY,
						nombre NVARCHAR(100),
						apellido NVARCHAR(100),
						dni NUMERIC(18,0),
						fecha_registro DATETIME,
						telefono NUMERIC(18,0),
						mail NVARCHAR(255),
						fecha_nac DATETIME)

CREATE TABLE pago_venta (
    id NUMERIC(18,0) PRIMARY KEY,
    importe NUMERIC(18,2),
    moneda NVARCHAR(100),
    cotizacion NUMERIC(18,2),
    id_medio_pago NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_medio_pago) REFERENCES medio_pago(id)
)


CREATE TABLE venta (
    id NUMERIC(18,0) PRIMARY KEY,
    fecha DATETIME,
    precio_venta NUMERIC(18,2),
    moneda NVARCHAR(100),
    comision NUMERIC(18,2),
    id_anuncio NUMERIC(18,0) NOT NULL,
    id_comprador NUMERIC(18,0) NOT NULL,
    id_pago_venta NUMERIC(18,0) NOT NULL,
    
    FOREIGN KEY (id_anuncio) REFERENCES anuncio(id),
    FOREIGN KEY (id_comprador) REFERENCES comprador(id),
    FOREIGN KEY (id_pago_venta) REFERENCES pago_venta(id)
)

CREATE TABLE alquiler (
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
    
    FOREIGN KEY (id_anuncio) REFERENCES anuncio(id),
    FOREIGN KEY (id_inquilino) REFERENCES inquilino(id)
)

CREATE TABLE inmueble (
    codigo NUMERIC(18,0) PRIMARY KEY,
    nombre NVARCHAR(100),
    descripcion NVARCHAR(100),
    id_localidad NUMERIC(18,2) NOT NULL,
    id_barrio NUMERIC(18,2) NOT NULL,
    direccion NVARCHAR(100),
    superficie_total NUMERIC(18,2),
    antiguedad NUMERIC(18,0),
    expensas NUMERIC(18,2),
    id_caracteristicas NUMERIC(18,0) NOT NULL,
    id_tipo_inmueble NUMERIC(18,0) NOT NULL,
    id_cantidad_ambientes NUMERIC(18,0) NOT NULL,
    id_operacion NUMERIC(18,0) NOT NULL,
    id_disposicion NUMERIC(18,0) NOT NULL,
    id_estado NUMERIC(18,0) NOT NULL,
    id_propietario NUMERIC(18,0) NOT NULL,
    FOREIGN KEY (id_localidad) REFERENCES localidad(id),
    FOREIGN KEY (id_barrio) REFERENCES barrio(id),
    FOREIGN KEY (id_caracteristicas) REFERENCES caracteristicas_inmueble(id),
    FOREIGN KEY (id_tipo_inmueble) REFERENCES tipo_inmueble(id),
    FOREIGN KEY (id_cantidad_ambientes) REFERENCES ambientes(id),
    FOREIGN KEY (id_operacion) REFERENCES tipo_operacion(id),
    FOREIGN KEY (id_disposicion) REFERENCES disposicion(id),
    FOREIGN KEY (id_estado) REFERENCES estado(id),
    FOREIGN KEY (id_propietario) REFERENCES propietario(id)
	)