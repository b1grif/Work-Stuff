	@ECHO OFF
	cls
	ECHO Add the CompatibilityMode registry key to a machine.
REM Copy needed files to current user's desktop
	copy \\MTLTSShare\Install\Cylance\psexec.exe %UserProfile%\Desktop
	TIMEOUT 5
REM Change directory to the current user's desktop	
	c:
	cd %UserProfile%\Desktop
REM Add the registry key
	psexec /accepteula -s reg add HKEY_LOCAL_MACHINE\SOFTWARE\Cylance\Desktop /v CompatibilityMode /t REG_BINARY /d 01
	del psexec.exe 2>nul
	pause