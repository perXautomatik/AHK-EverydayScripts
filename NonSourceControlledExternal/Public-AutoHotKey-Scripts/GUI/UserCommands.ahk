; Created by Asger Juul Brunshøj

; Note: Save with encoding UTF-8 with BOM if possible.
; I had issues with special characters like in ¯\_(ツ)_/¯ that wouldn't work otherwise.
; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; Write your own AHK commands in this file to be recognized by the GUI. Take inspiration from the samples provided here.

;-------------------------------------------------------------------------------
;;; SEARCH GOOGLE ;;;
;-------------------------------------------------------------------------------
if Pedersen = g%A_Space% ; Search Google
{
  gui_search_title = Google Search
  gui_search("https://www.google.com/search?num=50&safe=off&site=&source=hp&q=REPLACEME&btnG=Search&oq=&gs_l=")
}
if Pedersen = gi%A_Space% ; Search Google Images
{
  ; https://www.google.com/search?q=elephant&tbm=isch
  gui_search_title = Google Image Search
  gui_search("https://www.google.com/search?num=50&safe=off&site=&source=hp&q=REPLACEME&tbm=isch")
}
else if Pedersen = a%A_Space% ; Search Google for AutoHotkey related stuff
{
  gui_search_title = Autohotkey Google Search
  gui_search("https://www.google.com/search?num=50&safe=off&site=&source=hp&q=autohotkey%20REPLACEME&btnG=Search&oq=&gs_l=")
}
else if Pedersen = js%A_Space% ; Search Google for Javascript related stuff
{
  gui_search_title = Javascript Google Search
  gui_search("https://www.google.com/search?num=50&safe=off&site=&source=hp&q=javascript%20REPLACEME&btnG=Search&oq=&gs_l=")
}
else if Pedersen = l%A_Space% ; Search Google with ImFeelingLucky
{
  gui_search_title = I'm Feeling Lucky
  gui_search("http://www.google.com/search?q=REPLACEME&btnI=Im+Feeling+Lucky")
}
else if Pedersen = m%A_Space% ; Open more than one URL
{
  gui_search_title = multiple
  gui_search("https://www.google.com/search?&q=REPLACEME")
  gui_search("https://www.bing.com/search?q=REPLACEME")
  gui_search("https://duckduckgo.com/?q=REPLACEME")
}
else if Pedersen = x%A_Space% ; Search Google as Incognito
  ;   A note on how this works:
;   The function name "gui_search()" is poorly chosen.
;   What you actually specify as the parameter value is a command to run. It does not have to be a URL.
;   Before the command is run, the word REPLACEME is replaced by your input.
;   It does not have to be a search url, that was just the application I had in mind when I originally wrote it.
;   So what this does is that it runs chrome with the arguments "-incognito" and the google search URL where REPLACEME in the URL has been replaced by your input.
{
  ; gui_search_title = Google Search as Incognito
  ; gui_search("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe -incognito https://www.google.com/search?safe=off&q=REPLACEME")

  gui_search_title = Google Search as Incognito
  gui_search("C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe -incognito https://www.duckduckgo.com/?q=REPLACEME&kp=-2&ia=web")
}

;-------------------------------------------------------------------------------
;;; SEARCH OTHER THINGS ;;;
;-------------------------------------------------------------------------------
else if Pedersen = f%A_Space% ; Search Facebook
{
  gui_search_title = Search Facebook
  gui_search("https://www.facebook.com/search/results.php?q=REPLACEME")
}
else if Pedersen = y%A_Space% ; Search Youtube
{
  gui_search_title = Search Youtube
  gui_search("https://www.youtube.com/results?search_query=REPLACEME")
}
else if Pedersen = t%A_Space% ; Search torrent networks
{
  gui_search_title = Sharing is caring
  gui_search("https://kickass.to/usearch/REPLACEME")
}
else if Pedersen = fr%A_Space% ; Translate English to French
{
  gui_search_title = English to French
  gui_search("https://translate.google.as/#en/fr/REPLACEME")
}
else if Pedersen = ar%A_Space% ; Translate English to Arabic
{
  gui_search_title = English to Arabic
  gui_search("https://translate.google.as/#en/ar/REPLACEME")
}
else if Pedersen = wi%A_Space% ; wordsinasentence.com
{
  gui_search_title = Search wordsinasentence
  gui_search("https://wordsinasentence.com/REPLACEME-in-a-sentence/")
}
else if Pedersen = syn%A_Space% ; Find synonyms
{
  gui_search_title = Search synonyms
  gui_search("https://synonyms.reverso.net/synonyme/en/REPLACEME")
}
else if Pedersen = urba%A_Space% ; Search urbandictionary
{
  gui_search_title := "The dictionary which knows everything"
  gui_search("https://www.urbandictionary.com/define.php?term=REPLACEME")
}

