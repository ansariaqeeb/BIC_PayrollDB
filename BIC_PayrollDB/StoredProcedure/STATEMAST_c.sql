IF (OBJECT_ID('STATEMAST_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE STATEMAST_c
END
GO
CREATE PROCEDURE dbo.STATEMAST_c
(
	 @pXMLFILE XML ,
	 @pERRORXML XML OUT 
)
     
AS 
    BEGIN
			DECLARE @pFLAG CHAR(1),
			@pSTATEID INT,
			@pCOUNTRYID INT,
			@pSTATECODE nvarchar(20), 
			@pSHORTNAME nvarchar(60),
			@pSTATENAME nvarchar(120), 
			@pISACTIVE BIT,
			@pUSERID INT, 
			@vlocal INT,
			@vspName VARCHAR(20),
			@videntity INT,
			@vERRORID INT 
			 

			SET @vlocal = 0 
			SET @vspName = 'STATEMAST_c'

		  SELECT	@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'),
					@pSTATEID =  N.C.value('@STATEID[1]','INT'), 
					@pCOUNTRYID =  N.C.value('@COUNTRYID[1]','INT'), 
					@pSTATECODE  =  N.C.value('@STATECODE[1]','NVARCHAR(20)'), 
					@pSHORTNAME  =  N.C.value('@SHORTNAME[1]','NVARCHAR(60)'), 
					@pSTATENAME  =  N.C.value('@STATENAME[1]','NVARCHAR(120)'),  
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

					INSERT INTO dbo.STATEMAST 
					(  
						STATECODE,
						SHORTNAME,
						STATENAME,
						COUNTRYID,
						ISACTIVE,
						CREATEDON,
						CREATEDBY 
					) 
				  VALUES  
					(   @pSTATECODE , 
						@pSHORTNAME,
						@pSTATENAME,
						@pCOUNTRYID,
						1,   
						GETDATE(),
						@pUSERID
					)

					SET @videntity = @@IDENTITY
                  
                END 
            ELSE 
                IF @pFLAG = 'E' 
                    BEGIN

					UPDATE dbo.STATEMAST SET 
					STATECODE=@pSTATECODE,
					SHORTNAME=@pSHORTNAME,
					ISACTIVE=@pISACTIVE,
					STATENAME=@pSTATENAME,
					COUNTRYID=@pCOUNTRYID,
					UPDATEDBY=@pUSERID,
					UPDATEDON=GETDATE()
					WHERE STATEID=@pSTATEID

					SET @videntity = @pSTATEID 

                    END 
                ELSE 
                    IF @pFLAG = 'D' 
                     BEGIN  
                          DELETE  FROM dbo.STATEMAST
                          WHERE STATEID=@pSTATEID

                          SET @videntity = @pSTATEID
                     END  
                        

            IF @pFlag IN ( 'I', 'E', 'D')
				BEGIN 
					IF @pFlag = 'I' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Added', 'S', 'State', 0)
					IF @pFlag = 'E' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Edited', 'S', 'State', 0)
					IF @pFlag = 'D' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Deleted', 'S', 'State', 0) 
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

         SET @pERRORXML = dbo.F_ERRORXML(@vERRORID, '', 'E', 'State', 1)

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT;

    END CATCH;
  END

/*
  DECLARE @pERRORXML XML 
  EXEC dbo.STATEMAST_c @pXMLFILE = '<XMLFILE> 
  <SPXML> 
  <SPDETAILS FLAG="I" STATEID="2" COUNTRYID="3" STATECODE="MH" SHORTNAME="Maha" STATENAME="Maharashtra"  ISACTIVE="1"  USERID="1" /> 
  </SPXML> 
  </XMLFILE>', -- xml
      @pERRORXML = @pERRORXML OUT  -- xml
  
  SELECT @pERRORXML 
  
SELECT * FROM  STATEMAST
*/
-- Stored Procedure


GO
