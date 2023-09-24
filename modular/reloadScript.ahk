reloadScript(){
    try
    {
        Reload
        Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
        MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
        IfMsgBox, Yes, Edit
        return
    }
    catch e  ; Handles the first error/exception raised by the block above.
    {
        MsgBox, An exception was thrown!`nSpecifically: %e%
        Exit
    }
}