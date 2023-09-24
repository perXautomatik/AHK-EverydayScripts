refreshGUI()
	{
		sm("Refreshing GUI...")
		Resolution := getScreens()
		GuiControl, Main:, Resolution, |%Resolution%
		Antialiasing := getAntialias()
		GuiControl, Main:, Antialiasing, |%Antialiasing%
		Windowed := Abs(getSettingValue("Display", "bFull Screen", Prefs, "0") - 1)
		GuiControl, Main:, Windowed, %Windowed%
		if gameName = Fallout 4
			IntroMusic := getSettingValue("General", "bPlayMainMenuMusic", blank, "1")
		else if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			{
				if getSettingValue("General", "sMainMenuMusic", blank, "\Data\Music\Special\MUS_MainTheme.xwm") = blank
					IntroMusic = 0
				else
					IntroMusic = 1
			}
		else
			{
				if getSettingValue("Audio", "fMainMenuMusicVolume", blank, "0.6") = 0
					IntroMusic = 0
				else
					IntroMusic = 1
			}
		GuiControl, Main:, IntroMusic, %IntroMusic%
		if gameName = Skyrim Special Edition
			DecalQuantity := getDecalQuantity(getSettingValue("Display", "iMaxDecalsPerFrame", Prefs, "100"))
		else if gameName = Fallout 4
			DecalQuantity := getDecalQuantity(getSettingValue("Display", "iMaxDecalsPerFrame", Prefs, "40"))
		else
			DecalQuantity := getDecalQuantity(getSettingValue("Display", "iMaxDecalsPerFrame", Prefs, "10"))
		GuiControl, Main:, DecalQuantity, |%DecalQuantity%
		if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			iPresentInterval := getSettingValue("Display", "iPresentInterval", blank, "1")
		else if gameName = Skyrim Special Edition
			iPresentInterval := getSettingValue("Display", "iVSyncPresentInterval", Prefs, "1")
		else
			iPresentInterval := getSettingValue("Display", "iPresentInterval", Prefs, "1")
		if iPresentInterval <> 0
			iPresentInterval = 1
		GuiControl, Main:, iPresentInterval, %iPresentInterval%
		if gameName = Skyrim
			ShadowRes := sortNumberedList("256|512|1024|2048|4096|8192", Round(getSettingValue("Display", "iShadowMapResolution", Prefs, "1024"),0))
		else if gameName = Fallout 4
			ShadowRes := sortNumberedList("256|512|1024|2048|4096|8192", Round(getSettingValue("Display", "iShadowMapResolution", Prefs, "2048"),0))
		else
			ShadowRes := sortNumberedList("256|512|1024|2048|4096|8192", Round(getSettingValue("Display", "iShadowMapResolution", Prefs, "256"),0))
		GuiControl, Main:, ShadowRes, |%ShadowRes%
		if gameName = Fallout 4
			FadeObjects := Round(getSettingValue("LOD", "fLODFadeOutMultObjects", Prefs, "4.5"),1)
		else
			FadeObjects := Round(getSettingValue("LOD", "fLODFadeOutMultObjects", Prefs, "5"),1)
		GuiControl, Main:, FadeObjects, %FadeObjects%
		GuiControl, Main:, FadeObjectsReal, %FadeObjects%
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			FadeActors := Round(getSettingValue("LOD", "fLODFadeOutMultActors", Prefs, "6"),1)
		else if gameName = Oblivion
			FadeActors := Round(getSettingValue("LOD", "fLODFadeOutMultActors", blank, "5"),1)
		else
			FadeActors := Round(getSettingValue("LOD", "fLODFadeOutMultActors", Prefs, "6.3333"),1)
		GuiControl, Main:, FadeActors, %FadeActors%
		GuiControl, Main:, FadeActorsReal, %FadeActors%
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
		
		if gameName = Fallout 4
			uGridsToLoad := getSettingValue("General", "uGridsToLoad", Prefs, "5")
		else
			uGridsToLoad := getSettingValue("General", "uGridsToLoad", blank, "5")
		GuiControl, Main:, uGridsToLoad, %uGridsToLoad%
		if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
			RemoveGrass := getGrass(getSettingValue("Grass", "bDrawShaderGrass", blank, "1"), getSettingValue("Grass", "bAllowLoadGrass", blank, "1"), getSettingValue("Grass", "bAllowCreateGrass", blank, "0"))
		else
			RemoveGrass := Abs(getSettingValue("Grass", "bDrawShaderGrass", blank, "1") - 1)
		GuiControl, Main:, RemoveGrass, %RemoveGrass%
		if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
			GrassDensity := Round(getSettingValue("Grass", "iMinGrassSize", blank, "20"),0)
		else
			GrassDensity := Round(getSettingValue("Grass", "iMinGrassSize", blank, "80"),0)
		GuiControl, Main:, GrassDensity, %GrassDensity%
		GuiControl, Main:, GrassDensityReal, %GrassDensity%
		GrassDiversity := Round(getSettingValue("Grass", "iMaxGrassTypesPerTexure", blank, "2"),0)
		GuiControl, Main:, GrassDiversity, %GrassDiversity%
		GuiControl, Main:, GrassDiversityReal, %GrassDiversity%
		if (gameName = "Skyrim" or gameName = "Fallout 4")
			BackgroundMouse := getSettingValue("Controls", "bBackgroundMouse", blank, "0")
		else
			BackgroundMouse := getSettingValue("Controls", "bBackground Mouse", blank, "0")
		GuiControl, Main:, BackgroundMouse, %BackgroundMouse%
		DisablePrecipitation := Abs(getSettingValue("Weather", "bPrecipitation", blank, "1") - 1)
		GuiControl, Main:, DisablePrecipitation, %DisablePrecipitation%
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
		if (gameName = "Oblivion" or gameName = "Fallout New Vegas" or gameName = "Fallout 3")
			bDialogueSubtitles := getSettingValue("GamePlay", "bDialogueSubtitles", Prefs, "1")
		else
			bDialogueSubtitles := getSettingValue("Interface", "bDialogueSubtitles", Prefs, "0")
		GuiControl, Main:, bDialogueSubtitles, %bDialogueSubtitles%
		if (gameName = "Fallout New Vegas" or gameName = "Fallout 3")
			bGeneralSubtitles := getSettingValue("GamePlay", "bGeneralSubtitles", Prefs, "0")
		else if gameName = Oblivion
			bGeneralSubtitles := getSettingValue("GamePlay", "bGeneralSubtitles", blank, "1")
		else
			bGeneralSubtitles := getSettingValue("Interface", "bGeneralSubtitles", Prefs, "0")
		GuiControl, Main:, bGeneralSubtitles, %bGeneralSubtitles%
		bBorderRegionsEnabled := Abs(getSettingValue("General", "bBorderRegionsEnabled", blank, "1") - 1)
		GuiControl, Main:, bBorderRegionsEnabled, %bBorderRegionsEnabled%
		sScreenShotBaseName := getSettingValue("Display", "sScreenShotBaseName", blank, "ScreenShot")
		SplitPath, sScreenShotBaseName, sScreenShotBaseNameFileName, sScreenShotBaseName
		if sScreenShotBaseName =
			sScreenShotBaseName = %gameFolder%
		else
			sScreenShotBaseName .= "\"
		GuiControl, Main:, sScreenShotBaseName, %sScreenShotBaseName%||Browse...
		GuiControl, Main:, sScreenShotBaseNameFileName, %sScreenShotBaseNameFileName%
		iScreenShotIndex := getSettingValue("Display", "iScreenShotIndex", Prefs, "0")
		GuiControl, Main:, iScreenShotIndex, %iScreenShotIndex%
		FPS := Round(1/getSettingValue("HAVOK", "fMaxTime", blank, "0.0166666675"), 0)
		GuiControl, Main:, FPS, %FPS%
		iFPSClamp := getSettingValue("General", "iFPSClamp", blank, "0")
		if iFPSClamp <> 0
			iFPSClamp = 1
		GuiControl, Main:, iFPSClamp, %iFPSClamp%
		if gameName = Oblivion
			{
				bUseWaterReflectionsMisc := getSettingValue("Water", "bUseWaterReflectionsMisc", blank, "0")
				GuiControl, Main:, bUseWaterReflectionsMisc, %bUseWaterReflectionsMisc%
				bUseWaterReflectionsStatics := getSettingValue("Water", "bUseWaterReflectionsStatics", blank, "0")
				GuiControl, Main:, bUseWaterReflectionsStatics, %bUseWaterReflectionsStatics%
				bUseWaterReflectionsActors := getSettingValue("Water", "bUseWaterReflectionsActors", blank, "0")
				GuiControl, Main:, bUseWaterReflectionsActors, %bUseWaterReflectionsActors%
				bUseWaterHiRes := getSettingValue("Water", "bUseWaterHiRes", blank, "0")
				GuiControl, Main:, bUseWaterHiRes, %bUseWaterHiRes%
				bUseWaterDisplacements := getSettingValue("Water", "bUseWaterDisplacements", blank, "1")
				GuiControl, Main:, bUseWaterDisplacements, %bUseWaterDisplacements%
				bEnableTrees := getSettingValue("SpeedTree", "bEnableTrees", blank, "1")
				GuiControl, Main:, bEnableTrees, %bEnableTrees%
				bForceFullLOD := getSettingValue("SpeedTree", "bForceFullLOD", blank, "1")
				GuiControl, Main:, bForceFullLOD, %bForceFullLOD%
				bActorSelfShadowing := getSettingValue("Display", "bActorSelfShadowing", blank, "0")
				GuiControl, Main:, bActorSelfShadowing, %bActorSelfShadowing%
				bInstantLevelUp := getSettingValue("GamePlay", "bInstantLevelUp", blank, "0")
				GuiControl, Main:, bInstantLevelUp, %bInstantLevelUp%
				bMusicEnabled := getSettingValue("Audio", "bMusicEnabled", blank, "1")
				GuiControl, Main:, bMusicEnabled, %bMusicEnabled%
				bDoCanopyShadowPass := getSettingValue("Display", "bDoCanopyShadowPass", blank, "1")
				GuiControl, Main:, bDoCanopyShadowPass, %bDoCanopyShadowPass%
				fGlobalTimeMultiplier := Round(getSettingValue("General", "fGlobalTimeMultiplier", blank, "1"),1)
				GuiControl, Main:, fGlobalTimeMultiplier, %fGlobalTimeMultiplier%
				fShadowLOD := sortNumberedList("0|512|1024|2048|4096|8192", Round(getSettingValue("Display", "fShadowLOD2", blank, "400"),0))
				GuiControl, Main:, fShadowLOD, |%fShadowLOD%
			}
		if gameName = Skyrim
			{
				ShadowRemoval := getSettingValue("Display", "iShadowMapResolution", Prefs, "1024")
				if (ShadowRemoval != 1)
					ShadowRemoval = 0
				GuiControl, Main:, ShadowRemoval, %ShadowRemoval%
				ShadowDeffer := getSettingValue("Display", "bDeferredShadows", Prefs, "1")
				GuiControl, Main:, ShadowDeffer, %ShadowDeffer%
				ShadowTrees := getSettingValue("Display", "bTreesReceiveShadows", Prefs, "0")
				GuiControl, Main:, ShadowTrees, %ShadowTrees%
				ShadowBlur := sortNumberedList("1|3|4|5|7", Round(getSettingValue("Display", "iBlurDeferredShadowMask", Prefs, "5"),0))
				ShadowBlur = none|%ShadowBlur%|max
				if (getSettingValue("Display", "iBlurDeferredShadowMask", Prefs, "5") < 0)
					ShadowBlur = none|1|3|4|5|7|max||
				if (getSettingValue("Display", "iBlurDeferredShadowMask", Prefs, "5") = 0)
					ShadowBlur = none||1|3|4|5|7|max
				GuiControl, Main:, ShadowBlur, |%ShadowBlur%
				ShadowBias := sortNumberedList("0.15|0.25|0.50|0.90|1.00", Round(getSettingValue("Display", "fShadowBiasScale", Prefs, "1.00"),2))
				GuiControl, Main:, ShadowBias, |%ShadowBias%
				PreciseLighting := getSettingValue("Display", "bFloatPointRenderTarget", Prefs, "0")
				GuiControl, Main:, PreciseLighting, %PreciseLighting%
			}
		if gameName = Skyrim Special Edition
			{
				Godrays := getGodrays(getSettingValue("Display", "bVolumetricLightingEnable", Prefs, "1"),getSettingValue("Display", "iVolumetricLightingQuality", Prefs, "1"))
				GuiControl, Main:, Godrays, |%Godrays%
				bToggleSparkles := getSettingValue("Display", "bToggleSparkles", Prefs, "1")
				GuiControl, Main:, bToggleSparkles, %bToggleSparkles%
				fFirstSliceDistance := sortNumberedList("1250|2000|2800|3500|4000", Round(getSettingValue("Display", "fFirstSliceDistance", blank, "1250"),0))
				GuiControl, Main:, fFirstSliceDistance, |%fFirstSliceDistance%
				ShadowBias := sortNumberedList("0.15|0.25|0.30|0.50|1.00", Round(getSettingValue("Display", "fShadowDirectionalBiasScale", blank, "0.3"),2))
				GuiControl, Main:, ShadowBias, |%ShadowBias%
				ShadowRemoval = 0
				if getSettingValue("Display", "fShadowDistance", Prefs, "8000") < 10
					ShadowRemoval = 1
				GuiControl, Main:, ShadowRemoval, %ShadowRemoval%
				bEnableGrassFade := getSettingValue("Grass", "bEnableGrassFade", blank, "1")
				GuiControl, Main:, bEnableGrassFade, %bEnableGrassFade%
				bEnableSnowRimLighting := getSettingValue("Display", "bEnableSnowRimLighting", blank, "1")
				GuiControl, Main:, bEnableSnowRimLighting, %bEnableSnowRimLighting%
				fSparklesIntensity := sortNumberedList("0.20|0.30|0.50|0.90|1.00", Round(getSettingValue("Display", "fSparklesIntensity", blank, "1.00"),2))
				GuiControl, Main:, fSparklesIntensity, |%fSparklesIntensity%
				bEnableImprovedSnow := getSettingValue("Display", "bEnableImprovedSnow", Prefs, "1")
				GuiControl, Main:, bEnableImprovedSnow, %bEnableImprovedSnow%
				HalfRate := getSettingValue("Display", "iVSyncPresentInterval", Prefs, "1")
				if HalfRate = 2
					HalfRate = 1
				else
					HalfRate = 0
				GuiControl, Main:, HalfRate, %HalfRate%
				bLockFrameRate := getSettingValue("Display", "bLockFrameRate", blank, "1")
				GuiControl, Main:, bLockFrameRate, %bLockFrameRate%
				bIBLFEnable := getSettingValue("Display", "bIBLFEnable", Prefs, "1")
				GuiControl, Main:, bIBLFEnable, %bIBLFEnable%
				bVolumetricLightingDisableInterior := Abs(getSettingValue("Display", "bVolumetricLightingDisableInterior", blank, "1") - 1)
				GuiControl, Main:, bVolumetricLightingDisableInterior, %bVolumetricLightingDisableInterior%
				bEnableProjecteUVDiffuseNormals := getSettingValue("Display", "bEnableProjecteUVDiffuseNormals", Prefs, "1")
				GuiControl, Main:, bEnableProjecteUVDiffuseNormals, %bEnableProjecteUVDiffuseNormals%
				bDisableShadowJumps := Abs(getSettingValue("Display", "bDisableShadowJumps", blank, "1") - 1)
				GuiControl, Main:, bDisableShadowJumps, %bDisableShadowJumps%
				fGlobalBrightnessBoost := Round(getSettingValue("Display", "fGlobalBrightnessBoost", blank, "0"),4)*1000
				fGlobalBrightnessBoostReal := Round(getSettingValue("Display", "fGlobalBrightnessBoost", blank, "0"),4)
				GuiControl, Main:, fGlobalBrightnessBoost, %fGlobalBrightnessBoost%
				GuiControl, Main:, fGlobalBrightnessBoostReal, %fGlobalBrightnessBoostReal%
				fGlobalContrastBoost := Round(getSettingValue("Display", "fGlobalContrastBoost", blank, "0"),4)*1000
				fGlobalContrastBoostReal := Round(getSettingValue("Display", "fGlobalContrastBoost", blank, "0"),4)
				GuiControl, Main:, fGlobalContrastBoost, %fGlobalContrastBoost%
				GuiControl, Main:, fGlobalContrastBoostReal, %fGlobalContrastBoostReal%
				fGlobalSaturationBoost := Round(getSettingValue("Display", "fGlobalSaturationBoost", blank, "0"),4)*1000
				fGlobalSaturationBoostReal := Round(getSettingValue("Display", "fGlobalSaturationBoost", blank, "0"),4)
				GuiControl, Main:, fGlobalSaturationBoost, %fGlobalSaturationBoost%
				GuiControl, Main:, fGlobalSaturationBoostReal, %fGlobalSaturationBoostReal%
				bModManagerMenuEnabled := getSettingValue("General", "bModManagerMenuEnabled", blank, "1")
				GuiControl, Main:, bModManagerMenuEnabled, %bModManagerMenuEnabled%
				fSnowRimLightIntensity := Round(getSettingValue("Display", "fSnowRimLightIntensity", blank, "0.3"),2)
				GuiControl, Main:, fSnowRimLightIntensity, %fSnowRimLightIntensity%
				fSnowGeometrySpecPower := Round(getSettingValue("Display", "fSnowGeometrySpecPower", blank, "3"),2)
				GuiControl, Main:, fSnowGeometrySpecPower, %fSnowGeometrySpecPower%
				fSnowNormalSpecPower := Round(getSettingValue("Display", "fSnowNormalSpecPower", blank, "2"),2)
				GuiControl, Main:, fSnowNormalSpecPower, %fSnowNormalSpecPower%
				fSparklesDensity := Round(getSettingValue("Display", "fSparklesDensity", blank, "0.85"),2)
				GuiControl, Main:, fSparklesDensity, %fSparklesDensity%
				fSparklesSize := Round(getSettingValue("Display", "fSparklesSize", blank, "6"),2)
				GuiControl, Main:, fSparklesSize, %fSparklesSize%
				bSAOEnable := getSettingValue("Display", "bSAOEnable", Prefs, "1")
				GuiControl, Main:, bSAOEnable, %bSAOEnable%
				bDeactivateAOOnSnow := abs(getSettingValue("Display", "bDeactivateAOOnSnow", blank, "1")-1)
				GuiControl, Main:, bDeactivateAOOnSnow, %bDeactivateAOOnSnow%
				bEnableSnowMask := getSettingValue("Display", "bEnableSnowMask", blank, "1")
				GuiControl, Main:, bEnableSnowMask, %bEnableSnowMask%	
				bUse64bitsHDRRenderTarget := getSettingValue("Display", "bUse64bitsHDRRenderTarget", Prefs, "1")
				GuiControl, Main:, bUse64bitsHDRRenderTarget, %bUse64bitsHDRRenderTarget%
				bScreenSpaceReflectionEnabled := getSettingValue("Display", "bScreenSpaceReflectionEnabled", Prefs, "1")
				GuiControl, Main:, bScreenSpaceReflectionEnabled, %bScreenSpaceReflectionEnabled%
				iReflectionResolutionDivider := getSettingValue("Display", "iReflectionResolutionDivider", Prefs, "2")
				GuiControl, Main:, iReflectionResolutionDivider, %iReflectionResolutionDivider%
			}
		if gameName = Fallout 4
			{
				if (getSettingValue("General", "fChancesToPlayAlternateIntro", blank, "0.2") = 0) and (getSettingValue("General", "uMainMenuDelayBeforeAllowSkip", blank, "5000") != 5000)
					SPECIAL = 0
				else
					SPECIAL = 1
				GuiControl, Main:, SPECIAL, %SPECIAL%
				bMaximizeWindow := getSettingValue("Display", "bMaximizeWindow", Prefs, "0")
				GuiControl, Main:, bMaximizeWindow, %bMaximizeWindow%
				bTopMostWindow := getSettingValue("Display", "bTopMostWindow", Prefs, "0")
				GuiControl, Main:, bTopMostWindow, %bTopMostWindow%
				if (getSettingValue("Archive", "bInvalidateOlderFiles", blank, "0") = 1) and (getSettingValue("Archive", "sResourceDataDirsFinal", blank, "STRINGS\") = blank)
					bInvalidateOlderFiles = 1
				else
					bInvalidateOlderFiles = 0
				GuiControl, Main:, bInvalidateOlderFiles, %bInvalidateOlderFiles%
				bVolumetricLightingEnable := getSettingValue("Display", "bVolumetricLightingEnable", Prefs, "1")
				GuiControl, Main:, bVolumetricLightingEnable, %bVolumetricLightingEnable%
				bScreenSpaceBokeh := getSettingValue("Imagespace", "bScreenSpaceBokeh", Prefs, "1")
				GuiControl, Main:, bScreenSpaceBokeh, %bScreenSpaceBokeh%
				bAutoSizeQuickContainer := getSettingValue("Interface", "bAutoSizeQuickContainer", blank, "0")
				GuiControl, Main:, bAutoSizeQuickContainer, %bAutoSizeQuickContainer%
				bEnableWetnessMaterials := getSettingValue("Display", "bEnableWetnessMaterials", Prefs, "1")
				GuiControl, Main:, bEnableWetnessMaterials, %bEnableWetnessMaterials%
				bMBEnable := getSettingValue("Imagespace", "bMBEnable", Prefs, "1")
				GuiControl, Main:, bMBEnable, %bMBEnable%
				iConsoleSelectedRefColor := getSettingValue("Menu", "iConsoleSelectedRefColor", blank, "0x00000000")
				if iConsoleSelectedRefColor = 0
					iConsoleSelectedRefColor = 0x00000000
				GuiControl, Main:, iConsoleSelectedRefColorText, %iConsoleSelectedRefColor%
				if (SubStr(iConsoleSelectedRefColor, 3, 2) = "00")
					iConsoleSelectedRefColorProgress := "FFFFFF"
				else
					iConsoleSelectedRefColorProgress := SubStr(iConsoleSelectedRefColor, 9, 2) . SubStr(iConsoleSelectedRefColor, 7, 2) . SubStr(iConsoleSelectedRefColor, 5, 2)
				GuiControl, Main:+Background%iConsoleSelectedRefColorProgress%, iConsoleSelectedRefColorProgress
				fPAEffectColor := Round(255*getSettingValue("Pipboy", "fPAEffectColorR", blank, "1"),0),Round(255*getSettingValue("Pipboy", "fPAEffectColorG", blank, "0.82"),0),Round(255*getSettingValue("Pipboy", "fPAEffectColorB", blank, "0.41"),0)
				fPAEffectColorArray := StrSplit(fPAEffectColor,",")
				fPAEffectColorProgress := Format("{1:02x}{2:02x}{3:02x}", fPAEffectColorArray[1], fPAEffectColorArray[2], fPAEffectColorArray[3])
				GuiControl, Main:+Background%fPAEffectColorProgress%, fPAEffectColorProgress
				fPAEffectColorText := Round(fPAEffectColorArray[1]/255,2) . "," . Round(fPAEffectColorArray[2]/255,2) . "," . Round(fPAEffectColorArray[3]/255,2)
				GuiControl, Main:, fPAEffectColorText, %fPAEffectColorText%
				fPipboyEffectColor := Round(255*getSettingValue("Pipboy", "fPipboyEffectColorR", Prefs, "0.08"),0) . "," . Round(255*getSettingValue("Pipboy", "fPipboyEffectColorG", Prefs, "1"),0) . "," . Round(255*getSettingValue("Pipboy", "fPipboyEffectColorB", Prefs, "0.09"),0)
				fPipboyEffectColorArray := StrSplit(fPipboyEffectColor,",")
				fPipboyEffectColorProgress := Format("{1:02x}{2:02x}{3:02x}", fPipboyEffectColorArray[1], fPipboyEffectColorArray[2], fPipboyEffectColorArray[3])
				GuiControl, Main:+Background%fPipboyEffectColorProgress%, fPipboyEffectColorProgress
				fPipboyEffectColorText := Round(fPipboyEffectColorArray[1]/255,3) . "," . Round(fPipboyEffectColorArray[2]/255,3) . "," . Round(fPipboyEffectColorArray[3]/255,3)
				GuiControl, Main:, fPipboyEffectColorText, %fPipboyEffectColorText%
				iHUDColor := getSettingValue("Interface", "iHUDColorR", Prefs, "18") . "," . getSettingValue("Interface", "iHUDColorG", Prefs, "255") . "," . getSettingValue("Interface", "iHUDColorB", Prefs, "21")
				iHUDColorArray := StrSplit(iHUDColor,",")
				iHUDColorProgress := Format("{1:02x}{2:02x}{3:02x}", iHUDColorArray[1], iHUDColorArray[2], iHUDColorArray[3])
				GuiControl, Main:+Background%iHUDColorProgress%, iHUDColorProgress
				GuiControl, Main:, iHUDColorText, %iHUDColor%
				fVatsLightColor := Round(255*getSettingValue("VATS", "fVatsLightColorR", blank, "0.7"),0) . "," . Round(255*getSettingValue("VATS", "fVatsLightColorG", blank, "0.7"),0) . "," . Round(255*getSettingValue("VATS", "fVatsLightColorB", blank, "0.7"),0)
				fVatsLightColorArray := StrSplit(fVatsLightColor,",")
				fVatsLightColorProgress := Format("{1:02x}{2:02x}{3:02x}", fVatsLightColorArray[1], fVatsLightColorArray[2], fVatsLightColorArray[3])
				GuiControl, Main:+Background%fVatsLightColorProgress%, fVatsLightColorProgress
				fVatsLightColorText := Round(fVatsLightColorArray[1]/255,3) . "," . Round(fVatsLightColorArray[2]/255,3) . "," . Round(fVatsLightColorArray[3]/255,3)
				GuiControl, Main:, fVatsLightColorText, %fVatsLightColorText%
				/*
				fModMenuEffectColor := Round(255*getSettingValue("VATS", "fModMenuEffectColorR", Prefs, "0.49"),0) . "," . Round(255*getSettingValue("VATS", "fModMenuEffectColorG", Prefs, "0.99"),0) . "," . Round(255*getSettingValue("VATS", "fModMenuEffectColorB", Prefs, "0.42"),0)
				fModMenuEffectColorArray := StrSplit(fModMenuEffectColor,",")
				fModMenuEffectColorProgress := Format("{1:02x}{2:02x}{3:02x}", fModMenuEffectColorArray[1], fModMenuEffectColorArray[2], fModMenuEffectColorArray[3])
				GuiControl, Main:+Background%fModMenuEffectColorProgress%, fModMenuEffectColorProgress
				fModMenuEffectColorText := Round(fModMenuEffectColorArray[1]/255,3) . "," . Round(fModMenuEffectColorArray[2]/255,3) . "," . Round(fModMenuEffectColorArray[3]/255,3)
				GuiControl, Main:, fModMenuEffectColorText, %fModMenuEffectColorText%
				*/
				fModMenuEffectHighlightColor := Round(255*getSettingValue("VATS", "fModMenuEffectHighlightColorR", Prefs, "0.0706"),0) . "," . Round(255*getSettingValue("VATS", "fModMenuEffectHighlightColorG", Prefs, "1"),0) . "," . Round(255*getSettingValue("VATS", "fModMenuEffectHighlightColorB", Prefs, "0.0824"),0)
				fModMenuEffectHighlightColorArray := StrSplit(fModMenuEffectHighlightColor,",")
				fModMenuEffectHighlightColorProgress := Format("{1:02x}{2:02x}{3:02x}", fModMenuEffectHighlightColorArray[1], fModMenuEffectHighlightColorArray[2], fModMenuEffectHighlightColorArray[3])
				GuiControl, Main:+Background%fModMenuEffectHighlightColorProgress%, fModMenuEffectHighlightColorProgress
				fModMenuEffectHighlightColorText := Round(fModMenuEffectHighlightColorArray[1]/255,3) . "," . Round(fModMenuEffectHighlightColorArray[2]/255,3) . "," . Round(fModMenuEffectHighlightColorArray[3]/255,3)
				GuiControl, Main:, fModMenuEffectHighlightColorText, %fModMenuEffectHighlightColorText%
				fModMenuEffectHighlightPAColor := Round(255*getSettingValue("VATS", "fModMenuEffectHighlightPAColorR", Prefs, "1"),0) . "," . Round(255*getSettingValue("VATS", "fModMenuEffectHighlightPAColorG", Prefs, "0.82"),0) . "," . Round(255*getSettingValue("VATS", "fModMenuEffectHighlightPAColorB", Prefs, "0.41"),0)
				fModMenuEffectHighlightPAColorArray := StrSplit(fModMenuEffectHighlightPAColor,",")
				fModMenuEffectHighlightPAColorProgress := Format("{1:02x}{2:02x}{3:02x}", fModMenuEffectHighlightPAColorArray[1], fModMenuEffectHighlightPAColorArray[2], fModMenuEffectHighlightPAColorArray[3])
				GuiControl, Main:+Background%fModMenuEffectHighlightPAColorProgress%, fModMenuEffectHighlightPAColorProgress
				fModMenuEffectHighlightPAColorText := Round(fModMenuEffectHighlightPAColorArray[1]/255,3) . "," . Round(fModMenuEffectHighlightPAColorArray[2]/255,3) . "," . Round(fModMenuEffectHighlightPAColorArray[3]/255,3)
				GuiControl, Main:, fModMenuEffectHighlightPAColorText, %fModMenuEffectHighlightPAColorText%
				iHUDColorWarning := getSettingValue("Interface", "iHUDColorWarningR", blank, "238") . "," . getSettingValue("Interface", "iHUDColorWarningG", blank, "86") . "," . getSettingValue("Interface", "iHUDColorWarningB", blank, "55")
				iHUDColorWarningArray := StrSplit(iHUDColorWarning,",")
				iHUDColorWarningProgress := Format("{1:02x}{2:02x}{3:02x}", iHUDColorWarningArray[1], iHUDColorWarningArray[2], iHUDColorWarningArray[3])
				GuiControl, Main:+Background%iHUDColorWarningProgress%, iHUDColorWarningProgress
				GuiControl, Main:, iHUDColorWarningText, %iHUDColorWarning%
				/*
				iHUDColorAltWarning := getSettingValue("Interface", "iHUDColorAltWarningR", blank, "238") . "," . getSettingValue("Interface", "iHUDColorAltWarningG", blank, "86") . "," . getSettingValue("Interface", "iHUDColorAltWarningB", blank, "55")
				iHUDColorAltWarningArray := StrSplit(iHUDColorAltWarning,",")
				iHUDColorAltWarningProgress := Format("{1:02x}{2:02x}{3:02x}", iHUDColorAltWarningArray[1], iHUDColorAltWarningArray[2], iHUDColorAltWarningArray[3])
				GuiControl, Main:+Background%iHUDColorAltWarningProgress%, iHUDColorAltWarningProgress
				GuiControl, Main:, iHUDColorAltWarningText, %iHUDColorAltWarning%
				*/
				fWireConnectEffectColor := Round(255*getSettingValue("VATS", "fWireConnectEffectColorR", blank, "0.8"),0) . "," . Round(255*getSettingValue("VATS", "fWireConnectEffectColorG", blank, "0.8"),0) . "," . Round(255*getSettingValue("VATS", "fWireConnectEffectColorB", blank, "0.9"),0)
				fWireConnectEffectColorArray := StrSplit(fWireConnectEffectColor,",")
				fWireConnectEffectColorProgress := Format("{1:02x}{2:02x}{3:02x}", fWireConnectEffectColorArray[1], fWireConnectEffectColorArray[2], fWireConnectEffectColorArray[3])
				GuiControl, Main:+Background%fWireConnectEffectColorProgress%, fWireConnectEffectColorProgress
				fWireConnectEffectColorText := Round(fWireConnectEffectColorArray[1]/255,3) . "," . Round(fWireConnectEffectColorArray[2]/255,3) . "," . Round(fWireConnectEffectColorArray[3]/255,3)
				GuiControl, Main:, fWireConnectEffectColorText, %fWireConnectEffectColorText%
				if getSettingValue("Display", "bSAOEnable", Prefs, "1") = 0
					AmbientOcclusion = None||SSAO|HBAO+
				else if getSettingValue("NVHBAO", "bEnable", Prefs, "0") =0
					AmbientOcclusion = None|SSAO||HBAO+
				else
					AmbientOcclusion = None|SSAO|HBAO+||
				GuiControl, Main:, AmbientOcclusion, |%AmbientOcclusion%
			}
		if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			{
				bForceHighDetailReflections := getSettingValue("Water", "bForceHighDetailReflections", Prefs, "0")
				GuiControl, Main:, bForceHighDetailReflections, %bForceHighDetailReflections%
				bAutoWaterSilhouetteReflections := getSettingValue("Water", "bAutoWaterSilhouetteReflections", Prefs, "1") + getSettingValue("Water", "bForceLowDetailReflections", blank, "0")
				if bAutoWaterSilhouetteReflections = 0
					bAutoWaterSilhouetteReflections = 1
				else
					bAutoWaterSilhouetteReflections = 0
				GuiControl, Main:, bAutoWaterSilhouetteReflections, %bAutoWaterSilhouetteReflections%
				if getSettingValue("Water", "bUseWaterReflectionBlur", Prefs, "0") = 1
					iWaterBlurAmount := sortNumberedList("0|1|2|3|4", getSettingValue("Water", "iWaterBlurAmount", Prefs, "1"))
				else
					iWaterBlurAmount := sortNumberedList("0|1|2|3|4", 0)
				GuiControl, Main:, iWaterBlurAmount, |%iWaterBlurAmount%
				uHUDColor := getSettingValue("Interface", "uHUDColor", Prefs, "4290134783")
				uHUDColorProgress := SubStr(Format("{1:02X}", uHUDColor),1,6)
				GuiControl, Main:+Background%uHUDColorProgress%, uHUDColorProgress
				uHUDColorText := uHUDColor
				GuiControl, Main:, uHUDColorText, %uHUDColorText%
				uPipboyColor := getSettingValue("Interface", "uPipboyColor", Prefs, "4290134783")
				uPipboyColorProgress := SubStr(Format("{1:02X}", uPipboyColor),1,6)
				GuiControl, Main:+Background%uPipboyColorProgress%, uPipboyColorProgress
				uPipboyColorText := uPipboyColor
				GuiControl, Main:, uPipboyColorText, %uPipboyColorText%
			}
		if (gameName = "Fallout 4" or gameName = "Skyrim")
			{
				DisableTutorials := Abs(getSettingValue("Interface", "bShowTutorials", blank, "1") - 1)
				GuiControl, Main:, DisableTutorials, %DisableTutorials%
			}
		if (gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
			{
				bBorderless := getSettingValue("Display", "bBorderless", Prefs, "0")
				GuiControl, Main:, bBorderless, %bBorderless%
				bLensFlare := getSettingValue("Imagespace", "bLensFlare", Prefs, "1")
				GuiControl, Main:, bLensFlare, %bLensFlare%
				
				bEnablePlatform := getSettingValue("Bethesda.net", "bEnablePlatform", blank, "1")
				GuiControl, Main:, bEnablePlatform, %bEnablePlatform%
			}
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			{
				bFXAAEnabled := getSettingValue("Display", "bFXAAEnabled", Prefs, "0")
				GuiControl, Main:, FXAA, %bFXAAEnabled%
				f1PArrowTiltUpAngle := getSettingValue("Combat", "f1PArrowTiltUpAngle", blank, "2")
				GuiControl, Main:, f1PArrowTiltUpAngle, %f1PArrowTiltUpAngle%
				f3PArrowTiltUpAngle := getSettingValue("Combat", "f3PArrowTiltUpAngle", blank, "2.5")
				GuiControl, Main:, f3PArrowTiltUpAngle, %f3PArrowTiltUpAngle%
				f1PBoltTiltUpAngle := getSettingValue("Combat", "f1PBoltTiltUpAngle", blank, "1")
				GuiControl, Main:, f1PBoltTiltUpAngle, %f1PBoltTiltUpAngle%
				FixMapMenuNavigation := getFixMapMenuNavigation(Round(getSettingValue("MapMenu", "fMapWorldYawRange", blank, "80"),0), Round(getSettingValue("MapMenu", "fMapWorldMinPitch", blank, "15"),0), Round(getSettingValue("MapMenu", "fMapWorldMaxPitch", blank, "75"),0))
				GuiControl, Main:, FixMapMenuNavigation, %FixMapMenuNavigation%
				RemoveMapMenuBlur := getRemoveMapMenuBlur(getSettingValue("MapMenu", "bWorldMapNoSkyDepthBlur", blank, "0"), getSettingValue("MapMenu", "fWorldMapDepthBlurScale", blank, "0.3000000119"), getSettingValue("MapMenu", "fWorldMapMaximumDepthBlur", blank, "0.4499999881"), getSettingValue("MapMenu", "fWorldMapNearDepthBlurScale", blank, "4"))
				GuiControl, Main:, RemoveMapMenuBlur, %RemoveMapMenuBlur%
				MouseCursorSpeed := Round(getSettingValue("Interface", "fMouseCursorSpeed", Prefs, "1"),2) * 10
				MouseCursorSpeedReal := Round(getSettingValue("Interface", "fMouseCursorSpeed", Prefs, "1"),2)
				GuiControl, Main:, MouseCursorSpeed, %MouseCursorSpeed%
				GuiControl, Main:, MouseCursorSpeedReal, %MouseCursorSpeedReal%
				WaterReflectLand := getSettingValue("Water", "bReflectLODLand", blank, "1")
				GuiControl, Main:, WaterReflectLand, %WaterReflectLand%
				WaterReflectObjects := getSettingValue("Water", "bReflectLODObjects", blank, "0")
				GuiControl, Main:, WaterReflectObjects, %WaterReflectObjects%
				WaterReflectSky := getSettingValue("Water", "bReflectSky", blank, "0")
				GuiControl, Main:, WaterReflectSky, %WaterReflectSky%
				ShadowLand := getSettingValue("Display", "bDrawLandShadows", Prefs, "0")
				GuiControl, Main:, ShadowLand, %ShadowLand%
				ShadowTrees := getSettingValue("Display", "bTreesReceiveShadows", Prefs, "0")
				GuiControl, Main:, ShadowTrees, %ShadowTrees%
				DynamicTrees := getDynamicTrees(getSettingValue("Trees", "bEnableTrees", blank, "1"), getSettingValue("Trees", "bEnableTreeAnimations", blank, "1"))
				GuiControl, Main:, DynamicTrees, %DynamicTrees%
				SkinnedTrees := getSettingValue("Trees", "bRenderSkinnedTrees", Prefs, "1")
				GuiControl, Main:, SkinnedTrees, %SkinnedTrees%
				TreeAnimations := Round(getSettingValue("Trees", "fUpdateBudget", blank, "1.5"),1)
				if TreeAnimations > 0
					TreeAnimations = 1
				else
					TreeAnimations = 0
				GuiControl, Main:, TreeAnimations, %TreeAnimations%
				TreeDetailFade := getTreeDetailFade(Round(getSettingValue("Display", "fMeshLODLevel1FadeTreeDistance", Prefs, "2844"),0), Round(getSettingValue("Display", "fMeshLODLevel2FadeTreeDistance", Prefs, "2048"),0), Round(getSettingValue("Display", "fTreesMidLODSwitchDist", Prefs, "3600"),0), Round(getSettingValue("Trees", "uiMaxSkinnedTreesToRender", Prefs, "40"),0))
				GuiControl, Main:, TreeDetailFade, |%TreeDetailFade%
				iSubtitleSpeakerNameColor := getSettingValue("Interface", "iSubtitleSpeakerNameColor", blank, "8947848")
				iSubtitleSpeakerNameColorProgress := Format("{1:02X}", iSubtitleSpeakerNameColor)
				GuiControl, Main:+Background%iSubtitleSpeakerNameColorProgress%, iSubtitleSpeakerNameColorProgress
				iSubtitleSpeakerNameColorText := iSubtitleSpeakerNameColor
				GuiControl, Main:, iSubtitleSpeakerNameColorText, %iSubtitleSpeakerNameColorText%
			}
		if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			{
				if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
					WaterReflectTrees := getSettingValue("Water", "bReflectLODTrees", blank, "0")
				else
					WaterReflectTrees := getSettingValue("Water", "bUseWaterReflectionsTrees", blank, "0")
				GuiControl, Main:, WaterReflectTrees, %WaterReflectTrees%
			}
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			{
				if gameName = Skyrim
					FadeMesh := getObjectDetailFade(Round(getSettingValue("Display", "fMeshLODLevel1FadeDist", Prefs, "4096"),0), Round(getSettingValue("Display", "fMeshLODLevel2FadeDist", Prefs, "3072"),0))
				else if gameName = Skyrim Special Edition
					FadeMesh := getObjectDetailFade(Round(getSettingValue("Display", "fMeshLODLevel1FadeDist", Prefs, "9999999"),0), Round(getSettingValue("Display", "fMeshLODLevel2FadeDist", Prefs, "9999999"),0))
				else if gameName = Fallout 4
					FadeMesh := getObjectDetailFade(Round(getSettingValue("Display", "fMeshLODLevel1FadeDist", Prefs, "3500"),0), Round(getSettingValue("Display", "fMeshLODLevel2FadeDist", Prefs, "2000"),0))
				GuiControl, Main:, FadeMesh, |%FadeMesh%
				fSunShadowUpdateTime := getSettingValue("Display", "fSunShadowUpdateTime", blank, "1")
				GuiControl, Main:, fSunShadowUpdateTime, %fSunShadowUpdateTime%
				fSunUpdateThreshold := getSettingValue("Display", "fSunUpdateThreshold", blank, "0.5")
				GuiControl, Main:, fSunUpdateThreshold, %fSunUpdateThreshold%
				if gameName = Skyrim
					ShadowExDist := sortNumberedList("1500|2000|2800|3500|4000|5000|6000|8000", Round(getSettingValue("Display", "fShadowDistance", Prefs, "2500"),0))
				else if gameName = Skyrim Special Edition
					ShadowExDist := sortNumberedList("2000|2800|4000|6000|8000|10000", Round(getSettingValue("Display", "fShadowDistance", Prefs, "8000"),0))
				else if gameName = Fallout 4
					ShadowExDist := sortNumberedList("3000|5000|8000|14000|18000|20000", Round(getSettingValue("Display", "fDirShadowDistance", Prefs, "3000"),0))
				GuiControl, Main:, ShadowExDist, |%ShadowExDist%
				fEncumberedReminderTimer := sortNumberedList("30|60|300|3600", Round(getSettingValue("General", "fEncumberedReminderTimer", blank, "30"),0))
				GuiControl, Main:, fEncumberedReminderTimer, |%fEncumberedReminderTimer%
				DecalFade := getDecalFade(Round(getSettingValue("LightingShader", "fDecalLODFadeStart", blank, "0.05"), 4), Round(getSettingValue("LightingShader", "fDecalLODFadeEnd", blank, "0.06"),4))
				GuiControl, Main:, DecalFade, |%DecalFade%
				ModdersParadiseMode := getSettingValue("Display", "bShowMarkers", blank, "0")
				GuiControl, Main:, ModdersParadiseMode, %ModdersParadiseMode%
				iAutoSaveCount := getSettingValue("SaveGame", "iAutoSaveCount", blank, "3")
				GuiControl, Main:, iAutoSaveCount, %iAutoSaveCount%
				iMaxDesired := sortNumberedList("250|750|1500|3000|4500|6000|8000|10000", getSettingValue("Particles", "iMaxDesired", Prefs, "750"))
				GuiControl, Main:, iMaxDesired, |%iMaxDesired%
				ShowCompass := getSettingValue("Interface", "bShowCompass", Prefs, "1")
				GuiControl, Main:, ShowCompass, %ShowCompass%
				FlickeringLightDistance := sortNumberedList("0|1024|2048|4096|8192", Round(getSettingValue("General", "fFlickeringLightDistance", blank, "1024"),0))
				GuiControl, Main:, FlickeringLightDistance, |%FlickeringLightDistance%
				EnableLogging := getSettingValue("Papyrus", "bEnableLogging", blank, "0")
				GuiControl, Main:, EnableLogging, %EnableLogging%
				EnableTrace := getSettingValue("Papyrus", "bEnableTrace", blank, "0")
				GuiControl, Main:, EnableTrace, %EnableTrace%
				LoadDebugInformation := getSettingValue("Papyrus", "bLoadDebugInformation", blank, "0")
				GuiControl, Main:, LoadDebugInformation, %LoadDebugInformation%
				if gameName = Fallout 4
					PostLoadUpdateTimeMS := sortNumberedList("500|2000", Round(getSettingValue("Papyrus", "fPostLoadUpdateTimeMS", blank, "500"),0))
				else
					PostLoadUpdateTimeMS := sortNumberedList("500|2000", Round(getSettingValue("Papyrus", "fPostLoadUpdateTimeMS", blank, "2000"),0))
				GuiControl, Main:, PostLoadUpdateTimeMS, |%PostLoadUpdateTimeMS%
				EnableProfiling := getSettingValue("Papyrus", "bEnableProfiling", blank, "0")
				GuiControl, Main:, EnableProfiling, %EnableProfiling%
				if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
					bBackgroundLoadVMData := getSettingValue("General", "bBackgroundLoadVMData", blank, "0")
				else if gameName = Fallout 4
					bBackgroundLoadVMData := getSettingValue("General", "bBackgroundLoadVMData", blank, "1")
				GuiControl, Main:, bBackgroundLoadVMData, %bBackgroundLoadVMData%
				if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
					MouseHeadingXScale := Round(getSettingValue("Controls", "fMouseHeadingXScale", blank, "0.0199999996"),4)
				else
					MouseHeadingXScale := Round(getSettingValue("Controls", "fMouseHeadingXScale", blank, "0.021"),4)
				GuiControl, Main:, MouseHeadingXScale, %MouseHeadingXScale%
				if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
					MouseHeadingYScale := Round(getSettingValue("Controls", "fMouseHeadingYScale", blank, "0.8500000238"),4)
				else
					MouseHeadingYScale := Round(getSettingValue("Controls", "fMouseHeadingYScale", blank, "0.021"),4)
				GuiControl, Main:, MouseHeadingYScale, %MouseHeadingYScale%
				if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
					MouseZoomSpeed := Round(getSettingValue("Camera", "fMouseWheelZoomSpeed", blank, "0.8000000119"),2)
				else if gameName = Fallout 4
					MouseZoomSpeed := Round(getSettingValue("Camera", "fMouseWheelZoomSpeed", blank, "3"),2)
				GuiControl, Main:, MouseZoomSpeed, %MouseZoomSpeed%
				iConsoleTextSize := getSettingValue("Menu", "iConsoleTextSize", blank, "20")
				GuiControl, Main:, iConsoleTextSize, %iConsoleTextSize%
				iConsoleSizeScreenPercent := getSettingValue("Menu", "iConsoleSizeScreenPercent", blank, "40")
				GuiControl, Main:, iConsoleSizeScreenPercent, %iConsoleSizeScreenPercent%
				rConsoleTextColor := getSettingValue("Menu", "rConsoleTextColor", blank, "255,255,255")
				rConsoleTextColorArray := StrSplit(rConsoleTextColor,",")
				rConsoleTextColorProgress := Format("{1:02x}{2:02x}{3:02x}", rConsoleTextColorArray[1], rConsoleTextColorArray[2], rConsoleTextColorArray[3])
				GuiControl, Main:+Background%rConsoleTextColorProgress%, rConsoleTextColorProgress
				GuiControl, Main:, rConsoleTextColorText, %rConsoleTextColor%
				rConsoleHistoryTextColor := getSettingValue("Menu", "rConsoleHistoryTextColor", blank, "153,153,153")
				rConsoleHistoryTextColorArray := StrSplit(rConsoleHistoryTextColor,",")
				rConsoleHistoryTextColorProgress := Format("{1:02x}{2:02x}{3:02x}", rConsoleHistoryTextColorArray[1], rConsoleHistoryTextColorArray[2], rConsoleHistoryTextColorArray[3])
				GuiControl, Main:+Background%rConsoleHistoryTextColorProgress%, rConsoleHistoryTextColorProgress
				GuiControl, Main:, rConsoleHistoryTextColorText, %rConsoleHistoryTextColor%
			}
		if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Oblivion")
			{
				bUseBlurShader := getLightingEffect(getSettingValue("BlurShader", "bUseBlurShader", Prefs, "1"), getSettingValue("BlurShaderHDR", "bDoHighDynamicRange", Prefs, "1"))
				GuiControl, Main:, bUseBlurShader, |%bUseBlurShader%
				fMaxFootstepDistance := sortNumberedList("512|1024|2048|3072|4096", Round(getSettingValue("Audio", "fMaxFootstepDistance", blank, "1100"),0))
				GuiControl, Main:, fMaxFootstepDistance, |%fMaxFootstepDistance%
				bAllowConsole := getSettingValue("Interface", "bAllowConsole", blank, "1")
				GuiControl, Main:, bAllowConsole, %bAllowConsole%
				iConsoleVisibleLines := getSettingValue("Menu", "iConsoleVisibleLines", blank, "15")
				GuiControl, Main:, iConsoleVisibleLines, %iConsoleVisibleLines%
				fPlayerFootVolume := Round(getSettingValue("Audio", "fPlayerFootVolume", blank, "0.9"),2) * 100
				fPlayerFootVolumeReal := Round(getSettingValue("Audio", "fPlayerFootVolume", blank, "0.9"),2)
				GuiControl, Main:, fPlayerFootVolume, %fPlayerFootVolume%
				GuiControl, Main:, fPlayerFootVolumeReal, %fPlayerFootVolumeReal%
				bUseJoystick := getSettingValue("Controls", "bUse Joystick", blank, "1")
				GuiControl, Main:, bUseJoystick, %bUseJoystick%
				bAllow30Shaders := getSettingValue("Display", "bAllow30Shaders", blank, "0")
				GuiControl, Main:, bAllow30Shaders, %bAllow30Shaders%
				iActorShadowCountInt := Round(getSettingValue("Display", "iActorShadowCountInt", Prefs, "4"),0)
				GuiControl, Main:, iActorShadowCountInt, %iActorShadowCountInt%
				GuiControl, Main:, iActorShadowCountIntReal, %iActorShadowCountInt%
				iActorShadowCountExt := Round(getSettingValue("Display", "iActorShadowCountExt", Prefs, "2"),0)
				GuiControl, Main:, iActorShadowCountExt, %iActorShadowCountExt%
				GuiControl, Main:, iActorShadowCountExtReal, %iActorShadowCountExt%
				fShadowFadeTime := Round(getSettingValue("Display", "fShadowFadeTime", blank, "1.0000"), 2)
				GuiControl, Main:, fShadowFadeTime, %fShadowFadeTime%
				bUseEyeEnvMapping := getSettingValue("General", "bUseEyeEnvMapping", blank, "1")
				GuiControl, Main:, bUseEyeEnvMapping, %bUseEyeEnvMapping%
			}
		if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim")
			{
				bTransparencyMultisampling := getSettingValue("Display", "bTransparencyMultisampling", Prefs, "0")
				GuiControl, Main:, bTransparencyMultisampling, %bTransparencyMultisampling%
				WaterReflectRes := sortNumberedList("128|256|512|1024|2048", getSettingValue("Water", "iWaterReflectHeight", Prefs, "512"))
				GuiControl, Main:, WaterReflectRes, |%WaterReflectRes%
				bUseWaterDisplacements := getSettingValue("Water", "bUseWaterDisplacements", Prefs, "1")
				GuiControl, Main:, bUseWaterDisplacements, %bUseWaterDisplacements%
			}
		;	!= Skyrim or Skyrim Special Edition
		if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			{
				if gameName = Fallout 4
					iShadowFilter := sortNumberedList("0|1|2|3", Round(getSettingValue("Display", "uiOrthoShadowFilter", Prefs, "3"),0))
				else
					iShadowFilter := sortNumberedList("0|1|2|3", Round(getSettingValue("Display", "iShadowFilter", Prefs, "0"),0))
				GuiControl, Main:, iShadowFilter, |%iShadowFilter%
			}
		;	!= Fallout 4 or Oblivion
		if (gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			{
				FarOffTreeDistance := sortNumberedList("12500|25000|40000|75000", Round(getSettingValue("TerrainManager", "fTreeLoadDistance", Prefs, "25000"),0))
				GuiControl, Main:, FarOffTreeDistance, |%FarOffTreeDistance%
			}
		;	!= Fallout 4 or Skyrim Special Edition
		if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			{
				SysGet, adapterCount, MonitorCount
				SysGet, iAdapter, MonitorPrimary
				iAdapter := iAdapter - 1
				adapters := adapters(adapterCount, iAdapter)
				GuiControl, Main:, iAdapter, |%adapters%
				iTexMipMapSkip := getTextureQuality(getSettingValue("Display", "iTexMipMapSkip", Prefs, "0"), getSettingValue("Display", "iTexMipMapMinimum", Prefs, "0"))
				GuiControl, Main:, iTexMipMapSkip, |%iTexMipMapSkip%
				if gameName = Skyrim
					ShadowGrass := getSettingValue("Display", "bShadowsOnGrass", Prefs, "1")
				else
					ShadowGrass := getSettingValue("Display", "bShadowsOnGrass", blank, "0")
				GuiControl, Main:, ShadowGrass, %ShadowGrass%
			}
		;	!= Oblivion or Skyrim Special Edition
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			{
				Anisotropic := getAnisotropy()
				GuiControl, Main:, Anisotropic, |%Anisotropic%
				bEnableFileSelection := getSettingValue("Launcher", "bEnableFileSelection", Prefs, "0")
				GuiControl, Main:, bEnableFileSelection, %bEnableFileSelection%
			}
		; != Fallout 3
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Skyrim Special Edition" or gameName = "Fallout New Vegas" or gameName = "Oblivion") 
			{
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
		;	!= Oblivion
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
			{
				bAlwaysActive := getSettingValue("General", "bAlwaysActive", blank, "0")
				GuiControl, Main:, bAlwaysActive, %bAlwaysActive%
				if (gameName = "Skyrim" or gameName = "Fallout 4" or gameName = "Skyrim Special Edition")
					AlwaysRunbyDefault := getSettingValue("Controls", "bAlwaysRunByDefault", Prefs, "1")
				else if gameName = Fallout 3
					AlwaysRunbyDefault := getSettingValue("Controls", "bAlwaysRunByDefault", blank, "0")
				else if gameName = Fallout New Vegas
					AlwaysRunbyDefault := getSettingValue("Controls", "bAlwaysRunByDefault", blank, "0")
				GuiControl, Main:, AlwaysRunbyDefault, %AlwaysRunbyDefault%
				ShowQuestMarkers := getSettingValue("GamePlay", "bShowQuestMarkers", Prefs, "1")
				GuiControl, Main:, ShowQuestMarkers, %ShowQuestMarkers%
				DepthOfField := getSettingValue("Imagespace", "bDoDepthOfField", Prefs, "1")
				GuiControl, Main:, DepthOfField, %DepthOfField%
				if gameName = Skyrim Special Edition
					bDecals := getSettingValue("Decals", "bDecals", Prefs, "1")
				else
					bDecals := getSettingValue("Decals", "bDecals", blank, "1")
				GuiControl, Main:, bDecals, %bDecals%
				DisableGore := getSettingValue("General", "bDisableAllGore", blank, "0")
				GuiControl, Main:, DisableGore, %DisableGore%
				if (gameName = "Fallout 4" or gameName = "Skyrim") 
					FadeMult := Round(getSettingValue("LOD", "fDistanceMultiplier", blank, "1"),2)
				else
					FadeMult := Round(getSettingValue("LOD", "fDistanceMultiplier", blank, "1.2"),2)
				GuiControl, Main:, FadeMult, %FadeMult%
				bForceNPCsUseAmmo := getSettingValue("Combat", "bForceNPCsUseAmmo", blank, "0")
				GuiControl, Main:, bForceNPCsUseAmmo, %bForceNPCsUseAmmo%
				bDisableCombatDialogue := getSettingValue("Combat", "bDisableCombatDialogue", blank, "0")
				GuiControl, Main:, bDisableCombatDialogue, %bDisableCombatDialogue%
				if gameName = Skyrim
					FOV := sortNumberedList("55.93|65.00|70.59|85.79", Round(getSettingValue("Display", "fDefaultWorldFOV", blank, "65.00"),2))
				else if (gameName = "Fallout New Vegas" or gameName = "Fallout 3")
					FOV := sortNumberedList("59.84|69.26|75.00|85.28|91.31|107.51", Round(getSettingValue("Display", "fDefaultWorldFOV", blank, "75.00"),2))
				else if gameName = Fallout 4
					FOV := sortNumberedList("55.41|64.44|70.00|86.07", Round(getSettingValue("Display", "fDefaultWorldFOV", blank, "70.00"),2))
				else if gameName = Skyrim Special Edition
					FOV := sortNumberedList("64.37|74.12|80.00|96.42", Round(getSettingValue("Display", "fDefaultWorldFOV", blank, "80.00"),2))
				GuiControl, Main:, FOV, |%FOV%
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
						if gameName = Skyrim
							FadeDistantLOD16 := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", Prefs, "100000"),0)
						else if gameName = Skyrim Special Edition
							FadeDistantLOD16 := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", Prefs, "250000"),0)
						else
							FadeDistantLOD16 := Round(getSettingValue("TerrainManager", "fBlockLevel2Distance", Prefs, "83232"),0)
						GuiControl, Main:, FadeDistantLOD16, %FadeDistantLOD16%
						GuiControl, Main:, FadeDistantLOD16Real, %FadeDistantLOD16%
					}
				
				if gameName = Fallout 4
					{
						FadeDistantLOD32 := Round(getSettingValue("TerrainManager", "fBlockMaximumDistance", Prefs, "100000"),0)
						GuiControl, Main:, FadeDistantLOD32, %FadeDistantLOD32%
						GuiControl, Main:, FadeDistantLOD32Real, %FadeDistantLOD32%
					}
				if gameName = Skyrim Special Edition
					FadeDistantLODMult := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", Prefs, "1.5"),3)
				else
					FadeDistantLODMult := Round(getSettingValue("TerrainManager", "fSplitDistanceMult", Prefs, "0.75"),3)
				GuiControl, Main:, FadeDistantLODMult, %FadeDistantLODMult%
			}
		;	!= Skyrim Special Edition
		if (gameName = "Fallout 4" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Oblivion")
			{
				if gameName = Fallout 4
					DisableScreenshots := Abs(getSettingValue("Display", "bScreenshotToFile", blank, "1") - 1)
				else if gameName = Fallout New Vegas
					DisableScreenshots := Abs(getSettingValue("Display", "bAllowScreenShot", blank, "1") - 1)
				else
					DisableScreenshots := Abs(getSettingValue("Display", "bAllowScreenShot", blank, "0") - 1)
				GuiControl, Main:, DisableScreenshots, %DisableScreenshots%
			}
		;	!= Fallout 4
		if (gameName = "Oblivion" or gameName = "Skyrim" or gameName = "Fallout 3" or gameName = "Fallout New Vegas" or gameName = "Skyrim Special Edition")
			{
				GrassWindSpeed := getGrassWindSpeed(Round(getSettingValue("Grass", "fGrassWindMagnitudeMin", blank, "5"),0), Round(getSettingValue("Grass", "fGrassWindMagnitudeMax", blank, "125"),0))
				GuiControl, Main:, GrassWindSpeed, |%GrassWindSpeed%
				fGamma := Round(getSettingValue("Display", "fGamma", Prefs, "1"),4)*1000
				fGammaReal := Round(getSettingValue("Display", "fGamma", Prefs, "1"),4)
				GuiControl, Main:, fGamma, %fGamma%
				GuiControl, Main:, fGammaReal, %fGammaReal%
				if gameName = Oblivion
					FadeLight := Round(getSettingValue("Display", "fLightLOD2", blank, "1500"),0)
				else
					FadeLight := Round(getSettingValue("Display", "fLightLODStartFade", Prefs, "1000"),0) + Round(getSettingValue("Display", "fLightLODRange", blank, "500"),0)
				GuiControl, Main:, FadeLight, %FadeLight%
				GuiControl, Main:, FadeLightReal, %FadeLight%
			}
			
		if (gameName = "Skyrim" or gameName = "Skyrim Special Edition")
			FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"), getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLOD16Real"), getControlValue("FadeDistantLODMult"))
		else if gameName = Fallout 4
			FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"), getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLOD32Real"), getControlValue("FadeDistantLODMult"), getControlValue("FadeDistantLOD16Real"))
		else if (gameName = "Fallout 3" or gameName = "Fallout New Vegas")
			FadeDistantLOD := getFadeDistantLOD(getControlValue("FadeDistantLOD4Real"),, getControlValue("FadeDistantLOD8Real"), getControlValue("FadeDistantLODMult"))
		GuiControl, Main:, FadeDistantLOD, |%FadeDistantLOD%

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
				
				disableGuiControl("bEnableSnowRimLighting", getControlValue("bEnableImprovedSnow"))
				disableGuiControl("bToggleSparkles", getControlValue("bEnableImprovedSnow"))
				disableGuiControl("bDeactivateAOOnSnow", getControlValue("bEnableImprovedSnow"))
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
				
				enableGuiControl("ShadowRemoval", getControlValue("MaintainENBCompatibility"))
				enableGuiControl("ShadowDeffer", getControlValue("MaintainENBCompatibility"))
				enableGuiControl("ShadowLand", getControlValue("MaintainENBCompatibility"))
				enableGuiControl("PreciseLighting", getControlValue("MaintainENBCompatibility"))
				enableGuiControl("ShadowGrass", getControlValue("MaintainENBCompatibility"))
				enableGuiControl("ShadowTrees", getControlValue("MaintainENBCompatibility"))
				enableGuiControl("Antialiasing", getControlValue("MaintainENBCompatibility"))
				enableGuiControl("DepthOfField", getControlValue("MaintainENBCompatibility"))
				Gosub, MaintainENBCompatibility
			}
			
		if gameName = Oblivion
			{
				disableGuiControl("IntroMusic", getControlValue("bMusicEnabled"))
			}
		Sleep, 1000
		sm("GUI was refreshed.")
	}