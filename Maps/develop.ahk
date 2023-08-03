;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DEVELOPMENT TOOLS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Autohotkey configuration file
; AHK Version v.1.1.32.00
; Franklin Chou (franklin.chou@nelsonmullins.com)
; 2 May 2020
; Tested to work on Lenovo X1 Yoga, Gen. 4 


#Persistent

#c::
  WinGetActiveTitle, title
  MsgBox %title%
  title := ""
Return

#^c::
  WinGetClass, class, A
  MsgBox %class%
  class := ""
Return

f12::Reload
