IF (OBJECT_ID('CITYMAST_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE CITYMAST_c
END
GO
CREATE PROCEDURE dbo.CITYMAST_c
(
	 @pXMLFILE XML ,
	 @pERRORXML XML OUT 
)
     
AS 
    BEGIN
			DECLARE @pFLAG CHAR(1),
			@pCITYID INT,
			@pCOUNTRYID INT,
			@pSTATEID INT,
			@pCITYCODE VARCHAR(20), 
			@pCITYNAME nvarchar(120), 
			@pISACTIVE BIT,
			@pUSERID INT, 
			@vlocal INT,
			@vspName VARCHAR(20),
			@videntity INT,
			@vERRORID INT 
			 

			SET @vlocal = 0 
			SET @vspName = 'CITYMAST_c'

		  SELECT	@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'),
					@pCITYID =  N.C.value('@CITYID[1]','INT'), 
					@pCOUNTRYID =  N.C.value('@COUNTRYID[1]','INT'), 
					@pSTATEID =  N.C.value('@STATEID[1]','INT'), 
					@pCITYCODE  =  N.C.value('@CITYCODE[1]','VARCHAR(20)'), 
					@pCITYNAME  =  N.C.value('@CITYNAME[1]','NVARCHAR(120)'),   
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

					INSERT INTO dbo.CITYMAST 
					(  
							CITYCODE,
							CITYNAME,
							COUNTRYID,
							STATEID,
							ISACTIVE, 
							CREATEDBY,
							CREATEDON 
					) 
				  VALUES  
					(   
						@pCITYCODE,
						@pCITYNAME,
						@pCOUNTRYID,
						@pSTATEID,
						1,  
						@pUSERID, 
						GETDATE()
					)

					SET @videntity = @@IDENTITY
                  
                END 
            ELSE 
                IF @pFLAG = 'E' 
                    BEGIN

					UPDATE dbo.CITYMAST SET 
					CITYCODE=@pCITYCODE,
					CITYNAME=@pCITYNAME,
					COUNTRYID=@pCOUNTRYID,
					STATEID=@pSTATEID,
					ISACTIVE=@pISACTIVE, 
					UPDATEDBY=@pUSERID,
					UPDATEDON=GETDATE()
					WHERE CITYID=@pCITYID

					SET @videntity = @pCITYID 

                    END 
                ELSE 
                    IF @pFLAG = 'D' 
                     BEGIN  
                          DELETE  FROM dbo.CITYMAST
                          WHERE CITYID=@pCITYID

                          SET @videntity = @pCOUNTRYID
                     END  
                        

            IF @pFlag IN ( 'I', 'E', 'D')
				BEGIN 
					IF @pFlag = 'I' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Added', 'S', 'City', 0)
					IF @pFlag = 'E' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Edited', 'S', 'City', 0)
					IF @pFlag = 'D' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Deleted', 'S', 'City', 0) 
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

         SET @pERRORXML = dbo.F_ERRORXML(@vERRORID, '', 'E', 'City', 1)

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT;

    END CATCH;
  END

/*
  DECLARE @pERRORXML XML 
  EXEC dbo.CITYMAST_c @pXMLFILE = '<XMLFILE> 
  <SPXML> 
  <SPDETAILS FLAG="I" CITYID="2" COUNTRYID="3" STATEID="3" CITYCODE="AUR" CITYNAME="Aurangabad"  ISACTIVE="1"  USERID="1" /> 
  </SPXML> 
  </XMLFILE>', -- xml
      @pERRORXML = @pERRORXML OUT  -- xml
  
  SELECT @pERRORXML 
  
SELECT * FROM  CITYMAST
*/
-- Stored Procedure


GO
