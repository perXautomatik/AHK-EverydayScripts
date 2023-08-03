OnMessage(0x111, "WM_COMMAND")
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

WM_COMMAND(wParam)
{
    if (wParam = 65401 ; ID_FILE_EDITSCRIPT
         || wParam = 65304) ; ID_TRAY_EDITSCRIPT
    {
        Custom_Edit()
        return true
    }
}
OnMessage(0x111, "WM_COMMAND")


Custom_Edit()
{
    static TITLE := "AhkPad - " A_ScriptFullPath
    if !WinExist(TITLE)
    {
        Run  "E:\Program Files\Microsoft VS Code\Code.exe" "%A_ScriptFullPath%",,, pid
        WinWait ahk_pid %pid%,, 2
        if ErrorLevel
            return
        WinSetTitle %TITLE%
    }
    WinActivate
}
;Url: https://autohotkey.com/board/topic/27074-append-to-clipboard-with-control-g-g-glue/
^w::                 
	;transform ,topclip,unicode Deprecated: This command is not recommended for use in new scripts. For details on what you can use instead, see the sub-command sections below.

   topclip := ClipboardAll   ; Save the entire clipboard to a variable of your choice. ; ... here make temporary use of the clipboard, such as for pasting Unicode text via Transform Unicode ...   
   clipboard =  ;clear clipboard so you can use clipwait 
   send ^c 
   clipwait   ;erratic results without this 
   appendclip := ClipboardAll
   Clipboard := %topclip%`r`n%appendclip%    ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
   topclip := ""   ; Free the memory in case the clipboard was very large.
   appendclip := ""
return

;^-- auto-execute section "toprow"
;You can define a custom combination of two keys (except joystick buttons) by using " & " between them.
;#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.


#IfWinActive ahk_class vguiPopupWindow
{
	1::
	Send {LButton} 10 {enter}
	return
	
	2::
	Send {LButton} 100 {enter}
	return

	3::
	Send {LButton} 500 {enter}
	return

	4::
	Send {LButton} 900 {enter}
	return
}

^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return

;old method !g:: if (dostuff != off) { SetTimer, dostuff, 10 return } else { settimer, dostuff, off return }
;do stuff dostuff: send click, right, down Return
;new method

^g::
Send, {Rbutton}



; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.

RControl & Enter::
	IfWinActive ahk_exe powershell_ise.exe
		SendInput {F5}
PrintScreen::
IfWinExist Skärmklippverktyget
	WinActivate
  
	Run, "%windir%\system32\SnippingTool.exe"
return

;lets me open a command prompt at the location I'm open in windows explorer. If the current window is not a explorer window then the prompt opens at the location where the ;script is present. I would like to change this behavior and make it open from C:\

LWin & T::
if WinActive("ahk_class CabinetWClass") 
or WinActive("ahk_class ExploreWClass")
{
  Send {Shift Down}{AppsKey}{Shift Up}
  Sleep 10
  Send w{enter}
}
else
{
  run, cmd, C:\
}
return


!g::
if (dostuff != off)
{ 
SetTimer, dostuff, 10
return
}
else
settimer, dostuff, off
return
}

;shift+win+E to kill windows
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


#PgUp::Send {Volume_Up 1}
#PgDn::Send {Volume_Down 1}

PrintScreen:: ;runs snipping tool 
;will start Snipping if Snipping Tool is not open. If Snipping is already open and active it will Minimize. If Minimized it will Restore. If Snipping is open but not ;active it will Activate.
{
	SetTitleMatchMode, % (Setting_A_TitleMatchMode := A_TitleMatchMode) ? "RegEx" :
	if WinExist("ahk_class Microsoft-Windows-.*SnipperToolbar")
	{
		WinGet, State, MinMax
		if (State = -1)
		{	
			WinRestore
			Send, ^n
		}
		else if WinActive()
			WinMinimize
		else
		{
			WinActivate
			Send, ^n
		}
	}
	else if WinExist("ahk_class Microsoft-Windows-.*SnipperEditor")
	{
		WinGet, State, MinMax
		if (State = -1)
			WinRestore
		else if WinActive()
			WinMinimize
		else
			WinActivate
	}
	else
	{
		Run, snippingtool.exe
		if (SubStr(A_OSVersion,1,2)=10)
		{
			WinWait, ahk_class Microsoft-Windows-.*SnipperToolbar,,3
			Send, ^n
		}
	}
	SetTitleMatchMode, %Setting_A_TitleMatchMode%
	return
}

#IfWinActive ahk_class POEWindowClass
	;::
	Send {enter} /exit {enter}
return

; #IfWinActive, MTGA ;Space:: *:: while not(GetKeyState("LButton")) { IfWinActive, MTGA { SendInput {f3} } }           

;lets me open a command prompt at the location I'm open in windows explorer. If the current window is not a explorer window then the prompt opens at the location where the ;script is present. I would like to change this behavior and make it open from C:\

<#t::
if WinActive("ahk_class CabinetWClass") 
or WinActive("ahk_class ExploreWClass")
{
  Send {Shift Down}{AppsKey}{Shift Up}
  Sleep 10
  Send {enter}
}
else
{
  EnvGet, SystemRoot, SystemRoot
  Run %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy unrestricted
}
return



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