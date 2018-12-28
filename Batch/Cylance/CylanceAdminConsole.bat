	@ECHO OFF
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .	
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	ECHO .	
	ECHO This script will kill the CylanceUI then start it again with admin tools
	pause
	
REM Dump a list of running processes to search.log
REM Search search.log for "CylanceUI.exe"
	tasklist /FI "IMAGENAME eq CylanceUI.exe" /FO CSV > search.log
	FOR /F %%A IN (search.log) DO IF %%~zA EQU 0 GOTO end
	
REM Kill the Cylance UI if it is still running
	taskkill /f /im "CylanceUI.exe"
	pause
	
REM Start up UI in admin mode
	cd "C:\Program Files\Cylance\Desktop"
	start CylanceUI.exe -a
	
:end
	del search.log
