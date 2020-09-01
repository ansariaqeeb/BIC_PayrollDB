IF (OBJECT_ID('COUNTRYMAST_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE COUNTRYMAST_c
END
GO
CREATE PROCEDURE dbo.COUNTRYMAST_c
(
	 @pXMLFILE XML ,
	 @pERRORXML XML OUT 
)
     
AS 
    BEGIN
			DECLARE @pFLAG CHAR(1),
			@pCOUNTRYID INT,
			@pCOUNTRYCODE VARCHAR(10), 
			@pSHORTNAME nvarchar(60),
			@pCOUNTRYNAME nvarchar(120), 
			@pISACTIVE BIT,
			@pUSERID INT, 
			@vlocal INT,
			@vspName VARCHAR(20),
			@videntity INT,
			@vERRORID INT 
			 

			SET @vlocal = 0 
			SET @vspName = 'COUNTRYMAST_c'

		  SELECT	@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'),
					@pCOUNTRYID =  N.C.value('@COUNTRYID[1]','INT'), 
					@pCOUNTRYCODE  =  N.C.value('@COUNTRYCODE[1]','VARCHAR(10)'), 
					@pSHORTNAME  =  N.C.value('@SHORTNAME[1]','NVARCHAR(60)'), 
					@pCOUNTRYNAME  =  N.C.value('@COUNTRYNAME[1]','NVARCHAR(120)'),  
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

					INSERT INTO dbo.COUNTRYMAST 
					( 
						COUNTRYNAME,
						COUNTRYCODE,
						SHORTNAME,
						ISACTIVE, 
						CREATEDBY,
						CREATEDON 
					) 
				  VALUES  
					(   @pCOUNTRYNAME , 
						@pCOUNTRYCODE,
						@pSHORTNAME,
						1,  
						@pUSERID, 
						GETDATE()
					)

					SET @videntity = @@IDENTITY
                  
                END 
            ELSE 
                IF @pFLAG = 'E' 
                    BEGIN

					UPDATE dbo.COUNTRYMAST SET 
					COUNTRYNAME=@pCOUNTRYNAME,
					COUNTRYCODE=@pCOUNTRYCODE,
					ISACTIVE=@pISACTIVE,
					SHORTNAME=@pSHORTNAME,
					UPDATEDBY=@pUSERID,
					UPDATEDON=GETDATE()
					WHERE COUNTRYID=@pCOUNTRYID

					SET @videntity = @pCOUNTRYID 

                    END 
                ELSE 
                    IF @pFLAG = 'D' 
                     BEGIN  
                          DELETE  FROM dbo.COUNTRYMAST
                          WHERE COUNTRYID=@pCOUNTRYID

                          SET @videntity = @pCOUNTRYID
                     END  
                        

            IF @pFlag IN ( 'I', 'E', 'D')
				BEGIN 
					IF @pFlag = 'I' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Added', 'S', 'Country', 0)
					IF @pFlag = 'E' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Edited', 'S', 'Country', 0)
					IF @pFlag = 'D' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Deleted', 'S', 'Country', 0) 
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

         SET @pERRORXML = dbo.F_ERRORXML(@vERRORID, '', 'E', 'Country', 1)

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT;

    END CATCH;
  END

/*
  DECLARE @pERRORXML XML 
  EXEC dbo.COUNTRYMAST_c @pXMLFILE = '<XMLFILE> 
  <SPXML> 
  <SPDETAILS FLAG="I" COUNTRYID="1" COUNTRYCODE="IND" SHORTNAME="India" COUNTRYNAME="India"  ISACTIVE="1"  USERID="1" /> 
  </SPXML> 
  </XMLFILE>', -- xml
      @pERRORXML = @pERRORXML OUT  -- xml
  
  SELECT @pERRORXML 
  
SELECT * FROM  COUNTRYMAST
*/
-- Stored Procedure


GO
