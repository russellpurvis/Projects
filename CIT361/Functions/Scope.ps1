function foo{
    write-host "I'm in foo the value of `$x is $x"
    $y=10
    Write-Host "`$y in foo is $y"
    "Changing `$x to 10"
    $x = 10
    write-host "I'm in foo the value of `$x is $x"
    write-host "I'm in foo the value of global `$x is $global:x"
    "Changing global `$x to 100"
    $global:x=100
}
$x=1
foo
Write-Host "`$y is $y"
Write-Host "`$x is $x"