#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
OnMessage(0x111, "WM_COMMAND")

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

#include modular\openInVscode.ahk

#include modular\getExtension.ahk

;^-- auto-execute section "toprow"----------------------------------------------------------------

;v-- method implementations ---------------------------------------------------------------

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
#include modular\loadTooltip.ahk


#include modular\reloadScript.ahk
#include modular\RestartExplorer.ahk
#include modular\rightclickWithg.ahk
#include modular\pShellAtCurrent.ahk
#include modular\SnipPrinting.ahk

#include modular\volumePageUpdown.ahk
#include modular\pasteAsFile.ahk
laodToolTip("reloaded")

!+r::reloadScript()


;Module: paset as file
^+v::pasteAsFile()
#include modular\temp.ahk

;"vision" 
!+1::temp()

#include modular\appendClippboard.ahk
#include modular\ctrlEnterToexecute.ahk

#Include modular\SavingReloades.ahk
#include modular\altTab.ahk
#include modular\refreshAhkWindow.ahk
#include modular\ExitPoe.ahk


ExitApp