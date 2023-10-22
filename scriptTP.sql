CREATE TABLE inmueble (codigo NUMERIC(18,0) PRIMARY KEY NOT NULL,
					   nombre NVARCHAR(100), 
					   descripcion NVARCHAR(100),
					   id_localidad NUMERIC(18,2) FOREIGN KEY NOT NULL,
					   id_barrio NUMERIC(18,2) FOREIGN KEY NOT NULL,
					   direccion NVARCHAR(100),
					   superficie_total NUMERIC(18,2),
					   antiguedad NUMERIC(18,0),
					   expensas NUMERIC(18,2),
					   id_caracteristicas FOREIGN KEY NUMERIC(18,0) NOT NULL,
					   id_tipo FOREIGN KEY NUMERIC(18,0) NOT NULL,
					   id_cantidad_ambientes FOREIGN KEY NUMERIC(18,0) NOT NULL,
					   id_operacion FOREIGN KEY NUMERIC(18,0) NOT NULL,
					   id_disposicion FOREIGN KEY NUMERIC(18,0) NOT NULL,
					   id_estado NUMERIC(18,0) NOT NULL,
					   id_propietario NUMERIC(18,0) NOT NULL) 


CREATE TABLE tipo_inmueble (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
							tipo NVARCHAR(100))

CREATE TABLE estado (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
							estado NVARCHAR(100))

CREATE TABLE ambientes (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
							detalle NVARCHAR(100))

CREATE TABLE disposicion (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
							disposicion NVARCHAR(100))

CREATE TABLE orientacion (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
							orientacion NVARCHAR(100))

CREATE TABLE caracteristicas_inmueble (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
							wifi NUMERIC(18,0),
							cable NUMERIC(18,0),
							calefaccion NUMERIC(18,0),
							gas NUMERIC(18,0))

CREATE TABLE barrio (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
							nombre NVARCHAR(100))

CREATE TABLE propietario_x_inmueble (id_propietario NUMERIC(18,0) PRIMARY KEY NOT NULL,
									 id_inmueble NUMERIC(18,0) FOREIGN KEY NOT NULL)

CREATE TABLE propietario (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
						  nombre NVARCHAR(100),
						  apellido NVARCHAR(100),
						  dni NUMERIC(18,0),
						  fecha_registro DATETIME,
						  telefono NUMERIC(18,0),
						  mail NVARCHAR(255),
						  fecha_nac DATETIME)

CREATE TABLE anuncio (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
					  id_inmueble NUMERIC(18,0) FOREIGN KEY NOT NULL,
					  id_agente NUMERIC(18,0) FOREIGN KEY NOT NULL,
					  fecha_publicacion DATETIME,
					  precio_publicado NUMERIC(18,2),
					  costo_anuncio NUMERIC(18,2),
					  fecha_finalizacion DATETIME,
					  id_tipo_operacion NUMERIC(18,0) FOREIGN KEY NOT NULL,
					  id_moneda NUMERIC(18,0) FOREIGN KEY NOT NULL,
					  id_estado NUMERIC(18,0) FOREIGN KEY NOT NULL,
					  tipo_periodo NVARCHAR(100))

CREATE TABLE estado_anuncio (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
							 estado NVARCHAR(100))

CREATE TABLE moneda (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
					 descripcion NVARCHAR(100))

CREATE TABLE tipo_operacion (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
							 tipo NVARCHAR(100))

CREATE TABLE agente (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
					 nombre NVARCHAR(100),
					 apellido NVARCHAR(100),
					 dni NUMERIC(18,0),
					 fecha_registro DATETIME,
					 telefono NUMERIC(18,0),
					 mail NVARCHAR(255),
					 fecha_nac DATETIME)

CREATE TABLE sucursal (id NUMERIC(18,0) PRIMARY KEY NOT NULL, 
					   nombre NVARCHAR(100),
					   direccion NVARCHAR(100),
					   telefono NVARCHAR(100),
					   id_localidad NUMERIC(18,0) FOREIGN KEY NOT NULL)

CREATE TABLE inquilino (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
						nombre NVARCHAR(100),
						apellido NVARCHAR(100),
						dni NVARCHAR(100),
						fecha_registro DATETIME,
						telefono NUMERIC(18,0),
						mail NVARCHAR(100),
						fecha_nac DATETIME)

CREATE TABLE pago_alquiler (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
							id_alquiler NUMERIC(18,0) FOREIGN KEY NOT NULL
							fecha_pago DATETIME,
							fecha_vencimiento DATETIME,
							nro_periodo NUMERIC(18,0),
							desc_periodo NVARCHAR(100),
							fec_ini DATETIME,
							fec_fin DATETIME
							importe NUMERIC(18,0),
							id_medio_pago NUMERIC(18,0) FOREIGN KEY NOT NULL)

CREATE TABLE localidad (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
						nombre NVARCHAR(100),
						id_provincia NUMERIC(18,0) FOREIGN KEY NOT NULL)

CREATE TABLE provincia (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
						nombre NVARCHAR(100))

CREATE TABLE alquiler (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
					  fecha_inicio DATETIME,
					  fecha_fin DATETIME,
					  cant_periodos NUMERIC(18,0),
					  deposito NUMERIC(18,2),
					  comision NUMERIC(18,2),
					  gastos_averigua NUMERIC(18,2),
					  estado NVARCHAR(100),
					  id_anuncio NUMERIC(18,0) FOREIGN KEY NOT NULL,
					  id_inquilino NUMERIC(18,0) FOREIGN KEY NOT NULL,
					  duracion NUMERIC(18,0))
					  
CREATE TABLE detalle_alq (cod_detalle_alq NUMERIC(18,0) PRIMARY KEY NOT NULL,
						cod_alquiler NUMERIC(18,0) PRIMARY KEY  NOT NULL,
						nro_periodo_fin NUMERIC(18,0),
						precio NUMERIC(18,2),
						nro_periodo_in NUMERIC(18,0))

CREATE TABLE venta (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
			 		fecha DATETIME,
					precio_venta NUMERIC(18,2),
					moneda NVARCHAR(100),
					comision NUMERIC(18,2),
					id_anuncio NUMERIC(18,0) FOREIGN KEY NOT NULL,
					id_comprador NUMERIC(18,0) FOREIGN KEY NOT NULL,
					id_pago_venta NUMERIC(18,0) FOREIGN KEY NOT NULL)

CREATE TABLE pago_venta (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
						 importe NUMERIC(18,2),
						 moneda NVARCHAR(100),
						 cotizacion NULL(18,2),
						 id_medio_pago NUMERIC(18,0) FOREIGN KEY NOT NULL)

CREATE TABLE medio_pago (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
						 descripcion NVARCHAR(100))
					  
CREATE TABLE comprador (id NUMERIC(18,0) PRIMARY KEY NOT NULL,
						nombre NVARCHAR(100),
						apellido NVARCHAR(100),
						dni NUMERIC(18,0),
						fecha_registro DATETIME,
						telefono NUMERIC(18,0),
						mail NVARCHAR(255),
						fecha_nac DATETIME)
