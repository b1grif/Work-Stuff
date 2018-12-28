REM	Remove the backup copies of patches
	sc config wuauserv start= Auto
	net start wuauserv
	dism /online /cleanup-image /StartComponentCleanup /ResetBase
	pause
	net stop wuauserv