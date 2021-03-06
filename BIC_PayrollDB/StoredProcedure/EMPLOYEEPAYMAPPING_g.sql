﻿ IF (OBJECT_ID('EMPLOYEEPAYMAPPING_g') IS NOT NULL) 
BEGIN 
DROP PROCEDURE EMPLOYEEPAYMAPPING_g
END
GO
CREATE PROCEDURE [dbo].[EMPLOYEEPAYMAPPING_g]
(
 @pXMLFILE XML 
)
AS
    BEGIN 
	 
      DECLARE @pMID BIGINT , 
	  @pEMPID BIGINT   
     ------------------------------------------------------------------------------------------
	 DECLARE @verrorId INT 
     DECLARE @vspName VARCHAR(100) 
     SET @vspName = 'EMPLOYEEPAYMAPPING_g'
     
     SELECT @pMID = N.C.value('@MID[1]', 'BIGINT'),
			@pEMPID = N.C.value('@EMPID[1]', 'BIGINT') 
     FROM   @pXMLFILE.nodes('//XMLFILE/SPXML/SPDETAILS') N ( C )
    
     EXEC DBLOG_c @pXMLFILE = @pXMLFILE, @pSPNAME = @vSPNAME
     ------------------------------------------------------------------------------------------
        
		BEGIN TRY 
			
			SELECT
			E.MID,
			E.HEADID,
			P.HEADCODE,
			P.[DESC] AS HEADDESC,
			P.TRANSACTIONTYPE,
			S.STATUSCODE,
			S.DISCRIPTION AS STATUSDESC,
			E.EMPID,
			E.CALSEQUENCE, 
			CAST(ISNULL(E.AMOUNT,0)AS DECIMAL(21,2))AS AMOUNT,
			P.IsCalculation,
			E.FORMULA,
			E.ISACTIVE
			FROM  dbo.EMPLOYEEPAYMAPPING E
			LEFT JOIN dbo.EMPLOYEE EP ON EP.EMPID=E.EMPID
			LEFT JOIN dbo.PAYSLIPHEADS P ON P.HEADID=E.HEADID
			LEFT JOIN dbo.StatusMaster S ON S.STATUSID=P.TRANSACTIONTYPE AND S.TYPEID=5
			WHERE
			1 = CASE WHEN @pMID=0 THEN 1 WHEN  @pMID>0 AND E.MID= @pMID THEN 1 ELSE 0 END
			AND	1 = CASE WHEN @pEMPID=0 THEN 1 WHEN  @pEMPID>0 AND E.EMPID= @pEMPID THEN 1 ELSE 0 END  
			ORDER BY E.CALSEQUENCE

		END TRY 
   
		BEGIN CATCH

		SET @vERRORID = 0 - ERROR_NUMBER() 
		
		SELECT  0 - ERROR_NUMBER() AS 'ID' 

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT; 

		END CATCH; 
    END 
GO
 