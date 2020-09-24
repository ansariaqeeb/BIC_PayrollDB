DROP PROCEDURE [dbo].[PAYFREQUENCY_g]
GO
CREATE PROCEDURE [dbo].[PAYFREQUENCY_g]
(
 @pXMLFILE XML 
)
AS
    BEGIN 
	 
      DECLARE @pCOMPID INT ,  
	  @pMID INT, 
	  @pTID INT, 
	  @pFLAG CHAR(1) ,
	  @pUSERID INT,
	  @vTRANSDETAILS XML
     ------------------------------------------------------------------------------------------
	 DECLARE @verrorId INT 
     DECLARE @vspName VARCHAR(100) 
     SET @vspName = 'PAYFREQUENCY_g'
     
     SELECT @pCOMPID = N.C.value('@COMPID[1]', 'INT'),
			@pMID = N.C.value('@MID[1]', 'INT'),
			@pTID = N.C.value('@TID[1]', 'INT'), 
			@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'),
			@pUSERID = N.C.value('@USERID[1]', 'INT') 
     FROM   @pXMLFILE.nodes('//XMLFILE/SPXML/SPDETAILS') N ( C )
    
     EXEC DBLOG_c @pXMLFILE = @pXMLFILE, @pSPNAME = @vSPNAME
     ------------------------------------------------------------------------------------------
        
		BEGIN TRY 
		 
			
			SELECT  
			MID,
			PROCESSMONTHLY,
			STARTINGMONTH,
			FIRSTMONTHENDDATE,
			MONTHSINTAXYEAR,
			COMPID,
			M.ISACTIVE AS MISACTIVE,
			M.ISCLOSED AS MISCLOSED,
			(SELECT  
			TID,
			MONTHID,
			MONTHENDDATE,
			STATUS,
			T.ISACTIVE AS ISACTIVE,
			T.ISCLOSED AS ISCLOSED,
			ISCURRENT
			FROM dbo.FREQUENCYPERIODTRANS T 
			WHERE T.RMid =M.MID FOR XML RAW('TRANS'), ROOT ('TRANSACTION'))AS TRANSDETAILS
			FROM  dbo.FREQUENCYPERIOD M  
			WHERE
			1 = CASE WHEN @pUSERID=0 THEN 1 WHEN @pUSERID<>0 AND M.CREATEDBY=@pUSERID THEN 1 ELSE 0 END
			AND 1 = CASE WHEN @pCOMPID=0 THEN 1 WHEN @pCOMPID<>0 AND M.COMPID= @pCOMPID THEN 1 ELSE 0 END 
			AND 1 = CASE WHEN @pMID=0 THEN 1 WHEN @pMID<>0 AND M.MID= @pMID THEN 1 ELSE 0 END  

		END TRY 
   
		BEGIN CATCH

		SET @vERRORID = 0 - ERROR_NUMBER() 
		
		SELECT  0 - ERROR_NUMBER() AS 'ID' 

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT; 

		END CATCH; 
    END 
GO
