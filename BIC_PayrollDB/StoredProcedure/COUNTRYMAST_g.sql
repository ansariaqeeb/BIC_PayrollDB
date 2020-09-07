﻿IF (OBJECT_ID('COUNTRYMAST_g') IS NOT NULL) 
BEGIN 
DROP PROCEDURE COUNTRYMAST_g
END
GO
CREATE PROCEDURE [dbo].[COUNTRYMAST_g]
(
 @pXMLFILE XML 
)
AS
    BEGIN 
	 
      DECLARE @pCOUNTRYID INT   
	  DECLARE @pCOUNTRYNAME NVARCHAR(120)   
	  DECLARE @pCOUNTRYCODE NVARCHAR(10)
     ------------------------------------------------------------------------------------------
	 DECLARE @verrorId INT 
     DECLARE @vspName VARCHAR(100) 
     SET @vspName = 'COUNTRYMAST_g'
     
     SELECT @pCOUNTRYID = N.C.value('@COUNTRYID[1]', 'INT'),
			@pCOUNTRYNAME = N.C.value('@COUNTRYNAME[1]', 'NVARCHAR(120)'),
			@pCOUNTRYCODE = N.C.value('@COUNTRYCODE[1]', 'NVARCHAR(10)') 
     FROM   @pXMLFILE.nodes('//XMLFILE/SPXML/SPDETAILS') N ( C )
    
     EXEC DBLOG_c @pXMLFILE = @pXMLFILE, @pSPNAME = @vSPNAME
     ------------------------------------------------------------------------------------------
        
		BEGIN TRY 
			
			SELECT  
			COUNTRYID,
			COUNTRYNAME,
			COUNTRYCODE,
			ISACTIVE, 
			CREATEDBY,
			CREATEDON,
			UPDATEBY,
			UPDATEDON
			FROM  dbo.COUNTRYMAST
			WHERE
			1 = CASE WHEN  @pCOUNTRYID>0 AND COUNTRYID= @pCOUNTRYID THEN 1 ELSE 0 END 
			AND 1 = CASE WHEN LEN(@pCOUNTRYNAME)= 0 THEN 1 WHEN  LEN(@pCOUNTRYNAME)>0 AND COUNTRYNAME LIKE '%'+@pCOUNTRYNAME+'%' THEN 1 ELSE 0 END 
			AND 1 = CASE WHEN LEN(@pCOUNTRYCODE)= 0 THEN 1 WHEN  LEN(@pCOUNTRYCODE)>0 AND COUNTRYCODE LIKE '%'+@pCOUNTRYCODE+'%' THEN 1 ELSE 0 END 
			 

		END TRY 
   
		BEGIN CATCH

		SET @vERRORID = 0 - ERROR_NUMBER() 
		
		SELECT  0 - ERROR_NUMBER() AS 'ID' 

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT; 

		END CATCH; 
    END 
GO