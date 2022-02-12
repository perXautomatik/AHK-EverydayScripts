;#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
OnMessage(0x111, "WM_COMMAND")

#z::Run www.autohotkey.com
;open In vscode
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

^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return


<<<<<<< HEAD
; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.

#PgUp::Send {Volume_Up 1}
#PgDn::Send {Volume_Down 1}

PrintScreen::
IfWinExist Skärmklippverktyget
	WinActivate
  
	Run, "%windir%\system32\SnippingTool.exe"
return

;lets me open a command prompt at the location I'm open in windows explorer. If the current window is not a explorer window then the prompt opens at the location where the ;script is present. I would like to change this behavior and make it open from C:\

LWin & T::
if WinActive("ahk_class CabinetWClass") 
or WinActive("ahk_class ExploreWClass")
{
  Send {Shift Down}{AppsKey}{Shift Up}
  Sleep 10
  Send w{enter}
}
else
{
  run, cmd, C:\
}
return


!g::
if (dostuff != off)
{ then
SetTimer, dostuff, 10
return
}
else
settimer, dostuff, off
return
}

dostuff:
;do stuff
send, click, right, down
Return

#IfWinActive ahk_class POEWindowClass
	§::
	Send {enter} /exit {enter}
return


#IfWinActive, MTGA
Space::
while not(GetKeyState("LButton"))
{
    static TITLE := "AhkPad - " A_ScriptFullPath
    if !WinExist(TITLE)
    {
        Run  "E:\Program Files\Microsoft VS Code\Code.exe" "%A_ScriptFullPath%",,, pid
        WinWait ahk_pid %pid%,, 2
        if ErrorLevel
            return
        WinSetTitle %TITLE%
    }
    WinActivate
}

;^-- auto-execute section "toprow"
;^-- auto-execute section "toprow"----------------------------------------------------------------
	IfWinActive, MTGA
	{
		SendInput {Space}
		SendInput {Click}
		Sleep, 1000
	}

};#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.


#IfWinActive ahk_class vguiPopupWindow
;v-- method implementations ---------------------------------------------------------------

;[copy from:Get current explorer window path - AutoHotkey Community when: @https://bit.ly/3spOZt2]
GetActiveExplorerPath()
{
	1::
	Send {LButton} 10 {enter}
	return
	
	2::
	Send {LButton} 100 {enter}
	return
#z::Run www.autohotkey.com

	3::
	Send {LButton} 500 {enter}
	return
^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return

	4::
	Send {LButton} 900 {enter}
	return
}

^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return
; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

;old method !g:: if (dostuff != off) { SetTimer, dostuff, 10 return } else { settimer, dostuff, off return }
;do stuff dostuff: send click, right, down Return
;new method
; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.

^g::
Send, {Rbutton}


;MethodCalls;-------------------------------------------------------------------------------
#PgUp::Send {Volume_Up 1}
#PgDn::Send {Volume_Down 1}


;You can define a custom combination of two keys (except joystick buttons) by using " & " between them.
;#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.

RControl & Enter::
	IfWinActive ahk_exe powershell_ise.exe
		SendInput {F5}
#PgUp::Send {Volume_Up 1}
#PgDn::Send {Volume_Down 1}

PrintScreen::
IfWinExist Skärmklippverktyget
	WinActivate
  
	Run, "%windir%\system32\SnippingTool.exe"
return

;shift+win+E to kill windows
#+e::
   Run, taskkill.exe /im explorer.exe /f
Return
;ctrl+shift+e to run explorer
^+e::
   Run, explorer.exe
Return
;rightclick with ctrl+G
^g::
Send, {Rbutton}
;lets me open a command prompt at the location I'm open in windows explorer. If the current window is not a explorer window then the prompt opens at the location where the ;script is present. I would like to change this behavior and make it open from C:\


#PgUp::Send {Volume_Up 1}
#PgDn::Send {Volume_Down 1}

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
LWin & T::
if WinActive("ahk_class CabinetWClass") 
or WinActive("ahk_class ExploreWClass")
{
  Send {Shift Down}{AppsKey}{Shift Up}
  Sleep 10
  Send w{enter}
}
else
{
  run, cmd, C:\
}
return

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
return
!g::
if (dostuff != off)
{ then
SetTimer, dostuff, 10
return
}
else
settimer, dostuff, off
return
}

