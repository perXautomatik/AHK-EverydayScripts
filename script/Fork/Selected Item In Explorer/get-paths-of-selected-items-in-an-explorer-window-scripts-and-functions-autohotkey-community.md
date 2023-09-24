Rapte\_Of\_Suzaku

- Members
- 901 posts

- ![](//www.autohotkey.com/board/public/style_images/ortem/post_offline.png) Last active: Jul 08 2011 02:12 PM
- Joined: 29 Feb 2008

Library for getting info from a specific explorer window (if window handle not specified, the currently active window will be used). Requires AHK\_L or similar. Works with the desktop. Does not currently work with save dialogs and such.  
  
  
Explorer\_GetSelected(hwnd="") - paths of target window's selected items  
Explorer\_GetAll(hwnd="") - paths of all items in the target window's folder  
Explorer\_GetPath(hwnd="") - path of target window's folder

updated version: 2010-12-04, 14:39
fixed bug with ftp paths (2011-04-27, 16:12)