;-------------------------------------------------------------------------------
;;; LAUNCH WEBSITES AND PROGRAMS ;;;
;-------------------------------------------------------------------------------
else if Pedersen = / ; Go to subreddit. This is a quick way to navigate to a specific URL.
{
  gui_search_title := "/r/"
  gui_search("https://www.reddit.com/r/REPLACEME")
}
else if Pedersen = face ; facebook.com
{
  gui_destroy()
  run www.facebook.com
}
else if Pedersen = red ; reddit.com
{
  gui_destroy()
  run https://old.reddit.com
}
else if Pedersen = you ; youtube.com
{
  gui_destroy()
  run https://youtube.com
}
else if Pedersen = cal ; Google Calendar
{
  gui_destroy()
  run https://www.google.com/calendar
}
else if Pedersen = note ; Notepad
{
  gui_destroy()
  Run Notepad++
  ; sleep, 1000
  ; run, nircmd.exe waitprocess notepad++.exe speak text "notepad was closed"
}
else if Pedersen = paint ; MS Paint
{
  gui_destroy()
  run "C:\Windows\system32\mspaint.exe"
}
else if Pedersen = maps ; Google Maps focused on Bizerte
{
  gui_destroy()
  run "https://www.google.com/maps/@37.2763051`,9.8661903`,14.73z`"
}
else if Pedersen = inbox ; Open google inbox
{
  gui_destroy()
  run https://inbox.google.com/u/1/
  ; run https://mail.google.com/mail/u/0/#inbox  ; Maybe you prefer the old gmail
}
else if Pedersen = mes ; Opens Facebook unread messages
{
  gui_destroy()
  run https://www.facebook.com/messages?filter=unread&action=recent-messages
}
; custom programs
else if Pedersen = vs ; Open vsCode
{
  gui_destroy()
  IfWinNotExist, ahk_exe Code.exe
    Run, "C:\Users\marzouk\AppData\Local\Programs\Microsoft VS Code\Code.exe"
  ; Run, code.exe
  WinActivate ahk_exe Code.exe
}
else if Pedersen = vlc ; Open vlc
{
  gui_destroy()
  IfWinNotExist, ahk_exe vlc.exe
    Run, vlc.exe
  WinActivate ahk_exe vlc.exe
}
else if Pedersen = mpv ; Open mpv
{
  gui_destroy()
  IfWinNotExist, ahk_exe mpv.exe
    Run, mpv.exe
  WinActivate ahk_exe mpv.exe
}
else if Pedersen = ch ; Open Chrome
{
  gui_destroy()
  IfWinNotExist, ahk_exe chrome.exe
    Run, chrome.exe
  else
    WinActivate ahk_exe chrome.exe
}
else if Pedersen = wt ; Open wt
{
  gui_destroy()
  IfWinNotExist, ahk_exe WindowsTerminal.exe
    Run, wt.exe
  WinActivate ahk_exe WindowsTerminal.exe
}
else if Pedersen = fc ; Open calculator
{
  gui_destroy()
  Run, calc.exe
}
else if Pedersen = adr ; Open AppData/Roaming folder
{
  gui_destroy()
  Run, %A_AppData%
}
else if Pedersen = adl ; Open Appdata/Local folder
{
  gui_destroy()
  Run % StrReplace(A_AppData, "Roaming", "Local")
}
else if Pedersen = md ; Open Documents folder
{
  gui_destroy()
  Run %A_MyDocuments%
}
else if Pedersen = center ; Center all top-level windows
{
  gui_destroy()
  Run, nircmd.exe win center alltop
}
else if Pedersen = title ; Remove the title bar of My Computer window.
{
  gui_destroy()
  ; This hotkey  applies changes to whatever window has focus.
  WinGetTitle, currentWindow, A
  IfWinExist %currentWindow%
  {
    WinSet, Style, ^0xC00000, A ; toggle titlebar
    ; WinSet, Style,  ^0xC40000 , A ; remove frame and titlebar from current window
  }
  return
}
else if Pedersen = task ; toggle taskbar
{
  gui_destroy()
  VarSetCapacity(APPBARDATA, A_PtrSize=4 ? 36:48)

  NumPut(DllCall("Shell32\SHAppBarMessage", "UInt", 4 ; ABM_GETSTATE
    , "Ptr", &APPBARDATA
  , "Int")
? 2:1, APPBARDATA, A_PtrSize=4 ? 32:40) ; 2 - ABS_ALWAYSONTOP, 1 - ABS_AUTOHIDE
, DllCall("Shell32\SHAppBarMessage", "UInt", 10 ; ABM_SETSTATE
, "Ptr", &APPBARDATA)
KeyWait, % A_ThisHotkey
Return
}