dostuff:
;do stuff
send, click, right, down
Return

#IfWinActive ahk_class POEWindowClass
	§::
	Send {enter} /exit {enter}
return


#IfWinActive, MTGA
Space::
while not(GetKeyState("LButton"))
{
	IfWinActive, MTGA
	{
		SendInput {Space}
		SendInput {Click}
		Sleep, 1000
	}

};#	Win (Windows logo key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.

#ifwinactive, C:\Users\crbk01\Desktop\OnGithub\AutoHotkeyPortable\Data\AutoHotkey.ahk - AutoHotkey
{
    ^ENTER::
    send {F5}
    return
}


=======

>>>>>>> HomeMain
;Url: https://autohotkey.com/board/topic/27074-append-to-clipboard-with-control-g-g-glue/
^w::                 
	;transform ,topclip,unicode Deprecated: This command is not recommended for use in new scripts. For details on what you can use instead, see the sub-command sections below.

   topclip := ClipboardAll   ; Save the entire clipboard to a variable of your choice. ; ... here make temporary use of the clipboard, such as for pasting Unicode text via Transform Unicode ...   
   clipboard =  ;clear clipboard so you can use clipwait 
   send ^c 
   clipwait   ;erratic results without this 
   appendclip := ClipboardAll
   Clipboard := %topclip%`r`n%appendclip%    ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
   topclip := ""   ; Free the memory in case the clipboard was very large.
   appendclip := ""
<<<<<<< HEAD
^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return

=======
return
>>>>>>> HomeMain


RControl & Enter::
	IfWinActive ahk_exe powershell_ise.exe
		SendInput {F5}
return

;shift+win+E to kill windows
#+e::
   Run, taskkill.exe /im explorer.exe /f
Return
;ctrl+shift+e to run explorer
^+e::
   Run, explorer.exe
Return
;rightclick with ctrl+G
^g::
Send, {Rbutton}


#PgUp::Send {Volume_Up 1}
#PgDn::Send {Volume_Down 1}


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

;old method
!g::
if (dostuff != off)
{ 
SetTimer, dostuff, 10
return
}
else {
settimer, dostuff, off
return
}

dostuff:
;do stuff
send, click, right, down
Return
;new method
^g::
Send, {Rbutton}


#PgUp::Send {Volume_Up 1}
#PgDn::Send {Volume_Down 1}

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

;works 2021-03-05  
#IfWinActive ahk_class POEWindowClass
	?::
	Send {enter} /exit {enter}
return
#IfWinActive ahk_class POEWindowClass
	§::
	Send {enter} /exit {enter}
return

; #IfWinActive, MTGA ;Space:: *:: while not(GetKeyState("LButton")) { IfWinActive, MTGA { SendInput {f3} } }           

#IfWinActive, MTGA
Space::
while not(GetKeyState("LButton"))
{
	IfWinActive, MTGA
	{
		SendInput {Space}
		SendInput {Click}
		Sleep, 1000
	}

}           


;lets me open a command prompt at the location I'm open in windows explorer. If the current window is not a explorer window then the prompt opens at the location where the ;script is present. I would like to change this behavior and make it open from C:\

LWin & T::
if WinActive("ahk_class CabinetWClass") 
or WinActive("ahk_class ExploreWClass")
    {
    Send {Shift Down}{AppsKey}{Shift Up}
    Sleep 10
    Send {enter}
    }
    else
    {
    EnvGet, SystemRoot, SystemRoot
    Run %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy unrestricted
    }
{
  Send {Shift Down}{AppsKey}{Shift Up}
  Sleep 10
  Send w{enter}
}
else
{
  run, cmd, C:\
}
return


