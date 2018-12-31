<#
.SYNOPSIS
    Find computers in default Computers OU in Active Directory
.NOTES
    Author:            Bill Griffiths
	
    Change Log -- Change $ScriptVersion
    0.0.5 - Script is working.
    0.0.1 - Script created.
#>
#---------------------------------------------------------[Script Parameters]------------------------------------------------------

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

$Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@

#----------------------------------------------------------[Declarations]----------------------------------------------------------
$ScriptVersion = '0.0.5'

#Email Settings
$EmailTo = 'GriffithsB@domain.com'
$EmailFrom = "SCHEDULER@domain.com"
$EmailServer = "email.domain.com"

#-----------------------------------------------------------[Functions]------------------------------------------------------------ 

#-----------------------------------------------------------[Execution]------------------------------------------------------------
Write-Output "ScriptVersion=$ScriptVersion"
Write-Output "Looking for computers..."
$NewComputers = Get-ADComputer -SearchBase 'cn=computers,dc=domain,dc=com' -Filter *
if ($NewComputers){
    Write-Output "Converting to HTML..."
    $HTML = $NewComputers |
        Select-Object Name |
        ConvertTo-Html -Head $Header -Body "<H2>These computers are in the default Computers OU. They probably need to be moved</H2>"
    ForEach ($Line in $HTML){
        $EmailBody += $Line.ToString()
    }
    $EmailBody = $EmailBody.Replace("<tr><th>*</th></tr>","<tr><th>Computers</th></tr>")
    Write-Output "Sending email..."
    $EmailSub = "AD Computer Cleanup"
    Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSub -SmtpServer $EmailServer -Body $EmailBody -BodyAsHtml
} else {
    Write-Output "The Computers OU looks good!"
}
