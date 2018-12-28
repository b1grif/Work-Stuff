	@ECHO OFF
REM One Time Setup
	ECHO -------------------------------------------
	ECHO Count Files that are older than XX
	ECHO -------------------------------------------
REM Set Paramaters
	ECHO Set Parameters...
	SET /a Attempt=0
REM **************************************************************************
	SET FolderPath="D:\Program Files"
REM **************************************************************************
	SET FileType="*.*"
	SET LogPath="%USERPROFILE%\Desktop\OldFiles.txt"
	ECHO.
	ECHO.
	SET /P OldDate="Log everything before this date. ie.12/01/2015  -- "

:DATETIME
REM Build the date
	SET BuildDate=%DATE:~4,10%
	SET YearStr=%buildDate:~6,4%
	SET MonthStr=%buildDate:~0,2%
	SET DayStr=%buildDate:~3,2%
	SET DateStr=%YearStr%-%MonthStr%-%DayStr%
REM Build the time
	SET HOUR=%TIME:~0,2%
	IF "%HOUR:~0,1%" == " " SET HOUR=0%HOUR:~1,1%
	SET MINUTE=%TIME:~3,2%
	IF "%MINUTE:~0,2%" == " " SET MINUTE=0%MINUTE:~1,1%
	SET SECOND=%TIME:~6,2%
	SET TimeStr=%HOUR%:%MINUTE%:%SECOND%
	IF %Attempt%==1 GOTO Ending

:LoggingFiles
	DEL %LogPath% 2>Nul
	ECHO.
	ECHO.
	ECHO Logging the files to %LogPath%
	ECHO.
	ECHO.
	ECHO Starting at %TimeStr% on %DateStr%
	ECHO Starting at %TimeStr% on %DateStr%  >>%LogPath%
	ECHO.
	ECHO.
	ECHO Looking for files older than %OldDate%
	ECHO Looking for files older than %OldDate%  >>%LogPath%

	Forfiles /P %FolderPath% /S /M %FileType% /D -%OldDate% /C "cmd /c echo @path,@fsize,@fdate >>%LogPath%"

REM This part of code doesnt work properly
REM	Forfiles /P %FolderPath% /S /M %FileType% /D -%OldDate% /C ^"cmd /c ^
REM		echo @path ^&^
REM		echo @path,@fsize,@fdate >>%LogPath% ^"

	SET /a Attempt=%Attempt%+1
	ECHO.
	GOTO DATETIME

:Ending
	ECHO %Attempt%
	ECHO.
	ECHO Ending at %TimeStr% on %DateStr%  >>%LogPath%	