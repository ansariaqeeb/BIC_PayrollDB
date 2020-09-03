IF (OBJECT_ID('StatusTypeMaster_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE StatusTypeMaster_c
END
GO
CREATE PROCEDURE dbo.StatusTypeMaster_c
(
	 @pXMLFILE XML ,
	 @pERRORXML XML OUT 
)
     
AS 
    BEGIN
			DECLARE 
			@pFLAG CHAR(1),
			@pTYPEID INT, 
			@pTYPECODE VARCHAR(20), 
			@pDISCRIPTION nvarchar(120),
			@pISACTIVE BIT,
			@pUSERID INT, 
			@vlocal INT,
			@vspName VARCHAR(20),
			@videntity INT,
			@vERRORID INT 
			 

			SET @vlocal = 0 
			SET @vspName = 'StatusTypeMaster_c'

		  SELECT	@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'),
					@pTYPEID  =  N.C.value('@TYPEID[1]','INT'), 
					@pTYPECODE  =  N.C.value('@TYPECODE[1]','VARCHAR(20)'), 
					@pDISCRIPTION  =  N.C.value('@DISCRIPTION[1]','NVARCHAR(120)'), 
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

					INSERT INTO dbo.StatusTypeMaster 
					(   
						TYPECODE,
						DISCRIPTION,
						CREATEDON,
						CREATEDBY
					) 
				  VALUES  
					(   
						@pTYPECODE,
						@pDISCRIPTION,
						GETDATE(),
						@pUSERID
					)

					SET @videntity = @@IDENTITY
                  
                END 
            ELSE 
                IF @pFLAG = 'E' 
                    BEGIN

					UPDATE dbo.StatusTypeMaster SET 
					TYPECODE =@pTYPECODE,
					DISCRIPTION =@pDISCRIPTION,
					ISACTIVE=@pISACTIVE, 
					UPDATEDBY=@pUSERID,
					UPDATEDON=GETDATE()
					WHERE TYPEID=@pTYPEID

					SET @videntity = @pTYPEID 

                    END 
                ELSE 
                    IF @pFLAG = 'D' 
                     BEGIN  
                          DELETE  FROM dbo.StatusTypeMaster
                          WHERE TYPEID=@pTYPEID
                          SET @videntity = @pTYPEID
                     END  
                        

            IF @pFlag IN ( 'I', 'E', 'D')
				BEGIN 
					IF @pFlag = 'I' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Added', 'S', 'Company', 0)
					IF @pFlag = 'E' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Edited', 'S', 'Company', 0)
					IF @pFlag = 'D' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Deleted', 'S', 'Company', 0) 
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
  EXEC dbo.StatusTypeMaster_c @pXMLFILE = '<XMLFILE> 
  <SPXML> 
  <SPDETAILS FLAG="D" TYPEID="1" TYPECODE="4" DISCRIPTION="6" ISACTIVE="0"  USERID="1" /> 
  </SPXML> 
  </XMLFILE>', -- xml
      @pERRORXML = @pERRORXML OUT  -- xml
  
  SELECT @pERRORXML 
  
SELECT * FROM  StatusTypeMaster
*/
-- Stored Procedure


GO
