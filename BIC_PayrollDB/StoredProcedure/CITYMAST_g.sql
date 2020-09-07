﻿IF (OBJECT_ID('CITYMAST_g') IS NOT NULL) 
BEGIN 
DROP PROCEDURE CITYMAST_g
END
GO
CREATE PROCEDURE [dbo].[CITYMAST_g]
(
 @pXMLFILE XML 
)
AS
    BEGIN 
	 
      DECLARE @pCITYID INT   
	  DECLARE @pCOUNTRYID INT  
	  DECLARE @pSTATEID INT  
	  DECLARE @pDESC NVARCHAR(120)    
     ------------------------------------------------------------------------------------------
	 DECLARE @verrorId INT 
     DECLARE @vspName VARCHAR(100) 
     SET @vspName = 'CITYMAST_g'
     
     SELECT @pCITYID = N.C.value('@CITYID[1]', 'INT'),
			@pCOUNTRYID = N.C.value('@COUNTRYID[1]', 'INT'),
			@pSTATEID = N.C.value('@STATEID[1]', 'INT'), 
			@pDESC = N.C.value('@DESC[1]', 'NVARCHAR(120)') 
     FROM   @pXMLFILE.nodes('//XMLFILE/SPXML/SPDETAILS') N ( C )
    
     EXEC DBLOG_c @pXMLFILE = @pXMLFILE, @pSPNAME = @vSPNAME
     ------------------------------------------------------------------------------------------
        
		BEGIN TRY 
			
			SELECT  
			C.CITYID,
			C.CITYCODE,
			C.CITYNAME,
			C.COUNTRYID,
			C.STATEID,
			C.ISACTIVE,
			C.CREATEDON,
			C.CREATEDBY,
			C.UPDATEDON,
			C.UPDATEDBY,
			S.STATECODE,
			S.STATENAME,
			CM.COUNTRYNAME,
			CM.COUNTRYCODE
			FROM  dbo.CITYMAST C
			LEFT JOIN dbo.STATEMAST S ON S.STATEID=C.STATEID
			LEFT JOIN dbo.COUNTRYMAST CM ON CM.COUNTRYID=C.COUNTRYID 
			WHERE
			1 = CASE WHEN  @pCITYID>0 AND CITYID= @pCITYID THEN 1 ELSE 0 END 
			AND 1 = CASE WHEN  @pCOUNTRYID>0 AND C.COUNTRYID= @pCOUNTRYID THEN 1 ELSE 0 END 
			AND 1 = CASE WHEN  @pSTATEID>0 AND C.COUNTRYID= @pCOUNTRYID THEN 1 ELSE 0 END 
			AND 1 = CASE WHEN LEN(@pDESC)= 0 THEN 1 WHEN  LEN(@pDESC)>0 AND (C.CITYCODE LIKE '%'+@pDESC+'%' OR C.CITYNAME LIKE '%'+@pDESC+'%') THEN 1 ELSE 0 END  
			 

		END TRY 
   
		BEGIN CATCH

		SET @vERRORID = 0 - ERROR_NUMBER() 
		
		SELECT  0 - ERROR_NUMBER() AS 'ID' 

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT; 

		END CATCH; 
    END 
GO