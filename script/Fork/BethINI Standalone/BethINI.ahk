#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Load external libraries
#Include %A_ScriptDir%/Lib/RIni.ahk
#Include %A_ScriptDir%/Lib/GetGameSettings.ahk
#Include %A_ScriptDir%/Lib/GeneralFunctions.ahk

;because this program wasn't always called BethINI
global scriptName := "BethINI"
;because blank is nothing, and I wanted a variable that reflected this
global blank :=

GameStart := getSettingValueProject("General", "sGameName")
if getSettingValueProject("General", "bAlwaysSelectGame", "0") = 1 and getSettingValueProject("General", "sRestartedFromSetupTab", "0") = 0
	{
		GameStart =
		IniDelete, %scriptName%.ini, Directories, sGamePath
	}


if GameStart =
	{
		Gui, New,, Choose Game
		Gui, +LabelChooseGame
		Gui, Font, s8, Courier New
		Gui, Font, s8, Verdana
		Gui, Font, s8, Arial
		Gui, Font, s8, Segoe UI
		Gui, Font, s8, Tahoma
		Gui, Font, s8, Microsoft Sans Serif
		Gui, Add, Text, Section, Game
		Gui, Add, DropDownList, vGameStart gGameStart ys-3 w200, Enderal: Forgotten Stories|Fallout 3|Fallout 4|Fallout New Vegas|Oblivion|Skyrim|Skyrim Special Edition
		GameStart_TT := "Choose your game."
		Gui, Show

		Loop, 120
			{
				if GameStart !=
					break
				Sleep, 1000
			}
		if GameStart =
			{
				MsgBox, You have failed to select a game within three minutes, and BethINI is impatient!`n`nI shall take my leave!
				ExitApp
			}
		if !FileExist(scriptName . ".ini")
			{
				FileAppend, % "[General]`nsGameName=" . GameStart, %scriptName%.ini
			}
		IniWrite, %GameStart%, %scriptName%.ini, General, sGameName
		Gui, Destroy
	}
IniWrite, 0, %scriptName%.ini, General, sRestartedFromSetupTab
	
SplashTextOn, 100, 30, Please Wait, Loading

;sets the time BethINI was started
global theTime := A_YYYY . A_Space . A_DDD . A_Space . A_MMM . A_Space . A_DD . " - " . A_Hour . "." . A_Min . "." . A_Sec
;Sets the game
global gameName := getGameName()
global gameNameEnderalWorkaround := gameName
if gameName = Enderal: Forgotten Stories
	{
		global isEnderalForgotten := 1
		global gameNameEnderalWorkaround := "Enderal"
		global gameName := "Skyrim"	
	}
sm("Game: " . gameNameEnderalWorkaround)
;if the game is Oblivion, there is no Prefs INI
if gameName = Oblivion
	global Prefs :=
else
	global Prefs := "Prefs"
;because this program wasn't always called BethINI
global shortName := "BethINI"
;because just getting the game name isn't enough
global gameNameReg := GetGameRegName()
sm("Game Registry Name: " . gameNameReg)
global gameNameLauncher := GetGameLauncherName()
sm("Game Launcher Name: " . gameNameLauncher)

;where is the game located?
global gameFolder := GetFolder()
sm("Game Path: " . gameFolder)

global gameNameINI := GetGameIniName()
sm("Game INI Name: " . gameNameINI)
if isEnderalForgotten = 1
	global gameNameINIWorkaroundForEnderalForgotten := "Skyrim"
else
	global gameNameINIWorkaroundForEnderalForgotten := gameNameINI

global gameNameEXE := GetGameEXEName()
sm("Game Executable Name: " . gameNameEXE)
;where are the INI files?
global INIfolder := getMyGames()
sm("Game Settings Path: " . INIfolder)
if FileExist(INIfolder . "settings.ini")
	{
		IniRead, LocalSettings, % INIfolder . "settings.ini", General, LocalSettings, true
		if (LocalSettings = "false")
			{
				sm("Local settings for the current profile are disabled.")
				WinHide, Please Wait
				MsgBox, 4, Enable Profile-specific INI files?, BethINI is pointed to a Mod Organizer profile to manage its profile INI files. However, Local Settings is not enabled for this profile, which means that THESE INI FILES WILL NOT BE USED! Do you wish to enable Local Settings for this profile?
				IfMsgBox, Yes
					{
						IniWrite, true, % INIfolder . "settings.ini", General, LocalSettings
						sm("Local settings for the current profile were enabled.")
					}
				else
					{
						MsgBox, The INI files you are managing will not be used by the game!
						sm("The INI files you are managing will not be used by the game!")
					}
				WinShow, Please Wait
			}
	}
;Let's create the cache directory for our logs and backups
FileCreateDir, %INIfolder%%shortName% Cache\%theTime%
;because this program wasn't always called BethINI
global projectName := "BethINI"

;Where is Mod Organizer located, if it is being used?
global modOrganizerFolder := getModOrganizer()
sm("MO Path: " . modOrganizerFolder)
global profilesFolder := getProfilesFolder()
sm("MO Profiles folder: " . profilesFolder)

;Thou shalt not run BethINI while Mod Organizer is running
Process, Exist, ModOrganizer.exe
if ErrorLevel != 0
	{
		MsgBox, 262144, Please close Mod Organizer, It is highly recommended that you close Mod Organizer before continuing. If you are running this through Mod Organizer, arrows shall constantly strike your knee in-game for not reading the instructions!
		sm("Mod Organizer was detected and the user was politely asked to close it.")
	}
Process, Exist, ModOrganizer.exe
if ErrorLevel != 0
	sm("User failed to close Mod Organizer. Initiating Draugr Apocalypse...")
else
	sm("User closed Mod Organizer before continuing. Draugr Apocalypse averted.")

;We use this to discover whether or not the INI files are set to read-only. See "RdOnly"
FileGetAttrib, Attributes, %INIfolder%%gameNameINI%.ini

;Time to backup the INI files
Backup()

;Ask the user if they want to allow modification of Custom INI files
if FileExist(INIfolder . gameNameINI . "Custom.ini") or FileExist(INIfolder . "Custom.ini")
	{
		if (getSettingValueProject("General", "bModifyCustomINIs", "NoValue") = "NoValue")
			{
				WinHide, Please Wait
				MsgBox, 4, Modify Custom INIs?, BethINI has the ability to modify the game's Custom INI files, if found, to match any changes you make (Recommended). Do you want to allow BethINI to do this?`n`n(Note: This feature can be toggled at any time in the Setup tab. Backups shall always be made of your Custom INI files.)
				IfMsgBox, Yes
					{
						IniWrite, 1, %scriptName%.ini, General, bModifyCustomINIs
						sm("BethINI will modify any Custom INI files.")
					}
				else
					{
						IniWrite, 0, %scriptName%.ini, General, bModifyCustomINIs
						sm("BethINI will not modify Custom INI files.")
					}
				WinShow, Please Wait
			}
	}


;Custom INIs and main INIs shall become the same
if getSettingValueProject("General", "bModifyCustomINIs", "1") = 1
	{
		if FileExist(INIfolder . gameNameINI . "Custom.ini")
			IntegrateINI(INIfolder . gameNameINI . ".ini", INIfolder . gameNameINI . "Custom.ini")
		if FileExist(INIfolder . "Custom.ini")
			IntegrateINI(INIfolder . gameNameINI . ".ini", INIfolder . "Custom.ini")
	}
	
;Apply Mod Suggested INI tweaks before loading the GUI
modSuggestedINITweaks()
;DllCall("uxtheme\SetThemeAppProperties", "UInt", 0)
;And now for the GUI
Gui, Main:New, , %projectName%
;Gui, Main:-sysmenu
Gui, +LabelMainGui


Gui, Font, s8, Courier New
Gui, Font, s8, Verdana
Gui, Font, s8, Arial
Gui, Font, s8, Segoe UI
Gui, Font, s8, Tahoma
Gui, Font, s8, Microsoft Sans Serif
;Gui, Font, s8, Courier New
;Gui, Font, s8, Verdana



Gui, Add, Tab2, vCustomTab gCustomTab w885 r17, Setup|Basic||General|Gameplay|Interface|Detail|View Distance|Visuals|Custom
CustomTab_TT := ""

Gui, Add, Text, Section, Game
Gui, Add, Text, , Game Path
Gui, Add, Text, , Mod Organizer
Gui, Add, Text, , INI Path
Gui, Add, Text, , Restore Backup
Gui, Add, DropDownList, vGame gGame ys-3 w435,
Game_TT := "Changes the game."
GuiControl, Main:, Game, % getGameList()

Gui, Add, DropDownList, vGamePath gGamePath w435,
GamePath_TT := "Changes the game directory."
GuiControl, Main:, GamePath, % GetFolder() . "||Browse..."

Gui, Add, DropDownList, vMOPath gMOPath w435, Browse...
MOPath_TT := "Changes the Mod Organizer path."
if modOrganizerFolder !=
	if modOrganizerFolder != 0
		GuiControl, Main:, MOPath, % "|" . modOrganizerFolder . "||Browse..."

Gui, Add, DropDownList, vINIPath gINIPath w435,
INIPath_TT := "Changes the directory that the INI files are located in. Currently set to:`n" . INIfolder
INIPathFolder := INIfolder
if INIPathFolder contains %profilesFolder%
	{
		StringReplace, INIPathFolder, INIPathFolder, % profilesFolder, % "ModOrganizer > ", All
		StringReplace, INIPathFolder, INIPathFolder, % "\", % blank, All
	}
INIPath := INIPathFolder . "|" . A_MyDocuments . "\My Games\" . gameNameReg . "\|" . getProfiles()
Sort, INIPath, U D|
StringReplace, INIPath, INIPath, % INIPathFolder, % INIPathFolder . "|", All
if getProfiles() = blank
	INIPath := INIPath . "Browse..."
else
	INIPath := INIPath . "|Browse..."
GuiControl, Main:, INIPath, % INIPath

Gui, Add, DropDownList, vRestoreBackup gRestoreBackup w435,
RestoreBackup_TT := "Select a backup set of INI files you want to restore."
deleteExcessBackups()
GuiControl, Main:, RestoreBackup, % getBackupList()
Gui, Add, Checkbox, vbUpdateCheck gbUpdateCheck xs Section, Automatically Check for Updates
bUpdateCheck_TT := "Toggles the ability of " . shortName . " to automatically check for updates."
bUpdateCheck := getSettingValueProject("General", "bUpdateCheck", "1")
GuiControl, Main:, bUpdateCheck, %bUpdateCheck%
Gui, Add, Checkbox, vbAlwaysSelectGame gbAlwaysSelectGame , Always Select Game
bAlwaysSelectGame_TT := "If enabled, BethINI will always ask you to choose your game at startup."
bAlwaysSelectGame := getSettingValueProject("General", "bAlwaysSelectGame", "0")
GuiControl, Main:, bAlwaysSelectGame, %bAlwaysSelectGame%
Gui, Add, Checkbox, vRdOnly gRdOnly , Make INIs Read-Only
RdOnly_TT := "Upon saving, toggles whether or not your INI files shall be set to read-only,`nwhich prevents changes being made."
IfInString, Attributes, R
	RdOnly := 1
else
	RdOnly := 0
GuiControl, Main:, RdOnly, %RdOnly%
Gosub, RdOnly
if (getSettingValueProject("General", "bModifyCustomINIs", "NoValue") <> "NoValue")
	{
		Gui, Add, Checkbox, vbModifyCustomINIs gbModifyCustomINIs , Modify Custom INIs
		bModifyCustomINIs_TT := "If enabled, BethINI will modify any custom INI files found to reflect changes made.`nIf disabled, BethINI will still backup your Custom INI files, but will not actually make any modifications to them."
		bModifyCustomINIs := getSettingValueProject("General", "bModifyCustomINIs", "0")
		GuiControl, Main:, bModifyCustomINIs, %bModifyCustomINIs%
	}
if gameName = Skyrim
	{
		Gui, Add, Checkbox, vFixCreationKit gFixCreationKit , Fix Creation Kit
		FixCreationKit_TT := "Toggles the ability of " . shortName . " to fix and sort the Creation Kit INI files."
		FixCreationKit := getSettingValueProject("General", "bCreationKit", "0")
		GuiControl, Main:, FixCreationKit, %FixCreationKit%
	}
Gui, Add, Link, vFake1 Border, <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=GURM44ASJUM2Q">Donate to STEP</a>
Fake1_TT :=""
Fake2_TT :=""
Fake3_TT :=""
if gameName = Skyrim
	Gui, Add, Link, vFake2 Border, <a href="http://wiki.step-project.com/STEP:Guide">STEP Guide</a>
Gui, Add, Link, vFake3 Border, <a href="http://forum.step-project.com/topic/13322-">Need Help?</a>

Gui, Add, Checkbox, vbDeleteInvalidSettingsOnSummary gbDeleteInvalidSettingsOnSummary ys, Auto-detect Invalid Settings
bDeleteInvalidSettingsOnSummary_TT := "If enabled, BethINI will delete any settings it detects as being invalid when compared to the master`nlist of all valid settings. However, there is a bug that can cause it to delete valid settings in`nsome cases, which should be automatically detected, disabling this feature. Uncheck this if you`nexperience valid settings being removed. You can easily determine if this is the case via the Summary`nof Changes feature. Invalid settings are never used by the game, so it doesn't really hurt your game`nto disable this feature. Please note that this toggle does not cause BethINI to leave invalid settings`nintact in every instance, as this only affects the areas caused by this bug. If turning this off still`ndoesn't fix your issue, please notify me via the ""Need Help"" link below."
bDeleteInvalidSettingsOnSummary := getSettingValueProject("General", "bDeleteInvalidSettingsOnSummary", "1")
GuiControl, Main:, bDeleteInvalidSettingsOnSummary, %bDeleteInvalidSettingsOnSummary%



	
Gui, Tab, 2
Gui, Add, GroupBox, r6 w590, Display
if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		Gui, Add, Text, xp+9 yp+20 Section, Display Adapter
		Gui, Add, Text, , Resolution
	}
else
	Gui, Add, Text, xp+9 yp+20 Section, Resolution
Gui, Add, Text, , Antialiasing
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	Gui, Add, Text, , Anisotropic Filtering

	
if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		Gui, Add, DropDownList, viAdapter gDisplayAdapter ys-3,
		iAdapter_TT := "Changes the display device that the game shall be displayed upon.`n`n[Display]`niAdapter"
		SysGet, adapterCount, MonitorCount
		SysGet, iAdapter, MonitorPrimary
		iAdapter := iAdapter - 1
		adapters := adapters(adapterCount, iAdapter)
		GuiControl, Main:, iAdapter, %adapters%
		Gui, Add, ComboBox, vResolution gResolution Uppercase,
	}
else
	Gui, Add, ComboBox, vResolution gResolution ys-3 Uppercase,
Resolution_TT := "Changes the resolution. You can manually type in a custom resolution.`n`n[Display]`niSize H`niSize W"
Resolution := getScreens()
GuiControl, Main:, Resolution, %Resolution%

Gui, Add, ComboBox, vAntialiasing gAntialiasing ,
if gameName = Fallout 4
	Antialiasing_TT := "Specifies the antialiasing (AA) applied to edges to make them smoother and less jagged.`n`n[Display]`nsAntiAliasing"
else if gameName = Skyrim Special Edition
	Antialiasing_TT := "Specifies the antialiasing (AA) applied to edges to make them smoother and less jagged.`n`nPerformance cost: 2%`n`n[Display]`nbUseTAA"
else
	Antialiasing_TT := "Sets the level of antialiasing (AA) applied to edges to make them smoother and less jagged.`nYou can manually type in a custom value.`n`n[Display]`niMultiSample"
Antialiasing := getAntialias()
GuiControl, Main:, Antialiasing, %Antialiasing%


if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		Gui, Add, ComboBox, vAnisotropic gAnisotropicFiltering ,
		Anisotropic_TT := "Sets the level of anisotropic filtering (AF), improving the texture quality of distant objects.`nYou can manually type in a custom value.`n`n[Display]`niMaxAnisotropy"
		Anisotropic := getAnisotropy()
		GuiControl, Main:, Anisotropic, %Anisotropic%
	}

Gui, Add, Checkbox, vWindowed gWindowedMode ys, Windowed Mode
Windowed_TT := "Toggles Windowed/Fullscreen mode.`n`n[Display]`nbFull Screen"
Windowed := Abs(getSettingValue("Display", "bFull Screen", Prefs, "0") - 1)
GuiControl, Main:, Windowed, %Windowed%

if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Oblivion")
	{
		Gui, Add, Checkbox, vbAllow30Shaders gbAllow30Shaders , Allow 3.0 Shaders
		bAllow30Shaders_TT := "Toggles the ability of the game to use 3.0 shaders. This will not necessarily improve visuals, but may improve performance and remove bugs.`nYou must also force shaderpackage019.sdp to be used instead of the one specified in your RendererInfo.txt for this to work.`n`n[Display]`nbAllow30Shaders"
		bAllow30Shaders := getSettingValue("Display", "bAllow30Shaders", blank, "0")
		GuiControl, Main:, bAllow30Shaders, %bAllow30Shaders%
	}

if (gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vbBorderless gbBorderless , Borderless
		bBorderless_TT := "Toggles the window border off and on.`n`n[Display]`nbBorderless"
		bBorderless := getSettingValue("Display", "bBorderless", Prefs, "0")
		GuiControl, Main:, bBorderless, %bBorderless%
	}
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vFXAA gFXAA , FXAA
		FXAA_TT := "Toggles an almost zero-cost approximation of fake antialiasing using the FXAA technique.`nIt actually seems to work well, and may be good enough on low-end systems to use it and disable antialiasing.`nNote, however, that there is a slight blurring applied to everything as a side effect.`n`nPerformance cost: 1%`n`n[Display]`nbFXAAEnabled"
		bFXAAEnabled := getSettingValue("Display", "bFXAAEnabled", Prefs, "0")
		GuiControl, Main:, FXAA, %bFXAAEnabled%
	}
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vbAlwaysActive gAlwaysActive , Always Active
		bAlwaysActive_TT := "Toggles the ability of the game to remain active when it is out of focus`n(i.e. if in a windowed mode setup, if one clicks outside the game window with this enabled, the game will not pause).`n`n[General]`nbAlwaysActive"
		bAlwaysActive := getSettingValue("General", "bAlwaysActive", blank, "0")
		GuiControl, Main:, bAlwaysActive, %bAlwaysActive%
	}
if gameName = Skyrim Special Edition
	{
		Gui, Add, Checkbox, vbUse64bitsHDRRenderTarget gbUse64bitsHDRRenderTarget , 64-Bit Render Targets
		bUse64bitsHDRRenderTarget_TT := "Toggles 64-bit render targets. Disabling this can cause a significant performance boost with very little visual difference.`nBasically it is a more precise method of rendering that reduces banding artifacts.`n`nPerformance cost: 5%`n`n[Display]`nbUse64bitsHDRRenderTarget"
		bUse64bitsHDRRenderTarget := getSettingValue("Display", "bUse64bitsHDRRenderTarget", Prefs, "1")
		GuiControl, Main:, bUse64bitsHDRRenderTarget, %bUse64bitsHDRRenderTarget%
	}
if gameName = Fallout 4
	{
		Gui, Add, Checkbox, vbTopMostWindow gbTopMostWindow , Always On Top
		bTopMostWindow_TT := "Toggles the ability for the game window to always be the top-most window.`n`n[Display]`nbTopMostWindow"
		bTopMostWindow := getSettingValue("Display", "bTopMostWindow", Prefs, "0")
		GuiControl, Main:, bTopMostWindow, %bTopMostWindow%

		Gui, Add, Checkbox, vbMaximizeWindow gbMaximizeWindow , Maximize Window
		bMaximizeWindow_TT := "Toggles the ability for the game window to maximize, stretching across your resolution.`nIf used incorrectly, it can cause the game to be distorted.`nIt is recommended to be off in most cases,`nbut you can experiment with it.`n`n[Display]`nbMaximizeWindow"
		bMaximizeWindow := getSettingValue("Display", "bMaximizeWindow", Prefs, "0")
		GuiControl, Main:, bMaximizeWindow, %bMaximizeWindow%
	}
	
Gui, Add, Checkbox, viPresentInterval gVSync ys, VSync
if gameName = Skyrim Special Edition
	iPresentInterval_TT := "Toggles vertical synchronization (VSync), which removes screen tearing.`n`n[Display]`niVSyncPresentInterval"
else
	iPresentInterval_TT := "Toggles vertical synchronization (VSync), which removes screen tearing.`n`n[Display]`niPresentInterval"
if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	iPresentInterval := getSettingValue("Display", "iPresentInterval", blank, "1")
else if gameName = Skyrim Special Edition
	iPresentInterval := getSettingValue("Display", "iVSyncPresentInterval", Prefs, "1")
else
	iPresentInterval := getSettingValue("Display", "iPresentInterval", Prefs, "1")
if iPresentInterval <> 0
	iPresentInterval = 1
GuiControl, Main:, iPresentInterval, %iPresentInterval%

if (gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		Gui, Add, Checkbox, vbTransparencyMultisampling gbTransparencyMultisampling , Transparency AA
		bTransparencyMultisampling_TT := "Toggles transparency antialiasing on textures for better quality,`noften disabled for better performance.`n`n[Display]`nbTransparencyMultisampling"
		bTransparencyMultisampling := getSettingValue("Display", "bTransparencyMultisampling", Prefs, "0")
		GuiControl, Main:, bTransparencyMultisampling, %bTransparencyMultisampling%
	}

if gameName = Skyrim Special Edition
	{
		Gui, Add, Checkbox, vHalfRate gHalfRate , Half Hertz
		HalfRate_TT := "Toggles vertical synchronization (VSync) at half your monitor's refresh rate. `n`n[Display]`niVSyncPresentInterval"
		HalfRate := getSettingValue("Display", "iVSyncPresentInterval", Prefs, "1")
		if HalfRate = 2
			HalfRate = 1
		else
			HalfRate = 0
		GuiControl, Main:, HalfRate, %HalfRate%
		
		Gui, Add, Checkbox, vbLockFrameRate gbLockFrameRate , Lock Frame Rate
		bLockFrameRate_TT := "Toggles the ability for the game to lock the frame rate to 60 frames per second.`n`n[Display]`nbLockFrameRate"
		bLockFrameRate := getSettingValue("Display", "bLockFrameRate", blank, "1")
		GuiControl, Main:, bLockFrameRate, %bLockFrameRate%
	}
		
Gui, Add, Checkbox, viFPSClamp giFPSClamp , Clamped
iFPSClamp_TT := "Clamps the game's speed to the FPS.`nPossibly useful in combination with the FPS tweak.`n`n[General]`niFPSClamp"
iFPSClamp := getSettingValue("General", "iFPSClamp", blank, "0")
if iFPSClamp <> 0
	iFPSClamp = 1
GuiControl, Main:, iFPSClamp, %iFPSClamp%

Gui, Add, Text, , FPS
Gui, Add, Edit, vFPS gFPS x+m yp-3 w24 Number,
FPS_TT := "Sets the game physics to run at a custom framerate.`nA setting of 60 effectively disables this tweak.`n`n[HAVOK]`nfMaxTime"
FPS := Round(1/getSettingValue("HAVOK", "fMaxTime", blank, "0.0166666675"), 0)
GuiControl, Main:, FPS, %FPS%

Gui, Add, GroupBox, w460 r3 xs-9 ys+120, Presets
Gui, Add, Button, vButtonPoor gButtonPoor xp+9 yp+20 w60 h23 Section, Poor
ButtonPoor_TT := "Sets the Poor preset.`nThis preset should be used by people who have a really slow computer and struggle to get 20fps on low."
Gui, Add, Button, vButtonLow gButtonLow ys w60 h23 , Low
ButtonLow_TT := "Sets the Low preset.`nThis preset should be used by people who have a slow computer and struggle to get 24fps on medium."
Gui, Add, Button, vButtonMedium gButtonMedium ys w60 h23 , Medium
ButtonMedium_TT := "Sets the Medium preset.`nThis preset should be used by people who have an average computer and struggle to get 24fps on high,`nor who prefer getting better than 40fps on high."
Gui, Add, Button, vButtonHigh gButtonHigh ys w60 h23 , High
ButtonHigh_TT := "Sets the High preset.`nThis preset should be used by most gamers who have fast computers, or who`ndo not enjoy the sudden framedrops that can be experienced on ultra."
Gui, Add, Button, vButtonUltra gButtonUltra ys w60 h23 , Ultra
ButtonUltra_TT := "Sets the Ultra preset.`nThis preset should be used by most gamers who have very fast computers,`nwho enjoy taking screenshots with full detail, and who do not mind`nhaving a few sudden framedrops due to rendering most things at their`nmaximum draw distance."
Gui, Add, Button, vButtonDefault gButtonDefault ys w88 h23 , Default
ButtonDefault_TT := "Resets the INIs to their default values."
Gui, Add, Radio, vVanillaPresets gVanillaPresets xs Section, Vanilla Presets
VanillaPresets_TT := "Changes the preset buttons to use the vanilla presets."
Gui, Add, Radio, vBethINIPresets gBethINIPresets ys Checked, %shortName% Presets
BethINIPresets_TT := "Changes the preset buttons to use the " . shortName . " presets.`nHint: These presets are better!"
Gui, Add, Checkbox, vRecommendedTweaks gRecommendedTweaks ys , Recommended Tweaks
RecommendedTweaks_TT := "Toggles tweaks recommended for all users. You do not need to select a preset for this to work."


if gameName = Skyrim
	{
		Gui, Add, Checkbox, vMaintainENBCompatibility gMaintainENBCompatibility xs ys+32 Section , ENB Mode
		MaintainENBCompatibility_TT := "If you use ENB, check this! Ensures all settings required for ENB to work correctly are maintained."
	}
if gameName = Fallout 4
	{	
		Gui, Add, Checkbox, vbInvalidateOlderFiles gbInvalidateOlderFiles xs ys+32 Section , Load Loose Files
		bInvalidateOlderFiles_TT := "This allows existing loose files to be used instead of the vanilla archived versions.`n`n[Archive]`nbInvalidateOlderFiles`nsResourceDataDirsFinal"
		if (getSettingValue("Archive", "bInvalidateOlderFiles", blank, "0") = 1) and (getSettingValue("Archive", "sResourceDataDirsFinal", blank, "STRINGS\") = blank)
			bInvalidateOlderFiles = 1
		else
			bInvalidateOlderFiles = 0
		GuiControl, Main:, bInvalidateOlderFiles, %bInvalidateOlderFiles%
	}
if (gameName = "Fallout 4" or gameName = "Skyrim")
	{
		Gui, Add, Checkbox, vbEnableFileSelection gEnableFileSelection ys , Enable File Selection
		bEnableFileSelection_TT := "Toggles the ability of the game launcher to support mod plugins.`n`n[Launcher]`nbEnableFileSelection"
		bEnableFileSelection := getSettingValue("Launcher", "bEnableFileSelection", Prefs, "0")
		GuiControl, Main:, bEnableFileSelection, %bEnableFileSelection%
	}
if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		Gui, Add, Checkbox, vbEnableFileSelection gEnableFileSelection xs ys+32 Section , Enable File Selection
		bEnableFileSelection_TT := "Toggles the ability of the game launcher to support mod plugins.`n`n[Launcher]`nbEnableFileSelection"
		bEnableFileSelection := getSettingValue("Launcher", "bEnableFileSelection", Prefs, "0")
		GuiControl, Main:, bEnableFileSelection, %bEnableFileSelection%
	}

Gui, Add, Button, vButtonSaveandExit gButtonSaveandExit x327 y275 w150 h23 , Save and Exit
ButtonSaveandExit_TT := "Exits, saving changes, sorting the INI files, and removing obsolete settings."
Gui, Add, Button, vButtonCancel gButtonCancel w150 h23 , Cancel
ButtonCancel_TT := "Exits, giving the option to either save changes or revert back to how the INIs were before launching the app."

Gui, Tab, 3

if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition" or gameName = "Fallout New Vegas" or gameName = "Oblivion") 
	{
		Gui, Add, Checkbox, vsIntroSequence gsIntroSequence Section, Intro Logos
		if gameName != Fallout New Vegas
			sIntroSequence_TT := "Toggles the game intro logos.`n`n[General]`nsIntroSequence"
		else
			sIntroSequence_TT := "Toggles the game intro logos.`n`n[General]`nSMainMenuMovieIntro"
		if gameName = Skyrim
			{
				sIntroSequence := getSettingValue("General", "sIntroSequence", blank, "BGS_LOGO.BIK")
				if sIntroSequence != BGS_LOGO.BIK
					sIntroSequence = 0
				else
					sIntroSequence = 1
			}
		else if gameName = Skyrim Special Edition
			{
				sIntroSequence := getSettingValue("General", "sIntroSequence", blank, "BGS_Logo.bik")
				if sIntroSequence != BGS_Logo.bik
					sIntroSequence = 0
				else
					sIntroSequence = 1
			}
		else if gameName = Oblivion
			{
				sIntroSequence := getSettingValue("General", "sIntroSequence", blank, "bethesda softworks HD720p.bik,2k games.bik,game studios.bik,Oblivion Legal.bik") . getSettingValue("General", "sMainMenuMovieIntro", blank, "Oblivion iv logo.bik")
				if sIntroSequence =
					sIntroSequence = 0
				else
					sIntroSequence = 1
			}
		else if gameName = Fallout New Vegas
			{
			SMainMenuMovieIntro=0
				sIntroSequence := getSettingValue("General", "SMainMenuMovieIntro", blank)
				if sIntroSequence =
					sIntroSequence = 1
				else
					sIntroSequence = 0
			}
		else if gameName = Fallout 4
			{
				sIntroSequence := getSettingValue("General", "sIntroSequence", blank, "GameIntro_V3_B.bk2")
				if sIntroSequence != GameIntro_V3_B.bk2
					sIntroSequence = 0
				else
					sIntroSequence = 1
			}
		GuiControl, Main:, sIntroSequence, %sIntroSequence%
	}
if gameName = Fallout 4
	{
		Gui, Add, Checkbox, vSPECIAL gSPECIAL x+m, Intro S.P.E.C.I.A.L.
		SPECIAL_TT := "Toggles the Vault-Tec ""What Makes You S.P.E.C.I.A.L."" videos.`n`n[General]`nfChancesToPlayAlternateIntro`nuMainMenuDelayBeforeAllowSkip"
		if (getSettingValue("General", "fChancesToPlayAlternateIntro", blank, "0.2") = 0) and (getSettingValue("General", "uMainMenuDelayBeforeAllowSkip", blank, "5000") != 5000)
			SPECIAL = 0
		else
			SPECIAL = 1
		GuiControl, Main:, SPECIAL, %SPECIAL%
	}

if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Oblivion")
	{
		if gameName = Fallout 3
			Gui, Add, Checkbox, vDisableScreenshots gDisableScreenshots Section, Disable Screenshots
		else
			Gui, Add, Checkbox, vDisableScreenshots gDisableScreenshots xs, Disable Screenshots
		if gameName = Fallout 4
			DisableScreenshots_TT := "Toggles the ability to save screenshots natively with the PrintScreen key.`n`n[Display]`nbScreenshotToFile"
		else
			DisableScreenshots_TT := "Toggles the ability to save screenshots natively with the PrintScreen key.`n`n[Display]`nbAllowScreenShot"
		if gameName = Fallout 4
			DisableScreenshots := Abs(getSettingValue("Display", "bScreenshotToFile", blank, "1") - 1)
		else if gameName = Fallout New Vegas
			DisableScreenshots := Abs(getSettingValue("Display", "bAllowScreenShot", blank, "1") - 1)
		else
			DisableScreenshots := Abs(getSettingValue("Display", "bAllowScreenShot", blank, "0") - 1)
		GuiControl, Main:, DisableScreenshots, %DisableScreenshots%
	}
	
Gui, Add, Text, , Screenshots Directory
Gui, Add, ComboBox, vsScreenShotBaseName gsScreenShotBaseName x+m yp-3 w435  Right,
sScreenShotBaseName_TT := "Sets the location of game screenshots. You can manually type in or copy and paste`na value. However, the folder MUST exist already, and it MUST be followed by a ""\"".`n`n[Display]`nsScreenShotBaseName"
Gui, Add, Text, x+m yp+3, Filename
Gui, Add, Edit, vsScreenShotBaseNameFileName gsScreenShotBaseName x+m yp-3 w100,
sScreenShotBaseNameFileName_TT := "Sets the base filename of game screenshots.`n`n[Display]`nsScreenShotBaseName"
sScreenShotBaseName := getSettingValue("Display", "sScreenShotBaseName", blank, "ScreenShot")
SplitPath, sScreenShotBaseName, sScreenShotBaseNameFileName, sScreenShotBaseName
if sScreenShotBaseName =
	sScreenShotBaseName = %gameFolder%
else
	sScreenShotBaseName .= "\"
GuiControl, Main:, sScreenShotBaseName, %sScreenShotBaseName%||Browse...
GuiControl, Main:, sScreenShotBaseNameFileName, %sScreenShotBaseNameFileName%

Gui, Add, Text, x+m yp+3, Index
Gui, Add, Edit, viScreenShotIndex giScreenShotIndex x+m yp-3 w30 Number,
iScreenShotIndex_TT := "Sets the screenshot index number.`n`n[Display]`niScreenShotIndex"
iScreenShotIndex := getSettingValue("Display", "iScreenShotIndex", Prefs, "0")
GuiControl, Main:, iScreenShotIndex, %iScreenShotIndex%
	
if (gameName = "Skyrim" or gameName = "Fallout 4")
	{
		Gui, Add, Checkbox, vDisableTutorials gDisableTutorials xs, Disable Tutorials
		DisableTutorials_TT := "Toggles the in-game tutorial pop-ups.`n`n[Interface]`nbShowTutorials"
		DisableTutorials := Abs(getSettingValue("Interface", "bShowTutorials", blank, "1") - 1)
		GuiControl, Main:, DisableTutorials, %DisableTutorials%
	}
if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vModdersParadiseMode gModdersParadiseMode xs, Modder's Paradise Mode
		ModdersParadiseMode_TT := "Toggles Modder's Paradise Mode (shows markers for objects and their bounds like seen in the Creation Kit).`n`n[Display]`nbShowMarkers"
		ModdersParadiseMode := getSettingValue("Display", "bShowMarkers", blank, "0")
		GuiControl, Main:, ModdersParadiseMode, %ModdersParadiseMode%
		
		Gui, Add, Text, , Max Autosaves
		Gui, Add, Edit, viAutoSaveCount giAutoSaveCount x+m yp-3 w24 Number,
		iAutoSaveCount_TT := "Sets the maximum number of autosaves to keep.`n`n[SaveGame]`niAutoSaveCount"
		iAutoSaveCount := getSettingValue("SaveGame", "iAutoSaveCount", blank, "3")
		GuiControl, Main:, iAutoSaveCount, %iAutoSaveCount%
	}

Gui, Add, GroupBox, xs w270 r5 , Sound
if gameName = Oblivion
	{
		Gui, Add, Checkbox, vbMusicEnabled gbMusicEnabled xp+9 yp+20 Section, Music
		bMusicEnabled_TT := "Toggles all game music. Disabling music could possibly improve performance at the expense of music.`n`n[Audio]`nbMusicEnabled"
		bMusicEnabled := getSettingValue("Audio", "bMusicEnabled", blank, "1")
		GuiControl, Main:, bMusicEnabled, %bMusicEnabled%
		Gui, Add, Checkbox, vIntroMusic gIntroMusic x+m, Intro Music
	}
else
	Gui, Add, Checkbox, vIntroMusic gIntroMusic xp+9 yp+20 Section, Intro Music

if gameName = Fallout 4
	{
		IntroMusic_TT := "Toggles the game intro music.`n`n[General]`nbPlayMainMenuMusic"
		IntroMusic := getSettingValue("General", "bPlayMainMenuMusic", blank, "1")
	}
else if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		IntroMusic_TT := "Toggles the game intro music.`n`n[General]`nsMainMenuMusic"
		if getSettingValue("General", "sMainMenuMusic", blank, "\Data\Music\Special\MUS_MainTheme.xwm") = blank
			IntroMusic = 0
		else
			IntroMusic = 1
	}
else
	{
		IntroMusic_TT := "Toggles the game intro music.`n`n[Audio]`nfMainMenuMusicVolume"
		if getSettingValue("Audio", "fMainMenuMusicVolume", blank, "0.6") = 0
			IntroMusic = 0
		else
			IntroMusic = 1
	}
GuiControl, Main:, IntroMusic, %IntroMusic%

if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Oblivion")
	{
		Gui, Add, Text, xs, Max Footstep Distance
		Gui, Add, ComboBox, vfMaxFootstepDistance gfMaxFootstepDistance x+m yp-3 w60 Right,
		fMaxFootstepDistance_TT := "Sets the maximum distance that footsteps can be heard.`n`n[Audio]`nfMaxFootstepDistance"
		fMaxFootstepDistance := sortNumberedList("512|1024|2048|3072|4096", Round(getSettingValue("Audio", "fMaxFootstepDistance", blank, "1100"),0))
		GuiControl, Main:, fMaxFootstepDistance, %fMaxFootstepDistance%
		
		Gui, Add, Text, xs, Player Footsteps
		Gui, Add, Slider, vfPlayerFootVolume gfPlayerFootVolume x+m w80 h20 Range0-100 TickInterval10,
		Gui, Add, Edit, vfPlayerFootVolumeReal gfPlayerFootVolumeReal x+m yp-3 w40 Number,
		fPlayerFootVolume_TT := "Sets the volume of the player's footsteps.`n`n[Audio]`nfPlayerFootVolume"
		fPlayerFootVolumeReal_TT := "Sets the volume of the player's footsteps.`n`n[Audio]`nfPlayerFootVolume"
		fPlayerFootVolume := Round(getSettingValue("Audio", "fPlayerFootVolume", blank, "0.9"),2) * 100
		fPlayerFootVolumeReal := Round(getSettingValue("Audio", "fPlayerFootVolume", blank, "0.9"),2)
		GuiControl, Main:, fPlayerFootVolume, %fPlayerFootVolume%
		GuiControl, Main:, fPlayerFootVolumeReal, %fPlayerFootVolumeReal%
	}

if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, GroupBox, ys-20 xs+280 w330 r5 , Papyrus
		Gui, Add, Checkbox, vEnableLogging gEnableLogging xp+9 yp+20 Section, Logging
		EnableLogging_TT := "Toggles Papyrus logs being written to disk.`n`n[Papyrus]`nbEnableLogging"
		EnableLogging := getSettingValue("Papyrus", "bEnableLogging", blank, "0")
		GuiControl, Main:, EnableLogging, %EnableLogging%
		
		Gui, Add, Checkbox, vLoadDebugInformation gLoadDebugInformation , Debug Info
		LoadDebugInformation_TT := "Toggles additional debug information.`nIf enabled, line number information will be available in error traces at the expense of higher memory usage.`n`n[Papyrus]`nbLoadDebugInformation"
		LoadDebugInformation := getSettingValue("Papyrus", "bLoadDebugInformation", blank, "0")
		Gui, Add, Checkbox, vbBackgroundLoadVMData gbBackgroundLoadVMData , Background Load Scripting VM
		bBackgroundLoadVMData_TT := "Toggles loading the scripting data in the VM in the background.`nMay improve performance, but there is currently no data.`nSkyrim and Skyrim Special Edition defaults it to off, while Fallout 4 defaults it to on.`n`n[General]`nbBackgroundLoadVMData"
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			bBackgroundLoadVMData := getSettingValue("General", "bBackgroundLoadVMData", blank, "0")
		else if gameName = Fallout 4
			bBackgroundLoadVMData := getSettingValue("General", "bBackgroundLoadVMData", blank, "1")
		GuiControl, Main:, bBackgroundLoadVMData, %bBackgroundLoadVMData%
		
		Gui, Add, Checkbox, vEnableProfiling gEnableProfiling ys , Profiling
		EnableProfiling_TT := "Toggles script profiling, which enables profiling commands and allows profiling information to be logged,`nat the cost of some script performance.`n`n[Papyrus]`nbEnableProfiling"
		EnableProfiling := getSettingValue("Papyrus", "bEnableProfiling", blank, "0")
		GuiControl, Main:, EnableProfiling, %EnableProfiling%
		Gui, Add, Checkbox, vEnableTrace gEnableTrace , Tracing
		EnableTrace_TT := "Toggles script tracing.`n`n[Papyrus]`nbEnableTrace"
		EnableTrace := getSettingValue("Papyrus", "bEnableTrace", blank, "0")
		GuiControl, Main:, EnableTrace, %EnableTrace%
		Gui, Add, Text, xs ys+60 Section, Post-Load Update Time
		Gui, Add, ComboBox, vPostLoadUpdateTimeMS gPostLoadUpdateTimeMS ys-3,
		PostLoadUpdateTimeMS_TT := "Sets time, in milliseconds, given to scripts during loading.`n`n[Papyrus]`nfPostLoadUpdateTimeMS"
		if gameName = Fallout 4
			PostLoadUpdateTimeMS := sortNumberedList("500|2000", Round(getSettingValue("Papyrus", "fPostLoadUpdateTimeMS", blank, "500"),0))
		else
			PostLoadUpdateTimeMS := sortNumberedList("500|2000", Round(getSettingValue("Papyrus", "fPostLoadUpdateTimeMS", blank, "2000"),0))
		GuiControl, Main:, PostLoadUpdateTimeMS, %PostLoadUpdateTimeMS%
	}


Gui, Tab, 4

Gui, Add, Checkbox, vbBorderRegionsEnabled gbBorderRegionsEnabled Section, Remove Borders
bBorderRegionsEnabled_TT := "If enabled, the borders at the edges of the map shall be removed.`n`n[General]`nbBorderRegionsEnabled"
bBorderRegionsEnabled := Abs(getSettingValue("General", "bBorderRegionsEnabled", blank, "1") - 1)
GuiControl, Main:, bBorderRegionsEnabled, %bBorderRegionsEnabled%

if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vAlwaysRunbyDefault gAlwaysRunbyDefault , Always Run by Default
		AlwaysRunbyDefault_TT := "Toggles the ability of the character to always run by default.`nIf turned off, you can still run, but walking is the default action.`n`n[Controls]`nbAlwaysRunByDefault"
		if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
			AlwaysRunbyDefault := getSettingValue("Controls", "bAlwaysRunByDefault", Prefs, "1")
		else if gameName = Fallout 3
			AlwaysRunbyDefault := getSettingValue("Controls", "bAlwaysRunByDefault", blank, "0")
		else if gameName = Fallout New Vegas
			AlwaysRunbyDefault := getSettingValue("Controls", "bAlwaysRunByDefault", blank, "0")
		GuiControl, Main:, AlwaysRunbyDefault, %AlwaysRunbyDefault%
	}
if gameName = Oblivion
	{
		Gui, Add, Checkbox, vbInstantLevelUp gbInstantLevelUp , Instant Level Up
		bInstantLevelUp_TT := "If enabled, you will no longer be required to rest prior to leveling up.`n`n[GamePlay]`nbInstantLevelUp"
		bInstantLevelUp := getSettingValue("GamePlay", "bInstantLevelUp", blank, "0")
		GuiControl, Main:, bInstantLevelUp, %bInstantLevelUp%
		
		Gui, Add, Text, , Time Speed
		Gui, Add, Edit, vfGlobalTimeMultiplier gfGlobalTimeMultiplier x+m yp-3 w30,
		fGlobalTimeMultiplier_TT := "Sets the speed of time.`n`n[General]`nfGlobalTimeMultiplier"
		fGlobalTimeMultiplier := Round(getSettingValue("General", "fGlobalTimeMultiplier", blank, "1"),1)
		GuiControl, Main:, fGlobalTimeMultiplier, %fGlobalTimeMultiplier%
	}
if gameName = Fallout 4
	{
		Gui, Add, Checkbox, vfPlayerDisableSprintingLoadingCellDistance gfPlayerDisableSprintingLoadingCellDistance , Sprint Fix
		fPlayerDisableSprintingLoadingCellDistance_TT := "If enabled, sprinting will be allowed even when nearby cells are not fully loaded.`n`n[GamePlay]`nfPlayerDisableSprintingLoadingCellDistance"
		fPlayerDisableSprintingLoadingCellDistance := 0
		if getSettingValue("GamePlay", "fPlayerDisableSprintingLoadingCellDistance", blank, "4096") = 0
			fPlayerDisableSprintingLoadingCellDistance := 1
		GuiControl, Main:, fPlayerDisableSprintingLoadingCellDistance, %fPlayerDisableSprintingLoadingCellDistance%
	}
if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Text, , Over-Encumbered Reminder
		Gui, Add, ComboBox, vfEncumberedReminderTimer gfEncumberedReminderTimer x+m yp-3 w60  Right,
		fEncumberedReminderTimer_TT := "Sets the time interval between subsequent ""You are carrying too much to be able to run"" messages in seconds.`n`n[General]`nfEncumberedReminderTimer"
		fEncumberedReminderTimer := sortNumberedList("30|60|300|3600", Round(getSettingValue("General", "fEncumberedReminderTimer", blank, "30"),0))
		GuiControl, Main:, fEncumberedReminderTimer, %fEncumberedReminderTimer%
	}


if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, GroupBox, ys r6 w280 Section, Combat
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			{
				Gui, Add, Text, xp+9 yp+20 Section, 1st Person Arrow Tilt-up Angle
				Gui, Add, Text, , 3rd Person Arrow Tilt-up Angle
				Gui, Add, Text, , 1st Person Bolt Tilt-up Angle
				
				Gui, Add, Edit, vf1PArrowTiltUpAngle gf1PArrowTiltUpAngle ys-3 w40 h20 Right,
				f1PArrowTiltUpAngle_TT := "Sets the upward tilt angle of arrows in first-person view.`n`n[Combat]`nf1PArrowTiltUpAngle"
				f1PArrowTiltUpAngle := getSettingValue("Combat", "f1PArrowTiltUpAngle", blank, "2")
				GuiControl, Main:, f1PArrowTiltUpAngle, %f1PArrowTiltUpAngle%
				Gui, Add, Edit, vf3PArrowTiltUpAngle gf3PArrowTiltUpAngle w40 h20 Right,
				f3PArrowTiltUpAngle_TT := "Sets the upward tilt angle of arrows in 3rd-person view.`n`n[Combat]`nf3PArrowTiltUpAngle"
				f3PArrowTiltUpAngle := getSettingValue("Combat", "f3PArrowTiltUpAngle", blank, "2.5")
				GuiControl, Main:, f3PArrowTiltUpAngle, %f3PArrowTiltUpAngle%
				Gui, Add, Edit, vf1PBoltTiltUpAngle gf1PBoltTiltUpAngle w40 h20 Right,
				f1PBoltTiltUpAngle_TT := "Sets the upward tilt angle of crossbow bolts in first-person view.`n`n[Combat]`nf1PBoltTiltUpAngle"
				f1PBoltTiltUpAngle := getSettingValue("Combat", "f1PBoltTiltUpAngle", blank, "1")
				GuiControl, Main:, f1PBoltTiltUpAngle, %f1PBoltTiltUpAngle%
				Gui, Add, Checkbox, vbForceNPCsUseAmmo gbForceNPCsUseAmmo xs Section, NPCs Use Ammo
			}
		else
			Gui, Add, Checkbox, vbForceNPCsUseAmmo gbForceNPCsUseAmmo xp+9 yp+20 Section, NPCs Use Ammo
		bForceNPCsUseAmmo_TT := "If enabled, NPCs will no longer have access to unlimited ammo, but shall be forced to only use the ammo they possess.`n`n[Combat]`nbForceNPCsUseAmmo"
		bForceNPCsUseAmmo := getSettingValue("Combat", "bForceNPCsUseAmmo", blank, "0")
		GuiControl, Main:, bForceNPCsUseAmmo, %bForceNPCsUseAmmo%
		Gui, Add, Checkbox, vbDisableCombatDialogue gbDisableCombatDialogue , Disable Combat Dialogue
		bDisableCombatDialogue_TT := "Disables those cheeky comments that enemies say while in combat.`n`n[Combat]`nbDisableCombatDialogue"
		bDisableCombatDialogue := getSettingValue("Combat", "bDisableCombatDialogue", blank, "0")
		GuiControl, Main:, bDisableCombatDialogue, %bDisableCombatDialogue%
	}
	


Gui, Tab, 5
Gui, Add, Checkbox, vbDialogueSubtitles gbDialogueSubtitles Section, Dialogue Subtitles
if (gameName = "Oblivion" or gameName = "Fallout New Vegas" or gameName = "Fallout 3")
	{
		bDialogueSubtitles_TT := "Toggles subtitles for NPCs who are directly talking to you.`n`n[GamePlay]`nbDialogueSubtitles"
		bDialogueSubtitles := getSettingValue("GamePlay", "bDialogueSubtitles", Prefs, "1")
	}
else
	{
		bDialogueSubtitles_TT := "Toggles subtitles for NPCs who are directly talking to you.`n`n[Interface]`nbDialogueSubtitles"
		bDialogueSubtitles := getSettingValue("Interface", "bDialogueSubtitles", Prefs, "0")
	}
GuiControl, Main:, bDialogueSubtitles, %bDialogueSubtitles%

Gui, Add, Checkbox, vbGeneralSubtitles gbGeneralSubtitles , General Subtitles
if (gameName = "Oblivion" or gameName = "Fallout New Vegas" or gameName = "Fallout 3")
	bGeneralSubtitles_TT := "Toggles subtitles for NPCs who are not directly talking to you.`n`n[GamePlay]`nbGeneralSubtitles"
else
	bGeneralSubtitles_TT := "Toggles subtitles for NPCs who are not directly talking to you.`n`n[Interface]`nbGeneralSubtitles"
if (gameName = "Fallout New Vegas" or gameName = "Fallout 3")
	bGeneralSubtitles := getSettingValue("GamePlay", "bGeneralSubtitles", Prefs, "0")
else if gameName = Oblivion
	bGeneralSubtitles := getSettingValue("GamePlay", "bGeneralSubtitles", blank, "1")
else
	bGeneralSubtitles := getSettingValue("Interface", "bGeneralSubtitles", Prefs, "0")
GuiControl, Main:, bGeneralSubtitles, %bGeneralSubtitles%

if (gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vbEnablePlatform gbEnablePlatform , Bethesda Modding Platform
		if gameName = Fallout 4
			bEnablePlatform_TT := "Toggles Bethesda's built-in modding platform, including the Creation Club. If disabled, removes ""Mods"" from the menus, grays out the Creation Club, and removes Creation Club news.`n`n[Bethesda.net]`nbEnablePlatform"
		else
			bEnablePlatform_TT := "Toggles Bethesda's built-in modding platform. If disabled, Creation Club news will no longer appear, but the ""Mods"" and ""Creation Club"" buttons will still be active, albeit probably broken.`n`n[Bethesda.net]`nbEnablePlatform"
		bEnablePlatform := getSettingValue("Bethesda.net", "bEnablePlatform", blank, "1")
		GuiControl, Main:, bEnablePlatform, %bEnablePlatform%
	}
if (gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vbModManagerMenuEnabled gbModManagerMenuEnabled , Mod Manager Menu
		bModManagerMenuEnabled_TT := "Toggles the ""Mods"" menu item in the in-game system menu.`n`n[General]`nbModManagerMenuEnabled"
		bModManagerMenuEnabled := getSettingValue("General", "bModManagerMenuEnabled", blank, "1")
		GuiControl, Main:, bModManagerMenuEnabled, %bModManagerMenuEnabled%
	}
if gameName = Fallout 4
	{
		Gui, Add, Checkbox, vbAutoSizeQuickContainer gbAutoSizeQuickContainer , Autosize Quick Containers
		bAutoSizeQuickContainer_TT := "Toggles the ability for the quick-loot box to expand or contract with the size of its contents when hovering over containers.`n`n[Interface]`nbAutoSizeQuickContainer"
		bAutoSizeQuickContainer := getSettingValue("Interface", "bAutoSizeQuickContainer", blank, "0")
		GuiControl, Main:, bAutoSizeQuickContainer, %bAutoSizeQuickContainer%
	}
if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vShowQuestMarkers gShowQuestMarkers , Show Quest Markers
		ShowQuestMarkers_TT := "Toggles quest markers on the map and the compass.`n`n[GamePlay]`nbShowQuestMarkers"
		ShowQuestMarkers := getSettingValue("GamePlay", "bShowQuestMarkers", Prefs, "1")
		GuiControl, Main:, ShowQuestMarkers, %ShowQuestMarkers%
	}
if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vShowCompass gShowCompass , Show Compass
		ShowCompass_TT := "Toggles the compass.`n`n[Interface]`nbShowCompass"
		ShowCompass := getSettingValue("Interface", "bShowCompass", Prefs, "1")
		GuiControl, Main:, ShowCompass, %ShowCompass%
	}

if (gameName = "Oblivion" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		Gui, Add, Checkbox, vbUseJoystick gbUseJoystick, Use Joystick
		bUseJoystick_TT := "Toggles the use of a Joystick with the game. Disable this if you don't use one.`n`n[Controls]`nbUseJoystick"
		bUseJoystick := getSettingValue("Controls", "bUse Joystick", blank, "1")
		GuiControl, Main:, bUseJoystick, %bUseJoystick%
	}
if gameName = Fallout 4
	Gui, Add, GroupBox, ys w360 r11.5 , Colors
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	Gui, Add, GroupBox, ys w360 r1.5 , Colors
if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	Gui, Add, GroupBox, ys w225 r2.5 , Colors
;xp+9 yp+20
if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		Gui, Add, Text, xp+9 yp+20 Section w50 +Right, HUD
		Gui, Add, Progress, x+m yp-4 h21 w130 vuHUDColorProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans vuHUDColorText ,
		Gui, Add, Button, vuHUDColor guHUDColor x+0 yp-5, <
		uHUDColor_TT := "Sets the color of the Heads Up Display.`n`n[Interface]`nuHUDColor"
		uHUDColor := getSettingValue("Interface", "uHUDColor", Prefs, "4290134783")
		uHUDColorProgress := SubStr(Format("{1:02X}", uHUDColor),1,6)
		GuiControl, Main:+Background%uHUDColorProgress%, uHUDColorProgress
		uHUDColorText := uHUDColor
		GuiControl, Main:, uHUDColorText, %uHUDColorText%
		
		Gui, Add, Text, xs w50 +Right, Pipboy
		Gui, Add, Progress, x+m yp-4 h21 w130 vuPipboyColorProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans vuPipboyColorText ,
		Gui, Add, Button, vuPipboyColor guPipboyColor x+0 yp-5, <
		uPipboyColor_TT := "Sets the color of the Pipboy.`n`n[Interface]`nuPipboyColor"
		uPipboyColor := getSettingValue("Interface", "uPipboyColor", Prefs, "4290134783")
		uPipboyColorProgress := SubStr(Format("{1:02X}", uPipboyColor),1,6)
		GuiControl, Main:+Background%uPipboyColorProgress%, uPipboyColorProgress
		uPipboyColorText := uPipboyColor
		GuiControl, Main:, uPipboyColorText, %uPipboyColorText%
	}
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Text, xp+9 yp+20 Section w185 +Right, Subtitle Speaker Name
		Gui, Add, Progress, x+m yp-4 h21 w130 viSubtitleSpeakerNameColorProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans viSubtitleSpeakerNameColorText ,
		Gui, Add, Button, viSubtitleSpeakerNameColor giSubtitleSpeakerNameColor x+0 yp-5, <
		iSubtitleSpeakerNameColor_TT := "Sets the subtitle text color of the name of the person speaking.`n`n[Interface]`niSubtitleSpeakerNameColor"
		iSubtitleSpeakerNameColor := getSettingValue("Interface", "iSubtitleSpeakerNameColor", blank, "8947848")
		iSubtitleSpeakerNameColorProgress := Format("{1:02X}", iSubtitleSpeakerNameColor)
		GuiControl, Main:+Background%iSubtitleSpeakerNameColorProgress%, iSubtitleSpeakerNameColorProgress
		iSubtitleSpeakerNameColorText := iSubtitleSpeakerNameColor
		GuiControl, Main:, iSubtitleSpeakerNameColorText, %iSubtitleSpeakerNameColorText%
	}
if (gameName = "Fallout 4")
	{
		Gui, Add, Text, xp+9 yp+20 Section w185 +Right, Subtitles
		Gui, Add, Progress, x+m yp-4 h21 w130 vuSubtitleProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans vuSubtitleText ,
		Gui, Add, Button, vuSubtitle guSubtitle x+0 yp-5, <
		uSubtitle_TT := "Sets the color of subtitles.`n`n[Interface]`nuSubtitleR`nuSubtitleG`nuSubtitleB"
		uSubtitle := getSettingValue("Interface", "uSubtitleR", blank, "187") . "," . getSettingValue("Interface", "uSubtitleG", blank, "187") . "," . getSettingValue("Interface", "uSubtitleB", blank, "187")
		uSubtitleArray := StrSplit(uSubtitle,",")
		uSubtitleProgress := Format("{1:02x}{2:02x}{3:02x}", uSubtitleArray[1], uSubtitleArray[2], uSubtitleArray[3])
		GuiControl, Main:+Background%uSubtitleProgress%, uSubtitleProgress
		GuiControl, Main:, uSubtitleText, %uSubtitle%
		
		Gui, Add, Text, xs w185 +Right, HUD
		Gui, Add, Progress, x+m yp-4 h21 w130 viHUDColorProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans viHUDColorText ,
		Gui, Add, Button, viHUDColor giHUDColor x+0 yp-5, <
		iHUDColor_TT := "Sets the color of the Heads Up Display.`n`n[Interface]`niHUDColorR`niHUDColorG`niHUDColorB"
		iHUDColor := getSettingValue("Interface", "iHUDColorR", Prefs, "18") . "," . getSettingValue("Interface", "iHUDColorG", Prefs, "255") . "," . getSettingValue("Interface", "iHUDColorB", Prefs, "21")
		iHUDColorArray := StrSplit(iHUDColor,",")
		iHUDColorProgress := Format("{1:02x}{2:02x}{3:02x}", iHUDColorArray[1], iHUDColorArray[2], iHUDColorArray[3])
		GuiControl, Main:+Background%iHUDColorProgress%, iHUDColorProgress
		GuiControl, Main:, iHUDColorText, %iHUDColor%
		
		Gui, Add, Text, xs w185 +Right, Damage HUD
		Gui, Add, Progress, x+m yp-4 h21 w130 viHUDColorWarningProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans viHUDColorWarningText ,
		Gui, Add, Button, viHUDColorWarning giHUDColorWarning x+0 yp-5, <
		iHUDColorWarning_TT := "Sets the color of damage-related HUD elements.`n`n[Interface]`niHUDColorWarningR`niHUDColorWarningG`niHUDColorWarningB"
		iHUDColorWarning := getSettingValue("Interface", "iHUDColorWarningR", blank, "238") . "," . getSettingValue("Interface", "iHUDColorWarningG", blank, "86") . "," . getSettingValue("Interface", "iHUDColorWarningB", blank, "55")
		iHUDColorWarningArray := StrSplit(iHUDColorWarning,",")
		iHUDColorWarningProgress := Format("{1:02x}{2:02x}{3:02x}", iHUDColorWarningArray[1], iHUDColorWarningArray[2], iHUDColorWarningArray[3])
		GuiControl, Main:+Background%iHUDColorWarningProgress%, iHUDColorWarningProgress
		GuiControl, Main:, iHUDColorWarningText, %iHUDColorWarning%
		
		/*
		Gui, Add, Text, xs w160 +Right, Warning Alt HUD
		Gui, Add, Progress, x+m yp-4 h21 w130 viHUDColorAltWarningProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans viHUDColorAltWarningText ,
		Gui, Add, Button, viHUDColorAltWarning giHUDColorAltWarning x+0 yp-5, <
		iHUDColorAltWarning_TT := "Sets the color damage-related HUD elements.`n`n[Interface]`niHUDColorAltWarningR`niHUDColorAltWarningG`niHUDColorAltWarningB"
		iHUDColorAltWarning := getSettingValue("Interface", "iHUDColorAltWarningR", blank, "238") . "," . getSettingValue("Interface", "iHUDColorAltWarningG", blank, "86") . "," . getSettingValue("Interface", "iHUDColorAltWarningB", blank, "55")
		iHUDColorAltWarningArray := StrSplit(iHUDColorAltWarning,",")
		iHUDColorAltWarningProgress := Format("{1:02x}{2:02x}{3:02x}", iHUDColorAltWarningArray[1], iHUDColorAltWarningArray[2], iHUDColorAltWarningArray[3])
		GuiControl, Main:+Background%iHUDColorAltWarningProgress%, iHUDColorAltWarningProgress
		GuiControl, Main:, iHUDColorAltWarningText, %iHUDColorAltWarning%
		*/
		
		Gui, Add, Text, xs w185 +Right, Pipboy
		Gui, Add, Progress, x+m yp-4 h21 w130 vfPipboyEffectColorProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans vfPipboyEffectColorText ,
		Gui, Add, Button, vfPipboyEffectColor gfPipboyEffectColor x+0 yp-5, <
		fPipboyEffectColor_TT := "Sets the Pipboy effects color.`n`n[Pipboy]`nfPipboyEffectColorR`nfPipboyEffectColorG`nfPipboyEffectColorB"
		fPipboyEffectColor := Round(255*getSettingValue("Pipboy", "fPipboyEffectColorR", Prefs, "0.08"),0) . "," . Round(255*getSettingValue("Pipboy", "fPipboyEffectColorG", Prefs, "1"),0) . "," . Round(255*getSettingValue("Pipboy", "fPipboyEffectColorB", Prefs, "0.09"),0)
		fPipboyEffectColorArray := StrSplit(fPipboyEffectColor,",")
		fPipboyEffectColorProgress := Format("{1:02x}{2:02x}{3:02x}", fPipboyEffectColorArray[1], fPipboyEffectColorArray[2], fPipboyEffectColorArray[3])
		GuiControl, Main:+Background%fPipboyEffectColorProgress%, fPipboyEffectColorProgress
		fPipboyEffectColorText := Round(fPipboyEffectColorArray[1]/255,3) . "," . Round(fPipboyEffectColorArray[2]/255,3) . "," . Round(fPipboyEffectColorArray[3]/255,3)
		GuiControl, Main:, fPipboyEffectColorText, %fPipboyEffectColorText%
		
		Gui, Add, Text, xs w185 +Right, Power Armor Pipboy
		Gui, Add, Progress, x+m yp-4 h21 w130 vfPAEffectColorProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans vfPAEffectColorText ,
		Gui, Add, Button, vfPAEffectColor gfPAEffectColor x+0 yp-5, <
		fPAEffectColor_TT := "Sets the color of Pipboy effects while wearing Power Armor.`n`n[Pipboy]`nfPAEffectColorR`nfPAEffectColorG`nfPAEffectColorB"
		fPAEffectColor := Round(255*getSettingValue("Pipboy", "fPAEffectColorR", blank, "1"),0) . "," . Round(255*getSettingValue("Pipboy", "fPAEffectColorG", blank, "0.82"),0) . "," . Round(255*getSettingValue("Pipboy", "fPAEffectColorB", blank, "0.41"),0)
		fPAEffectColorArray := StrSplit(fPAEffectColor,",")
		fPAEffectColorProgress := Format("{1:02x}{2:02x}{3:02x}", fPAEffectColorArray[1], fPAEffectColorArray[2], fPAEffectColorArray[3])
		GuiControl, Main:+Background%fPAEffectColorProgress%, fPAEffectColorProgress
		fPAEffectColorText := Round(fPAEffectColorArray[1]/255,3) . "," . Round(fPAEffectColorArray[2]/255,3) . "," . Round(fPAEffectColorArray[3]/255,3)
		GuiControl, Main:, fPAEffectColorText, %fPAEffectColorText%
		
		/*
		Gui, Add, Text, xs w185 +Right, Mod Menu Effect
		Gui, Add, Progress, x+m yp-4 h21 w130 vfModMenuEffectColorProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans vfModMenuEffectColorText ,
		Gui, Add, Button, vfModMenuEffectColor gfModMenuEffectColor x+0 yp-5, <
		fModMenuEffectColor_TT := "Sets the mod menu effects color (not sure what that is yet).`n`n[VATS]`nfModMenuEffectColorR`nfModMenuEffectColorG`nfModMenuEffectColorB"
		fModMenuEffectColor := Round(255*getSettingValue("VATS", "fModMenuEffectColorR", Prefs, "0.49"),0) . "," . Round(255*getSettingValue("VATS", "fModMenuEffectColorG", Prefs, "0.99"),0) . "," . Round(255*getSettingValue("VATS", "fModMenuEffectColorB", Prefs, "0.42"),0)
		fModMenuEffectColorArray := StrSplit(fModMenuEffectColor,",")
		fModMenuEffectColorProgress := Format("{1:02x}{2:02x}{3:02x}", fModMenuEffectColorArray[1], fModMenuEffectColorArray[2], fModMenuEffectColorArray[3])
		GuiControl, Main:+Background%fModMenuEffectColorProgress%, fModMenuEffectColorProgress
		fModMenuEffectColorText := Round(fModMenuEffectColorArray[1]/255,3) . "," . Round(fModMenuEffectColorArray[2]/255,3) . "," . Round(fModMenuEffectColorArray[3]/255,3)
		GuiControl, Main:, fModMenuEffectColorText, %fModMenuEffectColorText%
		*/
		
		Gui, Add, Text, xs w185 +Right, Item Highlight
		Gui, Add, Progress, x+m yp-4 h21 w130 vfModMenuEffectHighlightColorProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans vfModMenuEffectHighlightColorText ,
		Gui, Add, Button, vfModMenuEffectHighlightColor gfModMenuEffectHighlightColor x+0 yp-5, <
		fModMenuEffectHighlightColor_TT := "Sets the highlight color of items in menus.`n`n[VATS]`nfModMenuEffectHighlightColorR`nfModMenuEffectHighlightColorG`nfModMenuEffectHighlightColorB"
		fModMenuEffectHighlightColor := Round(255*getSettingValue("VATS", "fModMenuEffectHighlightColorR", Prefs, "0.0706"),0) . "," . Round(255*getSettingValue("VATS", "fModMenuEffectHighlightColorG", Prefs, "1"),0) . "," . Round(255*getSettingValue("VATS", "fModMenuEffectHighlightColorB", Prefs, "0.0824"),0)
		fModMenuEffectHighlightColorArray := StrSplit(fModMenuEffectHighlightColor,",")
		fModMenuEffectHighlightColorProgress := Format("{1:02x}{2:02x}{3:02x}", fModMenuEffectHighlightColorArray[1], fModMenuEffectHighlightColorArray[2], fModMenuEffectHighlightColorArray[3])
		GuiControl, Main:+Background%fModMenuEffectHighlightColorProgress%, fModMenuEffectHighlightColorProgress
		fModMenuEffectHighlightColorText := Round(fModMenuEffectHighlightColorArray[1]/255,3) . "," . Round(fModMenuEffectHighlightColorArray[2]/255,3) . "," . Round(fModMenuEffectHighlightColorArray[3]/255,3)
		GuiControl, Main:, fModMenuEffectHighlightColorText, %fModMenuEffectHighlightColorText%
		
		Gui, Add, Text, xs w185 +Right, Power Armor Item Highlight
		Gui, Add, Progress, x+m yp-4 h21 w130 vfModMenuEffectHighlightPAColorProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans vfModMenuEffectHighlightPAColorText ,
		Gui, Add, Button, vfModMenuEffectHighlightPAColor gfModMenuEffectHighlightPAColor x+0 yp-5, <
		fModMenuEffectHighlightPAColor_TT := "Sets the highlight color of items in menus while wearing Power Armor.`n`n[VATS]`nfModMenuEffectHighlightPAColorR`nfModMenuEffectHighlightPAColorG`nfModMenuEffectHighlightPAColorB"
		fModMenuEffectHighlightPAColor := Round(255*getSettingValue("VATS", "fModMenuEffectHighlightPAColorR", Prefs, "1"),0) . "," . Round(255*getSettingValue("VATS", "fModMenuEffectHighlightPAColorG", Prefs, "0.82"),0) . "," . Round(255*getSettingValue("VATS", "fModMenuEffectHighlightPAColorB", Prefs, "0.41"),0)
		fModMenuEffectHighlightPAColorArray := StrSplit(fModMenuEffectHighlightPAColor,",")
		fModMenuEffectHighlightPAColorProgress := Format("{1:02x}{2:02x}{3:02x}", fModMenuEffectHighlightPAColorArray[1], fModMenuEffectHighlightPAColorArray[2], fModMenuEffectHighlightPAColorArray[3])
		GuiControl, Main:+Background%fModMenuEffectHighlightPAColorProgress%, fModMenuEffectHighlightPAColorProgress
		fModMenuEffectHighlightPAColorText := Round(fModMenuEffectHighlightPAColorArray[1]/255,3) . "," . Round(fModMenuEffectHighlightPAColorArray[2]/255,3) . "," . Round(fModMenuEffectHighlightPAColorArray[3]/255,3)
		GuiControl, Main:, fModMenuEffectHighlightPAColorText, %fModMenuEffectHighlightPAColorText%
		
		Gui, Add, Text, xs w185 +Right, VATS Target Light
		Gui, Add, Progress, x+m yp-4 h21 w130 vfVatsLightColorProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans vfVatsLightColorText ,
		Gui, Add, Button, vfVatsLightColor gfVatsLightColor x+0 yp-5, <
		fVatsLightColor_TT := "Sets the VATS light color of highlighted targets.`n`n[VATS]`nfVatsLightColorR`nfVatsLightColorG`nfVatsLightColorB"
		fVatsLightColor := Round(255*getSettingValue("VATS", "fVatsLightColorR", blank, "0.7"),0) . "," . Round(255*getSettingValue("VATS", "fVatsLightColorG", blank, "0.7"),0) . "," . Round(255*getSettingValue("VATS", "fVatsLightColorB", blank, "0.7"),0)
		fVatsLightColorArray := StrSplit(fVatsLightColor,",")
		fVatsLightColorProgress := Format("{1:02x}{2:02x}{3:02x}", fVatsLightColorArray[1], fVatsLightColorArray[2], fVatsLightColorArray[3])
		GuiControl, Main:+Background%fVatsLightColorProgress%, fVatsLightColorProgress
		fVatsLightColorText := Round(fVatsLightColorArray[1]/255,3) . "," . Round(fVatsLightColorArray[2]/255,3) . "," . Round(fVatsLightColorArray[3]/255,3)
		GuiControl, Main:, fVatsLightColorText, %fVatsLightColorText%
		
		Gui, Add, Text, xs w185 +Right, Wire Connection Highlight
		Gui, Add, Progress, x+m yp-4 h21 w130 vfWireConnectEffectColorProgress
		Gui, Add, Text, xp yp+4 w130 +Center +BackgroundTrans vfWireConnectEffectColorText ,
		Gui, Add, Button, vfWireConnectEffectColor gfWireConnectEffectColor x+0 yp-5, <
		fWireConnectEffectColor_TT := "Sets the color of electrical objects that can be connected to wires`nwhen you try to attach wires in the workshop.`n`n[Workshop]`nfWireConnectEffectColorR`nfWireConnectEffectColorG`nfWireConnectEffectColorB"
		fWireConnectEffectColor := Round(255*getSettingValue("Workshop", "fWireConnectEffectColorR", blank, "0.8"),0) . "," . Round(255*getSettingValue("Workshop", "fWireConnectEffectColorG", blank, "0.8"),0) . "," . Round(255*getSettingValue("Workshop", "fWireConnectEffectColorB", blank, "0.9"),0)
		fWireConnectEffectColorArray := StrSplit(fWireConnectEffectColor,",")
		fWireConnectEffectColorProgress := Format("{1:02x}{2:02x}{3:02x}", fWireConnectEffectColorArray[1], fWireConnectEffectColorArray[2], fWireConnectEffectColorArray[3])
		GuiControl, Main:+Background%fWireConnectEffectColorProgress%, fWireConnectEffectColorProgress
		fWireConnectEffectColorText := Round(fWireConnectEffectColorArray[1]/255,3) . "," . Round(fWireConnectEffectColorArray[2]/255,3) . "," . Round(fWireConnectEffectColorArray[3]/255,3)
		GuiControl, Main:, fWireConnectEffectColorText, %fWireConnectEffectColorText%
	}


if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, GroupBox, w360 r2.2 yp+45 xs-9, Map Menu
		Gui, Add, Checkbox, vFixMapMenuNavigation gFixMapMenuNavigation xp+9 yp+20 , Fix Map Menu Navigation
		FixMapMenuNavigation_TT := "Unlocks the map menu navigation so that when the right mouse button is held,`nthe camera can move more freely.`n`n[MapMenu]`nfMapWorldYawRange`nfMapWorldMinPitch`nfMapWorldMaxPitch"
		FixMapMenuNavigation := getFixMapMenuNavigation(Round(getSettingValue("MapMenu", "fMapWorldYawRange", blank, "80"),0), Round(getSettingValue("MapMenu", "fMapWorldMinPitch", blank, "15"),0), Round(getSettingValue("MapMenu", "fMapWorldMaxPitch", blank, "75"),0))
		GuiControl, Main:, FixMapMenuNavigation, %FixMapMenuNavigation%
		Gui, Add, Checkbox, vRemoveMapMenuBlur gRemoveMapMenuBlur , Remove Map Menu Blur
		RemoveMapMenuBlur_TT := "Toggles blurring effects on the map menu.`n`n[MapMenu]`nbWorldMapNoSkyDepthBlur`nfWorldMapDepthBlurScale`nfWorldMapMaximumDepthBlur`nfWorldMapNearDepthBlurScale"
		RemoveMapMenuBlur := getRemoveMapMenuBlur(getSettingValue("MapMenu", "bWorldMapNoSkyDepthBlur", blank, "0"), getSettingValue("MapMenu", "fWorldMapDepthBlurScale", blank, "0.3000000119"), getSettingValue("MapMenu", "fWorldMapMaximumDepthBlur", blank, "0.4499999881"), getSettingValue("MapMenu", "fWorldMapNearDepthBlurScale", blank, "4"))
		GuiControl, Main:, RemoveMapMenuBlur, %RemoveMapMenuBlur%
	}



if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	Gui, Add, GroupBox, ys-20 w285 r7.3 , Mouse Settings
else if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	Gui, Add, GroupBox, ys-20 w285 r2.5 , Mouse Settings
else if gameName = Oblivion
	Gui, Add, GroupBox, ys w285 r2.5 , Mouse Settings
else
	Gui, Add, GroupBox, ys-20 w285 r6 , Mouse Settings
Gui, Add, Checkbox, vBackgroundMouse gBackgroundMouse xp+9 yp+20 , Background Mouse
BackgroundMouse_TT := "Allows the mouse to move using the default system speed.`nWhile generally too buggy for actual gameplay,`nit can be useful while tweaking ENB in-game settings.`n`n[Controls]`nbBackgroundMouse"
if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	BackgroundMouse := getSettingValue("Controls", "bBackgroundMouse", blank, "0")
else
	BackgroundMouse := getSettingValue("Controls", "bBackground Mouse", blank, "0")
GuiControl, Main:, BackgroundMouse, %BackgroundMouse%

Gui, Add, Text, Section w115, Lock Sensitivity
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	Gui, Add, Text, w115, Cursor Velocity
Gui, Add, Slider, vMouseHeadingSensitivity gMouseHeadingSensitivity ys w80 h20 Range1-10 TickInterval2,
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	Gui, Add, Slider, vMouseCursorSpeed gMouseCursorSpeed w80 h20 Range1-20 TickInterval3,
	
Gui, Add, Edit, vMouseHeadingSensitivityReal gMouseHeadingSensitivityReal ys-3 w50 ,
if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	{
		MouseHeadingSensitivity_TT := "Sets the Lock Sensitivity (how fast the camera moves in response to the mouse).`n`n[Controls]`nfMouseHeadingSensitivity"
		MouseHeadingSensitivityReal_TT := "Sets the Lock Sensitivity  (how fast the camera moves in response to the mouse).`n`n[Controls]`nfMouseHeadingSensitivity"
	}
else
	{
		MouseHeadingSensitivity_TT := "Sets the Lock Sensitivity (how fast the camera moves in response to the mouse).`n`n[Controls]`nfMouseSensitivity"
		MouseHeadingSensitivityReal_TT := "Sets the Lock Sensitivity  (how fast the camera moves in response to the mouse).`n`n[Controls]`nfMouseSensitivity"
	}
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		MouseHeadingSensitivity := Round(getSettingValue("Controls", "fMouseHeadingSensitivity", Prefs, "0.0125000002"),4) * 100
		MouseHeadingSensitivityReal := Round(getSettingValue("Controls", "fMouseHeadingSensitivity", Prefs, "0.0125000002"),4)
	}
else if gameName = Fallout 4
	{
		MouseHeadingSensitivity := Round(getSettingValue("Controls", "fMouseHeadingSensitivity", Prefs, "0.03"),4) * 100
		MouseHeadingSensitivityReal := Round(getSettingValue("Controls", "fMouseHeadingSensitivity", Prefs, "0.03"),4)
	}
else
	{
		MouseHeadingSensitivity := Round(getSettingValue("Controls", "fMouseSensitivity", Prefs, "0.002"),4) * 100
		MouseHeadingSensitivityReal := Round(getSettingValue("Controls", "fMouseSensitivity", Prefs, "0.002"),4)
	}
GuiControl, Main:, MouseHeadingSensitivity, %MouseHeadingSensitivity%
GuiControl, Main:, MouseHeadingSensitivityReal, %MouseHeadingSensitivityReal%

if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{		
		Gui, Add, Edit, vMouseCursorSpeedReal gMouseCursorSpeedReal w50,
		MouseCursorSpeed_TT := "Sets the velocity of the mouse cursor in menus, such as the inventory.`n`n[Interface]`nfMouseCursorSpeed"
		MouseCursorSpeedReal_TT := "Sets the velocity of the mouse cursor in menus, such as the inventory.`n`n[Interface]`nfMouseCursorSpeed"
		MouseCursorSpeed := Round(getSettingValue("Interface", "fMouseCursorSpeed", Prefs, "1"),2) * 10
		MouseCursorSpeedReal := Round(getSettingValue("Interface", "fMouseCursorSpeed", Prefs, "1"),2)
		GuiControl, Main:, MouseCursorSpeed, %MouseCursorSpeed%
		GuiControl, Main:, MouseCursorSpeedReal, %MouseCursorSpeedReal%
	}

if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Text, xs yp+35 w105 +Center, Scale
		Gui, Add, Text, x+13 w8, X
		Gui, Add, Edit, vMouseHeadingXScale gMouseHeadingXScale x+5 yp-3 w50,
		MouseHeadingXScale_TT := "Sets the mouse horizontal scale value (how much the camera moves when moving the mouse horizontally).`n`n[Controls]`nfMouseHeadingXScale"
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			MouseHeadingXScale := Round(getSettingValue("Controls", "fMouseHeadingXScale", blank, "0.0199999996"),4)
		else
			MouseHeadingXScale := Round(getSettingValue("Controls", "fMouseHeadingXScale", blank, "0.021"),4)
		GuiControl, Main:, MouseHeadingXScale, %MouseHeadingXScale%
		
		Gui, Add, Text, x+21 yp+3 w8, Y
		Gui, Add, Edit, vMouseHeadingYScale gMouseHeadingYScale x+5 yp-3 w50,
		MouseHeadingYScale_TT := "Sets the mouse vertical scale value (how much the camera moves when moving the mouse vertically).`n`n[Controls]`nfMouseHeadingYScale"
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			MouseHeadingYScale := Round(getSettingValue("Controls", "fMouseHeadingYScale", blank, "0.8500000238"),4)
		else
			MouseHeadingYScale := Round(getSettingValue("Controls", "fMouseHeadingYScale", blank, "0.021"),4)
		GuiControl, Main:, MouseHeadingYScale, %MouseHeadingYScale%

		
		Gui, Add, Text, xs yp+30 w205 +Right, Mouse Wheel Zoom Speed
		Gui, Add, Edit, vMouseZoomSpeed gMouseZoomSpeed x+m w50 yp-3,
		MouseZoomSpeed_TT := "Sets the transition speed when zooming in and out in third person mode.`nThis also affects how fast the transition from first to third person occurs.`n`n[Camera]`nfMouseWheelZoomSpeed"
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			MouseZoomSpeed := Round(getSettingValue("Camera", "fMouseWheelZoomSpeed", blank, "0.8000000119"),2)
		else if gameName = Fallout 4
			MouseZoomSpeed := Round(getSettingValue("Camera", "fMouseWheelZoomSpeed", blank, "3"),2)
		GuiControl, Main:, MouseZoomSpeed, %MouseZoomSpeed%
	}
Gui, Add, GroupBox, yp+45 xs-9 w285 r6.5 , Console
 if (gameName = "Oblivion" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		Gui, Add, Checkbox, xp+9 yp+20 Section vbAllowConsole gbAllowConsole, Enable
		bAllowConsole_TT := "Toggles the ability to open the in-game console by pressing the tilde ~ key.`n`n[Interface]`nbAllowConsole"
		bAllowConsole := getSettingValue("Interface", "bAllowConsole", blank, "1")
		GuiControl, Main:, bAllowConsole, %bAllowConsole%
		
		Gui, Add, Text, , Max Lines
		Gui, Add, Edit, viConsoleVisibleLines giConsoleVisibleLines x+m yp-3 w24 Number,
		iConsoleVisibleLines_TT := "Sets the maximum number of lines visible in the in-game console.`n`n[Menu]`niConsoleVisibleLines"
		iConsoleVisibleLines := getSettingValue("Menu", "iConsoleVisibleLines", blank, "15")
		GuiControl, Main:, iConsoleVisibleLines, %iConsoleVisibleLines%
	}
if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Text, xp+9 yp+20 Section w120 +Right, Screen Percentage
		Gui, Add, Edit, viConsoleSizeScreenPercent giConsoleSizeScreenPercent x+m yp-3 w24 Number,
		iConsoleSizeScreenPercent_TT := "Sets the percentage of the screen that the in-game console can fill.`n`n[Menu]`niConsoleSizeScreenPercent"
		iConsoleSizeScreenPercent := getSettingValue("Menu", "iConsoleSizeScreenPercent", blank, "40")
		GuiControl, Main:, iConsoleSizeScreenPercent, %iConsoleSizeScreenPercent%
		
		Gui, Add, Text, xs w120 +Right, Text Size
		Gui, Add, Edit, viConsoleTextSize giConsoleTextSize x+m yp-3 w24 Number,
		iConsoleTextSize_TT := "Sets the size for text in the in-game console.`n`n[Menu]`niConsoleTextSize"
		iConsoleTextSize := getSettingValue("Menu", "iConsoleTextSize", blank, "20")
		GuiControl, Main:, iConsoleTextSize, %iConsoleTextSize%

		Gui, Add, Text, xs w120 +Right, Text Input Color
		Gui, Add, Progress, x+m yp-4 h21 w90 vrConsoleTextColorProgress
		Gui, Add, Text, xp yp+4 w90 +Center +BackgroundTrans vrConsoleTextColorText ,
		Gui, Add, Button, vrConsoleTextColor grConsoleTextColor x+0 yp-5, <
		rConsoleTextColor_TT := "Sets the color of text typed into the console.`n`n[Menu]`nrConsoleTextColor"
		rConsoleTextColor := getSettingValue("Menu", "rConsoleTextColor", blank, "255,255,255")
		rConsoleTextColorArray := StrSplit(rConsoleTextColor,",")
		rConsoleTextColorProgress := Format("{1:02x}{2:02x}{3:02x}", rConsoleTextColorArray[1], rConsoleTextColorArray[2], rConsoleTextColorArray[3])
		GuiControl, Main:+Background%rConsoleTextColorProgress%, rConsoleTextColorProgress
		GuiControl, Main:, rConsoleTextColorText, %rConsoleTextColor%
		
		Gui, Add, Text, xs w120 +Right, Text Output Color
		Gui, Add, Progress, x+m yp-4 h21 w90 vrConsoleHistoryTextColorProgress
		Gui, Add, Text, xp yp+4 w90 +Center +BackgroundTrans vrConsoleHistoryTextColorText ,
		Gui, Add, Button, vrConsoleHistoryTextColor grConsoleHistoryTextColor x+0 yp-5, <
		rConsoleHistoryTextColor_TT := "Sets the color of the text output in the console.`n`n[Menu]`nrConsoleHistoryTextColor"
		rConsoleHistoryTextColor := getSettingValue("Menu", "rConsoleHistoryTextColor", blank, "153,153,153")
		rConsoleHistoryTextColorArray := StrSplit(rConsoleHistoryTextColor,",")
		rConsoleHistoryTextColorProgress := Format("{1:02x}{2:02x}{3:02x}", rConsoleHistoryTextColorArray[1], rConsoleHistoryTextColorArray[2], rConsoleHistoryTextColorArray[3])
		GuiControl, Main:+Background%rConsoleHistoryTextColorProgress%, rConsoleHistoryTextColorProgress
		GuiControl, Main:, rConsoleHistoryTextColorText, %rConsoleHistoryTextColor%
	}
if gameName = Fallout 4
	{
		Gui, Add, Text, xs w120 +Right, Selection Color
		Gui, Add, Progress, x+m yp-4 h21 w90 viConsoleSelectedRefColorProgress
		Gui, Add, Text, xp yp+4 w90 +Center +BackgroundTrans viConsoleSelectedRefColorText ,
		Gui, Add, Button, viConsoleSelectedRefColor giConsoleSelectedRefColor x+0 yp-5, <
		iConsoleSelectedRefColor_TT := "Sets the color of items selected while in the console.`n`n[Menu]`niConsoleSelectedRefColor"
		iConsoleSelectedRefColor := getSettingValue("Menu", "iConsoleSelectedRefColor", blank, "0x00000000")
		if iConsoleSelectedRefColor = 0
			iConsoleSelectedRefColor = 0x00000000
		if (SubStr(iConsoleSelectedRefColor, 3, 2) = "00")
			iConsoleSelectedRefColorProgress := "FFFFFF"
		else
			iConsoleSelectedRefColorProgress := SubStr(iConsoleSelectedRefColor, 9, 2) . SubStr(iConsoleSelectedRefColor, 7, 2) . SubStr(iConsoleSelectedRefColor, 5, 2)
		GuiControl, Main:+Background%iConsoleSelectedRefColorProgress%, iConsoleSelectedRefColorProgress
		GuiControl, Main:, iConsoleSelectedRefColorText, %iConsoleSelectedRefColor%
	}

Gui, Tab, 6

if (gameName = "Oblivion" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	Gui, Add, GroupBox, w265 r6 , Water

if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vWaterReflectTrees gReflectTrees xp+9 yp+20 Section, Reflect Trees
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			{
				WaterReflectTrees_TT := "Toggles tree reflections in the water.`n`n[Water]`nbReflectLODTrees"
				WaterReflectTrees := getSettingValue("Water", "bReflectLODTrees", blank, "0")
			}
		else
			{
				WaterReflectTrees_TT := "Toggles tree reflections in the water.`n`n[Water]`nbUseWaterReflectionsTrees"
				WaterReflectTrees := getSettingValue("Water", "bUseWaterReflectionsTrees", blank, "0")
			}
		GuiControl, Main:, WaterReflectTrees, %WaterReflectTrees%
	}
if gameName = Oblivion
	{
		Gui, Add, Checkbox, vbUseWaterReflectionsMisc gbUseWaterReflectionsMisc, Reflect Misc
		bUseWaterReflectionsMisc_TT := "Toggles miscellaneous reflections in water, such as floating apples.`n`n[Water]`nbUseWaterReflectionsMisc"
		bUseWaterReflectionsMisc := getSettingValue("Water", "bUseWaterReflectionsMisc", blank, "0")
		GuiControl, Main:, bUseWaterReflectionsMisc, %bUseWaterReflectionsMisc%
	}
if gameName = Oblivion
	{
		Gui, Add, Checkbox, vbUseWaterReflectionsStatics gbUseWaterReflectionsStatics ys, Reflect Statics
		bUseWaterReflectionsStatics_TT := "Toggles static object reflections in water, such as certain rocks and buildings.`n`n[Water]`nbUseWaterReflectionsStatics"
		bUseWaterReflectionsStatics := getSettingValue("Water", "bUseWaterReflectionsStatics", blank, "0")
		GuiControl, Main:, bUseWaterReflectionsStatics, %bUseWaterReflectionsStatics%
		Gui, Add, Checkbox, vbUseWaterReflectionsActors gbUseWaterReflectionsActors , Reflect Actors
		bUseWaterReflectionsActors_TT := "Toggles actor reflections in water.`n`n[Water]`nbUseWaterReflectionsActors"
		bUseWaterReflectionsActors := getSettingValue("Water", "bUseWaterReflectionsActors", blank, "0")
		GuiControl, Main:, bUseWaterReflectionsActors, %bUseWaterReflectionsActors%
		
		Gui, Add, Checkbox, vbUseWaterHiRes gbUseWaterHiRes xs, High Resolution Water Detail
		bUseWaterHiRes_TT := "Toggles high resolution water detail.`n`n[Water]`nbUseWaterHiRes"
		bUseWaterHiRes := getSettingValue("Water", "bUseWaterHiRes", blank, "0")
		GuiControl, Main:, bUseWaterHiRes, %bUseWaterHiRes%
	}

if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		Gui, Add, Checkbox, vbAutoWaterSilhouetteReflections gbAutoWaterSilhouetteReflections xp+9 yp+20 Section, Reflect Detail
		bAutoWaterSilhouetteReflections_TT := "Toggles detailed water reflections. If disabled,`nwater reflections will only reflect the outlines of objects.`n`n[Water]`nbAutoWaterSilhouetteReflections`nbForceLowDetailReflections"
		bAutoWaterSilhouetteReflections := getSettingValue("Water", "bAutoWaterSilhouetteReflections", Prefs, "1") + getSettingValue("Water", "bForceLowDetailReflections", blank, "0")
		if bAutoWaterSilhouetteReflections = 0
			bAutoWaterSilhouetteReflections = 1
		else
			bAutoWaterSilhouetteReflections = 0
		GuiControl, Main:, bAutoWaterSilhouetteReflections, %bAutoWaterSilhouetteReflections%
		
		Gui, Add, Checkbox, vbForceHighDetailReflections gbForceHighDetailReflections , Reflect Full Scene
		bForceHighDetailReflections_TT := "Toggles full scene water reflections,`nwhich allows more objects to be reflected in the water.`n`n[Water]`nbForceHighDetailReflections"
		bForceHighDetailReflections := getSettingValue("Water", "bForceHighDetailReflections", Prefs, "0")
		GuiControl, Main:, bForceHighDetailReflections, %bForceHighDetailReflections%
	}
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vWaterReflectLand gReflectLand , Reflect Land
		WaterReflectLand_TT := "Toggles land reflections in the water.`n`n[Water]`nbReflectLODLand"
		WaterReflectLand := getSettingValue("Water", "bReflectLODLand", blank, "1")
		GuiControl, Main:, WaterReflectLand, %WaterReflectLand%
	}


if (gameName = "Oblivion" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim")
	{
		Gui, Add, Checkbox, vbUseWaterDisplacements gbUseWaterDisplacements , Water Ripples
		if gameName = Oblivion
			bUseWaterDisplacements_TT := "Toggles water ripples and water displacement. Required if using Oblivion Reloaded's water shaders.`n`n[Water]`nbUseWaterDisplacements"
		else
			bUseWaterDisplacements_TT := "Toggles water ripples and water displacement.`n`n[Water]`nbUseWaterDisplacements"
		bUseWaterDisplacements := getSettingValue("Water", "bUseWaterDisplacements", Prefs, "1")
		GuiControl, Main:, bUseWaterDisplacements, %bUseWaterDisplacements%
	}
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vWaterReflectObjects gReflectObjects ys, Reflect Objects
		WaterReflectObjects_TT := "Toggles object reflections in the water.`n`n[Water]`nbReflectLODObjects"
		WaterReflectObjects := getSettingValue("Water", "bReflectLODObjects", blank, "0")
		GuiControl, Main:, WaterReflectObjects, %WaterReflectObjects%
		
		Gui, Add, Checkbox, vWaterReflectSky gReflectSky , Reflect Sky
		WaterReflectSky_TT := "Toggles the sky reflection in the water.`n`n[Water]`nbReflectSky"
		WaterReflectSky := getSettingValue("Water", "bReflectSky", blank, "0")
		GuiControl, Main:, WaterReflectSky, %WaterReflectSky%
	}

	
if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim")
	Gui, Add, Text, xs, Reflection Resolution
if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim")
	{	
		Gui, Add, ComboBox, vWaterReflectRes gReflectionResolution x+m yp-3 w90 ,
		WaterReflectRes_TT := "Sets the resolution of water reflections.`nYou can manually type in a custom value.`n`n[Water]`niWaterReflectHeight`niWaterReflectWidth"
		WaterReflectRes := sortNumberedList("128|256|512|1024|2048", getSettingValue("Water", "iWaterReflectHeight", Prefs, "512"))
		GuiControl, Main:, WaterReflectRes, %WaterReflectRes%
	}
if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		
		Gui, Add, ComboBox, viWaterBlurAmount giWaterBlurAmount w90 ,
		iWaterBlurAmount_TT := "Sets the level of blurring on water reflections.`nYou can manually type in a custom value.`n`n[Water]`nbUseWaterReflectionBlur`niWaterBlurAmount"
		if getSettingValue("Water", "bUseWaterReflectionBlur", Prefs, "0") = 1
			iWaterBlurAmount := sortNumberedList("0|1|2|3|4", getSettingValue("Water", "iWaterBlurAmount", Prefs, "1"))
		else
			iWaterBlurAmount := sortNumberedList("0|1|2|3|4", 0)
		GuiControl, Main:, iWaterBlurAmount, |%iWaterBlurAmount%
	}
if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	Gui, Add, Text, xs yp+3, Reflection Blur






if gameName = Fallout 4	
	Gui, Add, Text, Section, Decal Quantity
else
	Gui, Add, Text, xs-9 ys+125 Section, Decal Quantity
if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	Gui, Add, Text, , Texture Quality
if gameName = Skyrim Special Edition
	Gui, Add, Text, , Godrays
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	Gui, Add, Text, , Field of View
if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Oblivion")
	Gui, Add, Text, , Lighting Effect
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	Gui, Add, Text, , Particles
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vbDecals gDecals yp+24, Decals
		bDecals_TT := "Toggles decals (mostly blood effects).`n`n[Decals]`nbDecals"
		if gameName = Skyrim Special Edition
			bDecals := getSettingValue("Decals", "bDecals", Prefs, "1")
		else
			bDecals := getSettingValue("Decals", "bDecals", blank, "1")
		GuiControl, Main:, bDecals, %bDecals%
	}
if gameName = Fallout 4
	{
		Gui, Add, Checkbox, vbEnableWetnessMaterials gbEnableWetnessMaterials , Wetness
		bEnableWetnessMaterials_TT := "Toggles the wet look effect on objects when it rains.`n`n[Display]`nbEnableWetnessMaterials"
		bEnableWetnessMaterials := getSettingValue("Display", "bEnableWetnessMaterials", Prefs, "1")
		GuiControl, Main:, bEnableWetnessMaterials, %bEnableWetnessMaterials%
	}
if gameName = Fallout 4
	{
		Gui, Add, Checkbox, vbScreenSpaceBokeh gbScreenSpaceBokeh , Bokeh
		bScreenSpaceBokeh_TT := "Toggles bokeh depth of field (DOF), which blurs the background in a more aesthetically pleasing manner than standard DOF.`n`n[Imagespace]`nbScreenSpaceBokeh"
		bScreenSpaceBokeh := getSettingValue("Imagespace", "bScreenSpaceBokeh", Prefs, "1")
		GuiControl, Main:, bScreenSpaceBokeh, %bScreenSpaceBokeh%
	}
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vDisableGore gDisableAllGore , Disable Gore
		DisableGore_TT := "Toggles gory effects, such as blood.`n`n[General]`nbDisableAllGore"
		DisableGore := getSettingValue("General", "bDisableAllGore", blank, "0")
		GuiControl, Main:, DisableGore, %DisableGore%
	}
if gameName = Fallout 4
	{
		Gui, Add, Checkbox, vbVolumetricLightingEnable gbVolumetricLightingEnable , Godrays
		bVolumetricLightingEnable_TT := "Toggles Godrays.`n`n[Display]`nbVolumetricLightingEnable"
		bVolumetricLightingEnable := getSettingValue("Display", "bVolumetricLightingEnable", Prefs, "1")
		GuiControl, Main:, bVolumetricLightingEnable, %bVolumetricLightingEnable%
	}
if (gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vbLensFlare gbLensFlare , Lens Flare
		bLensFlare_TT := "Toggles lens flare.`n`n[Imagespace]`nbLensFlare"
		bLensFlare := getSettingValue("Imagespace", "bLensFlare", Prefs, "1")
		GuiControl, Main:, bLensFlare, %bLensFlare%
	}
	
Gui, Add, DropDownList, vDecalQuantity gDecalQuantity ys-3 w135 ,
if gameName = Oblivion
	DecalQuantity_TT := "Changes the amount of decals, mostly blood effects, that can be displayed.`n`n[Display]`niMaxDecalsPerFrame"
else
	DecalQuantity_TT := "Changes the amount of decals, mostly blood effects, that can be displayed.`n`n[Decals]`nuMaxDecals`nuMaxSkinDecalPerActor`nuMaxSkinDecals`n`n[Display]`niMaxDecalsPerFrame`niMaxSkinDecalsPerFrame`nfDecalLifetime"
if gameName = Skyrim Special Edition
	DecalQuantity := getDecalQuantity(getSettingValue("Display", "iMaxDecalsPerFrame", Prefs, "100"))
else if gameName = Fallout 4
	DecalQuantity := getDecalQuantity(getSettingValue("Display", "iMaxDecalsPerFrame", Prefs, "40"))
else
	DecalQuantity := getDecalQuantity(getSettingValue("Display", "iMaxDecalsPerFrame", Prefs, "10"))
GuiControl, Main:, DecalQuantity, %DecalQuantity%
if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		Gui, Add, DropDownList, viTexMipMapSkip gTextureQuality w135 ,
		iTexMipMapSkip_TT := "Changes the texture quality.`n`n[Display]`niTexMipMapSkip`niTexMipMapMinimum"
		iTexMipMapSkip := getTextureQuality(getSettingValue("Display", "iTexMipMapSkip", Prefs, "0"), getSettingValue("Display", "iTexMipMapMinimum", Prefs, "0"))
		GuiControl, Main:, iTexMipMapSkip, %iTexMipMapSkip%
	}	
if gameName = Skyrim Special Edition
	{		
		Gui, Add, DropDownList, vGodrays gGodrays w135 ,
		Godrays_TT := "Sets Godrays quality.`n`nPerformance cost: 7% Low, 8% Medium, 10% High`n`n[Display]`nbVolumetricLightingEnable`niVolumetricLightingQuality"
		Godrays := getGodrays(getSettingValue("Display", "bVolumetricLightingEnable", Prefs, "1"),getSettingValue("Display", "iVolumetricLightingQuality", Prefs, "1"))
		GuiControl, Main:, Godrays, %Godrays%
	}	
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	{	
		Gui, Add, ComboBox, vFOV gFieldofView w135 ,
		FOV_TT := "Changes the default Field of View. This will only take effect on new saves.`nYou can manually type in a custom value.`n`n[Display]`nfDefaultWorldFOV"
		if gameName = Skyrim
			FOV := sortNumberedList("55.93|65.00|70.59|85.79", Round(getSettingValue("Display", "fDefaultWorldFOV", blank, "65.00"),2))
		else if (gameName = "Fallout New Vegas" or gameName = "Fallout 3")
			FOV := sortNumberedList("59.84|69.26|75.00|85.28|91.31|107.51", Round(getSettingValue("Display", "fDefaultWorldFOV", blank, "75.00"),2))
		else if gameName = Fallout 4
			FOV := sortNumberedList("55.41|64.44|70.00|86.07", Round(getSettingValue("Display", "fDefaultWorldFOV", blank, "70.00"),2))
		else if gameName = Skyrim Special Edition
			FOV := sortNumberedList("64.37|74.12|80.00|96.42", Round(getSettingValue("Display", "fDefaultWorldFOV", blank, "80.00"),2))
		GuiControl, Main:, FOV, %FOV%
	}
if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Oblivion")
	{		
		Gui, Add, DropDownList, vbUseBlurShader gbUseBlurShader w135 ,
		bUseBlurShader_TT := "Sets the lighting effect.`n`n[BlurShader]`nbUseBlurShader`n`n[BlurShaderHDR]`nbDoHighDynamicRange"
		bUseBlurShader := getLightingEffect(getSettingValue("BlurShader", "bUseBlurShader", Prefs, "1"), getSettingValue("BlurShaderHDR", "bDoHighDynamicRange", Prefs, "1"))
		GuiControl, Main:, bUseBlurShader, %bUseBlurShader%
	}
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, ComboBox, viMaxDesired giMaxDesired w135 ,
		iMaxDesired_TT := "Set the amount of particle effects.`nYou can manually type in a custom value.`n`n[Particles]`niMaxDesired"
		iMaxDesired := sortNumberedList("250|750|1500|3000|4500|6000|8000|10000", getSettingValue("Particles", "iMaxDesired", Prefs, "750"))
		GuiControl, Main:, iMaxDesired, %iMaxDesired%
	}
if gameName = Fallout 4
	{
		Gui, Add, Checkbox, vbMBEnable gbMBEnable , Motion Blur
		bMBEnable_TT := "Toggles motion blur.`n`n[Imagespace]`nbMBEnable"
		bMBEnable := getSettingValue("Imagespace", "bMBEnable", Prefs, "1")
		GuiControl, Main:, bMBEnable, %bMBEnable%
	}

Gui, Add, Checkbox, vDisablePrecipitation gDisablePrecipitation cMaroon, Disable Precipitation
DisablePrecipitation_TT := "Toggles rain and snow effects. CHECKING THIS SETTING CAN CAUSE CTDS.`n`n[Weather]`nbPrecipitation"
DisablePrecipitation := Abs(getSettingValue("Weather", "bPrecipitation", blank, "1") - 1)
GuiControl, Main:, DisablePrecipitation, %DisablePrecipitation%

if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Oblivion")
	{
		Gui, Add, Checkbox, vbUseEyeEnvMapping gbUseEyeEnvMapping , Eye Environment Mapping
		bUseEyeEnvMapping_TT := "Toggles eye environment mapping, which causes eyes to look a little brighter.`n`n[General]`nbUseEyeEnvMapping"
		bUseEyeEnvMapping := getSettingValue("General", "bUseEyeEnvMapping", blank, "1")
		GuiControl, Main:, bUseEyeEnvMapping, %bUseEyeEnvMapping%
	}
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vDepthOfField gDepthofField , Depth of Field
		DepthOfField_TT := "Toggles depth of field (DOF), a kind of blurring to imitate the human eye's perception.`nThis is most noticeable under water, reducing visibility to realistic levels (it looks clear otherwise).`n`n[Imagespace]`nbDoDepthOfField"
		DepthOfField := getSettingValue("Imagespace", "bDoDepthOfField", Prefs, "1")
		GuiControl, Main:, DepthOfField, %DepthOfField%
	}
if (gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vbIBLFEnable gbIBLFEnable , Anamorphic Lens Flare
		bIBLFEnable_TT := "Toggles the horizontal lens flare effect most commonly associated with anamorphic lenses.`n`nPerformance cost: 1%`n`n[Display]`nbIBLFEnable"
		bIBLFEnable := getSettingValue("Display", "bIBLFEnable", Prefs, "1")
		GuiControl, Main:, bIBLFEnable, %bIBLFEnable%
	}
if gameName = Skyrim
	{
		Gui, Add, Checkbox, vPreciseLighting gPreciseLighting , Precise Lighting
		PreciseLighting_TT := "Toggles the ability of lighting to be rendered using floating point (decimal) values rather than only integer values.`nEnabling this increases the precision of lighting.`n`n[Display]`nbFloatPointRenderTarget"
		PreciseLighting := getSettingValue("Display", "bFloatPointRenderTarget", Prefs, "0")
		GuiControl, Main:, PreciseLighting, %PreciseLighting%
	}
if (gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vbVolumetricLightingDisableInterior gbVolumetricLightingDisableInterior , Interior Godrays
		bVolumetricLightingDisableInterior_TT := "Toggles Godrays in interiors. This may cause interiors to become overly bright in some cases.`n`n[Display]`nbVolumetricLightingDisableInterior"
		bVolumetricLightingDisableInterior := Abs(getSettingValue("Display", "bVolumetricLightingDisableInterior", blank, "1") - 1)
		GuiControl, Main:, bVolumetricLightingDisableInterior, %bVolumetricLightingDisableInterior%
	}



if gameName = Fallout 4
	Gui, Add, GroupBox, ys w290 r11.5 , Shadows
else
	Gui, Add, GroupBox, xs+300 ys-145 w320 r11.5 , Shadows
Gui, Add, Text, xp+9 yp+20 Section, Shadow Resolution
if (gameName = "Oblivion" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Fallout 4")
	Gui, Add, Text, , Shadow Filtering
if gameName = Oblivion
	Gui, Add, Text, , Far-off Shadow Distance
if (gameName = "Oblivion" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		Gui, Add, Text, , Interior Shadows
		Gui, Add, Text, , Exterior Shadows
		Gui, Add, Text, , Shadow Fade Time
	}
if (gameName = "Fallout 4")
	Gui, Add, Text, , Ambient Occlusion
if gameName = Skyrim
	Gui, Add, Text, , Shadow Blurring
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	Gui, Add, Text, , Shadow Bias
if (gameName = "Skyrim Special Edition")
	Gui, Add, Text, , Detailed Draw Distance
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	Gui, Add, Text, , Exterior Draw Distance
	
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vShadowRemoval gShadowRemoval yp+24, Remove Shadows
		if gameName = Skyrim
			{
				ShadowRemoval_TT := "Removes shadows.`n`n[Display]`nbDeferredShadows`nbDrawLandShadows`nbShadowMaskZPrepass`nbShadowsOnGrass`nbTreesReceiveShadows`nfShadowDistance`niBlurDeferredShadowMask`niShadowMapResolution"
				ShadowRemoval := getSettingValue("Display", "iShadowMapResolution", Prefs, "1024")
				if (ShadowRemoval != 1)
					ShadowRemoval = 0
			}
		else if gameName = Skyrim Special Edition
			{
				ShadowRemoval_TT := "Removes shadows.`n`n[Display]`nbDirShadowMapFullViewPort`nfMaxHeightShadowCastingTrees`nfFirstSliceDistance`nbDrawLandShadows`nbTreesReceiveShadows`nfShadowDistance`niShadowMapResolution"
				ShadowRemoval = 0
				if getSettingValue("Display", "fShadowDistance", Prefs, "8000") < 10
					ShadowRemoval = 1
			}
		GuiControl, Main:, ShadowRemoval, %ShadowRemoval%
	}
if (gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vbDisableShadowJumps gbDisableShadowJumps , Sun-Shadow Transitions
		bDisableShadowJumps_TT := "If enabled, shadows will move according to the sun-shadow update settings`nrather than constantly moving with the sun.`n`n[Display]`nbDisableShadowJumps"
		bDisableShadowJumps := Abs(getSettingValue("Display", "bDisableShadowJumps", blank, "1") - 1)
		GuiControl, Main:, bDisableShadowJumps, %bDisableShadowJumps%
	}
if gameName = Skyrim
	{	
		Gui, Add, Checkbox, vShadowDeffer gDeferredShadows , Deferred Shadows
		ShadowDeffer_TT := "Toggles deferred rendering of shadows.`n`n[Display]`nbDeferredShadows"
		ShadowDeffer := getSettingValue("Display", "bDeferredShadows", Prefs, "1")
		GuiControl, Main:, ShadowDeffer, %ShadowDeffer%
	}
if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		if gameName = Skyrim
			Gui, Add, Checkbox, vShadowGrass gGrassShadows , Grass Shadows
		else
			Gui, Add, Checkbox, vShadowGrass gGrassShadows yp+24, Grass Shadows
		ShadowGrass_TT := "Toggles the ability of objects to cast shadows upon grass.`nThe grass itself does not cast shadows.`n`n[Display]`nbShadowsOnGrass"
		if gameName = Skyrim
			ShadowGrass := getSettingValue("Display", "bShadowsOnGrass", Prefs, "1")
		else
			ShadowGrass := getSettingValue("Display", "bShadowsOnGrass", blank, "0")
		GuiControl, Main:, ShadowGrass, %ShadowGrass%
	}
if (gameName = "Oblivion")
	{
		Gui, Add, Checkbox, vbActorSelfShadowing gbActorSelfShadowing, Self Shadows
		bActorSelfShadowing_TT := "Toggles the ability of characters to cast shadows upon themselves.`n`n[Display]`nbActorSelfShadowing"
		bActorSelfShadowing := getSettingValue("Display", "bActorSelfShadowing", blank, "0")
		GuiControl, Main:, bActorSelfShadowing, %bActorSelfShadowing%
	}

Gui, Add, ComboBox, vShadowRes gShadowResolution ys-3 w90 ,
if gameName = Skyrim Special Edition
	ShadowRes_TT := "Sets the resolution of shadows.`nYou can manually type in a custom value.`n`nPerformance cost: 10%`n`n[Display]`niShadowMapResolution"
else
	ShadowRes_TT := "Sets the resolution of shadows.`nYou can manually type in a custom value.`n`n[Display]`niShadowMapResolution"
if gameName = Skyrim
	ShadowRes := sortNumberedList("256|512|1024|2048|4096|8192", Round(getSettingValue("Display", "iShadowMapResolution", Prefs, "1024"),0))
else if (gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	ShadowRes := sortNumberedList("256|512|1024|2048|4096|8192", Round(getSettingValue("Display", "iShadowMapResolution", Prefs, "2048"),0))
else
	ShadowRes := sortNumberedList("256|512|1024|2048|4096|8192", Round(getSettingValue("Display", "iShadowMapResolution", Prefs, "256"),0))
GuiControl, Main:, ShadowRes, %ShadowRes%
if (gameName = "Oblivion" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Fallout 4")
	{
		Gui, Add, ComboBox, viShadowFilter giShadowFilter w90 ,
		if gameName = Fallout 4
			iShadowFilter_TT := "Sets the level of filtering (a kind of blurring of the edges) to shadows.`nYou can manually type in a custom value.`n`n[Display]`nuiOrthoShadowFilter"
		else
			iShadowFilter_TT := "Sets the level of filtering (a kind of blurring of the edges) to shadows.`nYou can manually type in a custom value.`n`n[Display]`niShadowFilter"
		if gameName = Fallout 4
			iShadowFilter := sortNumberedList("0|1|2|3", Round(getSettingValue("Display", "uiOrthoShadowFilter", Prefs, "3"),0))
		else
			iShadowFilter := sortNumberedList("0|1|2|3", Round(getSettingValue("Display", "iShadowFilter", Prefs, "0"),0))
		GuiControl, Main:, iShadowFilter, %iShadowFilter%
	}
if gameName = Oblivion
	{
		Gui, Add, ComboBox, vfShadowLOD gfShadowLOD w90 ,
		fShadowLOD_TT := "Sets the distance that you can see far-off shadows.`nA setting of 0 appears to show as many far-off shadows as are allowed.`nYou can manually type in a custom value.`n`n[Display]`nfShadowLOD1`nfShadowLOD2"
		fShadowLOD := sortNumberedList("0|2|512|1024|2048|4096|8192", Round(getSettingValue("Display", "fShadowLOD2", blank, "400"),0))
		GuiControl, Main:, fShadowLOD, %fShadowLOD%
	}
if (gameName = "Oblivion" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	{
		Gui, Add, Slider, viActorShadowCountInt giActorShadowCountInt w80 h20 yp+29 Range0-20 TickInterval2 ToolTip Section,
		Gui, Add, Edit, viActorShadowCountIntReal giActorShadowCountIntReal x+m yp-3 w30 Number,
		iActorShadowCountInt_TT := "Sets the maximum amount of interior actor shadows.`n`n[Display]`niActorShadowCountInt"
		iActorShadowCountIntReal_TT := iActorShadowCountInt_TT
		iActorShadowCountInt := Round(getSettingValue("Display", "iActorShadowCountInt", Prefs, "4"),0)
		GuiControl, Main:, iActorShadowCountInt, %iActorShadowCountInt%
		GuiControl, Main:, iActorShadowCountIntReal, %iActorShadowCountInt%
		
		Gui, Add, Slider, viActorShadowCountExt giActorShadowCountExt xs w80 h20 Range0-20 TickInterval2 ToolTip,
		Gui, Add, Edit, viActorShadowCountExtReal giActorShadowCountExtReal x+m yp-3 w30 Number,
		iActorShadowCountExt_TT := "Sets the maximum amount of exterior actor shadows.`n`n[Display]`niActorShadowCountExt"
		iActorShadowCountExtReal_TT := iActorShadowCountExt_TT
		iActorShadowCountExt := Round(getSettingValue("Display", "iActorShadowCountExt", Prefs, "2"),0)
		GuiControl, Main:, iActorShadowCountExt, %iActorShadowCountExt%
		GuiControl, Main:, iActorShadowCountExtReal, %iActorShadowCountExt%
		
		Gui, Add, Edit, vfShadowFadeTime gfShadowFadeTime xs w40,
		fShadowFadeTime_TT := "Sets the amount of time it takes for shadows to fully fade into view.`n`n[Display]`nfShadowFadeTime"
		fShadowFadeTime := Round(getSettingValue("Display", "fShadowFadeTime", blank, "1.0000"), 2)
		GuiControl, Main:, fShadowFadeTime, %fShadowFadeTime%
	}
if (gameName = "Fallout 4")
	{
		Gui, Add, DropDownList, vAmbientOcclusion gAmbientOcclusion w90 ,
		AmbientOcclusion_TT := "Sets the level of ambient occlusion shadowing effect.`n`n[Display]`nbSAOEnable`n`n[NVHBAO]`nbEnable"
		if getSettingValue("Display", "bSAOEnable", Prefs, "1") = 0
			AmbientOcclusion = None||SSAO|HBAO+
		else if getSettingValue("NVHBAO", "bEnable", Prefs, "0") =0
			AmbientOcclusion = None|SSAO||HBAO+
		else
			AmbientOcclusion = None|SSAO|HBAO+||
		GuiControl, Main:, AmbientOcclusion, |%AmbientOcclusion%
	}

	
if gameName = Skyrim
	{
		Gui, Add, ComboBox, vShadowBlur gShadowBlurring w90 ,
		ShadowBlur_TT := "Sets the amount of blurring applied to shadows.`nYou can manually type in a custom value.`n`n[Display]`niBlurDeferredShadowMask"
		ShadowBlur := sortNumberedList("1|3|4|5|7", Round(getSettingValue("Display", "iBlurDeferredShadowMask", Prefs, "5"),0))
		ShadowBlur = none|%ShadowBlur%|max
		if (getSettingValue("Display", "iBlurDeferredShadowMask", Prefs, "5") < 0)
			ShadowBlur = none|1|3|4|5|7|max||
		if (getSettingValue("Display", "iBlurDeferredShadowMask", Prefs, "5") = 0)
			ShadowBlur = none||1|3|4|5|7|max
		GuiControl, Main:, ShadowBlur, %ShadowBlur%
	}
if gameName = Skyrim
	{
		Gui, Add, ComboBox, vShadowBias gShadowBias w90 ,
		ShadowBias_TT := "Sets the depth bias of the shadows applied to surfaces.`nLow values reduce peter-panning (detached shadows)`nbut cause more shadow acne (AKA shadow striping).`nYou can manually type in a custom value.`n`n[Display]`nfShadowBiasScale"
		ShadowBias := sortNumberedList("0.15|0.25|0.50|0.90|1.00", Round(getSettingValue("Display", "fShadowBiasScale", Prefs, "1.00"),2))
		GuiControl, Main:, ShadowBias, %ShadowBias%
	}
if (gameName = "Skyrim Special Edition")
	{
		Gui, Add, ComboBox, vShadowBias gShadowBias w90 ,
		ShadowBias_TT := "Sets the directional bias of the shadows applied to surfaces.`nLow values reduce peter-panning (detached shadows).`nbut cause more shadow acne (AKA shadow striping).`nYou can manually type in a custom value.`n`n[Display]`nfShadowDirectionalBiasScale"
		ShadowBias := sortNumberedList("0.15|0.25|0.30|0.50|1.00", Round(getSettingValue("Display", "fShadowDirectionalBiasScale", blank, "0.3"),2))
		GuiControl, Main:, ShadowBias, %ShadowBias%
	}
if (gameName = "Skyrim Special Edition")
	{
		Gui, Add, ComboBox, vfFirstSliceDistance gfFirstSliceDistance w90 ,
		fFirstSliceDistance_TT := "Sets the detailed draw distance (the shadows closest to your character).`nYou can manually type in a custom value.`n`nPerformance cost: 2%`n`n[Display]`nfFirstSliceDistance"
		fFirstSliceDistance := sortNumberedList("1250|2000|2800|3500|4000", Round(getSettingValue("Display", "fFirstSliceDistance", blank, "1250"),0))
		GuiControl, Main:, fFirstSliceDistance, %fFirstSliceDistance%
	}
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, ComboBox, vShadowExDist gExteriorDrawDistance w90 , 
		if gameName = Skyrim
			{
				ShadowExDist_TT := "The distance that shadows are cast from the player.`nIncreasing this also has the side effect of lowering the resolution of shadows.`nYou can manually type in a custom value.`n`n[Display]`nfShadowDistance"
				ShadowExDist := sortNumberedList("1500|2000|2800|3500|4000|5000|6000|8000", Round(getSettingValue("Display", "fShadowDistance", Prefs, "2500"),0))
			}
		else if gameName = Skyrim Special Edition
			{
				ShadowExDist_TT := "The distance that shadows are cast from the player.`nYou can manually type in a custom value.`n`nPerformance cost: Negligible`n`n[Display]`nfShadowDistance"
				ShadowExDist := sortNumberedList("2000|2800|4000|6000|8000|10000", Round(getSettingValue("Display", "fShadowDistance", Prefs, "8000"),0))
			}
		else if gameName = Fallout 4
			{
				ShadowExDist_TT := "The distance that shadows are cast from the player.`nYou can manually type in a custom value.`n`n[Display]`nfDirShadowDistance"
				ShadowExDist := sortNumberedList("3000|5000|8000|14000|18000|20000", Round(getSettingValue("Display", "fDirShadowDistance", Prefs, "3000"),0))
			}
		GuiControl, Main:, ShadowExDist, %ShadowExDist%
	}
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Checkbox, vShadowTrees gTreeShadows , Tree Shadows
		ShadowTrees_TT := "Toggles the ability of trees to cast shadows upon themselves.`n`n[Display]`nbTreesReceiveShadows"
		ShadowTrees := getSettingValue("Display", "bTreesReceiveShadows", Prefs, "0")
		GuiControl, Main:, ShadowTrees, %ShadowTrees%
	}
if (gameName = "Oblivion")
	{
		Gui, Add, Checkbox, vbDoCanopyShadowPass gbDoCanopyShadowPass xs, Tree Shadows
		bDoCanopyShadowPass_TT := "Toggles the ability of trees to cast shadows.`n`n[Display]`nbDoCanopyShadowPass"
		bDoCanopyShadowPass := getSettingValue("Display", "bDoCanopyShadowPass", blank, "1")
		GuiControl, Main:, bDoCanopyShadowPass, %bDoCanopyShadowPass%
	}
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{		
		Gui, Add, Checkbox, vShadowLand gLandShadows , Land Shadows
		ShadowLand_TT := "Toggles the ability of land objects such as rocks and mountains to cast shadows.`n`nPerformance cost: 1%`n`n[Display]`nbDrawLandShadows"
		ShadowLand := getSettingValue("Display", "bDrawLandShadows", Prefs, "0")
		GuiControl, Main:, ShadowLand, %ShadowLand%
	}

if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Text, xs Section, Sun-Shadow Update Time
		Gui, Add, Text, ,  Sun-Shadow Update Threshold
		
		Gui, Add, Edit, vfSunShadowUpdateTime gfSunShadowUpdateTime ys-3 w74 h20 Right,
		fSunShadowUpdateTime_TT := "Sets the speed of sun-shadow transitions in seconds.`n`n[Display]`nfSunShadowUpdateTime"
		fSunShadowUpdateTime := getSettingValue("Display", "fSunShadowUpdateTime", blank, "1")
		GuiControl, Main:, fSunShadowUpdateTime, %fSunShadowUpdateTime%
		Gui, Add, Edit, vfSunUpdateThreshold gfSunUpdateThreshold w74 h20 Right,
		fSunUpdateThreshold_TT := "Sets the time between sun-shadow transitions.`n`n[Display]`nfSunUpdateThreshold"
		fSunUpdateThreshold := getSettingValue("Display", "fSunUpdateThreshold", blank, "0.5")
		GuiControl, Main:, fSunUpdateThreshold, %fSunUpdateThreshold%
	}
if gameName = Skyrim Special Edition
	{
		Gui, Add, Checkbox, vbSAOEnable gbSAOEnable xs, Ambient Occlusion
		bSAOEnable_TT := "Toggles ambient occlusion.`n`n[Display]`nbSAOEnable"
		bSAOEnable := getSettingValue("Display", "bSAOEnable", Prefs, "1")
		GuiControl, Main:, bSAOEnable, %bSAOEnable%
		
		Gui, Add, GroupBox, w320 xs-9 yp+40 r2.5, Screen Space Reflections

		Gui, Add, Checkbox, vbScreenSpaceReflectionEnabled gbScreenSpaceReflectionEnabled xp+9 yp+20, Screen Space Reflections
		bScreenSpaceReflectionEnabled_TT := "Toggles screen space reflections.`n`nPerformance cost: 18% divided by Reflection Divider.`n`n[Display]`nbScreenSpaceReflectionEnabled"
		bScreenSpaceReflectionEnabled := getSettingValue("Display", "bScreenSpaceReflectionEnabled", Prefs, "1")
		GuiControl, Main:, bScreenSpaceReflectionEnabled, %bScreenSpaceReflectionEnabled%
		
		Gui, Add, Text, ,  Reflection Divider
		Gui, Add, Edit, viReflectionResolutionDivider giReflectionResolutionDivider w40 x+m yp-3 Right Number,
		Gui, Add, UpDown, Range1-10
		iReflectionResolutionDivider_TT := "Sets the resolution divider of screen space reflections.`n`nPerformance improvement: The cost of screen space reflections divided by this.`n`n[Display]`niReflectionResolutionDivider"
		iReflectionResolutionDivider := getSettingValue("Display", "iReflectionResolutionDivider", Prefs, "2")
		GuiControl, Main:, iReflectionResolutionDivider, %iReflectionResolutionDivider%
	}



	



Gui, Tab, 7
Gui, Add, Text, Section, Object Fade
Gui, Add, Text, , Actor Fade
Gui, Add, Text, , Item Fade
Gui, Add, Text, , Grass Fade
if (gameName = "Oblivion" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	Gui, Add, Text, , Light Fade
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	Gui, Add, Text, , Flickering Light
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	Gui, Add, Text, , Object Detail Fade
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	Gui, Add, Text, , Fade Multiplier

Gui, Add, Slider, vFadeObjects gObjectFade ys r1.5 w100 Range0-30 TickInterval3 ToolTip,
Gui, Add, Slider, vFadeActors gActorFade r1.5 w100 Range0-30 TickInterval3 ToolTip, 
Gui, Add, Slider, vFadeItems gItemFade r1.5 w100 Range0-30 TickInterval3 ToolTip, 
Gui, Add, Slider, vFadeGrass gGrassFade r1.5 w100 Range0-18000 TickInterval3000 ToolTip, 
if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	Gui, Add, Slider, vFadeLight gLightFade r1.5 w100 Range0-50000 TickInterval5000 ToolTip, 
if gameName = Oblivion
	Gui, Add, Slider, vFadeLight gLightFade r1.5 w100 Range2-8192 TickInterval1000 ToolTip, 
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, ComboBox, vFlickeringLightDistance gFlickeringLightDistance yp+28 w100,
		FlickeringLightDistance_TT := "Sets the distance that the flickering effect on certain lights can be seen.`n`n[General]`nfFlickeringLightDistance"
		FlickeringLightDistance := sortNumberedList("0|1024|2048|4096|8192", Round(getSettingValue("General", "fFlickeringLightDistance", blank, "1024"),0))
		GuiControl, Main:, FlickeringLightDistance, %FlickeringLightDistance%
	}
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, DropDownList, vFadeMesh gObjectDetailFade w100 ,
		FadeMesh_TT := "Controls the distance at which object detail fades.`n`n[Display]`nfMeshLODLevel1FadeDist`nfMeshLODLevel2FadeDist"
		if gameName = Skyrim
			FadeMesh := getObjectDetailFade(Round(getSettingValue("Display", "fMeshLODLevel1FadeDist", Prefs, "4096"),0), Round(getSettingValue("Display", "fMeshLODLevel2FadeDist", Prefs, "3072"),0))
		else if gameName = Skyrim Special Edition
			FadeMesh := getObjectDetailFade(Round(getSettingValue("Display", "fMeshLODLevel1FadeDist", Prefs, "9999999"),0), Round(getSettingValue("Display", "fMeshLODLevel2FadeDist", Prefs, "9999999"),0))
		else if gameName = Fallout 4
			FadeMesh := getObjectDetailFade(Round(getSettingValue("Display", "fMeshLODLevel1FadeDist", Prefs, "3500"),0), Round(getSettingValue("Display", "fMeshLODLevel2FadeDist", Prefs, "2000"),0))
		GuiControl, Main:, FadeMesh, %FadeMesh%
	}
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Edit, vFadeMult gFadeMultiplier w100 Right,
		FadeMult_TT := "Sets the value to be multiplied against the fade distance settings in-game.`n`n[LOD]`nfDistanceMultiplier"
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition") 
			FadeMult := Round(getSettingValue("LOD", "fDistanceMultiplier", blank, "1"),2)
		else
			FadeMult := Round(getSettingValue("LOD", "fDistanceMultiplier", blank, "1.2"),2)
		GuiControl, Main:, FadeMult, %FadeMult%
	}

Gui, Add, Edit, vFadeObjectsReal gObjectFadeReal ys-3 w45 Limit4 Right,
if gameName = Skyrim Special Edition
	FadeObjects_TT := "Sets the object fade distance.`nYou can manually type in a custom value.`n`nPerformance cost: 0.3% per 1`n`n[LOD]`nfLODFadeOutMultObjects"
else
	FadeObjects_TT := "Sets the object fade distance.`nYou can manually type in a custom value.`n`n[LOD]`nfLODFadeOutMultObjects"
FadeObjectsReal_TT := FadeObjects_TT
if gameName = Fallout 4
	FadeObjects := Round(getSettingValue("LOD", "fLODFadeOutMultObjects", Prefs, "4.5"),1)
else
	FadeObjects := Round(getSettingValue("LOD", "fLODFadeOutMultObjects", Prefs, "5"),1)
GuiControl, Main:, FadeObjects, %FadeObjects%
GuiControl, Main:, FadeObjectsReal, %FadeObjects%


Gui, Add, Edit, vFadeActorsReal gActorFadeReal w45 Limit4 Right,
FadeActors_TT := "Sets the actor fade distance.`nYou can manually type in a custom value.`n`n[LOD]`nfLODFadeOutMultActors"
FadeActorsReal_TT := "Sets the actor fade distance.`nYou can manually type in a custom value.`n`n[LOD]`nfLODFadeOutMultActors"
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	FadeActors := Round(getSettingValue("LOD", "fLODFadeOutMultActors", Prefs, "6"),1)
else if gameName = Oblivion
	FadeActors := Round(getSettingValue("LOD", "fLODFadeOutMultActors", blank, "5"),1)
else
	FadeActors := Round(getSettingValue("LOD", "fLODFadeOutMultActors", Prefs, "6.3333"),1)
GuiControl, Main:, FadeActors, %FadeActors%
GuiControl, Main:, FadeActorsReal, %FadeActors%


Gui, Add, Edit, vFadeItemsReal gItemFadeReal w45 Limit4 Right,
FadeItems_TT := "Sets the item fade distance.`nYou can manually type in a custom value.`n`n[LOD]`nfLODFadeOutMultItems"
FadeItemsReal_TT := "Sets the item fade distance.`nYou can manually type in a custom value.`n`n[LOD]`nfLODFadeOutMultItems"
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	FadeItems := Round(getSettingValue("LOD", "fLODFadeOutMultItems", Prefs, "3"),1)
else if gameName = Fallout 4
	FadeItems := Round(getSettingValue("LOD", "fLODFadeOutMultItems", Prefs, "2.5"),1)
else if gameName = Oblivion
	FadeItems := Round(getSettingValue("LOD", "fLODFadeOutMultItems", blank, "2"),1)
else
	FadeItems := Round(getSettingValue("LOD", "fLODFadeOutMultItems", Prefs, "1.9333"),1)
GuiControl, Main:, FadeItems, %FadeItems%
GuiControl, Main:, FadeItemsReal, %FadeItems%



Gui, Add, Edit, vFadeGrassReal gGrassFadeReal w45 Limit5 Number Right,
if gameName = Oblivion
	{
		FadeGrass_TT := "Sets the grass fade distance.`nYou can manually type in a custom value.`n`n[Grass]`nfGrassEndDistance`nfGrassStartFadeDistance"
		FadeGrassReal_TT := "Sets the grass fade distance.`nYou can manually type in a custom value.`n`n[Grass]`nfGrassEndDistance`nfGrassStartFadeDistance"
	}
else
	{
		FadeGrass_TT := "Sets the grass fade distance.`nYou can manually type in a custom value.`n`n[Grass]`nfGrassFadeRange`nfGrassMaxStartFadeDistance`nfGrassMinStartFadeDistance`nfGrassStartFadeDistance"
		FadeGrassReal_TT := "Sets the grass fade distance.`nYou can manually type in a custom value.`n`n[Grass]`nfGrassFadeRange`nfGrassMaxStartFadeDistance`nfGrassMinStartFadeDistance`nfGrassStartFadeDistance"
	}
if gameName = Skyrim
	FadeGrass := Round(getSettingValue("Grass", "fGrassStartFadeDistance", Prefs, "3500"),0) + Round(getSettingValue("Grass", "fGrassFadeRange", blank, "1000"),0) - Round(getSettingValue("Grass", "fGrassMinStartFadeDistance", Prefs, "400"),0)
else if gameName = Skyrim Special Edition
	FadeGrass := Round(getSettingValue("Grass", "fGrassStartFadeDistance", Prefs, "7000"),0) + Round(getSettingValue("Grass", "fGrassFadeRange", blank, "1000"),0) - Round(getSettingValue("Grass", "fGrassMinStartFadeDistance", Prefs, "400"),0)
else if gameName = Fallout 4
	FadeGrass := Round(getSettingValue("Grass", "fGrassStartFadeDistance", Prefs, "3500"),0) + Round(getSettingValue("Grass", "fGrassFadeRange", blank, "1000"),0) - Round(getSettingValue("Grass", "fGrassMinStartFadeDistance", Prefs, "1000"),0)
else if gameName = Oblivion
	FadeGrass := Round(getSettingValue("Grass", "fGrassEndDistance", blank, "3000"),0)
else
	FadeGrass := Round(getSettingValue("Grass", "fGrassStartFadeDistance", Prefs, "3500"),0) + Round(getSettingValue("Grass", "fGrassFadeRange", blank, "1000"),0) - Round(getSettingValue("Grass", "fGrassMinStartFadeDistance", blank, "400"),0)
GuiControl, Main:, FadeGrass, %FadeGrass%
GuiControl, Main:, FadeGrassReal, %FadeGrass%

if (gameName = "Oblivion" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Edit, vFadeLightReal gLightFadeReal w45 Limit5 Number Right,
		if gameName = Skyrim Special Edition
			{
				FadeLight_TT := "Sets the light fade distance.`nYou can manually type in a custom value.`n`n[Display]`nfLightLODRange`nfLightLODStartFade"
				FadeLightReal_TT := "Sets the light fade distance.`nYou can manually type in a custom value.`n`n[Display]`nfLightLODRange`nfLightLODStartFade"
			}
		else if gameName = Oblivion
			{
				FadeLight_TT := "Sets the light fade distance.`nYou can manually type in a custom value.`n`n[Display]`nfLightLOD1`nfLightLOD2"
				FadeLightReal_TT := "Sets the light fade distance.`nYou can manually type in a custom value.`n`n[Display]`nfLightLOD1`nfLightLOD2"
			}
		else
			{
				FadeLight_TT := "Sets the light fade distance.`nYou can manually type in a custom value.`n`n[Display]`nfLightLODMaxStartFade`nfLightLODRange`nfLightLODStartFade"
				FadeLightReal_TT := "Sets the light fade distance.`nYou can manually type in a custom value.`n`n[Display]`nfLightLODMaxStartFade`nfLightLODRange`nfLightLODStartFade"
			}
		if gameName = Oblivion
			FadeLight := Round(getSettingValue("Display", "fLightLOD2", blank, "1500"),0)
		else
			FadeLight := Round(getSettingValue("Display", "fLightLODStartFade", Prefs, "1000"),0) + Round(getSettingValue("Display", "fLightLODRange", blank, "500"),0)
		GuiControl, Main:, FadeLight, %FadeLight%
		GuiControl, Main:, FadeLightReal, %FadeLight%
	}
	



Gui, Add, GroupBox, ys w330 r11.5 , Distant Object Detail
Gui, Add, Text, xp+9 yp+20 Section, uGridsToLoad
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Text, , Preset
		Gui, Add, Text, , Level 4
		Gui, Add, Text, , Level 8
		if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
			Gui, Add, Text, , Level 16
		if gameName = Fallout 4
			Gui, Add, Text, , Level 32
	}
	
Gui, Add, Edit, vuGridsToLoad guGrids ys-3 w30 h20 Right Number,
uGridsToLoad_TT := "Sets how many grids will be actively rendered and processed around the Player Characer (PC).`n`n[General]`nuGridsToLoad"
if gameName = Fallout 4
	uGridsToLoad := getSettingValue("General", "uGridsToLoad", Prefs, "5")
else
	uGridsToLoad := getSettingValue("General", "uGridsToLoad", blank, "5")
GuiControl, Main:, uGridsToLoad, %uGridsToLoad%
	
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	{		
		Gui, Add, DropDownList, vFadeDistantLOD gPreset w123 ,
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			FadeDistantLOD_TT := "Changes the Distant Object Detail preset.`n`n[TerrainManager]`nfBlockLevel0Distance`nfBlockLevel1Distance`nfBlockMaximumDistance`nfSplitDistanceMult"
		else if gameName = Fallout 4
			FadeDistantLOD_TT := "Changes the Distant Object Detail preset.`n`n[TerrainManager]`nfBlockLevel0Distance`nfBlockLevel1Distance`nfBlockLevel2Distance`nfBlockMaximumDistance`nfSplitDistanceMult"
		else
			FadeDistantLOD_TT := "Changes the Distant Object Detail preset.`n`n[TerrainManager]`nfBlockLoadDistanceLow`nfBlockLoadDistance`nfSplitDistanceMult"
		
		Gui, Add, Slider, vFadeDistantLOD4 gLevel4 Section w90 yp+30 r1.5 Range4096-106496 TickInterval10240 Tooltip,
		Gui, Add, Slider, vFadeDistantLOD8 gLevel8 w90 r1.5 Range12288-348160 TickInterval32768 Tooltip,
		if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
			Gui, Add, Slider, vFadeDistantLOD16 gLevel16 w90 r1.5 Range40960-393216 TickInterval40960 Tooltip,
		if gameName = Fallout 4
			Gui, Add, Slider, vFadeDistantLOD32 gLevel32 w90 r1.5 Range81920-491520 TickInterval61440 Tooltip,
		Gui, Add, Text, yp+30, Distance Multiplier
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			Gui, Add, Text, , Decal Fade
		
		Gui, Add, Edit, vFadeDistantLOD4Real gLevel4Real ys-3 w75 Right,
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition") 
			{
				FadeDistantLOD4_TT := "Sets the maximum distance for object LOD level 4`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockLevel0Distance"
				FadeDistantLOD4Real_TT := "Sets the maximum distance for object LOD level 4`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockLevel0Distance"
			}
		else
			{
				FadeDistantLOD4_TT := "Sets the maximum distance for object LOD level 4`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockLoadDistanceLow"
				FadeDistantLOD4Real_TT := "Sets the maximum distance for object LOD level 4`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockLoadDistanceLow"
			}
		if gameName = Skyrim
			FadeDistantLOD4 := Round(getSettingValue("TerrainManager", "fBlockLevel0Distance", Prefs, "20480"),0)
		else if gameName = Skyrim Special Edition
			FadeDistantLOD4 := Round(getSettingValue("TerrainManager", "fBlockLevel0Distance", Prefs, "35000"),0)
		else if gameName = Fallout 4
			FadeDistantLOD4 := Round(getSettingValue("TerrainManager", "fBlockLevel0Distance", Prefs, "14336"),0)
		else
			FadeDistantLOD4 := Round(getSettingValue("TerrainManager", "fBlockLoadDistanceLow", Prefs, "50000"),0)
		GuiControl, Main:, FadeDistantLOD4, %FadeDistantLOD4%
		GuiControl, Main:, FadeDistantLOD4Real, %FadeDistantLOD4%

		Gui, Add, Edit, vFadeDistantLOD8Real gLevel8Real w75 Right,
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition") 
			{
				FadeDistantLOD8_TT := "Sets the maximum distance for object LOD level 4`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockLevel1Distance"
				FadeDistantLOD8Real_TT := "Sets the maximum distance for object LOD level 4`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockLevel1Distance"
			}
		else
			{
				FadeDistantLOD8_TT := "Sets the maximum distance for object LOD level 8`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockLoadDistance"
				FadeDistantLOD8Real_TT := "Sets the maximum distance for object LOD level 8`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockLoadDistance"
			}
		if gameName = Skyrim
			FadeDistantLOD8 := Round(getSettingValue("TerrainManager", "fBlockLevel1Distance", Prefs, "32768"),0)
		else if gameName = Skyrim Special Edition
			FadeDistantLOD8 := Round(getSettingValue("TerrainManager", "fBlockLevel1Distance", Prefs, "70000"),0)
		else if gameName = Fallout 4
			FadeDistantLOD8 := Round(getSettingValue("TerrainManager", "fBlockLevel1Distance", Prefs, "27876"),0)
		else
			FadeDistantLOD8 := Round(getSettingValue("TerrainManager", "fBlockLoadDistance", Prefs, "125000"),0)
		GuiControl, Main:, FadeDistantLOD8, %FadeDistantLOD8%
		GuiControl, Main:, FadeDistantLOD8Real, %FadeDistantLOD8%
		
		if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
			{
				Gui, Add, Edit, vFadeDistantLOD16Real gLevel16Real w75 Right,
				if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
					{
						FadeDistantLOD16_TT := "Sets the maximum distance for object LOD level 16`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockMaximumDistance"
						FadeDistantLOD16Real_TT := "Sets the maximum distance for object LOD level 16`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockMaximumDistance"
						if gameName = Skyrim
							FadeDistantLOD16 := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", Prefs, "100000"),0)
						else
							FadeDistantLOD16 := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", Prefs, "250000"),0)
					}
				else
					{
						FadeDistantLOD16_TT := "Sets the maximum distance for object LOD level 16`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockLevel2Distance"
						FadeDistantLOD16Real_TT := "Sets the maximum distance for object LOD level 16`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockLevel2Distance"
						FadeDistantLOD16 := Round(getSettingValue("TerrainManager", "fBlockLevel2Distance", Prefs, "83232"),0)
					}
				GuiControl, Main:, FadeDistantLOD16, %FadeDistantLOD16%
				GuiControl, Main:, FadeDistantLOD16Real, %FadeDistantLOD16%
			}
		if gameName = Fallout 4
			{
				Gui, Add, Edit, vFadeDistantLOD32Real gLevel32Real w75 Right,
				FadeDistantLOD32_TT := "Sets the maximum distance for object LOD level 32`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockMaximumDistance"
				FadeDistantLOD32Real_TT := "Sets the maximum distance for object LOD level 32`n(higher levels are farther away).`n`n[TerrainManager]`nfBlockMaximumDistance"
				FadeDistantLOD32 := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", Prefs, "100000"),0)
				GuiControl, Main:, FadeDistantLOD32, %FadeDistantLOD32%
				GuiControl, Main:, FadeDistantLOD32Real, %FadeDistantLOD32%
			}
			
		Gui, Add, Edit, vFadeDistantLODMult gDistanceMultiplier w75 Right limit5,
		FadeDistantLODMult_TT := "Sets the distance multiplier for landscape LOD levels.`n`n[TerrainManager]`nfSplitDistanceMult"
		if gameName = Skyrim Special Edition
			FadeDistantLODMult := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", Prefs, "1.5"),3)
		else
			FadeDistantLODMult := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", Prefs, "0.75"),3)
		GuiControl, Main:, FadeDistantLODMult, %FadeDistantLODMult%
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"), getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLOD16Real"), getControlValue("FadeDistantLODMult"))
		else if gameName = Fallout 4
			FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"), getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLOD32Real"), getControlValue("FadeDistantLODMult"), getControlValue("FadeDistantLOD16Real"))
		else if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"),, getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLODMult"))
		GuiControl, Main:, FadeDistantLOD, |%FadeDistantLOD%
		
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			{
				Gui, Add, DropDownList, vDecalFade gDecalDraw w75 ,
				DecalFade_TT := "Controls the distance that decals fade.`n`n[LightingShader]`nfDecalLODFadeStart`nfDecalLODFadeEnd"
				DecalFade := getDecalFade(Round(getSettingValue("LightingShader", "fDecalLODFadeStart", blank, "0.0500"), 4), Round(getSettingValue("LightingShader", "fDecalLODFadeEnd", blank, "0.0600"),4))
				GuiControl, Main:, DecalFade, %DecalFade%
			}
	}





Gui, Tab, 8 ;Visuals

if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Text, x+15 w70 Section, Gamma
		Gui, Add, Slider, vfGamma gfGamma x+m w80 h20 Range0-2000 TickInterval250,
		Gui, Add, Edit, vfGammaReal gfGammaReal x+m w50 yp-3,
		fGamma_TT := "Sets the gamma (brightness/darkness).`n`n[Display]`nfGamma"
		fGammaReal_TT := "Sets the gamma (brightness/darkness).`n`n[Display]`nfGamma"
		fGamma := Round(getSettingValue("Display", "fGamma", Prefs, "1"),4)*1000
		fGammaReal := Round(getSettingValue("Display", "fGamma", Prefs, "1"),4)
		GuiControl, Main:, fGamma, %fGamma%
		GuiControl, Main:, fGammaReal, %fGammaReal%
	}
if gameName = Skyrim Special Edition
	{
		Gui, Add, Text, xs w70, Brightness
		Gui, Add, Slider, vfGlobalBrightnessBoost gfGlobalBrightnessBoost x+m w80 h20 Range-1000-1000 TickInterval250,
		Gui, Add, Edit, vfGlobalBrightnessBoostReal gfGlobalBrightnessBoostReal x+m w50 yp-3,
		fGlobalBrightnessBoost_TT := "Sets the global brightness boost modifier.`n`n[Display]`nfGlobalBrightnessBoost"
		fGlobalBrightnessBoostReal_TT := "Sets the global brightness boost modifier.`n`n[Display]`nfGlobalBrightnessBoost"
		fGlobalBrightnessBoost := Round(getSettingValue("Display", "fGlobalBrightnessBoost", blank, "0"),4)*1000
		fGlobalBrightnessBoostReal := Round(getSettingValue("Display", "fGlobalBrightnessBoost", blank, "0"),4)
		GuiControl, Main:, fGlobalBrightnessBoost, %fGlobalBrightnessBoost%
		GuiControl, Main:, fGlobalBrightnessBoostReal, %fGlobalBrightnessBoostReal%
		
		Gui, Add, Text, xp+75 ys w70, Contrast
		Gui, Add, Text, w70, Saturation
		
		Gui, Add, Slider, vfGlobalContrastBoost gfGlobalContrastBoost ys w80 h20 Range-1000-1000 TickInterval250,
		Gui, Add, Slider, vfGlobalSaturationBoost gfGlobalSaturationBoost w80 h20 Range-1000-1000 TickInterval250,
		
		Gui, Add, Edit, vfGlobalContrastBoostReal gfGlobalContrastBoostReal ys-3 w50 ,
		fGlobalContrastBoost_TT := "Sets the global contrast boost modifier.`n`n[Display]`nfGlobalContrastBoost"
		fGlobalContrastBoostReal_TT := "Sets the global contrast boost modifier.`n`n[Display]`nfGlobalContrastBoost"
		fGlobalContrastBoost := Round(getSettingValue("Display", "fGlobalContrastBoost", blank, "0"),4)*1000
		fGlobalContrastBoostReal := Round(getSettingValue("Display", "fGlobalContrastBoost", blank, "0"),4)
		GuiControl, Main:, fGlobalContrastBoost, %fGlobalContrastBoost%
		GuiControl, Main:, fGlobalContrastBoostReal, %fGlobalContrastBoostReal%

		Gui, Add, Edit, vfGlobalSaturationBoostReal gfGlobalSaturationBoostReal w50,
		fGlobalSaturationBoost_TT := "Sets the global saturation boost modifier.`n`n[Display]`nfGlobalSaturationBoost"
		fGlobalSaturationBoostReal_TT := "Sets the global saturation boost modifier.`n`n[Display]`nfGlobalSaturationBoost"
		fGlobalSaturationBoost := Round(getSettingValue("Display", "fGlobalSaturationBoost", blank, "0"),4)*1000
		fGlobalSaturationBoostReal := Round(getSettingValue("Display", "fGlobalSaturationBoost", blank, "0"),4)
		GuiControl, Main:, fGlobalSaturationBoost, %fGlobalSaturationBoost%
		GuiControl, Main:, fGlobalSaturationBoostReal, %fGlobalSaturationBoostReal%

		
	}
if gameName = Fallout 4
	Gui, Add, GroupBox, w310 r5.5 , Grass
if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	Gui, Add, GroupBox, xs-9 yp+30 w310 r5.5 , Grass
	
Gui, Add, Checkbox, vRemoveGrass gRemoveGrass xp+9 yp+20 Section , Remove Grass
if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	{
		RemoveGrass_TT := "Toggles grass rendering.`n`n[Grass]`nbAllowCreateGrass`nbAllowLoadGrass`nbDrawShaderGrass"
		RemoveGrass := getGrass(getSettingValue("Grass", "bDrawShaderGrass", blank, "1"), getSettingValue("Grass", "bAllowLoadGrass", blank, "1"), getSettingValue("Grass", "bAllowCreateGrass", blank, "0"))
	}
else
	{
		RemoveGrass_TT := "Toggles grass rendering.`n`n[Grass]`nbDrawShaderGrass"
		RemoveGrass := Abs(getSettingValue("Grass", "bDrawShaderGrass", blank, "1") - 1)
	}
GuiControl, Main:, RemoveGrass, %RemoveGrass%
Gui, Add, Text, , Grass Density
Gui, Add, Text, , Grass Diversity
if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	Gui, Add, Text, , Grass Wind Speed

if gameName = Skyrim Special Edition
	{
		Gui, Add, Checkbox, vbEnableGrassFade gbEnableGrassFade ys , Fade-In
		bEnableGrassFade_TT := "Toggles the gradual, fade-in effect for grass.`n`n[Grass]`nbEnableGrassFade"
		bEnableGrassFade := getSettingValue("Grass", "bEnableGrassFade", blank, "1")
		GuiControl, Main:, bEnableGrassFade, %bEnableGrassFade%
	}
if gameName = Skyrim Special Edition
	Gui, Add, Slider, vGrassDensity gGrassDensity w90 r1.5 Range0-120 TickInterval20 Tooltip, 
else
	Gui, Add, Slider, vGrassDensity gGrassDensity ys+18 w90 r1.5 Range0-120 TickInterval20 Tooltip, 
Gui, Add, Slider, vGrassDiversity gGrassDiversity w90 r1.5 Range0-15 TickInterval2 Tooltip, 
if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, DropDownList, vGrassWindSpeed gGrassWindSpeed w90 , 
		GrassWindSpeed_TT := "Controls how much grass moves in the wind.`n`n[Grass]`nfGrassWindMagnitudeMin`nfGrassWindMagnitudeMax"
		GrassWindSpeed := getGrassWindSpeed(Round(getSettingValue("Grass", "fGrassWindMagnitudeMin", blank, "5"),0), Round(getSettingValue("Grass", "fGrassWindMagnitudeMax", blank, "125"),0))
		GuiControl, Main:, GrassWindSpeed, %GrassWindSpeed%
	}
	
Gui, Add, Edit, vGrassDensityReal gGrassDensityReal ys+18 w25 Right, 
GrassDensity_TT := "Sets the grass density.`n`n[Grass]`niMinGrassSize"
GrassDensityReal_TT := "Sets the grass density.`n`n[Grass]`niMinGrassSize"
if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	GrassDensity := Round(getSettingValue("Grass", "iMinGrassSize", blank, "20"),0)
else
	GrassDensity := Round(getSettingValue("Grass", "iMinGrassSize", blank, "80"),0)
GuiControl, Main:, GrassDensity, %GrassDensity%
GuiControl, Main:, GrassDensityReal, %GrassDensity%

Gui, Add, Edit, vGrassDiversityReal gGrassDiversityReal w25 Right Number, 
GrassDiversity_TT := "Sets the maximum diversity of grass types.`n`n[Grass]`niMaxGrassTypesPerTexure"
GrassDiversityReal_TT := "Sets the maximum diversity of grass types.`n`n[Grass]`niMaxGrassTypesPerTexure"
GrassDiversity := Round(getSettingValue("Grass", "iMaxGrassTypesPerTexure", blank, "2"),0)
GuiControl, Main:, GrassDiversity, %GrassDiversity%
GuiControl, Main:, GrassDiversityReal, %GrassDiversity%

if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim" or gameName = "Oblivion" or gameName = "Skyrim Special Edition")
	Gui, Add, GroupBox, w310 r5.5 ys-20 xs+320, Trees

if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	Gui, Add, Text, xp+9 yp+20 Section, Far-off Tree Distance

if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, Text, , Tree Detail Fade
		Gui, Add, Checkbox, vDynamicTrees gDynamicTrees yp+24, Dynamic Trees
		DynamicTrees_TT := "Toggles between dynamic and static tree model rendering.`n`n[Trees]`nbEnableTrees`nbEnableTreeAnimations"
		DynamicTrees := getDynamicTrees(getSettingValue("Trees", "bEnableTrees", blank, "1"), getSettingValue("Trees", "bEnableTreeAnimations", blank, "1"))
		GuiControl, Main:, DynamicTrees, %DynamicTrees%
		Gui, Add, Checkbox, vSkinnedTrees gSkinnedTrees , Skinned Trees
		SkinnedTrees_TT := "Toggles the rendering of enhanced tree detail.`n`n[Trees]`nbRenderSkinnedTrees"
		SkinnedTrees := getSettingValue("Trees", "bRenderSkinnedTrees", Prefs, "1")
		GuiControl, Main:, SkinnedTrees, %SkinnedTrees%
	}

if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		Gui, Add, ComboBox, vFarOffTreeDistance gFarOffTreeDistance ys-3 w130 , 
		FarOffTreeDistance_TT := "Sets the distance that far-off trees are rendered.`n`n[TerrainManager]`nfTreeLoadDistance"
		FarOffTreeDistance := sortNumberedList("12500|25000|40000|75000", Round(getSettingValue("TerrainManager", "fTreeLoadDistance", Prefs, "25000"),0))
		GuiControl, Main:, FarOffTreeDistance, %FarOffTreeDistance%
	}	
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{		
		Gui, Add, DropDownList, vTreeDetailFade gTreeDetailFade w130 , 
		TreeDetailFade_TT := "Controls the distance at which tree detail fades.`n`n[Display]`nfMeshLODLevel1FadeTreeDistance`nfMeshLODLevel2FadeTreeDistance`nfTreesMidLODSwitchDist`nuiMaxSkinnedTreesToRender"
		TreeDetailFade := getTreeDetailFade(Round(getSettingValue("Display", "fMeshLODLevel1FadeTreeDistance", Prefs, "2844"),0), Round(getSettingValue("Display", "fMeshLODLevel2FadeTreeDistance", Prefs, "2048"),0), Round(getSettingValue("Display", "fTreesMidLODSwitchDist", Prefs, "3600"),0), Round(getSettingValue("Trees", "uiMaxSkinnedTreesToRender", Prefs, "40"),0))
		GuiControl, Main:, TreeDetailFade, %TreeDetailFade%
		
		Gui, Add, Checkbox, vTreeAnimations gTreeAnimations , Tree Animations
		TreeAnimations_TT := "Toggles tree animations.`n`n[Trees]`nfUpdateBudget"
		TreeAnimations := Round(getSettingValue("Trees", "fUpdateBudget", blank, "1.5"),1)
		if TreeAnimations > 0
			TreeAnimations = 1
		else
			TreeAnimations = 0
		GuiControl, Main:, TreeAnimations, %TreeAnimations%
	}

if gameName = Oblivion
	{
		Gui, Add, Checkbox, vbEnableTrees gbEnableTrees xp+9 yp+20 Section, Trees
		bEnableTrees_TT := "Toggles trees.`n`n[SpeedTree]`nbEnableTrees"
		bEnableTrees := getSettingValue("SpeedTree", "bEnableTrees", blank, "1")
		GuiControl, Main:, bEnableTrees, %bEnableTrees%
		Gui, Add, Checkbox, vbForceFullLOD gbForceFullLOD , Force Full LOD
		bForceFullLOD_TT := "Forces full distant tree detail.`n`n[SpeedTree]`nbForceFullLOD"
		bForceFullLOD := getSettingValue("SpeedTree", "bForceFullLOD", blank, "1")
		GuiControl, Main:, bForceFullLOD, %bForceFullLOD%
	}

if gameName = Skyrim Special Edition
	{
		Gui, Add, GroupBox, w530 r4.5 yp+65 xs-338, Snow

		Gui, Add, Checkbox, vbEnableProjecteUVDiffuseNormals gbEnableProjecteUVDiffuseNormals xp+9 yp+20 h23 Section, Projected UV Diffuse Normals
		bEnableProjecteUVDiffuseNormals_TT := "Toggles the use of projected UV diffuse normals. It is recommended to leave this enabled.`nSome mods missing an appropriate projecteddiffuse.dds texture can cause this feature to look bugged.`n`n[Display]`nbEnableProjecteUVDiffuseNormals"
		bEnableProjecteUVDiffuseNormals := getSettingValue("Display", "bEnableProjecteUVDiffuseNormals", Prefs, "1")
		GuiControl, Main:, bEnableProjecteUVDiffuseNormals, %bEnableProjecteUVDiffuseNormals%

		Gui, Add, Checkbox, vbEnableImprovedSnow gbEnableImprovedSnow x+m h23, Improved Shader
		bEnableImprovedSnow_TT := "Toggles the improved snow shader.`nPlease note that ""improved"" is highly subjective in this case.`nIt is recommended to disable this in most cases.`n`n[Display]`nbEnableImprovedSnow"
		bEnableImprovedSnow := getSettingValue("Display", "bEnableImprovedSnow", Prefs, "1")
		GuiControl, Main:, bEnableImprovedSnow, %bEnableImprovedSnow%		
		
		Gui, Add, Checkbox, vbEnableSnowMask gbEnableSnowMask x+m h23, Snow Mask
		bEnableSnowMask_TT := "Toggles the snow mask. This adds an effect to certain landscapes around snow.`n`n[Display]`nbEnableSnowMask"
		bEnableSnowMask := getSettingValue("Display", "bEnableSnowMask", blank, "1")
		GuiControl, Main:, bEnableSnowMask, %bEnableSnowMask%	
		
		Gui, Add, Checkbox, vbDeactivateAOOnSnow gbDeactivateAOOnSnow x+m h23, Snow AO
		bDeactivateAOOnSnow_TT := "Toggles ambient occlusion on snow. This toggle only works when using the improved shader.`nOtherwise, ambient occlusion will always work on snow.`n`n[Display]`nbDeactivateAOOnSnow"
		bDeactivateAOOnSnow := abs(getSettingValue("Display", "bDeactivateAOOnSnow", blank, "1")-1)
		GuiControl, Main:, bDeactivateAOOnSnow, %bDeactivateAOOnSnow%	
		
		Gui, Add, Checkbox, vbToggleSparkles gbToggleSparkles xs w105 h14, Sparkles
		bToggleSparkles_TT := "Toggles snow sparkles.`n`n[Display]`nbToggleSparkles"
		bToggleSparkles := getSettingValue("Display", "bToggleSparkles", Prefs, "1")
		GuiControl, Main:, bToggleSparkles, %bToggleSparkles%
		
		Gui, Add, Text, x+m , Intensity
		Gui, Add, ComboBox, vfSparklesIntensity gfSparklesIntensity x+m yp-3 w55 ,
		fSparklesIntensity_TT := "Sets the intensity of snow sparkles.`n`n[Display]`nfSparklesIntensity"
		fSparklesIntensity := sortNumberedList("0.20|0.30|0.50|0.90|1.00", Round(getSettingValue("Display", "fSparklesIntensity", blank, "1.00"),2))
		GuiControl, Main:, fSparklesIntensity, %fSparklesIntensity%
		
		Gui, Add, Text, x+m yp+3 w63, Density
		Gui, Add, Edit, vfSparklesDensity gfSparklesDensity x+m yp-3 w55,
		fSparklesDensity_TT := "Sets the density of snow sparkles. Lower values increase density.`nHigher values decrease density. This is very sensitive!`nDo not stray very far from the default value of 0.85.`n`n[Display]`nfSparklesDensity"
		fSparklesDensity := Round(getSettingValue("Display", "fSparklesDensity", blank, "0.85"),2)
		GuiControl, Main:, fSparklesDensity, %fSparklesDensity%
		
		Gui, Add, Text, x+m yp+3 w63, Size
		Gui, Add, Edit, vfSparklesSize gfSparklesSize x+m yp-3 w55,
		fSparklesSize_TT := "Sets the size of snow sparkles. Lower values create bigger sparkles.`nHigher values create smaller sparkles that are more sparkly.`n`n[Display]`nfSparklesSize"
		fSparklesSize := Round(getSettingValue("Display", "fSparklesSize", blank, "6"),2)
		GuiControl, Main:, fSparklesSize, %fSparklesSize%
		
		Gui, Add, Checkbox, vbEnableSnowRimLighting gbEnableSnowRimLighting xs w105 h14 , Rim Lighting
		bEnableSnowRimLighting_TT := "Toggles snow rim lighting.`n`n[Display]`nbEnableSnowRimLighting"
		bEnableSnowRimLighting := getSettingValue("Display", "bEnableSnowRimLighting", blank, "1")
		GuiControl, Main:, bEnableSnowRimLighting, %bEnableSnowRimLighting%
		
		Gui, Add, Text, x+m , Intensity
		Gui, Add, Edit, vfSnowRimLightIntensity gfSnowRimLightIntensity x+m yp-3 w55,
		fSnowRimLightIntensity_TT := "Sets the intensity of snow rim lighting.`n`n[Display]`nfSnowRimLightIntensity"
		fSnowRimLightIntensity := Round(getSettingValue("Display", "fSnowRimLightIntensity", blank, "0.3"),2)
		GuiControl, Main:, fSnowRimLightIntensity, %fSnowRimLightIntensity%
		
		Gui, Add, Text, x+m yp+3 w63, Geometry
		Gui, Add, Edit, vfSnowGeometrySpecPower gfSnowGeometrySpecPower x+m yp-3 w55 ,
		fSnowGeometrySpecPower_TT := "Sets the power of gloss/rim lighting on snow-covered geometry.`nHigher values are darker. Lower values are brighter.`n`n[Display]`nfSnowGeometrySpecPower"
		fSnowGeometrySpecPower := Round(getSettingValue("Display", "fSnowGeometrySpecPower", blank, "3"),2)
		GuiControl, Main:, fSnowGeometrySpecPower, %fSnowGeometrySpecPower%
		
		Gui, Add, Text, x+m yp+3 w63, Landscape
		Gui, Add, Edit, vfSnowNormalSpecPower gfSnowNormalSpecPower x+m yp-3 w55 ,
		fSnowNormalSpecPower_TT := "Sets the power of gloss/rim lighting on snow-covered landscape.`nHigher values are darker. Lower values are brighter.`n`n[Display]`nfSnowNormalSpecPower"
		fSnowNormalSpecPower := Round(getSettingValue("Display", "fSnowNormalSpecPower", blank, "2"),2)
		GuiControl, Main:, fSnowNormalSpecPower, %fSnowNormalSpecPower%

		
	}

	
	


	

	

	
Gui, Tab, 9 ;Custom
Gui, Add, Text, , Welcome to the Custom Tab! This is where all the tinkerers will be able to have all kinds of fun!`nSimply select the INI section and INI setting, and you can edit any legitimate setting you want.`nTweak at your own risk.
Gui, Add, Text, Section, Section
Gui, Add, Text, , Setting
Gui, Add, DropDownList, vSectionNames gSectionNames ys-3 w140 , 
SectionNames_TT := "Select the section."
IniRead, SectionNames1, % "Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . ".ini"
IniRead, SectionNames2, % "Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . Prefs . ".ini"
StringReplace, SectionNames1, SectionNames1, `n, |, All
StringReplace, SectionNames2, SectionNames2, `n, |, All
SectionNames := SectionNames1 . "|" . SectionNames2
Sort, SectionNames, D| U
GuiControl, Main:, SectionNames, %SectionNames%


Gui, Add, DropDownList, vSettingNames gSettingNames w477 , 
SettingNames_TT := "Select the setting."
SectionName := getControlValue("SectionNames")
if SectionName !=
	{
		IniRead, SettingNames1, % "Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . ".ini", %SectionName%
		IniRead, SettingNames2, % "Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . Prefs . ".ini", %SectionName%
		SettingNames = %SettingNames1%`n%SettingNames2%
		StringReplace, SettingNames, SettingNames, `n, |, All
		Sort, SettingNames, D| U
		SettingNames := LTrim(RegExReplace(SettingNames, "=[^\|]*", "|"), "|")
		GuiControl, Main:, SettingNames, |%SettingNames%
	}
else
	{
		GuiControl, Main:, SettingNames, |%blank%
		GuiControl, Disable, SettingNames
	}

Gui, Add, Edit, vCustomSettingValue gCustomSettingValue xs r8 w530,
CustomSettingValue_TT := ""
SectionName := getControlValue("SectionNames")
SettingName := getControlValue("SettingNames")
if SettingName !=
	{
		DefaultValue := getSettingValue(SectionName, SettingName, gameNameINIWorkaroundForEnderalForgotten, "DoesNotExist", "Presets\" . gameName . "\")
		if DefaultValue = DoesNotExist
			DefaultValue := getSettingValue(SectionName, SettingName, gameNameINIWorkaroundForEnderalForgotten . Prefs, "Failed to retrieve a default value.", "Presets\" . gameName . "\")
		CurrentValue := getSettingValue(SectionName, SettingName, Prefs, DefaultValue)
		GuiControl, Main:, CustomSettingValue, %CurrentValue%
	}
else
	{
		GuiControl, Main:, CustomSettingValue, %blank%
		GuiControl, Disable, CustomSettingValue
	}
Gui, Add, Button, vButtonConfirmCustom gButtonConfirmCustom w530 h30 , Save
ButtonConfirmCustom_TT := "Saves the value for the selected setting."
	
Gui, Add, StatusBar, vStatusBar,
OnMessage(0x200, "WM_MOUSEMOVE")
GuiControl, Disable, CustomTab
Gui, Show


if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	disableGuiControl("DecalQuantity", getControlValue("bDecals"))

if gameName = Skyrim Special Edition
	{
		disableGuiControl("HalfRate", getControlValue("iPresentInterval"))
		enableGuiControl("ShadowLand", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowTrees", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowRes", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowBias", getControlValue("ShadowRemoval"))
		enableGuiControl("fFirstSliceDistance", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowExDist", getControlValue("ShadowRemoval"))
		disableGuiControl("SkinnedTrees", getControlValue("DynamicTrees"))
		disableGuiControl("TreeAnimations", getControlValue("DynamicTrees"))
		disableGuiControl("TreeDetailFade", getControlValue("DynamicTrees"))
		disableGuiControl("fSparklesIntensity", getControlValue("bToggleSparkles"))
		disableGuiControl("fSparklesSize", getControlValue("bToggleSparkles"))
		disableGuiControl("fSparklesDensity", getControlValue("bToggleSparkles"))
		disableGuiControl("fSnowRimLightIntensity", getControlValue("bEnableSnowRimLighting"))
		disableGuiControl("fSnowNormalSpecPower", getControlValue("bEnableSnowRimLighting"))
		disableGuiControl("fSnowGeometrySpecPower", getControlValue("bEnableSnowRimLighting"))
		disableGuiControl("bToggleSparkles", getControlValue("bEnableImprovedSnow"))
		disableGuiControl("bDeactivateAOOnSnow", getControlValue("bEnableImprovedSnow"))
		disableGuiControl("bEnableSnowRimLighting", getControlValue("bEnableImprovedSnow"))
		disableGuiControl("bEnableSnowMask", getControlValue("bEnableImprovedSnow"))
		disableGuiControl("fSunShadowUpdateTime", getControlValue("bDisableShadowJumps"))
		disableGuiControl("fSunUpdateThreshold", getControlValue("bDisableShadowJumps"))
		disableGuiControl("iReflectionResolutionDivider", getControlValue("bScreenSpaceReflectionEnabled"))
	}
	
if gameName = Skyrim
	{
		enableGuiControl("ShadowDeffer", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowLand", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowGrass", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowTrees", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowRes", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowBlur", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowBias", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowExDist", getControlValue("ShadowRemoval"))
		disableGuiControl("ShadowLand", getControlValue("ShadowDeffer"))
		disableGuiControl("ShadowGrass", getControlValue("ShadowDeffer"))
		disableGuiControl("SkinnedTrees", getControlValue("DynamicTrees"))
		disableGuiControl("TreeAnimations", getControlValue("DynamicTrees"))
		disableGuiControl("TreeDetailFade", getControlValue("DynamicTrees"))
		
		IfExist, %gameFolder%enblocal.ini
			{
				if getSettingValue("GLOBAL", "UsePatchSpeedhackWithoutGraphics", "enblocal", "true", gameFolder) = "true"
					sm("ENB is set for ENBoost mode. ENB Mode shall be unchecked.")
				else
					{
						sm("ENB is turned on in ENBlocal.ini. ENB Mode shall be checked.")
						GuiControl, Main:, MaintainENBCompatibility, 1
						Gosub, MaintainENBCompatibility
					}
			}
	}
if gameName = Oblivion
	{
		disableGuiControl("IntroMusic", getControlValue("bMusicEnabled"))
		
		if checkForPlugin("OblivionReloaded.esp") = 1
			{
				sm("Oblivion Reloaded was detected. Changing settings accordingly.")
				GuiControl, Main:, Antialiasing, None||2x|4x|8x|16x
				GuiControl, Disable, Antialiasing
				Gosub, Antialiasing
				GuiControl, Main:, ShadowGrass, 0
				GuiControl, Disable, ShadowGrass
				Gosub, GrassShadows
				GuiControl, Main:, bUseWaterHiRes, 1
				GuiControl, Disable, bUseWaterHiRes
				Gosub, bUseWaterHiRes
				
				IniWrite, 1, %INIfolder%%gameNameINI%.ini, Water, bUseWaterReflections
			}
	}




Gui, Summary:New,, Summary of Changes
Gui, Font, s8, Courier New
Gui, Font, s8, Verdana
Gui, Font, s8, Arial
Gui, Font, s8, Segoe UI
Gui, Font, s8, Tahoma
Gui, Font, s8, Microsoft Sans Serif


Gui, Add, Text, , Summary of Changes Made this session:
Gui, Add, Button, vButtonRefreshSummary gButtonRefreshSummary w100, Refresh
ButtonRefreshSummary_TT := "Click this to refresh the summary of changes made this session."
if gameName != Oblivion
	Gui, Add, Tab2, w380 r15, %gameNameINI%.ini|%gameNameINI%Prefs.ini|Log
else
	Gui, Add, Tab2, w380 r15, %gameNameINI%|Log

Gui, Add, Edit, ReadOnly r21 vGameNameINITab w355, This will not populate until you click the Refresh button above.

if gameName != Oblivion
	{
		Gui, Tab, %gameNameINI%Prefs.ini
		Gui, Add, Edit, ReadOnly r21 vGameNameINIPrefsTab w355, This will not populate until you click the Refresh button above.
	}

Gui, Tab, Log
Gui, Add, Edit, ReadOnly r21 vLogTab w355,

Gui, Show, w400 h390

WinGetPos, BethINIXPos, BethINIYPos, BethINIWidth, BethINIHeight, %projectName%
WinMove, Summary of Changes, , % BethINIXPos + BethINIWidth, BethINIYPos

/*
;This debug list caused a bug where the user installed it to the game folder, causing the script to go on for hours listing every file in the folder. Simply commenting it out since it is unnecessary except for debug purposes.
sm("Files contained in " . A_ScriptDir . "\:`n")
Loop, Files, %A_ScriptDir%\*, R
	{
		Dir := StrReplace(A_LoopFileDir, A_ScriptDir)
		sm(Dir . "\" . A_LoopFileName)
	}
*/
FileRead, BethINIini, %scriptName%.ini
sm("Contents of BethINI.ini:`n" . BethINIini)
SplashTextOff
GuiControl, Enable, CustomTab
sm(shortName . " startup completed.")
if getSettingValueProject("General", "bUpdateCheck", "1") = 1
	checkForUpdate()
	


return

ChooseGameClose:
ExitApp

MainGuiClose:
ButtonCancel:
if GameStart !=
	{
		MsgBox, 4, Keep Changes?, Do you want to keep the changes you've made? (Clicking No will revert your INIs back to the way they were).
		IfMsgBox, No
			{
				Restore()
				ExitApp
			}
		FixINI()
	}
ExitApp

ButtonSaveandExit:
FixINI()
sm("Your INI files were successfully saved.")
/*
MsgBox, 4, Open Manual Editor?, Do you want to open the Manual Editor?
	IfMsgBox, Yes
		{
			Gosub, ApproveChanges
		}
*/
ExitApp

ButtonDefault:
Spin()
GuiControl, Main:, RecommendedTweaks, 0
return

ButtonRefreshSummary:
GuiControl, Summary:, GameNameINITab, %blank%
if Summary(INIfolder . shortName . " Cache\" . theTime . "\" . gameNameINI . ".ini") = 1
	{
		GuiControl, Summary:, GameNameINITab, %blank%
		GuiControl, Main:, bDeleteInvalidSettingsOnSummary, 0
		Summary(INIfolder . shortName . " Cache\" . theTime . "\" . gameNameINI . ".ini")
	}
if gameName != Oblivion
	{
		GuiControl, Summary:, GameNameINIPrefsTab, %blank%
		if Summary(INIfolder . shortName . " Cache\" . theTime . "\" . gameNameINI . Prefs . ".ini", Prefs) = 1
			{
				GuiControl, Summary:, GameNameINIPrefsTab, %blank%
				GuiControl, Main:, bDeleteInvalidSettingsOnSummary, 0
				Summary(INIfolder . shortName . " Cache\" . theTime . "\" . gameNameINI . Prefs . ".ini", Prefs)
			}
	}
return

ButtonPoor:
VanillaPresets := getControlValue("VanillaPresets")
setPreset(VanillaPresets, "0")
return

ButtonLow:
VanillaPresets := getControlValue("VanillaPresets")
setPreset(VanillaPresets, "1")
return

ButtonMedium:
VanillaPresets := getControlValue("VanillaPresets")
setPreset(VanillaPresets, "2")
return

ButtonHigh:
VanillaPresets := getControlValue("VanillaPresets")
setPreset(VanillaPresets, "3")
return

ButtonUltra:
VanillaPresets := getControlValue("VanillaPresets")
setPreset(VanillaPresets, "4")
return

GameStart:
GameStart := getControlValue("GameStart")
return

Game:
Game := getControlValue("Game")
if (isEnderalForgotten = 1)
	gameNameEnderalSelection := "Enderal: Forgotten Stories"
else
	gameNameEnderalSelection := gameNameEnderalWorkaround
if (Game <> gameNameEnderalSelection)
	{
		IniWrite, %Game%, %scriptName%.ini, General, sGameName
		IniWrite, 1, %scriptName%.ini, General, sRestartedFromSetupTab
		IniDelete, %scriptName%.ini, Directories, sGamePath
		Restore()
		sm("Game changed. Application will restart.")
		MsgBox, Game changed. Application will restart.
		Reload
	}
return

GamePath:
GamePath := getControlValue("GamePath")
if GamePath = Browse...
	{
		FileSelectFile, GameFile, 1, %gameNameLauncher%Launcher.exe, Select %gameNameLauncher%Launcher.exe, (*.exe)
		if ErrorLevel <> 0
			{
				sm("No location specified, so the Game Path was not modified.")
				return
			}
		SplitPath, GameFile, GameFile, gamePath
		gamePath .= "\"
		IniWrite, %gamePath%, %scriptName%.ini, Directories, sGamePath
		if isEnderalForgotten = 1
			IniWrite, %gamePath%, %scriptName%.ini, Directories, sEnderalForgottenStoriesGamePath
		IniWrite, 1, %scriptName%.ini, General, sRestartedFromSetupTab
		Restore()
		sm("Game Path changed. Application will restart.")
		MsgBox, Game Path changed. Application will restart.
		Reload
		return
	}
return

MOPath:
MOPath := getControlValue("MOPath")
if MOPath = Browse...
	{
		FileSelectFile, MOEXE, 1, ModOrganizer.exe, Select ModOrganizer.exe, (ModOrganizer.exe)
		if ErrorLevel <> 0
			{
				sm("No location specified, so the Mod Organizer path was not modified.")
				return
			}
		SplitPath, MOEXE, MOEXE, x
		IniWrite, %x%\, %scriptName%.ini, Directories, s%gameNameReg%ModOrganizerPath
		sm("Mod Organizer path set to " . x . "\")
		global modOrganizerFolder := x . "\"
		global profilesFolder := getProfilesFolder()
		GuiControl, Main:, MOPath, % "|" . x . "\||Browse..."
		INIPathFolder := INIfolder
		if INIPathFolder contains %profilesFolder%
			{
				StringReplace, INIPathFolder, INIPathFolder, % profilesFolder, % "ModOrganizer > ", All
				StringReplace, INIPathFolder, INIPathFolder, % "\", % blank, All
			}
		INIPath := INIPathFolder . "|" . A_MyDocuments . "\My Games\" . gameNameReg . "\|" . getProfiles()
		Sort, INIPath, U D|
		StringReplace, INIPath, INIPath, % INIPathFolder, % INIPathFolder . "|", All
		if getProfiles() = blank
			INIPath := "|" . INIPath . "Browse..."
		else
			INIPath := "|" . INIPath . "|Browse..."
		INIPath := StrReplace(INIPath, "||" , "|",, "1")
		GuiControl, Main:, INIPath, %INIPath%
	}
return
		
INIPath:
INIPath := getControlValue("INIPath")
if INIPath = Browse...
	{
		FileSelectFile, INIfile, 1, %gameNameINI%.ini, Select %gameNameINI%.ini, (%gameNameINI%.ini)
		if ErrorLevel <> 0
			{
				sm("No location specified, so the INI Path was not modified.")
				return
			}
		SplitPath, INIfile, INIfile, x
		INIPath = %x%\
		if (INIPath = INIfolder)
			return
		IniWrite, %INIPath%, %scriptName%.ini, Directories, s%gameNameEnderalWorkaround%GameSettingsPath
		IniWrite, 1, %scriptName%.ini, General, sRestartedFromSetupTab
		Restore()
		sm("INI Path changed. Application will restart.")
		MsgBox, INI Path changed. Application will restart.
		Reload
		return
	}
else if INIPath contains ModOrganizer >
	{
		INIPath := StrReplace(INIPath, "ModOrganizer > ", profilesFolder . "\",,"1") . "\"
		sm("INI Path set to " . INIPath)
		if (INIPath = INIfolder)
			return
		IniWrite, %INIPath%, %scriptName%.ini, Directories, s%gameNameEnderalWorkaround%GameSettingsPath
		IniWrite, 1, %scriptName%.ini, General, sRestartedFromSetupTab
		Restore()
		sm("INI Path changed. Application will restart.")
		MsgBox, INI Path changed. Application will restart.
		Reload
		return
	}
else if (INIPath = A_MyDocuments . "\My Games\" . gameNameReg . "\")
	{
		if (INIPath = INIfolder)
			return
		IniWrite, %INIPath%, %scriptName%.ini, Directories, s%gameNameEnderalWorkaround%GameSettingsPath
		IniWrite, 1, %scriptName%.ini, General, sRestartedFromSetupTab
		Restore()
		sm("INI Path changed. Application will restart.")
		MsgBox, INI Path changed. Application will restart.
		Reload
		return
	}
return

RestoreBackup:
RestoreBackup := getControlValue("RestoreBackup")
sm("Restoring the backup labeled " . RestoreBackup)
IfExist, %INIfolder%%shortName% Cache\%RestoreBackup%\%gameNameINI%.ini
	FileMove, %INIfolder%%shortName% Cache\%RestoreBackup%\%gameNameINI%.ini, %INIfolder%%gameNameINI%.ini, 1
IfExist, %INIfolder%%shortName% Cache\%RestoreBackup%\%gameNameINI%Custom.ini
	FileMove, %INIfolder%%shortName% Cache\%RestoreBackup%\%gameNameINI%Custom.ini, %INIfolder%%gameNameINI%Custom.ini, 1
IfExist, %INIfolder%%shortName% Cache\%RestoreBackup%\Custom.ini
	FileMove, %INIfolder%%shortName% Cache\%RestoreBackup%\Custom.ini, %INIfolder%Custom.ini, 1
IfExist, %INIfolder%%shortName% Cache\%RestoreBackup%\%gameNameINI%Prefs.ini
	FileMove, %INIfolder%%shortName% Cache\%RestoreBackup%\%gameNameINI%Prefs.ini, %INIfolder%%gameNameINI%Prefs.ini, 1
IfExist, %INIfolder%%shortName% Cache\%RestoreBackup%\%gameNameINI%Editor.ini
	FileMove, %INIfolder%%shortName% Cache\%RestoreBackup%\%gameNameINI%Editor.ini, %INIfolder%%gameNameINI%Editor.ini, 1
IfExist, %INIfolder%%shortName% Cache\%RestoreBackup%\%gameNameINI%EditorPrefs.ini
	FileMove, %INIfolder%%shortName% Cache\%RestoreBackup%\%gameNameINI%EditorPrefs.ini, %INIfolder%%gameNameINI%EditorPrefs.ini, 1
sm("Your INI files have been reverted back " . RestoreBackup . ". BethINI shall now close.")
Sleep, 4000
ExitApp
return

FixCreationKit:
FixCreationKit := getControlValue("FixCreationKit")
IniWrite, %FixCreationKit%, %scriptName%.ini, General, bCreationKit
if FixCreationKit = 1
	sm("Creation Kit files shall be modified upon saving and exiting " . shortName . ".")
else if FixCreationKit = 0
	sm("Creation Kit files shall NOT be modified upon saving and exiting " . shortName . ".")
return

RdOnly:
RdOnly := getControlValue("RdOnly")
global RedOnly := RdOnly
if RdOnly = 1
	sm("INI files shall be set to read-only.")
else
	sm("INI files shall not be set to read-only.")
return

bUpdateCheck:
bUpdateCheck := getControlValue("bUpdateCheck")
IniWrite, %bUpdateCheck%, %scriptName%.ini, General, bUpdateCheck
if bUpdateCheck = 1
	sm("BethINI will automatically check for updates at startup.")
else if bUpdateCheck = 0
	sm("BethINI will not automatically check for updates at startup.")
return

bAlwaysSelectGame:
bAlwaysSelectGame := getControlValue("bAlwaysSelectGame")
IniWrite, %bAlwaysSelectGame%, %scriptName%.ini, General, bAlwaysSelectGame
if bAlwaysSelectGame = 1
	sm("BethINI will always ask you to choose your game at startup.")
else if bAlwaysSelectGame = 0
	sm("BethINI will not always ask you to choose your game at startup.")
return

bModifyCustomINIs:
bModifyCustomINIs := getControlValue("bModifyCustomINIs")
IniWrite, %bModifyCustomINIs%, %scriptName%.ini, General, bModifyCustomINIs
if bModifyCustomINIs = 1
	sm("BethINI will modify Custom INI files.")
else if bModifyCustomINIs = 0
	sm("BethINI will no longer modify Custom INI files.")
return

bDeleteInvalidSettingsOnSummary:
bDeleteInvalidSettingsOnSummary := getControlValue("bDeleteInvalidSettingsOnSummary")
IniWrite, %bDeleteInvalidSettingsOnSummary%, %scriptName%.ini, General, bDeleteInvalidSettingsOnSummary
if bDeleteInvalidSettingsOnSummary = 1
	sm("BethINI will use auto-detection of invalid settings.")
else if bDeleteInvalidSettingsOnSummary = 0
	sm("BethINI will not remove settings for which a default value is not found.")
return

VanillaPresets:
VanillaPresets := getControlValue("VanillaPresets")
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	enableGuiControl("Poor", VanillaPresets)
tempText = Preset buttons now use %gameName%'s vanilla presets.
sm(tempText)
return

BethINIPresets:
BethINIPresets := getControlValue("BethINIPresets")
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	disableGuiControl("Poor", BethINIPresets)
tempText = Preset buttons now use %projectName%'s enhanced presets.
sm(tempText)
return

DisplayAdapter:
iAdapter := getControlValue("iAdapter")
if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	IniWrite, %iAdapter%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iAdapter
else if (gameName = "Skyrim" or gameName = "Oblivion")
	IniWrite, %iAdapter%, %INIfolder%%gameNameINI%.ini, Display, iAdapter
tempText = Display adapter changed to %iAdapter%
sm(tempText)
return
		
Resolution:
Resolution := getControlValue("Resolution")
StringSplit, resArray, Resolution, X
iSizeW := Trim(resArray1)
iSizeH := Trim(resArray2)
IniWrite, %iSizeW%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iSize W
IniWrite, %iSizeH%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iSize H
tempText = Display resolution changed to %iSizeW% X %iSizeH%
sm(tempText)
return
		
Antialiasing:
Antialiasing := getControlValue("Antialiasing")
if gameName = Fallout 4
	{
		if Antialiasing = None
			Antialiasing =
		IniWrite, %Antialiasing%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, sAntiAliasing
		if Antialiasing !=
			sm("Antialiasing has been set to " . Antialiasing)
		else
			sm("Antialiasing has been disabled.")
	}
else if gameName = Skyrim Special Edition
	{
		if Antialiasing = None
			Antialiasing = 0
		else
			Antialiasing = 1
		IniWrite, %Antialiasing%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bUseTAA
		if Antialiasing = 1
			sm("Antialiasing has been set to TAA.")
		else
			sm("Antialiasing has been disabled.")
	}
else
	{
		if Antialiasing = None
			{
				IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMultiSample
				sm("Antialiasing has been disabled.")
			}
		else
			{
				StringSplit, antialiasArray, Antialiasing, x
				IniWrite, %antialiasArray1%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMultiSample
				tempText = Antialiasing set to %antialiasArray1% samples
				sm(tempText)
			}
	}
return
			
AnisotropicFiltering:
Anisotropic := getControlValue("Anisotropic")
if Anisotropic = None
	{
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxAnisotropy
		sm("Anisotropic filtering has been disabled.")
	}
else
	{
		StringSplit, anisotropicArray, Anisotropic, x
		IniWrite, %anisotropicArray1%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxAnisotropy
		tempText = Anisotropic filtering set to %anisotropicArray1% samples
		sm(tempText)
	}
return
		
WindowedMode:
Windowed := getControlValue("Windowed")
if Windowed = 0
	{
		IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bFull Screen
		sm("The game will now run in fullscreen mode.")
	}
else if Windowed = 1
	{
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bFull Screen
		sm("The game will now run in windowed mode.")
	}
return
			
AlwaysActive:
bAlwaysActive := getControlValue("bAlwaysActive")
IniWrite, %bAlwaysActive%, %INIfolder%%gameNameINI%.ini, General, bAlwaysActive
if bAlwaysActive = 1
	sm("The game window will always be active, even when out of focus.")
else if bAlwaysActive = 0
	sm("The game window will not be active if out of focus.")
return

bAllow30Shaders:
bAllow30Shaders := getControlValue("bAllow30Shaders")
IniWrite, %bAllow30Shaders%, %INIfolder%%gameNameINI%.ini, Display, bAllow30Shaders
if bAllow30Shaders = 1
	tempText = 3.0 shaders can now be enabled.
else
	tempText = 3.0 shaders are now disabled.
sm(tempText)
return

bBorderless:
bBorderless := getControlValue("bBorderless")
IniWrite, %bBorderless%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bBorderless
if bBorderless = 1
	sm("The game window shall now be borderless if running in windowed mode.")
else if bBorderless = 0
	sm("The game window shall now have borders if running in windowed mode.")
return

bLockFrameRate:
bLockFrameRate := getControlValue("bLockFrameRate")
IniWrite, %bLockFrameRate%, %INIfolder%%gameNameINI%.ini, Display, bLockFrameRate
if bLockFrameRate = 1
	sm("Frame rate limited to 60 frames per second.")
else if bLockFrameRate = 0
	sm("Frame rate limited to 60 frames per second.")
return

bUse64bitsHDRRenderTarget:
bUse64bitsHDRRenderTarget := getControlValue("bUse64bitsHDRRenderTarget")
IniWrite, %bUse64bitsHDRRenderTarget%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bUse64bitsHDRRenderTarget
if bUse64bitsHDRRenderTarget = 1
	sm("64 bit render targets enabled.")
else if bUse64bitsHDRRenderTarget = 0
	sm("64 bit render targets disabled.")
return

FPS:
FPS := getControlValue("FPS")
IniWrite, % Round(1/FPS, 8) , %INIfolder%%gameNameINI%.ini, HAVOK, fMaxTime
sm("Framerate is set to " . FPS . ".")
return

iFPSClamp:
iFPSClamp := getControlValue("iFPSClamp")
FPS := getControlValue("FPS")
if iFPSClamp = 0
	{
		IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, iFPSClamp
		sm("Game speed is not clamped to the framerate.")
	}
else
	{
		IniWrite, %FPS%, %INIfolder%%gameNameINI%.ini, General, iFPSClamp
		sm("Game speed has been clamped to " . FPS . "fps.")
	}
return


bMaximizeWindow:
bMaximizeWindow := getControlValue("bMaximizeWindow")
IniWrite, %bMaximizeWindow%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bMaximizeWindow
if bMaximizeWindow = 1
	sm("The game window shall now be maximized.")
else if bMaximizeWindow = 0
	sm("The game window shall not be maximized.")
return

bTopMostWindow:
bTopMostWindow := getControlValue("bTopMostWindow")
IniWrite, %bTopMostWindow%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bTopMostWindow
if bTopMostWindow = 1
	sm("The game window shall always be on top.")
else if bTopMostWindow = 0
	sm("The game window may not always be on top.")
return
		
EnableFileSelection:
bEnableFileSelection := getControlValue("bEnableFileSelection")
IniWrite, %bEnableFileSelection%, %INIfolder%%gameNameINI%%Prefs%.ini, Launcher, bEnableFileSelection
if bEnableFileSelection = 1
	sm("The Launcher now supports mods.")
else if bEnableFileSelection = 0
	sm("The Launcher now does NOT supports mods and may ruin your load order.")
return

bInvalidateOlderFiles:
bInvalidateOlderFiles := getControlValue("bInvalidateOlderFiles")
IniWrite, %bInvalidateOlderFiles%, %INIfolder%%gameNameINI%.ini, Archive, bInvalidateOlderFiles
if gameName = Fallout 4
	IniWrite, % blank, %INIfolder%%gameNameINI%.ini, Archive, sResourceDataDirsFinal
sm("Existing loose files in the data directory shall now be used in place of archived versions.")
return

sIntroSequence:
sIntroSequence := getControlValue("sIntroSequence")
if sIntroSequence = 1
	{
		if gameName = Skyrim
			{
				IniWrite, BGS_LOGO.BIK, %INIfolder%%gameNameINI%.ini, General, sIntroSequence
			}
		else if gameName = Skyrim Special Edition
			{
				IniWrite, BGS_Logo.bik, %INIfolder%%gameNameINI%.ini, General, sIntroSequence
			}
		else if gameName = Oblivion
			{
				IniWrite, % "bethesda softworks HD720p.bik,2k games.bik,game studios.bik,Oblivion Legal.bik", %INIfolder%%gameNameINI%.ini, General, sIntroSequence
				IniWrite, Oblivion iv logo.bik, %INIfolder%%gameNameINI%.ini, General, sMainMenuMovieIntro
			}
		else if gameName = Fallout New Vegas
			{
				IniWrite, % blank, %INIfolder%%gameNameINI%.ini, General, SMainMenuMovieIntro
			}
		else if gameName = Fallout 4
			{
				IniWrite, GameIntro_V3_B.bk2, %INIfolder%%gameNameINI%.ini, General, sIntroSequence
			}
		tempText = %gameName% now will play the intro logo(s) every time you launch %gameName%.
		sm(tempText)
	}
else
	{
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition" or gameName = "Fallout 4")
			{
				IniWrite, % blank, %INIfolder%%gameNameINI%.ini, General, sIntroSequence
			}
		else if gameName = Oblivion
			{
				IniWrite, % blank, %INIfolder%%gameNameINI%.ini, General, sIntroSequence
				IniWrite, % blank, %INIfolder%%gameNameINI%.ini, General, sMainMenuMovieIntro
			}
		else if gameName = Fallout New Vegas
			{
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, SMainMenuMovieIntro
			}
		tempText = %gameName% now will NOT play the intro logo(s) every time you launch %gameName%.
		sm(tempText)
	}
return

SPECIAL:
SPECIAL := getControlValue("SPECIAL")
if SPECIAL = 1
	{
		IniWrite, 0.2, %INIfolder%%gameNameINI%.ini, General, fChancesToPlayAlternateIntro
		IniWrite, 5000, %INIfolder%%gameNameINI%.ini, General, uMainMenuDelayBeforeAllowSkip
		IniWrite, % "STRENGTH.bk2;PERCEPTION.bk2;ENDURANCE.bk2;CHARISMA.bk2;INTELLIGENCE.bk2;AGILITY.bk2;LUCK.bk2", %INIfolder%%gameNameINI%.ini, General, sStreamInstallVideoPlayList
		sm("""Why You Are S.P.E.C.I.A.L."" intro videos now have a 20% chance of appearing at game startup.")
	}
else
	{
		IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, fChancesToPlayAlternateIntro
		IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, uMainMenuDelayBeforeAllowSkip
		sm("""Why You Are S.P.E.C.I.A.L."" intro videos have been disabled.")
	}
return
	
bMusicEnabled:
bMusicEnabled := getControlValue("bMusicEnabled")
IniWrite, %bMusicEnabled%, %INIfolder%%gameNameINI%.ini, Audio, bMusicEnabled
disableGuiControl("IntroMusic", getControlValue("bMusicEnabled"))
if bMusicEnabled = 1
	sm("Music has been enabled.")
else if bMusicEnabled = 0
	sm("Music has been disabled.")
return

IntroMusic:
IntroMusic := getControlValue("IntroMusic")
if IntroMusic = 1
	{
		if gameName = Fallout 4
			{
				IniWrite, 1, %INIfolder%%gameNameINI%.ini, General, bPlayMainMenuMusic
				IniWrite, % "\Data\Music\Special\MUS_MainTheme.xwm", %INIfolder%%gameNameINI%.ini, General, sMainMenuMusic
			}
		else if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			IniWrite, % "\Data\Music\Special\MUS_MainTheme.xwm", %INIfolder%%gameNameINI%.ini, General, sMainMenuMusic
		else
			IniWrite, 0.6, %INIfolder%%gameNameINI%.ini, Audio, fMainMenuMusicVolume
		sm("Intro Music is now enabled.")
	}
else
	{
		if gameName = Fallout 4
			IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, bPlayMainMenuMusic
		else if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			IniWrite, % blank, %INIfolder%%gameNameINI%.ini, General, sMainMenuMusic
		else
			IniWrite, 0, %INIfolder%%gameNameINI%.ini, Audio, fMainMenuMusicVolume
		sm("Intro Music is now disabled.")
	}
return

fMaxFootstepDistance:
fMaxFootstepDistance := getControlValue("fMaxFootstepDistance")
IniWrite, %fMaxFootstepDistance%, %INIfolder%%gameNameINI%.ini, Audio, fMaxFootstepDistance
sm("The distance that footsteps can be heard has been set to " . fMaxFootstepDistance . ".")
return

fPlayerFootVolume:
fPlayerFootVolume := Round(getControlValue("fPlayerFootVolume")/100, 2)
GuiControl, Main:, fPlayerFootVolumeReal, %fPlayerFootVolume%
return

fPlayerFootVolumeReal:
fPlayerFootVolumeReal := getControlValue("fPlayerFootVolumeReal")
fPlayerFootVolume := getControlValue("fPlayerFootVolumeReal")*100
GuiControl, Main:, fPlayerFootVolume, %fPlayerFootVolume%
IniWrite, %fPlayerFootVolumeReal%, %INIfolder%%gameNameINI%.ini, Audio, fPlayerFootVolume
tempText = The volume of the player's footsteps has been set to %fPlayerFootVolumeReal%.
sm(tempText)
return

TextureQuality:
iTexMipMapSkip := getControlValue("iTexMipMapSkip")
tempText = Texture quality was not changed.
if iTexMipMapSkip = Poor
	{
		IniWrite, 2, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iTexMipMapSkip
		IniWrite, 3, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iTexMipMapMinimum
		tempText = Texture quality changed to Poor.
	}
else if iTexMipMapSkip = Low
	{
		IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iTexMipMapSkip
		IniWrite, 2, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iTexMipMapMinimum
		tempText = Texture quality changed to Low.
	}
else if iTexMipMapSkip = Medium
	{
		IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iTexMipMapSkip
		IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iTexMipMapMinimum
		tempText = Texture quality changed to Medium.
	}
else if iTexMipMapSkip = High
	{
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iTexMipMapSkip
		IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iTexMipMapMinimum
		tempText = Texture quality changed to High.
	}
else if iTexMipMapSkip = Ultra
	{
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iTexMipMapSkip
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iTexMipMapMinimum
		tempText = Texture quality changed to Ultra.
	}
sm(tempText)
return
	
Godrays:
Godrays := getControlValue("Godrays")
if Godrays = None
	IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bVolumetricLightingEnable
else
	IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bVolumetricLightingEnable
if Godrays = Low
	IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iVolumetricLightingQuality
if Godrays = Medium
	IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iVolumetricLightingQuality
if Godrays = High
	IniWrite, 2, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iVolumetricLightingQuality
sm("Godrays has been set to " . Godrays . ".")
return
	
FieldofView:
FOV := getControlValue("FOV")
IniWrite, %FOV%, %INIfolder%%gameNameINI%.ini, Display, fDefaultWorldFOV
tempText = FOV changed to %FOV%.
sm(tempText)
return

DecalQuantity:
DecalQuantity := getControlValue("DecalQuantity")
tempText = Decal Quantity was not changed.
if DecalQuantity = Poor
	{				
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			{
				IniWrite, 1, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecals
				IniWrite, 1, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecalPerActor
				IniWrite, 30, %INIfolder%%gameNameINI%.ini, Display, fDecalLifetime
				IniWrite, 10, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxDecals
				IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxSkinDecalsPerFrame
			}
		else if gameName = Skyrim Special Edition
			{
				IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxSkinDecals
				IniWrite, 1, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecalPerActor
				IniWrite, 30, %INIfolder%%gameNameINI%.ini, Display, fDecalLifetime
				IniWrite, 10, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxDecals
				IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxSkinDecalsPerFrame
			}
		IniWrite, 3, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxDecalsPerFrame
		tempText = Decal quantity set to Poor.
	}
else if DecalQuantity = Low
	{				
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			{
				IniWrite, 3, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecals
				IniWrite, 2, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecalPerActor
				IniWrite, 60, %INIfolder%%gameNameINI%.ini, Display, fDecalLifetime
				IniWrite, 20, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxDecals
				IniWrite, 3, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxSkinDecalsPerFrame
			}
		else if gameName = Skyrim Special Edition
			{
				IniWrite, 3, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxSkinDecals
				IniWrite, 2, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecalPerActor
				IniWrite, 60, %INIfolder%%gameNameINI%.ini, Display, fDecalLifetime
				IniWrite, 20, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxDecals
				IniWrite, 3, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxSkinDecalsPerFrame
			}
		IniWrite, 10, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxDecalsPerFrame
		tempText = Decal quantity set to Low.
	}
else if DecalQuantity = Medium
	{				
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			{
				IniWrite, 35, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecals
				IniWrite, 20, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecalPerActor
				IniWrite, 120, %INIfolder%%gameNameINI%.ini, Display, fDecalLifetime
				IniWrite, 100, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxDecals
				IniWrite, 35, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxSkinDecalsPerFrame
			}
		else if gameName = Skyrim Special Edition
			{
				IniWrite, 35, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxSkinDecals
				IniWrite, 20, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecalPerActor
				IniWrite, 120, %INIfolder%%gameNameINI%.ini, Display, fDecalLifetime
				IniWrite, 100, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxDecals
				IniWrite, 35, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxSkinDecalsPerFrame
			}
		IniWrite, 60, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxDecalsPerFrame
		tempText = Decal quantity set to Medium.
	}
else if DecalQuantity = High
	{				
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			{
				IniWrite, 50, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecals
				IniWrite, 40, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecalPerActor
				IniWrite, 180, %INIfolder%%gameNameINI%.ini, Display, fDecalLifetime
				IniWrite, 200, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxDecals
				IniWrite, 50, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxSkinDecalsPerFrame
			}
		else if gameName = Skyrim Special Edition
			{
				IniWrite, 50, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxSkinDecals
				IniWrite, 40, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecalPerActor
				IniWrite, 180, %INIfolder%%gameNameINI%.ini, Display, fDecalLifetime
				IniWrite, 200, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxDecals
				IniWrite, 50, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxSkinDecalsPerFrame
			}
		IniWrite, 120, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxDecalsPerFrame
		tempText = Decal quantity set to High.
	}
else if DecalQuantity = Ultra
	{				
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			{
				IniWrite, 100, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecals
				IniWrite, 60, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecalPerActor
				IniWrite, 300, %INIfolder%%gameNameINI%.ini, Display, fDecalLifetime
				IniWrite, 350, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxDecals
				IniWrite, 100, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxSkinDecalsPerFrame
			}
		else if gameName = Skyrim Special Edition
			{
				IniWrite, 100, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxSkinDecals
				IniWrite, 60, %INIfolder%%gameNameINI%.ini, Decals, uMaxSkinDecalPerActor
				IniWrite, 300, %INIfolder%%gameNameINI%.ini, Display, fDecalLifetime
				IniWrite, 350, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, uMaxDecals
				IniWrite, 100, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxSkinDecalsPerFrame
			}
		IniWrite, 250, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iMaxDecalsPerFrame
		tempText = Decal quantity set to Ultra.
	}
sm(tempText)
return

bUseBlurShader:
bUseBlurShader := getControlValue("bUseBlurShader")
if bUseBlurShader = None
	{
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, BlurShader, bUseBlurShader
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, BlurShaderHDR, bDoHighDynamicRange
	}
else if bUseBlurShader = Bloom
	{
		IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, BlurShader, bUseBlurShader
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, BlurShaderHDR, bDoHighDynamicRange
	}
else if bUseBlurShader = HDR
	{
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, BlurShader, bUseBlurShader
		IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, BlurShaderHDR, bDoHighDynamicRange
	}
sm("Lighting effect has been set to " . bUseBlurShader . ".")
return

DepthofField:
DepthOfField := getControlValue("DepthOfField")
IniWrite, %DepthOfField%, %INIfolder%%gameNameINI%%Prefs%.ini, Imagespace, bDoDepthOfField
if DepthOfField = 1
	sm("Depth of field is now enabled.")
else if DepthOfField = 0
	sm("Depth of field is now disabled.")
return

bScreenSpaceBokeh:
bScreenSpaceBokeh := getControlValue("bScreenSpaceBokeh")
IniWrite, %bScreenSpaceBokeh%, %INIfolder%%gameNameINI%%Prefs%.ini, Imagespace, bScreenSpaceBokeh
if bScreenSpaceBokeh = 1
	sm("Bokeh depth of field is now enabled.")
else if bScreenSpaceBokeh = 0
	sm("Bokeh depth of field is now disabled.")
return

bLensFlare:
bLensFlare := getControlValue("bLensFlare")
IniWrite, %bLensFlare%, %INIfolder%%gameNameINI%%Prefs%.ini, Imagespace, bLensFlare
if bLensFlare = 1
	sm("Lens flare is now enabled.")
else if bLensFlare = 0
	sm("Lens flare is now disabled.")
return

bIBLFEnable:
bIBLFEnable := getControlValue("bIBLFEnable")
IniWrite, %bIBLFEnable%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bIBLFEnable
if bIBLFEnable = 1
	sm("Anamorphic lens flares are now enabled.")
else if bIBLFEnable = 0
	sm("Anamorphic lens flares are now disabled.")
return

bVolumetricLightingEnable:
bVolumetricLightingEnable := getControlValue("bVolumetricLightingEnable")
IniWrite, %bVolumetricLightingEnable%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bVolumetricLightingEnable
if bVolumetricLightingEnable = 1
	sm("Godrays are now enabled.")
else if bVolumetricLightingEnable = 0
	sm("Godrays are now disabled.")
return

bMBEnable:
bMBEnable := getControlValue("bMBEnable")
IniWrite, %bMBEnable%, %INIfolder%%gameNameINI%%Prefs%.ini, Imagespace, bMBEnable
if bMBEnable = 1
	sm("Motion blur is now enabled.")
else if bMBEnable = 0
	sm("Motion blur is now disabled.")
return


bEnableWetnessMaterials:
bEnableWetnessMaterials := getControlValue("bEnableWetnessMaterials")
IniWrite, %bEnableWetnessMaterials%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bEnableWetnessMaterials
if bEnableWetnessMaterials = 1
	sm("Wetness effects are now enabled.")
else if bEnableWetnessMaterials = 0
	sm("Wetness effects are now disabled.")
return


FXAA:
FXAA := getControlValue("FXAA")
IniWrite, %FXAA%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bFXAAEnabled
if FXAA = 1
	sm("FXAA is now enabled.")
else if FXAA = 0
	sm("FXAA is now disabled.")
return

VSync:
iPresentInterval := getControlValue("iPresentInterval")
if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	IniWrite, %iPresentInterval%, %INIfolder%%gameNameINI%.ini, Display, iPresentInterval
else if gameName = Skyrim Special Edition
	{
		IniWrite, %iPresentInterval%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iVSyncPresentInterval
		HalfRate := getSettingValue("Display", "iVSyncPresentInterval", Prefs, "1")
		if HalfRate = 2
			HalfRate = 1
		else
			HalfRate = 0
		GuiControl, Main:, HalfRate, %HalfRate%
		disableGuiControl("HalfRate", getControlValue("iPresentInterval"))
	}
else
	IniWrite, %iPresentInterval%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iPresentInterval
if iPresentInterval = 1
	sm("VSync is now enabled.")
else if iPresentInterval = 0
	sm("VSync is now disabled.")
return

HalfRate:
iPresentInterval := getControlValue("iPresentInterval")
HalfRate := getControlValue("HalfRate")
if iPresentInterval = 0
	{
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iVSyncPresentInterval
		sm("VSync is now disabled.")
	}
else if HalfRate = 0
	{
		IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iVSyncPresentInterval
		sm("VSync is now enabled at your monitor's refresh rate.")
	}
else if HalfRate = 1
	{
		IniWrite, 2, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iVSyncPresentInterval
		sm("VSync is now enabled at half your monitor's refresh rate.")
	}
return

bTransparencyMultisampling:
bTransparencyMultisampling := getControlValue("bTransparencyMultisampling")
IniWrite, %bTransparencyMultisampling%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bTransparencyMultisampling
if bTransparencyMultisampling = 1
	sm("Transparency Multisampling is now enabled.")
else if bTransparencyMultisampling = 0
	sm("Transparency Multisampling is now disabled.")
return
		
Decals:
bDecals := getControlValue("bDecals")
if gameName = Skyrim Special Edition
	IniWrite, %bDecals%, %INIfolder%%gameNameINI%%Prefs%.ini, Decals, bDecals
else
	IniWrite, %bDecals%, %INIfolder%%gameNameINI%.ini, Decals, bDecals
disableGuiControl("DecalQuantity", getControlValue("bDecals"))
if bDecals = 1
	sm("Decals are now enabled.")
else if bDecals = 0
	sm("Decals are now disabled.")
return

DisableAllGore:
DisableGore := getControlValue("DisableGore")
IniWrite, %DisableGore%, %INIfolder%%gameNameINI%.ini, General, bDisableAllGore
if DisableGore = 1
	sm("Gore is now disabled.")
else if DisableGore = 0
	sm("Gore is now enabled.")
return

ReflectLand:
WaterReflectLand := getControlValue("WaterReflectLand")
IniWrite, %WaterReflectLand%, %INIfolder%%gameNameINI%.ini, Water, bReflectLODLand
if WaterReflectLand = 1
	sm("Land reflections in the water are now enabled.")
else if WaterReflectLand = 0
	sm("Land reflections in the water are now disabled.")
return

ReflectObjects: 
WaterReflectObjects := getControlValue("WaterReflectObjects")
IniWrite, %WaterReflectObjects%, %INIfolder%%gameNameINI%.ini, Water, bReflectLODObjects
if WaterReflectObjects = 1
	sm("Object reflections in the water are now enabled.")
else if WaterReflectObjects = 0
	sm("Object reflections in the water are now disabled.")
return

ReflectTrees:
WaterReflectTrees := getControlValue("WaterReflectTrees")
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	IniWrite, %WaterReflectTrees%, %INIfolder%%gameNameINI%.ini, Water, bReflectLODTrees
else
	IniWrite, %WaterReflectTrees%, %INIfolder%%gameNameINI%.ini, Water, bUseWaterReflectionsTrees
if WaterReflectTrees = 1
	sm("Tree reflections in the water are now enabled.")
else if WaterReflectTrees = 0
	sm("Tree reflections in the water are now disabled.")
return

bUseWaterHiRes: 
bUseWaterHiRes := getControlValue("bUseWaterHiRes")
IniWrite, %bUseWaterHiRes%, %INIfolder%%gameNameINI%.ini, Water, bUseWaterHiRes
if bUseWaterHiRes = 1
	sm("High resolution water detail is now enabled.")
else if bUseWaterHiRes = 0
	sm("High resolution water detail is now disabled.")
return

bUseWaterDisplacements:
bUseWaterDisplacements := getControlValue("bUseWaterDisplacements")
IniWrite, %bUseWaterDisplacements%, %INIfolder%%gameNameINI%%Prefs%.ini, Water, bUseWaterDisplacements
if bUseWaterDisplacements = 1
	sm("Water ripples are now enabled.")
else if bUseWaterDisplacements = 0
	sm("Water ripples are now disabled.")
return

bAutoWaterSilhouetteReflections:
bAutoWaterSilhouetteReflections := Abs(getControlValue("bAutoWaterSilhouetteReflections") - 1)
IniWrite, %bAutoWaterSilhouetteReflections%, %INIfolder%%gameNameINI%%Prefs%.ini, Water, bAutoWaterSilhouetteReflections
IniWrite, %bAutoWaterSilhouetteReflections%, %INIfolder%%gameNameINI%.ini, Water, bForceLowDetailReflections
if bAutoWaterSilhouetteReflections = 1
	sm("Water now reflects the details of objects.")
else if bAutoWaterSilhouetteReflections = 0
	sm("Water now reflects only the outlines of objects.")
return

bForceHighDetailReflections:
bForceHighDetailReflections := getControlValue("bForceHighDetailReflections")
IniWrite, %bForceHighDetailReflections%, %INIfolder%%gameNameINI%%Prefs%.ini, Water, bForceHighDetailReflections
if bForceHighDetailReflections = 1
	sm("Water now reflects the full scene.")
else if bForceHighDetailReflections = 0
	sm("Water now reflects only part of the scene.")
return

iWaterBlurAmount:
iWaterBlurAmount := getControlValue("iWaterBlurAmount")
IniWrite, %iWaterBlurAmount%, %INIfolder%%gameNameINI%%Prefs%.ini, Water, iWaterBlurAmount
if iWaterBlurAmount = 0
	{
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Water, bUseWaterReflectionBlur
		sm("Water blur is now disabled.")
	}
else
	{
		IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Water, bUseWaterReflectionBlur
		sm("Water blur has been set to " . iWaterBlurAmount . ".")
	}
return

bUseWaterReflectionsActors: 
bUseWaterReflectionsActors := getControlValue("bUseWaterReflectionsActors")
IniWrite, %bUseWaterReflectionsActors%, %INIfolder%%gameNameINI%.ini, Water, bUseWaterReflectionsActors
if bUseWaterReflectionsActors = 1
	sm("Actor reflections in the water are now enabled.")
else if bUseWaterReflectionsActors = 0
	sm("Actor reflections in the water are now disabled.")
return

bUseWaterReflectionsStatics: 
bUseWaterReflectionsStatics := getControlValue("bUseWaterReflectionsStatics")
IniWrite, %bUseWaterReflectionsStatics%, %INIfolder%%gameNameINI%.ini, Water, bUseWaterReflectionsStatics
if bUseWaterReflectionsStatics = 1
	sm("Static object reflections in the water are now enabled.")
else if bUseWaterReflectionsStatics = 0
	sm("Static object reflections in the water are now disabled.")
return

bUseWaterReflectionsMisc: 
bUseWaterReflectionsMisc := getControlValue("bUseWaterReflectionsMisc")
IniWrite, %bUseWaterReflectionsMisc%, %INIfolder%%gameNameINI%.ini, Water, bUseWaterReflectionsMisc
if bUseWaterReflectionsMisc = 1
	sm("Miscellaneous reflections in the water are now enabled.")
else if bUseWaterReflectionsMisc = 0
	sm("Miscellaneous reflections in the water are now disabled.")
return

ReflectSky: 
WaterReflectSky := getControlValue("WaterReflectSky")
IniWrite, %WaterReflectSky%, %INIfolder%%gameNameINI%.ini, Water, bReflectSky
if WaterReflectSky = 1
	sm("Sky reflections in the water are now enabled.")
else if WaterReflectSky = 0
	sm("Sky reflections in the water are now disabled.")
return

ReflectionResolution: 
WaterReflectRes := getControlValue("WaterReflectRes")
IniWrite, %WaterReflectRes%, %INIfolder%%gameNameINI%%Prefs%.ini, Water, iWaterReflectHeight
IniWrite, %WaterReflectRes%, %INIfolder%%gameNameINI%%Prefs%.ini, Water, iWaterReflectWidth
tempText = The resolution of water reflections has been changed to %WaterReflectRes%.
sm(tempText)
return

ShadowRemoval:
if gameName = Skyrim
	{
		if (getControlValue("ShadowDeffer") = 1)
			{
				disableGuiControl("ShadowLand", getControlValue("ShadowDeffer"))
				disableGuiControl("ShadowGrass", getControlValue("ShadowDeffer"))
				enableGuiControl("ShadowDeffer", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowLand", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowGrass", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowTrees", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowRes", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowBlur", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowBias", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowExDist", getControlValue("ShadowRemoval"))
			}
		else
			{
				enableGuiControl("ShadowDeffer", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowLand", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowGrass", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowTrees", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowRes", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowBlur", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowBias", getControlValue("ShadowRemoval"))
				enableGuiControl("ShadowExDist", getControlValue("ShadowRemoval"))
				disableGuiControl("ShadowLand", getControlValue("ShadowDeffer"))
				disableGuiControl("ShadowGrass", getControlValue("ShadowDeffer"))
			}
			
		if (getControlValue("ShadowRemoval") = 1)
			{
				IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bDeferredShadows
				IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bDrawLandShadows
				IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bShadowMaskZPrepass
				IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bShadowsOnGrass
				IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bTreesReceiveShadows
				IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fShadowDistance
				IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iBlurDeferredShadowMask
				IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iShadowMapResolution
				tempText = Shadows are now disabled.
			}
		else
			{
				ShadowDeffer := getControlValue("ShadowDeffer")
				IniWrite, %ShadowDeffer%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bDeferredShadows
				ShadowLand := getControlValue("ShadowLand")
				IniWrite, %ShadowLand%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bDrawLandShadows
				ShadowGrass := getControlValue("ShadowGrass")
				IniWrite, %ShadowGrass%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bShadowsOnGrass
				ShadowTrees := getControlValue("ShadowTrees")
				IniWrite, %ShadowTrees%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bTreesReceiveShadows
				ShadowRes := getControlValue("ShadowRes")
				IniWrite, %ShadowRes%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iShadowMapResolution
				ShadowBlur := getControlValue("ShadowBlur")
				IniWrite, %ShadowBlur%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iBlurDeferredShadowMask
				ShadowExDist := getControlValue("ShadowExDist")
				IniWrite, %ShadowExDist%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fShadowDistance
				tempText = Shadows are now enabled.
			}
	}
else if gameName = Skyrim Special Edition
	{
		ShadowRemoval := getControlValue("ShadowRemoval")
		if ShadowRemoval = 1
			{
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Display, bDirShadowMapFullViewPort
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Display, fMaxHeightShadowCastingTrees
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Display, fFirstSliceDistance
				IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bDrawLandShadows
				IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bTreesReceiveShadows
				IniWrite, 0.0001, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fShadowDistance
				IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iShadowMapResolution
				tempText = Shadows are now disabled.
			}
		else
			{
				IniWrite, 1, %INIfolder%%gameNameINI%.ini, Display, bDirShadowMapFullViewPort
				IniWrite, 5000, %INIfolder%%gameNameINI%.ini, Display, fMaxHeightShadowCastingTrees
				fFirstSliceDistance := getControlValue("fFirstSliceDistance")
				IniWrite, %fFirstSliceDistance%, %INIfolder%%gameNameINI%.ini, Display, fFirstSliceDistance
				ShadowLand := getControlValue("ShadowLand")
				IniWrite, %ShadowLand%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bDrawLandShadows
				ShadowTrees := getControlValue("ShadowTrees")
				IniWrite, %ShadowTrees%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bTreesReceiveShadows
				ShadowRes := getControlValue("ShadowRes")
				IniWrite, %ShadowRes%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iShadowMapResolution
				ShadowExDist := getControlValue("ShadowExDist")
				IniWrite, %ShadowExDist%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fShadowDistance
				tempText = Shadows are now enabled.
			}
		enableGuiControl("ShadowLand", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowTrees", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowRes", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowBias", getControlValue("ShadowRemoval"))
		enableGuiControl("fFirstSliceDistance", getControlValue("ShadowRemoval"))
		enableGuiControl("ShadowExDist", getControlValue("ShadowRemoval"))
	}
sm(tempText)
return

DeferredShadows:
disableGuiControl("ShadowLand", getControlValue("ShadowDeffer"))
disableGuiControl("ShadowGrass", getControlValue("ShadowDeffer"))

ShadowDeffer := getControlValue("ShadowDeffer")
IniWrite, %ShadowDeffer%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bDeferredShadows
if ShadowDeffer = 1
	sm("Deferred rendering of shadows is now enabled.")
else if ShadowDeffer = 0
	sm("Deferred rendering of shadows is now disabled.")
return

LandShadows:
ShadowLand := getControlValue("ShadowLand")
IniWrite, %ShadowLand%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bDrawLandShadows
if ShadowLand = 1
	sm("Land objects such as mountains and rocks now can cast shadows.")
else if ShadowLand = 0
	sm("Land objects such as mountains and rocks now cannot cast shadows.")
return

bSAOEnable:
bSAOEnable := getControlValue("bSAOEnable")
IniWrite, %bSAOEnable%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bSAOEnable
if bSAOEnable = 1
	sm("Ambient Occlusion is now enabled.")
else if bSAOEnable = 0
	sm("Ambient Occlusion is now disabled.")
return

bScreenSpaceReflectionEnabled:
bScreenSpaceReflectionEnabled := getControlValue("bScreenSpaceReflectionEnabled")
IniWrite, %bScreenSpaceReflectionEnabled%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bScreenSpaceReflectionEnabled
disableGuiControl("iReflectionResolutionDivider", getControlValue("bScreenSpaceReflectionEnabled"))
if bScreenSpaceReflectionEnabled = 1
	sm("Screen space reflections are now enabled.")
else if bScreenSpaceReflectionEnabled = 0
	sm("Screen space reflections are now disabled.")
return

iReflectionResolutionDivider:
iReflectionResolutionDivider := getControlValue("iReflectionResolutionDivider")
IniWrite, %iReflectionResolutionDivider%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iReflectionResolutionDivider
sm("The resolution divider for screen space reflections has been set to " . iReflectionResolutionDivider . ".")
return

bActorSelfShadowing:
bActorSelfShadowing := getControlValue("bActorSelfShadowing")
IniWrite, %bActorSelfShadowing%, %INIfolder%%gameNameINI%.ini, Display, bActorSelfShadowing
if bActorSelfShadowing = 1
	sm("Actors now can cast shadows upon themselves.")
else if bActorSelfShadowing = 0
	sm("Actors now cannot cast shadows upon themselves.")
return

GrassShadows:
ShadowGrass := getControlValue("ShadowGrass")
if gameName = Skyrim
	IniWrite, %ShadowGrass%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bShadowsOnGrass
else
	IniWrite, %ShadowGrass%, %INIfolder%%gameNameINI%.ini, Display, bShadowsOnGrass
if ShadowGrass = 1
	sm("Objects now can cast shadows upon generated grass.")
else if ShadowGrass = 0
	sm("Objects now cannot cast shadows upon generated grass.")
return

TreeShadows:
ShadowTrees := getControlValue("ShadowTrees")
IniWrite, %ShadowTrees%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bTreesReceiveShadows
if ShadowTrees = 1
	sm("Trees now can cast shadows upon themselves.")
else if ShadowTrees = 0
	sm("Trees now cannot cast shadows upon themselves.")
return

bDoCanopyShadowPass:
bDoCanopyShadowPass := getControlValue("bDoCanopyShadowPass")
IniWrite, %bDoCanopyShadowPass%, %INIfolder%%gameNameINI%.ini, Display, bDoCanopyShadowPass
if bDoCanopyShadowPass = 1
	sm("Trees will now cast shadows.")
else if bDoCanopyShadowPass = 0
	sm("Trees will no longer cast shadows.")
return

AmbientOcclusion:
AmbientOcclusion := getControlValue("AmbientOcclusion")
if AmbientOcclusion = None
	{
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bSAOEnable
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, NVHBAO, bEnable
	}
else if AmbientOcclusion = SSAO
	{
		IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bSAOEnable
		IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, NVHBAO, bEnable
	}
else if AmbientOcclusion = HBAO+
	{
		IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bSAOEnable
		IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, NVHBAO, bEnable
	}
sm("Ambient Occlusion has been set to " . AmbientOcclusion . ".")
return

ShadowResolution:
ShadowRes := getControlValue("ShadowRes")
IniWrite, %ShadowRes%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iShadowMapResolution
tempText = The resolution of shadows has been set to %ShadowRes%.
sm(tempText)
return

iShadowFilter:
iShadowFilter := getControlValue("iShadowFilter")
if gameName = Fallout 4
	IniWrite, %iShadowFilter%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, uiOrthoShadowFilter
else
	IniWrite, %iShadowFilter%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iShadowFilter
sm("Shadow Filtering has been set to " . iShadowFilter . ".")
return

fShadowLOD:
fShadowLOD := getControlValue("fShadowLOD")
IniWrite, % Round(fShadowLOD/2,0), %INIfolder%%gameNameINI%%Prefs%.ini, Display, fShadowLOD1
IniWrite, %fShadowLOD%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fShadowLOD2
sm("Far-off Shadow Distance has been set to " . fShadowLOD . ".")
return

iActorShadowCountInt:
iActorShadowCountInt := getControlValue("iActorShadowCountInt")
GuiControl, Main:, iActorShadowCountIntReal, %iActorShadowCountInt%
return

iActorShadowCountIntReal:
iActorShadowCountIntReal := getControlValue("iActorShadowCountIntReal")
GuiControl, Main:, iActorShadowCountInt, %iActorShadowCountIntReal%
IniWrite, %iActorShadowCountIntReal%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iActorShadowCountInt
sm("The maximum amount of interior actor shadows has been set to " . iActorShadowCountIntReal . ".")
return

iActorShadowCountExt:
iActorShadowCountExt := getControlValue("iActorShadowCountExt")
GuiControl, Main:, iActorShadowCountExtReal, %iActorShadowCountExt%
return

iActorShadowCountExtReal:
iActorShadowCountExtReal := getControlValue("iActorShadowCountExtReal")
GuiControl, Main:, iActorShadowCountExt, %iActorShadowCountExtReal%
IniWrite, %iActorShadowCountExtReal%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iActorShadowCountExt
sm("The maximum amount of interior actor shadows has been set to " . iActorShadowCountExtReal . ".")
return

fShadowFadeTime:
fShadowFadeTime := getControlValue("fShadowFadeTime")
IniWrite, %fShadowFadeTime%, %INIfolder%%gameNameINI%.ini, Display, fShadowFadeTime
sm("Shadow Fade Time has been set to " . fShadowFadeTime . " seconds.")
return

ShadowBlurring:
ShadowBlur := getControlValue("ShadowBlur")
if ShadowBlur = none
	ShadowBlur = 0
else if ShadowBlur = max
	ShadowBlur = -1
IniWrite, %ShadowBlur%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iBlurDeferredShadowMask
tempText = The blurring applied to shadows has been set to %ShadowBlur%.
sm(tempText)
return

ShadowBias:
ShadowBias := getControlValue("ShadowBias")
if gameName = Skyrim
	{
		IniWrite, %ShadowBias%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fShadowBiasScale
		tempText = The shadow bias depth scale has been set to %ShadowBias%.
	}
else
	{
		IniWrite, %ShadowBias%, %INIfolder%%gameNameINI%.ini, Display, fShadowDirectionalBiasScale
		tempText = The directional shadow bias scale has been set to %ShadowBias%.
	}
sm(tempText)
return

fFirstSliceDistance:
fFirstSliceDistance := getControlValue("fFirstSliceDistance")
IniWrite, %fFirstSliceDistance%, %INIfolder%%gameNameINI%.ini, Display, fFirstSliceDistance
tempText = The detailed shadow distance has been set to %fFirstSliceDistance%.
sm(tempText)
return

ExteriorDrawDistance:
ShadowExDist := getControlValue("ShadowExDist")
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	IniWrite, %ShadowExDist%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fShadowDistance
else if gameName = Fallout 4
	IniWrite, %ShadowExDist%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fDirShadowDistance
tempText = The distance that shadows can be cast while outdoors has been set to %ShadowExDist%.
sm(tempText)
return

bDisableShadowJumps:
bDisableShadowJumps := Abs(getControlValue("bDisableShadowJumps") - 1)
IniWrite, %bDisableShadowJumps%, %INIfolder%%gameNameINI%.ini, Display, bDisableShadowJumps
if bDisableShadowJumps = 1
	tempText = Sun-shadow transitions are now enabled.
else
	tempText = Sun-shadow transitions are now disabled.
sm(tempText)
disableGuiControl("fSunShadowUpdateTime", getControlValue("bDisableShadowJumps"))
disableGuiControl("fSunUpdateThreshold", getControlValue("bDisableShadowJumps"))
return

fSunShadowUpdateTime:
fSunShadowUpdateTime := getControlValue("fSunShadowUpdateTime")
IniWrite, %fSunShadowUpdateTime%, %INIfolder%%gameNameINI%.ini, Display, fSunShadowUpdateTime
sm("Sun-Shadow Update Time set to " . fSunShadowUpdateTime)
return

fSunUpdateThreshold:
fSunUpdateThreshold := getControlValue("fSunUpdateThreshold")
IniWrite, %fSunUpdateThreshold%, %INIfolder%%gameNameINI%.ini, Display, fSunUpdateThreshold
sm("Sun-Shadow Update Threshold set to " . fSunUpdateThreshold)
return

bEnableImprovedSnow:
bEnableImprovedSnow := getControlValue("bEnableImprovedSnow")
IniWrite, %bEnableImprovedSnow%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bEnableImprovedSnow
disableGuiControl("bToggleSparkles", getControlValue("bEnableImprovedSnow"))
disableGuiControl("bEnableSnowRimLighting", getControlValue("bEnableImprovedSnow"))
disableGuiControl("bDeactivateAOOnSnow", getControlValue("bEnableImprovedSnow"))
disableGuiControl("bEnableSnowMask", getControlValue("bEnableImprovedSnow"))
if bEnableImprovedSnow = 1
	{
		sm("The improved snow shader is now enabled.")
		
	}
else if bEnableImprovedSnow = 0
	{
		GuiControl, Main:, bToggleSparkles, 0
		gosub bToggleSparkles
		GuiControl, Main:, bEnableSnowRimLighting, 0
		gosub bEnableSnowRimLighting
		sm("The improved snow shader is now disabled.")
	}
return

bEnableSnowMask:
bEnableSnowMask := getControlValue("bEnableSnowMask")
IniWrite, %bEnableSnowMask%, %INIfolder%%gameNameINI%.ini, Display, bEnableSnowMask
if bEnableSnowMask = 1
	sm("Snow mask is now enabled.")
else if bEnableSnowMask = 0
	sm("Snow mask is now disabled.")
return

bDeactivateAOOnSnow:
bDeactivateAOOnSnow := getControlValue("bDeactivateAOOnSnow")
IniWrite, % abs(bDeactivateAOOnSnow - 1), %INIfolder%%gameNameINI%.ini, Display, bDeactivateAOOnSnow
if bDeactivateAOOnSnow = 1
	sm("Ambient occlusion on snow is now enabled.")
else if bDeactivateAOOnSnow = 0
	sm("Ambient occlusion on snow is now disabled.")
return

bToggleSparkles:
bToggleSparkles := getControlValue("bToggleSparkles")
IniWrite, %bToggleSparkles%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bToggleSparkles
disableGuiControl("fSparklesIntensity", getControlValue("bToggleSparkles"))
disableGuiControl("fSparklesSize", getControlValue("bToggleSparkles"))
disableGuiControl("fSparklesDensity", getControlValue("bToggleSparkles"))
if bToggleSparkles = 1
	sm("Snow sparkles are now enabled.")
else if bToggleSparkles = 0
	sm("Snow sparkles are now disabled.")
return

bEnableSnowRimLighting:
bEnableSnowRimLighting := getControlValue("bEnableSnowRimLighting")
IniWrite, %bEnableSnowRimLighting%, %INIfolder%%gameNameINI%.ini, Display, bEnableSnowRimLighting
disableGuiControl("fSnowRimLightIntensity", getControlValue("bEnableSnowRimLighting"))
disableGuiControl("fSnowNormalSpecPower", getControlValue("bEnableSnowRimLighting"))
disableGuiControl("fSnowGeometrySpecPower", getControlValue("bEnableSnowRimLighting"))
if bEnableSnowRimLighting = 1
	sm("Snow rim lighting are now enabled.")
else if bEnableSnowRimLighting = 0
	sm("Snow rim lighting are now disabled.")
return

fSparklesIntensity:
fSparklesIntensity := getControlValue("fSparklesIntensity")
IniWrite, %fSparklesIntensity%, %INIfolder%%gameNameINI%.ini, Display, fSparklesIntensity
sm("Snow sparkle intensity set to " . fSparklesIntensity)
return

fSparklesDensity:
fSparklesDensity := getControlValue("fSparklesDensity")
IniWrite, %fSparklesDensity%, %INIfolder%%gameNameINI%.ini, Display, fSparklesDensity
sm("Snow sparkle density set to " . fSparklesDensity)
return

fSparklesSize:
fSparklesSize := getControlValue("fSparklesSize")
IniWrite, %fSparklesSize%, %INIfolder%%gameNameINI%.ini, Display, fSparklesSize
sm("Snow sparkle size set to " . fSparklesSize)
return

fSnowRimLightIntensity:
fSnowRimLightIntensity := getControlValue("fSnowRimLightIntensity")
IniWrite, %fSnowRimLightIntensity%, %INIfolder%%gameNameINI%.ini, Display, fSnowRimLightIntensity
sm("Snow rim lighting intensity set to " . fSnowRimLightIntensity)
return

fSnowGeometrySpecPower:
fSnowGeometrySpecPower := getControlValue("fSnowGeometrySpecPower")
IniWrite, %fSnowGeometrySpecPower%, %INIfolder%%gameNameINI%.ini, Display, fSnowGeometrySpecPower
sm("Power of glossiness/rim lighting on objects set to " . fSnowGeometrySpecPower)
return

fSnowNormalSpecPower:
fSnowNormalSpecPower := getControlValue("fSnowNormalSpecPower")
IniWrite, %fSnowNormalSpecPower%, %INIfolder%%gameNameINI%.ini, Display, fSnowNormalSpecPower
sm("Power of glossiness/rim lighting on landscape set to " . fSnowNormalSpecPower)
return

ObjectFade:
FadeObjects := Round(getControlValue("FadeObjects"),1)
GuiControl, Main:, FadeObjectsReal, %FadeObjects%
return

ObjectFadeReal:
FadeObjectsReal := getControlValue("FadeObjectsReal")
GuiControl, Main:, FadeObjects, %FadeObjectsReal%
IniWrite, %FadeObjectsReal%, %INIfolder%%gameNameINI%%Prefs%.ini, LOD, fLODFadeOutMultObjects
tempText = The distance that objects can be seen has been set to %FadeObjectsReal%.
sm(tempText)
return

ActorFade:
FadeActors := Round(getControlValue("FadeActors"),1)
GuiControl, Main:, FadeActorsReal, %FadeActors%
return

ActorFadeReal:
FadeActorsReal := getControlValue("FadeActorsReal")
GuiControl, Main:, FadeActors, %FadeActorsReal%
IniWrite, %FadeActorsReal%, %INIfolder%%gameNameINI%%Prefs%.ini, LOD, fLODFadeOutMultActors
tempText = The distance that actors can be seen has been set to %FadeActorsReal%.
sm(tempText)
return

ItemFade:
FadeItems := Round(getControlValue("FadeItems"),1)
GuiControl, Main:, FadeItemsReal, %FadeItems%
return

ItemFadeReal:
FadeItemsReal := getControlValue("FadeItemsReal")
GuiControl, Main:, FadeItems, %FadeItemsReal%
IniWrite, %FadeItemsReal%, %INIfolder%%gameNameINI%%Prefs%.ini, LOD, fLODFadeOutMultItems
tempText = The distance that items can be seen has been set to %FadeItemsReal%.
sm(tempText)
return

GrassFade:
FadeGrass := getControlValue("FadeGrass")
GuiControl, Main:, FadeGrassReal, %FadeGrass%
return

GrassFadeReal:
FadeGrassReal := getControlValue("FadeGrassReal")
GuiControl, Main:, FadeGrass, %FadeGrassReal%
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
	{
		if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
			IniWrite, 0, %INIfolder%%gameNameINI%%Prefs%.ini, Grass, fGrassMinStartFadeDistance
		else
			IniWrite, 0, %INIfolder%%gameNameINI%.ini, Grass, fGrassMinStartFadeDistance
		fGrassStartFadeDistance := Round(0.25 * FadeGrassReal,0)
		fGrassMaxStartFadeDistance := fGrassStartFadeDistance + 4000
		fGrassFadeRange := FadeGrassReal - fGrassStartFadeDistance
		if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
			IniWrite, %fGrassMaxStartFadeDistance%, %INIfolder%%gameNameINI%%Prefs%.ini, Grass, fGrassMaxStartFadeDistance
		else
			IniWrite, %fGrassMaxStartFadeDistance%, %INIfolder%%gameNameINI%.ini, Grass, fGrassMaxStartFadeDistance
		IniWrite, %fGrassStartFadeDistance%, %INIfolder%%gameNameINI%%Prefs%.ini, Grass, fGrassStartFadeDistance
		IniWrite, %fGrassFadeRange%, %INIfolder%%gameNameINI%.ini, Grass, fGrassFadeRange
	}
else
	{
		if (FadeGrassReal > 8192 and checkForPlugin("OblivionReloaded.esp") != 1)
			{
				FadeGrassReal = 8192
				GuiControl, Main:, FadeGrass, %FadeGrassReal%
				GuiControl, Main:, FadeGrassReal, %FadeGrassReal%
				return
			}
		if (FadeGrassReal > 12288 and getSettingValue("General", "uGridsToLoad", blank, "5") < 6)
			{
				FadeGrassReal = 12288
				GuiControl, Main:, FadeGrass, %FadeGrassReal%
				GuiControl, Main:, FadeGrassReal, %FadeGrassReal%
				return
			}
		if (FadeGrassReal > 16384 and getSettingValue("General", "uGridsToLoad", blank, "5") < 8)
			{
				FadeGrassReal = 16384
				GuiControl, Main:, FadeGrass, %FadeGrassReal%
				GuiControl, Main:, FadeGrassReal, %FadeGrassReal%
				return
			}
		if (FadeGrassReal > 20480 and getSettingValue("General", "uGridsToLoad", blank, "5") < 10)
			{
				FadeGrassReal = 20480
				GuiControl, Main:, FadeGrass, %FadeGrassReal%
				GuiControl, Main:, FadeGrassReal, %FadeGrassReal%
				return
			}
		if FadeGrassReal < 10000
			FadeGrassRealStart := FadeGrassReal - 1000
		else
			FadeGrassRealStart := FadeGrassReal - 1500
		IniWrite, %FadeGrassReal%, %INIfolder%%gameNameINI%.ini, Grass, fGrassEndDistance
		IniWrite, %FadeGrassRealStart%, %INIfolder%%gameNameINI%.ini, Grass, fGrassStartFadeDistance
	}
tempText = The distance that grass can be seen has been set to %FadeGrassReal%.
sm(tempText)
return

LightFade:
FadeLight := getControlValue("FadeLight")
GuiControl, Main:, FadeLightReal, %FadeLight%
return

LightFadeReal:
FadeLightReal := getControlValue("FadeLightReal")
GuiControl, Main:, FadeLight, %FadeLightReal%
if gameName = Oblivion
	{
		IniWrite, % Round(0.6667 * FadeLightReal, 0), %INIfolder%%gameNameINI%.ini, Display, fLightLOD1
		IniWrite, %FadeLightReal%, %INIfolder%%gameNameINI%.ini, Display, fLightLOD2
	}
else
	{
		fLightLODStartFade := Round(0.1 * FadeLightReal, 0)
		fLightLODMaxStartFade := fLightLODStartFade + 3500
		fLightLODRange := FadeLightReal - fLightLODStartFade
		if gameName != Skyrim Special Edition
			IniWrite, %fLightLODMaxStartFade%, %INIfolder%%gameNameINI%.ini, Display, fLightLODMaxStartFade
		IniWrite, %fLightLODStartFade%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fLightLODStartFade
		IniWrite, %fLightLODRange%, %INIfolder%%gameNameINI%.ini, Display, fLightLODRange
	}
tempText = The distance that light can be seen has been set to %FadeLightReal%.
sm(tempText)
return

FadeMultiplier:
FadeMult := getControlValue("FadeMult")
IniWrite, %FadeMult%, %INIfolder%%gameNameINI%.ini, LOD, fDistanceMultiplier
tempText = All fade distance settings will be multiplied by %FadeMult% in-game.
sm(tempText)
return

ObjectDetailFade:
FadeMesh := getControlValue("FadeMesh")
if (FadeMesh = "Default" and gameName = "Skyrim")
	{
		IniWrite, 4096, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeDist
		IniWrite, 3072, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeDist
	}
else if (FadeMesh = "Default" and gameName = "Skyrim Special Edition")
	{
		IniWrite, 4096, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeDist
		IniWrite, 3072, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeDist
	}
else if (FadeMesh = "Default" and gameName = "Fallout 4")
	{
		IniWrite, 4000, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeDist
		IniWrite, 3000, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeDist
	}
else if FadeMesh = Poor
	{
		IniWrite, 2816, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeDist
		IniWrite, 1280, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeDist
	}
else if FadeMesh = Low
	{
		IniWrite, 3840, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeDist
		IniWrite, 2048, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeDist
	}
else if FadeMesh = Medium
	{
		IniWrite, 5376, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeDist
		IniWrite, 3456, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeDist
	}
else if FadeMesh = High
	{
		IniWrite, 10240, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeDist
		IniWrite, 7680, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeDist
	}
else if (FadeMesh = "Ultra" and gameName = "Skyrim")
	{
		IniWrite, 16896, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeDist
		IniWrite, 16896, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeDist
	}
else if (FadeMesh = "Ultra" and gameName = "Skyrim Special Edition")
	{
		IniWrite, 16896, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeDist
		IniWrite, 16896, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeDist
	}
else if (FadeMesh = "Ultra" and gameName = "Fallout 4")
	{
		IniWrite, 999999, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeDist
		IniWrite, 999999, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeDist
	}
sm("Object Detail Fade has been set to " . FadeMesh . " Quality.")
return

Preset:
FadeDistantLOD := getControlValue("FadeDistantLOD")
if gameName = Skyrim
			{
				defaultLevel0 = 20480
				defaultLevel1 = 32768
				defaultLevelmax = 100000
				defaultSplit = 0.75
			}
		else if gameName = Skyrim Special Edition
			{
				defaultLevel0 = 35000
				defaultLevel1 = 70000
				defaultLevelmax = 250000
				defaultSplit = 1.5
			}
		else if gameName = Fallout 4
			{
				defaultLevel0 = 14336
				defaultLevel1 = 27876
				defaultLevel2 = 83232
				defaultLevelmax = 161232
				defaultSplit = 0.75
				LOWlevel2 := Round(getSettingValue("TerrainManager", "fBlockLevel2Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel2, "Presets\" . gameName . "\Vanilla-Presets\low\"),0)
				MEDlevel2 := Round(getSettingValue("TerrainManager", "fBlockLevel2Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel2, "Presets\" . gameName . "\Vanilla-Presets\medium\"),0)
				HIlevel2 := Round(getSettingValue("TerrainManager", "fBlockLevel2Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel2, "Presets\" . gameName . "\Vanilla-Presets\high\"),0)
				ULTRAlevel2 := Round(getSettingValue("TerrainManager", "fBlockLevel2Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel2, "Presets\" . gameName . "\Vanilla-Presets\ultra\"),0)
				bethPOORlevel2 := Round(getSettingValue("TerrainManager", "fBlockLevel2Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel2, "Presets\" . gameName . "\BethINI-Presets\poor\"),0)
				bethLOWlevel2 := Round(getSettingValue("TerrainManager", "fBlockLevel2Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel2, "Presets\" . gameName . "\BethINI-Presets\low\"),0)
				bethMEDlevel2 := Round(getSettingValue("TerrainManager", "fBlockLevel2Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel2, "Presets\" . gameName . "\BethINI-Presets\medium\"),0)
				bethHIlevel2 := Round(getSettingValue("TerrainManager", "fBlockLevel2Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel2, "Presets\" . gameName . "\BethINI-Presets\high\"),0)
				bethULTRAlevel2 := Round(getSettingValue("TerrainManager", "fBlockLevel2Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel2, "Presets\" . gameName . "\BethINI-Presets\ultra\"),0)
			}
		else if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			{
				defaultLevel0 = 50000
				defaultLevelmax = 125000
				defaultSplit = 0.75
				LOWlevel0 := Round(getSettingValue("TerrainManager", "fBlockLoadDistanceLow", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\Vanilla-Presets\low\"),0)
				MEDlevel0 := Round(getSettingValue("TerrainManager", "fBlockLoadDistanceLow", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\Vanilla-Presets\high\"),0)
				HIlevel0 := Round(getSettingValue("TerrainManager", "fBlockLoadDistanceLow", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\Vanilla-Presets\ultra\"),0)
				LOWlevelmax := Round(getSettingValue("TerrainManager", "fBlockLoadDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\Vanilla-Presets\low\"),0)
				MEDlevelmax := Round(getSettingValue("TerrainManager", "fBlockLoadDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\Vanilla-Presets\high\"),0)
				HIlevelmax := Round(getSettingValue("TerrainManager", "fBlockLoadDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\Vanilla-Presets\ultra\"),0)
				bethPOORlevel0 := Round(getSettingValue("TerrainManager", "fBlockLoadDistanceLow", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\BethINI-Presets\poor\"),0)
				bethLOWlevel0 := Round(getSettingValue("TerrainManager", "fBlockLoadDistanceLow", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\BethINI-Presets\low\"),0)
				bethMEDlevel0 := Round(getSettingValue("TerrainManager", "fBlockLoadDistanceLow", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\BethINI-Presets\medium\"),0)
				bethHIlevel0 := Round(getSettingValue("TerrainManager", "fBlockLoadDistanceLow", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\BethINI-Presets\high\"),0)
				bethULTRAlevel0 := Round(getSettingValue("TerrainManager", "fBlockLoadDistanceLow", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\BethINI-Presets\ultra\"),0)
				bethPOORlevelmax := Round(getSettingValue("TerrainManager", "fBlockLoadDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\BethINI-Presets\poor\"),0)
				bethLOWlevelmax := Round(getSettingValue("TerrainManager", "fBlockLoadDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\BethINI-Presets\low\"),0)
				bethMEDlevelmax := Round(getSettingValue("TerrainManager", "fBlockLoadDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\BethINI-Presets\medium\"),0)
				bethHIlevelmax := Round(getSettingValue("TerrainManager", "fBlockLoadDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\BethINI-Presets\high\"),0)
				bethULTRAlevelmax := Round(getSettingValue("TerrainManager", "fBlockLoadDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\BethINI-Presets\ultra\"),0)
				MEDsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\Vanilla-Presets\high\"),3)
				HIsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\Vanilla-Presets\ultra\"),3)
			}
			
				LOWsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\Vanilla-Presets\low\"),3)	
				bethPOORsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\BethINI-Presets\poor\"),3)
				bethLOWsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\BethINI-Presets\low\"),3)
				bethHIsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\BethINI-Presets\high\"),3)
				bethULTRAsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\BethINI-Presets\ultra\"),3)
				bethMEDsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\BethINI-Presets\medium\"),3)
				
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition" or gameName = "Fallout 4")
			{
				LOWlevel0 := Round(getSettingValue("TerrainManager", "fBlockLevel0Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\Vanilla-Presets\low\"),0)
				MEDlevel0 := Round(getSettingValue("TerrainManager", "fBlockLevel0Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\Vanilla-Presets\medium\"),0)
				HIlevel0 := Round(getSettingValue("TerrainManager", "fBlockLevel0Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\Vanilla-Presets\high\"),0)
				ULTRAlevel0 := Round(getSettingValue("TerrainManager", "fBlockLevel0Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\Vanilla-Presets\ultra\"),0)
				LOWlevel1 := Round(getSettingValue("TerrainManager", "fBlockLevel1Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel1, "Presets\" . gameName . "\Vanilla-Presets\low\"),0)
				MEDlevel1 := Round(getSettingValue("TerrainManager", "fBlockLevel1Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel1, "Presets\" . gameName . "\Vanilla-Presets\medium\"),0)
				HIlevel1 := Round(getSettingValue("TerrainManager", "fBlockLevel1Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel1, "Presets\" . gameName . "\Vanilla-Presets\high\"),0)
				ULTRAlevel1 := Round(getSettingValue("TerrainManager", "fBlockLevel1Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel1, "Presets\" . gameName . "\Vanilla-Presets\ultra\"),0)
				LOWlevelmax := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\Vanilla-Presets\low\"),0)
				MEDlevelmax := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\Vanilla-Presets\medium\"),0)
				HIlevelmax := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\Vanilla-Presets\high\"),0)
				ULTRAlevelmax := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\Vanilla-Presets\ultra\"),0)
				
				bethPOORlevel0 := Round(getSettingValue("TerrainManager", "fBlockLevel0Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\BethINI-Presets\poor\"),0)
				bethLOWlevel0 := Round(getSettingValue("TerrainManager", "fBlockLevel0Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\BethINI-Presets\low\"),0)
				bethMEDlevel0 := Round(getSettingValue("TerrainManager", "fBlockLevel0Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\BethINI-Presets\medium\"),0)
				bethHIlevel0 := Round(getSettingValue("TerrainManager", "fBlockLevel0Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\BethINI-Presets\high\"),0)
				bethULTRAlevel0 := Round(getSettingValue("TerrainManager", "fBlockLevel0Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\BethINI-Presets\ultra\"),0)
				bethPOORlevel1 := Round(getSettingValue("TerrainManager", "fBlockLevel1Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel1, "Presets\" . gameName . "\BethINI-Presets\poor\"),0)
				bethLOWlevel1 := Round(getSettingValue("TerrainManager", "fBlockLevel1Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel1, "Presets\" . gameName . "\BethINI-Presets\low\"),0)
				bethMEDlevel1 := Round(getSettingValue("TerrainManager", "fBlockLevel1Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel1, "Presets\" . gameName . "\BethINI-Presets\medium\"),0)
				bethHIlevel1 := Round(getSettingValue("TerrainManager", "fBlockLevel1Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel1, "Presets\" . gameName . "\BethINI-Presets\high\"),0)
				bethULTRAlevel1 := Round(getSettingValue("TerrainManager", "fBlockLevel1Distance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel1, "Presets\" . gameName . "\BethINI-Presets\ultra\"),0)
				bethPOORlevelmax := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\BethINI-Presets\poor\"),0)
				bethLOWlevelmax := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\BethINI-Presets\low\"),0)
				bethMEDlevelmax := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\BethINI-Presets\medium\"),0)
				bethHIlevelmax := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\BethINI-Presets\high\"),0)
				bethULTRAlevelmax := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\BethINI-Presets\ultra\"),0)
				
				MEDsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\Vanilla-Presets\medium\"),3)
				HIsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\Vanilla-Presets\high\"),3)
				ULTRAsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\Vanilla-Presets\ultra\"),3)
			}
if FadeDistantLOD = Low
	{
		level0 = %LOWlevel0%
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition" or gameName = "Fallout 4")
			level1 = %LOWlevel1%
		if gameName = Fallout 4
			level2 = %LOWlevel2%
		levelmax = %LOWlevelmax%
		split = %LOWsplit%
	}
else if FadeDistantLOD = Medium
	{
		level0 = %MEDlevel0%
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition" or gameName = "Fallout 4")
			level1 = %MEDlevel1%
		if gameName = Fallout 4
			level2 = %MEDlevel2%
		levelmax = %MEDlevelmax%
		split = %MEDsplit%
	}
else if FadeDistantLOD = High
	{
		level0 = %HIlevel0%
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition" or gameName = "Fallout 4")
			level1 = %HIlevel1%
		if gameName = Fallout 4
			level2 = %HIlevel2%
		levelmax = %HIlevelmax%
		split = %HIsplit%
	}
else if FadeDistantLOD = Ultra
	{
		level0 = %ULTRAlevel0%
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition" or gameName = "Fallout 4")
			level1 = %ULTRAlevel1%
		if gameName = Fallout 4
			level2 = %ULTRAlevel2%
		levelmax = %ULTRAlevelmax%
		split = %ULTRAsplit%
	}
else if FadeDistantLOD = BethINI Poor
	{
		level0 = %bethPOORlevel0%
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition" or gameName = "Fallout 4")
			level1 = %bethPOORlevel1%
		if gameName = Fallout 4
			level2 = %bethPOORlevel2%
		levelmax = %bethPOORlevelmax%
		split = %bethPOORsplit%
	}
else if FadeDistantLOD = BethINI Low
	{
		level0 = %bethLOWlevel0%
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition" or gameName = "Fallout 4")
			level1 = %bethLOWlevel1%
		if gameName = Fallout 4
			level2 = %bethLOWlevel2%
		levelmax = %bethLOWlevelmax%
		split = %bethLOWsplit%
	}
else if FadeDistantLOD = BethINI Medium
	{
		level0 = %bethMEDlevel0%
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition" or gameName = "Fallout 4")
			level1 = %bethMEDlevel1%
		if gameName = Fallout 4
			level2 = %bethMEDlevel2%
		levelmax = %bethMEDlevelmax%
		split = %bethMEDsplit%
	}
else if FadeDistantLOD = BethINI High
	{
		level0 = %bethHIlevel0%
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition" or gameName = "Fallout 4")
			level1 = %bethHIlevel1%
		if gameName = Fallout 4
			level2 = %bethHIlevel2%
		levelmax = %bethHIlevelmax%
		split = %bethHIsplit%
	}
else if FadeDistantLOD = BethINI Ultra
	{
		level0 = %bethULTRAlevel0%
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition" or gameName = "Fallout 4")
			level1 = %bethULTRAlevel1%
		if gameName = Fallout 4
			level2 = %bethULTRAlevel2%
		levelmax = %bethULTRAlevelmax%
		split = %bethULTRAsplit%
	}
		
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		GuiControl, Main:, FadeDistantLOD4Real, % level0
		GuiControl, Main:, FadeDistantLOD8Real, % level1
		GuiControl, Main:, FadeDistantLOD16Real, % levelmax
		GuiControl, Main:, FadeDistantLODMult, % split
	}
else if gameName = Fallout 4
	{
		GuiControl, Main:, FadeDistantLOD4Real, % level0
		GuiControl, Main:, FadeDistantLOD8Real, % level1
		GuiControl, Main:, FadeDistantLOD16Real, % level2
		GuiControl, Main:, FadeDistantLOD32Real, % levelmax
		GuiControl, Main:, FadeDistantLODMult, % split
	}
else
	{
		GuiControl, Main:, FadeDistantLOD4Real, % level0
		GuiControl, Main:, FadeDistantLOD8Real, % levelmax
		GuiControl, Main:, FadeDistantLODMult, % split
	}
sm("Distant Object Detail has been set to " . FadeDistantLOD . " Quality.")
return

Level4:
FadeDistantLOD4 := getControlValue("FadeDistantLOD4")
GuiControl, Main:, FadeDistantLOD4Real, %FadeDistantLOD4%
return

Level4Real:
FadeDistantLOD4Real := getControlValue("FadeDistantLOD4Real")
GuiControl, Main:, FadeDistantLOD4, %FadeDistantLOD4Real%
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	IniWrite, %FadeDistantLOD4Real%, %INIfolder%%gameNameINI%%Prefs%.ini, TerrainManager, fBlockLevel0Distance
else
	IniWrite, %FadeDistantLOD4Real%, %INIfolder%%gameNameINI%%Prefs%.ini, TerrainManager, fBlockLoadDistanceLow
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"), getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLOD16Real"), getControlValue("FadeDistantLODMult"))
else if gameName = Fallout 4
	FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"), getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLOD32Real"), getControlValue("FadeDistantLODMult"), getControlValue("FadeDistantLOD16Real"))
else if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"),, getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLODMult"))
GuiControl, Main:, FadeDistantLOD, |%FadeDistantLOD%
tempText = Distant Object Detail Level 4 has been set to %FadeDistantLOD4Real%.
sm(tempText)
return

Level8:
FadeDistantLOD8 := getControlValue("FadeDistantLOD8")
GuiControl, Main:, FadeDistantLOD8Real, %FadeDistantLOD8%
return

Level8Real:
FadeDistantLOD8Real := getControlValue("FadeDistantLOD8Real")
GuiControl, Main:, FadeDistantLOD8, %FadeDistantLOD8Real%
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	IniWrite, %FadeDistantLOD8Real%, %INIfolder%%gameNameINI%%Prefs%.ini, TerrainManager, fBlockLevel1Distance
else
	IniWrite, %FadeDistantLOD8Real%, %INIfolder%%gameNameINI%%Prefs%.ini, TerrainManager, fBlockLoadDistance
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"), getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLOD16Real"), getControlValue("FadeDistantLODMult"))
else if gameName = Fallout 4
	FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"), getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLOD32Real"), getControlValue("FadeDistantLODMult"), getControlValue("FadeDistantLOD16Real"))
else if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"),, getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLODMult"))
GuiControl, Main:, FadeDistantLOD, |%FadeDistantLOD%
tempText = Distant Object Detail Level 8 has been set to %FadeDistantLOD8Real%.
sm(tempText)
return

Level16:
FadeDistantLOD16 := getControlValue("FadeDistantLOD16")
GuiControl, Main:, FadeDistantLOD16Real, %FadeDistantLOD16%
return

Level16Real:
FadeDistantLOD16Real := getControlValue("FadeDistantLOD16Real")
GuiControl, Main:, FadeDistantLOD16, %FadeDistantLOD16Real%
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	IniWrite, %FadeDistantLOD16Real%, %INIfolder%%gameNameINI%%Prefs%.ini, TerrainManager, fBlockMaximumDistance
else if gameName = Fallout 4
	IniWrite, %FadeDistantLOD16Real%, %INIfolder%%gameNameINI%%Prefs%.ini, TerrainManager, fBlockLevel2Distance
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"), getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLOD16Real"), getControlValue("FadeDistantLODMult"))
else if gameName = Fallout 4
	FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"), getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLOD32Real"), getControlValue("FadeDistantLODMult"), getControlValue("FadeDistantLOD16Real"))
GuiControl, Main:, FadeDistantLOD, |%FadeDistantLOD%
tempText = Distant Object Detail Level 16 has been set to %FadeDistantLOD16Real%.
sm(tempText)
return

Level32:
FadeDistantLOD32 := getControlValue("FadeDistantLOD32")
GuiControl, Main:, FadeDistantLOD32Real, %FadeDistantLOD32%
return

Level32Real:
FadeDistantLOD32Real := getControlValue("FadeDistantLOD32Real")
GuiControl, Main:, FadeDistantLOD32, %FadeDistantLOD32Real%
IniWrite, %FadeDistantLOD32Real%, %INIfolder%%gameNameINI%%Prefs%.ini, TerrainManager, fBlockMaximumDistance
FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"), getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLOD32Real"), getControlValue("FadeDistantLODMult"), getControlValue("FadeDistantLOD16Real"))
GuiControl, Main:, FadeDistantLOD, |%FadeDistantLOD%
tempText = Distant Object Detail Level 32 has been set to %FadeDistantLOD32Real%.
sm(tempText)
return

DistanceMultiplier:
FadeDistantLODMult := getControlValue("FadeDistantLODMult")
IniWrite, %FadeDistantLODMult%, %INIfolder%%gameNameINI%%Prefs%.ini, TerrainManager, fSplitDistanceMult
if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"), getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLOD16Real"), getControlValue("FadeDistantLODMult"))
else if gameName = Fallout 4
	FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"), getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLOD32Real"), getControlValue("FadeDistantLODMult"), getControlValue("FadeDistantLOD16Real"))
else if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"),, getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLODMult"))
GuiControl, Main:, FadeDistantLOD, |%FadeDistantLOD%
tempText = Landscape LOD multiplier has been set to %FadeDistantLODMult%.
sm(tempText)
return

DecalDraw:
DecalFade := getControlValue("DecalFade")
if DecalFade = Poor
	{
		IniWrite, 0.05, %INIfolder%%gameNameINI%.ini, LightingShader, fDecalLODFadeStart
		IniWrite, 0.06, %INIfolder%%gameNameINI%.ini, LightingShader, fDecalLODFadeEnd
	}
else if DecalFade = Low
	{
		IniWrite, 0.1, %INIfolder%%gameNameINI%.ini, LightingShader, fDecalLODFadeStart
		IniWrite, 0.15, %INIfolder%%gameNameINI%.ini, LightingShader, fDecalLODFadeEnd
	}
else if DecalFade = Medium
	{
		IniWrite, 0.2, %INIfolder%%gameNameINI%.ini, LightingShader, fDecalLODFadeStart
		IniWrite, 0.3, %INIfolder%%gameNameINI%.ini, LightingShader, fDecalLODFadeEnd
	}
else if DecalFade = High
	{
		IniWrite, 0.5, %INIfolder%%gameNameINI%.ini, LightingShader, fDecalLODFadeStart
		IniWrite, 0.6, %INIfolder%%gameNameINI%.ini, LightingShader, fDecalLODFadeEnd
	}
else if DecalFade = Ultra
	{
		IniWrite, 1, %INIfolder%%gameNameINI%.ini, LightingShader, fDecalLODFadeStart
		IniWrite, 1.1, %INIfolder%%gameNameINI%.ini, LightingShader, fDecalLODFadeEnd
	}
sm("Distant Decal Fade has been set to " . DecalFade . ".")
return

uGrids:
uGridsToLoad := getControlValue("uGridsToLoad")
fo4 =
if gameName = Fallout 4
	fo4 = Prefs
if uGridsToLoad < 0
	{
		tempText = A grid of that size would induce CTD! Setting value was not changed.
	}
else if (uGridsToLoad >= 0) and (uGridsToLoad < 5)
	{
		uGridsToLoad = 5
		IniWrite, %uGridsToLoad%, %INIfolder%%gameNameINI%%fo4%.ini, General, uGridsToLoad
		tempText = The grid that will be actively rendered and processed around the PC has been set to %uGridsToLoad% by %uGridsToLoad%.
	}
else if Mod(uGridsToLoad, 2) = 0
	{
		uGridsToLoad := uGridsToLoad + 1
		IniWrite, %uGridsToLoad%, %INIfolder%%gameNameINI%%fo4%.ini, General, uGridsToLoad
		tempText = The grid that will be actively rendered and processed around the PC has been set to %uGridsToLoad% by %uGridsToLoad%.
	}
else if Mod(uGridsToLoad, 2) != 0
	{
		IniWrite, %uGridsToLoad%, %INIfolder%%gameNameINI%%fo4%.ini, General, uGridsToLoad
		tempText = The grid that will be actively rendered and processed around the PC has been set to %uGridsToLoad% by %uGridsToLoad%.
	}
if gameName = Oblivion
	Gosub, GrassFade
IniWrite, % (uGridsToLoad + 1)**2, %INIfolder%%gameNameINI%.ini, General, uExterior Cell Buffer
sm(tempText)
return

/*
fGamma:
fGamma := getControlValue("fGamma")
IniWrite, %fGamma%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fGamma
tempText = Gamma has been set to %fGamma%.
sm(tempText)
return
*/

fGamma:
fGammaReal := Round(getControlValue("fGamma")/1000, 4)
GuiControl, Main:, fGammaReal, %fGammaReal%
return

fGammaReal:
fGammaReal := getControlValue("fGammaReal")
fGamma := getControlValue("fGammaReal")*1000
GuiControl, Main:, fGamma, %fGamma%
IniWrite, %fGammaReal%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fGamma
sm("Gamma has been set to " . fGammaReal . ".")
return

bEnableProjecteUVDiffuseNormals:
bEnableProjecteUVDiffuseNormals := getControlValue("bEnableProjecteUVDiffuseNormals")
IniWrite, %bEnableProjecteUVDiffuseNormals%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bEnableProjecteUVDiffuseNormals
if bEnableProjecteUVDiffuseNormals = 1
	sm("Projected UV diffuse normals are now enabled.")
else if bEnableProjecteUVDiffuseNormals = 0
	sm("Projected UV diffuse normals are now disabled.")
return

fGlobalBrightnessBoost:
fGlobalBrightnessBoostReal := Round(getControlValue("fGlobalBrightnessBoost")/1000, 4)
GuiControl, Main:, fGlobalBrightnessBoostReal, %fGlobalBrightnessBoostReal%
return

fGlobalBrightnessBoostReal:
fGlobalBrightnessBoostReal := getControlValue("fGlobalBrightnessBoostReal")
fGlobalBrightnessBoost := getControlValue("fGlobalBrightnessBoostReal")*1000
GuiControl, Main:, fGlobalBrightnessBoost, %fGlobalBrightnessBoost%
IniWrite, %fGlobalBrightnessBoostReal%, %INIfolder%%gameNameINI%.ini, Display, fGlobalBrightnessBoost
sm("The global brightness boost modifier has been set to " . fGlobalBrightnessBoostReal . ".")
return

fGlobalContrastBoost:
fGlobalContrastBoostReal := Round(getControlValue("fGlobalContrastBoost")/1000, 4)
GuiControl, Main:, fGlobalContrastBoostReal, %fGlobalContrastBoostReal%
return

fGlobalContrastBoostReal:
fGlobalContrastBoostReal := getControlValue("fGlobalContrastBoostReal")
fGlobalContrastBoost := getControlValue("fGlobalContrastBoostReal")*1000
GuiControl, Main:, fGlobalContrastBoost, %fGlobalContrastBoost%
IniWrite, %fGlobalContrastBoostReal%, %INIfolder%%gameNameINI%.ini, Display, fGlobalContrastBoost
sm("The global contrast boost modifier has been set to " . fGlobalContrastBoostReal . ".")
return

fGlobalSaturationBoost:
fGlobalSaturationBoostReal := Round(getControlValue("fGlobalSaturationBoost")/1000, 4)
GuiControl, Main:, fGlobalSaturationBoostReal, %fGlobalSaturationBoostReal%
return

fGlobalSaturationBoostReal:
fGlobalSaturationBoostReal := getControlValue("fGlobalSaturationBoostReal")
fGlobalSaturationBoost := getControlValue("fGlobalSaturationBoostReal")*1000
GuiControl, Main:, fGlobalSaturationBoost, %fGlobalSaturationBoost%
IniWrite, %fGlobalSaturationBoostReal%, %INIfolder%%gameNameINI%.ini, Display, fGlobalSaturationBoost
sm("The global saturation boost modifier has been set to " . fGlobalSaturationBoostReal . ".")
return

RemoveGrass:
RemoveGrass := Abs(getControlValue("RemoveGrass") - 1)
IniWrite, %RemoveGrass%, %INIfolder%%gameNameINI%.ini, Grass, bDrawShaderGrass
if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
	{
		IniWrite, %RemoveGrass%, %INIfolder%%gameNameINI%.ini, Grass, bAllowCreateGrass
		IniWrite, 0, %INIfolder%%gameNameINI%.ini, Grass, bAllowLoadGrass
	}
if RemoveGrass = 1
	sm("Grass is now enabled.")
else if RemoveGrass = 0
	sm("Grass is now disabled.")
return

bEnableGrassFade:
bEnableGrassFade := getControlValue("bEnableGrassFade")
IniWrite, %bEnableGrassFade%, %INIfolder%%gameNameINI%.ini, Grass, bEnableGrassFade
if bEnableGrassFade = 1
	sm("The gradual, fade-in effect for grass is now enabled.")
else if bEnableGrassFade = 0
	sm("The gradual, fade-in effect for grass is now disabled.")
return

GrassWindSpeed:
GrassWindSpeed := getControlValue("GrassWindSpeed")
if GrassWindSpeed = Default
	{
		IniWrite, 5, %INIfolder%%gameNameINI%.ini, Grass, fGrassWindMagnitudeMin
		IniWrite, 125, %INIfolder%%gameNameINI%.ini, Grass, fGrassWindMagnitudeMax
		sm("Grass wind speed has been set to default values.")
	}
else if GrassWindSpeed = None
	{
		IniWrite, 0, %INIfolder%%gameNameINI%.ini, Grass, fGrassWindMagnitudeMin
		IniWrite, 0, %INIfolder%%gameNameINI%.ini, Grass, fGrassWindMagnitudeMax
		sm("Wind no longer moves grass.")
	}
return

GrassDensity:
GrassDensity := getControlValue("GrassDensity")
GuiControl, Main:, GrassDensityReal, %GrassDensity%
return

GrassDensityReal:
GrassDensityReal := getControlValue("GrassDensityReal")
GuiControl, Main:, GrassDensity, %GrassDensityReal%
IniWrite, %GrassDensityReal%, %INIfolder%%gameNameINI%.ini, Grass, iMinGrassSize
tempText = Grass density has been set to %GrassDensityReal% (higher values produce less grass).
sm(tempText)
return

GrassDiversity:
GrassDiversity := getControlValue("GrassDiversity")
GuiControl, Main:, GrassDiversityReal, %GrassDiversity%
return

GrassDiversityReal:
GrassDiversityReal := getControlValue("GrassDiversityReal")
GuiControl, Main:, GrassDiversity, %GrassDiversityReal%
IniWrite, %GrassDiversityReal%, %INIfolder%%gameNameINI%.ini, Grass, iMaxGrassTypesPerTexure
tempText = Grass diversity has been set to %GrassDiversityReal%.
sm(tempText)
return

DynamicTrees:
DynamicTrees := getControlValue("DynamicTrees")
disableGuiControl("SkinnedTrees", getControlValue("DynamicTrees"))
disableGuiControl("TreeAnimations", getControlValue("DynamicTrees"))
disableGuiControl("TreeDetailFade", getControlValue("DynamicTrees"))
IniWrite, %DynamicTrees%, %INIfolder%%gameNameINI%.ini, Trees, bEnableTrees
IniWrite, %DynamicTrees%, %INIfolder%%gameNameINI%.ini, Trees, bEnableTreeAnimations
if DynamicTrees = 1
	sm("Dynamic tree model rendering is now enabled.")
else if DynamicTrees = 0
	sm("Static tree model rendering is now enabled.")
return

SkinnedTrees:
SkinnedTrees := getControlValue("SkinnedTrees")
IniWrite, %SkinnedTrees%, %INIfolder%%gameNameINI%%Prefs%.ini, Trees, bRenderSkinnedTrees
if SkinnedTrees = 1
	sm("Skinned trees are now enabled.")
else if SkinnedTrees = 0
	sm("Skinned trees are now disabled.")
return

bEnableTrees:
bEnableTrees := getControlValue("bEnableTrees")
IniWrite, %bEnableTrees%, %INIfolder%%gameNameINI%.ini, SpeedTree, bEnableTrees
if bEnableTrees = 1
	sm("Trees are now enabled.")
else if bEnableTrees = 0
	sm("Trees are now disabled.")
return

bForceFullLOD:
bForceFullLOD := getControlValue("bForceFullLOD")
IniWrite, %bForceFullLOD%, %INIfolder%%gameNameINI%.ini, SpeedTree, bForceFullLOD
if bForceFullLOD = 1
	sm("Trees shall now display full LOD detail.")
else if bForceFullLOD = 0
	sm("Trees shall not display full LOD detail.")
return

TreeAnimations:
TreeAnimations := getControlValue("TreeAnimations")
if TreeAnimations = 1
	{
		IniWrite, 1.5, %INIfolder%%gameNameINI%.ini, Trees, fUpdateBudget
		sm("Tree animations are now enabled.")
	}
else if TreeAnimations = 0
	{
		IniWrite, 0, %INIfolder%%gameNameINI%.ini, Trees, fUpdateBudget
		sm("Tree animations are now disabled.")
	}
return

TreeDetailFade:
TreeDetailFade := getControlValue("TreeDetailFade")
BethPoorLevel1 := Round(getSettingValue("Display", "fMeshLODLevel1FadeTreeDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTLevel1, "Presets\" . gameName . "\BethINI-Presets\poor\"),0)
BethPoorLevel2 := Round(getSettingValue("Display", "fMeshLODLevel2FadeTreeDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTLevel2, "Presets\" . gameName . "\BethINI-Presets\poor\"),0)
BethPoorMidSwitch := Round(getSettingValue("Display", "fTreesMidLODSwitchDist", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTMidSwitch, "Presets\" . gameName . "\BethINI-Presets\poor\"),0)
BethPoorMaxSkinnedTrees := Round(getSettingValue("Trees", "uiMaxSkinnedTreesToRender", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTMaxSkinnedTrees, "Presets\" . gameName . "\BethINI-Presets\poor\"),0)
BethLowLevel1 := Round(getSettingValue("Display", "fMeshLODLevel1FadeTreeDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTLevel1, "Presets\" . gameName . "\BethINI-Presets\low\"),0)
BethLowLevel2 := Round(getSettingValue("Display", "fMeshLODLevel2FadeTreeDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTLevel2, "Presets\" . gameName . "\BethINI-Presets\low\"),0)
BethLowMidSwitch := Round(getSettingValue("Display", "fTreesMidLODSwitchDist", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTMidSwitch, "Presets\" . gameName . "\BethINI-Presets\low\"),0)
BethLowMaxSkinnedTrees := Round(getSettingValue("Trees", "uiMaxSkinnedTreesToRender", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTMaxSkinnedTrees, "Presets\" . gameName . "\BethINI-Presets\low\"),0)
BethMedLevel1 := Round(getSettingValue("Display", "fMeshLODLevel1FadeTreeDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTLevel1, "Presets\" . gameName . "\BethINI-Presets\medium\"),0)
BethMedLevel2 := Round(getSettingValue("Display", "fMeshLODLevel2FadeTreeDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTLevel2, "Presets\" . gameName . "\BethINI-Presets\medium\"),0)
BethMedMidSwitch := Round(getSettingValue("Display", "fTreesMidLODSwitchDist", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTMidSwitch, "Presets\" . gameName . "\BethINI-Presets\medium\"),0)
BethMedMaxSkinnedTrees := Round(getSettingValue("Trees", "uiMaxSkinnedTreesToRender", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTMaxSkinnedTrees, "Presets\" . gameName . "\BethINI-Presets\medium\"),0)
BethHiLevel1 := Round(getSettingValue("Display", "fMeshLODLevel1FadeTreeDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTLevel1, "Presets\" . gameName . "\BethINI-Presets\high\"),0)
BethHiLevel2 := Round(getSettingValue("Display", "fMeshLODLevel2FadeTreeDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTLevel2, "Presets\" . gameName . "\BethINI-Presets\high\"),0)
BethHiMidSwitch := Round(getSettingValue("Display", "fTreesMidLODSwitchDist", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTMidSwitch, "Presets\" . gameName . "\BethINI-Presets\high\"),0)
BethHiMaxSkinnedTrees := Round(getSettingValue("Trees", "uiMaxSkinnedTreesToRender", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTMaxSkinnedTrees, "Presets\" . gameName . "\BethINI-Presets\high\"),0)
BethUltraLevel1 := Round(getSettingValue("Display", "fMeshLODLevel1FadeTreeDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTLevel1, "Presets\" . gameName . "\BethINI-Presets\ultra\"),0)
BethUltraLevel2 := Round(getSettingValue("Display", "fMeshLODLevel2FadeTreeDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTLevel2, "Presets\" . gameName . "\BethINI-Presets\ultra\"),0)
BethUltraMidSwitch := Round(getSettingValue("Display", "fTreesMidLODSwitchDist", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTMidSwitch, "Presets\" . gameName . "\BethINI-Presets\ultra\"),0)
BethUltraMaxSkinnedTrees := Round(getSettingValue("Trees", "uiMaxSkinnedTreesToRender", gameNameINIWorkaroundForEnderalForgotten . Prefs, DEFAULTMaxSkinnedTrees, "Presets\" . gameName . "\BethINI-Presets\ultra\"),0)
if TreeDetailFade = Default
	{
		IniWrite, 2844, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeTreeDistance
		IniWrite, 2048, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeTreeDistance
		IniWrite, 3600, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fTreesMidLODSwitchDist
		IniWrite, 40, %INIfolder%%gameNameINI%%Prefs%.ini, Trees, uiMaxSkinnedTreesToRender
		sm("Tree detail fade has been set to " . TreeDetailFade . ".")
	}
else if TreeDetailFade = Low
	{
		IniWrite, 2844, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeTreeDistance
		IniWrite, 2048, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeTreeDistance
		IniWrite, 3600, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fTreesMidLODSwitchDist
		IniWrite, 20, %INIfolder%%gameNameINI%%Prefs%.ini, Trees, uiMaxSkinnedTreesToRender
		sm("Tree detail fade has been set to " . TreeDetailFade . ".")
	}
else if TreeDetailFade = High
	{
		IniWrite, 2844, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeTreeDistance
		IniWrite, 2048, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeTreeDistance
		IniWrite, 5000, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fTreesMidLODSwitchDist
		IniWrite, 20, %INIfolder%%gameNameINI%%Prefs%.ini, Trees, uiMaxSkinnedTreesToRender
		sm("Tree detail fade has been set to " . TreeDetailFade . ".")
	}
else if TreeDetailFade = Ultra
	{
		IniWrite, 2844, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeTreeDistance
		IniWrite, 2048, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeTreeDistance
		IniWrite, 9999999, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fTreesMidLODSwitchDist
		if gameName = Skyrim
			IniWrite, 20, %INIfolder%%gameNameINI%%Prefs%.ini, Trees, uiMaxSkinnedTreesToRender
		else if gameName = Skyrim Special Edition
			IniWrite, 40, %INIfolder%%gameNameINI%%Prefs%.ini, Trees, uiMaxSkinnedTreesToRender
		sm("Tree detail fade has been set to " . TreeDetailFade . ".")
	}
else if TreeDetailFade = BethINI Poor
	{
		IniWrite, % BethPoorLevel1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeTreeDistance
		IniWrite, % BethPoorLevel2, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeTreeDistance
		IniWrite, % BethPoorMidSwitch, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fTreesMidLODSwitchDist
		IniWrite, % BethPoorMaxSkinnedTrees, %INIfolder%%gameNameINI%%Prefs%.ini, Trees, uiMaxSkinnedTreesToRender
		sm("Tree detail fade has been set to " . TreeDetailFade . ".")
	}
else if TreeDetailFade = BethINI Low
	{
		IniWrite, % BethLowLevel1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeTreeDistance
		IniWrite, % BethLowLevel2, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeTreeDistance
		IniWrite, % BethLowMidSwitch, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fTreesMidLODSwitchDist
		IniWrite, % BethLowMaxSkinnedTrees, %INIfolder%%gameNameINI%%Prefs%.ini, Trees, uiMaxSkinnedTreesToRender
		sm("Tree detail fade has been set to " . TreeDetailFade . ".")
	}
else if TreeDetailFade = BethINI Medium
	{
		IniWrite, % BethMedLevel1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeTreeDistance
		IniWrite, % BethMedLevel2, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeTreeDistance
		IniWrite, % BethMedMidSwitch, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fTreesMidLODSwitchDist
		IniWrite, % BethMedMaxSkinnedTrees, %INIfolder%%gameNameINI%%Prefs%.ini, Trees, uiMaxSkinnedTreesToRender
		sm("Tree detail fade has been set to " . TreeDetailFade . ".")
	}
else if TreeDetailFade = BethINI High
	{
		IniWrite, % BethHiLevel1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeTreeDistance
		IniWrite, % BethHiLevel2, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeTreeDistance
		IniWrite, % BethHiMidSwitch, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fTreesMidLODSwitchDist
		IniWrite, % BethHiMaxSkinnedTrees, %INIfolder%%gameNameINI%%Prefs%.ini, Trees, uiMaxSkinnedTreesToRender
		sm("Tree detail fade has been set to " . TreeDetailFade . ".")
	}
else if TreeDetailFade = BethINI Ultra
	{
		IniWrite, % BethUltraLevel1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel1FadeTreeDistance
		IniWrite, % BethUltraLevel2, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fMeshLODLevel2FadeTreeDistance
		IniWrite, % BethUltraMidSwitch, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fTreesMidLODSwitchDist
		IniWrite, % BethUltraMaxSkinnedTrees, %INIfolder%%gameNameINI%%Prefs%.ini, Trees, uiMaxSkinnedTreesToRender
		sm("Tree detail fade has been set to " . TreeDetailFade . ".")
	}
else
	sm("No change to tree detail fade has been made.")
return

FarOffTreeDistance:
FarOffTreeDistance := getControlValue("FarOffTreeDistance")
IniWrite, %FarOffTreeDistance%, %INIfolder%%gameNameINI%%Prefs%.ini, TerrainManager, fTreeLoadDistance
tempText = The maximum distance that far-off trees can be displayed has been changed to %FarOffTreeDistance%.
sm(tempText)
return

DisableScreenshots:
DisableScreenshots := Abs(getControlValue("DisableScreenshots") - 1)
if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
	IniWrite, %DisableScreenshots%, %INIfolder%%gameNameINI%.ini, Display, bAllowScreenShot
else
	IniWrite, %DisableScreenshots%, %INIfolder%%gameNameINI%.ini, Display, bScreenshotToFile
if DisableScreenshots = 0
	tempText = The game will no longer create screenshots when the Printscreen key is pressed.
else
	tempText = The game will now create screenshots when the Printscreen key is pressed.
sm(tempText)
return

sScreenShotBaseName:
sScreenShotBaseName := getControlValue("sScreenShotBaseName")
sScreenShotBaseNameFileName := getControlValue("sScreenShotBaseNameFileName")
if sScreenShotBaseName = Browse...
	{
		FileSelectFolder, sScreenShotBaseName
		if ErrorLevel <> 0
			{
				sScreenShotBaseName := getSettingValue("Display", "sScreenShotBaseName", blank, "ScreenShot")
				SplitPath, sScreenShotBaseName, sScreenShotBaseNameFileName, sScreenShotBaseName
				if sScreenShotBaseName =
					sScreenShotBaseName = %gameFolder%
				else
					sScreenShotBaseName .= "\"
				GuiControl, Main:, sScreenShotBaseName, |%sScreenShotBaseName%||Browse...
				return
			}
		sScreenShotBaseName .= "\"
		GuiControl, Main:, sScreenShotBaseName, |%sScreenShotBaseName%||Browse...
	}
else if (SubStr(sScreenShotBaseName, 0) <> "\")
	return
else if !FileExist(sScreenShotBaseName)
	return
IniWrite, %sScreenShotBaseName%%sScreenShotBaseNameFileName%, %INIfolder%%gameNameINI%.ini, Display, sScreenShotBaseName
sm("Screenshots will be saved in the """ . sScreenShotBaseName . """ directory with a base filename of """ . sScreenShotBaseNameFileName . """")
return

iScreenShotIndex:
iScreenShotIndex := getControlValue("iScreenShotIndex")
IniWrite, %iScreenShotIndex%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iScreenShotIndex
sm("The screenshot index number has been set to " . iScreenShotIndex . ".")
return

iConsoleVisibleLines:
iConsoleVisibleLines := getControlValue("iConsoleVisibleLines")
IniWrite, %iConsoleVisibleLines%, %INIfolder%%gameNameINI%.ini, Menu, iConsoleVisibleLines
sm("The maximum number of lines visible in the in-game console has been set to " . iConsoleVisibleLines . ".")
return

bUseJoystick:
bUseJoystick := getControlValue("bUseJoystick")
IniWrite, %bUseJoystick%, %INIfolder%%gameNameINI%.ini, Controls, bUse Joystick
if bUseJoystick = 1
	tempText = The Joystick is now enabled.
else
	tempText = The Joystick is now disabled.
sm(tempText)
return

bAllowConsole:
bAllowConsole := getControlValue("bAllowConsole")
IniWrite, %bAllowConsole%, %INIfolder%%gameNameINI%.ini, Interface, bAllowConsole
if bAllowConsole = 1
	tempText = The console is now enabled.
else
	tempText = The console is now disabled.
sm(tempText)
return

DisableTutorials:
DisableTutorials := Abs(getControlValue("DisableTutorials") - 1)
IniWrite, %DisableTutorials%, %INIfolder%%gameNameINI%.ini, Interface, bShowTutorials
if DisableTutorials = 0
	tempText = The game will no longer display tutorial pop-ups.
else
	tempText = The game will now display tutorial pop-ups.
sm(tempText)
return

FixMapMenuNavigation:
FixMapMenuNavigation := getControlValue("FixMapMenuNavigation")
if FixMapMenuNavigation = 1
	{
		IniWrite, 400, %INIfolder%%gameNameINI%.ini, MapMenu, fMapWorldYawRange
		IniWrite, 0, %INIfolder%%gameNameINI%.ini, MapMenu, fMapWorldMinPitch
		IniWrite, 90, %INIfolder%%gameNameINI%.ini, MapMenu, fMapWorldMaxPitch
		tempText = Map menu navigation has been greatly improved.
	}
else
	{
		IniWrite, 80, %INIfolder%%gameNameINI%.ini, MapMenu, fMapWorldYawRange
		IniWrite, 15, %INIfolder%%gameNameINI%.ini, MapMenu, fMapWorldMinPitch
		IniWrite, 75, %INIfolder%%gameNameINI%.ini, MapMenu, fMapWorldMaxPitch
		tempText = Map menu navigation has been returned to its default state.
	}
sm(tempText)
return

RemoveMapMenuBlur:
RemoveMapMenuBlur := getControlValue("RemoveMapMenuBlur")
if RemoveMapMenuBlur = 1
	{
		IniWrite, 1, %INIfolder%%gameNameINI%.ini, MapMenu, bWorldMapNoSkyDepthBlur
		IniWrite, 0, %INIfolder%%gameNameINI%.ini, MapMenu, fWorldMapDepthBlurScale
		IniWrite, 0, %INIfolder%%gameNameINI%.ini, MapMenu, fWorldMapMaximumDepthBlur
		IniWrite, 0, %INIfolder%%gameNameINI%.ini, MapMenu, fWorldMapNearDepthBlurScale
		tempText = Map menu blur has been removed.
	}
else
	{
		IniWrite, 0, %INIfolder%%gameNameINI%.ini, MapMenu, bWorldMapNoSkyDepthBlur
		IniWrite, 0.3000000119, %INIfolder%%gameNameINI%.ini, MapMenu, fWorldMapDepthBlurScale
		IniWrite, 0.4499999881, %INIfolder%%gameNameINI%.ini, MapMenu, fWorldMapMaximumDepthBlur
		IniWrite, 4, %INIfolder%%gameNameINI%.ini, MapMenu, fWorldMapNearDepthBlurScale
		tempText = Map menu blur settings has been reset to default values.
	}
sm(tempText)
return

BackgroundMouse:
BackgroundMouse := getControlValue("BackgroundMouse")
if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	IniWrite, %BackgroundMouse%, %INIfolder%%gameNameINI%.ini, Controls, bBackgroundMouse
else
	IniWrite, %BackgroundMouse%, %INIfolder%%gameNameINI%.ini, Controls, bBackground Mouse
if BackgroundMouse = 0
	tempText = The mouse will follow default behavior.
else
	tempText = Background mouse activated. Best use it only temporarily.
sm(tempText)
return

ModdersParadiseMode:
ModdersParadiseMode := getControlValue("ModdersParadiseMode")
IniWrite, %ModdersParadiseMode%, %INIfolder%%gameNameINI%.ini, Display, bShowMarkers
if ModdersParadiseMode = 1
	tempText = Modder's Paradise Mode is activated.
else
	tempText = Modder's Paradise Mode is deactivated.
sm(tempText)
return

iAutoSaveCount:
iAutoSaveCount := getControlValue("iAutoSaveCount")
if iAutoSaveCount > 0
	{
		IniWrite, %iAutoSaveCount%, %INIfolder%%gameNameINI%.ini, SaveGame, iAutoSaveCount
		sm("The maximum number of autosaves has been set to " . iAutoSaveCount)
	}
else if iAutoSaveCount =
	{
		return
	}
else if iAutoSaveCount < 1
	{
		IniWrite, 1, %INIfolder%%gameNameINI%.ini, SaveGame, iAutoSaveCount
		GuiControl, Main:, iAutoSaveCount, 1
		sm("The maximum number of autosaves has been set to 1")
	}
return

bVolumetricLightingDisableInterior:
bVolumetricLightingDisableInterior := Abs(getControlValue("bVolumetricLightingDisableInterior") - 1)
IniWrite, %bVolumetricLightingDisableInterior%, %INIfolder%%gameNameINI%.ini, Display, bVolumetricLightingDisableInterior
if bVolumetricLightingDisableInterior = 0
	tempText = Interior Godrays are now enabled.
else
	tempText = Interior Godrays are now disabled.
sm(tempText)
return

DisablePrecipitation:
DisablePrecipitation := Abs(getControlValue("DisablePrecipitation") - 1)
IniWrite, %DisablePrecipitation%, %INIfolder%%gameNameINI%.ini, Weather, bPrecipitation
if DisablePrecipitation = 0
	tempText = Rain and snow effects are now disabled.
else
	tempText = Rain and snow effects are now enabled.
sm(tempText)
return

bUseEyeEnvMapping:
bUseEyeEnvMapping := getControlValue("bUseEyeEnvMapping")
IniWrite, %bUseEyeEnvMapping%, %INIfolder%%gameNameINI%.ini, General, bUseEyeEnvMapping
if bUseEyeEnvMapping = 0
	tempText = Eye Environment Mapping has been disabled.
else
	tempText = Eye Environment Mapping has been enabled.
sm(tempText)
return

iMaxDesired:
iMaxDesired := getControlValue("iMaxDesired")
IniWrite, %iMaxDesired%, %INIfolder%%gameNameINI%%Prefs%.ini, Particles, iMaxDesired
sm("The particle count has been set to " . iMaxDesired)
return

PreciseLighting:
PreciseLighting := getControlValue("PreciseLighting")
IniWrite, %PreciseLighting%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, bFloatPointRenderTarget
if PreciseLighting = 1
	tempText = Precise lighting is now enabled.
else
	tempText = Precise lighting is now disabled.
sm(tempText)
return

RecommendedTweaks:
RecommendedTweaks := getControlValue("RecommendedTweaks")
if RecommendedTweaks = 1
	{
		if gameName = Skyrim
			{
				IniWrite, 12288, %INIfolder%%gameNameINI%.ini, Actor, fVisibleNavmeshMoveDist
				IniWrite, 10, %INIfolder%%gameNameINI%.ini, Camera, fMouseWheelZoomSpeed
				IniWrite, 0.7, %INIfolder%%gameNameINI%.ini, Combat, f1PArrowTiltUpAngle
				IniWrite, 0.7, %INIfolder%%gameNameINI%.ini, Combat, f3PArrowTiltUpAngle ;this might want to remove
				IniWrite, 0.7, %INIfolder%%gameNameINI%.ini, Combat, f1PBoltTiltUpAngle
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Display, bAllowScreenShot
				IniWrite, 0.25, %INIfolder%%gameNameINI%.ini, Display, fSunShadowUpdateTime
				IniWrite, 1.5, %INIfolder%%gameNameINI%.ini, Display, fSunUpdateThreshold
				IniWrite, % blank, %INIfolder%%gameNameINI%.ini, General, sIntroSequence
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Grass, bAllowLoadGrass
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Interface, bShowTutorials
				IniWrite, 400, %INIfolder%%gameNameINI%.ini, MapMenu, fMapWorldYawRange
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, MapMenu, fMapWorldMinPitch
				IniWrite, 90, %INIfolder%%gameNameINI%.ini, MapMenu, fMapWorldMaxPitch
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Papyrus, bEnableLogging
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Papyrus, bEnableProfiling
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Papyrus, bEnableTrace
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Papyrus, bLoadDebugInformation
				IniWrite, 2000, %INIfolder%%gameNameINI%.ini, Papyrus, fPostLoadUpdateTimeMS
				IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Launcher, bEnableFileSelection
				IniWrite, 600000, %INIfolder%%gameNameINI%%Prefs%.ini, MAIN, fSkyCellRefFadeDistance  ;this might want to remove
			}
		else if gameName = Skyrim Special Edition
			{
				IniWrite, 10, %INIfolder%%gameNameINI%.ini, Camera, fMouseWheelZoomSpeed
				IniWrite, 0.7, %INIfolder%%gameNameINI%.ini, Combat, f1PArrowTiltUpAngle
				IniWrite, 0.7, %INIfolder%%gameNameINI%.ini, Combat, f1PBoltTiltUpAngle
				IniWrite, % blank, %INIfolder%%gameNameINI%.ini, General, sIntroSequence
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Interface, bShowTutorials
				IniWrite, 400, %INIfolder%%gameNameINI%.ini, MapMenu, fMapWorldYawRange
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, MapMenu, fMapWorldMinPitch
				IniWrite, 90, %INIfolder%%gameNameINI%.ini, MapMenu, fMapWorldMaxPitch
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Papyrus, bEnableLogging
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Papyrus, bEnableProfiling
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Papyrus, bEnableTrace
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Papyrus, bLoadDebugInformation
				IniWrite, 2000, %INIfolder%%gameNameINI%.ini, Papyrus, fPostLoadUpdateTimeMS
			}
		else if gameName = Oblivion
			{
				IniWrite, % blank, %INIfolder%%gameNameINI%.ini, General, sIntroSequence
				IniWrite, % blank, %INIfolder%%gameNameINI%.ini, General, sMainMenuMovieIntro
			}
		else if gameName = Fallout 3
			{
				IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Launcher, bEnableFileSelection
			}
		else if gameName = Fallout New Vegas
			{
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, SMainMenuMovieIntro
				IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Launcher, bEnableFileSelection
			}
		else if gameName = Fallout 4
			{
				IniWrite, 1, %INIfolder%%gameNameINI%.ini, Archive, bInvalidateOlderFiles
				IniWrite, % blank, %INIfolder%%gameNameINI%.ini, Archive, sResourceDataDirsFinal
				IniWrite, 0.042, %INIfolder%%gameNameINI%.ini, Controls, fMouseHeadingYScale
				IniWrite, % blank, %INIfolder%%gameNameINI%.ini, General, sIntroSequence
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, fChancesToPlayAlternateIntro
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, uMainMenuDelayBeforeAllowSkip
				IniWrite, 3600, %INIfolder%%gameNameINI%.ini, General, fEncumberedReminderTimer
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Gameplay, fPlayerDisableSprintingLoadingCellDistance
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Grass, bAllowLoadGrass
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Papyrus, bEnableLogging
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Papyrus, bEnableProfiling
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Papyrus, bEnableTrace
				IniWrite, 0, %INIfolder%%gameNameINI%.ini, Papyrus, bLoadDebugInformation
				IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Launcher, bEnableFileSelection
			}
		refreshGUI()
		sleep, 1000
		sm("Recommended tweaks have been automatically applied.")
	}
else
	sm("Recommended tweaks shall not be automatically applied.")
return

MaintainENBCompatibility:
MaintainENBCompatibility := getControlValue("MaintainENBCompatibility")
if getControlValue("ShadowRemoval") = 0
	{
		disableGuiControl("ShadowDeffer", MaintainENBCompatibility)
		disableGuiControl("ShadowLand", MaintainENBCompatibility)
		disableGuiControl("ShadowGrass", MaintainENBCompatibility)
		disableGuiControl("ShadowTrees", MaintainENBCompatibility)
	}
if MaintainENBCompatibility = 1
	{
		GuiControl, Main:, ShadowRemoval, 0
		Gosub, ShadowRemoval
		if getControlValue("ShadowRes") = 1
			GuiControl, Main:, ShadowRes, |256|512|1024||2048|4096|8192
		GuiControl, Main:, ShadowDeffer, 1
		GuiControl, Main:, ShadowLand, 1
		GuiControl, Main:, PreciseLighting, 1
		GuiControl, Main:, ShadowGrass, 1
		GuiControl, Main:, ShadowTrees, 1
		ShadowBlur := getControlValue("ShadowBlur")
		if ShadowBlur = none
			GuiControl, Main:, ShadowBlur, |none|1||3|4|5|7|max
		GuiControl, Main:, Antialiasing, |None||2x|4x|8x|16x
		GuiControl, Main:, DepthOfField, 1
		Gosub, ShadowResolution
		Gosub, DeferredShadows
		Gosub, LandShadows
		Gosub, PreciseLighting
		Gosub, GrassShadows
		Gosub, TreeShadows
		Gosub, ShadowBlurring
		Gosub, Antialiasing
		Gosub, DepthofField
		tempText = All ENB settings have been corrected.
		sm(tempText)
	}
enableGuiControl("ShadowRemoval", MaintainENBCompatibility)
enableGuiControl("ShadowDeffer", MaintainENBCompatibility)
enableGuiControl("ShadowLand", MaintainENBCompatibility)
enableGuiControl("PreciseLighting", MaintainENBCompatibility)
enableGuiControl("ShadowGrass", MaintainENBCompatibility)
enableGuiControl("ShadowTrees", MaintainENBCompatibility)
enableGuiControl("Antialiasing", MaintainENBCompatibility)
enableGuiControl("DepthOfField", MaintainENBCompatibility)
if getControlValue("ShadowRemoval") = 1
	{
		disableGuiControl("ShadowDeffer", MaintainENBCompatibility)
		disableGuiControl("ShadowLand", MaintainENBCompatibility)
		disableGuiControl("ShadowGrass", MaintainENBCompatibility)
		disableGuiControl("ShadowTrees", MaintainENBCompatibility)
	}
return

AlwaysRunbyDefault:
AlwaysRunbyDefault := getControlValue("AlwaysRunbyDefault")
if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	IniWrite, %AlwaysRunbyDefault%, %INIfolder%%gameNameINI%%Prefs%.ini, Controls, bAlwaysRunByDefault
else
	IniWrite, %AlwaysRunbyDefault%, %INIfolder%%gameNameINI%.ini, Controls, bAlwaysRunByDefault
if AlwaysRunbyDefault = 1
	tempText = The PC will now always run by default.
else
	tempText = The PC will now always walk by default.
sm(tempText)
return

fGlobalTimeMultiplier:
fGlobalTimeMultiplier := getControlValue("fGlobalTimeMultiplier")
IniWrite, %fGlobalTimeMultiplier%, %INIfolder%%gameNameINI%.ini, General, fGlobalTimeMultiplier
sm("Time will move at " . fGlobalTimeMultiplier . "x speed.")
return

bInstantLevelUp:
bInstantLevelUp := getControlValue("bInstantLevelUp")
IniWrite, %bInstantLevelUp%, %INIfolder%%gameNameINI%.ini, GamePlay, bInstantLevelUp
if bInstantLevelUp = 1
	tempText = You no longer need to rest in order to level up.
else
	tempText = You need to rest in order to level up.
sm(tempText)
return

bBorderRegionsEnabled:
bBorderRegionsEnabled := Abs(getControlValue("bBorderRegionsEnabled") - 1)
IniWrite, %bBorderRegionsEnabled%, %INIfolder%%gameNameINI%.ini, General, bBorderRegionsEnabled
if bBorderRegionsEnabled = 1
	tempText = You can no longer go beyond the borders of the map.
else
	tempText = You can now go beyond the borders of the map.
sm(tempText)
return

bForceNPCsUseAmmo:
bForceNPCsUseAmmo := getControlValue("bForceNPCsUseAmmo")
IniWrite, %bForceNPCsUseAmmo%, %INIfolder%%gameNameINI%.ini, Combat, bForceNPCsUseAmmo
if bForceNPCsUseAmmo = 1
	tempText = NPCs no longer have unlimited ammo.
else
	tempText = NPCs now have unlimited ammo.
sm(tempText)
return

bDisableCombatDialogue:
bDisableCombatDialogue := getControlValue("bDisableCombatDialogue")
IniWrite, %bDisableCombatDialogue%, %INIfolder%%gameNameINI%.ini, Combat, bDisableCombatDialogue
if bDisableCombatDialogue = 1
	tempText = Combat dialogue is now disabled.
else
	tempText = Combat dialogue is now enabled.
sm(tempText)
return

fEncumberedReminderTimer:
fEncumberedReminderTimer := getControlValue("fEncumberedReminderTimer")
IniWrite, %fEncumberedReminderTimer%, %INIfolder%%gameNameINI%.ini, General, fEncumberedReminderTimer
sm("Over-Encumbered messages will repeat every " . fEncumberedReminderTimer . " seconds.")
return

fPlayerDisableSprintingLoadingCellDistance:
fPlayerDisableSprintingLoadingCellDistance := getControlValue("fPlayerDisableSprintingLoadingCellDistance")
if fPlayerDisableSprintingLoadingCellDistance = 1
	{
		fPlayerDisableSprintingLoadingCellDistance = 0
		tempText = Sprinting is always allowed.
	}
else
	{
		fPlayerDisableSprintingLoadingCellDistance = 4096
		tempText = Sprinting is not allowed near cells that are still loading.
	}
IniWrite, %fPlayerDisableSprintingLoadingCellDistance%, %INIfolder%%gameNameINI%.ini, GamePlay, fPlayerDisableSprintingLoadingCellDistance
sm(tempText)
return

f1PArrowTiltUpAngle:
f1PArrowTiltUpAngle := getControlValue("f1PArrowTiltUpAngle")
IniWrite, %f1PArrowTiltUpAngle%, %INIfolder%%gameNameINI%.ini, Combat, f1PArrowTiltUpAngle
sm("1st Person Arrow Tilt-up Angle set to " . f1PArrowTiltUpAngle)
return

f3PArrowTiltUpAngle:
f3PArrowTiltUpAngle := getControlValue("f3PArrowTiltUpAngle")
IniWrite, %f3PArrowTiltUpAngle%, %INIfolder%%gameNameINI%.ini, Combat, f3PArrowTiltUpAngle
sm("3rd Person Arrow Tilt-up Angle set to " . f3PArrowTiltUpAngle)
return

f1PBoltTiltUpAngle:
f1PBoltTiltUpAngle := getControlValue("f1PBoltTiltUpAngle")
IniWrite, %f1PBoltTiltUpAngle%, %INIfolder%%gameNameINI%.ini, Combat, f1PBoltTiltUpAngle
sm("1st Person Bolt Tilt-up Angle set to " . f1PBoltTiltUpAngle)
return

ShowQuestMarkers:
ShowQuestMarkers := getControlValue("ShowQuestMarkers")
IniWrite, %ShowQuestMarkers%, %INIfolder%%gameNameINI%%Prefs%.ini, GamePlay, bShowQuestMarkers
if ShowQuestMarkers = 1
	tempText = Quest markers are now enabled.
else
	tempText = Quest markers are now disabled.
sm(tempText)
return

bEnablePlatform:
bEnablePlatform := getControlValue("bEnablePlatform")
IniWrite, %bEnablePlatform%, %INIfolder%%gameNameINI%.ini, Bethesda.net, bEnablePlatform
if bEnablePlatform = 1
	tempText = Bethesda Mod Platform is now enabled.
else
	tempText = Bethesda Mod Platform is now disabled.
sm(tempText)
return

bModManagerMenuEnabled:
bModManagerMenuEnabled := getControlValue("bModManagerMenuEnabled")
IniWrite, %bModManagerMenuEnabled%, %INIfolder%%gameNameINI%.ini, General, bModManagerMenuEnabled
if bModManagerMenuEnabled = 1
	sm("In-game mod manager enabled.")
else
	sm("In-game mod manager disabled.")
return

bAutoSizeQuickContainer:
bAutoSizeQuickContainer := getControlValue("bAutoSizeQuickContainer")
IniWrite, %bAutoSizeQuickContainer%, %INIfolder%%gameNameINI%.ini, Interface, bAutoSizeQuickContainer
if bAutoSizeQuickContainer = 1
	tempText = Autosizing the loot box is now enabled.
else
	tempText = Autosizing the loot box is now disabled.
sm(tempText)
return


ShowCompass:
ShowCompass := getControlValue("ShowCompass")
IniWrite, %ShowCompass%, %INIfolder%%gameNameINI%%Prefs%.ini, Interface, bShowCompass
if ShowCompass = 1
	tempText = The compass is now enabled.
else
	tempText = The compass is now disabled.
sm(tempText)
return

iConsoleTextSize:
iConsoleTextSize := getControlValue("iConsoleTextSize")
IniWrite, %iConsoleTextSize%, %INIfolder%%gameNameINI%.ini, % "Menu", iConsoleTextSize
sm("The console text size has been set to " . iConsoleTextSize . ".")
return

iConsoleSizeScreenPercent:
iConsoleSizeScreenPercent := getControlValue("iConsoleSizeScreenPercent")
IniWrite, %iConsoleSizeScreenPercent%, %INIfolder%%gameNameINI%.ini, % "Menu", iConsoleSizeScreenPercent
sm("The percentage of the screen that the console can fill has been set to " . iConsoleSizeScreenPercent . "%.")
return

bDialogueSubtitles:
bDialogueSubtitles := getControlValue("bDialogueSubtitles")
if (gameName = "Oblivion" or gameName = "Fallout New Vegas" or gameName = "Fallout 3")
	IniWrite, %bDialogueSubtitles%, %INIfolder%%gameNameINI%%Prefs%.ini, GamePlay, bDialogueSubtitles
else
	IniWrite, %bDialogueSubtitles%, %INIfolder%%gameNameINI%%Prefs%.ini, Interface, bDialogueSubtitles
if bDialogueSubtitles = 1
	tempText = Dialogue subtitles are now enabled.
else
	tempText = Dialogue subtitle are now disabled.
sm(tempText)
return

bGeneralSubtitles:
bGeneralSubtitles := getControlValue("bGeneralSubtitles")
if (gameName = "Oblivion" or gameName = "Fallout New Vegas" or gameName = "Fallout 3")
	IniWrite, %bGeneralSubtitles%, %INIfolder%%gameNameINI%%Prefs%.ini, GamePlay, bGeneralSubtitles
else
	IniWrite, %bGeneralSubtitles%, %INIfolder%%gameNameINI%%Prefs%.ini, Interface, bGeneralSubtitles
if bGeneralSubtitles = 1
	tempText = General subtitles are now enabled.
else
	tempText = General subtitle are now disabled.
sm(tempText)
return

FlickeringLightDistance:
;FlickeringLightDistance, 
FlickeringLightDistance := getControlValue("FlickeringLightDistance")
IniWrite, %FlickeringLightDistance%, %INIfolder%%gameNameINI%.ini, General, fFlickeringLightDistance
tempText = The distance that flickering lights might be seen has been set to %FlickeringLightDistance%.
sm(tempText)
return

EnableLogging:
EnableLogging := getControlValue("EnableLogging")
IniWrite, %EnableLogging%, %INIfolder%%gameNameINI%.ini, Papyrus, bEnableLogging
if EnableLogging = 1
	tempText = Papyrus logging is enabled.
else
	tempText = Papyrus logging is disabled.
sm(tempText)
return

EnableProfiling:
EnableProfiling := getControlValue("EnableProfiling")
IniWrite, %EnableProfiling%, %INIfolder%%gameNameINI%.ini, Papyrus, bEnableProfiling
if EnableProfiling = 1
	tempText = Script profiling is enabled.
else
	tempText = Script profiling is disabled.
sm(tempText)
return

EnableTrace:
EnableTrace := getControlValue("EnableTrace")
IniWrite, %EnableTrace%, %INIfolder%%gameNameINI%.ini, Papyrus, bEnableTrace
if EnableTrace = 1
	tempText = Script tracing is enabled.
else
	tempText = Script tracing is disabled.
sm(tempText)
return

LoadDebugInformation:
LoadDebugInformation := getControlValue("LoadDebugInformation")
IniWrite, %LoadDebugInformation%, %INIfolder%%gameNameINI%.ini, Papyrus, bLoadDebugInformation
if LoadDebugInformation = 1
	tempText = Script debug information is enabled.
else
	tempText = Script debug information is disabled.
sm(tempText)
return

bBackgroundLoadVMData:
bBackgroundLoadVMData := getControlValue("bBackgroundLoadVMData")
IniWrite, %bBackgroundLoadVMData%, %INIfolder%%gameNameINI%.ini, General, bBackgroundLoadVMData
if bBackgroundLoadVMData = 1
	tempText = Scripting VM background loading is enabled.
else
	tempText = Scripting VM background loading is disabled.
sm(tempText)
return

PostLoadUpdateTimeMS:
PostLoadUpdateTimeMS := getControlValue("PostLoadUpdateTimeMS")
IniWrite, %PostLoadUpdateTimeMS%, %INIfolder%%gameNameINI%.ini, Papyrus, fPostLoadUpdateTimeMS
tempText = The time given to scripts during loading has been set to %PostLoadUpdateTimeMS% milliseconds.
sm(tempText)
return

MouseHeadingSensitivity:
if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	MouseHeadingSensitivity := Round(getControlValue("MouseHeadingSensitivity")/100, 4)
else
	MouseHeadingSensitivity := Round(getControlValue("MouseHeadingSensitivity")/1000, 4)
GuiControl, Main:, MouseHeadingSensitivityReal, %MouseHeadingSensitivity%
return

MouseHeadingSensitivityReal:
MouseHeadingSensitivityReal := getControlValue("MouseHeadingSensitivityReal")
if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	MouseHeadingSensitivity := getControlValue("MouseHeadingSensitivityReal")*100
else
	MouseHeadingSensitivity := getControlValue("MouseHeadingSensitivityReal")*1000
MouseHeadingSensitivityMax := Round(MouseHeadingSensitivityReal + 0.05, 4)
GuiControl, Main:, MouseHeadingSensitivity, %MouseHeadingSensitivity%
if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
	{
		IniWrite, %MouseHeadingSensitivityMax%, %INIfolder%%gameNameINI%.ini, Controls, fMouseHeadingSensitivityMax
		IniWrite, %MouseHeadingSensitivityReal%, %INIfolder%%gameNameINI%%Prefs%.ini, Controls, fMouseHeadingSensitivity
	}
else
	IniWrite, %MouseHeadingSensitivityReal%, %INIfolder%%gameNameINI%%Prefs%.ini, Controls, fMouseSensitivity
tempText = Lock sensitivity has been set to %MouseHeadingSensitivityReal%.
sm(tempText)
return

MouseCursorSpeed:
MouseCursorSpeedReal := Round(getControlValue("MouseCursorSpeed")/10, 2)
GuiControl, Main:, MouseCursorSpeedReal, %MouseCursorSpeedReal%
return

MouseCursorSpeedReal:
MouseCursorSpeedReal := getControlValue("MouseCursorSpeedReal")
MouseCursorSpeed := getControlValue("MouseCursorSpeedReal")*10
GuiControl, Main:, MouseCursorSpeed, %MouseCursorSpeed%
IniWrite, %MouseCursorSpeedReal%, %INIfolder%%gameNameINI%%Prefs%.ini, Interface, fMouseCursorSpeed
tempText = Cursor velocity has been set to %MouseCursorSpeedReal%.
sm(tempText)
return

MouseZoomSpeed:
MouseZoomSpeed := getControlValue("MouseZoomSpeed")
IniWrite, %MouseZoomSpeed%, %INIfolder%%gameNameINI%.ini, Camera, fMouseWheelZoomSpeed
sm("Mouse Wheel Zoom Speed has been set to " . MouseZoomSpeed . ".")
return

MouseHeadingXScale:
MouseHeadingXScale := getControlValue("MouseHeadingXScale")
IniWrite, %MouseHeadingXScale%, %INIfolder%%gameNameINI%.ini, Controls, fMouseHeadingXScale
tempText = Mouse X scale set to %MouseHeadingXScale%.
sm(tempText)
return

MouseHeadingYScale:
MouseHeadingYScale := getControlValue("MouseHeadingYScale")
IniWrite, %MouseHeadingYScale%, %INIfolder%%gameNameINI%.ini, Controls, fMouseHeadingYScale
tempText = Mouse Y scale set to %MouseHeadingYScale%.
sm(tempText)
return

SectionNames:
SectionName := getControlValue("SectionNames")
sm(SectionName . " was the section chosen.")
IniRead, SettingNames1, % "Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . ".ini", %SectionName%
IniRead, SettingNames2, % "Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . Prefs . ".ini", %SectionName%
SettingNames = %SettingNames1%`n%SettingNames2%
StringReplace, SettingNames, SettingNames, `n, |, All
Sort, SettingNames, D| U
SettingNames := LTrim(RegExReplace(SettingNames, "=[^\|]*", "|"), "|")
GuiControl, Main:, SettingNames, |%SettingNames%
if SectionName !=
	{
		GuiControl, Enable, SettingNames
		GuiControl, Enable, CustomSettingValue
	}
Gosub, SettingNames
return

SettingNames:
SettingName := getControlValue("SettingNames")
sm(SettingName . " was the setting chosen.")
SectionName := getControlValue("SectionNames")
DefaultValue := getSettingValue(SectionName, SettingName, gameNameINIWorkaroundForEnderalForgotten, "DoesNotExist", "Presets\" . gameName . "\")
if DefaultValue = DoesNotExist
	DefaultValue := getSettingValue(SectionName, SettingName, gameNameINIWorkaroundForEnderalForgotten . Prefs, "Failed to retrieve a default value.", "Presets\" . gameName . "\")
CurrentValue := getSettingValue(SectionName, SettingName, Prefs, "DoesNotExist")
if CurrentValue = DoesNotExist
	CurrentValue := getSettingValue(SectionName, SettingName, blank, DefaultValue)
if SettingName =
	{
		GuiControl, Disable, CustomSettingValue
		CurrentValue =
	}
else
	GuiControl, Enable, CustomSettingValue
GuiControl, Main:, CustomSettingValue, %CurrentValue%
return

CustomSettingValue:
return

ButtonConfirmCustom:
SectionName := getControlValue("SectionNames")
SettingName := getControlValue("SettingNames")
CustomSettingValue := getControlValue("CustomSettingValue")
DefaultValue := getSettingValue(SectionName, SettingName, gameNameINIWorkaroundForEnderalForgotten, "DoesNotExist", "Presets\" . gameName . "\")
if DefaultValue = DoesNotExist
	{
		InBaseINI = false
		DefaultValue := getSettingValue(SectionName, SettingName, gameNameINIWorkaroundForEnderalForgotten . Prefs, "Failed to retrieve a default value.", "Presets\" . gameName . "\")
		if DefaultValue = DoesNotExist
			InPrefsINI = false
		else
			InPrefsINI = true
	}
else
	InBaseINI = true
if InBaseINI = true
	{
		sm(SettingName . ":" . SectionName . " found in base INI file.")
		IniWrite, %CustomSettingValue%, %INIfolder%%gameNameINI%.ini, %SectionName%, %SettingName%
		refreshGUI()
		sm(SettingName . ":" . SectionName . " set to " . CustomSettingValue . " in the " gameNameINI . ".ini file.")
	}
else if InPrefsINI = true
	{
		sm(SettingName . ":" . SectionName . " found in Prefs INI file.")
		IniWrite, %CustomSettingValue%, %INIfolder%%gameNameINI%%Prefs%.ini, %SectionName%, %SettingName%
		refreshGUI()
		sm(SettingName . ":" . SectionName . " set to " . CustomSettingValue . " in the " gameNameINI . Prefs . ".ini file.")
	}
else
	sm("Error. Failed to determine where to save custom value. Contact me if you get this. INI file was not changed.")
return

CustomTab:
IniRead, SectionNames1, % "Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . ".ini"
IniRead, SectionNames2, % "Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . Prefs . ".ini"
StringReplace, SectionNames1, SectionNames1, `n, |, All
StringReplace, SectionNames2, SectionNames2, `n, |, All
SectionNames := SectionNames1 . "|" . SectionNames2
Sort, SectionNames, D| U
GuiControl, Main:, SectionNames, |%SectionNames%
SectionName := getControlValue("SectionNames")
if SectionName !=
	{
		GuiControl, Enable, SettingNames
		GuiControl, Enable, CustomSettingValue
	}
else
	{
		GuiControl, Main:, SettingNames, |%blank%
		GuiControl, Disable, SettingNames
		GuiControl, Main:, CustomSettingValue, %blank%
		GuiControl, Disable, CustomSettingValue
	}
return

ChooseColorOK:
Gui, ChooseColor:Submit
RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
Gui, ColorPreview:Destroy
return

ChooseColorGuiClose:
Gui, ColorPreview:Destroy
Gui, ChooseColor:Destroy
return

ChooseColorCancel:
RGBvalue:="None Chosen"
gosub ChooseColorGuiClose
return

ColorEdit:
	GuiControlGet,RedValue,,EditRed
	GuiControlGet,GreenValue,,EditGreen
	GuiControlGet,BlueValue,,EditBlue
	if (AlphaValue <> "No")
		GuiControlGet,AlphaValue,,EditAlpha

	gosub PreviewColor
	
	GuiControl,ChooseColor:,UpDownRed,%RedValue%
	GuiControl,ChooseColor:,UpDownGreen,%GreenValue%
	GuiControl,ChooseColor:,UpDownBlue,%BlueValue%
	if (AlphaValue <> "No")
		GuiControl,ChooseColor:,UpDownAlpha,%AlphaValue%
	GuiControl,ChooseColor:,SliderRed,%RedValue%
	GuiControl,ChooseColor:,SliderGreen,%GreenValue%
	GuiControl,ChooseColor:,SliderBlue,%BlueValue%
	if (AlphaValue <> "No")
		GuiControl,ChooseColor:,SliderAlpha,%AlphaValue%
		
	if (AlphaValue <> "No") and HexColorCode = 1 and DifferentOrder = 0
		GuiControl,ColorPreview:,HexColor, % "0x" . Format("{1:02X}", AlphaValue) . Format("{1:02X}{2:02X}{3:02X}", RedValue, GreenValue, BlueValue)
	else if (AlphaValue <> "No") and HexColorCode = 2 and DifferentOrder = 0
		GuiControl,ColorPreview:,HexColor, % Format("{:i}","0x" Format("{1:02X}{2:02X}{3:02X}{4:02X}", RedValue, GreenValue, BlueValue, AlphaValue))
	else if (AlphaValue <> "No") and HexColorCode = 1 and DifferentOrder = 1
		GuiControl,ColorPreview:,HexColor, % "0x" . Format("{1:02X}", AlphaValue) . Format("{1:02X}{2:02X}{3:02X}", BlueValue, GreenValue, RedValue)
	else if HexColorCode = 1
		GuiControl,ColorPreview:,HexColor, % "0x" . Format("{1:02X}{2:02X}{3:02X}", RedValue, GreenValue, BlueValue)
	else if HexColorCode = 2
		GuiControl,ColorPreview:,HexColor, % Format("{:i}","0x" Format("{1:02X}{2:02X}{3:02X}", RedValue, GreenValue, BlueValue))
	else
		GuiControl,ColorPreview:,HexColor, % RedValue . "," . GreenValue . "," . BlueValue
		
	if (AlphaValue <> "No")
		{
			AlphaValueWindow := AlphaValue/255*100+155
			WinSet, Transparent, %AlphaValueWindow%, Color Preview
		}
return

ColorUpDown:
	GuiControlGet,RedValue,,UpDownRed
	GuiControlGet,GreenValue,,UpDownGreen
	GuiControlGet,BlueValue,,UpDownBlue
	if (AlphaValue <> "No")
		GuiControlGet,AlphaValue,,UpDownAlpha

	gosub PreviewColor

	GuiControl,ChooseColor:,EditRed,%RedValue%
	GuiControl,ChooseColor:,EditGreen,%GreenValue%
	GuiControl,ChooseColor:,EditBlue,%BlueValue%
	if (AlphaValue <> "No")
		GuiControl,ChooseColor:,EditAlpha,%AlphaValue%
	GuiControl,ChooseColor:,SliderRed,%RedValue%
	GuiControl,ChooseColor:,SliderGreen,%GreenValue%
	GuiControl,ChooseColor:,SliderBlue,%BlueValue%
	if (AlphaValue <> "No")
		GuiControl,ChooseColor:,SliderAlpha,%AlphaValue%
		
	if (AlphaValue <> "No") and HexColorCode = 1 and DifferentOrder = 0
		GuiControl,ColorPreview:,HexColor, % "0x" . Format("{1:02X}", AlphaValue) . Format("{1:02X}{2:02X}{3:02X}", RedValue, GreenValue, BlueValue)
	else if (AlphaValue <> "No") and HexColorCode = 2 and DifferentOrder = 0
		GuiControl,ColorPreview:,HexColor, % Format("{:i}","0x" Format("{1:02X}{2:02X}{3:02X}{4:02X}", RedValue, GreenValue, BlueValue, AlphaValue))
	else if (AlphaValue <> "No") and HexColorCode = 1 and DifferentOrder = 1
		GuiControl,ColorPreview:,HexColor, % "0x" . Format("{1:02X}", AlphaValue) . Format("{1:02X}{2:02X}{3:02X}", BlueValue, GreenValue, RedValue)
	else if HexColorCode = 1
		GuiControl,ColorPreview:,HexColor, % "0x" . Format("{1:02X}{2:02X}{3:02X}", RedValue, GreenValue, BlueValue)
	else if HexColorCode = 2
		GuiControl,ColorPreview:,HexColor, % Format("{:i}","0x" Format("{1:02X}{2:02X}{3:02X}", RedValue, GreenValue, BlueValue))
	else
		GuiControl,ColorPreview:,HexColor, % RedValue . "," . GreenValue . "," . BlueValue
		
	if (AlphaValue <> "No")
		{
			AlphaValueWindow := AlphaValue/255*100+155
			WinSet, Transparent, %AlphaValueWindow%, Color Preview
		}
return

ColorSlide:
	GuiControlGet,RedValue,,SliderRed
	GuiControlGet,GreenValue,,SliderGreen
	GuiControlGet,BlueValue,,SliderBlue
	if (AlphaValue <> "No")
		GuiControlGet,AlphaValue,,SliderAlpha

	gosub PreviewColor

	GuiControl,ChooseColor:,EditRed,%RedValue%
	GuiControl,ChooseColor:,EditGreen,%GreenValue%
	GuiControl,ChooseColor:,EditBlue,%BlueValue%
	if (AlphaValue <> "No")
		GuiControl,ChooseColor:,EditAlpha,%AlphaValue%
	GuiControl,ChooseColor:,UpDownRed,%RedValue%
	GuiControl,ChooseColor:,UpDownGreen,%GreenValue%
	GuiControl,ChooseColor:,UpDownBlue,%BlueValue%
	if (AlphaValue <> "No")
		GuiControl,ChooseColor:,UpDownAlpha,%AlphaValue%
		
	if (AlphaValue <> "No") and HexColorCode = 1 and DifferentOrder = 0
		GuiControl,ColorPreview:,HexColor, % "0x" . Format("{1:02X}", AlphaValue) . Format("{1:02X}{2:02X}{3:02X}", RedValue, GreenValue, BlueValue)
	else if (AlphaValue <> "No") and HexColorCode = 2 and DifferentOrder = 0
		GuiControl,ColorPreview:,HexColor, % Format("{:i}","0x" Format("{1:02X}{2:02X}{3:02X}{4:02X}", RedValue, GreenValue, BlueValue, AlphaValue))
	else if (AlphaValue <> "No") and HexColorCode = 1 and DifferentOrder = 1
		GuiControl,ColorPreview:,HexColor, % "0x" . Format("{1:02X}", AlphaValue) . Format("{1:02X}{2:02X}{3:02X}", BlueValue, GreenValue, RedValue)
	else if HexColorCode = 1
		GuiControl,ColorPreview:,HexColor, % "0x" . Format("{1:02X}{2:02X}{3:02X}", RedValue, GreenValue, BlueValue)
	else if HexColorCode = 2
		GuiControl,ColorPreview:,HexColor, % Format("{:i}","0x" Format("{1:02X}{2:02X}{3:02X}", RedValue, GreenValue, BlueValue))
	else
		GuiControl,ColorPreview:,HexColor, % RedValue . "," . GreenValue . "," . BlueValue
		
	if (AlphaValue <> "No")
		{
			AlphaValueWindow := AlphaValue/255*100+155
			WinSet, Transparent, %AlphaValueWindow%, Color Preview
		}
return

PreviewColor:
	RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}", RedValue, GreenValue, BlueValue)
	GuiControl,ColorPreview:+Background%RGBvalue%,PreviewColor
return

ChooseColor:
Gui, ChooseColor:New,, Choose Color
Gui, -sysmenu
Gui, Font, s8, Courier New
Gui, Font, s8, Verdana
Gui, Font, s8, Arial
Gui, Font, s8, Segoe UI
Gui, Font, s8, Tahoma
Gui, Font, s8, Microsoft Sans Serif
Gui, Add, Text, Section w30 +Right, Red
Gui, Add, Text, w30 +Right, Green
Gui, Add, Text, w30 +Right, Blue
if (AlphaValue <> "No")
	Gui, Add, Text, w30 +Right, Alpha
Gui, Add, Slider, ys-1 w150 h20 +NoTicks +Range0-255 vSliderRed gColorSlide, %RedValue%
Gui, Add, Slider, w150 h20 +NoTicks +Range0-255 vSliderGreen gColorSlide, %GreenValue%
Gui, Add, Slider, w150 h20 +NoTicks +Range0-255 vSliderBlue gColorSlide, %BlueValue%
if (AlphaValue <> "No")
	Gui, Add, Slider, w150 h20 +NoTicks +Range0-255 vSliderAlpha gColorSlide, %AlphaValue%
Gui, Add, Button, w70 vChooseColorOK gChooseColorOK,OK
Gui, Add, Button, x+m w70 vChooseColorCancel gChooseColorCancel,Cancel
Gui, Add, Edit, ys-1 w45 h20 gColorEdit vEditRed +Limit3 +Number, %RedValue%
Gui, Add, UpDown, Range0-255 vUpDownRed gColorUpDown, %RedValue%
Gui, Add, Edit, w45 h20 gColorEdit vEditGreen +Limit3 +Number, %GreenValue%
Gui, Add, UpDown, Range0-255 vUpDownGreen gColorUpDown, %GreenValue%
Gui, Add, Edit, w45 h20 gColorEdit vEditBlue +Limit3 +Number, %BlueValue%
Gui, Add, UpDown, Range0-255 vUpDownBlue gColorUpDown, %BlueValue%
if (AlphaValue <> "No")
	{
		Gui, Add, Edit, w45 h20 gColorEdit vEditAlpha +Limit3 +Number, %AlphaValue%
		Gui, Add, UpDown, Range0-255 vUpDownAlpha gColorUpDown, %AlphaValue%
	}
Gui, Show, h140
WinGetPos,ChooseColorX,ChooseColorY,ChooseColorWidth,ChooseColorHeight, Choose Color
Gui, ColorPreview:New,, Color Preview
Gui, -sysmenu
Gui, Font, s8, Courier New
Gui, Font, s8, Verdana
Gui, Font, s8, Arial
Gui, Font, s8, Segoe UI
Gui, Font, s8, Tahoma
Gui, Font, s8, Microsoft Sans Serif
Gui, Add, Progress,w70 h70 +Border Background%RGBvalue% vPreviewColor
Gui, Add, Text, w70 +Center,Preview
/*
Set AlphaValue:="No" if the alpha value is not used
Set HexColorCode = 1 if the displayed INI format is 0x255
Set HexColorCode = 2 if the displayed INI format is Decimal
Set DifferentOrder = 0 if the order is RGBA
Set DifferentOrder = 1 if the order is ABGR
*/
if (AlphaValue <> "No") and HexColorCode = 1 and DifferentOrder = 0
	Gui, Add, Text, w70 +Center vHexColor, % "0x" . Format("{1:02X}", AlphaValue) . Format("{1:02X}{2:02X}{3:02X}", RedValue, GreenValue, BlueValue)
else if (AlphaValue <> "No") and HexColorCode = 2 and DifferentOrder = 0
	Gui, Add, Text, w70 +Center vHexColor, % Format("{:i}","0x" Format("{1:02X}{2:02X}{3:02X}{4:02X}", RedValue, GreenValue, BlueValue, AlphaValue))
else if  (AlphaValue <> "No") and HexColorCode = 1 and DifferentOrder = 1
	Gui, Add, Text, w70 +Center vHexColor, % "0x" . Format("{1:02X}", AlphaValue) . Format("{1:02X}{2:02X}{3:02X}", BlueValue, GreenValue, RedValue)
else if HexColorCode = 1
	Gui, Add, Text, w70 +Center vHexColor, % "0x" . Format("{1:02X}{2:02X}{3:02X}", RedValue, GreenValue, BlueValue)
else if HexColorCode = 2
	Gui, Add, Text, w70 +Center vHexColor, % Format("{:i}","0x" Format("{1:02X}{2:02X}{3:02X}", RedValue, GreenValue, BlueValue))
else
	Gui, Add, Text, w70 +Center vHexColor, % RedValue . "," . GreenValue . "," . BlueValue
GuiControlGet,ValueToCheck,,HexColor
Gui, Show, h140
WinMove, Color Preview, , % ChooseColorX + ChooseColorWidth, ChooseColorY
if (AlphaValue <> "No")
	{
		AlphaValueWindow := AlphaValue/255*55+200
		WinSet, Transparent, %AlphaValueWindow%, Color Preview
	}
return

iConsoleSelectedRefColor:
iConsoleSelectedRefColor := getControlValue("iConsoleSelectedRefColorText")
AlphaValue:=Format("{:i}","0x" SubStr(iConsoleSelectedRefColor, 3, 2))
RedValue:=Format("{:i}","0x" SubStr(iConsoleSelectedRefColor, 9, 2))
GreenValue:=Format("{:i}","0x" SubStr(iConsoleSelectedRefColor, 7, 2))
BlueValue:=Format("{:i}","0x" SubStr(iConsoleSelectedRefColor, 5, 2))
RGBvalue := "Default"
DifferentOrder := 1
gosub ChooseColor
WinWait, Choose Color
AlphaValue:=Format("{:i}","0x" SubStr(iConsoleSelectedRefColor, 3, 2))
RedValue:=Format("{:i}","0x" SubStr(iConsoleSelectedRefColor, 9, 2))
GreenValue:=Format("{:i}","0x" SubStr(iConsoleSelectedRefColor, 7, 2))
BlueValue:=Format("{:i}","0x" SubStr(iConsoleSelectedRefColor, 5, 2))
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
GuiControl,ChooseColor:,EditAlpha,%AlphaValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		;Fix the "different order"
		RGBvalue := "0x" . SubStr(RGBvalue, 3, 2) . SubStr(RGBvalue, 9, 2) . SubStr(RGBvalue, 7, 2) . SubStr(RGBvalue, 5, 2)
		IniWrite, %RGBvalue%, %INIfolder%%gameNameINI%.ini, Menu, iConsoleSelectedRefColor
		if (SubStr(RGBvalue, 3, 2) = "00")
			iConsoleSelectedRefColorProgress := "FFFFFF"
		else
			iConsoleSelectedRefColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%iConsoleSelectedRefColorProgress%, iConsoleSelectedRefColorProgress
		GuiControl, Main:, iConsoleSelectedRefColorText, %RGBvalue%
		sm("Console selection color has been set to " . RGBvalue . ".")
	}
return

rConsoleTextColor:
rConsoleTextColor := getControlValue("rConsoleTextColorText")
rConsoleTextColorArray:=StrSplit(rConsoleTextColor, ",")
AlphaValue:="No"
RedValue:=rConsoleTextColorArray[1]
GreenValue:=rConsoleTextColorArray[2]
BlueValue:=rConsoleTextColorArray[3]
RGBvalue := "Default"
HexColorCode := 0
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=rConsoleTextColorArray[1]
GreenValue:=rConsoleTextColorArray[2]
BlueValue:=rConsoleTextColorArray[3]
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		RGBvalue := Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 1, 2)) . "," . Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 3, 2)) . "," . Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 5, 2))
		IniWrite, %RGBvalue%, %INIfolder%%gameNameINI%.ini, Menu, rConsoleTextColor
		rConsoleTextColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%rConsoleTextColorProgress%, rConsoleTextColorProgress
		GuiControl, Main:, rConsoleTextColorText, %RGBvalue%
		sm("Console text input color has been set to " . RGBvalue . ".")
	}
return

rConsoleHistoryTextColor:
rConsoleHistoryTextColor := getControlValue("rConsoleHistoryTextColorText")
rConsoleHistoryTextColorArray:=StrSplit(rConsoleHistoryTextColor, ",")
AlphaValue:="No"
RedValue:=rConsoleHistoryTextColorArray[1]
GreenValue:=rConsoleHistoryTextColorArray[2]
BlueValue:=rConsoleHistoryTextColorArray[3]
RGBvalue := "Default"
HexColorCode := 0
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=rConsoleHistoryTextColorArray[1]
GreenValue:=rConsoleHistoryTextColorArray[2]
BlueValue:=rConsoleHistoryTextColorArray[3]
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		RGBvalue := Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 1, 2)) . "," . Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 3, 2)) . "," . Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 5, 2))
		IniWrite, %RGBvalue%, %INIfolder%%gameNameINI%.ini, Menu, rConsoleHistoryTextColor
		rConsoleHistoryTextColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%rConsoleHistoryTextColorProgress%, rConsoleHistoryTextColorProgress
		GuiControl, Main:, rConsoleHistoryTextColorText, %RGBvalue%
		sm("Console text output color has been set to " . RGBvalue . ".")
	}
return

fPipboyEffectColor:
fPipboyEffectColor := getControlValue("fPipboyEffectColorText")
fPipboyEffectColorArray:=StrSplit(fPipboyEffectColor, ",")
AlphaValue:="No"
RedValue:=Round(255*fPipboyEffectColorArray[1],0)
GreenValue:=Round(255*fPipboyEffectColorArray[2],0)
BlueValue:=Round(255*fPipboyEffectColorArray[3],0)
RGBvalue := "Default"
HexColorCode := 0
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=Round(255*fPipboyEffectColorArray[1],0)
GreenValue:=Round(255*fPipboyEffectColorArray[2],0)
BlueValue:=Round(255*fPipboyEffectColorArray[3],0)
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		RGBvalue := Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 1, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 3, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 5, 2))/255,3)
		RGBvalueArray:=StrSplit(RGBvalue, ",")
		IniWrite, % RGBvalueArray[1], %INIfolder%%gameNameINI%%Prefs%.ini, Pipboy, fPipboyEffectColorR
		IniWrite, % RGBvalueArray[2], %INIfolder%%gameNameINI%%Prefs%.ini, Pipboy, fPipboyEffectColorG
		IniWrite, % RGBvalueArray[3], %INIfolder%%gameNameINI%%Prefs%.ini, Pipboy, fPipboyEffectColorB
		fPipboyEffectColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%fPipboyEffectColorProgress%, fPipboyEffectColorProgress
		GuiControl, Main:, fPipboyEffectColorText, %RGBvalue%
		sm("Pipboy color has been set to " . RGBvalue . ".")
	}
return

fVatsLightColor:
fVatsLightColor := getControlValue("fVatsLightColorText")
fVatsLightColorArray:=StrSplit(fVatsLightColor, ",")
AlphaValue:="No"
RedValue:=Round(255*fVatsLightColorArray[1],0)
GreenValue:=Round(255*fVatsLightColorArray[2],0)
BlueValue:=Round(255*fVatsLightColorArray[3],0)
RGBvalue := "Default"
HexColorCode := 0
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=Round(255*fVatsLightColorArray[1],0)
GreenValue:=Round(255*fVatsLightColorArray[2],0)
BlueValue:=Round(255*fVatsLightColorArray[3],0)
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		RGBvalue := Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 1, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 3, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 5, 2))/255,3)
		RGBvalueArray:=StrSplit(RGBvalue, ",")
		IniWrite, % RGBvalueArray[1], %INIfolder%%gameNameINI%.ini, VATS, fVatsLightColorR
		IniWrite, % RGBvalueArray[2], %INIfolder%%gameNameINI%.ini, VATS, fVatsLightColorG
		IniWrite, % RGBvalueArray[3], %INIfolder%%gameNameINI%.ini, VATS, fVatsLightColorB
		fVatsLightColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%fVatsLightColorProgress%, fVatsLightColorProgress
		GuiControl, Main:, fVatsLightColorText, %RGBvalue%
		sm("VATS light color has been set to " . RGBvalue . ".")
	}
return

fWireConnectEffectColor:
fWireConnectEffectColor := getControlValue("fWireConnectEffectColorText")
fWireConnectEffectColorArray:=StrSplit(fWireConnectEffectColor, ",")
AlphaValue:="No"
RedValue:=Round(255*fWireConnectEffectColorArray[1],0)
GreenValue:=Round(255*fWireConnectEffectColorArray[2],0)
BlueValue:=Round(255*fWireConnectEffectColorArray[3],0)
RGBvalue := "Default"
HexColorCode := 0
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=Round(255*fWireConnectEffectColorArray[1],0)
GreenValue:=Round(255*fWireConnectEffectColorArray[2],0)
BlueValue:=Round(255*fWireConnectEffectColorArray[3],0)
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		RGBvalue := Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 1, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 3, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 5, 2))/255,3)
		RGBvalueArray:=StrSplit(RGBvalue, ",")
		IniWrite, % RGBvalueArray[1], %INIfolder%%gameNameINI%.ini, Workshop, fWireConnectEffectColorR
		IniWrite, % RGBvalueArray[2], %INIfolder%%gameNameINI%.ini, Workshop, fWireConnectEffectColorG
		IniWrite, % RGBvalueArray[3], %INIfolder%%gameNameINI%.ini, Workshop, fWireConnectEffectColorB
		fWireConnectEffectColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%fWireConnectEffectColorProgress%, fWireConnectEffectColorProgress
		GuiControl, Main:, fWireConnectEffectColorText, %RGBvalue%
		sm("Wire connect color has been set to " . RGBvalue . ".")
	}
return

fModMenuEffectColor:
fModMenuEffectColor := getControlValue("fModMenuEffectColorText")
fModMenuEffectColorArray:=StrSplit(fModMenuEffectColor, ",")
AlphaValue:="No"
RedValue:=Round(255*fModMenuEffectColorArray[1],0)
GreenValue:=Round(255*fModMenuEffectColorArray[2],0)
BlueValue:=Round(255*fModMenuEffectColorArray[3],0)
RGBvalue := "Default"
HexColorCode := 0
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=Round(255*fModMenuEffectColorArray[1],0)
GreenValue:=Round(255*fModMenuEffectColorArray[2],0)
BlueValue:=Round(255*fModMenuEffectColorArray[3],0)
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		RGBvalue := Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 1, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 3, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 5, 2))/255,3)
		RGBvalueArray:=StrSplit(RGBvalue, ",")
		IniWrite, % RGBvalueArray[1], %INIfolder%%gameNameINI%%Prefs%.ini, VATS, fModMenuEffectColorR
		IniWrite, % RGBvalueArray[2], %INIfolder%%gameNameINI%%Prefs%.ini, VATS, fModMenuEffectColorG
		IniWrite, % RGBvalueArray[3], %INIfolder%%gameNameINI%%Prefs%.ini, VATS, fModMenuEffectColorB
		fModMenuEffectColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%fModMenuEffectColorProgress%, fModMenuEffectColorProgress
		GuiControl, Main:, fModMenuEffectColorText, %RGBvalue%
		sm("Mod menu effect color has been set to " . RGBvalue . ".")
	}
return

fModMenuEffectHighlightColor:
fModMenuEffectHighlightColor := getControlValue("fModMenuEffectHighlightColorText")
fModMenuEffectHighlightColorArray:=StrSplit(fModMenuEffectHighlightColor, ",")
AlphaValue:="No"
RedValue:=Round(255*fModMenuEffectHighlightColorArray[1],0)
GreenValue:=Round(255*fModMenuEffectHighlightColorArray[2],0)
BlueValue:=Round(255*fModMenuEffectHighlightColorArray[3],0)
RGBvalue := "Default"
HexColorCode := 0
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=Round(255*fModMenuEffectHighlightColorArray[1],0)
GreenValue:=Round(255*fModMenuEffectHighlightColorArray[2],0)
BlueValue:=Round(255*fModMenuEffectHighlightColorArray[3],0)
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		RGBvalue := Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 1, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 3, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 5, 2))/255,3)
		RGBvalueArray:=StrSplit(RGBvalue, ",")
		IniWrite, % RGBvalueArray[1], %INIfolder%%gameNameINI%%Prefs%.ini, VATS, fModMenuEffectHighlightColorR
		IniWrite, % RGBvalueArray[2], %INIfolder%%gameNameINI%%Prefs%.ini, VATS, fModMenuEffectHighlightColorG
		IniWrite, % RGBvalueArray[3], %INIfolder%%gameNameINI%%Prefs%.ini, VATS, fModMenuEffectHighlightColorB
		fModMenuEffectHighlightColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%fModMenuEffectHighlightColorProgress%, fModMenuEffectHighlightColorProgress
		GuiControl, Main:, fModMenuEffectHighlightColorText, %RGBvalue%
		sm("Item highlight color has been set to " . RGBvalue . ".")
	}
return

fModMenuEffectHighlightPAColor:
fModMenuEffectHighlightPAColor := getControlValue("fModMenuEffectHighlightPAColorText")
fModMenuEffectHighlightPAColorArray:=StrSplit(fModMenuEffectHighlightPAColor, ",")
AlphaValue:="No"
RedValue:=Round(255*fModMenuEffectHighlightPAColorArray[1],0)
GreenValue:=Round(255*fModMenuEffectHighlightPAColorArray[2],0)
BlueValue:=Round(255*fModMenuEffectHighlightPAColorArray[3],0)
RGBvalue := "Default"
HexColorCode := 0
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=Round(255*fModMenuEffectHighlightPAColorArray[1],0)
GreenValue:=Round(255*fModMenuEffectHighlightPAColorArray[2],0)
BlueValue:=Round(255*fModMenuEffectHighlightPAColorArray[3],0)
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		RGBvalue := Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 1, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 3, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 5, 2))/255,3)
		RGBvalueArray:=StrSplit(RGBvalue, ",")
		IniWrite, % RGBvalueArray[1], %INIfolder%%gameNameINI%%Prefs%.ini, VATS, fModMenuEffectHighlightPAColorR
		IniWrite, % RGBvalueArray[2], %INIfolder%%gameNameINI%%Prefs%.ini, VATS, fModMenuEffectHighlightPAColorG
		IniWrite, % RGBvalueArray[3], %INIfolder%%gameNameINI%%Prefs%.ini, VATS, fModMenuEffectHighlightPAColorB
		fModMenuEffectHighlightPAColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%fModMenuEffectHighlightPAColorProgress%, fModMenuEffectHighlightPAColorProgress
		GuiControl, Main:, fModMenuEffectHighlightPAColorText, %RGBvalue%
		sm("Power armor item highlight color has been set to " . RGBvalue . ".")
	}
return

fPAEffectColor:
fPAEffectColor := getControlValue("fPAEffectColorText")
fPAEffectColorArray:=StrSplit(fPAEffectColor, ",")
AlphaValue:="No"
RedValue:=Round(255*fPAEffectColorArray[1],0)
GreenValue:=Round(255*fPAEffectColorArray[2],0)
BlueValue:=Round(255*fPAEffectColorArray[3],0)
RGBvalue := "Default"
HexColorCode := 0
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=Round(255*fPAEffectColorArray[1],0)
GreenValue:=Round(255*fPAEffectColorArray[2],0)
BlueValue:=Round(255*fPAEffectColorArray[3],0)
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		RGBvalue := Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 1, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 3, 2))/255,3) . "," . Round(Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 5, 2))/255,3)
		RGBvalueArray:=StrSplit(RGBvalue, ",")
		IniWrite, % RGBvalueArray[1], %INIfolder%%gameNameINI%.ini, Pipboy, fPAEffectColorR
		IniWrite, % RGBvalueArray[2], %INIfolder%%gameNameINI%.ini, Pipboy, fPAEffectColorG
		IniWrite, % RGBvalueArray[3], %INIfolder%%gameNameINI%.ini, Pipboy, fPAEffectColorB
		fPAEffectColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%fPAEffectColorProgress%, fPAEffectColorProgress
		GuiControl, Main:, fPAEffectColorText, %RGBvalue%
		sm("Power Armor Pipboy color has been set to " . RGBvalue . ".")
	}
return

iSubtitleSpeakerNameColor:
iSubtitleSpeakerNameColor := getControlValue("iSubtitleSpeakerNameColorText")
iSubtitleSpeakerNameColorHex := Format("{1:02X}", iSubtitleSpeakerNameColor)
AlphaValue:="No"
RedValue:=Format("{:i}","0x" SubStr(iSubtitleSpeakerNameColorHex, 1, 2))
GreenValue:=Format("{:i}","0x" SubStr(iSubtitleSpeakerNameColorHex, 3, 2))
BlueValue:=Format("{:i}","0x" SubStr(iSubtitleSpeakerNameColorHex, 5, 2))
RGBvalue := "Default"
/*
Set AlphaValue:="No" if the alpha value is not used
Set HexColorCode = 1 if the displayed INI format is 0x255
Set HexColorCode = 2 if the displayed INI format is Decimal
Set DifferentOrder = 0 if the order is RGBA
Set DifferentOrder = 1 if the order is ABGR
*/
HexColorCode := 2
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=Format("{:i}","0x" SubStr(iSubtitleSpeakerNameColorHex, 1, 2))
GreenValue:=Format("{:i}","0x" SubStr(iSubtitleSpeakerNameColorHex, 3, 2))
BlueValue:=Format("{:i}","0x" SubStr(iSubtitleSpeakerNameColorHex, 5, 2))
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		;Fix the "different order"
		iSubtitleSpeakerNameColor := Format("{:i}","0x" JustTheRGBColorHexCode)
		IniWrite, %iSubtitleSpeakerNameColor%, %INIfolder%%gameNameINI%.ini, Interface, iSubtitleSpeakerNameColor
		iSubtitleSpeakerNameColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%iSubtitleSpeakerNameColorProgress%, iSubtitleSpeakerNameColorProgress
		GuiControl, Main:, iSubtitleSpeakerNameColorText, %iSubtitleSpeakerNameColor%
		sm("Subtitle speaker color has been set to " . iSubtitleSpeakerNameColor . ".")
	}
return


uHUDColor:
uHUDColor := getControlValue("uHUDColorText")
uHUDColorHex := Format("{1:02X}", uHUDColor)
AlphaValue:=Format("{:i}","0x" SubStr(uHUDColorHex, 7, 2))
RedValue:=Format("{:i}","0x" SubStr(uHUDColorHex, 1, 2))
GreenValue:=Format("{:i}","0x" SubStr(uHUDColorHex, 3, 2))
BlueValue:=Format("{:i}","0x" SubStr(uHUDColorHex, 5, 2))
RGBvalue := "Default"
HexColorCode := 2
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
AlphaValue:=Format("{:i}","0x" SubStr(uHUDColorHex, 7, 2))
RedValue:=Format("{:i}","0x" SubStr(uHUDColorHex, 1, 2))
GreenValue:=Format("{:i}","0x" SubStr(uHUDColorHex, 3, 2))
BlueValue:=Format("{:i}","0x" SubStr(uHUDColorHex, 5, 2))
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
GuiControl,ChooseColor:,EditAlpha,%AlphaValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		;Fix the "different order"
		uHUDColor := Format("{:i}","0x" SubStr(RGBvalue, 5, 6) . SubStr(RGBvalue, 3, 2))
		IniWrite, %uHUDColor%, %INIfolder%%gameNameINI%%Prefs%.ini, Interface, uHUDColor
		uHUDColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%uHUDColorProgress%, uHUDColorProgress
		GuiControl, Main:, uHUDColorText, %uHUDColor%
		sm("HUD color has been set to " . uHUDColor . ".")
	}
return

uPipboyColor:
uPipboyColor := getControlValue("uPipboyColorText")
uPipboyColorHex := Format("{1:02X}", uPipboyColor)
AlphaValue:=Format("{:i}","0x" SubStr(uPipboyColorHex, 7, 2))
RedValue:=Format("{:i}","0x" SubStr(uPipboyColorHex, 1, 2))
GreenValue:=Format("{:i}","0x" SubStr(uPipboyColorHex, 3, 2))
BlueValue:=Format("{:i}","0x" SubStr(uPipboyColorHex, 5, 2))
RGBvalue := "Default"
HexColorCode := 2
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
AlphaValue:=Format("{:i}","0x" SubStr(uPipboyColorHex, 7, 2))
RedValue:=Format("{:i}","0x" SubStr(uPipboyColorHex, 1, 2))
GreenValue:=Format("{:i}","0x" SubStr(uPipboyColorHex, 3, 2))
BlueValue:=Format("{:i}","0x" SubStr(uPipboyColorHex, 5, 2))
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
GuiControl,ChooseColor:,EditAlpha,%AlphaValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		;Fix the "different order"
		uPipboyColor := Format("{:i}","0x" SubStr(RGBvalue, 5, 6) . SubStr(RGBvalue, 3, 2))
		IniWrite, %uPipboyColor%, %INIfolder%%gameNameINI%%Prefs%.ini, Interface, uPipboyColor
		uPipboyColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%uPipboyColorProgress%, uPipboyColorProgress
		GuiControl, Main:, uPipboyColorText, %uPipboyColor%
		sm("Pipboy color has been set to " . uPipboyColor . ".")
	}
return

uSubtitle:
uSubtitle := getControlValue("uSubtitleText")
uSubtitleArray:=StrSplit(uSubtitle, ",")
AlphaValue:="No"
RedValue:=uSubtitleArray[1]
GreenValue:=uSubtitleArray[2]
BlueValue:=uSubtitleArray[3]
RGBvalue := "Default"
HexColorCode := 0
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=uSubtitleArray[1]
GreenValue:=uSubtitleArray[2]
BlueValue:=uSubtitleArray[3]
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		RGBvalue := Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 1, 2)) . "," . Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 3, 2)) . "," . Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 5, 2))
		RGBvalueArray:=StrSplit(RGBvalue, ",")
		IniWrite, % RGBvalueArray[1], %INIfolder%%gameNameINI%.ini, Interface, uSubtitleR
		IniWrite, % RGBvalueArray[2], %INIfolder%%gameNameINI%.ini, Interface, uSubtitleG
		IniWrite, % RGBvalueArray[3], %INIfolder%%gameNameINI%.ini, Interface, uSubtitleB
		uSubtitleProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%uSubtitleProgress%, uSubtitleProgress
		GuiControl, Main:, uSubtitleText, %RGBvalue%
		sm("Subtitle color has been set to " . RGBvalue . ".")
	}
return

iHUDColor:
iHUDColor := getControlValue("iHUDColorText")
iHUDColorArray:=StrSplit(iHUDColor, ",")
AlphaValue:="No"
RedValue:=iHUDColorArray[1]
GreenValue:=iHUDColorArray[2]
BlueValue:=iHUDColorArray[3]
RGBvalue := "Default"
HexColorCode := 0
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=iHUDColorArray[1]
GreenValue:=iHUDColorArray[2]
BlueValue:=iHUDColorArray[3]
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		RGBvalue := Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 1, 2)) . "," . Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 3, 2)) . "," . Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 5, 2))
		RGBvalueArray:=StrSplit(RGBvalue, ",")
		IniWrite, % RGBvalueArray[1], %INIfolder%%gameNameINI%%Prefs%.ini, Interface, iHUDColorR
		IniWrite, % RGBvalueArray[2], %INIfolder%%gameNameINI%%Prefs%.ini, Interface, iHUDColorG
		IniWrite, % RGBvalueArray[3], %INIfolder%%gameNameINI%%Prefs%.ini, Interface, iHUDColorB
		iHUDColorProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%iHUDColorProgress%, iHUDColorProgress
		GuiControl, Main:, iHUDColorText, %RGBvalue%
		sm("HUD color has been set to " . RGBvalue . ".")
	}
return

iHUDColorWarning:
iHUDColorWarning := getControlValue("iHUDColorWarningText")
iHUDColorWarningArray:=StrSplit(iHUDColorWarning, ",")
AlphaValue:="No"
RedValue:=iHUDColorWarningArray[1]
GreenValue:=iHUDColorWarningArray[2]
BlueValue:=iHUDColorWarningArray[3]
RGBvalue := "Default"
HexColorCode := 0
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=iHUDColorWarningArray[1]
GreenValue:=iHUDColorWarningArray[2]
BlueValue:=iHUDColorWarningArray[3]
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		RGBvalue := Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 1, 2)) . "," . Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 3, 2)) . "," . Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 5, 2))
		RGBvalueArray:=StrSplit(RGBvalue, ",")
		IniWrite, % RGBvalueArray[1], %INIfolder%%gameNameINI%.ini, Interface, iHUDColorWarningR
		IniWrite, % RGBvalueArray[2], %INIfolder%%gameNameINI%.ini, Interface, iHUDColorWarningG
		IniWrite, % RGBvalueArray[3], %INIfolder%%gameNameINI%.ini, Interface, iHUDColorWarningB
		iHUDColorWarningProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%iHUDColorWarningProgress%, iHUDColorWarningProgress
		GuiControl, Main:, iHUDColorWarningText, %RGBvalue%
		sm("Damage HUD color has been set to " . RGBvalue . ".")
	}
return

/*
iHUDColorAltWarning:
iHUDColorAltWarning := getControlValue("iHUDColorAltWarningText")
iHUDColorAltWarningArray:=StrSplit(iHUDColorAltWarning, ",")
AlphaValue:="No"
RedValue:=iHUDColorAltWarningArray[1]
GreenValue:=iHUDColorAltWarningArray[2]
BlueValue:=iHUDColorAltWarningArray[3]
RGBvalue := "Default"
HexColorCode := 0
DifferentOrder := 0
gosub ChooseColor
WinWait, Choose Color
RedValue:=iHUDColorAltWarningArray[1]
GreenValue:=iHUDColorAltWarningArray[2]
BlueValue:=iHUDColorAltWarningArray[3]
GuiControl,ChooseColor:,EditRed,%RedValue%
GuiControl,ChooseColor:,EditGreen,%GreenValue%
GuiControl,ChooseColor:,EditBlue,%BlueValue%
WinWaitClose, Choose Color
if (RGBvalue <> "None Chosen")
	{
		;RGBvalue:=Format("0x{1:02X}{2:02X}{3:02X}{4:02X}", EditAlpha, EditRed, EditGreen, EditBlue)
		JustTheRGBColorHexCode:=SubStr(RGBvalue, 5, 6)
		RGBvalue := Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 1, 2)) . "," . Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 3, 2)) . "," . Format("{:i}","0x" SubStr(JustTheRGBColorHexCode, 5, 2))
		RGBvalueArray:=StrSplit(RGBvalue, ",")
		IniWrite, % RGBvalueArray[1], %INIfolder%%gameNameINI%.ini, Interface, iHUDColorAltWarningR
		IniWrite, % RGBvalueArray[2], %INIfolder%%gameNameINI%.ini, Interface, iHUDColorAltWarningG
		IniWrite, % RGBvalueArray[3], %INIfolder%%gameNameINI%.ini, Interface, iHUDColorAltWarningB
		iHUDColorAltWarningProgress := JustTheRGBColorHexCode
		GuiControl, Main:+Background%iHUDColorAltWarningProgress%, iHUDColorAltWarningProgress
		GuiControl, Main:, iHUDColorAltWarningText, %RGBvalue%
		sm("HUD color has been set to " . RGBvalue . ".")
	}
return
*/

ApproveChanges:
/*
Gui, ApproveChanges:New,, Manual Editor
Gui, Font, s8, Courier New
Gui, Font, s8, Verdana
Gui, Font, s8, Arial
Gui, Font, s8, Segoe UI
Gui, Font, s8, Tahoma
Gui, Font, s8, Microsoft Sans Serif


Gui, Add, Text, , You can manually change lines here.
if gameName != Oblivion
	Gui, Add, Tab2, w580 r25, %gameNameINI%.ini|%gameNameINI%Prefs.ini
else
	Gui, Add, Tab2, w580 r25, %gameNameINI%

if gameName != Oblivion
	{
		Gui, Tab, %gameNameINI%Prefs.ini
		FileRead, GameNameINIPrefsChanges, %INIfolder%%gameNameINI%%Prefs%.ini
		Gui, Add, Edit, r35 w560 vGameNameINIPrefsChanges,% GameNameINIPrefsChanges
		GameNameINIPrefsChanges_TT := ""
	}

Gui, Tab, %gameNameINI%.ini
FileRead, GameNameINIChanges, %INIfolder%%gameNameINI%.ini
Gui, Add, Edit, r35 w560 vGameNameINIChanges,% GameNameINIChanges
GameNameINIChanges_TT := ""


Gui, Show, w600
WinWait, Manual Editor
WinWaitClose, Manual Editor

return

SaveChangesManualEditor:
GuiControlGet, GameNameINIChanges, ApproveChanges:, GameNameINIChanges
FileDelete, %INIfolder%%gameNameINI%.ini
FileAppend, % GameNameINIChanges, %INIfolder%%gameNameINI%.ini
if gameName != Oblivion
	{
		GuiControlGet, GameNameINIPrefsChanges, ApproveChanges:, GameNameINIPrefsChanges
		FileDelete, %INIfolder%%gameNameINI%%Prefs%.ini
		FileAppend, % GameNameINIPrefsChanges, %INIfolder%%gameNameINI%%Prefs%.ini
	}
*/
return