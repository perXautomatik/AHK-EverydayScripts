sortNumberedList(numberedList, value)
	{
		newList = %value%|%numberedList%
		xList = %value%|%numberedList%
		Sort, xList, N U D|
		Sort, newList, N D|
		if (xList != newList)
			{
				newList := StrReplace(newList, value . "|" . value, value . "|",,"1")
				;StringReplace, newList, newList, % value . "|" . value, % value . "|"
			}
		else
			{
				newList := StrReplace(xList, value, value . "|",,"1")
				;StringReplace, newList, xList, %value%, %value%|
			}
		IfNotInString, newList, ||
			newList = %newList%|
		return newList
	}

getControlValue(controlToGetValueOf)
	{
		GuiControlGet, x,, %controlToGetValueOf%
		return x
	}
	
enableGuiControl(controlToDisable, enableIfZero)
{
	if (enableIfZero = 1)
		GuiControl, Disable, %controlToDisable%
	else if (enableIfZero = 0)
		GuiControl, Enable, %controlToDisable%
}
	
disableGuiControl(controlToDisable, disableIfZero)
	{
		if (disableIfZero = 0)
			GuiControl, Disable, %controlToDisable%
		else if (disableIfZero = 1)
			GuiControl, Enable, %controlToDisable%
	}
	
getSettingValue(section, key, INI="", default="", Directory="")
	{
		if Directory =
			Directory = %INIfolder%%gameNameINI%
		IniRead, x, %Directory%%INI%.ini, %section%, %key%, %default%
		if x = ERROR
			x = %default%
		return x
	}
	
getSettingValueProject(section, key, default="")
	{
		IniRead, x, %scriptName%.ini, %section%, %key%, %default%
		if x = ERROR
			x = %default%
		return x
	}

