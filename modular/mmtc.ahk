#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#singleInstance, force

ProcessExist(Name){
	Process, Exist, %Name%
	return Errorlevel
}

#If ProcessExist("mmtc.exe")
  NumpadRight::Run, cmd.exe /c mmtc -C next,, hide
  NumpadLeft::Run, cmd.exe /c mmtc -C previous,, hide
  NumpadDel::Run, cmd.exe /c mmtc -C pause,, hide
  NumpadMult::Run, cmd.exe /c mmtc -C "seekcur +5",, hide
  NumpadDiv::Run, cmd.exe /c mmtc -C "seekcur -5",, hide
  NumpadPgUp::Run, cmd.exe /c mmtc -C "volume +2",, hide
  NumpadPgDn::Run, cmd.exe /c mmtc -C "volume -2",, hide
  NumpadAdd::Run, cmd.exe /c mmtc -C "volume +2",, hide
  NumpadSub::Run, cmd.exe /c mmtc -C "volume -2",, hide
  NumpadHome::Run, cmd.exe /c mmtc -C "setvol 70",, hide
#If
