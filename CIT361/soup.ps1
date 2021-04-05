function Get-Soup {
        <#
    .SYNOPSIS
    Tells the user whether they get soup or not
    .DESCRIPTION
    Takes data from the user and inserts into parameters to see whether users get soup or not
    .EXAMPLE
    Get-Soup -soup tomato -size Pot -Quantity 2
    #>
    [Alias('Soup')]
    param (
        [Parameter(Mandatory=$true)]
        $soup,
        [Parameter(Mandatory=$true)]
        [ValidateSet('Cup','Bowl','Pot')]
        $size,
        [ValidateRange(1,5)]
        $Quantity = 1,
        [switch] $Please
    )
    if ($please) {
        "$Quantity $size$(if($quantity -gt 1){'s'}) of $soup soup for you."
    }
    else {
        "No $soup soup for you!"
    }
    
}