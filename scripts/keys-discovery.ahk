/*
  Virtual/Scan Codes & Key Names
  This uses a keyboard hook to provide all information of a key pressed.
  The idea of the Gui is from SKAN, however his script fails to detect some keys and other info
  https://autohotkey.com/board/topic/21105-crazy-scripting-scriptlet-to-find-scancode-of-a-key/
*/

#NoTrayIcon
#SingleInstance force

hook := InputHook()
hook.KeyOpt("{All}", "NS")
hook.OnKeyDown := Func("keyDown")
hook.Start()

Gui +ToolWindow +AlwaysOnTop
Gui Font, Bold q5 s14, Consolas
Gui Add, Text, 0x201 +Border w160 h33, {vk00} {sc000}
Gui Show,, > Key Information Discovery

return ; End of auto-execute

keyDown(hook, vk, sc)
{
  vkCode := "vk" Format("{:02X}", vk)
  scCode := "sc" Format("{:03X}", sc)
  ToolTip % "Key name: " GetKeyName(vkCode), 2, 80
  GuiControl Text, Static1, % "{" vkCode "} {" scCode "}"
}

GuiClose:
  ExitApp
