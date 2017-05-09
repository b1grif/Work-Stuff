	@ECHO OFF
	cls
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
REM	Clean the Recycle Bin for ALL Users on Win7 or Server 2008
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
	ECHO Clean up your Recycle Bin
	rd /s c:\$Recycle.Bin
	pause
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
REM Delete the SoftwareDistribution folder
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
	cls
	ECHO ---------------------------------------
	ECHO Delete the softwaredistribution folder
REM	Stop Windows Update Service
	net stop wuauserv
REM Delete un-needed files
	del c:\Windows\SoftwareDistribution\Download\ /s /q
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
REM Ask about specific folder cleanup
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
	cls
	ECHO ---------------------------------------
	SET /p FolderCleanup="Cleanup a specific folder? (Y/N)   "
	IF "%FolderCleanup%"=="N" GOTO CABFiles
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
REM Cleanup a specific folder
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
REM Set Paramaters
	ECHO Set Parameters...
	SET /p FolderPath="What is the folder path?   "
REM	SET FolderPath="C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\14\LOGS"
REM	SET FolderPath="C:\inetpub\logs\LogFiles\W3SVC974629824"
	SET /p FileType="What is the filetype? ex. *.usage    "
REM	SET FileType="*.log"
REM	SET FileType="*.usage"
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
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
REM Cleanup .CAB files possibly from KACE
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
REM Set Paramaters
:CABFiles
	cls
	ECHO ---------------------------------------
	ECHO Set parameters for deleting old CAB files from C:\Windows\Temp...
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
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
REM Ask about WinSXS folder cleanup
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
	cls
	ECHO ---------------------------------------
	SET /p BPCleanup="Cleanup backup copies of patches? (Y/N)   "
	IF "%BPCleanup%"=="N" GOTO DiskCleanup
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
REM Remove the backup copies of patches - WinSXS folder
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
:BackupPatches	
	dism /online /cleanup-image /StartComponentCleanup /ResetBase
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
REM Run Disk Cleanup
REM -------------------------------------------------------------------------------------------------------------------------------------------------------
:DiskCleanup
	ECHO .
	ECHO .
	ECHO .
	ECHO This script will only work on Server 2008 R2
REM Copy Windows Disk Cleanup tool to appropriate folders
	copy C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.1.7600.16385_none_c9392808773cd7da\cleanmgr.exe C:\Windows\System32\
	copy C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.1.7600.16385_en-us_b9cb6194b257cc63\cleanmgr.exe.mui C:\Windows\System32\en-US\
REM Run Windows Disk Cleanup
	cleanmgr.exe