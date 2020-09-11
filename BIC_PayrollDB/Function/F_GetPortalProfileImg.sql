IF (OBJECT_ID('F_GetPortalProfileImg') IS NOT NULL) 
BEGIN 
DROP FUNCTION F_GetPortalProfileImg
END
GO
CREATE FUNCTION [dbo].[F_GetPortalProfileImg]
    (
      @pSLID INT = 0 ,
      @pUSERID INT = 0 ,
      @pCOMMID INT = 0 ,
      @pFMembID INT = 0

    )
RETURNS VARCHAR(MAX)
    --WITH ENCRYPTION
AS 
    BEGIN               
                
                 
        DECLARE @vRETVAL VARCHAR(MAX)
             
        SELECT TOP 1
                @vRETVAL = 'account/userpic?pic=' + ISNULL(IMGDESC, '')
        FROM    dbo.ProfileImg AS pi
        WHERE   1 = ( CASE WHEN @pUSERID > 0 AND
                                UserID = @pUSERID THEN 1 END )
        IF ( ISNULL(@vRETVAL, '') = '' ) 
            BEGIN 
                SET @vRETVAL = 'account/userpic?pic=null'
            END 
        RETURN @vRETVAL
			      

    END

GO
