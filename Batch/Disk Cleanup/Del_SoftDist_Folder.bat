	@echo off
REM	Stop Windows Update Service
	net stop wuauserv
REM 	Delete un-needed files
	del c:\Windows\SoftwareDistribution\Download\ /s /q
REM	We dont use the Windows Update Service on Servers anymore
REM	net start wuauserv