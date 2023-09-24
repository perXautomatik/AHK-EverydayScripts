; source: https://github.com/mrjackphil/qnote-ahk
; obsidian: https://forum.obsidian.md/t/qnote-ahk-script-for-quick-note-creation-windows-only/4145/2
; tool to create gui: https://www.autohotkey.com/board/topic/738-smartgui-creator/
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance force
; Gui, Destroy

Gui, -Caption -ToolWindow +AlwaysOnTop +Resize
Gui, Margin, 10, 15
Gui, Color, 222222, 222222
Gui, font, s18 cc0caf5, Callibri
; Gui, Add, Text,, Note
Gui, Add, Edit, W600 R3 vBodyText -VScroll -E0x200

#j::
  toggle := !toggle
  if (toggle)
    Gui, Show,,
  else
    Gui, Hide
return

#k::
  Gui, Submit
  if (StrLen(BodyText) < 2) {
    toggle := false
    return
  }

  found := RegExMatch(BodyText, "-\w+")
  if (found)
  {
    if (InStr(BodyText, "--del"))
    {
      Run, %ComSpec% /c ansicon.exe jrnl %BodyText% && pause
    } else {
      Run, %ComSpec% /c jrnl %BodyText% && pause
    }
  } else
  {
    RunWait, %ComSpec% /c jrnl %BodyText%, , Min
  }

  GuiControl,, BodyText,
  toggle := false
  Gui, Hide
return

#h::reload
#+h::exitapp
