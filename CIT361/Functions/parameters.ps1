function add($n1,$n2){
    Write-Host "N1 is $n1"
    Write-Host "N2 is $n2"
    Write-Host "$n1 + $n2 = $($n1 + $n2)"
    Write-Host "Args = $args"
    Write-Output ($n1 + $n2) #same as if you get rid of write-output

}
#add 1 5
#add -n1 1 -n2 4
#add -n2 '1' 4


function addit{
    param(
        [int]$n1,
        [int]$n2
    )
    Write-Host "N1 is $n1"
    Write-Host "N2 is $n2"
    Write-Host "$n1 + $n2 = $($n1 + $n2)"
    Write-Host "Args = $args"
    $total = ($n1 + $n2) 
    foreach($a in $args){
        $total+=$a
    }
    $total
}


function get-soup([switch]$please,$soup='tomato'){
    if ($please) {
        "$soup soup for you."
    }else {
        "No $soup soup for you"
    }
        
}


function Switchdemo {
    $answer=Read-Host "Do you want to include sub directories?"
    $r=$false
    if ($answer -like 'y*') {
        $r=$true
    }
    <#if ($r) {
        Get-ChildItem -Recurse
    }else {
        Get-ChildItem
    }#>
    Get-ChildItem -recurse:$r
}

function greet($first,$last){
    "Hello $first $last"
    greet @h
}