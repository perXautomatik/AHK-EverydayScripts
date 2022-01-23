SavingReloadsAhkWindow(){
 try {
        send, {ctrl down}s{ctrl up}
        tooltip,macro is diabled, % a_screenwidth/2, % a_screenheight/2
        SetTimer, RemoveToolTip, 3000
        sleep 100
        reload, "C:\Users\crbk01\Desktop\OnGithub\AutoHotkeyPortable\Data\AutoHotkey.ahk"
 } catch e {
     MsgBox, An exception was thrown!`nSpecifically: %e%
      Exit
 }
 exit
}