; scripts from shortkeeper
else if Pedersen = syno ; Find synonyms from a selected word
{
  gui_destroy()
  ClipSaved := ClipboardAll
  Clipboard =
  SendInput, ^c
  ClipWait, 2
  if ErrorLevel
  {
    ;MsgBox % "Failed attempt to copy text to clipboard."
    Run % "https://synonyms.reverso.net/synonyme/en/"
  }
  else
  {
    TextSelected := Trim(Clipboard)
    Run % "https://synonyms.reverso.net/synonyme/en/" . TextSelected
  }
  Clipboard := ClipSaved
}
else if Pedersen = wias ; wordsinasentence.com
{
  gui_destroy()
  ClipSaved := ClipboardAll
  Clipboard =
  SendInput, ^c
  ClipWait, 2
  if ErrorLevel
  {
    ;MsgBox % "Failed attempt to copy text to clipboard."
    Run % "https://wordsinasentence.com/"
  }
  else
  {
    TextSelected := Trim(Clipboard)
    Run % "https://wordsinasentence.com/" . TextSelected
  }
  Clipboard := ClipSaved
}
else if Pedersen = url ; Open an URL from the clipboard 
{
  gui_destroy()
  ClipSaved := ClipboardAll
  Clipboard =
  SendInput, ^c
  ClipWait, 2
  if ErrorLevel
  {
    ; MsgBox % "Failed attempt to copy text to clipboard."
    Run % "https://google.com/"
  }
  else
  {
    TextSelected := Trim(Clipboard)
    Run % TextSelected
  }
  Clipboard := ClipSaved
}
else if Pedersen = wcount ; Get a Word Count of Selected Text
{
  gui_destroy()
  ClipSaved := ClipboardAll
  Clipboard =
  SendInput, ^c
  ClipWait, 2
  if ErrorLevel
  {
    MsgBox % "Failed attempt to read selected text."
  }
  else
  {
    NewClipboard := Trim(Clipboard)
    Count := 0
    Position := 1
    while, Position := RegExMatch(NewClipboard, "\S+", Out, Position+Strlen(Out))
      Count++
    MsgBox % "Words :" . Count
  }
  Clipboard := ClipSaved
}
else if Pedersen = wsl ; Convert Windows Path to WSL Path And Wise Versa
{
  gui_destroy()
  replaceCount = 0
  wslPath := RegExReplace(clipboard, "^([a-zA-Z]):(.*)", "/mnt/$L1$2", replaceCount)
  if replaceCount <= 0
  {
    winPath := RegExReplace(clipboard, "^\/mnt\/([a-zA-Z])(.*)", "$U1:$2", replaceCount)

    if replaceCount >= 1
    {
      StringReplace, winPath, winPath, /, \, All
      clipboard := winPath
    }
  }
  else
  {
    StringReplace, wslPath, wslPath, \, /, All
    clipboard := wslPath
  }
  return
}
else if Pedersen = lh ; Open file path in browser(localhost)
{
  gui_destroy()
  Clipboard =
  Send, ^c
  ClipWait, 1
  ; Clipboard = %Clipboard% ; use this if path already in clipboard
  wslPath := RegExReplace(clipboard, "C:\\xampp\\htdocs", "localhost")
  StringReplace, wslPath, wslPath, \, /, All
  clipboard := wslPath
  Run % "http://" . Clipboard
}

