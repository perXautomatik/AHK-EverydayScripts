; from https://autohotkey.com/board/topic/91930-window-moving-functions-for-the-arrow-keys/

/*
default hotkeys:
#!Arrows: Snap window to edges of workarea (3 levels, see below)
#!Home: Center window in workarea
#!t: Change current window's title
#!m: Begin moving/resizing window with arrow keys. Ctrl+arrows for resizing, Shift+arrows for finer control, Esc/Enter to stop

credits to ManaUser for isWindow() (http://www.autohotkey.com/community/viewtopic.php?t=27797)
*/

; winSnap(horizontal=[-1,0-1], vertical=[-1,0,1])
; snaps window to the edges of the workspace
; if you keep the modifiers down and press the same direction a couple times, the window goes over three 'levels' of snapping:
; 1 = move window to the edge
; 2 = resize window to half the workarea in that direction
; 3 = maximizes the window in the other direction (if snapped left 3 times, the window will occupy the half left of the workarea)
{

  ; !k::winSnap("",-1)
  ; !j::winSnap("",1)
  ; !h::winSnap(-1,"")
  ; !l::winSnap(1,"")
  ^!o::winSnap(0,0,1)

  winSnap(seth, setv, forceset=0, reset=0)
  {
    static h=0
    static v=0

    if (reset)
    {
      h := 0
      v := 0
      Hotkey, *~LWin up, off
      Hotkey, *~RWin up, off
      Hotkey, *~Alt up, off
      return 0
    }

    Hotkey, *~LWin up, winSnapReset, on
    Hotkey, *~RWin up, winSnapReset, on
    Hotkey, *~Alt up, winSnapReset, on

    wId := WinExist("A")
    WinGetPos, wLeft, wTop, wWidth, wHeight, ahk_id %wId%

    SysGet, wa, MonitorWorkArea
    ; available vars: waTop, waBottom, waLeft, waRight

    waWidth := waRight - waLeft
    waHeight := waBottom - waTop

    if (seth != "")
    {
      if (forceset)
        h := seth
      else
        h := (h*seth < 0 ? 0 : (Abs(h+seth) > 3 ? h : h+seth))
      ; h := (Abs(h+seth) > 3 ? h : h+seth)

      if (Abs(h) = 3)
      {
        wWidth := waWidth//2
        wHeight := waHeight
        wLeft := (h < 0 ? waLeft: waLeft+wWidth) ; considering wWidth=waWidth//2
        wTop := waTop
      }
      else if (Abs(h) = 2)
      {
        wWidth := waWidth//2
        wLeft := (h < 0 ? waLeft : waLeft+waWidth-wWidth)
      }
      else if (Abs(h) = 1)
      {
        wLeft := (h < 0 ? waLeft : waLeft+waWidth-wWidth)
      }
      else ; h = 0
      {
        wLeft := waLeft + waWidth//2 - wWidth//2
      }
    }

    if (setv != "") ; analogous to above
    {
      if (forceset)
        v := setv
      else
        v := (v*setv < 0 ? 0 : (Abs(v+setv) > 3 ? v : v+setv))

      if (Abs(v) = 3)
      {
        wWidth := waWidth
        wHeight := waHeight//2
        wLeft := waLeft
        wTop := (v < 0 ? waTop : waTop+wHeight) ; considering wHeight=waHeight//2
      }
      else if (Abs(v) = 2)
      {
        wHeight := waHeight//2
        wTop := (v < 0 ? waTop : waTop+waHeight-wHeight)
      }
      else if (Abs(v) = 1)
      {
        wTop := (v < 0 ? waTop : waTop+waHeight-wHeight)
      }
      else ; v = 0
      {
        wTop := waTop + waHeight//2 - wHeight//2
      }
    }

    ; msgbox pars:%seth% %setv%`n%wLeft%`, %wTop%`, %wWidth%`, %wHeight%
    WinMove, ahk_id %wId%,, %wLeft%, %wTop%, %wWidth%, %wHeight%
  }

  winSnapReset:
    winSnap("","",0,1)
  return

}

; changes title of active window
; if no title is given, asks for new title with an inputbox
; the change is volatile, meaning that if the window changes its title, the custom title is lost.
{

  #!t::winChangeTitle(WinExist("A"))

  winChangeTitle(wId, newTitle="") {
    if not isWindow(wId)
      return

    if (newTitle = "")
    {
      WinGetTitle, oldTitle, ahk_id %wId%
      InputBox, newTitle, New Title,,,,100,,,,,%oldTitle%
      if Errorlevel
        return
    }

    WinSetTitle, ahk_id %wId%,, %newTitle%
  }

}

; winMoveMode
; call with winMoveModeSet("start"), move window with arrow keys. Esc ends it
; modifiers: Ctrl=resize window ; Shift = uses smaller offset to move or resize.
{

  ^!i::winMoveModeSet("start")

  winMoveModeSet(cmd) {
    if (cmd = "start")
    {
      Hotkey, *k, winMoveModeUp, on
      Hotkey, *j, winMoveModeDown, on
      Hotkey, *h, winMoveModeLeft, on
      Hotkey, *l, winMoveModeRight, on
      Hotkey, Esc, winMoveModeEnd, on
      Hotkey, Enter, winMoveModeEnd, on

      wId := WinExist("A")
      WinGetTitle, wTitle, ahk_id %wId%
      ToolTip, Moving window`n%wTitle%
    }
    else if (cmd = "end")
    {
      Hotkey, *k, off
      Hotkey, *j, off
      Hotkey, *h, off
      Hotkey, *l, off
      Hotkey, Esc, off
      Hotkey, Enter, off
      Tooltip
    }
  }

  winMoveMode(h, v) {
    mode := GetKeyState("Ctrl", "P") ? "resize" : "move" ; starts resizeMode
    offset := GetKeyState("Shift", "P") ? 5 : 30 ;

    wId := WinExist("A")
    WinGetPos, wLeft, wTop, wWidth, wHeight, ahk_id %wId%

    if (mode = "resize")
    {
      wWidth += h*offset
      wHeight += v*offset
    }
    else if (mode = "move")
    {
      wLeft += h*offset
      wTop += v*offset
    }

    WinMove, ahk_id %wId%,, %wLeft%, %wTop%, %wWidth%, %wHeight%
  }

  winMoveModeUp:
    winMoveMode(0,-1)
  return

  winMoveModeDown:
    winMoveMode(0,1)
  return

  winMoveModeLeft:
    winMoveMode(-1,0)
  return

  winMoveModeRight:
    winMoveMode(1,0)
  return

  winMoveModeEnd:
    winMoveModeSet("end")
  return

}

; This checks if a window is, in fact a window.
; As opposed to the desktop or a menu, etc.
; from ManaUser's AppsKeys, http://www.autohotkey.com/community/viewtopic.php?t=27797
isWindow(hwnd)
{
  WinGet, s, Style, ahk_id %hwnd%
  return s & 0xC00000 ? (s & 0x80000000 ? 0 : 1) : 0
  ;WS_CAPTION AND !WS_POPUP(for tooltips etc)
}
