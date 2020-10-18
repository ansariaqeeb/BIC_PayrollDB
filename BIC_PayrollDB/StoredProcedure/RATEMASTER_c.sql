 
 IF (OBJECT_ID('RATEMASTER_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE dbo.RATEMASTER_c
END
GO
CREATE PROCEDURE dbo.RATEMASTER_c
(
	 @pXMLFILE XML ,
	 @pERRORXML XML OUT 
)
     
AS 
    BEGIN
			DECLARE 
			@pFLAG CHAR(1),
			@pRATEID INT, 
			@pRATECODE VARCHAR(20), 
			@pDESCRIPTION varchar(500),
			@pRATE DECIMAL(21,6),  
			@pISACTIVE bit,
			@pCOMPID INT, 
			@pUSERID INT, 
			@vlocal INT,
			@vspName VARCHAR(20),
			@videntity INT,
			@vERRORID INT,
			@pFORMULA VARCHAR(5000),
			@pIsCalculation BIT,
			@pBASEFACTORID INT

			SET @vlocal = 0 
			SET @vspName = 'RATEMASTER_c'

		  SELECT	@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'),
					@pRATEID  =  N.C.value('@RATEID[1]','INT'), 
					@pRATECODE  =  N.C.value('@RATECODE[1]','VARCHAR(20)'), 
					@pDESCRIPTION  =  N.C.value('@DESCRIPTION[1]','VARCHAR(500)'), 
					@pRATE  =  N.C.value('@RATE[1]','DECIMAL(21,6)'), 
					@pISACTIVE  =  N.C.value('@ISACTIVE[1]','BIT'), 
					@pCOMPID  =  N.C.value('@COMPID[1]','INT') ,
					@pBASEFACTORID =  N.C.value('@BASEFACTORID[1]','INT') ,
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

					INSERT INTO dbo.RATEMASTER
					(
						RATECODE,
						DESCRIPTION,
						RATE, 
						COMPID,
						BASEFACTORID,
						CREATEDON,
						CREATEDBY
					)
					VALUES
					(
						@pRATECODE,
						@pDESCRIPTION,
						@pRATE, 
						@pCOMPID,
						@pBASEFACTORID,
						GETDATE(),
						@pUSERID
					) 

					SET @videntity = @@IDENTITY
					 
                  
                END 
            ELSE 
                IF @pFLAG = 'E' 
                    BEGIN

					UPDATE dbo.RATEMASTER SET 
					RATECODE =@pRATECODE,
					DESCRIPTION =@pDESCRIPTION,
					RATE =@pRATE,
					BASEFACTORID=@pBASEFACTORID,
					ISACTIVE=@pISACTIVE, 
					UPDATEDBY=@pUSERID,
					UPDATEDON=GETDATE()
					WHERE RATEID=@pRATEID

					SET @videntity = @pRATEID 

                    END 
                ELSE 
                    IF @pFLAG = 'D' 
                     BEGIN  
                          DELETE  FROM dbo.RATEMASTER
                          WHERE RATEID=@pRATEID

                          SET @videntity = @pRATEID
                     END  
                        

            IF @pFlag IN ( 'I', 'E', 'D')
				BEGIN 
					IF @pFlag = 'I' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Added', 'S', 'Rate', 0)
					IF @pFlag = 'E' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Edited', 'S', 'Rate', 0)
					IF @pFlag = 'D' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Deleted', 'S', 'Rate', 0) 
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