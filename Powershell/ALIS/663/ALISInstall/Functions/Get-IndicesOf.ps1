<#
.SYNOPSIS
    Returns the number of the object in an array
.PARAMETER Array
    Array of objects
.PARAMETER Value
    Value to find
.OUTPUTS
    string
.NOTES
    Author:            Bill Griffiths
#>
#---------------------------------------------------------[Script Parameters]------------------------------------------------------

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Get-IndicesOf {
	[CmdletBinding()]
	param(
        [object]$Array,
        [string]$Value
    )
    begin{
        $i = 0
    }
	process {
        foreach ($obj in $Array) {
            if ($obj -eq $Value) {
                $i
            }
            ++$i
        }
    }
    end {
    }
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------
