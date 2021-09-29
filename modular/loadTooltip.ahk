try
{
    #Persistent
        ToolTip, Reloaded
        SetTimer, RemoveToolTip, -1000
        return

}
catch e  ; Handles the first error/exception raised by the block above.
{
    MsgBox, An exception was thrown!`nSpecifically: %e%
    Exit
}