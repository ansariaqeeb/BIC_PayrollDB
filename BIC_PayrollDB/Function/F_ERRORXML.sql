IF (OBJECT_ID('F_ERRORXML') IS NOT NULL) 
BEGIN 
DROP FUNCTION F_ERRORXML
END
GO
CREATE FUNCTION dbo.F_ERRORXML
(
	@pMsgID   INT ,
	@pMsgDesc   VARCHAR(MAX),
	@pType  CHAR(1),
	@pTitle  VARCHAR(250),
	@pISERROR BIT=0
)
RETURNS XML 
AS 
 BEGIN
 
     DECLARE @vRESULT XML
     
     
        IF @pISERROR=0
        BEGIN
			SET @vRESULT = (SELECT ISNULL(@pMsgID,0) AS 'ID' ,ISNULL(@pMsgDesc,'') AS 'ERRORMSGS', ISNULL(@pType,'') AS 'TYPE',ISNULL(@pTitle,'') AS 'TITLE' FOR XML PATH('SYSMSGS'),TYPE)
        END
        ELSE
        BEGIN
          
          DECLARE @vERRORMESS VARCHAR(255)
          
          IF EXISTS (SELECT * FROM dbo.ERRORMESS WHERE EERRORID = @pMsgID AND @pMsgDesc = '')
            BEGIN 
              SELECT @vERRORMESS = USERMESS FROM dbo.ERRORMESS WHERE EERRORID = @pMsgID
              
                SET @vRESULT = (SELECT ISNULL(@pMsgID,0) AS 'ID' ,ISNULL(@vERRORMESS,'') AS 'ERRORMSGS', ISNULL(@pType,'') AS 'TYPE',ISNULL(@pTitle,'') AS 'TITLE' FOR XML PATH('SYSMSGS'),TYPE)
            END 
          ELSE  
          IF (LEN(@pMsgDesc) > 0 AND @pMsgID > 0 )
            BEGIN 
             SET @vRESULT = (SELECT ISNULL(@pMsgID,0) AS 'ID' , @pMsgDesc AS 'ERRORMSGS', ISNULL(@pType,'') AS 'TYPE',ISNULL(@pTitle,'') AS 'TITLE' FOR XML PATH('SYSMSGS'),TYPE)
            END 
          ELSE 
           BEGIN 
		    SET @vRESULT = (SELECT ISNULL(@pMsgID,0) AS 'ID' ,CASE WHEN LEN(@pMsgDesc) <> 0 THEN  @pMsgDesc ELSE ERROR_MESSAGE() END AS 'ERRORMSGS', ISNULL(@pType,'') AS 'TYPE',ISNULL(@pTitle,'') AS 'TITLE' FOR XML PATH('SYSMSGS'),TYPE)
		   END
		   
	   END
   
         
   RETURN (@vRESULT)
   
 END 
    
GO
