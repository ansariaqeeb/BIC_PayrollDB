DROP PROCEDURE [dbo].[RATEMASTER_g]
GO
CREATE PROCEDURE [dbo].[RATEMASTER_g]
(
 @pXMLFILE XML 
)
AS
    BEGIN 
	 
      DECLARE @pCOMPID INT ,  
	  @pRATEID INT, 
	  @pRATECODE VARCHAR(20), 
	  @pFLAG CHAR(1) ,
	  @pUSERID INT,
	  @vTRANSDETAILS XML
     ------------------------------------------------------------------------------------------
	 DECLARE @verrorId INT 
     DECLARE @vspName VARCHAR(100) 
     SET @vspName = 'RATEMASTER_g'
     
     SELECT @pCOMPID = N.C.value('@COMPID[1]', 'INT'),
			@pRATEID = N.C.value('@RATEID[1]', 'INT'),
			@pRATECODE = N.C.value('@RATECODE[1]', 'VARCHAR(20)'), 
			@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'),
			@pUSERID = N.C.value('@USERID[1]', 'INT') 
     FROM   @pXMLFILE.nodes('//XMLFILE/SPXML/SPDETAILS') N ( C )
    
     EXEC DBLOG_c @pXMLFILE = @pXMLFILE, @pSPNAME = @vSPNAME
     ------------------------------------------------------------------------------------------
        
		BEGIN TRY 
		 
			
			SELECT  
			 RATEID,
			 RATECODE,
			 DESCRIPTION,
			 RATE,
			 COMPID,
			 BASEFACTORID,
			 M.ISACTIVE,
			 M.CREATEDON,
			 M.CREATEDBY,
			 M.UPDATEDON,
			 M.UPDATEDBY,
			 S.STATUSCODE 
			FROM  dbo.RATEMASTER M
			LEFT JOIN StatusMaster S ON S.STATUSID=M.BASEFACTORID  AND S.TYPEID=6
			WHERE
			1 = CASE WHEN @pUSERID=0 THEN 1 WHEN @pUSERID<>0 AND M.CREATEDBY=@pUSERID THEN 1 ELSE 0 END
			AND 1 = CASE WHEN @pCOMPID=0 THEN 1 WHEN @pCOMPID<>0 AND M.COMPID= @pCOMPID THEN 1 ELSE 0 END 
			AND 1 = CASE WHEN @pRATEID=0 THEN 1 WHEN @pRATEID<>0 AND M.RATEID= @pRATEID THEN 1 ELSE 0 END  
			AND 1 = CASE WHEN LEN(@pRATECODE)=0 THEN 1 WHEN LEN(@pRATECODE)<>0 AND M.RATECODE LIKE '%'+@pRATECODE+'%' THEN 1 ELSE 0 END  

		END TRY 
   
		BEGIN CATCH

		SET @vERRORID = 0 - ERROR_NUMBER() 
		
		SELECT  0 - ERROR_NUMBER() AS 'ID' 

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT; 

		END CATCH; 
    END 
GO
