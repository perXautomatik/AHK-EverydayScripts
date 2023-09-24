
repeatSeQuence(){
 try {

toggle:=0							; This assigns the value 0 to the variable toggle
	toggle:=!toggle					; This makes the variable toggle change from the value 1 to 0, and from 0 to 1.
	if toggle						; If toggle is 1 (which means true)
		SetTimer, WheelUpDown,  50	; Then the timer is turned on
	else							; Else, if toggle is 0 (which means false)
		SetTimer, WheelUpDown,  Off	; the timer is turned off
return

g::SetTimer, WheelUpDown, % (toggle:=!toggle) ? 50 : "Off"	; This is a hotkey doing the same thing as f another way. Search for ternary and force expression in the docs for more information.
	
; When the timer is on, the code under the line WheelUpDown: will be executed until it reaches a return.
WheelUpDown:						; This is a label
	Send,{WheelUp 6}{WheelDown 6}	; This is the send command for sending key strokes and mouse click and such.
return

 } catch e {
     MsgBox, An exception was thrown!`nSpecifically: %e%
      Exit
 }
 exit
}