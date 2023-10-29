-- DROP PROCEDURE MANGO_DB.BorrarTablas

CREATE PROCEDURE MANGO_DB.BorrarTablas
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
	SELECT ('[MANGO_DB].[' + name + ']')
	FROM sys.tables;

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

PRINT 'Se borraron todas las tablas del schema ' + @schemaName;
END;