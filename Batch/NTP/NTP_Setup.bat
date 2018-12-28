	@ECHO OFF
REM Stop NTP Services
	Net Stop w32time
REM Wipe NTP Settings
	SET /p UserResponse1="Wipe current NTP Settings? Yes or No:   "
	If %UserResponse1%==No GOTO SETNTP
:WIPE
	Net Stop w32time
	w32tm /unregister
	w32tm /register
REM	Set the NTP Pool
:SETNTP
	SET /p UserResponse2="Set the NTP Pool? Yes or No:   "
	If %UserResponse2%==No GOTO STARTSERVICES
	SET Pool=pool.ntp.org
REM	Configure the NTP server
	w32tm /config /manualpeerlist:%Pool% /syncfromflags:MANUAL /reliable:YES /update
	ECHO NTP Config Set to %Pool%
REM Start the NTP services
:STARTSERVICES
	Net Start w32time
REM Force a Resync
	SET /p UserResponse3="Force a NTP Resync? Yes or No:   "
	If %UserResponse3%==No GOTO End
	W32tm /resync
:End