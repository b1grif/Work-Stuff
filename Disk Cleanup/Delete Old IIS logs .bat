	@ECHO OFF
REM Set Paramaters
	ECHO Begin Setting Parameters...
	SET FolderPath="C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\14\LOGS"
REM	SET FolderPath="C:\inetpub\logs\LogFiles\W3SVC974629824"
REM	SET FileType="*.log"
	SET FileType="*.usage"
	SET LogPath="%USERPROFILE%\Desktop\DirLog.txt"
	SET /P Date="Delete everything before this date. ie.12/01/2015  -- "
REM Logging files
	DEL %LogPath% 2>Nul
	ECHO Logging the files to %LogPath%
	Forfiles /P %FolderPath% /S /M %FileType% /D -%Date% /C "cmd /c echo @file >>%LogPath%"
REM Delete files
	SET /P DelFiles="Ready to delete those files?  Yes or No  "
	IF "%DelFiles%"=="Yes" Forfiles /P %FolderPath% /S /M %FileType% /D -%Date% /C "cmd /c del @path"
	Pause