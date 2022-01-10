declare @databasename VARCHAR(1000) 

DECLARE db_cursor CURSOR FOR

select [DatabaseName] FROM [master].[dbo].[Shrink data Files]

OPEN db_cursor

FETCH NEXT FROM db_cursor INTO @databasename

WHILE @@FETCH_STATUS = 0

BEGIN

USE [DatabaseName]????
GO

DECLARE @FileSize varchar(20),
???????? 	@LogicalFile varchar(50),
???????? 	@TargetFileSize int,
???????? 	@NewFileSize varchar(20),
???????? 	@IncrementSize int
??????

SET @LogicalFile = (select [Logical File Name]  FROM [master].[dbo].[Shrink data Files] where [DatabaseName] = '@databasename')  ?---MDF file name
???
SET @TargetFileSize = (select [TargetFileSize ] FROM [master].[dbo].[Shrink data Files] where [DatabaseName] = '@databasename')????--Little more than Space_Used_MB from our excel

SET @IncrementSize = (select [Increment Size] FROM [master].[dbo].[Shrink data Files] where [DatabaseName] = '@databasename')?


SET @FileSize = (SELECT [Size]/128 FROM dbo.Sysfiles WHERE [name] = @LogicalFile)????


SET @NewFileSize = @FileSize -@IncrementSize


WHILE @FileSize > @TargetFileSize
????
????BEGIN

????????BEGIN

????????????EXEC ('DBCC SHRINKFILE ' + '(N' + '''' + @LogicalFile +'''' + ', ' + @NewFileSize + ')')
????????????????????????
????????END
????????????
????????????SET????@FileSize = (SELECT [Size]/128 FROM dbo.Sysfiles WHERE [name] = @LogicalFile)
????????
????????????SET @NewFileSize = @FileSize -@IncrementSize

????END

GO
go


























