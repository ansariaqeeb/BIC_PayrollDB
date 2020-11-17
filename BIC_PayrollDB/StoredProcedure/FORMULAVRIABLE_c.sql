 
 IF (OBJECT_ID('dbo.FORMULAVRIABLE_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE dbo.FORMULAVRIABLE_c
END
GO
CREATE PROCEDURE dbo.FORMULAVRIABLE_c
(
	 @pXMLFILE XML ,
	 @pERRORXML XML OUT 
)
     
AS 
    BEGIN
			DECLARE 
			@pFLAG CHAR(1),
			@pHEADID BIGINT,  
			@pVARID BIGINT, 
			@pVARIABLE VARCHAR(2),
			@pFIELDID BIGINT,
			@pTESTVALUE DECIMAL(21,6),
			@pISACTIVE bit,
			@pCOMPID INT, 
			@pUSERID INT, 
			@vlocal INT,
			@vspName VARCHAR(20),
			@videntity INT,
			@vERRORID INT
			 

			SET @vlocal = 0 
			SET @vspName = 'FORMULAVRIABLE_c'

		  SELECT	@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'),
					@pHEADID  =  N.C.value('@HEADID[1]','BIGINT'), 
					@pVARID  =  N.C.value('@VARID[1]','BIGINT'), 
					@pFIELDID  =  N.C.value('@FIELDID[1]','BIGINT'), 
					@pTESTVALUE=  N.C.value('@TESTVALUE[1]','DECIMAL(21,6)'),
					@pISACTIVE  =  N.C.value('@ISACTIVE[1]','BIT'), 
					@pCOMPID  =  N.C.value('@COMPID[1]','BIT'),
					@pUSERID  =  N.C.value('@USERID[1]','BIT') 
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

					SELECT @pVARIABLE=VARIABLENAME 
					FROM VARIABLENAME 
					WHERE Id =(SELECT COUNT(VARID) FROM FORMULAVRIABLE WHERE  HEADID=@pHEADID AND COMPID=@pCOMPID)+1

					INSERT INTO dbo.FORMULAVRIABLE
					        ( HEADID ,
					          VARIABLE ,
					          FIELDID ,
					          TESTVALUE,
							  COMPID,
							  ISACTIVE,
							  CREATEDBY,
							  CREATEDON
					        )
					VALUES  ( @pHEADID , -- HEADID - bigint
					          @pVARIABLE, -- VARIABLE - char(2)
					          @pFIELDID , -- FIELDID - bigint
					          @pTESTVALUE,  -- TESTVALUE - decimal
							  @pCOMPID,
							  1,
							  @pUSERID,
							  GETDATE()
					        )
					SET @videntity = @@IDENTITY
					 
                  
                END 
            ELSE 
                IF @pFLAG = 'E' 
                    BEGIN

					UPDATE dbo.FORMULAVRIABLE SET   
					FIELDID =@pFIELDID,
					TESTVALUE=@pTESTVALUE,
					ISACTIVE=@pISACTIVE, 
					UPDATEDBY=@pUSERID,
					UPDATEDON=GETDATE() 
					WHERE VARID=@pVARID

					SET @videntity = @pVARID 

                    END 
                ELSE 
                    IF @pFLAG = 'D' 
                     BEGIN  
                          DELETE  FROM dbo.FORMULAVRIABLE
                          WHERE VARID=@pVARID

                          SET @videntity = @pVARID
                     END  
                        

            IF @pFlag IN ( 'I', 'E', 'D')
				BEGIN 
					IF @pFlag = 'I' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Added', 'S', 'Formula Variable', 0)
					IF @pFlag = 'E' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Edited', 'S', 'Formula Variable', 0)
					IF @pFlag = 'D' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Deleted', 'S', 'Formula Variable', 0) 
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

         SET @pERRORXML = dbo.F_ERRORXML(@vERRORID, '', 'E', 'Formula Variable', 1)

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT;

    END CATCH;
  END 
  GO