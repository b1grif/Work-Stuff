    @ECHO OFF
REM Fix servers and now the program will try the registerdns command again
	set /p IP="What is the computer's IP?  "
	psexec -accepteula \\%IP% ipconfig /flushdns
    psexec -accepteula \\%IP% ipconfig /registerdns