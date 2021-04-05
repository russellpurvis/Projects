<# Program Name : RPS 
Date: 1/28/2021 
Author: John Purvis 
Course: CIT361 
I, John Purvis, affirm that I wrote this script as original work completed by me. #>


# set scores to 0
[int]$userscore = 0
[int]$computerscore = 0
[int]$usermatch = 0
[int]$computermatch = 0

while ($usermatch -ge 0 ) {


    do {
    Clear-Host
    $option = @("rock","paper","scissors") | Get-Random -Count 1
    Write-Host "Your Score is $userscore" -ForegroundColor Green
    Write-Host "--------------------------------------------------------------"
    Write-Host "The Computer's Score is $computerscore" -ForegroundColor Blue
    Write-Host "--------------------------------------------------------------"
    Write-Host "Games Won: $usermatch " -ForegroundColor Yellow
    Write-Host "--------------------------------------------------------------"
    Write-Host "Games Lost: $computermatch" -ForegroundColor white
    Write-Host "--------------------------------------------------------------"
    Write-Host "Press (r) for rock, (p) for paper, and (s) for scissors"

       $guess = Read-Host "Choice"

       switch -wildcard ( $guess )
       {
      "r*" {$choice = "rock"}
      "p*" {$choice = "paper"}
      "s*" {$choice = "scissors"}
      default {Write-Host "Did you choose one of the three choices?"}
    }
    
    
    if ($choice -eq "rock" -and $option -eq "paper"){
      Write-Host "You lose, The computer chose $option";
      Start-Sleep -Seconds 2
      $computerscore = $computerscore + 1
     }
     
     elseif($choice -eq "paper" -and $option -eq "scissors"){
        Write-Host "You lose, The computer chose $option";
        Start-Sleep -Seconds 2
      $computerscore = $computerscore + 1
     }
     
     elseif($choice -eq "scissors" -and $option -eq "rock"){
        Write-Host "You lose, The computer chose $option";
        Start-Sleep -Seconds 2
      $computerscore = $computerscore + 1
     }
     
     elseif ($choice -eq $option){
      Write-Host "Its a draw, you both chose $option"
      Start-Sleep -Seconds 2
     }
     
     else{
      Write-Host "You won! The computer chose $option"
      Start-Sleep -Seconds 2
      $userscore = $userscore + 1
     }
    }
    
    until (($userscore -eq 3) -or ($computerscore -eq 3))
    
    
    if ($computerscore -gt $userscore){
     Clear-Host
     Write-Host "You lost. computer score = $computerscore points, Your score = $userscore points" -ForegroundColor Red
     Write-Host "--------------------------------------------------------------"
     $computermatch = $computermatch +1
    }
    
    else{
     Clear-Host
     Write-Host "You won. Your score = $userscore Points, the Computer's score = $computerscore" -ForegroundColor Green
     Write-Host "--------------------------------------------------------------"
     $usermatch = $usermatch +1
    }
    Write-Host "Games Won: $usermatch " -ForegroundColor Yellow
    Write-Host "--------------------------------------------------------------"
    Write-Host "Games Lost: $computermatch" -ForegroundColor white
    Write-Host "--------------------------------------------------------------"
    
    
    do {$playagain = Read-Host "Do you want to play again? Y or N"} 
    
    while (("Y","N") -notcontains $playagain)
 
 
    if ($playagain -eq "y"){
        $userscore=0
        $computerscore=0
        continue
  
 }
 
 elseif ($playagain -eq "n"){
   if ($usermatch -gt $computermatch) {
     Write-Host "You are the overall Champion!!!"
     Start-Sleep -Seconds 2
   }

   elseif ($usermatch -lt $computermatch) {
     Write-Host "Sorry, you lost the overall Match."
     Start-Sleep -Seconds 2
   }

   elseif ($usermatch -eq $computermatch) {
     Write-Host "Looks like its an overall tie!"
     Start-Sleep -Seconds 2
    }

  exit
 }
}