;open In vscode
Custom_Edit(byRef customEditorPath)
{
    {

    try {
    static TITLE := "AhkPad - " A_ScriptFullPath
    if !WinExist(TITLE)
    {
        Run "%pathToCustomEditor%" "%A_ScriptFullPath%",,, pid
        WinWait ahk_pid %pid%,, 2
        if ErrorLevel
            return
        WinSetTitle %TITLE%
    }
    exit
    } catch e {
        MsgBox, An exception was thrown!`nSpecifically: %e%
        Exit
    }
    }
}
