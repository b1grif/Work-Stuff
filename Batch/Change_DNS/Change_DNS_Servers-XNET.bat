    @ECHO OFF
REM ## Enter your IPv4 DNS Server IP addresses where indicated and run script with administrative privileges.
    
REM Set the variables to the DNS addresses    
    set vardns1=10.1.1.18
    set vardns2=10.1.1.19
REM Prompt for the interface name
    netsh int show interface
    ECHO Type the interface name shown above
    set /p int1=

REM Setting the primary DNS
    ECHO Setting Primary DNS
    netsh int ip set dns name = %int1% source = static addr = %vardns1%

REM Setting the secondary DNS
    ECHO Setting Secondary DNS
    netsh int ip add dns name = %int1% addr = %vardns2%

REM Flush DNS for good measure
    ipconfig /flushdns

REM Shows that the new DNS servers were set properly
    ECHO Are the DNS servers set to %vardns1% and %vardns2%
    ipconfig /all

    pause

    exit