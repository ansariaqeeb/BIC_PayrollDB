 
 IF (OBJECT_ID('EMPLOYEEPAYMAPPING_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE EMPLOYEEPAYMAPPING_c
END
GO
CREATE PROCEDURE dbo.EMPLOYEEPAYMAPPING_c
(
	 @pXMLFILE XML ,
	 @pERRORXML XML OUT 
)
     
AS 
    BEGIN
			DECLARE 
			@pFLAG CHAR(1),
			@pMID INT, 
			@pHEADID INT, 
			@pEMPID INT,
			@pCALSEQUENCE INT, 
			@pAMOUNT DECIMAL(21, 6),
			@pIsCalculation BIT,
			@pFORMULA VARCHAR(5000),
			@pISACTIVE bit, 
			@pUSERID INT, 
			@vlocal INT,
			@vspName VARCHAR(20),
			@videntity INT,
			@vERRORID INT  
			 

			SET @vlocal = 0 
			SET @vspName = 'EMPLOYEEPAYMAPPING_c'

		  SELECT	@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'),
					@pMID  =  N.C.value('@MID[1]','INT'), 
					@pHEADID  =  N.C.value('@HEADID[1]','INT'), 
					@pEMPID  =  N.C.value('@EMPID[1]','INT'), 
					@pCALSEQUENCE  =  N.C.value('@CALSEQUENCE[1]','INT'), 
					@pAMOUNT  =  N.C.value('@AMOUNT[1]','DECIMAL(21, 6)'), 
					@pIsCalculation  =  N.C.value('@IsCalculation[1]','BIT'), 
					@pFORMULA  =  N.C.value('@FORMULA[1]','VARCHAR(5000)'), 
					@pISACTIVE  =  N.C.value('@ISACTIVE[1]','BIT'),  
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

					INSERT INTO dbo.EMPLOYEEPAYMAPPING 
					(
						HEADID,
						EMPID, 
						CALSEQUENCE,
						AMOUNT,
						IsCalculation,
						FORMULA, 
						CREATEDON,
						CREATEDBY
					)
					VALUES
					(
						@pHEADID,
						@pEMPID,
						@pCALSEQUENCE,
						@pAMOUNT,
						@pIsCalculation,
						@pFORMULA,
						GETDATE(),
						@pUSERID
					) 

					SET @videntity = @@IDENTITY
					 
                  
                END 
            ELSE 
                IF @pFLAG = 'E' 
                    BEGIN

					UPDATE dbo.EMPLOYEEPAYMAPPING SET 
					HEADID =@pHEADID,
					EMPID =@pEMPID,
					CALSEQUENCE =@pCALSEQUENCE, 
					AMOUNT =@pAMOUNT,
					IsCalculation =@pIsCalculation,
					FORMULA=@pFORMULA,
					ISACTIVE=@pISACTIVE, 
					UPDATEDBY=@pUSERID,
					UPDATEDON=GETDATE()
					WHERE MID=@pMID

					SET @videntity = @pMID 

                    END 
                ELSE 
                    IF @pFLAG = 'D' 
                     BEGIN  
                          DELETE  FROM dbo.EMPLOYEEPAYMAPPING
                          WHERE MID=@pMID

                          SET @videntity = @pMID
                     END  
                        

            IF @pFlag IN ( 'I', 'E', 'D')
				BEGIN 
					IF @pFlag = 'I' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Added', 'S', 'Pay Slip Transaction', 0)
					IF @pFlag = 'E' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Edited', 'S', 'Pay Slip Transaction', 0)
					IF @pFlag = 'D' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Deleted', 'S', 'Pay Slip Transaction', 0) 
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

         SET @pERRORXML = dbo.F_ERRORXML(@vERRORID, '', 'E', 'Pay Slip Transaction', 1)

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT;

    END CATCH;
  END 
  GO