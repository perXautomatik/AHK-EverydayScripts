;"vision" 

!+1::
    {
        SendRaw, `A`
        Sleep 1000
        SendRaw, `vslutningsinitiativ`
        Sleep 1000
        SendRaw, `sommaren 2021` ;paste "Avslutningsinitiativ sommaren 2021"
        Sleep 1000
        ;säker på att du vill ändra ett avslutat ärende
        SendInput, {enter}
        Sleep 100
        ;save and close
        SendInput, ^+s
        return
    }
