IF (OBJECT_ID('USERMAST_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE USERMAST_c
END
GO
CREATE  PROCEDURE [dbo].[USERMAST_c]
(
    @pFlag CHAR(1) ,
    @pUSERID INT ,
    @pLOGINID VARCHAR(120) ,
    @pPASSWORD VARCHAR(20) , 
    @pISACTIVE BIT ,
    @pMobileNo VARCHAR(13) , 
    @pEmail NVARCHAR(600) = '',
	@pFNAME VARCHAR(20),
	@pMNAME VARCHAR(20),
	@pLNAME VARCHAR(20),
	@pDOB DATE,
	@pADDRESS VARCHAR(100),
	@pPROFILEIMG VARCHAR(MAX)
 )   
AS 
    BEGIN
        DECLARE @ErrorLogID INT;
        DECLARE @vSpName VARCHAR(100);
        DECLARE @vTableName VARCHAR(100);
        DECLARE @VIDENTITY INT 
		      
        SET @vSpName = 'USERMAST_c'
        SET @vTableName = 'USERMAST'
           
		 
        BEGIN TRY
            BEGIN TRANSACTION @vSpName;
            IF @pFlag = 'I' 
                BEGIN
				    
			


            INSERT  INTO dbo.USERMAST
                    ( LOGINID ,ISACTIVE,Email ,MobileNo,
                        FNAME ,MNAME ,LNAME ,DOB ,ADDRESS ,PROFILEIMG ,PASSWORD)
            VALUES  ( @pLOGINID, @pISACTIVE,@pEmail, @pMobileNo,@pFNAME,@pMNAME,@pLNAME,@pDOB,
					@pADDRESS,@pPROFILEIMG,ENCRYPTBYPASSPHRASE ('HellowHoWAreYouPJNPS',@pPASSWORD))
                    
			SELECT  @VIDENTITY = @@IDENTITY 

		     
			 EXEC dbo.UPDATEEXTRA @REFRESH='' 
                    
                    
                    EXEC LogGen_i @vSpName, @vTableName, @VIDENTITY, 1, 1
                    
                    SELECT  @VIDENTITY AS 'ID' 
                END 
            ELSE 
                IF @pFlag = 'E' 
                    BEGIN
                        EXEC LogGen_i @vSpName, @vTableName, @pUSERID, 2, 1
                        UPDATE  USERMAST
                        SET     PASSWORD = ENCRYPTBYPASSPHRASE ('HellowHoWAreYouPJNPS',@pPASSWORD), 
                                ISACTIVE = @pISACTIVE,  MobileNo = @pMobileNo,DOB=@pDOB,
                                Email = @pEmail,FNAME=@pFNAME,MNAME=@pMNAME,LNAME=@pLNAME,ADDRESS=@pADDRESS,
								PROFILEIMG=@pPROFILEIMG 
                        WHERE   USERID = @pUSERID  

				        SELECT  @pUSERID AS 'ID'
                         
                    END 
                ELSE 

                    IF @pFlag = 'D' 
                        BEGIN
                            EXEC LogGen_i @vSpName, @vTableName, @pUSERID, 4, 1
                            BEGIN TRY 
                                DELETE  FROM USERMAST
                                WHERE   USERID = @pUSERID 
                                
                                SELECT  @@ROWCOUNT AS 'ID'
                            END TRY
                          
                            BEGIN CATCH 
                                UPDATE  USERMAST
                                SET     ISACTIVE = 0
                                WHERE   USERID = @pUSERID 
                                
                                SELECT  -123 AS 'ID' 
                            END CATCH 
                        END 
                    ELSE 
                        IF @pFlag = 'S' 
                            BEGIN
                                SELECT  COUNT(*) AS 'ID'
                                FROM    USERMAST
                                WHERE   USERID = @pUSERID 
                            END  
				IF @pFlag = 'C' 
                BEGIN
                    SELECT  COUNT(*) AS 'ID'
                    FROM    USERMAST
                    WHERE   USERID <> @pUSERID AND
                            LOGINID = @pLOGINID
                END 
            ELSE 
                IF @pFlag = 'F' 
                    BEGIN
                        SELECT  @pUSERID = USERID
                        FROM    USERMAST
                        WHERE   ( LOGINID = @pLOGINID OR
                                  Email = @pEmail ) AND
                                ISNULL(Email, '') <> ''
                           
                        SELECT  ISNULL(@pUSERID, 0) ID  
                            
                    END  
				ELSE  
                
            COMMIT TRANSACTION @vSpName;
        END TRY
        BEGIN CATCH 
            IF XACT_STATE() <> 0 
                BEGIN
                    ROLLBACK TRANSACTION @vSpName;
                    SELECT  0 - ERROR_NUMBER() AS 'ID',
                                ERROR_MESSAGE() AS 'mess'
                END
	
            DECLARE @ErrInputParam VARCHAR(2000)
	
            SET @ErrInputParam = ' Table Name=  USERMAST, 
                         USERID =' + ISNULL(CONVERT(VARCHAR(10), @pUSERID), 'NULL') + ',   
                         LOGINID =' + ISNULL(CONVERT(VARCHAR(120), @pLOGINID), 'NULL') + ',   
                         PASSWORD =' + ISNULL(CONVERT(VARCHAR(50), @pPASSWORD), 'NULL') + ',   
                         ISDOMAIN =' + ISNULL(CONVERT(VARCHAR(1), ''), 'NULL') + ',   
                         UTYPEID =' + ISNULL(CONVERT(VARCHAR(10), ''), 'NULL') + ',   
                         TMZONEID =' + ISNULL(CONVERT(VARCHAR(10), ''), 'NULL') + ',   
                         Email =' + ISNULL(CONVERT(VARCHAR(255), @pEmail), 'NULL') + ',   
                         MobileNo =' + ISNULL(CONVERT(VARCHAR(18), @pMobileNo), 'NULL')+ ',   
                         FNAME =' + ISNULL(CONVERT(VARCHAR(20), @pFNAME), 'NULL')+ ',   
                         MNAME =' + ISNULL(CONVERT(VARCHAR(20), @pMNAME), 'NULL')+ ',   
                         LNAME =' + ISNULL(CONVERT(VARCHAR(20), @pLNAME), 'NULL')+ ',   
                         DOB =' + ISNULL(CONVERT(VARCHAR(15), @pDOB), 'NULL')  + ',   
                         ADDRESS =' + ISNULL(CONVERT(VARCHAR(100), @pADDRESS), 'NULL')  + ',   
                         PROFILEIMG =' + ISNULL(CONVERT(VARCHAR(MAX), @pPROFILEIMG), 'NULL')    
            EXECUTE LogError_i @ErrInputParam, @ErrorLogID OUTPUT;
      
        END CATCH;
	
    END



GO
