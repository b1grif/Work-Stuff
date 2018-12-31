<#
.SYNOPSIS
    Installs the BL
.PARAMETER LogFolder
    Define where the logs go.

	Defaults to E:\ALISInstallationLogs\
.PARAMETER BLAlisbin
    Destination for BL files
.PARAMETER NewBLFiles
    PSObject for file paths
.NOTES
    Author:            Bill Griffiths
#>
#---------------------------------------------------------[Script Parameters]------------------------------------------------------

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Install-ALISBL {
	[CmdletBinding()]
	param(
        [string]$LogFolder = "E:\ALISInstallationLogs",
        [string]$BLAlisbin,
        [Object]$NewBLFiles
    )
    begin {
		if (!(Test-Path $LogFolder)){
			New-Item -Path $LogFolder -ItemType Directory
		}
        $Log = $LogFolder + '\Install-ALISBL_' +$DateTimeStr + '.log'
        Write-Log -Message "==============================================================================="-Path $LOG -Level Info
        Write-Log -Message "BL installation"-Path $LOG -Level Info
        Write-Log -Message "==============================================================================="-Path $LOG -Level Info
        $BLInstallComplete = 1
    }
	process {
        ForEach ($File in $NewBLFiles) {
            $Message = $null
            $Message = Copy-Item $File $BLAlisbin -PassThru -ErrorAction SilentlyContinue
            If ($Message){
                Write-Log -Message "Installed $File in $BLAlisbin" -Path $LOG -Level Info
                $BLInstallComplete = 0
            } Else {
                Write-Log -Message "Copy Failure -- $File to $BLAlisbin" -Path $LOG -Level Error
            }
        }
        $HashProps = @{
            'BL_Installation' = $BLInstallComplete
        }
		# Output Object
		New-Object -TypeName 'PSCustomObject' -Property $HashProps | Select-Object @SelectHash
	}
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------