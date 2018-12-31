<#
.SYNOPSIS
    Uses the CSV created by Get-ADPassInfo to know what accounts to set a random password
.NOTES
    Author:            Bill Griffiths

    Change Log -- Change $ScriptVersion

    0.0.1 - Script created.
#>
#---------------------------------------------------------[Script Parameters]------------------------------------------------------
Param(
    [string]$Path,
    [string]$Log,
    [string]$AssignedPerson,
    [switch]$OnlyDisabled,
    [string]$Identity
)
#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#----------------------------------------------------------[Declarations]----------------------------------------------------------
$ScriptVersion = '0.1.0'


# Get list of accounts
$FinishedPath = ".\Passwords\RandomPasswords.xlsx"

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Set-RandomPassword {
    [CmdletBinding(
        DefaultParameterSetName='Excel',
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High'
    )]
    Param (
        [Parameter(
            Mandatory=$false,
            ParameterSetName='Excel'
            )]
        [Parameter(
            Mandatory=$false,
            ParameterSetName='Identity'
            )]
        [string]$Path = '.\Passwords',

        [Parameter(
            Mandatory=$false,
            ParameterSetName='Excel'
            )]
        [Parameter(
            Mandatory=$false,
            ParameterSetName='Identity'
            )]
        [string]$Log='.\logs\' + $MyInvocation.MyCommand.Name + '_' + (Get-Date).ToString('MM-dd-yyyy_hhmm') + '.log',

        [Parameter(
            Mandatory=$false,
            ParameterSetName='Excel'
            )]
        [string]$AssignedPerson,

        [Parameter(
            Mandatory=$false,
            ParameterSetName='Excel'
            )]
        [switch]$OnlyDisabled,

        [Parameter(
            Mandatory=$false,
            ParameterSetName='Identity'
            )]
        [string]$Identity

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

        Write-Log -ScriptVersion $ScriptVersion -Path $LOG -Level Info
        $XLSX = Get-ChildItem -Path $Path -File |
            Sort-Object -Property LastWriteTime -Descending |
            Select-Object -First 1
        Write-Log -Message "Im importing $($XLSX.FullName)" -Path $LOG -Level Info
        # Get the list of accounts with groups
        $AllAccounts = Import-Excel -Path $XLSX.FullName

    }
    Process {
        if ($PSCmdlet.ParameterSetName -eq 'Excel'){
            if ($OnlyDisabled -eq $true){
                Write-Log -Message "Im finding only the disabled accounts..."  -Path $LOG -Level Info
                $RandPassAccounts = $AllAccounts |
                    Where-Object {$_.Group -eq 'RandomPassword'} |
                    Where-Object {$_.Enabled -eq $false}
                Write-Log -Message "I found $($RandPassAccounts.count) accounts..."  -Path $LOG -Level Info
            } elseif ($AssignedPerson){
                Write-Log -Message "Im getting all accounts..."  -Path $LOG -Level Info
                $RandPassAccounts = $AllAccounts |
                    Where-Object {($_.Group -eq 'RandomPassword') -and ($_."Assigned person" -eq $AssignedPerson)}
                $Count = ($RandPassAccounts | Measure-Object).Count
                if ($RandPassAccounts){
                    Write-Log -Message "I found $Count accounts..."  -Path $LOG -Level Info
                } else {
                    Write-Log -Message "$AssignedPerson doesnt have any accounts left with the RandomPassword setting" -Path $LOG -Level Error
                    Break
                }
            } else {
                Write-Log -Message "Im getting all accounts..."  -Path $LOG -Level Info
                $RandPassAccounts = $AllAccounts |
                    Where-Object {$_.Group -eq 'RandomPassword'}
                $Count = ($RandPassAccounts | Measure-Object).Count
                Write-Log -Message "I found $Count accounts..."  -Path $LOG -Level Info
            }
        } else {
            Write-Log -Message "Im getting all accounts..."  -Path $LOG -Level Info
            $RandPassAccounts = $AllAccounts |
                Where-Object {($_.Group -eq 'RandomPassword') -and ($_.SamAccountName -eq $Identity)}
            $Count = ($RandPassAccounts | Measure-Object).Count
            if ($RandPassAccounts){
                Write-Log -Message "I found $Count accounts..."  -Path $LOG -Level Info
            } else {
                Write-Log -Message "I couldnt find $Identity with the RandomPassword setting" -Path $LOG -Level Error
                Break
            }
        }


        foreach ($Account in $RandPassAccounts){
            # Check if already updated
            $ExpiryTest = Get-ADUser -Identity $Account.SamAccountName -Properties $Properties |
                Select-Object -Property $SelectObjProp
            if ($ExpiryTest.PasswordLastSet -gt ((Get-Date).AddDays(-90))){
                # Already reset!
                Write-Log -Message "I checked and $($Account.SamAccountName) was reset on $($ExpiryTest.PasswordLastSet)" -Path $Log -Level Info
            } else {
                # Still outside the password policy
                if ($PSCmdlet.ShouldProcess("$($Account.SamAccountName)","Set-RandomPassword")){
                    $counter ++
                    Write-Progress -Activity 'Set-RandomPassword' -Status "Processing" -CurrentOperation $Account.SamAccountName -PercentComplete ($counter / ($Count) * 100)
                    # Generate password
                    $NewPassword = ([char[]]([char]33..[char]95) + ([char[]]([char]97..[char]126)) + 0..9 |
                        Sort-Object {Get-Random})[0..19] -join ''
                    # Set password
                    Set-ADAccountPassword -Identity $Account.SamAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $NewPassword -Force)
                    Write-Log -Message "I set a new password for $($Account.SamAccountName)" -Path $Log -Level Info
                    Set-ADUser -Identity $Account.SamAccountName -Replace @{info='RandomPassword'}
                    Write-Log -Message "I set the Notes section in AD for $($Account.SamAccountName)" -Path $Log -Level Info
                } else {
                    Write-Log -Message "I skipped $($Account.SamAccountName)" -Path $Log -Level Info
                }
            }
        }
    }
    End {
        Write-Output "Finished"
    }
}
#-----------------------------------------------------------[Execution]------------------------------------------------------------
if ($Identity){
    Set-RandomPassword -Identity $Identity
} elseif ($AssignedPerson) {
    Set-RandomPassword -AssignedPerson $AssignedPerson
} elseif ($OnlyDisabled -eq $true) {
    Set-RandomPassword -OnlyDisabled
} else {
    Set-RandomPassword
}
