; Autohotkey configuration file
; AHK Version v1.1.22.06
; Franklin Chou (franklin.chou@yahoo.com)
; 20 Nov. 2015

;------------------------------------------------------------------------------
; GLOSSARY OF COMMONLY USED KEY MODIFIERS
;
; # Windows key
; ! Alt key
; ^ Control key
; + Shift key
; < Use the Left key of a pair
; > Use the Right key of a pair
;------------------------------------------------------------------------------

#SingleInstance force

PrintScreen::AppsKey

; Print screen reassigned to Windows Key + PrintScreen
#PrintScreen::PrintScreen

;------------------------------------------------------------------------------
; COMMONLY USED SYMBOL KEYS

>+P::send ¶
>+S::send §
;------------------------------------------------------------------------------

#IfWinActive,, Microsoft Word
  PgUp::Home
  PgDn::End
  <!Up:: Send {PgUp}
  <!Down:: Send {PgDn}
#IfWinActive

; no-commit
FireFox := "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
Word	:= "C:\Program Files\Microsoft Office\Office15\WINWORD.EXE"
; no-commit-end

#^R::Reload
#B::Run, "FireFox"
#W::Run, "Word"
