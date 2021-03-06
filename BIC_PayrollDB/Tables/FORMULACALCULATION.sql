﻿
DROP TABLE FORMULACALCULATION
GO
CREATE TABLE FORMULACALCULATION
(
	CALID BIGINT NOT NULL IDENTITY(1,1),
	VARID BIGINT,
	HEADID BIGINT,
	CONDITION NVARCHAR(1000),
	CALCULATION NVARCHAR(1000),
	ISEXIT BIT,
	RESULT CHAR(3),
	TESTVALUE DECIMAL(21,6)
)
ON [PRIMARY]
GO
ALTER TABLE [dbo].[FORMULACALCULATION] ADD CONSTRAINT [PK_FORMULACALCULATION] PRIMARY KEY CLUSTERED  ([CALID]) ON [PRIMARY]