deleteExcessBackups()
	{
		FileList =
		Loop, Files, %INIfolder%%shortName% Cache\*, D  ; Only Directories
			FileList = %FileList%%A_LoopFileTimeModified%`t%A_LoopFileName%`n
		Sort, FileList, R  ; Sort by date, reverse order
		FileList := StrReplace(FileList, "Before " . shortName,,,"1")
		numBackups = 0
		Loop, Parse, FileList, `n
		{
			if A_LoopField =  ; Omit the last linefeed (blank item) at the end of the list.
				continue
			StringSplit, FileItem, A_LoopField, %A_Tab%  ; Split into two parts at the tab char.
			numBackups += 1
			if (numBackups > 5) and (FileItem2 != "Before" . shortName) and (FileItem2 != blank)
				FileRemoveDir, %INIfolder%%shortName% Cache\%FileItem2%, 1
		}
	}

getBackupList()
	{
		FileList =
		Loop, Files, %INIfolder%%shortName% Cache\*, D  ; Only Directories
			FileList = %FileList%%A_LoopFileName%|
		Sort, FileList, R D| ; Sort by date, reverse order
		FileList := StrReplace(FileList, "Before " . shortName . "|",,,"1")
		return FileList . "Before " . shortName
	}
	
sm(tempText, MainINITab="0")
	{
		FileAppend, %A_Hour%:%A_Min%:%A_Sec%.%A_MSec%:%A_Space%%tempText%`n, %INIfolder%%shortName% Cache\%theTime%\log.txt
		Gui, Main:Default
		SB_SetText(tempText)
		GuiControlGet, LogTab, Summary:, LogTab
		if LogTab !=
			LogTab = %LogTab%`n%A_Hour%:%A_Min%:%A_Sec%.%A_MSec%:%A_Space%%tempText%
		else
			FileRead, LogTab, %INIfolder%%shortName% Cache\%theTime%\log.txt
		GuiControl, Summary:, LogTab, %LogTab%
	}

getGameName()
	{
		ifNotExist, %scriptName%.ini
			{
				MsgBox, Failed to create the %scriptName%.ini file! Are you running this in a UAC-protected directory? %scriptName% shall now exit.
				ExitApp
			}
		GameName := getSettingValueProject("General", "sGameName", "Skyrim")
		return GameName
	}
	
GetGameRegName()
	{
		if gameName = Skyrim
			{
				GameRegName = Skyrim
				if isEnderalForgotten = 1
					GameRegName = Enderal
			}
		else if gameName = Skyrim Special Edition
			GameRegName = Skyrim Special Edition
		else if gameName = Fallout 4
			GameRegName = Fallout4
		else if gameName = Fallout 3
			GameRegName = Fallout3
		else if gameName = Fallout New Vegas
			GameRegName = FalloutNV
		else if gameName = Oblivion
			GameRegName = Oblivion
		return GameRegName
	}
	
GetGameIniName()
	{
		if gameName = Skyrim
			{
				GameIniName = Skyrim
				if isEnderalForgotten = 1
					GameIniName = Enderal
			}
		else if gameName = Skyrim Special Edition
			GameIniName = Skyrim
		else if gameName = Fallout 4
			GameIniName = Fallout4
		else if gameName = Fallout 3
			GameIniName = Fallout
		else if gameName = Fallout New Vegas
			GameIniName = Fallout
		else if gameName = Oblivion
			GameIniName = Oblivion
		return GameIniName
	}
	
GetGameLauncherName()
	{
		if gameName = Skyrim
			{
				GameLauncherName = Skyrim
				if isEnderalForgotten = 1
					GameLauncherName := "Enderal "
			}
		else if gameName = Skyrim Special Edition
			GameLauncherName = SkyrimSE
		else if gameName = Fallout 4
			GameLauncherName = Fallout4
		else if gameName = Fallout 3
			GameLauncherName = Fallout
		else if gameName = Fallout New Vegas
			GameLauncherName = FalloutNV
		else if gameName = Oblivion
			GameLauncherName = Oblivion
		return GameLauncherName
	}
	
GetGameEXEName()
	{
		if gameName = Skyrim
			GameEXEName = TESV
		else if gameName = Skyrim Special Edition
			GameEXEName = SkyrimSE
		else if gameName = Fallout 4
			GameEXEName = Fallout4
		else if gameName = Fallout 3
			GameEXEName = Fallout
		else if gameName = Fallout New Vegas
			GameEXEName = FalloutNV
		else if gameName = Oblivion
			GameEXEName = Oblivion
		return GameEXEName
	}
	
getMyGames()
	{
		IniDelete, %scriptName%.ini, Directories, sGameSettingsPath
		GameSettingsPath := getSettingValueProject("Directories", "s" . gameNameEnderalWorkaround . "GameSettingsPath")
		if GameSettingsPath =
			{
				sm("The s" . gameName . "GameSettingsPath was not specified in the " . projectName . " configuration file.")
				if FileExist(A_MyDocuments . "\My Games\" . gameNameReg . "\" . gameNameINI . ".ini")
					GameSettingsPath := A_MyDocuments . "\My Games\" . gameNameReg . "\"
				if GameSettingsPath =
					{
						sm("The main INI file was not found in its assumed location.")
						FileSelectFile, INIfile, 1, %gameNameINI%.ini, Select %gameNameINI%.ini, %gameNameINI%.ini (*.ini)
						if ErrorLevel <> 0
							{
								sm("Error! Failed to locate " . gameNameINI . ".ini")
								IniDelete, %scriptName%.ini, Directories, sGamePath
								IniDelete, %scriptName%.ini, Directories, s%gameName%GameSettingsPath
								IniDelete, %scriptName%.ini, General, sGameName
								MsgBox, Error! %gameNameINI%.ini could not be located. %shortName% shall now exit.
								ExitApp
							}
						SplitPath, INIfile, INIfile, GameSettingsPath
						GameSettingsPath = %GameSettingsPath%\
					}
			}
		IniWrite, %GameSettingsPath%, %scriptName%.ini, Directories, s%gameNameEnderalWorkaround%GameSettingsPath
		return GameSettingsPath
	}

GetFolder()
	{
		gamePath := getSettingValueProject("Directories", "sGamePath")
		if isEnderalForgotten = 1
			gamePath := getSettingValueProject("Directories", "sEnderalForgottenStoriesGamePath")
		if gamePath =
			{
				sm("The game path is not specified in the INI.")
				RegRead, gamePath, HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Bethesda Softworks\%gameNameReg%, installed path
				if gamePath = 
					{
						RegRead, gamePath, HKEY_LOCAL_MACHINE\SOFTWARE\Bethesda Softworks\%gameNameReg%, installed path
						if gamePath = 
							{
								sm("The game is not listed in the registry.")
								WinHide, Please Wait
								MsgBox, 262144, Attention!, The %gameNameLauncher%Launcher.exe was not able to be automatically located. Please browse and select %gameNameLauncher%Launcher.exe at the next prompt.
								FileSelectFile, TheGameLauncher, 1, %gameNameLauncher%Launcher.exe, Select %gameNameLauncher%Launcher.exe, (*.exe)
								if ErrorLevel <> 0
									{
										sm("Error! Cannot locate the " . gameNameLauncher . "Launcher. Exiting...")
										IniDelete, %scriptName%.ini, Directories, sGamePath
										IniDelete, %scriptName%.ini, Directories, sGameSettingsPath
										IniDelete, %scriptName%.ini, General, sGameName
										MsgBox, 262144, Attention!, % "Error! Cannot locate the " . gameNameLauncher . "Launcher. " . shortName . " shall now exit."
										ExitApp
									}
								WinShow, Please Wait
								SplitPath, TheGameLauncher, TheGameLauncherExe, gamePath
								gamePath .= "\"
								sm("The game is located here: " . gamePath)
							}
					}
			}
		IniWrite, %gamePath%, %scriptName%.ini, Directories, sGamePath
		if isEnderalForgotten = 1
			IniWrite, %gamePath%, %scriptName%.ini, Directories, sEnderalForgottenStoriesGamePath
		return gamePath
	}
	
getModOrganizer()
	{
		moLocation := getSettingValueProject("Directories", "s" . gameNameReg . "ModOrganizerPath")
		if moLocation !=
			{
				sm(gameName . " Mod Organizer, according to the INI file, appears to be located in " . moLocation)
				return moLocation
			}
		RegRead, Nxm, HKEY_CLASSES_ROOT\nxm\shell\open\command
		if Nxm =
			{
				sm("Mod Organizer is not registered to download from the Nexus, so its location could not be found that way.")
				return "NOT FOUND"
			}
		sm("nxm links point to " . Nxm)
		StringGetPos, NxmHandlerPosition, Nxm, nxmhandler.exe
		NxmHandlerPosition -= 2
		StringMid, NxmNew, Nxm, 2, %NxmHandlerPosition%
		if !FileExist(NxmNew . "\nxmhandlers.ini")
			{
				sm("No nxmhandlers.ini at the location found.")
				SplitPath, A_AppData,, appdata
				if !FileExist(appdata . "\Local\ModOrganizer\nxmhandler.ini")
					{
						sm("No nxmhandler.ini at the AppData location found.")
						return "NOT FOUND"
					}
				else
					FileRead, nxmhandlers, %appdata%\Local\ModOrganizer\nxmhandler.ini
			}
		else
			FileRead, nxmhandlers, %NxmNew%\nxmhandlers.ini
		if gameName = Skyrim Special Edition
			StringGetPos, gameNamePosition, nxmhandlers, skyrimse
		else
			StringGetPos, gameNamePosition, nxmhandlers, %gameNameReg%
		StringGetPos, equalLocation, nxmhandlers, =,, %gameNamePosition%
		StringGetPos, moAppLocation, nxmhandlers, ModOrganizer.exe,, %equalLocation%
		equalLocation += 2
		moAppLocation -= equalLocation
		StringMid, moLocation, nxmhandlers, %equalLocation%, %moAppLocation%
		moLocation := StrReplace(moLocation, "\\", "\")
		if FileExist(moLocation . "ModOrganizer.exe")
			{
				IniWrite, %moLocation%, %scriptName%.ini, Directories, s%gameNameReg%ModOrganizerPath
				tempText := gameName . " Mod Organizer appears to be located in " . moLocation
			}
		else
			{
				tempText := "ModOrganizer.exe was not found at " . moLocation
				moLocation =
				SplitPath, A_AppData,, appdata
				if !FileExist(appdata . "\Local\ModOrganizer\nxmhandler.ini")
					{
						sm(tempText)
						sm("No nxmhandler.ini at the AppData location found.")
						return "NOT FOUND"
					}
				else
					FileRead, nxmhandlers, %appdata%\Local\ModOrganizer\nxmhandler.ini
				if gameName = Skyrim Special Edition
					StringGetPos, gameNamePosition, nxmhandlers, skyrimse
				else
					StringGetPos, gameNamePosition, nxmhandlers, %gameNameReg%
				StringGetPos, equalLocation, nxmhandlers, =,, %gameNamePosition%
				StringGetPos, moAppLocation, nxmhandlers, ModOrganizer.exe,, %equalLocation%
				equalLocation += 2
				moAppLocation -= equalLocation
				StringMid, moLocation, nxmhandlers, %equalLocation%, %moAppLocation%
				moLocation := StrReplace(moLocation, "\\", "\")
				if FileExist(moLocation . "ModOrganizer.exe")
					{
						IniWrite, %moLocation%, %scriptName%.ini, Directories, s%gameNameReg%ModOrganizerPath
						tempText := gameName . " Mod Organizer appears to be located in " . moLocation
					}
				else
					{
						tempText := "ModOrganizer.exe was not found at " . moLocation
						moLocation =
					}
			}
		sm(tempText)
		return moLocation
	}

getProfilesFolder()
	{
		if FileExist(modOrganizerFolder . "ModOrganizer.ini")
			{
				/*
				if (getSettingValue("General", "gameName", "ModOrganizer", gameNameEnderalWorkaround, modOrganizerFolder) = gameNameEnderalWorkaround)
					{
						sm("Mod Organizer base files for " . gameNameEnderalWorkaround . " found at " . modOrganizerFolder)
						profilesFolder = %modOrganizerFolder%Profiles
					}
				*/
				Loop, Files, %modOrganizerFolder%Profiles\*, D  ; Only Directories
					{
						if FileExist(modOrganizerFolder . "Profiles\" . A_LoopFileName . "\" . gameNameINI . ".ini")
							{
								sm("Mod Organizer base files for " . gameNameEnderalWorkaround . " found at " . modOrganizerFolder)
								profilesFolder = %modOrganizerFolder%Profiles
								break
							}
					}
			}
		else
			{
				sm("Mod Organizer is not portable. Try Mod Organizer 2 AppData location.")
				SplitPath, A_AppData,, appdata
				
				;default names for AppData Mod Organizer instances
				gameNameMOLocalAppData = %gameName%
				if gameName = Skyrim Special Edition
					gameNameMOLocalAppData = SkyrimSE
				if gameName = Fallout New Vegas
					gameNameMOLocalAppData = FalloutNV
				
				;This code will handle custom named AppData Mod Organizer instances
				TheInstances =
				if FileExist(appdata . "\Local\ModOrganizer\")
					{
						sm("Mod Organizer Instances in AppData:")
						Loop, Files, %appdata%\Local\ModOrganizer\*, D  ; Only Directories
							{
								;IniRead, OutputVar, Filename, Section, Key , Default
								IniRead, GameForThisInstance, %appdata%\Local\ModOrganizer\%A_LoopFileName%\ModOrganizer.ini, General, % "gameName"
								sm(A_LoopFileName . " is for: " . GameForThisInstance)
								if gameName = Fallout New Vegas
									ModOrganizerGameName := "New Vegas"
								else
									ModOrganizerGameName := gameNameEnderalWorkaround
								if (GameForThisInstance = ModOrganizerGameName)
									{
										sm("ModOrganizer.ini for " . gameNameEnderalWorkaround . " found at " . appdata . "\Local\ModOrganizer\" . A_LoopFileName)
										if TheInstances =
											TheInstances := A_LoopFileName
										else
											TheInstances .= ", " . A_LoopFileName
									}
							}
					}
				sm("The following Mod Organizer instances could be used for this game: " . TheInstances)
				if TheInstances contains ,
					Loop, Parse, TheInstances , `,, %A_Space%
						{
							IniRead, GamePathForThisInstance, %appdata%\Local\ModOrganizer\%A_LoopField%\ModOrganizer.ini, General, % "gamePath"
							GamePathForThisInstance := StrReplace(GamePathForThisInstance, "\\", "\") . "\"
							sm("The Mod Organizer instance called """ . A_LoopField . """ is managing a game located at " . GamePathForThisInstance)
							if (GamePathForThisInstance = gameFolder)
								{
									gameNameMOLocalAppData := A_LoopField
									sm("The Mod Organizer instance called """ . A_LoopField . """ is managing the same game BethINI is! Therefore, it will be set as the instance to locate Mod Organizer profiles.")
									;Only the first Mod Organizer instance will be used that matches our game path. If a user has multiple Mod Organizer instances pointing to the same game (can't think of a reason someone would do this), this could cause complaints...
									break
								}
						}
					else
						{
							IniRead, GamePathForThisInstance, %appdata%\Local\ModOrganizer\%TheInstances%\ModOrganizer.ini, General, % "gamePath"
							GamePathForThisInstance := StrReplace(GamePathForThisInstance, "\\", "\") . "\"
							sm("The Mod Organizer instance called """ . TheInstances . """ is managing a game located at " . GamePathForThisInstance)
							if (GamePathForThisInstance = gameFolder)
								{
									gameNameMOLocalAppData := TheInstances
									sm("The Mod Organizer instance called """ . TheInstances . """ is managing the same game BethINI is! Therefore, it will be set as the instance to locate Mod Organizer profiles.")
								}
						}
					
				
				if FileExist(appdata . "\Local\ModOrganizer\" . gameNameMOLocalAppData . "\ModOrganizer.ini")
					{
						sm("ModOrganizer.ini for " . gameNameEnderalWorkaround . " found at " . appdata . "\Local\ModOrganizer\" . gameNameMOLocalAppData)
						;getSettingValue(section, key, INI="", default="", Directory="")
						MOBaseDir := StrReplace(getSettingValue("Settings", "base_directory", "ModOrganizer", appdata . "\Local\ModOrganizer\" . gameNameMOLocalAppData, appdata . "\Local\ModOrganizer\" . gameNameMOLocalAppData . "\"), "/", "\")
						;StringReplace, MOBaseDir, MOBaseDir, % "/", % "\", All
						sm("Mod Organizer 2 Base Directory is " . MOBaseDir)
						profilesFolder := StrReplace(StrReplace(getSettingValue("Settings", "profiles_directory", "ModOrganizer", MOBaseDir . "\profiles", appdata . "\Local\ModOrganizer\" . gameNameMOLocalAppData . "\"), "/", "\"), "%BASE_DIR%", MOBaseDir)
						;StringReplace, profilesFolder, profilesFolder, % "/", % "\", All
						;StringReplace, profilesFolder, profilesFolder, % "%BASE_DIR%", % MOBaseDir, All
					}
			}
		sm("Mod Organizer profiles for " . gameNameEnderalWorkaround . " are located at " . profilesFolder)
		return profilesFolder
	}
	
	
getProfiles()
	{
		FileList =
		if profilesFolder =
			return FileList
		Loop, Files, %profilesFolder%\*, D  ; Only Directories
			FileList = %FileList%|ModOrganizer > %A_LoopFileName%
		return FileList
	}
	
getGameList()
	{
		if gameName = Skyrim
			{
				GameList = Enderal: Forgotten Stories|Fallout 3|Fallout 4|Fallout New Vegas|Oblivion|Skyrim||Skyrim Special Edition
				if isEnderalForgotten = 1
					GameList = Enderal: Forgotten Stories||Fallout 3|Fallout 4|Fallout New Vegas|Oblivion|Skyrim|Skyrim Special Edition
			}
		else if gameName = Skyrim Special Edition
			GameList = Enderal: Forgotten Stories|Fallout 3|Fallout 4|Fallout New Vegas|Oblivion|Skyrim|Skyrim Special Edition||
		else if gameName = Fallout 4
			GameList = Enderal: Forgotten Stories|Fallout 3|Fallout 4||Fallout New Vegas|Oblivion|Skyrim|Skyrim Special Edition
		else if gameName = Fallout 3
			GameList = Enderal: Forgotten Stories|Fallout 3||Fallout 4|Fallout New Vegas|Oblivion|Skyrim|Skyrim Special Edition
		else if gameName = Fallout New Vegas
			GameList = Enderal: Forgotten Stories|Fallout 3|Fallout 4|Fallout New Vegas||Oblivion|Skyrim|Skyrim Special Edition
		else if gameName = Oblivion
			GameList = Enderal: Forgotten Stories|Fallout 3|Fallout 4|Fallout New Vegas|Oblivion||Skyrim|Skyrim Special Edition
		return GameList
	}
	
WM_MOUSEMOVE()
{
	;SB_SetText("")
	static CurrControl, PrevControl, _TT  ; _TT is kept blank for use by the ToolTip command below.
    CurrControl := A_GuiControl
    if (CurrControl <> PrevControl and not InStr(CurrControl, " "))
		{
			ToolTip  ; Turn off any previous tooltip.
			SetTimer, DisplayToolTip, 250
			PrevControl := CurrControl
		}
    return

    DisplayToolTip:
    SetTimer, DisplayToolTip, Off
    tempToolTip = %CurrControl%_TT
    ToolTip % %tempToolTip%  ; The leading percent sign tell it to use an expression.
    SetTimer, RemoveToolTip, 60000
    return

    RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
    return
}