HoldDownKey(key){
 try {
KeyDown := !KeyDown
If KeyDown
	SendInput {%key%  down}
	Else
		SendInput {%key% up}
	Return     

 } catch e {
     MsgBox, An exception was thrown!`nSpecifically: %e%
      Exit
 }
 exit
}              