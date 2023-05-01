IntegrateINI(INItoIntegrateInto, INItoIntegrateOverTheInto)
	{
		;shut down variables 1 and 3
		RIni_Shutdown(1)
		RIni_Shutdown(3)
		;The main INItoIntegrateInto becomes variable 1
		RIni_Read(1, INItoIntegrateInto)
		;The INItoIntegrateOverTheInto becomes variable 3
		RIni_Read(3, INItoIntegrateOverTheInto)
		;Merges the current INItoIntegrateInto with the INItoIntegrateOverTheInto, overwriting anything that was there with the INItoIntegrateOverTheInto.
		RIni_Merge(3, 1, 2, 3)
		;Sorts it. Not really necessary.
		RIni_SortSections(1)
		;Writes the merged INItoIntegrateInto
		RIni_Write(1, INItoIntegrateInto)
		
		;shuts down all variables
		RIni_Shutdown(1)
		RIni_Shutdown(3)
		;This is a hack to clear the variables so that the INIs can be dynamic
		if gameName != Skyrim
			{
				RIni_Read(1, "Presets\Skyrim\Vanilla-Presets\ultra\SkyrimPrefs.ini")
				RIni_Read(3, "Presets\Skyrim\Vanilla-Presets\ultra\SkyrimPrefs.ini")
			}
		else
			{
				RIni_Read(1, "Presets\Fallout 4\Vanilla-Presets\high\Fallout4Prefs.ini")
				RIni_Read(3, "Presets\Fallout 4\Vanilla-Presets\high\Fallout4Prefs.ini")
			}
		return
	}