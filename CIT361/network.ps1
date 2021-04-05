function Get-IPNetwork {
    param (
        [ipaddress]$IPAddress,
        [ipaddress]$SubnetMask
    )

    $networkid=[net.ipaddress]($IPAddress.address -band $SubnetMask.address)
    return $networkid

}

function Test-IPNetwork {
    param (
       [parameter(
           Mandatory=$true,
           HelpMessage="Enter a IP address."
       )]
       
        [ipaddress]$IP1,
        [ipaddress]$IP2,
        [ipaddress]$SubnetMask
    )
    $networkID1=[net.ipaddress]($IP1.address -band $SubnetMask.address)
    $networkID2=[net.ipaddress]($IP2.address -band $SubnetMask.address)

   if ($networkID1.address -eq $networkID2.address) {
       Write-Output $True
   }
   elseif ($networkID1.address -ne $networkID2.address) {
       Write-Output $false
   }
   else {
       return $null
   }

    
}



function UserIP {
    
    $address1=Read-Host "Please Input IP address 1"
    $address2=Read-Host "Please Input IP address 2"
    $SubnetMask=Read-Host "Please Input SubnetMask"
    $address1=[ipaddress]$address1 
    $address2=[ipaddress]$address2
    $SubnetMask=[ipaddress]$SubnetMask
    $networkID1=[net.ipaddress]($address1.address -band $SubnetMask.address)
    $networkID2=[net.ipaddress]($address2.address -band $SubnetMask.address)
    Write-Host "IP address 1 is $address1 with the network address of $networkID1"
    Write-Host "IP address 2 is $address2 with the network address of $networkID2"
    
    $iparray=$networkID1,$networkID2

    if ($iparray[0] -eq $iparray[1]) {
        Write-Host "The IP addresses $address1 and $address2 are on the same network"
        
    }
    else {
        Write-Host "The IP addresses $address1 and $address2 are not on the same network"
    }

}
