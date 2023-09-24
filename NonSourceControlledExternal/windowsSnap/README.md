# Advanced Window Snap

Advanced Window Snap is a script for [AutoHotKey] that expands upon Windows built-in window-snapping hotkeys (which are <kbd>Win</kbd> + <kbd>LEFT</kbd> to snap an active window to the left half of a monitor and <kbd>Win</kbd> + <kbd>RIGHT</kbd> to snap a window to the right half of a monitor) by adding 9 additional snap methods.

## Installation Steps

1. Install [AutoHotKey]
2. Copy or Download the **AdvancedWindowSnap.ahk** file to your computer and double click it to run it.
3. (Optional) To have the program run when you start up your computer, place the .ahk file into your computer's [startup] folder. 
    * The Windows 7 Startup Folder can be accessed by mousing to **Start** > **All Programs**, then right-clicking on **Startup** and selecting "**Open**".
    * The Windows 8 Startup Folder can be accessed by tapping <kbd>Win</kbd> + <kbd>R</kbd> on your keyboard, then in the Open: field, type `shell:startup` then press <kbd>Enter</kbd>.

## Advanced Window Snap Keybindings

### Directional Arrow Hotkeys:
Hotkey | Behavior
------ | --------
<kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>UP</kbd> | Window will snap to the top **half** of the screen.
<kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>DOWN</kbd> | Window will snap to the bottom **half** of the screen.
<kbd>Ctrl</kbd> + <kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>UP</kbd> | Window will snap to the top **third** of the screen.
<kbd>Ctrl</kbd> + <kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>DOWN</kbd> | Window will snap to the bottom **third** of the screen.

### Numberpad Hotkeys (Landscape):
These will work only if you have NumLock turned **ON**. These are ideal for Landscape Monitors.

Hotkey | Behavior
------ | --------
<kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Numpad 7</kbd> | Window will snap to the top-left **quarter** of the screen.
<kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Numpad 8</kbd> | Window will snap to the top **half** of the screen.
<kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Numpad 9</kbd> | Window will snap to the top-right **quarter** of the screen.
<kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Numpad 1</kbd> | Window will snap to the bottom-left **quarter** of the screen.
<kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Numpad 2</kbd> | Window will snap to the bottom **half** of the screen.
<kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Numpad 3</kbd> | Window will snap to the bottom-right **quarter** of the screen.

### Numberpad Hotkeys (Portrait):
These will work only if you have NumLock turned **ON**. These are ideal for Portrait Monitors.

Hotkey | Behavior
------ | --------
<kbd>Ctrl</kbd> + <kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Numpad 8</kbd> | Window will snap to the top **third** of the screen.
<kbd>Ctrl</kbd> + <kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Numpad 5</kbd> | Window will snap to the middle **third** of the screen.
<kbd>Ctrl</kbd> + <kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Numpad 2</kbd> | Window will snap to the bottom **third** of the screen

## Changelog

- **v1.00**, *08 Jan 2015*
    - Initial Version

## Recommendation For Editing AHK Files
If you plan on working with AutoHotKey files, consider using [Sublime Text 3]. Read my steps for setting up Sublime Text 3 to edit AutoHotKey files here: [Working with AutoHotKey in Sublime Text].

[AutoHotKey]:http://ahkscript.org/
[startup]:http://www.autohotkey.com/docs/FAQ.htm#Startup]
[Sublime Text 3]:http://www.sublimetext.com/3
[Package Control]:https://packagecontrol.io/installation
[AutoHotKey Package]:https://packagecontrol.io/packages/AutoHotkey
[Working with AutoHotKey in Sublime Text]:https://gist.github.com/AWMooreCO/d0308bab265cc8c5e122