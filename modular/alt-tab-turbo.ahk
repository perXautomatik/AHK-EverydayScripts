#NoEnv
#SingleInstance force
#WinActivateForce

WinIdArray := {} ; Holds AHK_ID for each stored window

Load_Window(key) { ; Load window from stored ID
  global WinIdArray ; Get global ID array
  active_id := WinIdArray[key] ; Get window ID by key

  ; WinActivate, ahk_id %active_id% ; Activate window by AHK_ID

  IfWinActive, ahk_id %active_id%
    WinMinimize, ahk_id %active_id%
  else
    WinActivate, ahk_id %active_id%
}

Save_Window(key) { ; Store window ID
  WinGet, active_id, ID, A ; Get AHK_ID of active window

  global WinIdArray ; Get global ID array
  WinIdArray[key] := active_id ; Set window ID by key
}

; numbers - save
; ^#+1::Save_Window("1")
; ^#+2::Save_Window("2")
; ^#+3::Save_Window("3")
; ^#+4::Save_Window("4")
; ^#+5::Save_Window("5")
; ^#+6::Save_Window("6")
; ^#+7::Save_Window("7")
; ^#+8::Save_Window("8")
; ^#+9::Save_Window("9")
; ^#+0::Save_Window("0")

; numbers - load
; RAlt & 1::Load_Window("1")
; RAlt & 2::Load_Window("2")
; RAlt & 3::Load_Window("3")
; RAlt & 4::Load_Window("4")
; RAlt & 5::Load_Window("5")
; RAlt & 6::Load_Window("6")
; RAlt & 7::Load_Window("7")
; RAlt & 8::Load_Window("8")
; RAlt & 9::Load_Window("9")
; RAlt & 0::Load_Window("0")

; letters - save
^#+a::Save_Window("a")
^#+b::Save_Window("b")
^#+c::Save_Window("c")
^#+d::Save_Window("d")
^#+e::Save_Window("e")
^#+f::Save_Window("f")
^#+g::Save_Window("g")
^#+h::Save_Window("h")
^#+i::Save_Window("i")
^#+j::Save_Window("j")
^#+k::Save_Window("k")
^#+l::Save_Window("l")
^#+m::Save_Window("m")
^#+n::Save_Window("n")
^#+o::Save_Window("o")
^#+p::Save_Window("p")
^#+q::Save_Window("q")
^#+r::Save_Window("r")
^#+s::Save_Window("s")
^#+t::Save_Window("t")
^#+u::Save_Window("u")
^#+v::Save_Window("v")
^#+w::Save_Window("w")
^#+x::Save_Window("x")
^#+y::Save_Window("y")
^#+z::Save_Window("z")

; letters - load
; RAlt & a::Load_Window("a")
; RAlt & b::Load_Window("b")
; RAlt & c::Load_Window("c")
; RAlt & d::Load_Window("d")
; RAlt & e::Load_Window("e")
; RAlt & f::Load_Window("f")
; RAlt & g::Load_Window("g")
; RAlt & h::Load_Window("h")
; RAlt & i::Load_Window("i")
; RAlt & j::Load_Window("j")
; RAlt & k::Load_Window("k")
; RAlt & l::Load_Window("l")
; RAlt & m::Load_Window("m")
; RAlt & n::Load_Window("n")
; RAlt & o::Load_Window("o")
; RAlt & p::Load_Window("p")
; RAlt & q::Load_Window("q")
; RAlt & r::Load_Window("r")
; RAlt & s::Load_Window("s")
; RAlt & t::Load_Window("t")
; RAlt & u::Load_Window("u")
; RAlt & v::Load_Window("v")
; RAlt & w::Load_Window("w")
RAlt & x::Load_Window("x")
; RAlt & y::Load_Window("y")
RAlt & z::Load_Window("z")
