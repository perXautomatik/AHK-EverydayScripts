PgUp::
    Toggle1 := !Toggle1
    settimer,doloop1,1
return

doloop1:
settimer,doloop1,off
while (Toggle1) {

sleep 50
Send s
sleep 50
Send e
sleep 50
Send d
sleep 50
Send s
sleep 50
Send e
sleep 50
Send e
sleep 50
Send d
sleep 50
Send s
sleep 50
Send e
sleep 50
Send r
sleep 50
Send y
sleep 50
Send s
sleep 50
Send e
sleep 50
Send a
sleep 50
Send s
sleep 50
Send e
sleep 50
Send e
sleep 50
Send a
sleep 50
Send s
sleep 50
Send e
sleep 50
Send r
sleep 50
Send y
}
Return

PgDn::
    Toggle2 := !Toggle2
    settimer,doloop2,1
return

doloop2:
settimer,doloop2,off
while (Toggle2) {

sleep 50
Send s
sleep 50
Send e
sleep 50
Send d
sleep 50
Send s
sleep 50
Send s
sleep 50
Send s
sleep 50
Send s
sleep 50
Send s
sleep 50
Send e
sleep 50
Send e
sleep 50
Send d
sleep 50
Send s
sleep 50
Send e
sleep 50
Send r
sleep 50
Send y
sleep 50
Send s
sleep 50
Send e
sleep 50
Send a
sleep 50
Send s
sleep 50
Send s
sleep 50
Send s
sleep 50
Send s
sleep 50
Send s
sleep 50
Send e
sleep 50
Send e
sleep 50
Send a
sleep 50
Send s
sleep 50
Send e
sleep 50
Send r
sleep 50
Send y
}
Return

Insert::
    Toggle3 := !Toggle3
    settimer,doloop3,1
return

doloop3:
settimer,doloop3,off
while (Toggle3) {
sleep 50
Send r
}
Return

Delete::
    Toggle4 := !Toggle4
    settimer,doloop4,1
return

doloop4:
settimer,doloop4,off
while (Toggle4) {
sleep 50
Send e
sleep 50
Send y
}
Return