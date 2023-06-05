checkForMod(modFile, NexusID="-1")
	{
		;Checks to see if the modFile for the given NexusID exists and returns its path if found. Returns 0 if not found.
		if INIfolder contains rofiles
			{
				;MO-location\profiles\profile-name --> MO-location\profiles\
				SplitPath, INIfolder,, profilesDirectory
				
				;MO-location\profiles --> MO-location
				SplitPath, profilesDirectory,, profilesDirectory
				
				;Is this necessary?
				SplitPath, profilesDirectory,, moPath
				
				IniRead, modsPath, %moPath%\ModOrganizer.ini, Settings, mod_directory, % "%BASE_DIR%/mods"
				;modsPath := getSettingValue("Settings", "mod_directory", "ModOrganizer", "%BASE_DIR%/mods", moPath)
				modsPath := StrReplace(StrReplace(modsPath, "\\" , "\"), "/", "\")
				if modsPath contains BASE_DIR
					{
						StringReplace, modsPath, modsPath, % "%BASE_DIR%\", % blank, All
						modsPath = %moPath%\%modsPath%
					}
				Loop, Read, %INIfolder%modlist.txt
					{
						if SubStr(A_LoopReadLine, 1, 1) = "+"
							{
								modName := SubStr(A_LoopReadLine, 2)
								modFilePath = %modsPath%\%modName%\
								if getSettingValue("General", "modid", "meta", "-1", modFilePath) = NexusID
									break
							}
					}
			}
		else
			modFilePath = %gameFolder%Data\
		modFileLocation = %modFilePath%%modFile%
		IfExist, %modFileLocation%
			return modFileLocation
		return 0
	}