þÿ ; # 	 W i n   ( W i n d o w s   l o g o   k e y  
 ; ! 	 A l t  
 ; ^ 	 C o n t r o l  
 ; + 	 S h i f t  
 ; & 	 A n   a m p e r s a n d   m a y   b e   u s e d   b e t w e e n   a n y   t w o   k e y s   o r   m o u s e   b u t t o n s   t o   c o m b i n e   t h e m   i n t o   a   c u s t o m   h o t k e y .   S e e   b e l o w   f o r   d e t a i l s .  
 ; < 	 U s e   t h e   l e f t   k e y   o f   t h e   p a i r .   e . g .   < ! a   i s   t h e   s a m e   a s   ! a   e x c e p t   t h a t   o n l y   t h e   l e f t   A l t   k e y   w i l l   t r i g g e r   i t .  
 ; > 	 U s e   t h e   r i g h t   k e y   o f   t h e   p a i r .  
  
 ^ ! n : :  
 I f W i n E x i s t   U n t i t l e d   -   N o t e p a d  
 	 W i n A c t i v a t e  
 e l s e  
 	 R u n   N o t e p a d  
 r e t u r n  
  
 ; o l d   m e t h o d  
 ! g : :  
 i f   ( d o s t u f f   ! =   o f f )  
 {    
 S e t T i m e r ,   d o s t u f f ,   1 0  
 r e t u r n  
 }  
 e l s e   {  
 s e t t i m e r ,   d o s t u f f ,   o f f  
 r e t u r n  
 }  
  
 d o s t u f f :  
 ; d o   s t u f f  
 s e n d ,   c l i c k ,   r i g h t ,   d o w n  
 R e t u r n  
 ; n e w   m e t h o d  
 ^ g : :  
 S e n d ,   { R b u t t o n }  
  
  
 # P g U p : : S e n d   { V o l u m e _ U p   1 }  
 # P g D n : : S e n d   { V o l u m e _ D o w n   1 }  
  
 P r i n t S c r e e n : :   ; r u n s   s n i p p i n g   t o o l    
 ; w i l l   s t a r t   S n i p p i n g   i f   S n i p p i n g   T o o l   i s   n o t   o p e n .   I f   S n i p p i n g   i s   a l r e a d y   o p e n   a n d   a c t i v e   i t   w i l l   M i n i m i z e .   I f   M i n i m i z e d   i t   w i l l   R e s t o r e .   I f   S n i p p i n g   i s   o p e n   b u t   n o t   ; a c t i v e   i t   w i l l   A c t i v a t e .  
  
 {  
 	 S e t T i t l e M a t c h M o d e ,   %   ( S e t t i n g _ A _ T i t l e M a t c h M o d e   : =   A _ T i t l e M a t c h M o d e )   ?   " R e g E x "   :  
 	 i f   W i n E x i s t ( " a h k _ c l a s s   M i c r o s o f t - W i n d o w s - . * S n i p p e r T o o l b a r " )  
 	 {  
 	 	 W i n G e t ,   S t a t e ,   M i n M a x  
 	 	 i f   ( S t a t e   =   - 1 )  
 	 	 { 	  
 	 	 	 W i n R e s t o r e  
 	 	 	 S e n d ,   ^ n  
 	 	 }  
 	 	 e l s e   i f   W i n A c t i v e ( )  
 	 	 	 W i n M i n i m i z e  
 	 	 e l s e  
 	 	 {  
 	 	 	 W i n A c t i v a t e  
 	 	 	 S e n d ,   ^ n  
 	 	 }  
 	 }  
 	 e l s e   i f   W i n E x i s t ( " a h k _ c l a s s   M i c r o s o f t - W i n d o w s - . * S n i p p e r E d i t o r " )  
 	 {  
 	 	 W i n G e t ,   S t a t e ,   M i n M a x  
 	 	 i f   ( S t a t e   =   - 1 )  
 	 	 	 W i n R e s t o r e  
 	 	 e l s e   i f   W i n A c t i v e ( )  
 	 	 	 W i n M i n i m i z e  
 	 	 e l s e  
 	 	 	 W i n A c t i v a t e  
 	 }  
 	 e l s e  
 	 {  
 	 	 R u n ,   s n i p p i n g t o o l . e x e  
 	 	 i f   ( S u b S t r ( A _ O S V e r s i o n , 1 , 2 ) = 1 0 )  
 	 	 {  
 	 	 	 W i n W a i t ,   a h k _ c l a s s   M i c r o s o f t - W i n d o w s - . * S n i p p e r T o o l b a r , , 3  
 	 	 	 S e n d ,   ^ n  
 	 	 }  
 	 }  
 	 S e t T i t l e M a t c h M o d e ,   % S e t t i n g _ A _ T i t l e M a t c h M o d e %  
 	 r e t u r n  
 }  
  
 # I f W i n A c t i v e   a h k _ c l a s s   P O E W i n d o w C l a s s  
 	 ö : :  
 	 S e n d   { e n t e r }   / e x i t   { e n t e r }  
 r e t u r n  
  
  
 # I f W i n A c t i v e ,   M T G A  
 S p a c e : :  
 w h i l e   n o t ( G e t K e y S t a t e ( " L B u t t o n " ) )  
 {  
 	 I f W i n A c t i v e ,   M T G A  
 	 {  
 	 	 S e n d I n p u t   { S p a c e }  
 	 	 S e n d I n p u t   { C l i c k }  
 	 	 S l e e p ,   1 0 0 0  
 	 }  
  
 }                        
  
  
 ; l e t s   m e   o p e n   a   c o m m a n d   p r o m p t   a t   t h e   l o c a t i o n   I ' m   o p e n   i n   w i n d o w s   e x p l o r e r .   I f   t h e   c u r r e n t   w i n d o w   i s   n o t   a   e x p l o r e r   w i n d o w   t h e n   t h e   p r o m p t   o p e n s   a t   t h e   l o c a t i o n   w h e r e   t h e   ; s c r i p t   i s   p r e s e n t .   I   w o u l d   l i k e   t o   c h a n g e   t h i s   b e h a v i o r   a n d   m a k e   i t   o p e n   f r o m   C : \  
  
 L W i n   &   T : :  
 i f   W i n A c t i v e ( " a h k _ c l a s s   C a b i n e t W C l a s s " )    
 o r   W i n A c t i v e ( " a h k _ c l a s s   E x p l o r e W C l a s s " )  
 {  
     S e n d   { S h i f t   D o w n } { A p p s K e y } { S h i f t   U p }  
     S l e e p   1 0  
     S e n d   w { e n t e r }  
 }  
 e l s e  
 {  
     r u n ,   c m d ,   C : \  
 }  
 r e t u r n  
