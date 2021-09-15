#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
OnMessage(0x111, "WM_COMMAND")

WM_COMMAND(wParam)
{
    if (wParam = 65401 ; ID_FILE_EDITSCRIPT
         || wParam = 65304) ; ID_TRAY_EDITSCRIPT
    {
        Custom_Edit()
        return true
    }
}
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

;^-- auto-execute section "toprow"----------------------------------------------------------------

;v-- method implementations ---------------------------------------------------------------

#include modular\activeExplorerPath.ahk


GetExtension(vpath) {
return  RegExReplace(vPath, "^.*?((\.(?!.*\\)(?!.*\.))|$)")  
}

; based on ActiveFolderPath() by Scoox https://autohotkey.com/board/topic/70960-detect-current-windows-explorer-location/
AFP(WinTitle="A")
{
    WinGetClass, Class, %WinTitle%
    If (Class ~= "Program|WorkerW") ;desktop
    {
        WinPath := A_Desktop
    }
    Else ;all other windows
    {
        WinGetText, WinPath, A
        RegExMatch(WinPath, ".:\\.*", WinPath)
        for w in ComObjCreate("Shell.Application").Windows    ; grab the folder path
        {
            aac = % w.Document.Folder.Self.Path
            if (WinPath=aac) {
                valid:=1
                break
            }
        }   
    }
 if !valid
    return
    WinPath := RegExReplace(WinPath, "\\+$") 
    If WinPath 
        WinPath .= "\"
    Return WinPath
}


;MethodCalls;-------------------------------------------------------------------------------


;#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.

#SingleInstance force

#include modular\pasteAsFile.ahk

#include modular\altTab.ahk



#include modular\refreshAhkWindow.ahk

#include modular\appendClippboard.ahk


#include modular\ctrlEnterToexecute.ahk

#include modular\RestartExplorer.ahk
#include modular\rightclickWithg.ahk

#include modular\volumePageUpdown.ahk

#Include modular\SavingReloades.ahk

#include modular\SnipPrinting.ahk
#include modular\ExitPoe.ahk
#include modular\pShellAtCurrent.ahk