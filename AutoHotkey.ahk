OnMessage(0x111, "WM_COMMAND")
#SingleInstance, Force
#Persistent ;hoping to use exit in end of each module to make sure no thread lingers after execution
SetWorkingDir, %A_ScriptDir% ;To make a script unconditionally use its own folder as its working directory

ToolTip,%A_ScriptDir% ; why is %A_WorkingDir% not showing up?



SendMode Input
SetWorkingDir, %A_ScriptDir%



;^-- auto-execute section "toprow"----------------------------------------------------------------
;v-- method implementations ---------------------------------------------------------------

;#include modular\activeExplorerPath.ahk
#include modular\afp.ahk

;MethodCalls;-------------------------------------------------------------------------------


;#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.


;Timed ToolTip`nThis will be displayed for 1 seconds.
;works
#include modular\loadTooltip.ahk
laodToolTip("reloaded")


#include Fork\CheckIfProgIsRunning\continuouslyAndStartIt.ahk
CheckIfRunning("D:\PortableApps\3. Clipboard\PortableApps\DittoPortable\DittoAutostart.exe","D:\PortableApps\3. Clipboard\PortableApps\DittoPortable\","DittoAutostart.exe")



;Replaces the currently running instance of the script with a new one.
;https://www.autohotkey.com/docs/commands/Reload.htm
;works
#include modular\reloadScript.ahk
!+r::reloadScript()



;shift+win+E to kill explorer
#+e::
   Run, taskkill.exe /im explorer.exe /f
Return
;ctrl+shift+e to run explorer
^+e::
   Run, explorer.exe
Return
;rightclick with ctrl+G
^+g::
Send, {Rbutton}


;works
#include modular\SnipPrinting.ahk


;works
#include modular\pasteAsFile.ahk
^+v::pasteAsFile()

;works
#include modular\volumePageUpdown.ahk

;works
#include modular\ctrlEnterToexecute.ahk
#ifwinactive, ahk_exe powershell_ise.exe
    ^Enter::sendF8()
#ifwinactive, - AutoHotkey ahk_exe AutoHotkey.exe
    ^Enter::sendF5()
#if

;works
#Include modular\SavingReloades.ahk
#ifwinactive,* AutoHotkey.ahk - Notepad2
	^s::SavingReloadsAhkWindow()
#if

#include modular\pushEnterUntil.ahk
!+Enter::pushEnterUntil()

;unsure/irrelevant

;doesn't work
#include modular\pShellAtCurrent.ahk
#t::pShellAtCurrent()

;not working, better use custom settings in program
#include modular\altShiftEnter.ahk
#ifwinactive, ahk_exe datagrip64.exe
    !F2::sendAltShiftEnter()
#if

;does not work, but atleast prompts error
#include modular\appendClippboard.ahk
!+w::appendClipboard()


;Work, could be reused as paste variable content
#include modular\temp.ahk
!+1::temp()

#include modular\altTab.ahk
#include modular\refreshAhkWindow.ahk

#IfWinActive, MTGA
Space::
while not(GetKeyState("LButton"))
{
	IfWinActive, MTGA
	{
		SendInput {Space}
		SendInput {Click}
		Sleep, 1000
	}

}