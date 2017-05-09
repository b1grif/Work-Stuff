	@echo off
REM TESTING 123
	set /p IP="What is the server's IP?  "
	psexec -accepteula \\%IP% ipconfig /all
REM Does the program need to continue?
REM	set /p DONE="Continue:Yes or No     "
REM	if %DONE%=="No" Call :EXIT
	pause
REM Set the variables    
	set vardns1=172.16.0.5
	set vardns2=172.16.0.6
REM Prompt for the interface name
	psexec -accepteula \\%IP% netsh int show interface
	ECHO Type the interface name shown above
	set /p int1=
REM Setting the primary DNS
	ECHO Setting Primary DNS
	psexec -accepteula \\%IP% netsh int ip set dns name = %int1% source = static addr = %vardns1%
REM Setting the secondary DNS
	ECHO Setting Secondary DNS
	psexec -accepteula \\%IP% netsh int ip add dns name = %int1% addr = %vardns2%
REM Flush DNS for good measure
	psexec -accepteula \\%IP% ipconfig /flushdns
REM Shows that the new DNS servers were set properly
	ECHO Are the DNS servers set to %vardns1% and %vardns2%
	psexec -accepteula \\%IP% ipconfig /all

	pause
:EXIT
	QuIT