	@ECHO OFF
	ECHO This batch does three things.
	ECHO it backs up all Cylance Registry Keys
	ECHO then it deletes the keys releated to the fingerprint
	ECHO then it restarts the Cylance services.
REM Export the Cylance Registry Keys
	REG EXPORT HKEY_LOCAL_Machine\Software\Cylance\Desktop C:\Cylance_Reg_Keys.txt
REM Delete the Old Fingerprint
	REG DELETE HKEY_LOCAL_Machine\Software\Cylance\Desktop\FP /f
	REG DELETE HKEY_LOCAL_Machine\Software\Cylance\Desktop\FPMake /f
	REG DELETE HKEY_LOCAL_Machine\Software\Cylance\Desktop\FPVersion /f
REM Stop Cylance services
	NET STOP CylanceSvc
REM Start Cylance services
	NET START CylanceSvc