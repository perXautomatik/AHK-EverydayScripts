Spin()
	{
		if gameName != Oblivion
			{
				card := getVideoCard()
				if FileExist(INIfolder . gameNameINI . "Prefs.ini")
					IniRead, AudioMenu, %INIfolder%%gameNameINI%Prefs.ini, AudioMenu
			}
		else
			{
				uVideoDeviceIdentifierPart1 := getSettingValue("Display", "uVideoDeviceIdentifierPart1", blank, "0")
				uVideoDeviceIdentifierPart2 := getSettingValue("Display", "uVideoDeviceIdentifierPart2", blank, "0")
				uVideoDeviceIdentifierPart3 := getSettingValue("Display", "uVideoDeviceIdentifierPart3", blank, "0")
				uVideoDeviceIdentifierPart4 := getSettingValue("Display", "uVideoDeviceIdentifierPart4", blank, "0")
			}
		if gameName != Fallout 4
			{
				bInvalidateOlderFiles := getSettingValue("Archive", "bInvalidateOlderFiles", blank, "1")
				if gameName = Oblivion
					sArchiveList := getSettingValue("Archive", "sArchiveList", blank, "Oblivion - Meshes.bsa, Oblivion - Textures - Compressed.bsa, Oblivion - Sounds.bsa, Oblivion - Voices1.bsa, Oblivion - Voices2.bsa, Oblivion - Misc.bsa")
				else if gameName = Fallout 3
					sArchiveList := getSettingValue("Archive", "sArchiveList", blank, "Fallout - Textures.bsa, Fallout - Meshes.bsa, Fallout - Voices.bsa, Fallout - Sound.bsa, Fallout - MenuVoices.bsa, Fallout - Misc.bsa")
				else if gameName = Fallout New Vegas
					sArchiveList := getSettingValue("Archive", "sArchiveList", blank, "Fallout - Textures.bsa, Fallout - Textures2.bsa, Fallout - Meshes.bsa, Fallout - Voices1.bsa, Fallout - Sound.bsa,  Fallout - Misc.bsa")
				else if gameName = Skyrim
					{
						sResourceArchiveList := getSettingValue("Archive", "sResourceArchiveList", blank, "Skyrim - Misc.bsa, Skyrim - Shaders.bsa, Skyrim - Textures.bsa, Skyrim - Interface.bsa, Skyrim - Animations.bsa, Skyrim - Meshes.bsa, Skyrim - Sounds.bsa")
						sResourceArchiveList2 := getSettingValue("Archive", "sResourceArchiveList2", blank, "Skyrim - Voices.bsa, Skyrim - VoicesExtra.bsa")
						if isEnderalForgotten = 1
							{
								sResourceArchiveList2 := getSettingValue("Archive", "sResourceArchiveList2", blank, "E - Meshes.bsa, E - Music.bsa, E - Scripts.bsa, E - Sounds.bsa, E - Textures1.bsa, E - Textures2.bsa, E - Textures3.bsa, L - Textures.bsa, L - Voices.bsa")
							}
					}
				else if gameName = Skyrim Special Edition
					{
						sResourceArchiveList := getSettingValue("Archive", "sResourceArchiveList", blank, "Skyrim - Misc.bsa, Skyrim - Shaders.bsa, Skyrim - Interface.bsa, Skyrim - Animations.bsa, Skyrim - Meshes0.bsa, Skyrim - Meshes1.bsa, Skyrim - Sounds.bsa")
						sResourceArchiveList2 := getSettingValue("Archive", "sResourceArchiveList2", blank, "Skyrim - Voices_en0.bsa, Skyrim - Textures0.bsa, Skyrim - Textures1.bsa, Skyrim - Textures2.bsa, Skyrim - Textures3.bsa, Skyrim - Textures4.bsa, Skyrim - Textures5.bsa, Skyrim - Textures6.bsa, Skyrim - Textures7.bsa, Skyrim - Textures8.bsa, Skyrim - Patch.bsa")
					}
				sInvalidationFile := getSettingValue("Archive", "sInvalidationFile", blank, "ArchiveInvalidation.txt")
			}
		sLocalSavePath := getSettingValue("General", "sLocalSavePath", blank, "Saves\")
		iScreenShotIndex := getSettingValue("Display", "iScreenShotIndex", Prefs, "0")
		if gameName = Fallout New Vegas
			gameLanguage := getSettingValue("General", "sLanguage", blank, "ENGLISH")
			
		
			
			
			
			
		sm("Deleting Main INIs...")
		FileSetAttrib, -R, %INIfolder%%gameNameINI%.ini
		FileDelete, %INIfolder%%gameNameINI%.ini
		if gameName != Oblivion
			{
				FileSetAttrib, -R, %INIfolder%%gameNameINI%Prefs.ini
				FileDelete, %INIfolder%%gameNameINI%Prefs.ini
			}
		sm("Copying defaults...")
		
		if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition") and isEnderalForgotten <> 1
			FileCopy, %gameFolder%%gameNameINI%\%gameNameINI%Prefs.ini, %INIfolder%%gameNameINI%Prefs.ini, 1
		if gameName = Fallout 3
			FileCopy, Presets\%gameName%\Default\%gameNameINI%Prefs.ini, %INIfolder%%gameNameINI%Prefs.ini, 1
		if (gameName = "Fallout New Vegas")
			{
				FileCopy, Presets\%gameName%\Default\%gameNameINI%_default.ini, %INIfolder%%gameNameINI%.ini, 1
				FileCopy, Presets\%gameName%\Default\%gameNameINI%Prefs.ini, %INIfolder%%gameNameINI%Prefs.ini, 1
				IniWrite, %gameLanguage%, %INIfolder%%gameNameINI%.ini, General, sLanguage
			}
		else if isEnderalForgotten = 1
			{
				FileCopy, Presets\Skyrim\Default\Skyrim_default.ini, %INIfolder%%gameNameINI%.ini, 1
				FileCopy, Presets\Skyrim\Default\SkyrimPrefs.ini, %INIfolder%%gameNameINI%Prefs.ini, 1
				IniWrite, 1, %INIfolder%%gameNameINI%.ini, General, sIntroSequence
				IniWrite, 32, %INIfolder%%gameNameINI%.ini, MapMenu, uLockedObjectMapLOD
			}
		else
			FileCopy, %gameFolder%%gameNameINI%_default.ini, %INIfolder%%gameNameINI%.ini, 1
			
		IniWrite, % sLocalSavePath, %INIfolder%%gameNameINI%.ini, General, sLocalSavePath

		IniWrite, %A_ScreenWidth%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iSize W
		IniWrite, %A_ScreenHeight%, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iSize H
		
		IniWrite, % iScreenShotIndex, %INIfolder%%gameNameINI%%Prefs%.ini, Display, iScreenShotIndex
		
		if gameName != Oblivion
			IniWrite, % AudioMenu, %INIfolder%%gameNameINI%Prefs.ini, AudioMenu
		
		if gameName = Oblivion
			{
				IniWrite, %uVideoDeviceIdentifierPart1%, %INIfolder%%gameNameINI%.ini, Display, uVideoDeviceIdentifierPart1
				IniWrite, %uVideoDeviceIdentifierPart2%, %INIfolder%%gameNameINI%.ini, Display, uVideoDeviceIdentifierPart2
				IniWrite, %uVideoDeviceIdentifierPart3%, %INIfolder%%gameNameINI%.ini, Display, uVideoDeviceIdentifierPart3
				IniWrite, %uVideoDeviceIdentifierPart4%, %INIfolder%%gameNameINI%.ini, Display, uVideoDeviceIdentifierPart4
			}
		else if gameName = Skyrim Special Edition
			IniWrite, %card%, %INIfolder%%gameNameINI%Prefs.ini, Launcher, sD3DDevice
		else
			IniWrite, %card%, %INIfolder%%gameNameINI%Prefs.ini, Display, sD3DDevice
			
		if gameName != Fallout 4
			{
				IniWrite, %bInvalidateOlderFiles%, %INIfolder%%gameNameINI%.ini, Archive, bInvalidateOlderFiles
				if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
					{
						IniWrite, %sResourceArchiveList%, %INIfolder%%gameNameINI%.ini, Archive, sResourceArchiveList
						IniWrite, %sResourceArchiveList2%, %INIfolder%%gameNameINI%.ini, Archive, sResourceArchiveList2
					}
				else
					IniWrite, %sArchiveList%, %INIfolder%%gameNameINI%.ini, Archive, sArchiveList
				IniWrite, %sInvalidationFile%, %INIfolder%%gameNameINI%.ini, Archive, sInvalidationFile
			}
		
		refreshGUI()
		Sleep, 500
		sm("Your INI files have been successfully reset to default values.")
		return
	}