IF (OBJECT_ID('LK_USERMAST_g') IS NOT NULL) 
BEGIN 
DROP PROCEDURE LK_USERMAST_g
END
GO
CREATE PROCEDURE [dbo].LK_USERMAST_g
(
 @pXMLFILE XML 
)
AS
    BEGIN 
	 
      DECLARE @pUSERID INT    
	  DECLARE @pLOGINID VARCHAR(50)   
     ------------------------------------------------------------------------------------------
	 DECLARE @verrorId INT 
     DECLARE @vspName VARCHAR(100) 
     SET @vspName = 'LK_USERMAST_g'
     
     SELECT @pUSERID = N.C.value('@USERID[1]', 'INT'),
			@pLOGINID = N.C.value('@LOGINID[1]', 'VARCHAR(50)') 
     FROM   @pXMLFILE.nodes('//XMLFILE/SPXML/SPDETAILS') N ( C )
    
     EXEC DBLOG_c @pXMLFILE = @pXMLFILE, @pSPNAME = @vSPNAME
     ------------------------------------------------------------------------------------------
        
		BEGIN TRY 
			
			SELECT 
			USERID, 
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
			COUNTRYNAME,
			SecondaryEmailID ,   
			ISACTIVE, 
			ISADMIN ,
			CREATEDBY,
			CREATEDON,
			UPDATEDBY,
			UPDATEDON,
			SVRKEY,
			SVRDATE
			FROM  dbo.USERMAST
			WHERE
			1 = CASE WHEN @pUSERID=0 THEN 1 WHEN @pUSERID<>0 AND @pUSERID= CREATEDBY THEN 1 ELSE 0 END  
			

		END TRY 
   
		BEGIN CATCH

		SET @vERRORID = 0 - ERROR_NUMBER() 
		
		SELECT  0 - ERROR_NUMBER() AS 'ID' 

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT; 

		END CATCH; 
    END 
GO
