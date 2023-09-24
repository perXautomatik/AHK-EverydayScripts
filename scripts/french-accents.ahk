#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

/*
Easy accents on a qwerty keyboard including french ç as well as spanish ñ and ¿ 1nd ¡

Inspired a.o. by https://autohotkey.com/board/topic/16920-how-to-enter-basic-spanish-accented-characters/
Note: Obtained the unicode values at: https en.wikipedia.org /wiki/List_of_Unicode_characters  Broken Link for safety

Basiclly this solution allows to type any vowel followed by any of ['"\^] to obtain the 'accented' version:
' after [aeiou] produces [áéíóú]
" after [aeiou] produces [äëïöü]
\ after [aeiou] produces [àèìòù]
^ after [aeiou] produces [âêîôû]
' after [NnCc?!] procuces [ÑñÇç¿¡]

This approach requires extra care to enter a quote or single quote character as such after a vowel.
This is cared for by preceding ' or " with a space:
this sequence will be changed into a ' or " without the ledig space.

Note: I use the \ key to issue an ` accent, because it is available
on my US Apple keyboard as an extra key between the single/double quotes key and the return key.
This is just a personal lazy solution, the real ` key could be used as well.
*/

;; a ;;
:C*?:A\::{U+00C0} ; A followed by \ => À
:C*?:A'::{U+00C1} ; A followed by ' => Á
:C*?:A^::{U+00C2} ; A followed by ^ => Â
:C*?:A"::{U+00C4} ; A followed by " => Ä
:C*?:a\::{U+00E0} ; a followed by \ => à
:C*?:a'::{U+00E1} ; a followed by ' => á
:C*?:a^::{U+00E2} ; a followed by ^ => â
:C*?:a"::{U+00E4} ; a followed by " => ä

  ;; e ::
:C*?:E\::{U+00C8} ; E followed by \ => È
:C*?:E'::{U+00C9} ; E followed by ' => É
:C*?:E^::{U+00CA} ; E followed by ^ => Ê
:C*?:E"::{U+00CB} ; E followed by " => Ë
:C*?:e\::{U+00E8} ; e followed by \ => è
:C*?:e'::{U+00E9} ; e followed by ' => é
:C*?:e^::{U+00EA} ; e followed by ^ => ê
:C*?:e"::{U+00EB} ; é followed by " => ë

  ;; i ;;
:C*?:I\::{U+00CC} ; I followed by \ => Ì
:C*?:I'::{U+00CD} ; I followed by ' => Í
:C*?:I^::{U+00CE} ; I followed by ^ => Î
:C*?:I"::{U+00CF} ; I followed by " => Ï
:C*?:i\::{U+00EC} ; i followed by \ => ì
:C*?:i'::{U+00ED} ; i followed by ' => í
:C*?:i^::{U+00EE} ; i followed by ^ => î
:C*?:i"::{U+00EF} ; i followed by " => ï

  ;; o ;;
:C*?:O\::{U+00D2} ; O followed by \ => Ò
:C*?:O'::{U+00D3} ; O followed by ' => Ó
:C*?:O^::{U+00D4} ; O followed by ^ => Ô
:C*?:O"::{U+00D6} ; O followed by " => Ö
:C*?:o\::{U+00F2} ; o followed by \ => ò
:C*?:o'::{U+00F3} ; o followed by ' => ó
:C*?:o^::{U+00F4} ; o followed by ^ => ô
:C*?:o"::{U+00F6} ; o followed by " => ö

  ;; u ;;
:C*?:U\::{U+00D9} ; U followed by \ => Ù
:C*?:U'::{U+00DA} ; U followed by ' => Ú
:C*?:U^::{U+00DB} ; U followed by ^ => Û
:C*?:U"::{U+00DC} ; U followed by " => Ü
:C*?:u\::{U+00F9} ; u followed by \ => ù
  ; :C*?:u'::{U+00FA} ; u followed by ' => ú
:C*?:u^::{U+00FB} ; u followed by ^ => û
:C*?:u"::{U+00FC} ; u followed by " => ü

  ;; c ;;
:C*?:C,::{U+00C7} ; C followed by ' => Ç
:C*?:c,::{U+00E7} ; c followed by ' => ç

  ;; n ;;
  ; :C*?:N'::{U+00D1} ; N followed by ' => N
  ; :C*?:n'::{U+00F1} ; n followed by ' => ñ
  ; :C*?:N|::{U+00D1} ; N followed by | => N
  ; :C*?:n|::{U+00F1} ; n followed by | => ñ

  ;; ! ;;
:*?:!'::{U+00A1} ; ! followed by ' => ¡

  ;; ? ;;
:*?:?'::{U+00BF} ; ? followed by ' => ¿

  ;; {space} followed by single quote removes the space and issues a ' (allows a quote after e, o...);;
  :*?: '::' ; '

  ;; {space} followed by double quote removes the space and issues a " (allows a " after e, o...);;
  :*?: "::" ; "

  ;; Thanks for comments and or corrections to Guido Van Hoecke <guivho@gmail.com>

  #f::suspend
#k::ExitApp
