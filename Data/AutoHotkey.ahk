;#NoTrayIcon
#SingleInstance, Force
#Persistent

;NiceBlue = BED2E8
;Pass := IBox("Please input Outlook password", Pass, "Password")
GenTip(A_Scriptname . " has started!")
While ((A_TimeIdlePhysical < 1800000) && !WinExist("Idle timer expired"))
{

;SetTitleMatchMode, 2
;SetTitleMatchMode, slow

UniqueID := WinExist, Security Alert ;WinExist("ahk_class Security Alert") or WinExist("ahk_class" . #32770)

	GenTip(A_Scriptname . %UniqueID)

{
    WinActivate  ; Automatically uses the window found above.
    Send, {Enter}
	GenTip(A_Scriptname . " before!")

;    return
}

;Send, {LWINDOWN}{LWINUP}
;#ifwinwaitactive, 
;{
;GenTip(A_Scriptname . " before!")

;WinWaitActive, Security Alert, 
;Send,{tab}{return}
;MouseClick, left,  150,  127 


;GenTip(A_Scriptname . " after!")
Sleep 1000 ; just in case  147,  101


;}	
		
}
SetTimer, Restart, 100

Return

Restart:
If ((A_TimeIdlePhysical < 1800000) && !WinExist("Idle timer expired"))
	Reload
Return

Critical:
!esc::
MsgBox, 0, Closing, %A_ScriptName% is closing, 1
ExitApp
Return

#esc::
reload
Return


IBox(Prompt, Default="", Options="") {
	Static MyInputBoxEditCtrl
	Global NiceBlue
	Gui, 55: Default
	Gui, +LabelMyInputBox +ToolWindow
	Gui, Margin, 20, 10
	Gui, Color, %NiceBlue%
	Gui, Add, Text, w360, %Prompt%
	Gui, Add, Edit, r1 wp %Options% vMyInputBoxEditCtrl
	Gui, Add, Button, yp+40 xp gInputBoxSubmitVariables Default, OK
	Gui, Add, Button, gDoNotInputBoxSubmitVariables yp xp300, Cancel
	Gui, Show,, Input is needed...
	WinWaitClose, Input is needed...
	Return RetVar

	InputBoxSubmitVariables:
	Gui, Submit
	RetVar := MyInputBoxEditCtrl
	MyInputBoxEscape:
	MyInputBoxClose:
	DoNotInputBoxSubmitVariables:
	Gui, Destroy
	If !StrLen(RetVar)
		ErrorLevel := 1
	Return
}	
GenTip(Text) {
	CenTip(Text)
	Seconds := Ceil(StrLen(Text)*60)
	EndTip(Seconds, 14)
}
CenTip(Text) {
	If Text =
	{
		ToolTip,,,,14
		Return
	}
	CoordMode, ToolTip, Screen
	Len := StrLen(Text)
	If Len > 25
		Len := Len*4.8
	Else If Len <= 25
		Len := Len*5.2
	X := (A_ScreenWidth/2)-(Len/2)
	Y := (A_ScreenHeight-20)/2
	ToolTip, %Text%, %X%, %Y%, 14
	Return
}
EndTip(Time, Tip) {
	global CurrentTip
	CurrentTip := Tip
	SetTimer, EndTip, %Time%
	Return Tip
}
CtrlSetText(Control, Text="", WinTitle="", OptionalEndKey="") {
	Global Active
	If !WinTitle
		WinTitle = A
	ControlSetText, %Control%, %Text%, %WinTitle%
	If OptionalEndKey
		Send % OptionalEndKey
	Return Abs(ErrorLevel-1)
}
EndTip:
ToolTip,,,, %CurrentTip%