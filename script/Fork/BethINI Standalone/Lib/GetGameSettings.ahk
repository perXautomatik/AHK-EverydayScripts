getDynamicTrees(bEnableTrees, bEnableTreeAnimations)
	{
		x = 1
		if bEnableTrees = 0
			x = 0
		if bEnableTreeAnimations = 0
			x = 0
		return x
	}

getFixMapMenuNavigation(fMapWorldYawRange, fMapWorldMinPitch, fMapWorldMaxPitch)
	{
		if (fMapWorldYawRange = 400) and (fMapWorldMinPitch = 0) and (fMapWorldMaxPitch = 90)
			return 1
		return 0
	}

getScreens()
	{
		width := getSettingValue("Display", "iSize W", Prefs, A_ScreenWidth)
		height := getSettingValue("Display", "iSize H", Prefs, A_ScreenHeight)
		;probably should recode this to support a more dynamic list of resolutions.
		if (width X height != 800 X 600) and (width X height != 1280 X 720) and (width X height != 1360 X 768) and (width X height != 1366 X 768) and (width X height != 1920 X 1080)
			screens = %width% X %height%||800 X 600|1280 X 720|1360 X 768|1366 X 768|1920 X 1080
		if (width X height = 1280 X 720)
			screens = 800 X 600|%width% X %height%||1360 X 768|1366 X 768|1920 X 1080
		if (width X height = 1360 X 768)
			screens = 800 X 600|1280 X 720|%width% X %height%||1366 X 768|1920 X 1080
		if (width X height = 1366 X 768)
			screens = 800 X 600|1280 X 720|1360 X 768|%width% X %height%||1920 X 1080
		if (width X height = 1920 X 1080)
			screens = 800 X 600|1280 X 720|1360 X 768|1366 X 768|%width% X %height%||
		if (width X height = 800 X 600)
			screens = %width% X %height%||1280 X 720|1360 X 768|1366 X 768|1920 X 1080
		if (A_ScreenWidth X A_ScreenHeight != 800 X 600) and (A_ScreenWidth X A_ScreenHeight != 1280 X 720) and (A_ScreenWidth X A_ScreenHeight != 1360 X 768) and (A_ScreenWidth X A_ScreenHeight != 1366 X 768) and (A_ScreenWidth X A_ScreenHeight != 1920 X 1080) and (width X height != 1920 X 1080)
			screens .= "|" . A_ScreenWidth . " X " . A_ScreenHeight
		else if (A_ScreenWidth X A_ScreenHeight != 800 X 600) and (A_ScreenWidth X A_ScreenHeight != 1280 X 720) and (A_ScreenWidth X A_ScreenHeight != 1360 X 768) and (A_ScreenWidth X A_ScreenHeight != 1366 X 768) and (A_ScreenWidth X A_ScreenHeight != 1920 X 1080) and (width X height = 1920 X 1080)
			screens .= A_ScreenWidth . " X " . A_ScreenHeight
		return screens
	}
	
adapters(adapterCount, iAdapter)
	{
		adapterNum = 0
		if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			iAdapter := getSettingValue("Display", "iAdapter", Prefs, iAdapter)
		else if (gameName = "Skyrim" or gameName = "Oblivion")
			iAdapter := getSettingValue("Display", "iAdapter", blank, iAdapter)
		if (adapterNum = iAdapter) {
			adapters = %adapterNum%||
			}
		else {
				adapters = %adapterNum%|
			}
		while adapterCount > 1
			{
				adapterNum += 1
				if (adapterNum = iAdapter) {
						adapters = %adapters%%adapterNum%||
					}
				else {
						adapters = %adapters%%adapterNum%|
					}
				adapterCount -= 1
			}
		return adapters
	}
	
