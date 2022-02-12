#include modular\getExtension.ahk

;^-- auto-execute section "toprow"----------------------------------------------------------------

;v-- method implementations ---------------------------------------------------------------

#include modular\activeExplorerPath.ahk
#include modular\afp.ahk

pasteAsFile(){
    InputBox,  filename, Clipboard to file, Enter a file name,,300,130
    if ErrorLevel
        return
    if !(filename) {
        filename:=A_Year "_" A_MM "_" A_DD "~" A_Hour . A_Min . A_Sec  
    }
    fext:=GetExtension(filename)
    ; get current explorer path
    afp:=AFP()

    If (FileExist(Afp . filename) && (fext)) {
        msgbox ,33,file, File already exists. Overwrite?
        IfMsgBox, Cancel
        Return  
            IfMsgBox, OK 
            {  
                FileDelete, % afp . filename
                sleep, 200
            }
    }

    If (FileExist(Afp . filename . ".txt") && !(fext) ) {
        msgbox ,33,file,  File already exists. Overwrite?
        IfMsgBox, Cancel
        Return  
            IfMsgBox, OK 
            {  
                FileDelete, % afp . filename . ".txt"
                sleep, 200
            }
    }

    if (fext) && (filename)
        fileappend, % clipboard, % afp . filename
    else
        fileappend, % clipboard, % afp . filename . ".txt"
    return
return

exit

}