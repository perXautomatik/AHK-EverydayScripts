;lets me open a command prompt at the location I'm open in windows explorer. If the current window is not a explorer window then the prompt opens at the location where the ;script is present. I would like to change this behavior and make it open from C:\

pShellAtCurrent(){
    try{
        if WinActive("ahk_class CabinetWClass") 
        or WinActive("ahk_class ExploreWClass")
        {
            Send {Shift Down}{AppsKey}{Shift Up}
            Sleep 10
            Send {enter}
        }
        else
        {
            EnvGet, SystemRoot, SystemRoot
            Run %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy unrestricted
        }
    return
    }
    catch e  ; Handles the first error/exception raised by the block above.
    {
        MsgBox, An exception was thrown!`nSpecifically: %e%
        Exit
    }
    exit
}