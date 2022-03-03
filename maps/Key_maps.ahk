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

#include modular\SnipPrinting.ahk 
; Print screen reassigned to Windows Key + PrintScreen
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

; 3 lines omitted

;Replaces the currently running instance of the script with a new one.
#include modular\reloadScript.ahk
!+r::reloadScript()
