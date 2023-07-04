detectHiddenWindows, on
run notepad,, hide, npPid
winWait % "ahk_pid " npPid
controlSetText, edit1, Some text, % "ahk_pid " npPid

msgbox 'Some Text' was written to notepad in background.`nPress OK to show.
winShow, % "ahk_pid " npPid

Url: https://www.autohotkey.com/board/topic/71838-solved-run-a-script-for-a-program-in-the-background/