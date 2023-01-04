setPreset(VanillaPresets, quality)
	{
		if gameName = Skyrim
			card := getVideoCard()
		
		if VanillaPresets = 1
			{
				PresetType = Vanilla
				if (quality = 0) and (gameName != "Oblivion")
					{
						MsgBox, You should not receive this error. Inform me if you do.
						sm("You should not receive this error. Inform me if you do.")
						return
					}
			}
		else
			PresetType = %shortName%
			
		if quality = 0
			PresetQuality = poor
		else if quality = 1
			PresetQuality = low
		else if quality = 2
			PresetQuality = medium
		else if quality = 3
			PresetQuality = high
		else if quality = 4
			PresetQuality = ultra
		
		if isEnderalForgotten = 1
			{
				IntegrateINI(INIfolder . gameNameINI . ".ini", "Presets\" . gameName . "\" . PresetType . "-Presets\" . PresetQuality . "\Skyrim.ini")
				IntegrateINI(INIfolder . gameNameINI . Prefs . ".ini", "Presets\" . gameName . "\" . PresetType . "-Presets\" . PresetQuality . "\Skyrim" . Prefs . ".ini")
			}
		else
			{
				IntegrateINI(INIfolder . gameNameINI . ".ini", "Presets\" . gameName . "\" . PresetType . "-Presets\" . PresetQuality . "\" . gameNameINI . ".ini")
				IntegrateINI(INIfolder . gameNameINI . Prefs . ".ini", "Presets\" . gameName . "\" . PresetType . "-Presets\" . PresetQuality . "\" . gameNameINI . Prefs . ".ini")
			}
		
		if gameName = Skyrim
			IniWrite, %card%, %INIfolder%%gameNameINI%Prefs.ini, Display, sD3DDevice
			
		modSuggestedINITweaks()
		refreshGUI()
		sleep, 1000
		sm("Video settings have been set for " . PresetType . " " . PresetQuality . " quality.")
		return
	}