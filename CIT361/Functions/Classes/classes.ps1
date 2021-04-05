class Device{
    $Name
    [ipaddress]$IpAddress
    $MacAddress
}

$d=[Device]::new()
$d.IpAddress='1.2.3.4'
$d.Name="Printer"
$d.MacAddress='ab:12:34:56:78:56'

#$d=[Device]@{IpAddress='10.0.1.2';Name='Sever1'}


class Metal {
    [String]$Symbol
    [string]$Name
    [int]$MeltingPoint
    [double]$specificGravity
}
$m=Import-Csv .\Metals.csv|ForEach-Object {[metal]$_}


class Circle{
    hidden static $pi=3.1415927
    [double]$radius=0
    [string]$color='Transparent'
    Circle(){}
    Circle($radius){
        $this.radius=$radius
    }


    static [double] Area([double]$radius){
        return [Circle]::pi * [math]::Pow($radius,2)
    }

    [double] Area(){
        return [Circle]::pi * [math]::pow($this.radius,2)
    }
}
class bettercircle:Circle{
    betterCircle(){}
    betterCircle($radius){
        $this.radius=5
    }
    $texture='smooth'
    [double]Circumference(){
        return 2 * [math]::pi * $this.radius
    }
}

enum rarity{common=0;semiprecious=1;precious=2}
[rarity]$r=precious