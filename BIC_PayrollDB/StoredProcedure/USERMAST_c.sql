IF (OBJECT_ID('USERMAST_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE USERMAST_c
END
GO
CREATE PROCEDURE dbo.USERMAST_c
(
	 @pXMLFILE XML ,
	 @pERRORXML XML OUT 
)
     
AS 
    BEGIN
			DECLARE @pFLAG CHAR(1),
			@pUSERID INT,
			@pLOGINID VARCHAR(50), 
			@pEmail NVARCHAR(300),
			@pMobileNo VARCHAR(18),
			@pMobileVerify BIT,
			@pEmailVerify  BIT,  
			@pFNAME VARCHAR(50),
			@pMNAME VARCHAR(50),
			@pLNAME VARCHAR(50) ,
			@pDOB DATE,
			@pADDRESS VARCHAR(1000),  
			@pPASSWORD NVARCHAR(MAX),
			@pSecondaryEmailID NVARCHAR(300),
			@pISACTIVE BIT,
			@pISADMIN BIT,
			@vlocal INT,
			@vspName VARCHAR(20),
			@videntity INT,
			@vERRORID INT 
			 

			SET @vlocal = 0 
			SET @vspName = 'USERMAST_c'

		  SELECT	@pFLAG = N.C.value('@FLAG[1]', 'CHAR(1)'),
					@pUSERID =  N.C.value('@USERID[1]','INT'), 
					@pEmail  =  N.C.value('@Email[1]','NVARCHAR(300)'), 
					@pLOGINID  =  N.C.value('@LOGINID[1]','VARCHAR(50)'), 
					@pPASSWORD  =  N.C.value('@PASSWORD[1]','NVARCHAR(MAX)'), 
					@pISADMIN =  N.C.value('@ISADMIN[1]','BIT'),
					@pISACTIVE  =  N.C.value('@ISACTIVE[1]','BIT'), 
					@pMobileNo = N.C.value('@MobileNo[1]','VARCHAR(18)'),
					@pMobileVerify = N.C.value('@MobileVerify[1]','BIT'),
					@pEmailVerify = N.C.value('@EmailVerify[1]','BIT'),
					@pFNAME = N.C.value('@FNAME[1]','VARCHAR(50)'),
					@pMNAME = N.C.value('@FNAME[1]','VARCHAR(50)'),
					@pLNAME = N.C.value('@LNAME[1]','VARCHAR(50)'),
					@pDOB = N.C.value('@DOB[1]','DATE'),
					@pADDRESS = N.C.value('@ADDRESS[1]','VARCHAR(1000)'),
					@pSecondaryEmailID = N.C.value('@SecondaryEmailID[1]','NVARCHAR(300)')
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

					INSERT INTO USERMAST
					(
						LOGINID ,  
						Email ,
						MobileNo ,
						MobileVerify ,
						EmailVerify , 
						FNAME ,
						MNAME ,
						LNAME ,
						DOB ,
						ADDRESS ,
						PASSWORD, 
						SecondaryEmailID ,   
						ISACTIVE, 
						ISADMIN ,
						CREATEDBY,
						CREATEDON
					) 
				  VALUES  
					(   @pLOGINID , 
						@pEmail,
						@pMobileNo,  
						@pMobileVerify,
						@pEmailVerify,
					    @pFNAME,
						@pMNAME,
						@pLNAME,
						@pDOB,
						@pADDRESS,
						@pPASSWORD ,
						@pSecondaryEmailID,
						1,
						0,
						0,
						GETDATE()
					)

					SET @videntity = @@IDENTITY
                  
                END 
            ELSE 
                IF @pFLAG = 'E' 
                    BEGIN

					UPDATE dbo.USERMAST SET 
					LOGINID=@pLOGINID,
					Email=@pEmail,
					MobileNo=@pMobileNo,
					PASSWORD=@pPASSWORD,
					MobileVerify=@pMobileVerify,
					EmailVerify=@pEmailVerify,
					FNAME=@pFNAME,
					MNAME =@pMNAME,
					LNAME=@pLNAME,
					DOB=@pDOB,
					ADDRESS=@pADDRESS,
					SecondaryEmailID=@pSecondaryEmailID,
					UPDATEBY=@pUSERID,
					UPDATEDON=GETDATE()
					WHERE USERID=@pUSERID

					SET @videntity = @pUSERID 

                    END 
                ELSE 
                    IF @pFLAG = 'D' 
                     BEGIN  
                          DELETE  FROM dbo.USERMAST
                          WHERE   USERID = @pUSERID  

                          SET @videntity = @pUSERID
                     END  
                        

            IF @pFlag IN ( 'I', 'E', 'D')
				BEGIN 
					IF @pFlag = 'I' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Added', 'S', 'User', 0)
					IF @pFlag = 'E' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Edited', 'S', 'User', 0)
					IF @pFlag = 'D' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Deleted', 'S', 'User', 0) 
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

         SET @pERRORXML = dbo.F_ERRORXML(@vERRORID, '', 'E', 'User', 1)

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT;

    END CATCH;
  END

/*
  DECLARE @pERRORXML XML 
  EXEC dbo.USERMAST_c @pXMLFILE = '<XMLFILE> 
  <SPXML> 
  <SPDETAILS FLAG="D" USERID="1" Email="aqeeb1.ansari@gmaill.com" LOGINID="admin1" PASSWORD="1234561" ISADMIN="0" ISACTIVE="0"  MobileNo="12345678901"  MobileVerify="1"  EmailVerify="1" FNAME="Aqeeb1" MNAME="K1" LNAME="Ansari1" DOB="2000-09-18" ADDRESS="qwertyuiop1" SecondaryEmailID="asd1@gmail.com"  /> 
  </SPXML> 
  </XMLFILE>', -- xml
      @pERRORXML = @pERRORXML OUT  -- xml
  
  SELECT @pERRORXML 
  
SELECT * FROM  USERMAST
*/
-- Stored Procedure


GO
