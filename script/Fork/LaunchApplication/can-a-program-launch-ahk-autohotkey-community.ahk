loop
{
	WinWait, ahk_exe audacity.exe
	Run, "C:\Program Files\Audacity\Audacity.exe"
	WinWaitClose, ahk_exe audacity.exe
}
sleep, 100
Run, "C:\Program Files\Audacity\Launch Audacity delete temp folder.bat"
sleep, 100
ExitApp
return
#

Url: https://www.autohotkey.com/boards/viewtopic.php?t=71461