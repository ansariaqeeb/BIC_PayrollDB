﻿ IF (OBJECT_ID('FORMULAVRIABLE_g') IS NOT NULL) 
BEGIN 
DROP PROCEDURE FORMULAVRIABLE_g
END
GO
CREATE PROCEDURE [dbo].[FORMULAVRIABLE_g]
(
 @pXMLFILE XML 
)
AS
    BEGIN 
	 
      DECLARE @pVARID BIGINT, 
	   @pHEADID BIGINT, 
	  @pVARIABLE nvarchar(20), 
	  @pCOMPID INT, 
	  @pUSERID INT    
     ------------------------------------------------------------------------------------------
	 DECLARE @verrorId INT 
     DECLARE @vspName VARCHAR(100) 
     SET @vspName = 'FORMULAVRIABLE_g'
     
     SELECT @pVARID = N.C.value('@VARID[1]', 'BIGINT'),
			@pHEADID = N.C.value('@HEADID[1]', 'BIGINT'),
			@pVARIABLE = N.C.value('@VARIABLE[1]', 'nvarchar(20)'), 
			@pCOMPID = N.C.value('@COMPID[1]', 'INT'), 
			@pUSERID = N.C.value('@USERID[1]', 'INT') 
     FROM   @pXMLFILE.nodes('//XMLFILE/SPXML/SPDETAILS') N ( C )
    
     EXEC DBLOG_c @pXMLFILE = @pXMLFILE, @pSPNAME = @vSPNAME
     ------------------------------------------------------------------------------------------
        
		BEGIN TRY 
			 
			SELECT 
			VARID, 
			P.HEADID ,
			H.HEADCODE,
			H.[DESC] AS HEADDESC,
			VARIABLE ,
			FIELDID ,
			H1.HEADCODE AS FIELDCODE,
			H1.[DESC] AS FIELDDESC,
			CAST(ISNULL(TESTVALUE,0)AS DECIMAL(21,2))AS TESTVALUE,
			ISNULL(P.ISACTIVE,0)AS ISACTIVE
			FROM  dbo.FORMULAVRIABLE P  
			INNER JOIN PAYSLIPHEADS H ON H.HEADID = P.HEADID
			INNER JOIN PAYSLIPHEADS H1 ON H1.HEADID = P.FIELDID
			WHERE
			1 = CASE WHEN @pVARID=0 THEN 1 WHEN @pVARID<>0 AND VARID=@pVARID THEN 1 ELSE 0 END
			AND 1 = CASE WHEN @pCOMPID<>0 AND P.COMPID= @pCOMPID THEN 1 ELSE 0 END  
			AND 1 = CASE WHEN @pHEADID<>0 AND P.HEADID= @pHEADID THEN 1 ELSE 0 END
			AND 1 = CASE WHEN LEN(@pVARIABLE)=0 THEN 1 WHEN LEN(@pVARIABLE)<>0 AND VARIABLE LIKE '%'+ @pVARIABLE +'%' THEN 1 ELSE 0 END 
			
		END TRY 
   
		BEGIN CATCH

		SET @vERRORID = 0 - ERROR_NUMBER() 
		
		SELECT  0 - ERROR_NUMBER() AS 'ID' 

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT; 

		END CATCH; 
    END 
GO