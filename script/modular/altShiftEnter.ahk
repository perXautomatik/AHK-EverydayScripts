#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
sendAltShiftEnter()
{
	laodToolTip("inside")
		SendInput {Alt}{Shift}{Enter}
	exit
}