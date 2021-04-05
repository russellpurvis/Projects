<# Program Name : GMFC 
Date: 2/4/2021 
Author: John Purvis 
Course: CIT361 
I, John Purvis, affirm that I wrote this script as original work completed by me. #>


# set scores to 0
[int]$userguess = 1
$array = @( 'l','L','h','H','g','G','q','Q')
$guessed = @()
while ($userguess -ge 0 ) {


   
    Clear-Host
    $SystemColors=[System.Enum]::getvalues([System.ConsoleColor]) #Returns an array of all the possible ConsoleColor Values

    $option = $SystemColors | Get-Random -Count 1
    [string]$color=[System.ConsoleColor]$option
    $StartTime = $(get-date)
    do {
      
    Clear-Host
    write-Host "Press L for list" -ForegroundColor Yellow
    Write-Host "--------------------------------------------------------------"
    Write-Host "Press H for a hint" -ForegroundColor Yellow
    Write-Host "--------------------------------------------------------------"
    Write-Host "Press G for a list of your guesses so far" -ForegroundColor Yellow
    Write-Host "--------------------------------------------------------------"
    Write-Host "Press Q to quit the round" -ForegroundColor Yellow
    Write-Host "--------------------------------------------------------------"
    
    $guess = Read-Host "Guess my favorite color"

    if ($guess -eq 'l' -or $guess -eq 'L' ) {
      Write-Host ($SystemColors -join "`n")
      Start-Sleep -Seconds 5
    }
    elseif ($guess -eq 'h' -or $guess -eq 'H') {
      if ($color -like 'Dar*') {
        Write-Host $color.subString(0,5)
        Start-Sleep -Seconds 2
      }
    else {
      Write-Host $color.subString(0,1)
      Start-Sleep -Seconds 2
    }
    }
    if ($guess -eq 'g' -or $guess -eq 'G') {
      Write-Host ($guessed -join "`n")
      Start-Sleep -Seconds 2
    }
    if ($guess -eq 'q' -or $guess -eq 'Q') {
      exit
    }
    
    
    if ($guess -eq $option){
      Write-Host "Correct, " -NoNewline 
      write-Host $guess -ForegroundColor $option -NoNewline
      Write-Host " is my favorite color";
      $userguess=$userguess + 1
      Write-Host " it took " -NoNewline
      Write-Host $guess.count -NoNewline -ForegroundColor Green
      Write-Host " tries to get the right answer"
      Start-Sleep -Seconds 2
      $guessed = @()
      break
     }
     
     elseif($guess -notin $SystemColors -and $guess -notin $array[0..8]) {
      Write-Host "$guess isn't in the list of options, try again.";
        Start-Sleep -Seconds 2
        $userguess=$userguess + 1
      continue
     }
     
     elseif($guess -in $SystemColors -and $guess -ne $option){
        Write-Host "Incorrect, " -NoNewline
        Write-Host $guess -ForegroundColor $guess -NoNewline
        write-Host " is not my favorite color. Try again."
        Start-Sleep -Seconds 2
        $userguess=$userguess + 1
        $guessed += $guess
        continue
     }
     
     else{
      continue
     }
    }


    Until ($guess -eq $option)
     
    
    $elapsedTime = $(get-date) - $StartTime
      $totalElapsedTime += $elapsedTime
      Write-Host "--------------------------------------------------------------"
      Write-Host "it took you " -NoNewline
      Write-Host $elapsedTime -nonewline -ForegroundColor Cyan 
      Write-Host " to guess the right answer" 
      Write-Host "--------------------------------------------------------------"
      Write-Host "You have been playing for " -nonewline
      Write-Host $totalElapsedTime -ForegroundColor DarkCyan
      Write-Host "--------------------------------------------------------------"
    
    do {$playagain =  Read-Host "Do you want to play again? Y or N"} 
    
    while (("Y","N") -notcontains $playagain)
 
 
    if ($playagain -eq "y"){
        $userguess=1
        $guessed = @()
        continue
  
 }
 
 elseif ($playagain -eq "n"){
  exit
 }
}