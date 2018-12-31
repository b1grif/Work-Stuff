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

function Install-ALISConfFiles {
	[CmdletBinding()]
	param(
        [string]$LogFolder = "E:\ALISInstallationLogs",
        [string]$TomcatConfAlis,
        [string]$FileName,
        [object]$FileValues,
        $LOG = $LOGFolder + '\Install-ALISConfFiles_' +$DateTimeStr + '.log'
    ) 
    begin {
        $InstallComplete = 1
        if (Test-Path "$TomcatConfAlis"){
            $ConfPath = "$TomcatConfAlis\"
        } else {
            Write-Log -Message "Error finding $TomcatConfAlis folder" -Path $LOG -Level Error
        }
    }
	process {
        If (Test-Path "$ConfPath$FileName"){
            Remove-Item -Path "$ConfPath$FileName" -Force
            If (Test-Path "$ConfPath$FileName"){
                Write-Log -Message "Error deleting $ConfPath$FileName" -Path $LOG -Level Error
            } Else {
                Write-Log -Message "$ConfPath$FileName was deleted" -Path $LOG -Level Info
                New-Item -Path "$ConfPath$FileName" -ItemType File 
                Add-Content -Path "$ConfPath$FileName" -Value $FileValues
                Write-Log -Message "New $ConfPath$FileName file copied" -Path $LOG -Level Info
                $InstallComplete = 0
            }
        } Else {
            New-Item -Path "$ConfPath$FileName" -ItemType File 
            Add-Content -Path "$ConfPath$FileName" -Value $FileValues
            Write-Log -Message "New $ConfPath$FileName file copied" -Path $LOG -Level Info
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
