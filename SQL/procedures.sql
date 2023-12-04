USE GD2C2023;
GO

-- SELECT * FROM sys.procedures -- Esto para ver los procedures existentes

IF OBJECT_ID('MANGO_DB.BorrarTablasTransaccional', 'P') IS NOT NULL
BEGIN DROP PROCEDURE MANGO_DB.BorrarTablasTransaccional; END;
GO

IF OBJECT_ID('MANGO_DB.BorrarTablasBI', 'P') IS NOT NULL
BEGIN DROP PROCEDURE MANGO_DB.BorrarTablasBI; END;
GO

IF OBJECT_ID('MANGO_DB.BorrarFuncionesBI', 'P') IS NOT NULL
BEGIN DROP PROCEDURE MANGO_DB.BorrarFuncionesBI; END;
GO

IF OBJECT_ID('MANGO_DB.BorrarVistasBI', 'P') IS NOT NULL
BEGIN DROP PROCEDURE MANGO_DB.BorrarVistasBI; END;
GO

IF OBJECT_ID('MANGO_DB.BorrarFuncionesTransaccional', 'P') IS NOT NULL
BEGIN DROP PROCEDURE MANGO_DB.BorrarFuncionesTransaccional; END;
GO

IF OBJECT_ID('MANGO_DB.ResetearTransaccional', 'P') IS NOT NULL
BEGIN DROP PROCEDURE MANGO_DB.ResetearTransaccional; END;
GO

IF OBJECT_ID('MANGO_DB.ResetearBI', 'P') IS NOT NULL
BEGIN DROP PROCEDURE MANGO_DB.ResetearBI; END;
GO

CREATE PROCEDURE MANGO_DB.BorrarFuncionesTransaccional
AS
BEGIN
	-- Primero voy a borrar la función que usamos en transaccional, después las tablas

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'caracteristicas' AND ROUTINE_SCHEMA = 'MANGO_DB' AND ROUTINE_TYPE = 'FUNCTION')
    BEGIN DROP FUNCTION MANGO_DB.caracteristicas; END;
END
GO


CREATE PROCEDURE MANGO_DB.BorrarTablasTransaccional
AS
BEGIN
    -- Dropeo todas las FK constraints así puedo borrar las tablas después
BEGIN
	DECLARE @schemaName NVARCHAR(128) = N'MANGO_DB'; -- Replace with your schema name

	DECLARE @tableCursor CURSOR;
	DECLARE @tableName NVARCHAR(128);
	DECLARE @constraintName NVARCHAR(128);

	-- Create a cursor to loop through the tables in the schema
	SET @tableCursor = CURSOR FOR
	SELECT t.name AS TableName
	FROM sys.tables AS t
	WHERE SCHEMA_NAME(t.schema_id) = @schemaName;

	-- Open the cursor
	OPEN @tableCursor;

	FETCH NEXT FROM @tableCursor INTO @tableName;


	-- Loop through the tables
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Create a cursor to loop through the foreign keys in each table
		DECLARE @constraintCursor CURSOR;
    
		-- Generate and execute the SQL statement to drop foreign key constraints
		SET @constraintCursor = CURSOR FOR
		SELECT name AS ConstraintName
		FROM sys.foreign_keys
		WHERE parent_object_id = OBJECT_ID(@schemaName + '.' + @tableName);
    
		-- Open the constraint cursor
		OPEN @constraintCursor;
    
		FETCH NEXT FROM @constraintCursor INTO @constraintName;
    
		-- Loop through the constraints and drop them
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @dropConstraintSQL NVARCHAR(MAX);
			SET @dropConstraintSQL = 'ALTER TABLE ' + @schemaName + '.' + @tableName + ' DROP CONSTRAINT ' + @constraintName;
			-- PRINT @dropConstraintSQL; -- Print the SQL statement for verification
			EXEC sp_executesql @dropConstraintSQL; -- Execute the SQL statement to drop the constraint
			FETCH NEXT FROM @constraintCursor INTO @constraintName;
		END
    
		-- Close and deallocate the constraint cursor
		CLOSE @constraintCursor;
		DEALLOCATE @constraintCursor;
    
		-- Fetch the next table
		FETCH NEXT FROM @tableCursor INTO @tableName;
		END

		-- Close and deallocate the table cursor
		CLOSE @tableCursor;
		DEALLOCATE @tableCursor;
END

-- Dropeo todas las tablas existentes, 
BEGIN
	DECLARE @nombreTabla NVARCHAR(MAX);

	DECLARE table_cursor CURSOR FOR
	SELECT ('[MANGO_DB].[' + name + ']') FROM sys.tables tab
	WHERE tab.schema_id = (SELECT schema_id FROM sys.schemas sch WHERE sch.name = 'MANGO_DB')

	OPEN table_cursor;

	FETCH NEXT FROM table_cursor INTO @nombreTabla;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @sql NVARCHAR(MAX);
		SET @sql = 'DROP TABLE ' + @nombreTabla;
		-- PRINT @sql
		EXEC sp_executesql @sql
		FETCH NEXT FROM table_cursor INTO @nombreTabla;
	END;

	CLOSE table_cursor;
	DEALLOCATE table_cursor;
END
END;
GO


CREATE PROCEDURE MANGO_DB.ResetearTransaccional
AS
BEGIN

EXEC MANGO_DB.BorrarTablasTransaccional;
EXEC MANGO_DB.BorrarFuncionesTransaccional;

