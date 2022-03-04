modSuggestedINITweaks()
	{
		sm("Applying mod-suggested INI tweaks.")
		if gameName = Skyrim
			{
				if checkForPlugin("Skyrim Flora Overhaul.esp") = 1
					{
						if Round(getSettingValue("Grass", "iMaxGrassTypesPerTexure", blank, "2"),0) < 7
							IniWrite, 7, %INIfolder%%gameNameINI%.ini, Grass, iMaxGrassTypesPerTexure
					}
				if checkForPlugin("Verdant - A Skyrim Grass Plugin.esp") = 1
					{
						if Round(getSettingValue("Grass", "iMaxGrassTypesPerTexure", blank, "2"),0) < 15
							IniWrite, 15, %INIfolder%%gameNameINI%.ini, Grass, iMaxGrassTypesPerTexure
						if Round(getSettingValue("Grass", "iMinGrassSize", blank, "20"),0) < 60
							IniWrite, 60, %INIfolder%%gameNameINI%.ini, Grass, iMinGrassSize
					}
				if checkForPlugin("Vivid Weathers.esp") = 1
					{
						IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fGamma
						if Round(getSettingValue("Particles", "iMaxDesired", Prefs, "750"),0) < 6000
							IniWrite, 6000, %INIfolder%%gameNameINI%%Prefs%.ini, Particles, iMaxDesired
					}
			}
		if gameName = Skyrim Special Edition
			{
				if checkForPlugin("Skyrim Flora Overhaul.esp") = 1
					{
						if Round(getSettingValue("Grass", "iMaxGrassTypesPerTexure", blank, "2"),0) < 7
							IniWrite, 7, %INIfolder%%gameNameINI%.ini, Grass, iMaxGrassTypesPerTexure
					}
				if checkForPlugin("Verdant - A Skyrim Grass Plugin SSE Version.esp") = 1
					{
						if Round(getSettingValue("Grass", "iMaxGrassTypesPerTexure", blank, "2"),0) < 15
							IniWrite, 15, %INIfolder%%gameNameINI%.ini, Grass, iMaxGrassTypesPerTexure
						if Round(getSettingValue("Grass", "iMinGrassSize", blank, "20"),0) < 60
							IniWrite, 60, %INIfolder%%gameNameINI%.ini, Grass, iMinGrassSize
					}
				if checkForPlugin("Vivid WeathersSE.esp") = 1
					{
						IniWrite, 1, %INIfolder%%gameNameINI%%Prefs%.ini, Display, fGamma
						if Round(getSettingValue("Particles", "iMaxDesired", Prefs, "750"),0) < 6000
							IniWrite, 6000, %INIfolder%%gameNameINI%%Prefs%.ini, Particles, iMaxDesired
					}
				if checkForPlugin("SimplyFasterArrows.esp") = 1
					{
						IniWrite, 0.3, %INIfolder%%gameNameINI%.ini, Combat, f1PArrowTiltUpAngle
						IniWrite, 0.3, %INIfolder%%gameNameINI%.ini, Combat, f3PArrowTiltUpAngle
						IniWrite, 0.3, %INIfolder%%gameNameINI%.ini, Combat, f1PBoltTiltUpAngle
					}
				if checkForPlugin("Nyhus.esp") = 1
					IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, bBorderRegionsEnabled
				if checkForPlugin("Jehanna.esp") = 1
					IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, bBorderRegionsEnabled
				if checkForPlugin("Folkstead.esp") = 1
					IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, bBorderRegionsEnabled
				if checkForPlugin("SnowElfPalace.esp") = 1
					IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, bBorderRegionsEnabled
					
				if checkForPlugin("Improved Mountain LOD and Z Fight Patch.esp") = 1
					{
						IniWrite, 95000, %INIfolder%%gameNameINI%%Prefs%.ini, TerrainManager, fBlockLevel0Distance
						IniWrite, 330000, %INIfolder%%gameNameINI%%Prefs%.ini, TerrainManager, fBlockLevel1Distance
						IniWrite, 350000, %INIfolder%%gameNameINI%%Prefs%.ini, TerrainManager, fBlockMaximumDistance
					}
			}
		sm("Finished applying mod-suggested INI tweaks.")
		return
	}