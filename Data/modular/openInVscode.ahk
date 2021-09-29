;open In vscode
Custom_Edit(byRef pathToCustomEditor)
{
    static TITLE := "AhkPad - " A_ScriptFullPath
    if !WinExist(TITLE)
    {
        RunWait, %comspec% /c "%pathToCustomEditor%" "%A_ScriptFullPath%",,, pid
        WinWait ahk_pid %pid%,, 2
        if ErrorLevel
            return
        WinSetTitle %TITLE%
    }
}
