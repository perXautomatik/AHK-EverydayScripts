

;^-- auto-execute section "toprow"
;You can define a custom combination of two keys (except joystick buttons) by using " & " between them.
;#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.

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
	
	Send {enter} /exit {enter}
return


#IfWinActive, ahk_exe powershell_ise.exe
^ & RControl::
		SendInput {F5}
return


;lets me open a command prompt at the location I'm open in windows explorer. If the current window is not a explorer window then the prompt opens at the location where the ;script is present. I would like to change this behavior and make it open from C:\

<#t::
if WinActive("ahk_class CabinetWClass") 
or WinActive("ahk_class ExploreWClass")
{
  Send {Shift Down}{AppsKey}{Shift Up}
  Sleep 10
  Send w{enter}
}
else
{
  EnvGet, SystemRoot, SystemRoot
  Run %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy unrestricted
}
return
~|::
{
Send, {CtrlDown}{AltDown}{Tab}
Send, {CtrlUp}{AltUp}
return
}


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
{
Send, {Rbutton}
return
}

#PgUp::
{
	Send {Volume_Up 1} 
	return
}
#PgDn::
{
	Send {Volume_Down 1} 
	return
}


