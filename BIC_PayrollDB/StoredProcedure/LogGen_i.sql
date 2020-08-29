IF (OBJECT_ID('LogGen_i') IS NOT NULL) 
BEGIN 
DROP PROCEDURE LogGen_i
END
GO
CREATE PROCEDURE [dbo].[LogGen_i] (
       @Pr_ProcedureName VARCHAR(50) ,
       @Pr_TableName VARCHAR(50) ,
       @Pr_IndexId VARCHAR(10) ,
       @Pr_ActionTaken TINYINT ,
       @Pr_UserId INT ,
       @Pr_Columns VARCHAR(MAX) = ' * ' )
       
AS 
       BEGIN 
             DECLARE @retval NVARCHAR(MAX)
             DECLARE @ParmDefinition NVARCHAR(50);
             DECLARE @V_SQL NVARCHAR(MAX)
             DECLARE @V_PrimaryColumn NVARCHAR(50)		
		
             SELECT @V_PrimaryColumn = TBL_1.COLUMN_NAME
             FROM   INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS TBL_1
                    INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TBL_2 ON TBL_1.CONSTRAINT_NAME = TBL_2.CONSTRAINT_NAME
             WHERE  CONSTRAINT_TYPE = 'PRIMARY KEY'
                    AND TBL_1.TABLE_NAME = @Pr_TableName
             IF ( @Pr_Columns = '' ) 
                SET @Pr_Columns = ' * '
             SET @V_SQL = N'SELECT @retvalOUT = ( SELECT ' + @Pr_Columns + ' FROM  ' + @Pr_TableName + ' WHERE '
                 + @V_PrimaryColumn + '= ' + @Pr_IndexId + '  FOR XML PATH (''' + @Pr_TableName + ''' ) )' 

             SET @ParmDefinition = N'@retvalOUT nvarchar(MAX) OUTPUT';

             EXEC sp_executesql @V_SQL, @ParmDefinition, @retvalOUT = @retval OUTPUT;
			  
             INSERT INTO LogTable ( ProcedureName, TableName, PRIMARYKEY, ActionTaken, Records, LogDate, UserId )
             VALUES ( @Pr_ProcedureName, @Pr_TableName, @Pr_IndexId, @Pr_ActionTaken, @retval, GETUTCDATE(), @Pr_UserId )


       END 		 
GO

