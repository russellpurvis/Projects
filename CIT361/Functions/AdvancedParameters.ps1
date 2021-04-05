function greet {
    <#
    .SYNOPSIS
    Use greet to send a message to your friend
    .DESCRIPTION
    A description
    .EXAMPLE
    Greet-Snoopy
    #>
    [alias('Hi')]
    param (
        [parameter(
            Mandatory=$true,
            HelpMessage="Enter a first name."
        )]
        [alias('name')]
        $firstname,
        $lastname
    )
    "Hello $firstname $lastname"
}