getAntialias()
	{
		if gameName = Fallout 4
			{
				x := getSettingValue("Display", "sAntiAliasing", Prefs)
				if x =
					antialias = None||FXAA|TAA
				else if x = FXAA
					antialias = None|FXAA||TAA
				else if x = TAA
					antialias = None|FXAA|TAA||
			}
		else if gameName = Skyrim Special Edition
			{
				x := getSettingValue("Display", "bUseTAA", Prefs)
				if x = 0
					antialias = None||TAA
				else
					antialias = None|TAA||
			}
		else
			{
				x := getSettingValue("Display", "iMultiSample", Prefs, "0")
				if (x = 0) or (x = 1)
					antialias = None||2x|4x|8x|16x
				else if (x = 2)
					antialias = None|2x||4x|8x|16x
				else if (x = 4)
					antialias = None|2x|4x||8x|16x
				else if (x = 8)
					antialias = None|2x|4x|8x||16x
				else if (x = 16)
					antialias = None|2x|4x|8x|16x||
				else
					antialias = None|2x|4x|8x|16x|%x%x||
			}
		return antialias
	}

getAnisotropy()
	{
		x := getSettingValue("Display", "iMaxAnisotropy", Prefs, "4")
		if (x = 0) or (x = 1)
			y = None||2x|4x|8x|16x
		else if (x = 2)
			y = None|2x||4x|8x|16x
		else if (x = 4)
			y = None|2x|4x||8x|16x
		else if (x = 8)
			y = None|2x|4x|8x||16x
		else if (x = 16)
			y = None|2x|4x|8x|16x||
		else
			y = None|2x|4x|8x|16x|%x%x||
		return y
	}

getTextureQuality(n1, n2)
	{
		if (n1 = 0) and (n2 = 0)
			y = Poor|Low|Medium|High|Ultra||
		else if (n1 = 0) and (n2 = 1)
			y = Poor|Low|Medium|High||Ultra
		else if (n1 = 1) and (n2 = 1)
			y = Poor|Low|Medium||High|Ultra
		else if (n1 = 1) and (n2 = 2)
			y = Poor|Low||Medium|High|Ultra
		else if (n1 = 2) and (n2 = 3)
			y = Poor||Low|Medium|High|Ultra
		else
			y = Poor|Low|Medium|High|Custom||
		return y
	}

getRemoveMapMenuBlur(bWorldMapNoSkyDepthBlur, fWorldMapDepthBlurScale, fWorldMapMaximumDepthBlur, fWorldMapNearDepthBlurScale)
	{
		if (bWorldMapNoSkyDepthBlur = 1) and (fWorldMapDepthBlurScale = 0) and (fWorldMapMaximumDepthBlur = 0) and (fWorldMapNearDepthBlurScale = 0)
			return 1
		return 0
	}

getDecalQuantity(n)
	{
		if (n = 3)
			y = Poor||Low|Medium|High|Ultra
		else if (n = 10)
			y = Poor|Low||Medium|High|Ultra
		else if (n = 40)
			y = Poor|Low|Medium||High|Ultra
		else if (n = 60)
			y = Poor|Low|Medium||High|Ultra
		else if (n = 100)
			y = Poor|Low|Medium|High||Ultra
		else if (n = 120)
			y = Poor|Low|Medium|High||Ultra
		else if (n = 250)
			y = Poor|Low|Medium|High|Ultra||
		else
			y = Custom||Poor|Low|Medium|High|Ultra
		return y
	}
	
getLightingEffect(bUseBlurShader, bDoHighDynamicRange)
	{
		if bDoHighDynamicRange = 1
			x = None|Bloom|HDR||
		else if bUseBlurShader = 1
			x = None|Bloom||HDR
		else
			x = None||Bloom|HDR
		return x
	}

getGrassWindSpeed(fGrassWindMagnitudeMin, fGrassWindMagnitudeMax)
	{
		if (fGrassWindMagnitudeMin = 0) and (fGrassWindMagnitudeMax = 0)
			x = None||Default
		else if (fGrassWindMagnitudeMin = 5) and (fGrassWindMagnitudeMax = 125)
			x = None|Default||
		else
			x = Custom||None|Default
		return x
	}

getGrass(bDrawShaderGrass, bAllowLoadGrass, bAllowCreateGrass)
	{
		x = 0
		if bAllowLoadGrass = 0
			x = 1
		if bAllowCreateGrass = 1
			x = 0
		if bDrawShaderGrass = 0
			x = 1
		return x
	}
	
