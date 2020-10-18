﻿ IF (OBJECT_ID('PAYSLIPHEADS_g') IS NOT NULL) 
BEGIN 
DROP PROCEDURE PAYSLIPHEADS_g
END
GO
CREATE PROCEDURE [dbo].[PAYSLIPHEADS_g]
(
 @pXMLFILE XML 
)
AS
    BEGIN 
	 
      DECLARE @pHEADID INT ,  
	  @pHEADCODE nvarchar(20),  
	  @pDESC NVARCHAR(120) ,
	  @pCOMPID INT,
	  @pTRANSACTIONTYPE INT,
	  @pUSERID INT    
     ------------------------------------------------------------------------------------------
	 DECLARE @verrorId INT 
     DECLARE @vspName VARCHAR(100) 
     SET @vspName = 'PAYSLIPHEADS_g'
     
     SELECT @pHEADID = N.C.value('@HEADID[1]', 'INT'),
			@pHEADCODE = N.C.value('@HEADCODE[1]', 'nvarchar(20)'),
			@pDESC = N.C.value('@DESC[1]', 'nvarchar(200)'), 
			@pCOMPID = N.C.value('@COMPID[1]', 'INT'),
			@pTRANSACTIONTYPE = N.C.value('@TRANSACTIONTYPE[1]', 'INT'),
			@pUSERID = N.C.value('@USERID[1]', 'INT') 
     FROM   @pXMLFILE.nodes('//XMLFILE/SPXML/SPDETAILS') N ( C )
    
     EXEC DBLOG_c @pXMLFILE = @pXMLFILE, @pSPNAME = @vSPNAME
     ------------------------------------------------------------------------------------------
        
		BEGIN TRY 
			
			SELECT  
			HEADID,
			HEADCODE,
			[DESC],
			TRANSACTIONTYPE,
			S.STATUSCODE,
			ISNULL(ISAFFECTNATIONALPAY,0)AS ISAFFECTNATIONALPAY,
			ISNULL(ISAFFECTPAYSLIP,0)AS ISAFFECTPAYSLIP,
			ISNULL(PRINTONPS,0)AS PRINTONPS,
			ISNULL(TYPEOFINPUTID ,0)AS TYPEOFINPUTID,
			ISNULL(S1.STATUSCODE,'') AS TYPEOFINPUTDESC,
			ISNULL(P.RATEID,0)AS RATEID,
			ISNULL(R.RATECODE,'') +' '+ISNULL(R.DESCRIPTION,'') AS RATEDESC,
			P.ISACTIVE,
			P.COMPID, 
			ISNULL(P.IsCalculation,0)AS IsCalculation,
			ISNULL(P.FORMULA,'')AS FORMULA
			FROM  dbo.PAYSLIPHEADS P 
			INNER JOIN dbo.StatusMaster S ON S.STATUSID=P.TRANSACTIONTYPE AND S.TYPEID=5
			LEFT JOIN dbo.StatusMaster S1 ON S1.STATUSID=P.TYPEOFINPUTID AND S1.TYPEID=7
			LEFT JOIN dbo.RATEMASTER R ON R.RATEID=P.RATEID  
			WHERE
			1 = CASE WHEN @pHEADID=0 THEN 1 WHEN @pHEADID<>0 AND HEADID=@pHEADID THEN 1 ELSE 0 END
			AND 1 = CASE WHEN @pCOMPID=0 THEN 1 WHEN @pCOMPID<>0 AND P.COMPID= @pCOMPID THEN 1 ELSE 0 END 
			AND 1 = CASE WHEN @pTRANSACTIONTYPE=0 THEN 1 WHEN @pTRANSACTIONTYPE<>0 AND TRANSACTIONTYPE= @pTRANSACTIONTYPE THEN 1 ELSE 0 END 
			AND 1 = CASE WHEN LEN(@pHEADCODE)=0 THEN 1 WHEN LEN(@pHEADCODE)<>0 AND HEADCODE LIKE '%'+ @pHEADCODE +'%' THEN 1 ELSE 0 END
			AND 1 = CASE WHEN LEN(@pDESC)=0 THEN 1 WHEN LEN(@pDESC)<>0 AND [DESC] LIKE '%'+ @pDESC +'%' THEN 1 ELSE 0 END 

		END TRY 
   
		BEGIN CATCH

		SET @vERRORID = 0 - ERROR_NUMBER() 
		
		SELECT  0 - ERROR_NUMBER() AS 'ID' 

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT; 

		END CATCH; 
    END 
GO
