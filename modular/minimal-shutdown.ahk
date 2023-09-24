; from:https://www.autohotkey.com/board/topic/60944-a-fast-minimal-computer-shutdown-hibernate-or-sleep-timer/
; param 1 - Optionally, can pass 'sleep', 'restart', 'hibernate', or 'shutdown' . If empty, will prompt for action
; param 2 - Optionally, can pass number of minutes to desired action. If empty, will prompt. Set to '0' for immediate action
#NoEnv  ; Recommended for performance and compatibility w future AutoHotkey releases.
SendMode Input  ; Recom for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#ClipboardTimeout 2000
SetTitleMatchMode, 2
#singleinstance force
#Persistent

; Menu,tray,icon,A computer shutdown timer.ahk.ico

inAction = %1%
inTime = %2%
setTime := true
if ((inTime = "0") or inTime)
	setTime := false

if inAction =
{
	; Gui +OwnDialogs +AlwaysOnTop
	Gui +OwnDialogs
	InputBox , whatToDo, , what do you want to do?`n(You have 15 secs to change the default action`, which is for Shutdown):`n`n1 - Shutdown`n2 - Restart`n3 - Sleep`n4 - Hibernate,, 400,290, , , ,15, 1
	if Errorlevel = 1 ;Cancel was hit
		gosub doAbort
	if (whatToDo < 1) or (whatToDo >4)
	{
		MsgBox, 262148,, Wrong action was entered ("%whatToDo%"). Try again?
		IfMsgbox Yes
			reload
		exitapp
	}
}
else if inAction = shutdown
	whatToDo = 1
else if inAction = restart
	whatToDo = 2
else if inAction = sleep
	whatToDo = 3
else if inAction = hibernate
	whatToDo = 4
else
{
	MsgBox, 262144,, invalid paramater 1 was passed ("%inAction%")`n`nIt can only be either empty or 'shutdown', 'restart', 'sleep', or 'hibernate'. Aborting.
	ExitApp
}

timeCheckInterval = 15000
timeIncrementInMins = .25
defaultTimeToAction = 20  ; 20 secs will be added later

if whatToDo = 1
{
	mg = SHUTDOWN
	mgg = Shutdown
}
else if whatToDo = 2
{
	mg = RESTART
	mgg = Restart
}
else if whatToDo = 3
{
	mg = SLEEP
	mgg = Sleep
}
else if whatToDo = 4
{
	mg = HIBERNATE
	mgg = Hibernate
}
else
{
	MsgBox, 262144,, fatal err
	exitapp
}

if setTime
{
	; Gui +OwnDialogs +AlwaysOnTop
	Gui +OwnDialogs
	; Gui +OwnDialogs
	InputBox , inTime, , Enter mins to %mgg% (decimals ok):`n(You have %defaultTimeToAction% secs to enter the time left.),, 410,180 ,,,,%defaultTimeToAction%,0
	if Errorlevel = 1 ;Cancel was hit
		gosub doAbort
}

inTime := Round(inTime,1) ; round the time length for the timer in mins to 1 decimal
tds := inTime *60000   ; convert Timer mins length to milli seconds
StartTime = %A_TickCount%  ; get starting time from the system in millisecs
resetMsg = Re-Set Timer (Time Left: %inTime% mins to %mgg%)
Menu, Tray, Tip, Time Left: %inTime% mins
Menu, tray, add, %resetMsg%, ResetTimer ;Show Time Left on Timer = %in%, TimeLeft
gresetMsg = CANCEL`n%mg%`n%inTime% mins to %mgg%.
Gui, Add, Button, x100 y41 w150 h70 gAbort, %gresetMsg%
Gui, Add, Button, x100 y115 w150 h35 gResetTimer, Reset Time to %mgg%
Gui,Color,Red ;, Green ;Green ;,cRed
Gui, Show, x840 y500 h185 w352, Shutdown XP
sleep 10000
Gosub CloseIt
SetTimer, CloseIt, %timeCheckInterval% ;15000  ; was 60000
return

CloseIt:
ElapsedTime := (A_TickCount - StartTime) ; if millisecs used, elapsed time from start time
if (tds > ElapsedTime)   ; if millsecs used, test to see if the time has been exceeded
{ ; timer not finished
	tleftd := (tds - ElapsedTime)/60000
	tleftd := round(tleftd,1)
	Menu, Tray, Tip, Time Left: %tleftd% mins to %mgg%
	newresetMsg = Re-Set Timer (Time Left: %tleftd% mins to %mgg%)
	if (resetMsg <> newresetMsg)
	{
		Menu, tray, Rename, %resetMsg%, %newresetMsg%
		resetMsg = %newresetMsg%
	}
	gosub GuiSet
	return
}
; timer expired so do action and any final closing you may need
SetTimer, CloseIt, off ;%timeCheckInterval% ;15000
delaysecs = 6
MsgBox, 262148,, Will %mgg% in %delaysecs% secs.`n`nDo you want to reset the timer or cancel %mgg%?,%delaysecs%
IfMsgbox Yes
{
	MsgBox, 262148,, Reset %mgg% timer?`n('No' will just close this timer)
	IfMsgbox No
		exitapp
	Gosub ResetTimer
	return
}

if whatToDo = 1 ;shutdown
{
	gosub someCloseRoutines
	shutdown, 9 ; 1- shutdown 8 - power down (add both together)
}
else if whatToDo = 2 ;doRestart
{
	gosub someCloseRoutines
	Shutdown, 2  ; reboot
}
; Call the Windows API function "SetSuspendState" to have the system suspend or hibernate.
; Windows 95/NT4: Since this function does not exist, the following call would have no effect.
; Parameter #1: Pass 1 instead of 0 to hibernate rather than suspend.
; Parameter #2: Pass 1 instead of 0 to suspend immediately rather than asking each application for permission.
; Parameter #3: Pass 1 instead of 0 to disable all wake events.
else if whatToDo = 3 ; sleep
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
else if  whatToDo = 4 ; hibernate
	DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
ExitApp

ResetTimer:
; Gui +OwnDialogs +AlwaysOnTop
Gui +OwnDialogs
InputBox , inTime, , Enter new countdown number of`nminutes before %mg%:, ,300,170,,,,5,30
inTime := Round(inTime,1) ; round the time length for the timer in mins
tds := inTime * 60000  ; convert Timer mins length to milli seconds
StartTime = %A_TickCount%  ; reset starting time from the system in millisecs
Gosub CloseIt  ; resets gui
SetTimer, CloseIt, %timeCheckInterval% ;15000  ; was 60000
Return

someCloseRoutines:
;///////////////////     Customize for specific special close routines if open        //////////////////
; add other needed shutdown actions here
return

doAbort:
MsgBox, 262144,, Aborted shutdown.,2
ExitApp

GuiSet:
gresetMsgNew = CANCEL`n%mg%`n%tleftd% mins to %mgg%.
if gresetMsgNew <> gresetMsg
{
	ControlSetText, %gresetMsg%, %gresetMsgNew%,Shutdown XP
	gresetMsg = %gresetMsgNew%
}
Return

Abort:
GuiClose:
SetTimer, CloseIt, off
MsgBox, 262144,, Aborted %mg%.,1
ExitApp

Reset:
return
