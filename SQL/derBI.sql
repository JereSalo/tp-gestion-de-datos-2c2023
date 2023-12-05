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
	
	sumatoria_monto_por_cierre NUMERIC(18,2) NULL,
	sumatoria_precio NUMERIC(18,2) NULL, -- VISTAS: 2
	sumatoria_duracion NUMERIC(18,0) NULL, -- VISTAS: 1
	cantidad_operaciones_concretadas NUMERIC(18,0) NULL, -- VISTAS: 1
	sumatoria_comision NUMERIC(18,2) NULL,
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
	sumatoria_comisiones NUMERIC(18,2) NULL, -- VISTAS: 7
	cantidad_pagos_incumplidos NUMERIC(18,0) NULL,
	cantidad_pagos_totales NUMERIC(18,0) NULL,

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
	id_tiempo NUMERIC(18,0), 
	
	sumatoria_pagos NUMERIC(18,2),
	porcentaje_aumento NUMERIC(18,2), 
	cantidad_pagos_con_aumento NUMERIC(18,0), 
	cantidad_pagos NUMERIC(18,0), 

	FOREIGN KEY (id_tiempo) REFERENCES MANGO_DB.BI_Tiempo(id)
);
