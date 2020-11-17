 
 IF (OBJECT_ID('dbo.FORMULACALCULATION_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE dbo.FORMULACALCULATION_c
END
GO
CREATE PROCEDURE dbo.FORMULACALCULATION_c
(
	 @pXMLFILE XML ,
	 @pERRORXML XML OUT 
)
     
AS 
    BEGIN
			DECLARE 
			@pFLAG CHAR(1),
			@pCALID BIGINT,  
			@pVARID BIGINT,
			@pHEADID BIGINT, 
			@pCONDITION NVARCHAR(1000),
			@pCALCULATION NVARCHAR(1000),
			@pISEXIT bit,
			@pRESULT CHAR(3),
			@pTESTVALUE DECIMAL(21,6),
			@pISACTIVE bit,
			@pCOMPID INT, 
			@pUSERID INT, 
			@vlocal INT,
			@vspName VARCHAR(20),
			@videntity INT,
			@vERRORID INT
			 

			SET @vlocal = 0 
			SET @vspName = 'FORMULACALCULATION_c'

		  SELECT	@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'),
					@pCALID  =  N.C.value('@CALID[1]','BIGINT'),  
					@pHEADID  =  N.C.value('@HEADID[1]','BIGINT'), 
					@pCONDITION  =  N.C.value('@CONDITION[1]','NVARCHAR(1000)'), 
					@pCALCULATION  =  N.C.value('@CALCULATION[1]','NVARCHAR(1000)'), 
					@pISEXIT  =  N.C.value('@ISEXIT[1]','BIT'),  
					@pTESTVALUE=  N.C.value('@TESTVALUE[1]','DECIMAL(21,6)'),
					@pISACTIVE  =  N.C.value('@ISACTIVE[1]','BIT'), 
					@pCOMPID  =  N.C.value('@COMPID[1]','INT'),
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
					SELECT @pRESULT=RESULTNAME 
					FROM VARIABLENAME 
					WHERE Id =(SELECT COUNT(CALID) FROM FORMULACALCULATION WHERE  HEADID=@pHEADID AND COMPID=@pCOMPID)+1

					INSERT INTO dbo.FORMULACALCULATION
					        (  
					          HEADID ,
					          CONDITION ,
					          CALCULATION ,
					          ISEXIT ,
					          RESULT ,
							  COMPID,
							  ISACTIVE,
							  CREATEDBY,
							  CREATEDON
					        )
					VALUES  ( 
					          @pHEADID , -- HEADID - bigint
					          @pCONDITION , -- CONDITION - nvarchar(1000)
					          @pCALCULATION, -- CALCULATION - nvarchar(1000)
					          @pISEXIT , -- ISEXIT - bit
					          @pRESULT , -- RESULT - char(3)
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

					UPDATE dbo.FORMULACALCULATION SET   
					HEADID =@pHEADID,
					CONDITION=@pCONDITION,
					CALCULATION=@pCALCULATION,
					ISEXIT=@pISEXIT,
					ISACTIVE=@pISACTIVE, 
					UPDATEDBY=@pUSERID,
					UPDATEDON=GETDATE() 
					WHERE CALID=@pCALID

					SET @videntity = @pCALID 

                    END 
                ELSE 
                    IF @pFLAG = 'D' 
                     BEGIN  
                          DELETE  FROM dbo.FORMULACALCULATION
                          WHERE CALID=@pCALID

                          SET @videntity = @pCALID
                     END  
                        

            IF @pFlag IN ( 'I', 'E', 'D')
				BEGIN 
					IF @pFlag = 'I' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Added', 'S', 'Formula Calculation', 0)
					IF @pFlag = 'E' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Edited', 'S', 'Formula Calculation', 0)
					IF @pFlag = 'D' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Deleted', 'S', 'Formula Calculation', 0) 
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

         SET @pERRORXML = dbo.F_ERRORXML(@vERRORID, '', 'E', 'Formula Calculation', 1)

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT;

    END CATCH;
  END 
  GO