þÿ O n M e s s a g e ( 0 x 1 1 1 ,   " W M _ C O M M A N D " )  
  
 W M _ C O M M A N D ( w P a r a m )  
 {  
         i f   ( w P a r a m   =   6 5 4 0 1   ;   I D _ F I L E _ E D I T S C R I P T  
                   | |   w P a r a m   =   6 5 3 0 4 )   ;   I D _ T R A Y _ E D I T S C R I P T  
         {  
                 C u s t o m _ E d i t ( )  
                 r e t u r n   t r u e  
         }  
 }  
  
 C u s t o m _ E d i t ( )  
 {  
         s t a t i c   T I T L E   : =   " A h k P a d   -   "   A _ S c r i p t F u l l P a t h  
         i f   ! W i n E x i s t ( T I T L E )  
         {  
                 R u n     " C : \ U s e r s \ c r b k 0 1 \ D o c u m e n t s \ M i c r o s o f t   V S   C o d e \ C o d e . e x e "   " % A _ S c r i p t F u l l P a t h % " , , ,   p i d  
                 W i n W a i t   a h k _ p i d   % p i d % , ,   2  
                 i f   E r r o r L e v e l  
                         r e t u r n  
                 W i n S e t T i t l e   % T I T L E %  
         }  
         W i n A c t i v a t e  
 }  
  
 ; ^ - -   a u t o - e x e c u t e   s e c t i o n   " t o p r o w "  
 ; # 	 W i n   ( W i n d o w s   l o g o   k e y  
 ; ! 	 A l t  
 ; ^ 	 C o n t r o l  
 ; + 	 S h i f t  
 ; & 	 A n   a m p e r s a n d   m a y   b e   u s e d   b e t w e e n   a n y   t w o   k e y s   o r   m o u s e   b u t t o n s   t o   c o m b i n e   t h e m   i n t o   a   c u s t o m   h o t k e y .   S e e   b e l o w   f o r   d e t a i l s .  
 ; < 	 U s e   t h e   l e f t   k e y   o f   t h e   p a i r .   e . g .   < ! a   i s   t h e   s a m e   a s   ! a   e x c e p t   t h a t   o n l y   t h e   l e f t   A l t   k e y   w i l l   t r i g g e r   i t .  
 ; > 	 U s e   t h e   r i g h t   k e y   o f   t h e   p a i r .  
  
 ^ ! n : :  
 I f W i n E x i s t   U n t i t l e d   -   N o t e p a d  
 	 W i n A c t i v a t e  
 e l s e  
 	 R u n   N o t e p a d  
 r e t u r n  
  
 ; o l d   m e t h o d  
 ! g : :  
 i f   ( d o s t u f f   ! =   o f f )  
 {    
 S e t T i m e r ,   d o s t u f f ,   1 0  
 r e t u r n  
 }  
 e l s e   {  
 s e t t i m e r ,   d o s t u f f ,   o f f  
 r e t u r n  
 }  
  
 d o s t u f f :  
 ; d o   s t u f f  
 s e n d ,   c l i c k ,   r i g h t ,   d o w n  
 R e t u r n  
 ; n e w   m e t h o d  
 ^ g : :  
 S e n d ,   { R b u t t o n }  
  
  
 # P g U p : : S e n d   { V o l u m e _ U p   1 }  
 # P g D n : : S e n d   { V o l u m e _ D o w n   1 }  
  
 P r i n t S c r e e n : :   ; r u n s   s n i p p i n g   t o o l    
 ; w i l l   s t a r t   S n i p p i n g   i f   S n i p p i n g   T o o l   i s   n o t   o p e n .   I f   S n i p p i n g   i s   a l r e a d y   o p e n   a n d   a c t i v e   i t   w i l l   M i n i m i z e .   I f   M i n i m i z e d   i t   w i l l   R e s t o r e .   I f   S n i p p i n g   i s   o p e n   b u t   n o t   ; a c t i v e   i t   w i l l   A c t i v a t e .  
  
 {  
 	 S e t T i t l e M a t c h M o d e ,   %   ( S e t t i n g _ A _ T i t l e M a t c h M o d e   : =   A _ T i t l e M a t c h M o d e )   ?   " R e g E x "   :  
 	 i f   W i n E x i s t ( " a h k _ c l a s s   M i c r o s o f t - W i n d o w s - . * S n i p p e r T o o l b a r " )  
 	 {  
 	 	 W i n G e t ,   S t a t e ,   M i n M a x  
 	 	 i f   ( S t a t e   =   - 1 )  
 	 	 { 	  
 	 	 	 W i n R e s t o r e  
 	 	 	 S e n d ,   ^ n  
 	 	 }  
 	 	 e l s e   i f   W i n A c t i v e ( )  
 	 	 	 W i n M i n i m i z e  
 	 	 e l s e  
 	 	 {  
 	 	 	 W i n A c t i v a t e  
 	 	 	 S e n d ,   ^ n  
 	 	 }  
 	 }  
 	 e l s e   i f   W i n E x i s t ( " a h k _ c l a s s   M i c r o s o f t - W i n d o w s - . * S n i p p e r E d i t o r " )  
 	 {  
 	 	 W i n G e t ,   S t a t e ,   M i n M a x  
 	 	 i f   ( S t a t e   =   - 1 )  
 	 	 	 W i n R e s t o r e  
 	 	 e l s e   i f   W i n A c t i v e ( )  
 	 	 	 W i n M i n i m i z e  
 	 	 e l s e  
 	 	 	 W i n A c t i v a t e  
 	 }  
 	 e l s e  
 	 {  
 	 	 R u n ,   s n i p p i n g t o o l . e x e  
 	 	 i f   ( S u b S t r ( A _ O S V e r s i o n , 1 , 2 ) = 1 0 )  
 	 	 {  
 	 	 	 W i n W a i t ,   a h k _ c l a s s   M i c r o s o f t - W i n d o w s - . * S n i p p e r T o o l b a r , , 3  
 	 	 	 S e n d ,   ^ n  
 	 	 }  
 	 }  
 	 S e t T i t l e M a t c h M o d e ,   % S e t t i n g _ A _ T i t l e M a t c h M o d e %  
 	 r e t u r n  
 }  
  
 # I f W i n A c t i v e   a h k _ c l a s s   P O E W i n d o w C l a s s  
 	 ö : :  
 	 S e n d   { e n t e r }   / e x i t   { e n t e r }  
 r e t u r n  
  
  
 # I f W i n A c t i v e ,   M T G A  
 S p a c e : :  
 w h i l e   n o t ( G e t K e y S t a t e ( " L B u t t o n " ) )  
 {  
 	 I f W i n A c t i v e ,   M T G A  
 	 {  
 	 	 S e n d I n p u t   { S p a c e }  
 	 	 S e n d I n p u t   { C l i c k }  
 	 	 S l e e p ,   1 0 0 0  
 	 }  
  
 }                        
  
  
 ; l e t s   m e   o p e n   a   c o m m a n d   p r o m p t   a t   t h e   l o c a t i o n   I ' m   o p e n   i n   w i n d o w s   e x p l o r e r .   I f   t h e   c u r r e n t   w i n d o w   i s   n o t   a   e x p l o r e r   w i n d o w   t h e n   t h e   p r o m p t   o p e n s   a t   t h e   l o c a t i o n   w h e r e   t h e   ; s c r i p t   i s   p r e s e n t .   I   w o u l d   l i k e   t o   c h a n g e   t h i s   b e h a v i o r   a n d   m a k e   i t   o p e n   f r o m   C : \  
  
 < # t : :  
 i f   W i n A c t i v e ( " a h k _ c l a s s   C a b i n e t W C l a s s " )    
 o r   W i n A c t i v e ( " a h k _ c l a s s   E x p l o r e W C l a s s " )  
 {  
     S e n d   { S h i f t   D o w n } { A p p s K e y } { S h i f t   U p }  
     S l e e p   1 0  
     S e n d   w { e n t e r }  
 }  
 e l s e  
 {  
     E n v G e t ,   S y s t e m R o o t ,   S y s t e m R o o t  
     R u n   % S y s t e m R o o t % \ s y s t e m 3 2 \ W i n d o w s P o w e r S h e l l \ v 1 . 0 \ p o w e r s h e l l . e x e   - E x e c u t i o n P o l i c y   u n r e s t r i c t e d  
 }  
 r e t u r n  
