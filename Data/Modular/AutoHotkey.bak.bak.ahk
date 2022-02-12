
^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return


!g::
if (dostuff != off)
{ then
SetTimer, dostuff, 10
return
}
else {
settimer, dostuff, off
return
}

dostuff:
;do stuff
send, click, right, down
Return

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

}           


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
