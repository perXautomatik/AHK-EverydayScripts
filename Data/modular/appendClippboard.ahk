
appendClipboard(){
try{
;Url: https://autohotkey.com/board/topic/27074-append-to-clipboard-with-control-g-g-glue/
              
	;transform ,topclip,unicode Deprecated: This command is not recommended for use in new scripts. For details on what you can use instead, see the sub-command sections below.
   
   topclip := ClipboardAll   ; Save the entire clipboard to a variable of your choice. ; ... here make temporary use of the clipboard, such as for pasting Unicode text via Transform Unicode ...   
   
   laodToolTip(topclip) ;feedback

   clipboard =  ;clear clipboard so you can use clipwait 
   send ^c 
   clipwait   ;erratic results without this 
   appendclip := ClipboardAll
   Clipboard := %topclip%`r`n%appendclip%    ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
   topclip := ""   ; Free the memory in case the clipboard was very large.
   appendclip := ""
exit

}
 catch e  ; Handles the first error/exception raised by the block above.
{
   MsgBox, An exception was thrown!`nSpecifically: %e%
   Exit
}
}   