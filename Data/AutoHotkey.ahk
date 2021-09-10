;OnMessage(0x111, "WM_COMMAND")

WM_COMMAND(wParam)
{
    if (wParam = 65401 ; ID_FILE_EDITSCRIPT
         || wParam = 65304) ; ID_TRAY_EDITSCRIPT
    { Custom_Edit() return true }
}

Custom_Edit()
{
    static TITLE := "AhkPad - " A_ScriptFullPath
    if !WinExist(TITLE) { Run  "A_MyDocuments\Microsoft VS Code\Code.exe" "%A_ScriptFullPath%",,, pid WinWait ahk_pid %pid%,, 2 if ErrorLevel return WinSetTitle %TITLE% }
}
;#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.

;not yeat sure if this works, work computer seemed to have a hard time short after i tryed this.;WinActivate
^TAB::
  send {alt Down}{tab Down}
  sleep 500
  send {alt upp}{tab upp}
return
^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return

;old method !g:: if (dostuff != off) { SetTimer, dostuff, 10 return } else { settimer, dostuff, off return }


;Compensate iresponsive right click do stuff dostuff: send, click, right, down Return ;new method
^g::
Send, {Rbutton}


;increase volume
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

;poe exit should be other char
#IfWinActive ahk_class POEWindowClass
	
	Send {enter} /exit {enter}
return


; decrapified #IfWinActive, MTGA Space:: while not(GetKeyState("LButton")) { IfWinActive, MTGA { SendInput {Space} SendInput {Click} Sleep, 1000 } }           


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
;#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.

#z::Run www.autohotkey.com

^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return


; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.

#PgUp::Send {Volume_Up 1}
#PgDn::Send {Volume_Down 1}

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
{ then
SetTimer, dostuff, 10
return
}
else
settimer, dostuff, off
return
}

dostuff:
;do stuff
send, click, right, down
Return

#IfWinActive ahk_class POEWindowClass
	§::
	Send {enter} /exit {enter}
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

}; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one .ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.

#z::Run www.autohotkey.com

^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return


; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.

#PgUp::Send {Volume_Up 1}
#PgDn::Send {Volume_Down 1};#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.

#z::Run www.autohotkey.com

^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return


; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.

#PgUp::Send {Volume_Up 1}
#PgDn::Send {Volume_Down 1}

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
{ then
SetTimer, dostuff, 10
return
}
else
settimer, dostuff, off
return
}

dostuff:
;do stuff
send, click, right, down
Return

#IfWinActive ahk_class POEWindowClass
	§::
	Send {enter} /exit {enter}
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

};#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.

;not yeat sure if this works, work computer seemed to have a hard time short after i tryed this.;WinActivate
^TAB::
  send {alt Down}{tab Down}
  sleep 500
  send {alt upp}{tab upp}
return
^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return

;old method !g:: if (dostuff != off) { SetTimer, dostuff, 10 return } else { settimer, dostuff, off return }


;Compensate iresponsive right click do stuff dostuff: send, click, right, down Return ;new method
^g::
Send, {Rbutton}


;increase volume
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

;poe exit should be other char
#IfWinActive ahk_class POEWindowClass
	
	Send {enter} /exit {enter}
return


; decrapified #IfWinActive, MTGA Space:: while not(GetKeyState("LButton")) { IfWinActive, MTGA { SendInput {Space} SendInput {Click} Sleep, 1000 } }           


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
