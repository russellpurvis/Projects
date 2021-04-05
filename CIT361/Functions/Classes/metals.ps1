param($filename)
class Metal {
    [String]$Symbol
    [string]$Name
    [int]$MeltingPoint
    [double]$specificGravity
}
$m=Import-Csv $filename|ForEach-Object {[metal]$_}

$m|sort MeltingPoint