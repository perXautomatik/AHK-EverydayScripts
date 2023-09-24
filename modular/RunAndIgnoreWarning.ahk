CheckIfRunning(iTC_Pat){
    try
    {
		#Persistent
		#NoTrayIcon
		SetTitleMatchMode 2

		Run %iTC_Path%
		sleep 1000
		IfWinExist,Warning:
		{
			WinActivate,Warning
				Send,{Enter}
			sleep 1000
			Run %iTC_Path%
		}

	return
	    }
    catch e  ; Handles the first error/exception raised by the block above.
    {
        MsgBox, %A_ScriptDir% An exception was thrown!`nSpecifically: %e%
        Exit
    }
}