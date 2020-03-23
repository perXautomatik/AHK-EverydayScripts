; Autohotkey configuration file
; AHK Version v.1.1.30.01
; Franklin Chou (franklin.chou@nelsonmullins.com)
; 22 Mar. 2020
; Tested to work on Lenovo X1 Yoga, Gen. 4 

#SingleInstance Force
#Persistent 

CapsLock::Ctrl
LCtrl::return
;LCtrl::CapsLock

; WORD ------------------------------------------------------------------------
#IfWinActive ahk_class OpusApp
  PrintScreen::AppsKey
