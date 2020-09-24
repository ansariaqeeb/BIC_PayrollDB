 IF (OBJECT_ID('StatusMaster_g') IS NOT NULL) 
BEGIN 
DROP PROCEDURE StatusMaster_g
END
GO
CREATE PROCEDURE [dbo].[StatusMaster_g]
(
 @pXMLFILE XML 
)
AS
    BEGIN 
	 
      DECLARE @pSTATUSID INT , @pTYPEID INT ,  
	  @pDESC NVARCHAR(120)    
     ------------------------------------------------------------------------------------------
	 DECLARE @verrorId INT 
     DECLARE @vspName VARCHAR(100) 
     SET @vspName = 'StatusMaster_g'
     
     SELECT @pSTATUSID = N.C.value('@STATUSID[1]', 'INT'),
			@pTYPEID = N.C.value('@TYPEID[1]', 'INT'),
			@pDESC = N.C.value('@DESC[1]', 'NVARCHAR(120)') 
     FROM   @pXMLFILE.nodes('//XMLFILE/SPXML/SPDETAILS') N ( C )
    
     EXEC DBLOG_c @pXMLFILE = @pXMLFILE, @pSPNAME = @vSPNAME
     ------------------------------------------------------------------------------------------
        
		BEGIN TRY 
			
			SELECT 
						STATUSID,
						STATUSCODE,
						TYPEID,
						DISCRIPTION,
						UPDATEDBY, 
						UPDATEDON,
						CREATEDBY,
						CREATEDON,
						ISACTIVE

			FROM  dbo.StatusMaster
			WHERE
			1 = CASE WHEN  @pSTATUSID>0 AND STATUSID= @pSTATUSID THEN 1 ELSE 0 END
			AND	1 = CASE WHEN  @pTYPEID>0 AND TYPEID= @pTYPEID THEN 1 ELSE 0 END  
			AND ISACTIVE=1

		END TRY 
   
		BEGIN CATCH

		SET @vERRORID = 0 - ERROR_NUMBER() 
		
		SELECT  0 - ERROR_NUMBER() AS 'ID' 

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT; 

		END CATCH; 
    END 
GO
