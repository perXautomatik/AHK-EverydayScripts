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


;WinWaitActive, Security Alert, 
;Send,{tab}{return}
;MouseClick, left,  150,  127 

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


;GenTip(A_Scriptname . " after!")
Sleep 1000 ; just in case  147,  101


;}	
		
}
SetTimer, Restart, 100


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