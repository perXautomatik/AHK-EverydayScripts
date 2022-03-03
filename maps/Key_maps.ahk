; Autohotkey configuration file
; AHK Version v1.1.22.06
; Christoffer Brobäck (Christoffer.broback@gmail.com)
; 03/03/2022

;------------------------------------------------------------------------------
; GLOSSARY OF COMMONLY USED KEY MODIFIERS
;
; # Windows key
;!	Alt
;^	Control
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey. See below for details.
;<	Use the left key of the pair. e.g. <!a is the same as !a except that only the left Alt key will trigger it.
;>	Use the right key of the pair.
;------------------------------------------------------------------------------

#SingleInstance force

; Print screen Through Windows Snipping tool
#include modular\SnipPrinting.ahk

;------------------------------------------------------------------------------
;window conscious
#include modular\ctrlEnterToexecute.ahk
#ifwinactive, ahk_exe powershell_ise.exe
    ^Enter::sendF8()
#ifwinactive, - AutoHotkey ahk_exe AutoHotkey.exe
    ^Enter::sendF5()
#if

#Include modular\SavingReloades.ahk
#ifwinactive, AutoHotkey.ahk - Anteckningar
	^s::SavingReloadsAhkWindow()
#if

;------------------------------------------------------------------------------
;Replaces the currently running instance of the script with a new one.
#include modular\reloadScript.ahk
!+r::reloadScript()
;------------------------------------------------------------------------------
;remote Desktop without mouse
#include modular\rightclickWithg.ahk
^g::sendRightClick()
;------------------------------------------------------------------------------
;media keys
#include modular\volumePageUpdown.ahk
;------------------------------------------------------------------------------
;autoklicker
#Include Fork\autoklick\auto-clicker-autohotkey-community.ahk
