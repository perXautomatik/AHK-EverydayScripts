;open In vscode
Custom_Edit(byRef pathToCustomEditor)
{
    If pathToCustomEditor is not space
    {

    try {
            static TITLE := "AhkPad - " A_ScriptFullPath
            if !WinExist(TITLE)
            {
                Run "'%pathToCustomEditor%' '%A_ScriptFullPath%'",,,pid
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
    Else
        MsgBox, empty
}
