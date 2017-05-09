	@ECHO OFF
REM	Clean the Recycle Bin for ALL Users on Win7 or Server 2008
	rd /s c:\$Recycle.Bin
	rd /s e:\$Recycle.Bin
	rd /s h:\$Recycle.Bin