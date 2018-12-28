<# 
.SYNOPSIS
	Create Remote Desktop Connection Manager connection file
.DESCRIPTION
	The script will pull all virtual servers out of Active Directory and create a Remote Desktop Connection Manager file

    If the script wont run, open powershell then run this command without the quotes "Set-ExecutionPolicy remotesigned"
    Then rerun the script.
.INPUTS
	Pulls from Active Directory
.OUTPUTS
	\\MTLShr02\home$\griffithsb\LAN.xml -- This file gets renamed to the file on the next line
	\\MTLShr02\home$\griffithsb\LAN.rdg
.NOTES
	Author:            Bill Griffiths
	
	Change Log:
	0.10 - Script created.
		   
#>


$LanFile = "\\MTLShr02\home$\$env:USERNAME\LAN.rdg"
$DevFile = "\\MTLShr02\home$\$env:USERNAME\Dev.rdg"
$TestFile = "\\MTLShr02\home$\$env:USERNAME\Test.rdg"
$DRFile = "\\MTLShr02\home$\$env:USERNAME\DR.rdg"

$DMZFile = "\\MTLShr02\home$\$env:USERNAME\DMZ.rdg"

#Create the begining of the RDG file
$Begin1 = "<?xml version=`"1.0`" encoding=`"utf-8`"?>"
$Begin2 = "<RDCMan programVersion=`"2.7`" schemaVersion=`"3`">"
$Begin3 = "  <file>"
$Begin4 = "    <credentialsProfiles />"
$Begin5 = "    <properties>"
$Begin6 = "      <expanded>True</expanded>"
$Begin7 = "      <name>"
$Begin8 = "</name>"
$Begin9 = "    </properties>"

$ServerStart = "    <server>"
$ServerPropStart = "      <properties>"
$ServerNameStart = "        <name>"
$ServerNameStop = "</name>"
$ServerPropStop = "      </properties>"
$ServerStop = "    </server>"

# Create the end of the RDG file
$End1 = "  </file>"
$End2 = "  <connected />"
$End3 = "  <favorites />"
$End4 = "  <recentlyUsed />"
$End5 = "</RDCMan>"

If(Test-Path $LanFile) {Remove-Item $LanFile }
If(Test-Path $DevFile) {Remove-Item $DevFile }
If(Test-Path $TestFile) {Remove-Item $TestFile }
If(Test-Path $DRFile) {Remove-Item $DRFile }

If(Test-Path $DMZFile) {Remove-Item $DMZFile }


Import-Module ActiveDirectory

############################################################################################
#Create the begining of the RDG file
Add-Content $LanFile $Begin1
Add-Content $LanFile $Begin2
Add-Content $LanFile $Begin3
Add-Content $LanFile $Begin4
Add-Content $LanFile $Begin5
Add-Content $LanFile $Begin6
Add-Content $LanFile ($Begin7 + "PROD" + $Begin8)
Add-Content $LanFile $Begin9
# Virtual Servers OU
Get-ADComputer -Filter * -SearchBase "ou=Virtual Servers,ou=Servers-PROD,ou=Computers - Servers,dc=mtl,dc=corp" | select-object -ExpandProperty Name| ForEach-Object {
	# Create the server blocks
	Add-Content $LanFile $ServerStart
	Add-Content $LanFile $ServerPropStart
	Add-Content $LanFile ($ServerNameStart + $_ + $ServerNameStop)
	Add-Content $LanFile $ServerPropStop
	Add-Content $LanFile $ServerStop
	}
# Physical Servers OU
Get-ADComputer -Filter * -SearchBase "ou=Physical Servers,ou=Servers-PROD,ou=Computers - Servers,dc=mtl,dc=corp" | select-object -ExpandProperty Name| ForEach-Object {
	# Create the server blocks
	Add-Content $LanFile $ServerStart
	Add-Content $LanFile $ServerPropStart
	Add-Content $LanFile ($ServerNameStart + $_ + $ServerNameStop)
	Add-Content $LanFile $ServerPropStop
	Add-Content $LanFile $ServerStop
	}
# Create the end of the RDG file
Add-Content $LanFile $End1
Add-Content $LanFile $End2
Add-Content $LanFile $End3
Add-Content $LanFile $End4
Add-Content $LanFile $End5

############################################################################################
#Create the begining of the RDG file
Add-Content $DevFile $Begin1
Add-Content $DevFile $Begin2
Add-Content $DevFile $Begin3
Add-Content $DevFile $Begin4
Add-Content $DevFile $Begin5
Add-Content $DevFile $Begin6
Add-Content $DevFile ($Begin7 + "Dev" + $Begin8)
Add-Content $DevFile $Begin9
# Virtual Servers OU
Get-ADComputer -Filter * -SearchBase "ou=Servers-DEV,ou=Computers - Servers,dc=mtl,dc=corp" | select-object -ExpandProperty Name| ForEach-Object {
	# Create the server blocks
	Add-Content $DevFile $ServerStart
	Add-Content $DevFile $ServerPropStart
	Add-Content $DevFile ($ServerNameStart + $_ + $ServerNameStop)
	Add-Content $DevFile $ServerPropStop
	Add-Content $DevFile $ServerStop
	}
# Create the end of the RDG file
Add-Content $DevFile $End1
Add-Content $DevFile $End2
Add-Content $DevFile $End3
Add-Content $DevFile $End4
Add-Content $DevFile $End5

############################################################################################
#Create the begining of the RDG file
Add-Content $TestFile $Begin1
Add-Content $TestFile $Begin2
Add-Content $TestFile $Begin3
Add-Content $TestFile $Begin4
Add-Content $TestFile $Begin5
Add-Content $TestFile $Begin6
Add-Content $TestFile ($Begin7 + "Test" + $Begin8)
Add-Content $TestFile $Begin9
# Virtual Servers OU
Get-ADComputer -Filter * -SearchBase "ou=Servers-TEST,ou=Computers - Servers,dc=mtl,dc=corp" | select-object -ExpandProperty Name| ForEach-Object {
	# Create the server blocks
	Add-Content $TestFile $ServerStart
	Add-Content $TestFile $ServerPropStart
	Add-Content $TestFile ($ServerNameStart + $_ + $ServerNameStop)
	Add-Content $TestFile $ServerPropStop
	Add-Content $TestFile $ServerStop
	}
# Create the end of the RDG file
Add-Content $TestFile $End1
Add-Content $TestFile $End2
Add-Content $TestFile $End3
Add-Content $TestFile $End4
Add-Content $TestFile $End5