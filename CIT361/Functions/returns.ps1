function foo{
    $args.Count
    if ($args.count -gt 0) {
        $args[0]
    }

}

function Test-Odd($number) {
    $number #same as write-output
    write-host "The number was $number" -foregroundcolor green 
    Write-output "Hi mom"
    if($number % 2 -eq 1){
        return $true
    }else {
        return $false
    }
}