	@ECHO OFF
	ECHO Run this to list the processes that are being monitored by Cylance...
	SET /p OS="Is it a 64bit OS?(Y/N)  "
REM 64bit command
	IF /i %OS%=="Y" TASKLIST /FI "MODULES eq CyMemDef64.dll"
REM 32bit command
	IF /i %OS%=="N" TASKLIST /FI "MODULES eq CyMemDef.dll"
	PAUSE