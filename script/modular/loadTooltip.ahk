laodToolTip(inputString){
    try
    {
        #Persistent
            ToolTip, %inputString%
            SetTimer, RemoveToolTip, -1000
            return

           RemoveToolTip:
           tooltip
           return
    }
    catch e  ; Handles the first error/exception raised by the block above.
    {
        MsgBox, An exception was thrown!`nSpecifically: %e%
        Exit
    }
}