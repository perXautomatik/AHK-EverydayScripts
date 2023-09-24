
; based on ActiveFolderPath() by Scoox https://autohotkey.com/board/topic/70960-detect-current-windows-explorer-location/
AFP(WinTitle="A")
{
    WinGetClass, Class, %WinTitle%
    If (Class ~= "Program|WorkerW") ;desktop
    {
        WinPath := A_Desktop
    }
    Else ;all other windows
    {
        WinGetText, WinPath, A
        RegExMatch(WinPath, ".:\\.*", WinPath)
        for w in ComObjCreate("Shell.Application").Windows    ; grab the folder path
        {
            aac = % w.Document.Folder.Self.Path
            if (WinPath=aac) {
                valid:=1
                break
            }
        }   
    }
 if !valid
    return
    WinPath := RegExReplace(WinPath, "\\+$") 
    If WinPath 
        WinPath .= "\"
    Return WinPath
}

