^g::
#Url: https://autohotkey.com/board/topic/27074-append-to-clipboard-with-control-g-g-glue/
   transform ,topclip,unicode
   clipboard =  ;clear clipboard so you can use clipwait 
   send ^c 
   clipwait   ;erratic results without this 
   transform ,appendclip,unicode   
   transform ,clipboard,unicode, %topclip%`r`n%appendclip% 
return