PRINT 'Se reseteó modelo transaccional del esquema MANGO_DB ';

END
GO

CREATE PROCEDURE MANGO_DB.BorrarTablasBI
AS
BEGIN
-- Primero drop tablas de hechos porque tienen las FKs
	IF OBJECT_ID('MANGO_DB.BI_Hecho_Anuncio', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Hecho_Anuncio; END;

	IF OBJECT_ID('MANGO_DB.BI_Hecho_Venta', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Hecho_Venta; END;

	IF OBJECT_ID('MANGO_DB.BI_Hecho_Alquiler', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Hecho_Alquiler; END;

	IF OBJECT_ID('MANGO_DB.BI_Hecho_Pago_Alquiler', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Hecho_Pago_Alquiler; END;

	-- Ahora drop de todas las dimensiones creadas

	IF OBJECT_ID('MANGO_DB.BI_Tiempo', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Tiempo; END;

	IF OBJECT_ID('MANGO_DB.BI_Ubicacion', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Ubicacion; END;

	IF OBJECT_ID('MANGO_DB.BI_Sucursal', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Sucursal; END;

	IF OBJECT_ID('MANGO_DB.BI_Rango_etario', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Rango_etario; END;

	IF OBJECT_ID('MANGO_DB.BI_Tipo_Inmueble', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Tipo_Inmueble; END;

	IF OBJECT_ID('MANGO_DB.BI_Ambientes', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Ambientes; END;

	IF OBJECT_ID('MANGO_DB.BI_Rango_m2', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Rango_m2; END;

	IF OBJECT_ID('MANGO_DB.BI_Tipo_Operacion', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Tipo_Operacion; END;

	IF OBJECT_ID('MANGO_DB.BI_Tipo_Moneda', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Tipo_Moneda; END;

	IF OBJECT_ID('MANGO_DB.BI_Alquiler', 'U') IS NOT NULL
	BEGIN DROP TABLE MANGO_DB.BI_Alquiler; END;
END;
GO

CREATE PROCEDURE MANGO_DB.BorrarFuncionesBI
AS
BEGIN
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'getCuatrimestre' AND ROUTINE_SCHEMA = 'MANGO_DB' AND ROUTINE_TYPE = 'FUNCTION')
	BEGIN DROP FUNCTION MANGO_DB.getCuatrimestre; END;
	
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'getRangoM2' AND ROUTINE_SCHEMA = 'MANGO_DB' AND ROUTINE_TYPE = 'FUNCTION')
	BEGIN DROP FUNCTION MANGO_DB.getRangoM2; END;
	
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'getRangoEtario' AND ROUTINE_SCHEMA = 'MANGO_DB' AND ROUTINE_TYPE = 'FUNCTION')
	BEGIN DROP FUNCTION MANGO_DB.getRangoEtario; END;
END
GO

CREATE PROCEDURE MANGO_DB.BorrarVistasBI
AS
BEGIN
	IF OBJECT_ID('MANGO_DB.BI_barrios_mas_elegidos_alquiler', 'V') IS NOT NULL
	BEGIN DROP VIEW MANGO_DB.BI_barrios_mas_elegidos_alquiler; END;
	
	IF OBJECT_ID('MANGO_DB.BI_comision_promedio', 'V') IS NOT NULL
	BEGIN DROP VIEW MANGO_DB.BI_comision_promedio; END;

	IF OBJECT_ID('MANGO_DB.BI_duracion_promedio_anuncios', 'V') IS NOT NULL
	BEGIN DROP VIEW MANGO_DB.BI_duracion_promedio_anuncios; END;

	IF OBJECT_ID('MANGO_DB.BI_monto_total_de_cierre', 'V') IS NOT NULL
	BEGIN DROP VIEW MANGO_DB.BI_monto_total_de_cierre; END;

	IF OBJECT_ID('MANGO_DB.BI_porcentaje_incumplimiento_pagos_alquileres', 'V') IS NOT NULL
	BEGIN DROP VIEW MANGO_DB.BI_porcentaje_incumplimiento_pagos_alquileres; END;

	IF OBJECT_ID('MANGO_DB.BI_porcentaje_operaciones_concretadas', 'V') IS NOT NULL
	BEGIN DROP VIEW MANGO_DB.BI_porcentaje_operaciones_concretadas; END;

	IF OBJECT_ID('MANGO_DB.BI_porcentaje_promedio_incremento_valor_alquileres', 'V') IS NOT NULL
	BEGIN DROP VIEW MANGO_DB.BI_porcentaje_promedio_incremento_valor_alquileres; END;

	IF OBJECT_ID('MANGO_DB.BI_precio_promedio_anuncios', 'V') IS NOT NULL
	BEGIN DROP VIEW MANGO_DB.BI_precio_promedio_anuncios; END;

	IF OBJECT_ID('MANGO_DB.BI_precio_promedio_m2', 'V') IS NOT NULL
	BEGIN DROP VIEW MANGO_DB.BI_precio_promedio_m2; END;
END
GO


CREATE PROCEDURE MANGO_DB.ResetearBI
AS
BEGIN
	EXEC MANGO_DB.BorrarTablasBI;
	EXEC MANGO_DB.BorrarFuncionesBI;
	EXEC MANGO_DB.BorrarVistasBI;

	PRINT 'Se reseteó modelo BI del esquema MANGO_DB ';
END
GO