<#
.SYNOPSIS
    Tests to make sure that the drives were given the correct letters
.PARAMETER Type
    ALIS Server environment type... Seperate or AIO
.NOTES
    Author:            Bill Griffiths
#>
#---------------------------------------------------------[Script Parameters]------------------------------------------------------

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Install-ALISLog4j {
	[CmdletBinding()]
	param(
        [string]$LogFolder = "E:\ALISInstallationLogs",
        [string]$PLorSL,
        [string]$TomcatConfAlis,
        [string]$AlisRepo,
        $LOG = $LOGFolder + '\Install-ALISLog4j_' +$DateTimeStr + '.log'
    )
    begin {
        $InstallComplete = 1
        
        If ($PLorSL -eq "pl"){
            if (Test-Path "$TomcatConfAlis"){
                $Log4j = "$TomcatConfAlis\alis-pl-log4j.xml"
            } else {
                Write-Log -Message "Error finding $TomcatConfAlis folder" -Path $LOG -Level Error
            }
        } ElseIf ($PLorSL -eq "sl"){
            if (Test-Path "$TomcatConfAlis"){
                $Log4j = "$TomcatConfAlis\alis-sl-log4j.xml"
            } else {
                Write-Log -Message "Error finding $TomcatConfAlis folder" -Path $LOG -Level Error
            }
        } Else {
            Write-Log -Message "Error $PLorSL isnt pl or sl" -Path $LOG -Level Error
        }
    }
	process {
        If (Test-Path $Log4j){
            Remove-Item -Path $Log4j
            If (Test-Path $Log4j){
                Write-Log -Message "Error deleting $Log4j" -Path $LOG -Level Error
            } Else {
                Write-Log -Message "$Log4j was deleted" -Path $LOG -Level Info
                Copy-Item -Path $AlisRepo'\alis-'$PLorSL'-log4j.xml' -Destination $Log4j
                Write-Log -Message "New $Log4j file copied" -Path $LOG -Level Info
                $InstallComplete = 0
            }
        } Else {
            Copy-Item -Path $AlisRepo'\alis-'$PLorSL'-log4j.xml' -Destination $Log4j
            Write-Log -Message "New $Log4j file copied" -Path $LOG -Level Info
            $InstallComplete = 0
        }
        $HashProps = @{
            'Installation' = $InstallComplete
        }
		# Output Object
		New-Object -TypeName 'PSCustomObject' -Property $HashProps | Select-Object @SelectHash
	}
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------
