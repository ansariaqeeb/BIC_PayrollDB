 
 IF (OBJECT_ID('PAYSLIPHEADS_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE PAYSLIPHEADS_c
END
GO
CREATE PROCEDURE dbo.PAYSLIPHEADS_c
(
	 @pXMLFILE XML ,
	 @pERRORXML XML OUT 
)
     
AS 
    BEGIN
			DECLARE 
			@pFLAG CHAR(1),
			@pHEADID INT, 
			@pHEADCODE VARCHAR(20), 
			@pDESC nvarchar(200),
			@pTRANSACTIONTYPE INT, 
			@pTRANSACTIONTYPEDESC NVARCHAR(200),
			@pISACTIVE bit,
			@pCOMPID INT, 
			@pUSERID INT, 
			@vlocal INT,
			@vspName VARCHAR(20),
			@videntity INT,
			@vERRORID INT  
			 

			SET @vlocal = 0 
			SET @vspName = 'PAYSLIPHEADS_c'

		  SELECT	@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'),
					@pHEADID  =  N.C.value('@HEADID[1]','INT'), 
					@pHEADCODE  =  N.C.value('@HEADCODE[1]','VARCHAR(20)'), 
					@pTRANSACTIONTYPE  =  N.C.value('@TRANSACTIONTYPE[1]','INT'), 
					@pDESC  =  N.C.value('@DESC[1]','NVARCHAR(200)'), 
					@pISACTIVE  =  N.C.value('@ISACTIVE[1]','BIT'), 
					@pCOMPID  =  N.C.value('@COMPID[1]','INT') ,
					@pUSERID  =  N.C.value('@USERID[1]','INT')  
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

					INSERT INTO dbo.PAYSLIPHEADS
					(
						HEADCODE,
						[DESC],
						TRANSACTIONTYPE,
						COMPID,
						CREATEDON,
						CREATEDBY
					)
					VALUES
					(
						@pHEADCODE,
						@pDESC,
						@pTRANSACTIONTYPE,
						@pCOMPID,
						GETDATE(),
						@pUSERID
					) 

					SET @videntity = @@IDENTITY
					 
                  
                END 
            ELSE 
                IF @pFLAG = 'E' 
                    BEGIN

					UPDATE dbo.PAYSLIPHEADS SET 
					HEADCODE =@pHEADCODE,
					[DESC] =@pDESC,
					TRANSACTIONTYPE =@pTRANSACTIONTYPE,  
					ISACTIVE=@pISACTIVE, 
					UPDATEDBY=@pUSERID,
					UPDATEDON=GETDATE()
					WHERE HEADID=@pHEADID

					SET @videntity = @pHEADID 

                    END 
                ELSE 
                    IF @pFLAG = 'D' 
                     BEGIN  
                          DELETE  FROM dbo.PAYSLIPHEADS
                          WHERE HEADID=@pHEADID

                          SET @videntity = @pHEADID
                     END  
                        

            IF @pFlag IN ( 'I', 'E', 'D')
				BEGIN 
					IF @pFlag = 'I' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Added', 'S', 'Pay Slip Heads', 0)
					IF @pFlag = 'E' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Edited', 'S', 'Pay Slip Heads', 0)
					IF @pFlag = 'D' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Deleted', 'S', 'Pay Slip Heads', 0) 
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

         SET @pERRORXML = dbo.F_ERRORXML(@vERRORID, '', 'E', 'Pay Slip Heads', 1)

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT;

    END CATCH;
  END 
  GO