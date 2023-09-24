#v::Suspend

#IfWinActive ahk_class Fallout4
~RButton::
Send, {r down}
Sleep 50
Send, {r up}
Sleep, 500
Send, {Enter down}
Sleep 50
Send, {Enter up}
Return

~LButton::
Send, {Tab down}
Sleep 50
Send, {Tab up}
Sleep, 500
Send, {Enter down}
Sleep 50
Send, {Enter up}
Return
#IfWinActive