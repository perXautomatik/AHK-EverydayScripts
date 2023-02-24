OnMessage(0x111, "WM_COMMAND")
#SingleInstance, Force
#Persistent ;hoping to use exit in end of each module to make sure no thread lingers after execution
SetWorkingDir, %A_ScriptDir% ;To make a script unconditionally use its own folder as its working directory

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


;Timed ToolTip`nThis will be displayed for 1 seconds.
;works
#include modular\loadTooltip.ahk
laodToolTip("reloaded")


;Replaces the currently running instance of the script with a new one.
;https://www.autohotkey.com/docs/commands/Reload.htm
;works
#include modular\reloadScript.ahk
!+r::reloadScript()


;works
#include modular\RestartExplorer.ahk
;shift+win+E to restart explorer
#+e::restartExplorer()

;works
#include modular\rightclickWithg.ahk
^g::sendRightClick()

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
#ifwinactive, AutoHotkey.ahk - Anteckningar
        ^s::SavingReloadsAhkWindow()
#if

;works
#Include Fork\autoklick\auto-clicker-autohotkey-community.ahk
      
#Include modular\HoldDownKey.ahk
#ifwinactive, ahk_exe 7DaysToDie.exe      
        q::HoldDownKey(w)
#if      

;-------------------------unsure/irrelevant
 	  
;#Include modular\repeatSeQience.ahk
#ifwinactive, ahk_exe i_view64.exe
; 	f::repeatSeQuence()									; This defines a hotkey, what it does is defined by the code below until the first return.
#if

#ifwinactive, ahk_exe datagrip64.exe
;    !F2::sendAltShiftEnter() 
#if


#include Fork\CheckIfProgIsRunning\continuouslyAndStartIt.ahk
CheckIfRunning("D:\PortableApps\3. Clipboard\PortableApps\DittoPortable\DittoAutostart.exe","D:\PortableApps\3. Clipboard\PortableApps\DittoPortable\","DittoAutostart.exe")


#include Fork\WindowToforeground\bring-window-to-foreground.ahk
;!+p::toForeground("Ditto") ;not working



;does not work, but atleast prompts error
#include modular\appendClippboard.ahk
!+w::appendClipboard()


#include modular\pushEnterUntil.ahk
!+Enter::pushEnterUntil()

;doesn'tWork (it's called but it doesn't paste the text expected)
#include modular\temp.ahk
!+1::temp()

;doesn't work
;#include modular\pShellAtCurrent.ahk
;#p::pShellAtCurrent()




#include modular\altTab.ahk
#include modular\refreshAhkWindow.ahk



#include modular\ExitPoe.ahk


;todo show current N clipboardContents from ditto or otherwise, 
;   alt+q
; solution?: check out - [ClipBoardMonitor](https://github.com/536/my-startup-ahk-scripts/blob/master/startup/ClipBoardMonitor/ClipBoardMonitor.ahk) - Monitor clipboard changes, show tooltip of word count for text or a temporary GUI for pictures.
;todo paste clipboard at N
;   alt+f...N


ExitApp