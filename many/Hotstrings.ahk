;#Hotstring EndChars -()[]{}:;'"/\,.?!`n `t

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Hotstrings ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

:R*?:date;::
FormatTime, CurrentDateTime,, yyyy-MM-dd
SendInput %CurrentDateTime%
return
:R*?:time;::
FormatTime, CurrentDateTime,, HH:mm
SendInput %CurrentDateTime%
return
:R*?:dtm;::
FormatTime, CurrentDateTime,, yyyy-MM-dd HH:mm
SendInput %CurrentDateTime%
return

:*:ak;::autohotkey
:*:js;::javascript
:*:so;::stackoverflow

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; File Paths ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

:*:pd;::`%ProgramData`%
:*:ad;::`%AppData`%
