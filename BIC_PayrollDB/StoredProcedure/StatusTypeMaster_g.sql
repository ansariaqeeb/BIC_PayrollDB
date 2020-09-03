IF (OBJECT_ID('StatusTypeMaster_g') IS NOT NULL) 
BEGIN 
DROP PROCEDURE StatusTypeMaster_g
END
GO
CREATE PROCEDURE [dbo].[StatusTypeMaster_g]
(
 @pXMLFILE XML 
)
AS
    BEGIN 
	 
      DECLARE @pTYPEID INT ,  
	  @pDESC NVARCHAR(120)    
     ------------------------------------------------------------------------------------------
	 DECLARE @verrorId INT 
     DECLARE @vspName VARCHAR(100) 
     SET @vspName = 'StatusTypeMaster_g'
     
     SELECT @pTYPEID = N.C.value('@TYPEID[1]', 'INT'),
			@pDESC = N.C.value('@DESC[1]', 'NVARCHAR(120)') 
     FROM   @pXMLFILE.nodes('//XMLFILE/SPXML/SPDETAILS') N ( C )
    
     EXEC DBLOG_c @pXMLFILE = @pXMLFILE, @pSPNAME = @vSPNAME
     ------------------------------------------------------------------------------------------
        
		BEGIN TRY 
			
			SELECT 
						TYPECODE,
						DISCRIPTION,
						CREATEDON,
						CREATEDBY,
						UPDATEDBY, 
						UPDATEDON

			FROM  dbo.StatusTypeMaster
			WHERE
			1 = CASE WHEN  @pTYPEID>0 AND TYPEID= @pTYPEID THEN 1 ELSE 0 END  

		END TRY 
   
		BEGIN CATCH

		SET @vERRORID = 0 - ERROR_NUMBER() 
		
		SELECT  0 - ERROR_NUMBER() AS 'ID' 

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT; 

		END CATCH; 
    END 
GO
