#c::
oCB := ClipboardAll  ; save clipboard contents
Send, ^c
ClipWait,1

< do whatever you originally wanted with selected text in "clipboard" variable >

ClipBoard := oCB         ; return original Clipboard contents
return

