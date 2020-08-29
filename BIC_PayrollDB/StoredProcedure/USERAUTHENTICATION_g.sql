IF (OBJECT_ID('USERAUTHENTICATION_g') IS NOT NULL) 
BEGIN 
DROP PROCEDURE dbo.USERAUTHENTICATION_g
END
GO
CREATE PROCEDURE [dbo].[USERAUTHENTICATION_g]
      (
        @pLOGINID VARCHAR(120) ,
        @pPASSWORD VARCHAR(20) ,
        @pXML XML = ''
      )
AS
BEGIN
            BEGIN TRY     

                  DECLARE @vSPNAME VARCHAR(15);
                  DECLARE @ErrorLogID INT; 
                  DECLARE @tCOMPNAME VARCHAR(30);
                  DECLARE @tCOMPUSER VARCHAR(30);
                  DECLARE @tCOMPIPADDRESS VARCHAR(30);
                  DECLARE @tBROWSERNM VARCHAR(30);
                  DECLARE @tBROWSERVER VARCHAR(10);
                  DECLARE @tATTEMPTNO VARCHAR(10);
                  DECLARE @tISSUCESS VARCHAR(10);
                  DECLARE @tISLOCKED VARCHAR(10);
                  DECLARE @tISDOMAINVALID BIT;
                  DECLARE @tIDENTITY INT; 
                  DECLARE @tTIMEZONE INT;
                  DECLARE @tROLEID INT;
                  DECLARE @tUSERID INT;
                  DECLARE @pwd VARBINARY(MAX);
                  DECLARE @strpwd NVARCHAR(MAX)= '';
                  DECLARE @tEMAILID VARCHAR(100);
				  

                  DECLARE @vISHRHOD BIT = 0;

                  DECLARE @vIDENTITY INT;
				  IF EXISTS ( SELECT UM.USERID FROM USERMAST UM WHERE UM.LOGINID = @pLOGINID 
				  AND CONVERT(VARCHAR(50), DECRYPTBYPASSPHRASE('HellowHoWAreYouPJNPS', PASSWORD)) = @pPASSWORD )
                  BEGIN
						SET @tATTEMPTNO = '0';
						SET @tISSUCESS = '1';
						SET @tISLOCKED = '0';   
					 
						INSERT INTO LOGINLOG
						( LOGINID, TRYPASSWORD, COMPNAME, COMPUSER, COMPIPADDRESS, BROWSERNM, BROWSERVER, ATTEMPTNO, ISSUCESS, ISLOCKED )
						VALUES
						( @pLOGINID, @pPASSWORD, @tCOMPNAME, @tCOMPUSER, @tCOMPIPADDRESS, @tBROWSERNM, @tBROWSERVER, @tATTEMPTNO, @tISSUCESS, @tISLOCKED ); 

						SET @vIDENTITY = @@IDENTITY;

                        SELECT DISTINCT
						um.USERID,  
						ISNULL(um.FNAME, '') + ' ' + ISNULL(um.LNAME, '') + ' (' + um.LOGINID + ')' AS LOGINID, 
						@pPASSWORD AS PASSWORD,  
						dbo.F_GetPortalProfileImg(0, um.USERID, 0, 0) IMGDESC,   
						um.LOGINID USERNAME,  
						@vIDENTITY AS LOGID 
                        FROM
                        USERMAST um 
                        WHERE
                        (um.LOGINID = @pLOGINID OR um.Email=@pLOGINID) 
                        AND CONVERT(VARCHAR(50), DECRYPTBYPASSPHRASE('HellowHoWAreYouPJNPS', PASSWORD)) = @pPASSWORD
                        AND um.ISACTIVE = 1;
              
                               
                   END
				  ELSE
                  BEGIN 
                       SET @tATTEMPTNO = '0';
                       SET @tISSUCESS = '0';
                       SET @tISLOCKED = '0';            
                       INSERT INTO dbo.LOGINLOG
                       ( LOGINID, TRYPASSWORD, COMPNAME, COMPUSER, COMPIPADDRESS, BROWSERNM, BROWSERVER, ATTEMPTNO, ISSUCESS, ISLOCKED )
                       VALUES
                       ( @pLOGINID, @pPASSWORD, @tCOMPNAME, @tCOMPUSER, @tCOMPIPADDRESS, @tBROWSERNM, @tBROWSERVER, @tATTEMPTNO, @tISSUCESS, @tISLOCKED );
                       
					   SELECT -1 AS USERID, @pLOGINID AS LOGINID, @pPASSWORD AS PASSWORD;
                   END;     
                           
            END TRY
        
            BEGIN CATCH
                  DECLARE @ErrInputParam VARCHAR(2000);
                  SET @ErrInputParam = ' SP NAME=  USERAUTHENTICATION_g, 
                                                @pLOGINID =' + ISNULL(CONVERT(VARCHAR, @pLOGINID), 'NULL') + ', 
                                                @pPASSWORD =' + ISNULL(CONVERT(VARCHAR, @pPASSWORD), 'NULL');
                  PRINT ERROR_MESSAGE();
            END CATCH; 
      END; 
GO
