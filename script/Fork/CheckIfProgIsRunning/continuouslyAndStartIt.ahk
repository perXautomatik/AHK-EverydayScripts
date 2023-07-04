;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       WinXP/7
; Author:         studotwho
;
; Script Function:
;	Restarts the iTeleportConnect service if it hasn't started - this usually happens if your
;   wireless network interface hasn't started when iTC tries to connect.
;
;   This script loops every (45) seconds to determine if iTC is running or not, and restarts it if it's not.
;
CheckIfRunning(iTC_EXE,iTC_Path,iTC_imgName){
    try
    {
		#SingleInstance, force
		SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
		SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

		loop {
			sleep 45000
			Process, Exist, %iTC_imgName% ; check to see if iTeleportConnect is running
			If (ErrorLevel = 0) ; If it is not running
			{
			Run, %iTC_EXE%, %iTC_Path%, hide
			}
			Else ; If it is running, ErrorLevel equals the process id for the target program (Printkey). Then do nothing.
			{
				sleep 5
			}
		}

    }
    catch e  ; Handles the first error/exception raised by the block above.
    {
        MsgBox, An exception was thrown!`nSpecifically: %e%
        Exit
    }
}