IF (OBJECT_ID('USERMAST_g') IS NOT NULL) 
BEGIN 
DROP PROCEDURE USERMAST_g
END
GO
CREATE PROCEDURE [dbo].[USERMAST_g]
    (
      @pEUSERID INT ,
      @pFlag SMALLINT = -1 ,
      @pPAGENO INT,
      @pDESC VARCHAR(50),
      @pUSERID INT = 0
    ) 
AS
    BEGIN
        DECLARE @ErrorLogID INT; 
        DECLARE @vUSERTYPE INT 
        DECLARE @vPageSize INT 
        DECLARE @vPagecount INT 
        DECLARE @vIsSysAdmin VARCHAR(255); 
        DECLARE @vUTYPEID INT;  
        
        BEGIN TRY
           

                    SELECT  U.USERID ,
                            ISNULL(U.FNAME, '') FNAME ,
                            ISNULL(U.MNAME, '') MNAME ,
                            ISNULL(U.LNAME, '') LNAME ,
                            ISNULL(U.FNAME, '') + ' ' + ISNULL(U.LNAME, '')
                            + ' (' + U.LOGINID + ')' AS LOGINID ,
                            U.Email ,
                            CONVERT(VARCHAR(50), DECRYPTBYPASSPHRASE('HellowHoWAreYouPJNPS',
                                                              PASSWORD)) PASSWORD , 
                            ISNULL(U.ISACTIVE, 0) ISACTIVE ,  
                            u.DOB , 
                            dbo.F_GetPortalProfileImg(0, u.USERID, 0, 0) AS IMGDESC ,
                            ISNULL(u.MobileNo,'') AS MobileNo,  
                            u.LOGINID USERNAME ,
                            @pPAGENO AS PAGECOUNT ,
                            @vPageSize AS PAGESIZE ,
                            COUNT(*) OVER ( ) AS NUMBEROFROWS  
                    FROM    USERMAST U 
                    WHERE   1 = (CASE WHEN @pUSERID = 0 THEN 1 WHEN @pUSERID > 0 AND U.USERID = @pUSERID THEN 1 END)
                            AND 1 = ( CASE WHEN @pDESC = '' THEN 1 WHEN @pDESC <> ''
                                                AND ( FNAME LIKE '%' + @pDESC
                                                      + '%'
                                                      OR LNAME LIKE '%'
                                                      + @pDESC + '%'
                                                      OR MNAME LIKE '%'
                                                      + @pDESC + '%') THEN 1 END)
                    ORDER BY U.LOGINID   
                                  
        END TRY
        BEGIN CATCH

-- Roll back any active or uncommittable transactions before
    -- inserting information in the ErrorLog.
           
            DECLARE @ErrInputParam VARCHAR(2000)
            SELECT  0 - ERROR_NUMBER()
            PRINT ERROR_MESSAGE()
            SET @ErrInputParam = ' Table Name=  USERMAST  ,   @pFlag + '
                + CONVERT (VARCHAR, @pFlag)
    -- Log Error
            EXECUTE LogError_i @ErrInputParam, @ErrorLogID OUTPUT;
        END CATCH;
    END	

GO
