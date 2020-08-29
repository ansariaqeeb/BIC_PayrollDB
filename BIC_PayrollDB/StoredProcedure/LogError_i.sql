IF (OBJECT_ID('LogError_i') IS NOT NULL) 
BEGIN 
DROP PROCEDURE LogError_i
END
GO
CREATE PROCEDURE [dbo].[LogError_i]
       @InputParam VARCHAR(2000) , -- by uspLogError in the ErrorLog table.
       @ErrorLogID INT = 0 OUTPUT  -- Contains the ErrorLogID of the row inserted    
       --WITH ENCRYPTION
AS 
       BEGIN
             SET NOCOUNT ON;

    -- Output parameter value of 0 indicates that error 
    -- information was not logged.
             SET @ErrorLogID = 0;
             BEGIN TRY
        -- Return if there is no error information to log.
        --Jatin 09042013
        --IF ERROR_NUMBER() IS NULL
        --    RETURN;

        -- Return if inside an uncommittable transaction.
        -- Data insertion/modification is not allowed when 
        -- a transaction is in an uncommittable state.
                   IF XACT_STATE() = -1 
                      BEGIN
                            PRINT 'Cannot log error since the current transaction is in an uncommittable state. '
                                  + 'Rollback the transaction before executing uspLogError in order to successfully log error information.';
                            RETURN;
                      END;
        --if(@InputParam IS NUll)
       -- BEgin
       

                   INSERT   INTO ErrorLog ( UserName, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine,
                                            ErrorMessage, ErrorDate, InputParameter )
                   VALUES   ( CONVERT(SYSNAME, CURRENT_USER), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(),
                              ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(), GETUTCDATE(), @InputParam );

        -- Pass back the ErrorLogID of the row inserted
                   SELECT   @ErrorLogID = @@IDENTITY;
       
             END TRY
             BEGIN CATCH
                   PRINT 'An error occurred in stored procedure uspLogError: ';
       -- EXECUTE uspPrintError;
                   RETURN -1;
             END CATCH
       END;

GO
