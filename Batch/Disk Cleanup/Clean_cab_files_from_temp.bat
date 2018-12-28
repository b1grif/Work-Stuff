	@ECHO OFF
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
REM Cleanup .CAB files possibly from KACE
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
REM Set Paramaters
	ECHO Set Parameters...
	SET FolderPath="C:\Windows\Temp"
	SET FileType="*.cab"
	SET LogPath="%USERPROFILE%\Desktop\CABLog.txt"
	SET /P Date="Delete everything before this date. ie.12/01/2015  -- "
REM Logging files
	DEL %LogPath% 2>Nul
	ECHO Logging the files to %LogPath%
	Forfiles /P %FolderPath% /S /M %FileType% /D -%Date% /C "cmd /c echo @file >>%LogPath%"
REM Delete files
	SET /P DelFiles="Ready to delete those files?  Yes or No  "
	IF "%DelFiles%"=="Yes" Forfiles /P %FolderPath% /S /M %FileType% /D -%Date% /C "cmd /c del @path"
	Pause