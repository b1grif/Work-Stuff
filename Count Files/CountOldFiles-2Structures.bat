	@ECHO OFF
REM One Time Setup
	ECHO -------------------------------------------
	ECHO Count Files that are older than XX
	ECHO -------------------------------------------
REM Set Paramaters
	ECHO Set Parameters...
	SET /a Attempt=0
REM **************************************************************************
	SET FolderPath1="G:\pdev"
	SET FolderPath2="I:\netdev"
REM **************************************************************************
	SET FileType="*.*"
	SET LogPath1="%USERPROFILE%\Desktop\PDev_OldFiles.txt"
	SET LogPath2="%USERPROFILE%\Desktop\NetDev_OldFiles.txt"
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
	IF %Attempt%==1 ECHO Ending at %TimeStr% on %DateStr%  >>%LogPath1%
	IF %Attempt%==1 GOTO LoggingFiles2
	IF %Attempt%==2 ECHO Ending at %TimeStr% on %DateStr%  >>%LogPath2%
	IF %Attempt%==2 GOTO Ending

:LoggingFiles
	DEL %LogPath1% 2>Nul
	ECHO.
	ECHO.
	ECHO Logging the files to %LogPath1%
	ECHO.
	ECHO.
	ECHO Starting at %TimeStr% on %DateStr%
	ECHO Starting at %TimeStr% on %DateStr%  >>%LogPath1%
	ECHO.
	ECHO.
	ECHO Looking for files older than %OldDate%
	ECHO Looking for files older than %OldDate%  >>%LogPath1%

	Forfiles /P %FolderPath1% /S /M %FileType% /D -%OldDate% /C "cmd /c echo @path,@fsize,@fdate >>%LogPath1%"
	
	SET /a Attempt=%Attempt%+1
	ECHO.
	GOTO DATETIME

:LoggingFiles2
	DEL %LogPath2% 2>Nul
	ECHO.
	ECHO.
	ECHO Logging the files to %LogPath2%
	ECHO.
	ECHO.
	ECHO Starting at %TimeStr% on %DateStr%
	ECHO Starting at %TimeStr% on %DateStr%  >>%LogPath2%
	ECHO.
	ECHO.
	ECHO Looking for files older than %OldDate%
	ECHO Looking for files older than %OldDate%  >>%LogPath2%

	Forfiles /P %FolderPath2% /S /M %FileType% /D -%OldDate% /C "cmd /c echo @path,@fsize,@fdate >>%LogPath2%"

	SET /a Attempt=%Attempt%+1
	ECHO.
	GOTO DATETIME
:Ending
	ECHO %Attempt%
	ECHO.
	