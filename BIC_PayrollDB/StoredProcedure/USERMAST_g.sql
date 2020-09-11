IF (OBJECT_ID('USERMAST_g') IS NOT NULL) 
BEGIN 
DROP PROCEDURE USERMAST_g
END
GO
CREATE PROCEDURE [dbo].[USERMAST_g]
(
 @pXMLFILE XML 
)
AS
    BEGIN 
	 
      DECLARE @pUSERID INT   
	  DECLARE @pLOGINID VARCHAR(50)   
	  DECLARE @pPASSWORD NVARCHAR(MAX)
     ------------------------------------------------------------------------------------------
	 DECLARE @verrorId INT 
     DECLARE @vspName VARCHAR(100) 
     SET @vspName = 'USERMAST_g'
     
     SELECT @pUSERID = N.C.value('@USERID[1]', 'INT'),
			@pLOGINID = N.C.value('@LOGINID[1]', 'VARCHAR(50)'),
			@pPASSWORD = N.C.value('@PASSWORD[1]', 'NVARCHAR(MAX)') 
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
			COUNTRYID,
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
			1 = CASE WHEN  LEN(@pLOGINID)>0 AND LOGINID=@pLOGINID THEN 1 ELSE 0 END 
			AND 1 = CASE WHEN  LEN(@pPASSWORD)>0 AND PASSWORD=@pPASSWORD THEN 1 ELSE 0 END 
			AND ISACTIVE=1

		END TRY 
   
		BEGIN CATCH

		SET @vERRORID = 0 - ERROR_NUMBER() 
		
		SELECT  0 - ERROR_NUMBER() AS 'ID' 

		EXECUTE LogError_i @pXMLFILE, @vERRORID OUTPUT; 

		END CATCH; 
    END 
GO
