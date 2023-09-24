#p::
WinGet, id, list, $EURUSD
Loop, %id%
{
this_id := id%A_Index%
WinActivate, ahk_id %this_id%
}
return

