USE [master]
GO

/****** Object:  DdlTrigger [AUDIT_Tgr_MonitorChange]    Script Date: 3/12/2015 9:59:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [AUDIT_Change]
ON ALL SERVER
FOR 
/*
DDL_DATABASE_LEVEL_EVENTS
*/
CREATE_DATABASE
,ALTER_DATABASE
,DROP_DATABASE
,CREATE_CERTIFICATE
,ALTER_CERTIFICATE
,DROP_CERTIFICATE
,CREATE_FUNCTION
,ALTER_FUNCTION
,DROP_FUNCTION
,CREATE_INDEX
,DROP_INDEX
,CREATE_PROCEDURE
,ALTER_PROCEDURE
,DROP_PROCEDURE
,CREATE_SCHEMA
,ALTER_SCHEMA
,DROP_SCHEMA
,CREATE_SYNONYM
,DROP_SYNONYM
,CREATE_TABLE
,ALTER_TABLE
,DROP_TABLE
,CREATE_TRIGGER
,ALTER_TRIGGER
,DROP_TRIGGER
,CREATE_TYPE
,DROP_TYPE
,CREATE_USER
,ALTER_USER
,DROP_USER
,CREATE_VIEW
,ALTER_VIEW
,DROP_VIEW
,CREATE_LOGIN
,ALTER_LOGIN
,DROP_LOGIN
AS
set nocount on
DECLARE @DBNAME varchar(200)
DECLARE @LoginName varchar(200)
DECLARE @BODY varchar(1000)
declare @EventType varchar(100)
declare @Host varchar(100)
declare @DatabaseName varchar(100)
declare @Tsql nvarchar(3999)
declare @SchemaName varchar(100)
declare @ObjectName varchar(100)
declare @ObjectType varchar(100)
DECLARE @ip VARCHAR(32) = (
SELECT client_net_address
FROM sys.dm_exec_connections
WHERE session_id = @@SPID
);
SELECT @EventType = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','nvarchar(max)') 
--,@host = EVENTDATA().value('(/EVENT_INSTANCE/ClientHost)[1]', 'nvarchar(max)')
,@DatabaseName = EVENTDATA().value( '(/EVENT_INSTANCE/DatabaseName)[1]', 'nvarchar(max)' )
,@Tsql = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)') 
,@SchemaName = EVENTDATA().value('(/EVENT_INSTANCE/SchemaName)[1]','nvarchar(max)') 
,@ObjectName = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(max)')
,@ObjectType = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]','nvarchar(max)') 
,@loginname = EVENTDATA().value('(/EVENT_INSTANCE/LoginName)[1]', 'NVARCHAR(100)') 
-- Is the default schema used 
if @SchemaName = ' ' select @SchemaName = default_schema_name from sys.sysusers u join sys.database_principals p 
on u.uid = p.principal_id where u.name = CURRENT_USER
insert into EnterpriseDBA..MonitorChange 
select @EventType, host_name(), @ip, PROGRAM_NAME(), @DatabaseName, @tsql, @SchemaName, @ObjectName, @ObjectType, getdate(), @loginname, CURRENT_USER, ORIGINAL_LOGIN() 
--SUSER_SNAME() 

GO

ENABLE TRIGGER [AUDIT_Change] ON ALL SERVER
GO


