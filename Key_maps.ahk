; Autohotkey configuration file
; AHK Version v1.1.22.06
; Franklin Chou (franklin.chou@yahoo.com)
; 20 Nov. 2015

;------------------------------------------------------------------------------
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

; Right shift and S, insert section symbol
>+S::send §

#IfWinActive,, Microsoft Word
  PgUp::Home
  PgDn::End
  <!Up:: Send {PgUp}
  <!Down:: Send {PgDn}
#IfWinActive

; 3 lines omitted

#^R::Reload
#B::Run, "FireFox"
#W::Run, "Word"