þÿ ; O n M e s s a g e ( 0 x 1 1 1 ,   " W M _ C O M M A N D " )  
  
 W M _ C O M M A N D ( w P a r a m )  
 {  
         i f   ( w P a r a m   =   6 5 4 0 1   ;   I D _ F I L E _ E D I T S C R I P T  
                   | |   w P a r a m   =   6 5 3 0 4 )   ;   I D _ T R A Y _ E D I T S C R I P T  
         {   C u s t o m _ E d i t ( )   r e t u r n   t r u e   }  
 }  
  
 C u s t o m _ E d i t ( )  
 {  
         s t a t i c   T I T L E   : =   " A h k P a d   -   "   A _ S c r i p t F u l l P a t h  
         i f   ! W i n E x i s t ( T I T L E )   {   R u n     " A _ M y D o c u m e n t s \ M i c r o s o f t   V S   C o d e \ C o d e . e x e "   " % A _ S c r i p t F u l l P a t h % " , , ,   p i d   W i n W a i t   a h k _ p i d   % p i d % , ,   2   i f   E r r o r L e v e l   r e t u r n   W i n S e t T i t l e   % T I T L E %   }  
 }  
  
 ; ^ - -   a u t o - e x e c u t e   s e c t i o n   " t o p r o w "  
 ; # 	 W i n   ( W i n d o w s   l o g o   k e y  
 ; ! 	 A l t  
 ; ^ 	 C o n t r o l  
 ; + 	 S h i f t  
 ; & 	 A n   a m p e r s a n d   m a y   b e   u s e d   b e t w e e n   a n y   t w o   k e y s   o r   m o u s e   b u t t o n s   t o   c o m b i n e   t h e m   i n t o   a   c u s t o m   h o t k e y .   S e e   b e l o w   f o r   d e t a i l s .  
 ; < 	 U s e   t h e   l e f t   k e y   o f   t h e   p a i r .   e . g .   < ! a   i s   t h e   s a m e   a s   ! a   e x c e p t   t h a t   o n l y   t h e   l e f t   A l t   k e y   w i l l   t r i g g e r   i t .  
 ; > 	 U s e   t h e   r i g h t   k e y   o f   t h e   p a i r .  
  
 ; n o t   y e a t   s u r e   i f   t h i s   w o r k s ,   w o r k   c o m p u t e r   s e e m e d   t o   h a v e   a   h a r d   t i m e   s h o r t   a f t e r   i   t r y e d   t h i s . ; W i n A c t i v a t e  
 ^ T A B : :  
     s e n d   { a l t   D o w n } { t a b   D o w n }  
     s l e e p   5 0 0  
     s e n d   { a l t   u p p } { t a b   u p p }  
 r e t u r n  
  
  
 ^ ! n : :  
 I f W i n E x i s t   U n t i t l e d   -   N o t e p a d  
 	 W i n A c t i v a t e  
 e l s e  
 	 R u n   N o t e p a d  
 r e t u r n  
  
 ; o l d   m e t h o d   ! g : :   i f   ( d o s t u f f   ! =   o f f )   {   S e t T i m e r ,   d o s t u f f ,   1 0   r e t u r n   }   e l s e   {   s e t t i m e r ,   d o s t u f f ,   o f f   r e t u r n   }  
  
  
 ; C o m p e n s a t e   i r e s p o n s i v e   r i g h t   c l i c k   d o   s t u f f   d o s t u f f :   s e n d ,   c l i c k ,   r i g h t ,   d o w n   R e t u r n   ; n e w   m e t h o d  
 ^ g : :  
 S e n d ,   { R b u t t o n }  
  
  
 ; i n c r e a s e   v o l u m e  
 # P g U p : : S e n d   { V o l u m e _ U p   1 }  
 # P g D n : : S e n d   { V o l u m e _ D o w n   1 }  
  
 P r i n t S c r e e n : :   ; r u n s   s n i p p i n g   t o o l    
 ; w i l l   s t a r t   S n i p p i n g   i f   S n i p p i n g   T o o l   i s   n o t   o p e n .   I f   S n i p p i n g   i s   a l r e a d y   o p e n   a n d   a c t i v e   i t   w i l l   M i n i m i z e .   I f   M i n i m i z e d   i t   w i l l   R e s t o r e .   I f   S n i p p i n g   i s   o p e n   b u t   n o t   ; a c t i v e   i t   w i l l   A c t i v a t e .  
  
 {  
 	 S e t T i t l e M a t c h M o d e ,   %   ( S e t t i n g _ A _ T i t l e M a t c h M o d e   : =   A _ T i t l e M a t c h M o d e )   ?   " R e g E x "   :  
 	 i f   W i n E x i s t ( " a h k _ c l a s s   M i c r o s o f t - W i n d o w s - . * S n i p p e r T o o l b a r " )  
 	 {  
 	 	 W i n G e t ,   S t a t e ,   M i n M a x  
 	 	 i f   ( S t a t e   =   - 1 )  
 	 	 { 	  
 	 	 	 W i n R e s t o r e  
 	 	 	 S e n d ,   ^ n  
 	 	 }  
 	 	 e l s e   i f   W i n A c t i v e ( )  
 	 	 	 W i n M i n i m i z e  
 	 	 e l s e  
 	 	 {  
 	 	 	 W i n A c t i v a t e  
 	 	 	 S e n d ,   ^ n  
 	 	 }  
 	 }  
 	 e l s e   i f   W i n E x i s t ( " a h k _ c l a s s   M i c r o s o f t - W i n d o w s - . * S n i p p e r E d i t o r " )  
 	 {  
 	 	 W i n G e t ,   S t a t e ,   M i n M a x  
 	 	 i f   ( S t a t e   =   - 1 )  
 	 	 	 W i n R e s t o r e  
 	 	 e l s e   i f   W i n A c t i v e ( )  
 	 	 	 W i n M i n i m i z e  
 	 	 e l s e  
 	 	 	 W i n A c t i v a t e  
 	 }  
 	 e l s e  
 	 {  
 	 	 R u n ,   s n i p p i n g t o o l . e x e  
 	 	 i f   ( S u b S t r ( A _ O S V e r s i o n , 1 , 2 ) = 1 0 )  
 	 	 {  
 	 	 	 W i n W a i t ,   a h k _ c l a s s   M i c r o s o f t - W i n d o w s - . * S n i p p e r T o o l b a r , , 3  
 	 	 	 S e n d ,   ^ n  
 	 	 }  
 	 }  
 	 S e t T i t l e M a t c h M o d e ,   % S e t t i n g _ A _ T i t l e M a t c h M o d e %  
 	 r e t u r n  
 }  
  
 ; p o e   e x i t   s h o u l d   b e   o t h e r   c h a r  
 # I f W i n A c t i v e   a h k _ c l a s s   P O E W i n d o w C l a s s  
 	  
 	 S e n d   { e n t e r }   / e x i t   { e n t e r }  
 r e t u r n  
  
  
 ;   d e c r a p i f i e d   # I f W i n A c t i v e ,   M T G A   S p a c e : :   w h i l e   n o t ( G e t K e y S t a t e ( " L B u t t o n " ) )   {   I f W i n A c t i v e ,   M T G A   {   S e n d I n p u t   { S p a c e }   S e n d I n p u t   { C l i c k }   S l e e p ,   1 0 0 0   }   }                        
  
  
 ; l e t s   m e   o p e n   a   c o m m a n d   p r o m p t   a t   t h e   l o c a t i o n   I ' m   o p e n   i n   w i n d o w s   e x p l o r e r .   I f   t h e   c u r r e n t   w i n d o w   i s   n o t   a   e x p l o r e r   w i n d o w   t h e n   t h e   p r o m p t   o p e n s   a t   t h e   l o c a t i o n   w h e r e   t h e   ; s c r i p t   i s   p r e s e n t .   I   w o u l d   l i k e   t o   c h a n g e   t h i s   b e h a v i o r   a n d   m a k e   i t   o p e n   f r o m   C : \  
  
 < # t : :  
 i f   W i n A c t i v e ( " a h k _ c l a s s   C a b i n e t W C l a s s " )    
 o r   W i n A c t i v e ( " a h k _ c l a s s   E x p l o r e W C l a s s " )  
 {  
     S e n d   { S h i f t   D o w n } { A p p s K e y } { S h i f t   U p }  
     S l e e p   1 0  
     S e n d   w { e n t e r }  
 }  
 e l s e  
 {  
     E n v G e t ,   S y s t e m R o o t ,   S y s t e m R o o t  
     R u n   % S y s t e m R o o t % \ s y s t e m 3 2 \ W i n d o w s P o w e r S h e l l \ v 1 . 0 \ p o w e r s h e l l . e x e   - E x e c u t i o n P o l i c y   u n r e s t r i c t e d  
 }  
 r e t u r n  
