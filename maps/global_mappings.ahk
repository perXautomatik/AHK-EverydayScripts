;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GLOBAL KEYBINDINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#SingleInstance, Force
#Persistent ;hoping to use exit in end of each module to make sure no thread lingers after execution
SetWorkingDir, %A_ScriptDir% ;To make a script unconditionally use its own folder as its working directory

ToolTip,%A_ScriptDir% ; why is %A_WorkingDir% not showing up?

SendMode Input
SetWorkingDir, %A_ScriptDir%
OnMessage(0x111, "WM_COMMAND")
#include modular\openInVscode.ahk

customEditorPath := "C:\Users\dator\AppData\Local\Programs\Microsoft VS Code\Code.exe"
;doesn'tWork (it does open the folder of ahk script but doesn't open vscode)

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

;Timed ToolTip`nThis will be displayed for 1 seconds.
#include modular\loadTooltip.ahk
laodToolTip("reloaded")



;shift+win+E to Kill\Restart Explorer
#include modular\RestartExplorer.ahk
#+e::restartExplorer()

;works
#include modular\pasteAsFile.ahk
^+v::pasteAsFile()
;todo show current N clipboardContents from ditto or otherwise,
;   alt+q
; solution?: check out - [ClipBoardMonitor](https://github.com/536/my-startup-ahk-scripts/blob/master/startup/ClipBoardMonitor/ClipBoardMonitor.ahk) - Monitor clipboard changes, show tooltip of word count for text or a temporary GUI for pictures.
;todo paste clipboard at N
;   alt+f...N


ExitApp