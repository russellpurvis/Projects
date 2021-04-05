$a = " "
$c = 0

Write-Host "I can count faster than you can. Watch!"
Start-Sleep -Seconds 4
$StartTime = $(get-date)
do {
    
    Write-Host $a -NoNewline
    $c += 1
    $c
} until ($c -ge 1000)

$elapsedTime = $(get-date) - $StartTime
      $totalTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)
      $totalElapsedTime += $elapsedTime
      Write-Host "$elapsedTime"
      Write-Host "AND DONE!!!" 