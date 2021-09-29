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
!+r::
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



#include modular\RestartExplorer.ahk
#include modular\rightclickWithg.ahk
#include modular\pShellAtCurrent.ahk
#include modular\SnipPrinting.ahk

#include modular\volumePageUpdown.ahk
#include modular\pasteAsFile.ahk
;Module: paset as file
;^+v::pasteAsFile()
#include modular\temp.ahk


#include modular\appendClippboard.ahk
#include modular\ctrlEnterToexecute.ahk

#Include modular\SavingReloades.ahk
#include modular\altTab.ahk
#include modular\refreshAhkWindow.ahk
#include modular\ExitPoe.ahk


ExitApp