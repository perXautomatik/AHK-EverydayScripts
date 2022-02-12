;open In vscode
Custom_Edit()
{
    static TITLE := "AhkPad - " A_ScriptFullPath
    if !WinExist(TITLE)
    {
        Run  "C:\Users\crbk01\Documents\Microsoft VS Code\Code.exe" "%A_ScriptFullPath%",,, pid
        WinWait ahk_pid %pid%,, 2
        if ErrorLevel
            return
        WinSetTitle %TITLE%
    }
}
