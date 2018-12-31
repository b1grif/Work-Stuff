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

function Install-ALISPLSL {
	[CmdletBinding()]
	param(
        [string]$LogFolder = "E:\ALISInstallationLogs",
        [string]$PLorSL,
        [string]$DestFolder, # TomcatPLWebapps\alis_pl\
        [string]$Warfile,
        $LOG = $LOGFolder + '\Install-ALISPLSL_' +$DateTimeStr + '.log'
    )
    begin {
        Write-Log -Message "==============================================================================="-Path $LOG -Level Info
        Write-Log -Message "$PLorSL installation"-Path $LOG -Level Info
        Write-Log -Message "==============================================================================="-Path $LOG -Level Info
        $InstallComplete = 1
        Remove-Item -Path $DestFolder'\alis_'$PLorSL'.war' -Force | Out-Null
        if (Test-Path $DestFolder'\alis_'$PLorSL'.war'){
            Write-Log -Message "Error - Didnt delete the alis_$PLorSL.war file" -Path $LOG -Level Error
        } else {
            Write-Log -Message "Deleted $($DestFolder)alis_$($PLorSL).war" -Path $LOG -Level Info
        }
        Remove-Item -Path $DestFolder'\alis_'$PLorSL -Recurse -Force  | Out-Null
        if (Test-Path $DestFolder'\alis_'$PLorSL){
            Write-Log -Message "Error - Didnt delete the alis_$PLorSL folder" -Path $LOG -Level Error
        } else {
            Write-Log -Message "Deleted $($DestFolder)alis_$($PLorSL) folder" -Path $LOG -Level Info
        }
    }
	process {
        $Message = Copy-Item $Warfile $DestFolder'\alis_'$PLorSL'.war' -PassThru -ErrorAction SilentlyContinue
        If ($Message){
            Write-Log -Message "Installed $Message" -Path $LOG -Level Info
            $InstallComplete = 0
        } Else {
            Write-Log -Message "Copy Failure -- $Warfile to $DestFolder" -Path $LOG -Level Error
        }
        $HashProps = @{
            'Installation' = $InstallComplete
        }
		# Output Object
		New-Object -TypeName 'PSCustomObject' -Property $HashProps | Select-Object @SelectHash
	}
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------
