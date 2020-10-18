 
 IF (OBJECT_ID('PROCESSPAYSLIP_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE dbo.PROCESSPAYSLIP_c
END
GO
CREATE PROCEDURE dbo.PROCESSPAYSLIP_c
(
	 @pXMLFILE XML ,
	 @pERRORXML XML OUT 
)
     
AS 
    BEGIN
			DECLARE 
			@pFLAG CHAR(1),
			@pCOMPID BIGINT,  
			@pUSERID BIGINT, 
			@pTransXML XML, 
			@vlocal INT,
			@vspName VARCHAR(20),
			@videntity INT,
			@vERRORID INT

			SET @vlocal = 0 
			SET @vspName = 'PROCESSPAYSLIP_c'

		  SELECT	@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'), 
					@pCOMPID  =  N.C.value('@COMPID[1]','BIGINT') , 
					@pUSERID  =  N.C.value('@USERID[1]','BIGINT'),
					@pTransXML = N.C.query('//TRANSLIST') 
		 FROM @pXMLFILE.nodes('//XMLFILE/SPXML/SPDETAILS') N ( C )

		  EXEC DBLOG_c @pXMLFILE = @pXMLFILE, @pSPNAME = @vspName

         ---------------------------------------------------------------------------------------
           BEGIN TRY
			IF @@TRANCOUNT = 0  
			  BEGIN  
				  BEGIN TRANSACTION  
				  SET @vLOCAL = 1 
			   END 

            IF @pFLAG = 'I' 
                BEGIN
					  
					INSERT INTO dbo.PROCESSPAYSLIP
					        ( EMPID ,
					          HEADID ,
					          QTY ,
					          RATE ,
					          AMOUNT ,
					          ISOVERRIDE ,
					          REFERENCE ,
					          COMPID ,
					          RMID ,
					          RTID , 
					          CREATEDON ,
					          CREATEDBY  
					        )
					SELECT	N.C.value('@EMPID[1]','BIGINT'),
							N.C.value('@HEADID[1]','BIGINT'),
							N.C.value('@QTY[1]','DECIMAL(21,6)'), 
							N.C.value('@RATE[1]','DECIMAL(21,6)'),
							N.C.value('@AMOUNT[1]','DECIMAL(21,6)'),
							N.C.value('@ISOVERRIDE[1]','BIT'),
							N.C.value('@REFERENCE[1]','VARCHAR(500)'), 
							@pCOMPID,
							N.C.value('@PERIODID[1]','INT'),
							N.C.value('@PERIODTRANS[1]','INT'),
							GETDATE(),
							@pUSERID 
					FROM @ptransXMl.nodes('//TRANSLIST/TRANS') N ( C )
					WHERE N.C.value('@PROCESSID[1]', 'BIGINT') = 0

					UPDATE P SET 
					P.QTY= N.C.value('@QTY[1]','DECIMAL(21,6)'),
					P.AMOUNT= N.C.value('@AMOUNT[1]','DECIMAL(21,6)'),
					P.ISOVERRIDE= N.C.value('@ISOVERRIDE[1]','BIT'),
					P.REFERENCE= N.C.value('@REFERENCE[1]','VARCHAR(500)'),
					P.RATE= N.C.value('@RATE[1]','DECIMAL(21,6)')
					FROM dbo.PROCESSPAYSLIP P 
					INNER JOIN @ptransXMl.nodes('//TRANSLIST/TRANS') N ( C ) ON N.C.value('@PROCESSID[1]', 'BIGINT')=P.PROCESSID

					SET @videntity = @pCOMPID  
                END 
            ELSE 
                IF @pFLAG = 'E' 
                    BEGIN 
					PRINT 1 
                    END 
                ELSE 
                    IF @pFLAG = 'D' 
                     BEGIN  
                     PRINT 1 
                     END  
                        

            IF @pFlag IN ( 'I', 'E', 'D')
				BEGIN 
					IF @pFlag = 'I' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Added', 'S', 'Payslip Process', 0)
					IF @pFlag = 'E' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Edited', 'S', 'Payslip Process', 0)
					IF @pFlag = 'D' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Deleted', 'S', 'Payslip Process', 0) 
				END 

         IF ( @@trancount > 0 AND @vLOCAL = 1 )
		  BEGIN    
			COMMIT TRANSACTION 
		  END   
        END TRY    
        BEGIN CATCH
          IF ( @@trancount > 0  AND @vLOCAL = 1 )
            BEGIN 
              ROLLBACK TRANSACTION 
            END    

         SET @vERRORID = 0 - ERROR_NUMBER() 

         SET @pERRORXML = dbo.F_ERRORXML(@vERRORID, '', 'E', 'Rate', 1)

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT;

    END CATCH;
  END 
  GO