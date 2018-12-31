<#
.SYNOPSIS
    Creates a CSV for with all AD accounts except for passwords that have changed in the past 90 days
.DESCRIPTION
    This script is to be used in tandem with Set-RandomPassword.ps1
    This script pulls the AD info
.INPUTS
    Active Directory
.OUTPUTS
    .\shared\ts\2018\Passwords\Users_MM-dd-yyyy_hhmm.xlsx
.NOTES
    Author:            Bill Griffiths

    Change Log -- Change $ScriptVersion
    0.1.0 - Script working
    0.0.1 - Script created.
#>
#---------------------------------------------------------[Script Parameters]------------------------------------------------------

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#----------------------------------------------------------[Declarations]----------------------------------------------------------
$ScriptVersion = '0.1.0'

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Get-ADPassInfo {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]
        [string]$Path,

        [Parameter(Mandatory=$false)]
        [string]$Name = 'Users' + '_' + ((Get-Date).ToString('MM-dd-yyyy_hhmm')) + '.xlsx'
    )
    Begin {
        $Properties = @(
            "DisplayName",
            "Description",
            "EmailAddress",
            "Created",
            "Enabled",
            "LockedOut",
            "PasswordLastSet",
            "msDS-UserPasswordExpiryTimeComputed",
            "CannotChangePassword",
            "PasswordneverExpires",
            "DistinguishedName",
            "SamAccountName",
            "info"
        )

        $SelectObjProp = @(
            "DisplayName",
            "SamAccountName",
            "Confirmation",
            @{
                Name="Group";
                Expression={
                    if ($null -eq $_.info){
                        $null
                    } else {
                        $_.info
                    }
                }
            },
            "Description",
            "EmailAddress",
            "Created",
            "Enabled",
            "LockedOut",
            "PasswordLastSet",
            @{
                Name="PasswordExpiry";
                Expression={
                    if ($_."msDS-UserPasswordExpiryTimeComputed" -eq 0){
                        'Change pw next logon'
                    } else {
                        [datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")
                    }
                }
            },
            @{
                Name="PasswordAge";
                Expression={
                    (New-TimeSpan -Start ($_.PasswordLastSet) -End (Get-Date)).Days
                }
            },
            "CannotChangePassword",
            "PasswordneverExpires",
            @{
                Name="DistinguishedName";
                Expression={
                    $_.DistinguishedName -replace "CN=.*,OU","OU"
                }
            }
        )
    }

    Process {
        # Create the spreadsheet for passwords expired more than 90 days ago
        $AllUsers = Get-AdUser -Filter * -Properties $Properties |
            Select-Object -Property $SelectObjProp |
            Where-Object {$_.PasswordLastSet -lt ((Get-Date).AddDays(-90))} |
            Sort-Object -Property PasswordAge -Descending
        if (Test-Path $Path){
            $AllUsers | Export-Excel -Path "$Path\$Name"
        } else {
            Write-Output "$Path doesnt exist!"
        }
    }
    End {
        Write-Output "All done"
    }
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Get-ADPassInfo