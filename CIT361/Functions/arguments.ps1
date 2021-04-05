function hi{
    $args[0].GetType()
    '-'*20
    #$args[1].GetType()
}


function greet{
    if ($args.count -eq 0) {
        Write-Host  "Who do you want to say hi to?"
    }else {
        "Hello $args"
    }

}


function ql{$args}

