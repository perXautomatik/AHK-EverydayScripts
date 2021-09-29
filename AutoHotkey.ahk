#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
OnMessage(0x111, "WM_COMMAND")
#include modular\openInVscode.ahk

customEditorPath := "C:\Users\crbk01\Documents\Microsoft VS Code\Code.exe"


WM_COMMAND(wParam)
{
    if (wParam = 65401 ; ID_FILE_EDITSCRIPT
         || wParam = 65304) ; ID_TRAY_EDITSCRIPT
    {
        Custom_Edit(%customEditorPath%) ;open In vscode
        return true
    }
}




;^-- auto-execute section "toprow"----------------------------------------------------------------
;v-- method implementations ---------------------------------------------------------------

#include modular\getExtension.ahk
#include modular\activeExplorerPath.ahk
#include modular\afp.ahk

;MethodCalls;-------------------------------------------------------------------------------


;#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.


;Replaces the currently running instance of the script with a new one.
;https://www.autohotkey.com/docs/commands/Reload.htm

;Timed ToolTip`nThis will be displayed for 1 seconds.


#include modular\RestartExplorer.ahk
#include modular\rightclickWithg.ahk


#include modular\SnipPrinting.ahk
#include modular\volumePageUpdown.ahk


#include modular\loadTooltip.ahk
laodToolTip("reloaded")

#include modular\reloadScript.ahk
!+r::reloadScript()


#include modular\pasteAsFile.ahk
^+v::pasteAsFile()



#include modular\temp.ahk
!+1::temp()


#include modular\pShellAtCurrent.ahk
<#t::pShellAtCurrent()

#include modular\appendClippboard.ahk
#include modular\ctrlEnterToexecute.ahk

#Include modular\SavingReloades.ahk
#include modular\altTab.ahk
#include modular\refreshAhkWindow.ahk
#include modular\ExitPoe.ahk


ExitApp