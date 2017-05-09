	@ECHO OFF
REM Kill a Stuck Windows Service
REM .
REM Make note of the service name
	SET /p SERVICENAME="What is the service name?  "
REM Find the PID
	sc queryex %SERVICENAME%
REM Make note of the PID
	SET /p PID="What is the PID?   "
REM Kill the service's PID
	TASKKILL /f /pid %PID%
	Pause