function add($n1,$n2,[switch]$concatenate){
   begin{
       if($concatenate){
           $total=''
       }else{
        $total=0
       }

        $total+=$n1
        $total+=$n2
        foreach($a in $args){$total+=$a}
   }
    

    process{
        $total+=$_
    }

    end{
        $total
    }

}
1..10|ForEach-Object -Begin {'counting';$t=0} -Process {$t+=$_} -End $t
