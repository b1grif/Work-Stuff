	@ECHO OFF
	ECHO Kill a task on a remote computer
	ECHO .
	ECHO .
	ECHO .
	ECHO .
REM Set the computer name
	SET /p ComputerName="What is the computer name?      "
	
REM Do you want to kill Onbase?
	SET /p KillObunity="Do you want to kill Obunity?  (Yes or No)      "

REM Yes kill obunity
	If %KillObunity%==Yes GOTO KillOnbase
	
REM No kill a different process
	If %KillObunity%==No GOTO ChooseProcess

:ChooseProcess
	tasklist /s %ComputerName%
	ECHO .
	ECHO .
	ECHO .
	ECHO .
	SET /p ProcessName="What process do you want to kill?      "
	GOTO TaskKill
	
:KillOnbase
	SET ProcessName="Obunity.exe"
	
:TaskKill
	ECHO Killing processes %ProcessName%
	ECHO.
	ECHO.
	ECHO.
	ECHO.
	taskkill /s %ComputerName% /IM %ProcessName%
	ECHO.
	ECHO.
	ECHO.
	ECHO.
	tasklist /s %ComputerName%
	ECHO.
	ECHO.
	SET /p Done="Are you done? (Y/N)     "
	If %Done%==Y GOTO END
	If %Done%==N GOTO Taskkill

:END