getTreeDetailFade(fMeshLODLevel1FadeTreeDistance, fMeshLODLevel2FadeTreeDistance, fTreesMidLODSwitchDist, uiMaxSkinnedTreesToRender)
	{
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

		if gameName = Skyrim
			{
				if (fMeshLODLevel1FadeTreeDistance = 2844) and (fMeshLODLevel2FadeTreeDistance = 2048) and (fTreesMidLODSwitchDist = 3600) and (uiMaxSkinnedTreesToRender = 40)
					x = Default||Low|High|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = 2844) and (fMeshLODLevel2FadeTreeDistance = 2048) and (fTreesMidLODSwitchDist = 3600) and (uiMaxSkinnedTreesToRender = 20)
					x = Default|Low||High|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = 2844) and (fMeshLODLevel2FadeTreeDistance = 2048) and (fTreesMidLODSwitchDist = 5000) and (uiMaxSkinnedTreesToRender = 20)
					x = Default|Low|High||Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = 2844) and (fMeshLODLevel2FadeTreeDistance = 2048) and (fTreesMidLODSwitchDist = 9999999) and (uiMaxSkinnedTreesToRender = 20)
					x = Default|Low|High|Ultra||BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = BethPoorLevel1) and (fMeshLODLevel2FadeTreeDistance = BethPoorLevel2) and (fTreesMidLODSwitchDist = BethPoorMidSwitch) and (uiMaxSkinnedTreesToRender = BethPoorMaxSkinnedTrees)
					x = Default|Low|High|Ultra|BethINI Poor||BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = BethLowLevel1) and (fMeshLODLevel2FadeTreeDistance = BethLowLevel2) and (fTreesMidLODSwitchDist = BethLowMidSwitch) and (uiMaxSkinnedTreesToRender = BethLowMaxSkinnedTrees)
					x = Default|Low|High|Ultra|BethINI Poor|BethINI Low||BethINI Medium|BethINI High|BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = BethMedLevel1) and (fMeshLODLevel2FadeTreeDistance = BethMedLevel2) and (fTreesMidLODSwitchDist = BethMedMidSwitch) and (uiMaxSkinnedTreesToRender = BethMedMaxSkinnedTrees)
					x = Default|Low|High|Ultra|BethINI Poor|BethINI Low|BethINI Medium||BethINI High|BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = BethHiLevel1) and (fMeshLODLevel2FadeTreeDistance = BethHiLevel2) and (fTreesMidLODSwitchDist = BethHiMidSwitch) and (uiMaxSkinnedTreesToRender = BethHiMaxSkinnedTrees)
					x = Default|Low|High|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High||BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = BethUltraLevel1) and (fMeshLODLevel2FadeTreeDistance = BethUltraLevel2) and (fTreesMidLODSwitchDist = BethUltraMidSwitch) and (uiMaxSkinnedTreesToRender = BethUltraMaxSkinnedTrees)
					x = Default|Low|High|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra||
				else
					x = Custom||Default|Low|High|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
			}
		else if gameName = Skyrim Special Edition
			{
				if (fMeshLODLevel1FadeTreeDistance = 2844) and (fMeshLODLevel2FadeTreeDistance = 2048) and (fTreesMidLODSwitchDist = 3600) and (uiMaxSkinnedTreesToRender = 40)
					x = Default||Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = 2844) and (fMeshLODLevel2FadeTreeDistance = 2048) and (fTreesMidLODSwitchDist = 9999999) and (uiMaxSkinnedTreesToRender = 40)
					x = Default|Ultra||BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = BethPoorLevel1) and (fMeshLODLevel2FadeTreeDistance = BethPoorLevel2) and (fTreesMidLODSwitchDist = BethPoorMidSwitch) and (uiMaxSkinnedTreesToRender = BethPoorMaxSkinnedTrees)
					x = Default|Ultra|BethINI Poor||BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = BethLowLevel1) and (fMeshLODLevel2FadeTreeDistance = BethLowLevel2) and (fTreesMidLODSwitchDist = BethLowMidSwitch) and (uiMaxSkinnedTreesToRender = BethLowMaxSkinnedTrees)
					x = Default|Ultra|BethINI Poor|BethINI Low||BethINI Medium|BethINI High|BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = BethMedLevel1) and (fMeshLODLevel2FadeTreeDistance = BethMedLevel2) and (fTreesMidLODSwitchDist = BethMedMidSwitch) and (uiMaxSkinnedTreesToRender = BethMedMaxSkinnedTrees)
					x = Default|Ultra|BethINI Poor|BethINI Low|BethINI Medium||BethINI High|BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = BethHiLevel1) and (fMeshLODLevel2FadeTreeDistance = BethHiLevel2) and (fTreesMidLODSwitchDist = BethHiMidSwitch) and (uiMaxSkinnedTreesToRender = BethHiMaxSkinnedTrees)
					x = Default|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High||BethINI Ultra
				else if (fMeshLODLevel1FadeTreeDistance = BethUltraLevel1) and (fMeshLODLevel2FadeTreeDistance = BethUltraLevel2) and (fTreesMidLODSwitchDist = BethUltraMidSwitch) and (uiMaxSkinnedTreesToRender = BethUltraMaxSkinnedTrees)
					x = Default|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra||
				else
					x = Custom||Default|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
			}
		return x
	}

