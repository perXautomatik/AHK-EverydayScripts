;LowShortcut.ahk
; Autocreate low priority shortcuts by dropping files or shortcuts on the icon
; Run it to manually input a window title and a program location
;Skrommel @ 2007

If 0=0
{
  InputBox,linkfile,~Window title Dialog Box~,Please enter a window title:
  InputBox,target,~Program location Dialog Box~,Please enter a program location:
  FileCreateShortcut,%comspec%,%linkfile% - low.lnk,,/c start "%linkfile%" /low "%target%",,%target%,,,
}
Else
Loop,%0%
{
  drop:=%A_Index%
  Loop,%drop%
    longfilename:=A_LoopFileLongPath
  SplitPath,longfilename,filename,dir,ext,namenoext,drive
  If ext<>LNK
    FileCreateShortcut,%comspec%,%namenoext% - low.lnk,,/c start "%filename%" /low "%longfilename%",,%longfilename%,,,
  Else
  {
    FileGetShortcut,%longfilename%,target,dir,args,description,icon,iconnum,runstate
    FileCreateShortcut,%comspec%,%namenoext% - low.lnk,%dir%,/c start "%namenoext%" /low "%target%",%description%,%target%,%icon%,%iconnum%,
  }
}
