;"vision" 

^#1::
    ;paste "Avslutningsinitiativ sommaren 2021"
    SendInput {Raw} Avslutningsinitiativ sommaren 2021
    Sleep, Delay 100
    ;säker på att du vill ändra ett avslutat ärende
    SendInput, {enter}
    Sleep, Delay 100
    ;save and close
    SendInput, ^+s

return