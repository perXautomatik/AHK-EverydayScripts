temp()
    {

        var := "avslutningsinitiativ"
        var2 := " sommaren 2021"
        var3 = % var var2

        laodToolTip(var3)
        SendInput %var3% ;paste "Avslutningsinitiativ sommaren 2021"
        Sleep 1000
        ;säker på att du vill ändra ett avslutat ärende
        SendInput, {enter}
        Sleep 100
        ;save and close
        SendInput, ^+s
        exit
    }
