temp()
    {

        Var := "
(
avslutningsinitiativ sommaren 2021
)"

        SendInput %var% ;paste "Avslutningsinitiativ sommaren 2021"
        Sleep 1000
        ;säker på att du vill ändra ett avslutat ärende
        SendInput, {enter}
        Sleep 100
        ;save and close
        SendInput, ^+s
        exit
    }
