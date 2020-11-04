﻿DROP PROCEDURE [dbo].[PROCESSPAYSLIP_g]
GO
CREATE PROCEDURE [dbo].[PROCESSPAYSLIP_g]
(
 @pXMLFILE XML 
)
AS
    BEGIN 
	 
      DECLARE @pEMPID INT ,   
	  @pCOMPID INT, 
	  @pUSERID INT,
	  @pPERIODID INT,
	  @pPERIODTRANS INT ,
	  @pTotGrossIncome Decimal(21,6),
	  @pTotDeduction Decimal(21,6)
     ------------------------------------------------------------------------------------------
	 DECLARE @verrorId INT 
     DECLARE @vspName VARCHAR(100) 
     SET @vspName = 'PROCESSPAYSLIP_g'
     
     SELECT @pEMPID = N.C.value('@EMPID[1]', 'INT'), 
			@pCOMPID = N.C.value('@COMPID[1]', 'INT'), 
			@pUSERID = N.C.value('@USERID[1]', 'INT') 
     FROM   @pXMLFILE.nodes('//XMLFILE/SPXML/SPDETAILS') N ( C )
    
     EXEC DBLOG_c @pXMLFILE = @pXMLFILE, @pSPNAME = @vSPNAME
     ------------------------------------------------------------------------------------------
        
		BEGIN TRY 

			SELECT @pPERIODID=MID,@pPERIODTRANS=TID FROM dbo.FREQUENCYPERIOD M
			INNER JOIN dbo.FREQUENCYPERIODTRANS T ON T.RMID=M.MID WHERE COMPID=@pCOMPID AND M.ISACTIVE=1 AND M.ISCLOSED=0 AND T.ISCURRENT=1 AND T.ISCLOSED=0

			SELECT @pTotGrossIncome=SUM(ISNULL(M.AMOUNT,P.AMOUNT))
			FROM  dbo.EMPLOYEEPAYMAPPING P 
			INNER JOIN dbo.PAYSLIPHEADS H ON P.HEADID=H.HEADID AND P.ISACTIVE=1 AND H.ISACTIVE=1 AND H.COMPID=1  AND H.TRANSACTIONTYPE=1
			LEFT JOIN dbo.PROCESSPAYSLIP M ON P.HEADID=M.HEADID AND P.EMPID=1 AND M.COMPID=1 AND M.ISACTIVE=1 AND ISNULL(M.ISPROCESSED,0)=0 AND ISNULL(M.ISCLOSED,0)=0
			
			SELECT @pTotDeduction=SUM(ISNULL(M.AMOUNT,P.AMOUNT))
			FROM  dbo.EMPLOYEEPAYMAPPING P 
			INNER JOIN dbo.PAYSLIPHEADS H ON P.HEADID=H.HEADID AND P.ISACTIVE=1 AND H.ISACTIVE=1 AND H.COMPID=1  AND H.TRANSACTIONTYPE=2
			LEFT JOIN dbo.PROCESSPAYSLIP M ON P.HEADID=M.HEADID AND P.EMPID=1 AND M.COMPID=1 AND M.ISACTIVE=1 AND ISNULL(M.ISPROCESSED,0)=0 AND ISNULL(M.ISCLOSED,0)=0

			SELECT  
			E.EMPCODE,
			E.FIRSTNAME,
			E.MIDDLENAME,
			E.LASTNAME,
			P.MID AS MAPPINGID,
			P.HEADID,
			P.EMPID,
			P.CALSEQUENCE,
			P.AMOUNT AS MAPAMOUNT,
			H.HEADCODE,
			H.[DESC] AS HEADDESC,
			H.TRANSACTIONTYPE,
			S.STATUSCODE TRANSACTIONTYPEDESC,
			H.IsCalculation,
			ISNULL(H.ISAFFECTNATIONALPAY,0)AS ISAFFECTNATIONALPAY,
			ISNULL(H.ISAFFECTPAYSLIP,0)AS ISAFFECTPAYSLIP,
			ISNULL(H.PRINTONPS,0)AS PRINTONPS,
			ISNULL(H.TYPEOFINPUTID,0)AS TYPEOFINPUTID,
			ISNULL(S1.STATUSCODE,'') AS TYPEOFINPUTDESC,
			ISNULL(H.RATEID,0)AS RATEID,
			ISNULL(R.RATECODE,'') +' '+ISNULL(R.DESCRIPTION,'') AS RATEDESC,
			@pPERIODID AS PERIODID,
			@pPERIODTRANS AS PERIODTRANS,
			ISNULL(M.PROCESSID,0)AS PROCESSID,
			CAST(ISNULL(M.QTY,0)AS DECIMAL(21,2))AS QTY, 
			CAST(ISNULL(M.RATE,0)AS DECIMAL(21,2))AS RATE, 
			CAST(ISNULL(M.AMOUNT,P.AMOUNT)AS DECIMAL(21,2))AS AMOUNT,   
			ISNULL(M.ISOVERRIDE,0)AS ISOVERRIDE,
			ISNULL(M.REFERENCE,'')AS REFERENCE,
			ISNULL(M.ISPROCESSED,0)AS ISPROCESSED,
			ISNULL(M.ISCLOSED,'')AS ISCLOSED,
			CAST(ISNULL(@pTotGrossIncome,0)AS DECIMAL(21,2))AS TOTALGROSSINCOME, 
			CAST(ISNULL(@pTotDeduction,0)AS DECIMAL(21,2))AS TOTALDEDUCTION,  
			CAST(ISNULL((@pTotGrossIncome-@pTotDeduction),0)AS DECIMAL(21,2))AS NETPAY 
			FROM  dbo.EMPLOYEEPAYMAPPING P 
			INNER JOIN dbo.PAYSLIPHEADS H ON P.HEADID=H.HEADID AND P.ISACTIVE=1 AND H.ISACTIVE=1 AND H.COMPID=@pCOMPID
			INNER JOIN dbo.EMPLOYEE E ON P.EMPID=E.EMPID
			INNER JOIN dbo.StatusMaster S ON H.TRANSACTIONTYPE= S.STATUSID AND S.TYPEID=5
			LEFT JOIN dbo.StatusMaster S1 ON H.TYPEOFINPUTID= S1.STATUSID AND S1.TYPEID=7
			LEFT JOIN dbo.RATEMASTER R ON H.RATEID=R.RATEID  
			LEFT JOIN dbo.PROCESSPAYSLIP M ON P.HEADID=M.HEADID AND P.EMPID=@pEMPID AND M.COMPID=@pCOMPID AND M.ISACTIVE=1 AND ISNULL(M.ISPROCESSED,0)=0 AND ISNULL(M.ISCLOSED,0)=0
			ORDER BY P.CALSEQUENCE 
			  
		END TRY 
   
		BEGIN CATCH

		SET @vERRORID = 0 - ERROR_NUMBER() 
		
		SELECT  0 - ERROR_NUMBER() AS 'ID' 

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT; 

		END CATCH; 
    END 
GO