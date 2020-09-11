IF (OBJECT_ID('StatusMaster_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE StatusMaster_c
END
GO
CREATE PROCEDURE dbo.StatusMaster_c
(
	 @pXMLFILE XML ,
	 @pERRORXML XML OUT 
)
     
AS 
    BEGIN
			DECLARE 
			@pFLAG CHAR(1),
			@pSTATUSID INT, 
			@pSTATUSCODE VARCHAR(20), 
			@pTYPEID INT,
			@pDISCRIPTION NVARCHAR(120), 
			@pUSERID INT, 
			@vlocal INT,
			@vspName VARCHAR(20),
			@videntity INT,
			@vERRORID INT ,
			@pISACTIVE BIT

			SET @vlocal = 0 
			SET @vspName = 'StatusMaster_c'

		  SELECT	@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'),
					@pSTATUSID  =  N.C.value('@STATUSID[1]','INT'), 
					@pSTATUSCODE  =  N.C.value('@STATUSCODE[1]','VARCHAR(20)'), 
					@pTYPEID  =  N.C.value('@TYPEID[1]','INT'), 
					@pDISCRIPTION  =  N.C.value('@DISCRIPTION[1]','NVARCHAR(120)'), 
					@pUSERID  =  N.C.value('@USERID[1]','INT'),
					@pISACTIVE  =  N.C.value('@ISACTIVE[1]','BIT')
					 
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

					INSERT INTO dbo.StatusMaster
					(   
						STATUSCODE,
						TYPEID,
						DISCRIPTION ,
						CREATEDON,
						CREATEDBY
						
					) 
				  VALUES  
					(   
						@pSTATUSCODE,
						@pTYPEID,
						@pDISCRIPTION,
						GETDATE(),
						@pUSERID
					)

					SET @videntity = @@IDENTITY
                  
                END 
            ELSE 
                IF @pFLAG = 'E' 
                    BEGIN
					PRINT @pISACTIVE
					UPDATE dbo.StatusMaster SET 
					STATUSCODE =@pSTATUSCODE,
					TYPEID =@pTYPEID,
					DISCRIPTION =@pDISCRIPTION,
					ISACTIVE=@pISACTIVE, 
					UPDATEDBY=@pUSERID,
					UPDATEDON=GETDATE()
					WHERE STATUSID=@pSTATUSID

					SET @videntity = @pSTATUSID 

                    END 
                ELSE 
                    IF @pFLAG = 'D' 
                     BEGIN  
                          DELETE  FROM dbo.StatusMaster
                          WHERE STATUSID=@pSTATUSID

                          SET @videntity = @pSTATUSID
                     END  
                        

            IF @pFlag IN ( 'I', 'E', 'D')
				BEGIN 
					IF @pFlag = 'I' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Added', 'S', 'Status', 0)
					IF @pFlag = 'E' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Edited', 'S', 'Status', 0)
					IF @pFlag = 'D' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Deleted', 'S', 'Status', 0) 
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

         SET @pERRORXML = dbo.F_ERRORXML(@vERRORID, '', 'E', 'Company', 1)

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT;

    END CATCH;
  END

/*
  DECLARE @pERRORXML XML 
  EXEC dbo.StatusMaster_c @pXMLFILE = '<XMLFILE> 
  <SPXML> 
  <SPDETAILS FLAG="E" STATUSID="2" STATUSCODE="Female" TYPEID="2" DISCRIPTION="Female" ISACTIVE="1"  USERID="1" /> 
  </SPXML> 
  </XMLFILE>', -- xml
      @pERRORXML = @pERRORXML OUT  -- xml
  
  SELECT @pERRORXML 
  
SELECT * FROM  StatusMaster
*/
-- Stored Procedure


GO

