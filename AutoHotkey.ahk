OnMessage(0x111, "WM_COMMAND")

WM_COMMAND(wParam)
{
    if (wParam = 65401 ; ID_FILE_EDITSCRIPT
         || wParam = 65304) ; ID_TRAY_EDITSCRIPT
    {
        Custom_Edit()
        return true
    }
}

Custom_Edit()
{
    static TITLE := "AhkPad - " A_ScriptFullPath
    if !WinExist(TITLE)
    {
        Run  "C:\Users\crbk01\Documents\Microsoft VS Code\Code.exe" "%A_ScriptFullPath%",,, pid
        WinWait ahk_pid %pid%,, 2
        if ErrorLevel
            return
        WinSetTitle %TITLE%
    }
}
;^-- auto-execute section "toprow"
;#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.

;[copy from:Get current explorer window path - AutoHotkey Community when: @https://bit.ly/3spOZt2]
GetActiveExplorerPath()
{
	explorerHwnd := WinActive("ahk_class CabinetWClass")
	if (explorerHwnd)
	{
		for window in ComObjCreate("Shell.Application").Windows
		{
			if (window.hwnd==explorerHwnd)
			{
				return window.Document.Folder.Self.Path
			}
		}
	}
}

#SingleInstance force
;Module: paset as file
^#v::
InputBox,  filename, Clipboard to file, Enter a file name,,300,130
if ErrorLevel
    return
if !(filename) {
    filename:=A_Year "_" A_MM "_" A_DD "~" A_Hour . A_Min . A_Sec  
}
fext:=GetExtension(filename)
; get current explorer path
afp:=AFP()

If (FileExist(Afp . filename) && (fext)) {
    msgbox ,33,file, File already exists. Overwrite?
    IfMsgBox, Cancel
    Return  
        IfMsgBox, OK 
        {  
            FileDelete, % afp . filename
            sleep, 200
        }
}

If (FileExist(Afp . filename . ".txt") && !(fext) ) {
    msgbox ,33,file,  File already exists. Overwrite?
    IfMsgBox, Cancel
    Return  
        IfMsgBox, OK 
        {  
            FileDelete, % afp . filename . ".txt"
            sleep, 200
        }
}

if (fext) && (filename)
    fileappend, % clipboard, % afp . filename
else
    fileappend, % clipboard, % afp . filename . ".txt"
return

GetExtension(vpath) {
return  RegExReplace(vPath, "^.*?((\.(?!.*\\)(?!.*\.))|$)")  
}

; based on ActiveFolderPath() by Scoox https://autohotkey.com/board/topic/70960-detect-current-windows-explorer-location/
AFP(WinTitle="A")
{
    WinGetClass, Class, %WinTitle%
    If (Class ~= "Program|WorkerW") ;desktop
    {
        WinPath := A_Desktop
    }
    Else ;all other windows
    {
        WinGetText, WinPath, A
        RegExMatch(WinPath, ".:\\.*", WinPath)
        for w in ComObjCreate("Shell.Application").Windows    ; grab the folder path
        {
            aac = % w.Document.Folder.Self.Path
            if (WinPath=aac) {
                valid:=1
                break
            }
        }   
    }
 if !valid
    return
    WinPath := RegExReplace(WinPath, "\\+$") 
    If WinPath 
        WinPath .= "\"
    Return WinPath
}



;tried all sorts of ways to control the alt key but seems like the contrl key is not logicaly in downstate due to remote control
  ^TAB::
  send {ALT down}{TAB}
	sleep 2000
	send {ALT up}	
return


SetTitleMatchMode, 1 ; match titles begining with specified string


#ifwinactive, C:\Users\crbk01\Desktop\OnGithub\AutoHotkeyPortable\Data\AutoHotkey.ahk - AutoHotkey
{
^ENTER::
send {F5}
return
}


PrintScreen:: ;runs snipping tool 
;will start Snipping if Snipping Tool is not open. If Snipping is already open and active it will Minimize. If Minimized it will Restore. If Snipping is open but not ;active it will Activate.

{
	SetTitleMatchMode, % (Setting_A_TitleMatchMode := A_TitleMatchMode) ? "RegEx" :
	if WinExist("ahk_class Microsoft-Windows-.*SnipperToolbar")
	{
		WinGet, State, MinMax
		if (State = -1)
		{	
			WinRestore
			Send, ^n
		}
		else if WinActive()
			WinMinimize
		else
		{
			WinActivate
			Send, ^n
		}
	}
	else if WinExist("ahk_class Microsoft-Windows-.*SnipperEditor")
	{
		WinGet, State, MinMax
		if (State = -1)
			WinRestore
		else if WinActive()
			WinMinimize
		else
			WinActivate
	}
	else
	{
		Run, snippingtool.exe
		if (SubStr(A_OSVersion,1,2)=10)
		{
			WinWait, ahk_class Microsoft-Windows-.*SnipperToolbar,,3
			Send, ^n
		}
	}
	SetTitleMatchMode, %Setting_A_TitleMatchMode%
	return
}


#ifwinactive, AutoHotkey.ahk - Anteckningar
{
^s::
send, {ctrl down}s{ctrl up}
tooltip,macro is diabled, % a_screenwidth/2, % a_screenheight/2
SetTimer, RemoveToolTip, 3000
sleep 100
reload, "C:\Users\crbk01\Desktop\OnGithub\AutoHotkeyPortable\Data\AutoHotkey.ahk"


RemoveToolTip:
tooltip
return
}

;lets me open a command prompt at the location I'm open in windows explorer. If the current window is not a explorer window then the prompt opens at the location where the ;script is present. I would like to change this behavior and make it open from C:\

<#t::
if WinActive("ahk_class CabinetWClass") 
or WinActive("ahk_class ExploreWClass")
{
  Send {Shift Down}{AppsKey}{Shift Up}
  Sleep 10
  Send w{enter}
}
else
{
  EnvGet, SystemRoot, SystemRoot
  Run %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy unrestricted
}
return
