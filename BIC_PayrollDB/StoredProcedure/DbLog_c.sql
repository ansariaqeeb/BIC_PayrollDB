IF (OBJECT_ID('DbLog_c') IS NOT NULL) 
BEGIN 
DROP PROCEDURE DbLog_c
END
GO
CREATE PROCEDURE dbo.DbLog_c
(
        @pXMLFILE XML ,
        @pSPNAME VARCHAR(50)
)
AS
BEGIN


        INSERT INTO dbo.DbLog( userId, xmlFile, spName, logDateTime, compName, compUser, compIpAddress, browserName, browserServer )
        SELECT
                     D.USERID ,
                     ISNULL( @pXMLFILE, NULL) ,
                     ISNULL( @pSPNAME, '') ,
                     GETDATE() ,
                     D.COMPNAME ,
                     D.COMPUSER ,
                     D.COMPIPADDRESS ,
                     D.BROWSERNM ,
                     D.BROWSERVER
        FROM         ( SELECT @pXMLFILE AS XMLFILE ) AS C
        LEFT    JOIN (       SELECT
                                     ISNULL(N.C.value('@USERID[1]', 'INT'), 0) AS USERID ,
                                     ISNULL(N.C.value('@COMPNAME[1]', 'VARCHAR(100)'), '') AS COMPNAME ,
                                     ISNULL(N.C.value('@COMPUSER[1]', 'VARCHAR(100)'), '') AS COMPUSER ,
                                     ISNULL(N.C.value('@COMPIPADDRESS[1]', 'VARCHAR(100)'), '') AS COMPIPADDRESS ,
                                     ISNULL(N.C.value('@BROWSERNM[1]', 'VARCHAR(100)'), '') AS BROWSERNM ,
                                     ISNULL(N.C.value('@BROWSERVER[1]', 'VARCHAR(100)'), '') AS BROWSERVER
                             FROM    @pXMLFILE.nodes('//XMLFILE/LOGINLOG') N(C) ) AS D ON 1 = 1;

END; 
GO
