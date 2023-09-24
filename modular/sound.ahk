#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#SingleInstance, force

!F1::Send {Volume_Down}
!F2::Send {Volume_Up}
NumpadUp::Send {Volume_Up}
NumpadClear::Send {Volume_Up}
NumpadDown::Send {Volume_Down}
NumpadLeft::Send {Media_Prev}
NumpadRight::Send {Media_Next}
NumpadDel::Send {Media_Play_Pause}
NumpadIns::Send {Volume_Mute}
NumpadEnd Up::Send {End}
NumpadEnd & NumpadClear::suspend