;-------------------------------------------------------------------------------
;;; INTERACT WITH THIS AHK SCRIPT ;;;
;-------------------------------------------------------------------------------
else if Pedersen = rel ; Reload this script
{
  gui_destroy() ; removes the GUI even when the reload fails
  Reload
}
else if Pedersen = dir ; Open the directory for this script
{
  gui_destroy()
  Run, %A_ScriptDir%
}
else if Pedersen = host ; Edit host script
{
  gui_destroy()
  run, notepad.exe "%A_ScriptFullPath%"
}
else if Pedersen = user ; Edit GUI user commands
{
  gui_destroy()
  Run, "C:\Users\marzouk\AppData\Local\Programs\Microsoft VS Code\Code.exe" "%A_ScriptDir%\GUI\UserCommands.ahk"
}

;-------------------------------------------------------------------------------
;;; TYPE RAW TEXT ;;;
;-------------------------------------------------------------------------------
else if Pedersen = @ ; Email address
{
  gui_destroy()
  Send, my_email_address@gmail.com
}
else if Pedersen = name ; My name
{
  gui_destroy()
  Send, My Full Name
}
else if Pedersen = phone ; My phone number
{
  gui_destroy()
  SendRaw, +45-12345678
}
else if Pedersen = int ; LaTeX integral
{
  gui_destroy()
  SendRaw, \int_0^1 \; \mathrm{d}x\,
}
else if Pedersen = shrug ; ¯\_(ツ)_/¯
{
  gui_destroy()
  Send ¯\_(ツ)_/¯
}
else if Pedersen = clip ; Paste clipboard content without formatting
{
  gui_destroy()
  SendRaw, %ClipBoard%
}
; custom faces
else if Pedersen = wink ; ¯\_(ツ)_/¯
{
  gui_destroy()
  Send ( ͡~ ͜ʖ ͡°)
}
else if Pedersen = smile ; ( ͡° ͜ʖ ͡°)
{
  gui_destroy()
  Send ( ͡° ͜ʖ ͡°)
}

;-------------------------------------------------------------------------------
;;; OPEN FOLDERS ;;;
;-------------------------------------------------------------------------------
else if Pedersen = down ; Downloads
{
  gui_destroy()
  run C:\Users\%A_Username%\Downloads
}
else if Pedersen = rec ; Recycle Bin
{
  gui_destroy()
  Run ::{645FF040-5081-101B-9F08-00AA002F954E}
  }
  else if Pedersen = ss ; Screenshots folder
  {
    gui_destroy()
    Run, C:\Users\marzouk\Documents\ShareX\Screenshots
  }
  ; custom folders
  else if Pedersen = . ; open home folder
  {
    gui_destroy()
    run, C:\Users\%A_Username%
  }
  else if Pedersen = ahk ; autohotkey folder
  {
    gui_destroy()
    run, C:\Users\%A_Username%\autohotkey
  }
  else if Pedersen = dt ; open desktop folder
  {
    gui_destroy()
    run, C:\Users\%A_Username%\Desktop
  }
  else if Pedersen = code ; open code folder
  {
    gui_destroy()
    run, C:\Users\%A_Username%\code
  }
  else if Pedersen = tuts ; open tuts folder
  {
    gui_destroy()
    run, C:\xampp\htdocs\tuts
  }
  else if Pedersen = prog ; open prog folder
  {
    gui_destroy()
    run, D:\new-downloads\programming
  }
  else if Pedersen = ala ; open ala folder
  {
    gui_destroy()
    run, D:\ala
  }

  ;-------------------------------------------------------------------------------
  ;;; MISCELLANEOUS ;;;
  ;-------------------------------------------------------------------------------
  else if Pedersen = ping ; Ping Google
  {
    gui_destroy()
    Run, cmd /K "ping -t www.google.com"
  }
  else if Pedersen = hosts ; Open hosts file in Notepad
  {
    gui_destroy()
    Run notepad.exe C:\Windows\System32\drivers\etc\hosts
  }
  else if Pedersen = date ; What is the date?
  {
    gui_destroy()
    FormatTime, date,, LongDate
    MsgBox %date%
    date =
  }
  else if Pedersen = ? ; Tooltip with list of commands
  {
    GuiControl,, Pedersen, ; Clear the input box
    Gosub, gui_commandlibrary
  }
