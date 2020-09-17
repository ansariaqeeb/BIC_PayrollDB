IF (OBJECT_ID('EMPLOYEE_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE EMPLOYEE_c
END
GO
CREATE PROCEDURE dbo.EMPLOYEE_c
(
	 @pXMLFILE XML ,
	 @pERRORXML XML OUT 
)
     
AS 
    BEGIN
			DECLARE 
			@pFLAG CHAR(1),
			@pEMPID bigint,
			@pEMPCODE nvarchar(20),
			@pTITLE varchar(5)  ,
			@pFIRSTNAME nvarchar(100)  ,
			@pMIDDLENAME nvarchar(100)  ,
			@pLASTNAME nvarchar(100)  ,
			@pNICKNAME nvarchar(100)   ,
			@pSTARTDATE date,
			@pDOB date,
			@pNATIONALID nvarchar(30)   , 
			@pPASSPORTNO nvarchar(30)  ,
			@pCOUNTRYOFISSUE nvarchar(30)  ,
			@pGENDER nvarchar(10)  ,
			@pMARITALSTATUS nvarchar(10)  ,
			@pDEPENDENT nvarchar(5)  ,
			@pYEARSOFSERVICE nvarchar(5)   ,
			@pADDR1COMPLEXNAME nvarchar(500)  ,
			@pADDR1STREETNO nvarchar(500)  ,
			@pADDR1STREETNAME nvarchar(500)  ,
			@pADDR1POSTALCODE nvarchar(255)   ,
			@pADDR1COUNTRYNAME nvarchar(50)  ,
			@pADDR1STATENAME nvarchar(50)  ,
			@pADDR1CITYNAME nvarchar(50)  , 
			@pADDR2SAMEASADDR1 bit,
			@pADDR2COMPLEXNAME nvarchar(500)  ,
			@pADDR2STREETNO nvarchar(500)  ,
			@pADDR2STREETNAME nvarchar(500)  ,
			@pADDR2POSTALCODE nvarchar(255)   ,
			@pADDR2COUNTRYNAME nvarchar(50)  ,
			@pADDR2STATENAME nvarchar(50)  ,
			@pADDR2CITYNAME nvarchar(50)  , 
			@pWORKPHONE nvarchar(15)  ,
			@pHOMEPHONE nvarchar(15)  ,
			@pCELLNO nvarchar(15)  ,
			@pFAXNO nvarchar(15)  ,
			@pSPOUSENAME nvarchar(100)  ,
			@pSPOUSENO nvarchar(15)  ,
			@pEMAILID nvarchar(100)  ,
			@pDAILYRATE DECIMAL(21, 6)  ,
			@pWEEKLYRATE DECIMAL(21, 6)  ,
			@pMONTHLYRATE DECIMAL(21, 6)  ,
			@pHOURLYRATE DECIMAL(21, 6)  ,
			@pPREVIUSYEARLYPAY DECIMAL(21, 6)  ,
			@pLASTINCREAMENTDATE DATE,
			@pTERMINATIONDATE DATE,
			@pAVGHOURPERDAY DECIMAL(21, 6)  ,
			@pHOURPERWEEK DECIMAL(21, 6)  ,
			@pDAYSPERMONTH DECIMAL(21, 6)  ,
			@pWEEKDAYS nvarchar(200)  ,
			@pANNUALSTANDARDLEAVE DECIMAL(21, 6)  ,
			@pANNUALSICKLEAVE DECIMAL(21, 6)  ,
			@pANNUALOPTIONALLEAVE DECIMAL(21, 6)  ,
			@pISACTIVE bit,
			@pCOMPID INT  ,
			@pCREATEDON datetime    ,
			@pCREATEDBY int    ,
			@pUPDATEDON datetime    , 
			@pUPDATEDBY int, 
			@pUSERID INT, 
			@vlocal INT,
			@vspName VARCHAR(20),
			@videntity INT,
			@vERRORID INT 
			 

			SET @vlocal = 0 
			SET @vspName = 'EMPLOYEE_c'

		  	SELECT	@pFLAG				=  N.C.value('@FLAG[1]', 'CHAR(1)'),
					@pEMPID			=  N.C.value('@EMPID[1]','INT'), 
					@pEMPCODE			=  N.C.value('@EMPCODE[1]','VARCHAR(20)'), 
					@pTITLE			=  N.C.value('@TITLE[1]','NVARCHAR(5)'), 
					@pFIRSTNAME  =  N.C.value('@FIRSTNAME[1]','NVARCHAR(100)'), 
					@pMIDDLENAME		=  N.C.value('@MIDDLENAME[1]','NVARCHAR(100)'),
					@pLASTNAME	=  N.C.value('@LASTNAME[1]','NVARCHAR(100)'),
					@pNICKNAME	=  N.C.value('@NICKNAME[1]','NVARCHAR(100)'),
					@pSTARTDATE	=  N.C.value('@STARTDATE[1]','DATE'),
					@pDOB	=  N.C.value('@DOB[1]','DATE'),
					@pNATIONALID		=  N.C.value('@NATIONALID[1]','NVARCHAR(30)'),
					@pPASSPORTNO	=  N.C.value('@PASSPORTNO[1]','NVARCHAR(30)'),
					@pCOUNTRYOFISSUE	=  N.C.value('@COUNTRYOFISSUE[1]','NVARCHAR(30)'),
					@pGENDER		=  N.C.value('@GENDER[1]','NVARCHAR(10)'),
					@pMARITALSTATUS	=  N.C.value('@MARITALSTATUS[1]','NVARCHAR(20)'),
					@pDEPENDENT	=  N.C.value('@DEPENDENT[1]','NVARCHAR(10)'),
					@pYEARSOFSERVICE	=  N.C.value('@YEARSOFSERVICE[1]','NVARCHAR(10)'),
					@pADDR1COMPLEXNAME	=  N.C.value('@ADDR1COMPLEXNAME[1]','NVARCHAR(50)'),
					@pADDR1STREETNO		=  N.C.value('@ADDR1STREETNO[1]','NVARCHAR(50)'),
					@pADDR1STREETNAME		=  N.C.value('@ADDR1STREETNAME[1]','NVARCHAR(20)'),
					@pADDR1POSTALCODE	=  N.C.value('@ADDR1POSTALCODE[1]','NVARCHAR(20)'),
					@pADDR1COUNTRYNAME				=  N.C.value('@ADDR1COUNTRYNAME[1]','NVARCHAR(20)'),
					@pADDR1STATENAME			=  N.C.value('@ADDR1STATENAME[1]','NVARCHAR(120)'),
					@pADDR1CITYNAME			=  N.C.value('@ADDR1CITYNAME[1]','NVARCHAR(500)'),
					@pADDR2SAMEASADDR1		=  N.C.value('@ADDR2SAMEASADDR1[1]','BIT'),
					@pADDR2COMPLEXNAME	=  N.C.value('@ADDR2COMPLEXNAME[1]','NVARCHAR(500)'),
					@pADDR2STREETNO				=  N.C.value('@ADDR2STREETNO[1]','NVARCHAR(500)'), 
					@pADDR2STREETNAME				=  N.C.value('@ADDR2STREETNAME[1]','NVARCHAR(500)'), 
					@pADDR2POSTALCODE				=  N.C.value('@ADDR2POSTALCODE[1]','NVARCHAR(50)'), 
					@pADDR2COUNTRYNAME				=  N.C.value('@ADDR2COUNTRYNAME[1]','NVARCHAR(30)'), 
					@pADDR2STATENAME				=  N.C.value('@ADDR2STATENAME[1]','NVARCHAR(30)'), 
					@pADDR2CITYNAME				=  N.C.value('@ADDR2CITYNAME[1]','NVARCHAR(30)'), 
					@pWORKPHONE				=  N.C.value('@WORKPHONE[1]','NVARCHAR(20)'), 
					@pHOMEPHONE				=  N.C.value('@HOMEPHONE[1]','NVARCHAR(20)'), 
					@pCELLNO				=  N.C.value('@CELLNO[1]','NVARCHAR(20)'), 
					@pFAXNO				=  N.C.value('@FAXNO[1]','NVARCHAR(20)'), 
					@pSPOUSENAME				=  N.C.value('@SPOUSENAME[1]','NVARCHAR(100)'), 
					@pSPOUSENO				=  N.C.value('@SPOUSENO[1]','NVARCHAR(30)'), 
					@pEMAILID				=  N.C.value('@EMAILID[1]','NVARCHAR(100)'), 
					@pDAILYRATE				=  N.C.value('@DAILYRATE[1]','DECIMAL(21, 6)'), 
					@pWEEKLYRATE				=  N.C.value('@WEEKLYRATE[1]','DECIMAL(21, 6)'), 
					@pMONTHLYRATE				=  N.C.value('@MONTHLYRATE[1]','DECIMAL(21, 6)'), 
					@pHOURLYRATE				=  N.C.value('@HOURLYRATE[1]','DECIMAL(21, 6)'), 
					@pPREVIUSYEARLYPAY				=  N.C.value('@PREVIUSYEARLYPAY[1]','DECIMAL(21, 6)'), 
					@pLASTINCREAMENTDATE				=  N.C.value('@LASTINCREAMENTDATE[1]','DATE'), 
					@pTERMINATIONDATE				=  N.C.value('@TERMINATIONDATE[1]','DATE'), 
					@pAVGHOURPERDAY				=  N.C.value('@AVGHOURPERDAY[1]','DECIMAL(21, 6)'), 
					@pHOURPERWEEK				=  N.C.value('@HOURPERWEEK[1]','DECIMAL(21, 6)'), 
					@pDAYSPERMONTH				=  N.C.value('@DAYSPERMONTH[1]','DECIMAL(21, 6)'), 
					@pWEEKDAYS				=  N.C.value('@WEEKDAYS[1]','NVARCHAR(200)'),
					@pANNUALSTANDARDLEAVE=  N.C.value('@ANNUALSTANDARDLEAVE[1]','DECIMAL(21, 6)'),
					@pANNUALSICKLEAVE=  N.C.value('@ANNUALSICKLEAVE[1]','DECIMAL(21, 6)'),
					@pANNUALOPTIONALLEAVE=  N.C.value('@ANNUALOPTIONALLEAVE[1]','DECIMAL(21, 6)'), 
					@pCOMPID			=  N.C.value('@COMPID[1]','INT'),
					@pISACTIVE			=  N.C.value('@ISACTIVE[1]','BIT'),
					@pUSERID			=  N.C.value('@USERID[1]','INT')  
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

					INSERT INTO EMPLOYEE
					( 
						 EMPCODE,  
						 TITLE,  
						 FIRSTNAME,   
						 MIDDLENAME,   
						 LASTNAME,   
						 NICKNAME,   
						 STARTDATE, 
						 DOB,  
						 NATIONALID,  
						 PASSPORTNO,   
						 COUNTRYOFISSUE, 
						 GENDER,   
						 MARITALSTATUS,  
						 DEPENDENT,   
						 YEARSOFSERVICE,   
						 ADDR1COMPLEXNAME,   
						 ADDR1STREETNO,   
						 ADDR1STREETNAME,   
						 ADDR1POSTALCODE,   
						 ADDR1COUNTRYNAME,   
						 ADDR1STATENAME,   
						 ADDR1CITYNAME,  
						 ADDR2SAMEASADDR1,  
						 ADDR2COMPLEXNAME,   
						 ADDR2STREETNO,   
						 ADDR2STREETNAME,   
						 ADDR2POSTALCODE,   
						 ADDR2COUNTRYNAME,   
						 ADDR2STATENAME,   
						 ADDR2CITYNAME,   
						 WORKPHONE,   
						 HOMEPHONE,   
						 CELLNO,   
						 FAXNO,   
						 SPOUSENAME,   
						 SPOUSENO,   
						 EMAILID,   
						 DAILYRATE, 
						 WEEKLYRATE,  
						 MONTHLYRATE,  
						 HOURLYRATE,  
						 PREVIUSYEARLYPAY,  
						 LASTINCREAMENTDATE,  
						 TERMINATIONDATE,  
						 AVGHOURPERDAY,  
						 HOURPERWEEK,  
						 DAYSPERMONTH, 
						 WEEKDAYS,   
						 ANNUALSTANDARDLEAVE, 
						 ANNUALSICKLEAVE, 
						 ANNUALOPTIONALLEAVE, 
						 ISACTIVE, 
						 COMPID, 
						 CREATEDON,  
						 CREATEDBY  
					)
					VALUES	
					( 			
						@pEMPCODE,				
						@pTITLE	,				
						@pFIRSTNAME	,			
						@pMIDDLENAME,			
						@pLASTNAME,				
						@pNICKNAME,				
						@pSTARTDATE	,			
						@pDOB,					
						@pNATIONALID,			
						@pPASSPORTNO,			
						@pCOUNTRYOFISSUE,		
						@pGENDER,				
						@pMARITALSTATUS,			
						@pDEPENDENT,				
						@pYEARSOFSERVICE,		
						@pADDR1COMPLEXNAME,		
						@pADDR1STREETNO,			
						@pADDR1STREETNAME,		
						@pADDR1POSTALCODE,		
						@pADDR1COUNTRYNAME,		
						@pADDR1STATENAME,		
						@pADDR1CITYNAME,			
						@pADDR2SAMEASADDR1	,	
						@pADDR2COMPLEXNAME,		
						@pADDR2STREETNO,			
						@pADDR2STREETNAME,		
						@pADDR2POSTALCODE,		
						@pADDR2COUNTRYNAME,		
						@pADDR2STATENAME,		
						@pADDR2CITYNAME,			
						@pWORKPHONE,				
						@pHOMEPHONE,				
						@pCELLNO,				
						@pFAXNO,					
						@pSPOUSENAME,			
						@pSPOUSENO,				
						@pEMAILID,				
						@pDAILYRATE,				
						@pWEEKLYRATE,			
						@pMONTHLYRATE,			
						@pHOURLYRATE,			
						@pPREVIUSYEARLYPAY,		
						@pLASTINCREAMENTDATE,	
						@pTERMINATIONDATE,		
						@pAVGHOURPERDAY,			
						@pHOURPERWEEK,			
						@pDAYSPERMONTH,			
						@pWEEKDAYS,				
						@pANNUALSTANDARDLEAVE,	
						@pANNUALSICKLEAVE,		
						@pANNUALOPTIONALLEAVE, 
						@pISACTIVE,	 
						@pCOMPID,
						GETDATE(),
						@pUSERID				
					)

					SET @videntity = @@IDENTITY
                  
                END 
            ELSE 
                IF @pFLAG = 'E' 
                    BEGIN

						UPDATE dbo.EMPLOYEE SET 
						EMPCODE			=@pEMPCODE,			
						TITLE				=@pTITLE,				
						FIRSTNAME			=@pFIRSTNAME,			
						MIDDLENAME			=@pMIDDLENAME,			
						LASTNAME			=@pLASTNAME,			
						NICKNAME			=@pNICKNAME,			
						STARTDATE			=@pSTARTDATE,			
						DOB				=@pDOB,				
						NATIONALID			=@pNATIONALID	,		
						PASSPORTNO			=@pPASSPORTNO,			
						COUNTRYOFISSUE		=@pCOUNTRYOFISSUE,		
						GENDER				=@pGENDER	,			
						MARITALSTATUS		=@pMARITALSTATUS,		
						DEPENDENT			=@pDEPENDENT,			
						YEARSOFSERVICE		=@pYEARSOFSERVICE,		
						ADDR1COMPLEXNAME	=@pADDR1COMPLEXNAME	,
						ADDR1STREETNO		=@pADDR1STREETNO,		
						ADDR1STREETNAME	=@pADDR1STREETNAME,	
						ADDR1POSTALCODE	=@pADDR1POSTALCODE,	
						ADDR1COUNTRYNAME	=@pADDR1COUNTRYNAME,	
						ADDR1STATENAME		=@pADDR1STATENAME,		
						ADDR1CITYNAME		=@pADDR1CITYNAME,		
						ADDR2SAMEASADDR1	=@pADDR2SAMEASADDR1,	
						ADDR2COMPLEXNAME	=@pADDR2COMPLEXNAME	,
						ADDR2STREETNO		=@pADDR2STREETNO,		
						ADDR2STREETNAME	=@pADDR2STREETNAME,	
						ADDR2POSTALCODE	=@pADDR2POSTALCODE,	
						ADDR2COUNTRYNAME	=@pADDR2COUNTRYNAME	,
						ADDR2STATENAME		=@pADDR2STATENAME,		
						ADDR2CITYNAME		=@pADDR2CITYNAME,		
						WORKPHONE			=@pWORKPHONE,			
						HOMEPHONE			=@pHOMEPHONE,			
						CELLNO				=@pCELLNO,				
						FAXNO				=@pFAXNO,				
						SPOUSENAME			=@pSPOUSENAME,			
						SPOUSENO			=@pSPOUSENO,			
						EMAILID			=@pEMAILID,			
						DAILYRATE			=@pDAILYRATE,			
						WEEKLYRATE			=@pWEEKLYRATE,			
						MONTHLYRATE		=@pMONTHLYRATE	,	
						HOURLYRATE			=@pHOURLYRATE,			
						PREVIUSYEARLYPAY	=@pPREVIUSYEARLYPAY	,
						LASTINCREAMENTDATE	=@pLASTINCREAMENTDATE,	
						TERMINATIONDATE	=@pTERMINATIONDATE	,
						AVGHOURPERDAY		=@pAVGHOURPERDAY,		
						HOURPERWEEK		=@pHOURPERWEEK	,	
						DAYSPERMONTH		=@pDAYSPERMONTH	,	
						WEEKDAYS			=@pWEEKDAYS,			
						ANNUALSTANDARDLEAVE=@pANNUALSTANDARDLEAVE,
						ANNUALSICKLEAVE	=@pANNUALSICKLEAVE,	
						ANNUALOPTIONALLEAVE=@pANNUALOPTIONALLEAVE,
						ISACTIVE			=@pISACTIVE		,	
						COMPID				=@pCOMPID,				
						UPDATEDON			=GETDATE(),			
						UPDATEDBY			=@pUSERID
						WHERE EMPID=@pEMPID

					SET @videntity = @pEMPID 

                    END 
                ELSE 
                    IF @pFLAG = 'D' 
                     BEGIN  
                          DELETE  FROM dbo.EMPLOYEE
                          WHERE EMPID=@pEMPID

                          SET @videntity = @pEMPID
                     END  
                        

            IF @pFlag IN ( 'I', 'E', 'D')
				BEGIN 
					IF @pFlag = 'I' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Added', 'S', 'Employee', 0)
					IF @pFlag = 'E' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Edited', 'S', 'Employee', 0)
					IF @pFlag = 'D' SET @pERRORXML = dbo.F_ERRORXML(@vIDENTITY, 'Successfully Deleted', 'S', 'Employee', 0) 
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
GO
