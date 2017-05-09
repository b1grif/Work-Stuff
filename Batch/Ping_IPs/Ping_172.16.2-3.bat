	@echo off
REM Delete old log files
	del OfflineDevices172.16.2-3.txt 2>nul
REM *************************************************************************************************************************************
REM Uncomment the next two lines for testing
REM	set /p server1=Enter specific hostname here:  
REM	>>AllServers.txt echo "%SERVER1%"
REM *************************************************************************************************************************************
REM Start the PING and log if OFFLINE
	for /f "delims=" %%a in (AllDevices172.16.2-3.txt) do ping -n 2 %%a >nul && (  
	echo %%a online) || (
	>>OfflineDevices172.16.2-3.txt echo %%a is OFFLINE)