getFadeDistantLOD(fBlockLevel0Distance,fBlockLevel1Distance="",fBlockMaximumDistance="",fSplitDistanceMult="", fBlockLevel2Distance="")
	{
		x =
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
				HIlevel0 := Round(getSettingValue("TerrainManager", "fBlockLoadDistanceLow", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\Vanilla-Presets\high\"),0)
				ULTRAlevel0 := Round(getSettingValue("TerrainManager", "fBlockLoadDistanceLow", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevel0, "Presets\" . gameName . "\Vanilla-Presets\ultra\"),0)
				LOWlevelmax := Round(getSettingValue("TerrainManager", "fBlockLoadDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\Vanilla-Presets\low\"),0)
				HIlevelmax := Round(getSettingValue("TerrainManager", "fBlockLoadDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\Vanilla-Presets\high\"),0)
				ULTRAlevelmax := Round(getSettingValue("TerrainManager", "fBlockLoadDistance", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultLevelmax, "Presets\" . gameName . "\Vanilla-Presets\ultra\"),0)
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
			}
			
				LOWsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\Vanilla-Presets\low\"),3)
				HIsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\Vanilla-Presets\high\"),3)
				ULTRAsplit := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", gameNameINIWorkaroundForEnderalForgotten . Prefs, defaultSplit, "Presets\" . gameName . "\Vanilla-Presets\ultra\"),3)
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
			}
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			{	
				output = 0
				c = 1
				while output = 0
					{
						if c = 1
							preset = LOW
						else if c = 2
							preset = MED
						else if c = 3
							preset = HI
						else if c = 4
							preset = ULTRA
						else if c = 5
							preset = bethPOOR
						else if c = 6
							preset = bethLOW
						else if c = 7
							preset = bethMED
						else if c = 8
							preset = bethHI
						else if c = 9
							preset = bethULTRA
						else
							preset = Custom
						if preset <> Custom
							{
								level0 = % %preset%level0
								level1 = % %preset%level1
								levelmax = % %preset%levelmax
								split = % %preset%split
								if (fBlockLevel0Distance = level0) and (fBlockLevel1Distance = level1) and (fBlockMaximumDistance = levelmax) and (fSplitDistanceMult = split)
									output = %preset%
								else
									c += 1
							}
						else
							output = Custom
					}
				if output = LOW
					x = Low||Medium|High|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = MED
					x = Low|Medium||High|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = HI
					x = Low|Medium|High||Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = ULTRA
					x = Low|Medium|High|Ultra||BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = bethPOOR
					x = Low|Medium|High|Ultra|BethINI Poor||BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = bethLOW
					x = Low|Medium|High|Ultra|BethINI Poor|BethINI Low||BethINI Medium|BethINI High|BethINI Ultra
				else if output = bethMED
					x = Low|Medium|High|Ultra|BethINI Poor|BethINI Low|BethINI Medium||BethINI High|BethINI Ultra
				else if output = bethHI
					x = Low|Medium|High|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High||BethINI Ultra
				else if output = bethULTRA
					x = Low|Medium|High|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra||
				else
					x = Custom||Low|Medium|High|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
			}
		else if gameName = Fallout 4
			{
				output = 0
				c = 1
				while output = 0
					{
						if c = 1
							preset = LOW
						else if c = 2
							preset = MED
						else if c = 3
							preset = HI
						else if c = 4
							preset = ULTRA
						else if c = 5
							preset = bethPOOR
						else if c = 6
							preset = bethLOW
						else if c = 7
							preset = bethMED
						else if c = 8
							preset = bethHI
						else if c = 9
							preset = bethULTRA
						else
							preset = Custom
						if preset <> Custom
							{
								level0 = % %preset%level0
								level1 = % %preset%level1
								level2 = % %preset%level2
								levelmax = % %preset%levelmax
								split = % %preset%split
								if (fBlockLevel0Distance = level0) and (fBlockLevel1Distance = level1) and (fBlockLevel2Distance = level2) and (fBlockMaximumDistance = levelmax) and (fSplitDistanceMult = split)
									output = %preset%
								else
									c += 1
							}
						else
							output = Custom
					}
				if output = LOW
					x = Low||Medium|High|Ultra
					;|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = MED
					x = Low|Medium||High|Ultra
					;|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = HI
					x = Low|Medium|High||Ultra
					;|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = ULTRA
					x = Low|Medium|High|Ultra||
					;BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = bethPOOR
					x = Low|Medium|High|Ultra|BethINI Poor||BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = bethLOW
					x = Low|Medium|High|Ultra|BethINI Poor|BethINI Low||BethINI Medium|BethINI High|BethINI Ultra
				else if output = bethMED
					x = Low|Medium|High|Ultra|BethINI Poor|BethINI Low|BethINI Medium||BethINI High|BethINI Ultra
				else if output = bethHI
					x = Low|Medium|High|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High||BethINI Ultra
				else if output = bethULTRA
					x = Low|Medium|High|Ultra|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra||
				else
					x = Custom||Low|Medium|High|Ultra
			}
		else if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			{
				output = 0
				c = 1
				while output = 0
					{
						if c = 1
							preset = LOW
						else if c = 2
							preset = HI
						else if c = 3
							preset = HI
						else if c = 4
							preset = ULTRA
						else if c = 5
							preset = bethPOOR
						else if c = 6
							preset = bethLOW
						else if c = 7
							preset = bethMED
						else if c = 8
							preset = bethHI
						else if c = 9
							preset = bethULTRA
						else
							preset = Custom
						if preset <> Custom
							{
								level0 = % %preset%level0
								levelmax = % %preset%levelmax
								split = % %preset%split
								if (fBlockLevel0Distance = level0) and (fBlockMaximumDistance = levelmax) and (fSplitDistanceMult = split)
									output = %preset%
								else
									c += 1
							}
						else
							output = Custom
					}
				if output = LOW
					x = Low||Medium|High|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = HI
					x = Low|Medium||High|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = ULTRA
					x = Low|Medium|High||BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = bethPOOR
					x = Low|Medium|High|BethINI Poor||BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if output = bethLOW
					x = Low|Medium|High|BethINI Poor|BethINI Low||BethINI Medium|BethINI High|BethINI Ultra
				else if output = bethMED
					x = Low|Medium|High|BethINI Poor|BethINI Low|BethINI Medium||BethINI High|BethINI Ultra
				else if output = bethHI
					x = Low|Medium|High|BethINI Poor|BethINI Low|BethINI Medium|BethINI High||BethINI Ultra
				else if output = bethULTRA
					x = Low|Medium|High|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra||
				else
					x = Custom||Low|Medium|High|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				
				
				/*
				if (fBlockLevel0Distance = LOWlevel0) and (fBlockMaximumDistance = LOWlevelmax) and (fSplitDistanceMult = LOWsplit)
					x = Low||Medium|High|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if (fBlockLevel0Distance = HIlevel0) and (fBlockMaximumDistance = HIlevelmax) and (fSplitDistanceMult = HIsplit)
					x = Low|Medium||High|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else if (fBlockLevel0Distance = ULTRAlevel0) and (fBlockMaximumDistance = ULTRAlevelmax) and (fSplitDistanceMult = ULTRAsplit)
					x = Low|Medium|High||BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
				else
					x = Custom||Low|Medium|High|BethINI Poor|BethINI Low|BethINI Medium|BethINI High|BethINI Ultra
					*/
			}
		return x
	}

getDecalFade(fDecalLODFadeStart, fDecalLODFadeEnd)
	{
		if (fDecalLODFadeStart = 0.0500) and (fDecalLODFadeEnd = 0.0600)
			x = Poor||Low|Medium|High|Ultra
		else if (fDecalLODFadeStart = 0.1000) and (fDecalLODFadeEnd = 0.1500)
			x = Poor|Low||Medium|High|Ultra
		else if (fDecalLODFadeStart = 0.2000) and (fDecalLODFadeEnd = 0.3000)
			x = Poor|Low|Medium||High|Ultra
		else if (fDecalLODFadeStart = 0.5000) and (fDecalLODFadeEnd = 0.6000)
			x = Poor|Low|Medium|High||Ultra
		else if (fDecalLODFadeStart = 1.0000) and (fDecalLODFadeEnd = 1.1000)
			x = Poor|Low|Medium|High|Ultra||
		else
			x = Custom||Poor|Low|Medium|High|Ultra
		return x
	}

getObjectDetailFade(fMeshLODLevel1FadeDist, fMeshLODLevel2FadeDist)
	{
		if (fMeshLODLevel1FadeDist = 4096) and (fMeshLODLevel2FadeDist = 3072) and (gameName = "Skyrim")
			x = Default||Poor|Low|Medium|High|Ultra
		else if (fMeshLODLevel1FadeDist = 4000) and (fMeshLODLevel2FadeDist = 3000) and (gameName = "Fallout 4")
			x = Default||Poor|Low|Medium|High|Ultra
		else if (fMeshLODLevel1FadeDist = 2816) and (fMeshLODLevel2FadeDist = 1280)
			x = Default|Poor||Low|Medium|High|Ultra
		else if (fMeshLODLevel1FadeDist = 3840) and (fMeshLODLevel2FadeDist = 2048)
			x = Default|Poor|Low||Medium|High|Ultra
		else if (fMeshLODLevel1FadeDist = 5376) and (fMeshLODLevel2FadeDist = 3456)
			x = Default|Poor|Low|Medium||High|Ultra
		else if (fMeshLODLevel1FadeDist = 10240) and (fMeshLODLevel2FadeDist = 7680)
			x = Default|Poor|Low|Medium|High||Ultra
		else if (fMeshLODLevel1FadeDist >= 16896) and (fMeshLODLevel2FadeDist >= 16896)
			x = Default|Poor|Low|Medium|High|Ultra||
		else
			x = Custom||Default|Poor|Low|Medium|High|Ultra
		return x
	}
	
getAmbientOcclusion(bSAOEnable, bEnable)
	{
		if bSAOEnable = 0
			x = None||SSAO|HBAO+
		else if bEnable = 0
			x = None|SSAO||HBAO+
		else
			x = None|SSAO|HBAO+||
		return x
	}
	
getGodrays(bVolumetricLightingEnable, iVolumetricLightingQuality)
	{
		if iVolumetricLightingQuality = 0
			x = None|Low||Medium|High
		if iVolumetricLightingQuality = 1
			x = None|Low|Medium||High
		if iVolumetricLightingQuality = 2
			x = None|Low|Medium|High||
		if bVolumetricLightingEnable = 0
			x = None||Low|Medium|High
		return x
	}