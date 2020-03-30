#Persistent
#NoTrayIcon
SetTitleMatchMode 2

Run %A_ScriptDir%\DittoPortable.exe
sleep 1000
   IfWinExist,Warning:
{
	WinActivate,Warning
        Send,{Enter}
	sleep 1000
	Run %A_ScriptDir%\DittoPortable.exe
}

return