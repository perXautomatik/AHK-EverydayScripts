FixINI()
	{

		
		sm("Deleting invalid settings...")
		if gameName = Skyrim
			{
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad/Multithreading
				
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, NavMesh
				
				;/* Should no longer be needed.
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iShadowMapResolutionPrimary
				IniDelete, %INIfolder%%gameNameINI%.ini, HAVOK, iNumHWThreads
				IniDelete, %INIfolder%%gameNameINI%.ini, MapMenu, fShadowLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%.ini, MapMenu, fSpecularLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%.ini, VATS, fShadowLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%.ini, VATS, fSpecularLODMaxStartFade

				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, bMouseAcceleration
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, bDecals
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, bSkinnedDecals
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, uMaxSkinDecals
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, uMaxSkinDecalsPerActor
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iAdapter
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iActorShadowCountExt
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iActorShadowCountInt
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iPresentInterval
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iShadowMapResolutionSecondary
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iShadowMapResolutionPrimary
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iShadowSplitCount
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iRadialBlurLevel
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, General, fBrightLightColorB
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, General, fBrightLightColorG
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, General, fBrightLightColorR
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, General, fDefaultFOV
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, General, bGamepadEnable				
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Imagespace, iRadialBlurLevel
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Launcher, iScreenShotIndex
				;*/
				
				sm("Invalid settings deleted.")
				sm("Controversial settings shall be sought out and questioned if found.")
				if getSettingValue("HAVOK", "iNumThreads", blank, "1") != 1
					{
						MsgBox, 4, Controversial tweak detected!, Warning! iNumThreads setting under Havok section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 1, %INIfolder%%gameNameINI%.ini, HAVOK, iNumThreads
							}
					}
				if getSettingValue("General", "iPreloadSizeLimit", blank, "26214400") != 26214400
					{
						MsgBox, 4, Controversial tweak detected!, Warning! iPreloadSizeLimit setting under General section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 26214400, %INIfolder%%gameNameINI%.ini, General, iPreloadSizeLimit
							}
					}
				if getSettingValue("General", "uGridsToLoad", blank, "5") != 5
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uGridsToLoad setting under General section is not set to its default value. This will probably negatively affect performance/stability. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 5, %INIfolder%%gameNameINI%.ini, General, uGridsToLoad
							}
					}
				if getSettingValue("General", "uExterior Cell Buffer", blank, "36") <> (getSettingValue("General", "uGridsToLoad", blank, "5") + 1)**2
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uExterior Cell Buffer setting under General section is not set to the correct value for the uGridsToLoad you currently are using. This will probably negatively affect performance/stability. Would you like to set it to the correct value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, % (getSettingValue("General", "uGridsToLoad", blank, "5") + 1)**2, %INIfolder%%gameNameINI%.ini, General, uExterior Cell Buffer
							}
					}
				if getSettingValue("General", "uInterior Cell Buffer", blank, "3") != 3
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uInterior Cell Buffer setting under General section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 3, %INIfolder%%gameNameINI%.ini, General, uInterior Cell Buffer
							}
					}
				if getSettingValue("General", "iFPSClamp", blank, "0") != 0
					{
						iFPSClamp := getSettingValue("General", "iFPSClamp", blank, "0")
						MsgBox, 4, Controversial tweak detected!, Warning! iFPSClamp setting under General section is not set to its default value. This can cause the game to be bugged if you do not have a stable framerate of %iFPSClamp%. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, iFPSClamp
							}
					}
				sm("Finished handling controversial settings.")
				sm("Correcting known harmful settings...")
				
				if (getSettingValue("Archive", "sResourceArchiveList", blank, "SKYRIM - MISC.BSA, SKYRIM - SHADERS.BSA, SKYRIM - TEXTURES.BSA, SKYRIM - MESHES.BSA, SKYRIM - ANIMATIONS.BSA, SKYRIM - VOICES.BSA, SKYRIM - VOICES2.BSA, SKYRIM - INTERFACE.BSA, SKYRIM - SOUNDS.BSA") = "SKYRIM - MISC.BSA, SKYRIM - SHADERS.BSA, SKYRIM - TEXTURES.BSA, SKYRIM - MESHES.BSA, SKYRIM - ANIMATIONS.BSA, SKYRIM - VOICES.BSA, SKYRIM - VOICES2.BSA, SKYRIM - INTERFACE.BSA, SKYRIM - SOUNDS.BSA")
					{
						IniWrite, % "Skyrim - Misc.bsa, Skyrim - Shaders.bsa, Skyrim - Textures.bsa, Skyrim - Interface.bsa, Skyrim - Animations.bsa, Skyrim - Meshes.bsa, Skyrim - Sounds.bsa", %INIfolder%%gameNameINI%.ini, Archive, sResourceArchiveList
						sm("sResourceArchiveList was the default incorrect trickery.")
					}
				if (getSettingValue("Archive", "sResourceArchiveList2", blank, blank) = blank and isEnderalForgotten <> 1)
					{
						IniWrite, % "Skyrim - Voices.bsa, Skyrim - VoicesExtra.bsa", %INIfolder%%gameNameINI%.ini, Archive, sResourceArchiveList2
						sm("sResourceArchiveList2 was blank.")
					}
				if (getSettingValue("Archive", "sResourceArchiveList2", blank, blank) <> "E - Meshes.bsa, E - Music.bsa, E - Scripts.bsa, E - Sounds.bsa, E - Textures1.bsa, E - Textures2.bsa, E - Textures3.bsa, L - Textures.bsa, L - Voices.bsa" and isEnderalForgotten = 1)
					{
						IniWrite, % "E - Meshes.bsa, E - Music.bsa, E - Scripts.bsa, E - Sounds.bsa, E - Textures1.bsa, E - Textures2.bsa, E - Textures3.bsa, L - Textures.bsa, L - Voices.bsa", %INIfolder%%gameNameINI%.ini, Archive, sResourceArchiveList2
						sm("sResourceArchiveList2 was not pointed to the Enderal BSA files!")
					}
				if getSettingValue("Display", "bAutoViewDistance", blank, "0") = 1
					IniWrite, 0, %INIfolder%%gameNameINI%.ini, Display, bAutoViewDistance
				if getSettingValue("Display", "bForcePow2Textures", blank, "0") = 1
					IniWrite, 0, %INIfolder%%gameNameINI%.ini, Display, bForcePow2Textures
				if getSettingValue("Display", "bImageSpaceEffects", blank, "1") = 0
					IniWrite, 1, %INIfolder%%gameNameINI%.ini, Display, bImageSpaceEffects
				if getSettingValue("Display", "bMTRendering", blank, "0") = 1
					IniWrite, 0, %INIfolder%%gameNameINI%.ini, Display, bMTRendering
				if getSettingValue("Display", "bUse Shaders", blank, "1") = 0
					IniWrite, 1, %INIfolder%%gameNameINI%.ini, Display, bUse Shaders
				if getSettingValue("Display", "bSimpleLighting", blank, "0") = 1
					IniWrite, 0, %INIfolder%%gameNameINI%.ini, Display, bSimpleLighting
				if getSettingValue("General", "uExterior Cell Buffer", blank, "36") < 0
					IniWrite, 36, %INIfolder%%gameNameINI%.ini, General, uExterior Cell Buffer
				if getSettingValue("General", "uGridsToLoad", blank, "5") < 5
					IniWrite, 5, %INIfolder%%gameNameINI%.ini, General, uGridsToLoad
				if getSettingValue("General", "uInterior Cell Buffer", blank, "3") < 0
					IniWrite, 3, %INIfolder%%gameNameINI%.ini, General, uInterior Cell Buffer
				if getSettingValue("Grass", "iGrassCellRadius", blank, "2") <> (getSettingValue("General", "uGridsToLoad", blank, "5")-1)//2
					IniWrite, % (getSettingValue("General", "uGridsToLoad", blank, "5")-1)//2, %INIfolder%%gameNameINI%.ini, Grass, iGrassCellRadius
				if getSettingValue("Grass", "iMinGrassSize", blank, "20") < 0
					IniWrite, 20, %INIfolder%%gameNameINI%.ini, Grass, iMinGrassSize
				if getSettingValue("MapMenu", "fMapWorldYawRange", blank, "80") > 400
					IniWrite, 400, %INIfolder%%gameNameINI%.ini, MapMenu, fMapWorldYawRange
				if getSettingValue("ScreenSplatter", "bBloodSplatterEnabled", blank, "1") = 0
					IniWrite, 1, %INIfolder%%gameNameINI%.ini, ScreenSplatter, bBloodSplatterEnabled
				if getSettingValue("Water", "bUseWater", blank, "1") = 0
					IniWrite, 1, %INIfolder%%gameNameINI%.ini, Water, bUseWater
				;Prefs
				if getSettingValue("Display", "bMainZPrepass", Prefs, "0") = 1
					IniWrite, 0, %INIfolder%%gameNameINI%Prefs.ini, Display, bMainZPrepass
				if getSettingValue("Display", "iShadowFilter", Prefs, "3") < 0 or getSettingValue("Display", "iShadowFilter", Prefs, "3") > 4
					IniWrite, 3, %INIfolder%%gameNameINI%Prefs.ini, Display, iShadowFilter
				if getSettingValue("Display", "fInteriorShadowDistance", Prefs, "3000") > 3000
					IniWrite, 3000, %INIfolder%%gameNameINI%Prefs.ini, Display, fInteriorShadowDistance	
				if getSettingValue("Water", "iWaterReflectHeight", Prefs, "0") < 1
					IniWrite, 512, %INIfolder%%gameNameINI%Prefs.ini, Water, iWaterReflectHeight
				if getSettingValue("Water", "iWaterReflectWidth", Prefs, "0") < 1
					IniWrite, 512, %INIfolder%%gameNameINI%Prefs.ini, Water, iWaterReflectWidth
				sm("Known harmful settings corrected.")
				bCreationKit := getSettingValueProject("General", "bCreationKit")          ;Checks if the user has specified the Creation Kit to NOT be modified.
				if bCreationKit =
					{
						bCreationKit = 0
						IniWrite, 0, %scriptName%.ini, General, bCreationKit
					}
				if bCreationKit = 0
					sm("Creation Kit files will not be modified.")
				else if bCreationKit = 1
					{
						sm("Fixing up Creation Kit INIs...")
						sArchiveList = Skyrim - Textures.bsa,Skyrim - Meshes.bsa,Skyrim - Animations.bsa,Skyrim - Voices.bsa,Skyrim - Interface.bsa,Skyrim - Misc.bsa,Skyrim - Sounds.bsa,Skyrim - VoicesExtra.bsa,Skyrim - Shaders.bsa,Update.bsa
						IfExist, %gameFolder%Data\Dawnguard.bsa
							sArchiveList = %sArchiveList%,Dawnguard.bsa
						IfExist, %gameFolder%Data\Hearthfires.bsa
							sArchiveList = %sArchiveList%,Hearthfires.bsa
						IfExist, %gameFolder%Data\Dragonborn.bsa
							sArchiveList = %sArchiveList%,Dragonborn.bsa
						IniWrite, %sArchiveList%, %gameFolder%%gameNameINI%Editor.ini, Archive, SArchiveList
						sResourceArchiveList2 = Skyrim - Shaders.bsa, Update.bsa
						IfExist, %gameFolder%Data\Dawnguard.bsa
							sResourceArchiveList2 = %sResourceArchiveList2%, Dawnguard.bsa
						IfExist, %gameFolder%Data\Hearthfires.bsa
							sResourceArchiveList2 = %sResourceArchiveList2%, Hearthfires.bsa
						IfExist, %gameFolder%Data\Dragonborn.bsa
							sResourceArchiveList2 = %sResourceArchiveList2%, Dragonborn.bsa
						IniWrite, %sResourceArchiveList2%, %gameFolder%%gameNameINI%Editor.ini, Archive, SResourceArchiveList2
						IniWrite, 0, %gameFolder%%gameNameINI%Editor.ini, General, bUseVersionControl
						IniWrite, 1, %gameFolder%%gameNameINI%Editor.ini, General, bAllowMultipleMasterLoads
						sm("Creation Kit INIs fixed.")
						sm("Sorting Creation Kit INIs...")
						SortINI(gameFolder . gameNameINI . "Editor.ini")
						SortINI(gameFolder . gameNameINI . "EditorPrefs.ini")
						sm("Creation Kit INIs sorted.")
					}
			}
		else if gameName = Skyrim Special Edition
			{
				;/*
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, bAllowScreenshot
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fLightLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fShadowLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fSpecularLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iShadowMapResolutionPrimary
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, iMaxDecalsPerFrame
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, iMaxSkinDecalsPerFrame
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iAdapter
				;*/
				;IniDelete, %INIfolder%%gameNameINI%Prefs.ini, NavMesh
				sm("Invalid settings deleted.")
				
				sm("Controversial settings shall be sought out and questioned if found.")
				if getSettingValue("HAVOK", "iNumThreads", blank, "1") != 1
					{
						MsgBox, 4, Controversial tweak detected!, Warning! iNumThreads setting under Havok section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 1, %INIfolder%%gameNameINI%.ini, HAVOK, iNumThreads
							}
					}
				if getSettingValue("General", "iPreloadSizeLimit", blank, "26214400") != 26214400
					{
						MsgBox, 4, Controversial tweak detected!, Warning! iPreloadSizeLimit setting under General section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 26214400, %INIfolder%%gameNameINI%.ini, General, iPreloadSizeLimit
							}
					}
				if getSettingValue("General", "uGridsToLoad", blank, "5") != 5
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uGridsToLoad setting under General section is not set to its default value. This will probably negatively affect performance/stability. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 5, %INIfolder%%gameNameINI%.ini, General, uGridsToLoad
							}
					}
				if getSettingValue("General", "uExterior Cell Buffer", blank, "36") <> (getSettingValue("General", "uGridsToLoad", blank, "5") + 1)**2
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uExterior Cell Buffer setting under General section is not set to the correct value for the uGridsToLoad you currently are using. This will probably negatively affect performance/stability. Would you like to set it to the correct value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, % (getSettingValue("General", "uGridsToLoad", blank, "5") + 1)**2, %INIfolder%%gameNameINI%.ini, General, uExterior Cell Buffer
							}
					}
				if getSettingValue("General", "uInterior Cell Buffer", blank, "3") != 3
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uInterior Cell Buffer setting under General section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 3, %INIfolder%%gameNameINI%.ini, General, uInterior Cell Buffer
							}
					}
				if getSettingValue("General", "iFPSClamp", blank, "0") != 0
					{
						iFPSClamp := getSettingValue("General", "iFPSClamp", blank, "0")
						MsgBox, 4, Controversial tweak detected!, Warning! iFPSClamp setting under General section is not set to its default value. This can cause the game to be bugged if you do not have a stable framerate of %iFPSClamp%. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, iFPSClamp
							}
					}
				sm("Finished handling controversial settings.")
				
				sm("Correcting known harmful settings...")
				if getSettingValue("Grass", "iGrassCellRadius", blank, "2") <> (getSettingValue("General", "uGridsToLoad", blank, "5")-1)//2
					IniWrite, % (getSettingValue("General", "uGridsToLoad", blank, "5")-1)//2, %INIfolder%%gameNameINI%.ini, Grass, iGrassCellRadius
				if getSettingValue("Display", "bShadowsOnGrass", blank, "1") <> 1
					IniWrite, 1, %INIfolder%%gameNameINI%.ini, Display, bShadowsOnGrass
				if getSettingValue("Display", "bAutoViewDistance", blank, "0") <> 0
					IniWrite, 0, %INIfolder%%gameNameINI%.ini, Display, bAutoViewDistance
				if getSettingValue("Display", "bEnableImprovedSnow", Prefs, "1") = 1
					IniWrite, 1, %INIfolder%%gameNameINI%.ini, Display, iLandscapeMultiNormalTilingFactor
				sm("Known harmful settings corrected.")
			}
		else if gameName = Fallout 4
			{
				;/*
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, bDeferredCommands
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fShadowLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fSpecularLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fLightLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iShadowMapResolutionPrimary
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, bAllowScreenshot
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, bNvGodraysEnable
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, % "fSunUpdateThreshold:Display"
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bAllowConsole
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, fDefaultWorldFOV
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, fDefault1stPersonFOV
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, fSafeZoneYWid
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bEnableRainOcclusion
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iAdapter
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iTexMipMapSkip
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, bDecals
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, bSkinnedDecals
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, uMaxSkinDecals
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, uMaxSkinDecalsPerActor
				;*/
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader
				sm("Invalid settings deleted.")
				
				sm("Controversial settings shall be sought out and questioned if found.")
				if getSettingValue("HAVOK", "iNumThreads", blank, "7") != 7
					{
						MsgBox, 4, Controversial tweak detected!, Warning! iNumThreads setting under Havok section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 7, %INIfolder%%gameNameINI%.ini, HAVOK, iNumThreads
							}
					}
				if getSettingValue("General", "iPreloadSizeLimit", blank, "419430400") != 419430400
					{
						MsgBox, 4, Controversial tweak detected!, Warning! iPreloadSizeLimit setting under General section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 419430400, %INIfolder%%gameNameINI%.ini, General, iPreloadSizeLimit
							}
					}
				if getSettingValue("General", "uGridsToLoad", Prefs, "5") != 5
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uGridsToLoad setting under General section is not set to its default value. This will probably negatively affect performance/stability. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 5, %INIfolder%%gameNameINI%%Prefs%.ini, General, uGridsToLoad
							}
					}
				if getSettingValue("General", "uExterior Cell Buffer", blank, "36") <> (getSettingValue("General", "uGridsToLoad", Prefs, "5") + 1)**2
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uExterior Cell Buffer setting under General section is not set to the correct value for the uGridsToLoad you currently are using. This will probably negatively affect performance/stability. Would you like to set it to the correct value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, % (getSettingValue("General", "uGridsToLoad", Prefs, "5") + 1)**2, %INIfolder%%gameNameINI%.ini, General, uExterior Cell Buffer
							}
					}
				if getSettingValue("General", "uInterior Cell Buffer", blank, "3") != 3
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uInterior Cell Buffer setting under General section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 3, %INIfolder%%gameNameINI%.ini, General, uInterior Cell Buffer
							}
					}
				if getSettingValue("General", "iFPSClamp", blank, "0") != 0
					{
						iFPSClamp := getSettingValue("General", "iFPSClamp", blank, "0")
						MsgBox, 4, Controversial tweak detected!, Warning! iFPSClamp setting under General section is not set to its default value. This can cause the game to be bugged if you do not have a stable framerate of %iFPSClamp%. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, iFPSClamp
							}
					}
				sm("Finished handling controversial settings.")
				
				sm("Correcting known harmful settings...")
				if getSettingValue("Grass", "iGrassCellRadius", blank, "2") <> (getSettingValue("General", "uGridsToLoad", blank, "5")-1)//2
					IniWrite, % (getSettingValue("General", "uGridsToLoad", blank, "5")-1)//2, %INIfolder%%gameNameINI%.ini, Grass, iGrassCellRadius
				sm("Known harmful settings corrected.")
			}
		else if gameName = Oblivion
			{
				IniDelete, %INIfolder%%gameNameINI%.ini, Absorb
				IniDelete, %INIfolder%%gameNameINI%.ini, ShockBolt
				
				;/*
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterMeshesArchiveFileName
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterMiscArchiveFileName
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterSoundsArchiveFileName
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterTexturesArchiveFileName1
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterVoicesArchiveFileName1
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterVoicesArchiveFileName2
				IniDelete, %INIfolder%%gameNameINI%.ini, Audio, bDSoundHWAcceleration
				IniDelete, %INIfolder%%gameNameINI%.ini, Audio, bUseSoftwareAudio3D
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadLoading
				IniDelete, %INIfolder%%gameNameINI%.ini, Controls, bUseJoysick
				IniDelete, %INIfolder%%gameNameINI%.ini, Controls, fJoystickLookXYMult
				IniDelete, %INIfolder%%gameNameINI%.ini, Controls, fXenonLookMult
				IniDelete, %INIfolder%%gameNameINI%.ini, Controls, fXenonLookXYMult
				IniDelete, %INIfolder%%gameNameINI%.ini, Controls, iTexMipMapSkip
				IniDelete, %INIfolder%%gameNameINI%.ini, Controls, iXenonMenuStickSpeedThreshold
				IniDelete, %INIfolder%%gameNameINI%.ini, Controls, iXenonMenuStickThreshold
				IniDelete, %INIfolder%%gameNameINI%.ini, Controls, Slide Left
				IniDelete, %INIfolder%%gameNameINI%.ini, Controls, Slide Right
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fFarDistance
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, bHighQuality20Lighting
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iDifficultyLevel
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fGrassStartFadeDistance
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fGrassEndDistance
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, bLODPopActors
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, bLODPopItems
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, bLODPopObjects
				IniDelete, %INIfolder%%gameNameINI%.ini, GamePlay, iDifficultyLevel
				IniDelete, %INIfolder%%gameNameINI%.ini, General, iDifficultyLevel
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bNewAnimation
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bUseThreadedBlood
				IniDelete, %INIfolder%%gameNameINI%.ini, General, fQuestScriptDelayTime
				IniDelete, %INIfolder%%gameNameINI%.ini, General, SMainMenuMusicTrack
				IniDelete, %INIfolder%%gameNameINI%.ini, HAVOK, iResetCounter
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fLODNormalTextureBlend
				IniDelete, %INIfolder%%gameNameINI%.ini, MAIN, bEnableBorderRegion
				IniDelete, %INIfolder%%gameNameINI%.ini, MESSAGES, % "iFileLogging"
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bBackgroundPathing
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bSmoothPaths
				IniDelete, %INIfolder%%gameNameINI%.ini, SpeedTree, iTreeClonesAllowed
				IniDelete, %INIfolder%%gameNameINI%.ini, Water, SNearWaterIndoorID
				IniDelete, %INIfolder%%gameNameINI%.ini, Water, SNearWaterOutdoorID
				;*/
				sm("Invalid settings deleted.")
				
				sm("Controversial settings shall be sought out and questioned if found.")
				if getSettingValue("General", "iPreloadSizeLimit", blank, "26214400") != 26214400
					{
						MsgBox, 4, Controversial tweak detected!, Warning! iPreloadSizeLimit setting under General section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 26214400, %INIfolder%%gameNameINI%.ini, General, iPreloadSizeLimit
							}
					}
				if getSettingValue("General", "uGridsToLoad", blank, "5") != 5
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uGridsToLoad setting under General section is not set to its default value. This will probably negatively affect performance/stability. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 5, %INIfolder%%gameNameINI%.ini, General, uGridsToLoad
							}
					}
				if getSettingValue("General", "uExterior Cell Buffer", blank, "36") <> (getSettingValue("General", "uGridsToLoad", blank, "5") + 1)**2
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uExterior Cell Buffer setting under General section is not set to the correct value for the uGridsToLoad you currently are using. This will probably negatively affect performance/stability. Would you like to set it to the correct value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, % (getSettingValue("General", "uGridsToLoad", blank, "5") + 1)**2, %INIfolder%%gameNameINI%.ini, General, uExterior Cell Buffer
							}
					}
				if getSettingValue("General", "uInterior Cell Buffer", blank, "3") != 3
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uInterior Cell Buffer setting under General section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 3, %INIfolder%%gameNameINI%.ini, General, uInterior Cell Buffer
							}
					}
				if getSettingValue("General", "iFPSClamp", blank, "0") != 0
					{
						iFPSClamp := getSettingValue("General", "iFPSClamp", blank, "0")
						MsgBox, 4, Controversial tweak detected!, Warning! iFPSClamp setting under General section is not set to its default value. This can cause the game to be bugged if you do not have a stable framerate of %iFPSClamp%. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, iFPSClamp
							}
					}
				sm("Finished handling controversial settings.")
				sm("Correcting known harmful settings...")
				if getSettingValue("Display", "bForcePow2Textures", blank, "0") = 1
					IniWrite, 0, %INIfolder%%gameNameINI%.ini, Display, bForcePow2Textures
				if getSettingValue("Display", "bUse Shaders", blank, "1") = 0
					IniWrite, 1, %INIfolder%%gameNameINI%.ini, Display, bUse Shaders
				if getSettingValue("General", "uExterior Cell Buffer", blank, "36") < 0
					IniWrite, 36, %INIfolder%%gameNameINI%.ini, General, uExterior Cell Buffer
				if getSettingValue("General", "uGridsToLoad", blank, "5") < 5
					IniWrite, 5, %INIfolder%%gameNameINI%.ini, General, uGridsToLoad
				if getSettingValue("General", "uInterior Cell Buffer", blank, "3") < 0
					IniWrite, 3, %INIfolder%%gameNameINI%.ini, General, uInterior Cell Buffer
				if getSettingValue("Grass", "iMinGrassSize", blank, "20") < 0
					IniWrite, 20, %INIfolder%%gameNameINI%.ini, Grass, iMinGrassSize
				if getSettingValue("Display", "fDefaultFOV", blank, "75") <> 75
					IniWrite, 75, %INIfolder%%gameNameINI%.ini, Display, fDefaultFOV
				sm("Known harmful settings corrected.")
			}
		else if gameName = Fallout 3
			{
				IniDelete, %INIfolder%%gameNameINI%.ini, Absorb
				
				;/*
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterMeshesArchiveFileName
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterMiscArchiveFileName
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterSoundsArchiveFileName
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterTexturesArchiveFileName1
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterVoicesArchiveFileName1
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterVoicesArchiveFileName2
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, bBackgroundPathing
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, bCloneModelsInBackground
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, fBackgroundLoadClonedPerLoop
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, fBackgroundLoadingPerLoop
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iAnimaitonClonePerLoop
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadExtraMax
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadExtraMaxFPS
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadExtraMilliseconds
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadExtraMin
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadExtraMinFPS
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadFaceMult
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadLoading
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadMilliseconds
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadTreeMilliseconds
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iExteriorPriority
				IniDelete, %INIfolder%%gameNameINI%.ini, Decals, uMaxDecalCount
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, bHighQuality20Lighting
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fFarDistance
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fSpecualrStartMax
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fSpecularStartMin
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iActorShadowCount
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iActorShadowExtMax
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iActorShadowExtMin
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iActorShadowIntMax
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iActorShadowIntMin
				IniDelete, %INIfolder%%gameNameINI%.ini, DistantLOD, bUseLODLandData
				IniDelete, %INIfolder%%gameNameINI%.ini, DistantLOD, fFadeDistance
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bAllowScriptedAutosave
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bAnimationUseBlendFromPose
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bDisableHeadTracking
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bDisplayMissingContentDialogue
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bEnableProfile
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bForceReloadOnEssentialCharacterDeath
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bNewAnimation
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bUseThreadedBlood
				IniDelete, %INIfolder%%gameNameINI%.ini, General, fGlobalTimeMultiplier
				IniDelete, %INIfolder%%gameNameINI%.ini, General, fStaticScreenWaitTime
				IniDelete, %INIfolder%%gameNameINI%.ini, General, iSaveGameBackupCount
				IniDelete, %INIfolder%%gameNameINI%.ini, General, SBetaCommentFileName
				IniDelete, %INIfolder%%gameNameINI%.ini, General, SMainMenuMusicTrack
				IniDelete, %INIfolder%%gameNameINI%.ini, General, SSaveGameSafeCellID
				IniDelete, %INIfolder%%gameNameINI%.ini, General, uGridDistantCount
				IniDelete, %INIfolder%%gameNameINI%.ini, General, uGridDistantCountCity
				IniDelete, %INIfolder%%gameNameINI%.ini, General, uGridDistantTreeRange
				IniDelete, %INIfolder%%gameNameINI%.ini, General, uGridDistantTreeRangeCity
				IniDelete, %INIfolder%%gameNameINI%.ini, HAVOK, bHavokPick
				IniDelete, %INIfolder%%gameNameINI%.ini, HAVOK, iMaxPicks
				IniDelete, %INIfolder%%gameNameINI%.ini, HAVOK, iNumHavokThreads
				IniDelete, %INIfolder%%gameNameINI%.ini, HAVOK, iResetCounter
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, bUseImageSpaceMenuFX
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorHUDAltBlue
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorHUDAltGreen
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorHUDAltRed
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorHUDMainBlue
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorHUDMainGreen
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorHUDMainRed
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorMainMenuBlue
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorMainMenuGreen
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorMainMenuRed
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorPipboyBlue
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorPipboyGreen
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorPipboyRed
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorSystemBlue
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorSystemGreen
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorSystemRed
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorTerminalBlue
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorTerminalGreen
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorTerminalRed
				IniDelete, %INIfolder%%gameNameINI%.ini, InterfaceFX, bEnableFlickerMenus
				IniDelete, %INIfolder%%gameNameINI%.ini, InterfaceFX, bEnableScanlinesMenus
				IniDelete, %INIfolder%%gameNameINI%.ini, InterfaceFX, bEnableScanlinesPipboy
				IniDelete, %INIfolder%%gameNameINI%.ini, InterfaceFX, fBrightenMenus
				IniDelete, %INIfolder%%gameNameINI%.ini, InterfaceFX, fBrightenPipboy
				IniDelete, %INIfolder%%gameNameINI%.ini, InterfaceFX, fScanlineScaleMenus
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bDisplayLODBuildings
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bDisplayLODTrees
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bForceHideLODLand
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bLODPopActors
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bLODPopItems
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bLODPopObjects
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bLODPopTrees
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bLODUseCombinedLandNormalMaps
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fFadeInTimet
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fLODMultActors
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fLODMultItems
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fLODMultLandscape
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fLODMultObjects
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fTreeLODDefault
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fTreeLODMax
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fTreeLODMin
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, iBoneLODForce
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, iLODTextureSizePow2
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, iLODTextureTiling
				IniDelete, %INIfolder%%gameNameINI%.ini, LookIK, fLookAtGain
				IniDelete, %INIfolder%%gameNameINI%.ini, LookIK, fLookAtTargetGain
				IniDelete, %INIfolder%%gameNameINI%.ini, MAIN, bCloneModelsInBackground
				IniDelete, %INIfolder%%gameNameINI%.ini, MAIN, bEnableBorderRegion
				IniDelete, %INIfolder%%gameNameINI%.ini, MESSAGES, bDisableWarning
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bDebugAvoidance
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bDebugSmoothing
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bDisableAvoidance
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bDrawPathsDefault
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bDrawSmoothFailures
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bPathMovementOnly
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bSmoothPaths
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bSnapToAngle
				IniDelete, %INIfolder%%gameNameINI%.ini, Pipboy, fScanlineScalePipboy
				IniDelete, %INIfolder%%gameNameINI%.ini, RenderedTerminal, bDoRenderedTerminalScanlines
				IniDelete, %INIfolder%%gameNameINI%.ini, ScreenSplatter, bScreenSplatterEnabled
				IniDelete, %INIfolder%%gameNameINI%.ini, SpeedTree, iTreeClonesAllowed
				IniDelete, %INIfolder%%gameNameINI%.ini, TerrainManager, fBlockMorphDistanceMult
				;*/
				
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GeneralWarnings
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Absorb
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Archive
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BackgroundLoad
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, bLightAttenuation
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDRInterior
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, CameraPath
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, CopyProtectionStrings
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Debug
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, DistantLOD
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Fonts
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, FootIK
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, General
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GethitShader
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, HAVOK
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, InterfaceFX
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Landscape
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Loading
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, LookIK
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, MAIN
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, % "Menu"
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, MESSAGES
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Pathfinding
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Pipboy
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, RagdollAnim
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, RenderedTerminal
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, ScreenSplatter
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, SpeedTree
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TestAllCells
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, VATS
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Voice
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Weather

				;/*
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, bEnableAudio
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, bEnableAudioCache
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, bEnableEnviroEffectsOnPC
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, bMultiThreadAudio
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, bUseAudioDebugInformation
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fASFadeInTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fASFadeOutTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fAudioDebugDelay
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fCollisionSoundHeavyThreshold
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDBVoiceAttenuationIn2D
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogMaxDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogMinDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogueFadeDecibels
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogueFadeSecondsIn
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogueFadeSecondsOut
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogueHeadPitchExaggeration
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogueHeadRollExaggeration
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogueHeadYawExaggeration
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fEarthLargeMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fEarthMediumMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fFilterdBAttenuation
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fFilterDistortionGain
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fFilterPEQGain
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fHardLandingDamageThreshold
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fMainMenuMusicVolume
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fMaxFootstepDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fMetalLargeMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fMetalMediumMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fMinSoundVel
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fPlayerFootVolume
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fRadioDialogMute
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fRegionLoopFadeInTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fRegionLoopFadeOutTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fSkinLargeMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fSkinMediumMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fStoneLargeMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fStoneMediumMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fWoodLargeMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fWoodMediumMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, iAudioCacheSize
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, iCollisionSoundTimeDelta
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, iMaxImpactSoundCount
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, iMaxSizeForCachedSound
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, iRadioUpdateInterval			
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fAlphaAddExterior
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fAlphaAddInterior
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fBlurRadius
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fSIEmmisiveMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fSISpecularMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fSkyBrightness
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fSunlightDimmer
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, iBlendType
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, iBlurTexSize
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, iNumBlurpasses
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fBlurRadius
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fBrightClamp
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fBrightScale
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fEmissiveHDRMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fEyeAdaptSpeed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fGrassDimmer
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fSIEmmisiveMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fSISpecularMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fSkyBrightness
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fSunBrightness
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fSunlightDimmer
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fTargetLUM
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fTreeDimmer
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fUpperLUMClamp
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, iBlendType
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, iNumBlurpasses
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, bAlwaysRunByDefault
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, bBackground Keyboard
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, bBackground Mouse
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, fForegroundMouseAccelBase
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, fForegroundMouseAccelTop
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, fForegroundMouseBase
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, fForegroundMouseMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, bDecalOcclusionQuery
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, bProfileDecals
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, uMaxDecalCount
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bActorSelfShadowing
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bAllow20HairShader
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bAllow30Shaders
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bAllowPartialPrecision
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bAllowScreenShot
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bAutoViewDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDecalsOnSkinnedGeometry
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoActorShadows
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoAmbientPass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoCanopyShadowPass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoDiffusePass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoSpecularPass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoStaticAndArchShadows
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoTallGrassEffect
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoTexturePass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDynamicWindowReflections
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bEquippedTorchesCastShadows
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bForce1XShaders
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bForceMultiPass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bForcePow2Textures
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bHighQuality20Lighting
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bIgnoreResolutionCheck
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bImageSpaceEffects
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bLODNoiseAniso
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bReportBadTangentSpace
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bShadowsOnGrass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bShowMenuTextureUse
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bStaticMenuBackground
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bUse Shaders
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bUseRefractionShader
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fDecalLifetime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fDefault1stPersonFOV
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fDefaultFOV
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fEnvMapLOD1
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fEnvMapLOD2
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fEyeEnvMapLOD1
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fEyeEnvMapLOD2
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fFarDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fGammaMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fGammaMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fLandLOFadeSeconds
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fLightLODDefaultStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fLightLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fLightLODMinStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fLightLODRange
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fNearDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fNoLODFarDistanceMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fNoLODFarDistanceMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fNoLODFarDistancePct
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fPipboy1stPersonFOV
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fShadowFadeTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fShadowLODDefaultStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fShadowLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fShadowLODMinStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fShadowLODRange
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fSpecualrStartMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fSpecularLODDefaultStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fSpecularLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fSpecularLODMinStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fSpecularLODRange
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fSpecularStartMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iActorShadowCount
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iActorShadowExtMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iActorShadowExtMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iActorShadowIntMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iActorShadowIntMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iAutoViewHiFrameRate
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iAutoViewLowFrameRate
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iAutoViewMinDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iDebugTextLeftRightOffset
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iDebugTextTopBottomOffset
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iLocation X
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iLocation Y
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iNPatches
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iNPatchNOrder
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iNPatchPOrder
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iPresentInterval
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, SScreenShotBaseName
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, uVideoDeviceIdentifierPart1
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, uVideoDeviceIdentifierPart2
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, uVideoDeviceIdentifierPart3
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, uVideoDeviceIdentifierPart4
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, bAllowHavokGrabTheLiving
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, bEssentialTakeNoDamage
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, bHealthBarShowing
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, fHealthBarEmittanceFadeTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, fHealthBarEmittanceTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, fHealthBarFadeOutSpeed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, fHealthBarHeight
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, fHealthBarSpeed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, fHealthBarWidth
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, iDetectionPicks
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, bDrawShaderGrass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, bGrassPointLighting
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fGrassDefaultStartFadeDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fGrassFadeRange
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fGrassMaxStartFadeDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fGrassMinStartFadeDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fGrassWindMagnitudeMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fGrassWindMagnitudeMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fTexturePctThreshold
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fWaveOffsetRange
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, iGrassDensityEvalSize
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, iMaxGrassTypesPerTexure
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, iMinGrassSize
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bActivatePickUseGamebryoPick
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bAllowConsole
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bHideUnavailablePerks
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bUseFuzzyPicking
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bUseImageSpaceMenuFX
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fActivatePickSphereRadius
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fInterfaceTintB
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fInterfaceTintG
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fInterfaceTintR
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fKeyRepeatInterval
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fKeyRepeatTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuBackgroundOpacity
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuBGBlurRadius
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuModeAnimBlend
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuPlayerLightAmbientBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuPlayerLightAmbientGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuPlayerLightAmbientRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuPlayerLightDiffuseBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuPlayerLightDiffuseGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuPlayerLightDiffuseRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fPopUpBackgroundOpacity
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fRSMFaceSliderDefaultMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fRSMFaceSliderDefaultMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iMaxViewCasterPicksFuzzy
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iMaxViewCasterPicksGamebryo
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iMaxViewCasterPicksHavok
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSafeZoneX
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSafeZoneXWide
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSafeZoneY
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSafeZoneYWide
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorHUDAltBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorHUDAltGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorHUDAltRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorHUDMainBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorHUDMainGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorHUDMainRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorMainMenuBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorMainMenuGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorMainMenuRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorPipboyBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorPipboyGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorPipboyRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorSystemBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorSystemGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorSystemRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorTerminalBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorTerminalGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorTerminalRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bDisplayLODBuildings
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bDisplayLODLand
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bDisplayLODTrees
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bForceHideLODLand
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bLODPopActors
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bLODPopItems
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bLODPopObjects
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bLODPopTrees
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bLODUseCombinedLandNormalMaps
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bUseFaceGenLOD
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fActorLODDefault
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fActorLODMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fActorLODMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fDistanceMultiplier
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fFadeInThreshold
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fFadeInTimet
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fFadeOutThreshold
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fFadeOutTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fItemLODDefault
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fItemLODMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fItemLODMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODBoundRadiusMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLodDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutActorMultCity
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutActorMultComplex
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutActorMultInterior
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutItemMultCity
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutItemMultComplex
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutItemMultInterior
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutObjectMultCity
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutObjectMultComplex
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutObjectMultInterior
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutPercent
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODLandDropAmount
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODLandVerticalBias
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODMultActors
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODMultItems
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODMultLandscape
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODMultObjects
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODMultTrees
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODNormalTextureBlend
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODQuadMinLoadDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fObjectLODDefault
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fObjectLODMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fObjectLODMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fTalkingDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fTreeLODDefault
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fTreeLODMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fTreeLODMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iBoneLODForce
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, % "iFadeNodeMinNearDistance"
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iLODTextureSizePow2
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iLODTextureTiling
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, bUseDistantObjectBlocks
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, bUseNewTerrainSystem
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fBlockMorphDistanceMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fDefaultBlockLoadDistanceLow
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fDefaultTreeLoadDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fHighBlockLoadDistanceLow
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fHighTreeLoadDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fLowBlockLoadDistanceLow
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fLowTreeLoadDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, bForceLowDetailReflections
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, bReflectExplosions
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, bUseWaterHiRes
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, bUseWaterLOD
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, bUseWaterShader
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, fNearWaterIndoorTolerance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, fNearWaterOutdoorTolerance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, fNearWaterUnderwaterFreq
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, fNearWaterUnderwaterVolume
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, fSurfaceTileSize
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, fTileTextureDivisor
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, uNearWaterPoints
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, uNearWaterRadius
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, uSurfaceFPS
				;*/
				sm("Invalid settings deleted.")
				
				sm("Controversial settings shall be sought out and questioned if found.")
				if getSettingValue("HAVOK", "iNumThreads", blank, "1") != 1
					{
						MsgBox, 4, Controversial tweak detected!, Warning! iNumThreads setting under Havok section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 1, %INIfolder%%gameNameINI%.ini, HAVOK, iNumThreads
							}
					}
				if getSettingValue("General", "iPreloadSizeLimit", blank, "26214400") != 26214400
					{
						MsgBox, 4, Controversial tweak detected!, Warning! iPreloadSizeLimit setting under General section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 26214400, %INIfolder%%gameNameINI%.ini, General, iPreloadSizeLimit
							}
					}
				if getSettingValue("General", "uGridsToLoad", blank, "5") != 5
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uGridsToLoad setting under General section is not set to its default value. This will probably negatively affect performance/stability. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 5, %INIfolder%%gameNameINI%.ini, General, uGridsToLoad
							}
					}
				if getSettingValue("General", "uExterior Cell Buffer", blank, "36") <> (getSettingValue("General", "uGridsToLoad", blank, "5") + 1)**2
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uExterior Cell Buffer setting under General section is not set to the correct value for the uGridsToLoad you currently are using. This will probably negatively affect performance/stability. Would you like to set it to the correct value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, % (getSettingValue("General", "uGridsToLoad", blank, "5") + 1)**2, %INIfolder%%gameNameINI%.ini, General, uExterior Cell Buffer
							}
					}
				if getSettingValue("General", "uInterior Cell Buffer", blank, "3") != 3
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uInterior Cell Buffer setting under General section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 3, %INIfolder%%gameNameINI%.ini, General, uInterior Cell Buffer
							}
					}
				if getSettingValue("General", "iFPSClamp", blank, "0") != 0
					{
						iFPSClamp := getSettingValue("General", "iFPSClamp", blank, "0")
						MsgBox, 4, Controversial tweak detected!, Warning! iFPSClamp setting under General section is not set to its default value. This can cause the game to be bugged if you do not have a stable framerate of %iFPSClamp%. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, iFPSClamp
							}
					}
				sm("Finished handling controversial settings.")
				
				sm("Correcting known harmful settings...")
				
				if getSettingValue("Archive", "sArchiveList", blank, blank) = blank
					{
						IniWrite, % "Fallout - Textures.bsa, Fallout - Meshes.bsa, Fallout - Voices.bsa, Fallout - Sound.bsa, Fallout - MenuVoices.bsa, Fallout - Misc.bsa", %INIfolder%%gameNameINI%.ini, Archive, sArchiveList
						sm("sArchiveList was the default incorrect trickery.")
					}
				if getSettingValue("Fonts", "sFontFile_2", blank, blank) = blank
					IniWrite, % "Textures\Fonts\Monofonto_Large.fnt", %INIfolder%%gameNameINI%.ini, Fonts, sFontFile_2
				if getSettingValue("Fonts", "sFontFile_7", blank, blank) = blank
					IniWrite, % "Textures\Fonts\Baked-in_Monofonto_Large.fnt", %INIfolder%%gameNameINI%.ini, Fonts, sFontFile_7
				
				sm("Known harmful settings corrected.")
			}
		else if gameName = Fallout New Vegas
			{
				IniDelete, %INIfolder%%gameNameINI%.ini, Absorb
				
				;/*
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterMeshesArchiveFileName
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterMiscArchiveFileName
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterSoundsArchiveFileName
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterTexturesArchiveFileName1
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterVoicesArchiveFileName1
				IniDelete, %INIfolder%%gameNameINI%.ini, Archive, SMasterVoicesArchiveFileName2
				IniDelete, %INIfolder%%gameNameINI%.ini, Audio, bEnableTextToSpeech
				IniDelete, %INIfolder%%gameNameINI%.ini, Audio, fDialogReverbAttenuation
				IniDelete, %INIfolder%%gameNameINI%.ini, Audio, fTextToSpeechVolume
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, bBackgroundPathing
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, bCloneModelsInBackground
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, fBackgroundLoadClonedPerLoop
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, fBackgroundLoadingPerLoop
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iAnimaitonClonePerLoop
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadExtraMax
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadExtraMaxFPS
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadExtraMilliseconds
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadExtraMin
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadExtraMinFPS
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadFaceMult
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadLoading
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadMilliseconds
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iBackgroundLoadTreeMilliseconds
				IniDelete, %INIfolder%%gameNameINI%.ini, BackgroundLoad, iExteriorPriority
				IniDelete, %INIfolder%%gameNameINI%.ini, Decals, uMaxDecalCount
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, bHighQuality20Lighting
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fFarDistance
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fSpecualrStartMax
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, fSpecularStartMin
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iActorShadowCount
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iActorShadowExtMax
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iActorShadowExtMin
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iActorShadowIntMax
				IniDelete, %INIfolder%%gameNameINI%.ini, Display, iActorShadowIntMin
				IniDelete, %INIfolder%%gameNameINI%.ini, DistantLOD, bUseLODLandData
				IniDelete, %INIfolder%%gameNameINI%.ini, DistantLOD, fFadeDistance
				IniDelete, %INIfolder%%gameNameINI%.ini, Fonts, sFontFile_9
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bAllowScriptedAutosave
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bAnimationUseBlendFromPose
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bDisableHeadTracking
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bDisplayMissingContentDialogue
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bEnableProfile
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bForceReloadOnEssentialCharacterDeath
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bNewAnimation
				IniDelete, %INIfolder%%gameNameINI%.ini, General, bUseThreadedBlood
				IniDelete, %INIfolder%%gameNameINI%.ini, General, fGlobalTimeMultiplier
				IniDelete, %INIfolder%%gameNameINI%.ini, General, fStaticScreenWaitTime
				IniDelete, %INIfolder%%gameNameINI%.ini, General, iSaveGameBackupCount
				IniDelete, %INIfolder%%gameNameINI%.ini, General, SMainMenuMusicTrack
				IniDelete, %INIfolder%%gameNameINI%.ini, General, SSaveGameSafeCellID
				IniDelete, %INIfolder%%gameNameINI%.ini, General, uGridDistantCount
				IniDelete, %INIfolder%%gameNameINI%.ini, General, uGridDistantCountCity
				IniDelete, %INIfolder%%gameNameINI%.ini, General, uGridDistantTreeRange
				IniDelete, %INIfolder%%gameNameINI%.ini, General, uGridDistantTreeRangeCity
				IniDelete, %INIfolder%%gameNameINI%.ini, HAVOK, bHavokPick
				IniDelete, %INIfolder%%gameNameINI%.ini, HAVOK, iMaxPicks
				IniDelete, %INIfolder%%gameNameINI%.ini, HAVOK, iNumHavokThreads
				IniDelete, %INIfolder%%gameNameINI%.ini, HAVOK, iResetCounter
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, bUseImageSpaceMenuFX
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorHUDAltBlue
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorHUDAltGreen
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorHUDAltRed
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorHUDMainBlue
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorHUDMainGreen
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorHUDMainRed
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorMainMenuBlue
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorMainMenuGreen
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorMainMenuRed
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorPipboyBlue
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorPipboyGreen
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorPipboyRed
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorSystemBlue
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorSystemGreen
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorSystemRed
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorTerminalBlue
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorTerminalGreen
				IniDelete, %INIfolder%%gameNameINI%.ini, Interface, iSystemColorTerminalRed
				IniDelete, %INIfolder%%gameNameINI%.ini, InterfaceFX, bEnableFlickerMenus
				IniDelete, %INIfolder%%gameNameINI%.ini, InterfaceFX, bEnableScanlinesMenus
				IniDelete, %INIfolder%%gameNameINI%.ini, InterfaceFX, bEnableScanlinesPipboy
				IniDelete, %INIfolder%%gameNameINI%.ini, InterfaceFX, fBrightenMenus
				IniDelete, %INIfolder%%gameNameINI%.ini, InterfaceFX, fBrightenPipboy
				IniDelete, %INIfolder%%gameNameINI%.ini, InterfaceFX, fScanlineScaleMenus
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bDisplayLODBuildings
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bDisplayLODTrees
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bForceHideLODLand
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bLODPopActors
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bLODPopItems
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bLODPopObjects
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bLODPopTrees
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, bLODUseCombinedLandNormalMaps
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fFadeInTimet
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fLODMultActors
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fLODMultItems
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fLODMultLandscape
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fLODMultObjects
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fLODNormalTextureBlend
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fLODQuadMinLoadDistance
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fTreeLODDefault
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fTreeLODMax
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, fTreeLODMin
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, iBoneLODForce
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, iLODTextureSizePow2
				IniDelete, %INIfolder%%gameNameINI%.ini, LOD, iLODTextureTiling
				IniDelete, %INIfolder%%gameNameINI%.ini, LookIK, fLookAtGain
				IniDelete, %INIfolder%%gameNameINI%.ini, LookIK, fLookAtTargetGain
				IniDelete, %INIfolder%%gameNameINI%.ini, MAIN, bCloneModelsInBackground
				IniDelete, %INIfolder%%gameNameINI%.ini, MAIN, bEnableBorderRegion
				IniDelete, %INIfolder%%gameNameINI%.ini, MESSAGES, bDisableWarning
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bDebugAvoidance
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bDebugSmoothing
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bDisableAvoidance
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bDrawPathsDefault
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bDrawSmoothFailures
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bPathMovementOnly
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bSmoothPaths
				IniDelete, %INIfolder%%gameNameINI%.ini, Pathfinding, bSnapToAngle
				IniDelete, %INIfolder%%gameNameINI%.ini, Pipboy, fScanlineScalePipboy
				IniDelete, %INIfolder%%gameNameINI%.ini, RenderedTerminal, bDoRenderedTerminalScanlines
				IniDelete, %INIfolder%%gameNameINI%.ini, ScreenSplatter, bScreenSplatterEnabled
				IniDelete, %INIfolder%%gameNameINI%.ini, SpeedTree, iTreeClonesAllowed
				IniDelete, %INIfolder%%gameNameINI%.ini, TerrainManager, fBlockMorphDistanceMult
				;*/
				
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GeneralWarnings
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Absorb
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Archive
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BackgroundLoad
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, bLightAttenuation
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDRInterior
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, CameraPath
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, CopyProtectionStrings
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Debug
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, DistantLOD
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Fonts
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, FootIK
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, General
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GethitShader
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, HAVOK
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, InterfaceFX
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Landscape
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Loading
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, LookIK
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, MAIN
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, % "Menu"
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, MESSAGES
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Pathfinding
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Pipboy
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, RagdollAnim
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, RenderedTerminal
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, ScreenSplatter
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, SpeedTree
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TestAllCells
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, VATS
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Voice
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Weather
				
				;/*
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, bEnableAudio
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, bEnableAudioCache
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, bEnableEnviroEffectsOnPC
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, bEnableTextToSpeech
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, bMultiThreadAudio
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, bUseAudioDebugInformation
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fASFadeInTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fASFadeOutTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fAudioDebugDelay
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fCollisionSoundHeavyThreshold
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDBVoiceAttenuationIn2D
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogMaxDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogMinDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogReverbAttenuation
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogueFadeDecibels
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogueFadeSecondsIn
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogueFadeSecondsOut
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogueHeadPitchExaggeration
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogueHeadRollExaggeration
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fDialogueHeadYawExaggeration
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fEarthLargeMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fEarthMediumMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fFilterdBAttenuation
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fFilterDistortionGain
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fFilterPEQGain
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fHardLandingDamageThreshold
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fMainMenuMusicVolume
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fMaxFootstepDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fMetalLargeMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fMetalMediumMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fTextToSpeechVolume
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fPlayerFootVolume
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fRadioDialogMute
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fRegionLoopFadeInTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fRegionLoopFadeOutTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fSkinLargeMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fSkinMediumMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fStoneLargeMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fStoneMediumMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fWoodLargeMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, fWoodMediumMassMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, iAudioCacheSize
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, iCollisionSoundTimeDelta
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, iMaxImpactSoundCount
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, iMaxSizeForCachedSound
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Audio, iRadioUpdateInterval
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fAlphaAddExterior
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fAlphaAddInterior
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fBlurRadius
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fSIEmmisiveMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fSISpecularMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fSkyBrightness
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, fSunlightDimmer
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, iBlendType
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, iBlurTexSize
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShader, iNumBlurpasses
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fBlurRadius
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fBrightClamp
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fBrightScale
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fEmissiveHDRMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fEyeAdaptSpeed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fGrassDimmer
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fSIEmmisiveMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fSISpecularMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fSkyBrightness
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fSunBrightness
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fSunlightDimmer
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fTargetLUM
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fTreeDimmer
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, fUpperLUMClamp
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, iBlendType
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, BlurShaderHDR, iNumBlurpasses
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, bAlwaysRunByDefault
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, bBackground Keyboard
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, bBackground Mouse
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, fForegroundMouseAccelBase
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, fForegroundMouseAccelTop
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, fForegroundMouseBase
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Controls, fForegroundMouseMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, bDecalOcclusionQuery
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, bProfileDecals
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Decals, uMaxDecalCount
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bActorSelfShadowing
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bAllow20HairShader
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bAllow30Shaders
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bAllowPartialPrecision
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bAllowScreenShot
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bAutoViewDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDecalsOnSkinnedGeometry
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoActorShadows
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoAmbientPass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoCanopyShadowPass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoDiffusePass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoSpecularPass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoStaticAndArchShadows
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoTallGrassEffect
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDoTexturePass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bDynamicWindowReflections
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bEquippedTorchesCastShadows
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bForce1XShaders
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bForceMultiPass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bForcePow2Textures
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bHighQuality20Lighting
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bIgnoreResolutionCheck
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bImageSpaceEffects
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bLODNoiseAniso
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bReportBadTangentSpace
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bShadowsOnGrass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bShowMenuTextureUse
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bStaticMenuBackground
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bUse Shaders
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, bUseRefractionShader
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fDecalLifetime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fDefault1stPersonFOV
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fDefaultFOV
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fEnvMapLOD1
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fEnvMapLOD2
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fEyeEnvMapLOD1
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fEyeEnvMapLOD2
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fFarDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fGammaMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fGammaMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fLandLOFadeSeconds
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fLightLODDefaultStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fLightLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fLightLODMinStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fLightLODRange
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fNearDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fNoLODFarDistanceMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fNoLODFarDistanceMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fNoLODFarDistancePct
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fPipboy1stPersonFOV
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fShadowFadeTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fShadowLODDefaultStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fShadowLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fShadowLODMinStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fShadowLODRange
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fSpecualrStartMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fSpecularLODDefaultStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fSpecularLODMaxStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fSpecularLODMinStartFade
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fSpecularLODRange
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, fSpecularStartMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iActorShadowCount
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iActorShadowExtMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iActorShadowExtMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iActorShadowIntMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iActorShadowIntMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iAutoViewHiFrameRate
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iAutoViewLowFrameRate
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iAutoViewMinDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iDebugTextLeftRightOffset
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iDebugTextTopBottomOffset
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iLocation X
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iLocation Y
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iNPatches
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iNPatchNOrder
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iNPatchPOrder
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, iPresentInterval
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, SScreenShotBaseName
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, uVideoDeviceIdentifierPart1
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, uVideoDeviceIdentifierPart2
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, uVideoDeviceIdentifierPart3
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Display, uVideoDeviceIdentifierPart4
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, bAllowHavokGrabTheLiving
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, bEssentialTakeNoDamage
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, bHealthBarShowing
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, fHealthBarEmittanceFadeTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, fHealthBarEmittanceTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, fHealthBarFadeOutSpeed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, fHealthBarHeight
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, fHealthBarSpeed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, fHealthBarWidth
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, GamePlay, iDetectionPicks
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, bDrawShaderGrass
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, bGrassPointLighting
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fGrassDefaultStartFadeDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fGrassFadeRange
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fGrassMaxStartFadeDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fGrassMinStartFadeDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fGrassWindMagnitudeMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fGrassWindMagnitudeMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fTexturePctThreshold
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, fWaveOffsetRange
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, iGrassDensityEvalSize
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, iMaxGrassTypesPerTexure
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Grass, iMinGrassSize
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bActivatePickUseGamebryoPick
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bAllowConsole
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bHideUnavailablePerks
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bUseFuzzyPicking
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bUseImageSpaceMenuFX
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fActivatePickSphereRadius
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fInterfaceTintB
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fInterfaceTintG
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fInterfaceTintR
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fKeyRepeatInterval
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fKeyRepeatTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuBackgroundOpacity
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuBGBlurRadius
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuModeAnimBlend
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuPlayerLightAmbientBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuPlayerLightAmbientGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuPlayerLightAmbientRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuPlayerLightDiffuseBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuPlayerLightDiffuseGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fMenuPlayerLightDiffuseRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fPopUpBackgroundOpacity
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fRSMFaceSliderDefaultMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fRSMFaceSliderDefaultMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iMaxViewCasterPicksFuzzy
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iMaxViewCasterPicksGamebryo
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iMaxViewCasterPicksHavok
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSafeZoneX
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSafeZoneXWide
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSafeZoneY
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSafeZoneYWide
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorHUDAltBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorHUDAltGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorHUDAltRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorHUDMainBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorHUDMainGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorHUDMainRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorMainMenuBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorMainMenuGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorMainMenuRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorPipboyBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorPipboyGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorPipboyRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorSystemBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorSystemGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorSystemRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorTerminalBlue
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorTerminalGreen
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iSystemColorTerminalRed
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bDisplayLODBuildings
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bDisplayLODLand
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bDisplayLODTrees
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bForceHideLODLand
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bLODPopActors
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bLODPopItems
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bLODPopObjects
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bLODPopTrees
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bLODUseCombinedLandNormalMaps
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, bUseFaceGenLOD
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fActorLODDefault
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fActorLODMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fActorLODMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fDistanceMultiplier
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fFadeInThreshold
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fFadeInTimet
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fFadeOutThreshold
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fFadeOutTime
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fItemLODDefault
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fItemLODMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fItemLODMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODBoundRadiusMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLodDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutActorMultCity
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutActorMultComplex
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutActorMultInterior
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutItemMultCity
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutItemMultComplex
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutItemMultInterior
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutObjectMultCity
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutObjectMultComplex
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutObjectMultInterior
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODFadeOutPercent
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODLandDropAmount
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODLandVerticalBias
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODMultActors
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODMultItems
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODMultLandscape
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODMultObjects
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODMultTrees
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODNormalTextureBlend
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fLODQuadMinLoadDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fObjectLODDefault
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fObjectLODMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fObjectLODMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fTalkingDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fTreeLODDefault
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fTreeLODMax
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, fTreeLODMin
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iBoneLODForce
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, % "iFadeNodeMinNearDistance"
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iLODTextureSizePow2
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Interface, iLODTextureTiling
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, bUseDistantObjectBlocks
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, bUseNewTerrainSystem
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fBlockMorphDistanceMult
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fDefaultBlockLoadDistanceLow
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fDefaultTreeLoadDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fHighBlockLoadDistanceLow
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fHighTreeLoadDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fLowBlockLoadDistanceLow
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, TerrainManager, fLowTreeLoadDistance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, bForceLowDetailReflections
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, bReflectExplosions
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, bUseWaterHiRes
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, bUseWaterLOD
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, bUseWaterShader
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, fNearWaterIndoorTolerance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, fNearWaterOutdoorTolerance
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, fNearWaterUnderwaterFreq
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, fNearWaterUnderwaterVolume
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, fSurfaceTileSize
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, fTileTextureDivisor
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, uNearWaterPoints
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, uNearWaterRadius
				IniDelete, %INIfolder%%gameNameINI%Prefs.ini, Water, uSurfaceFPS
				;*/
				sm("Invalid settings deleted.")
				
				sm("Controversial settings shall be sought out and questioned if found.")
				if getSettingValue("HAVOK", "iNumThreads", blank, "1") != 1
					{
						MsgBox, 4, Controversial tweak detected!, Warning! iNumThreads setting under Havok section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 1, %INIfolder%%gameNameINI%.ini, HAVOK, iNumThreads
							}
					}
				if getSettingValue("General", "iPreloadSizeLimit", blank, "26214400") != 26214400
					{
						MsgBox, 4, Controversial tweak detected!, Warning! iPreloadSizeLimit setting under General section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 26214400, %INIfolder%%gameNameINI%.ini, General, iPreloadSizeLimit
							}
					}
				if getSettingValue("General", "uGridsToLoad", blank, "5") != 5
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uGridsToLoad setting under General section is not set to its default value. This will probably negatively affect performance/stability. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 5, %INIfolder%%gameNameINI%.ini, General, uGridsToLoad
							}
					}
				if getSettingValue("General", "uExterior Cell Buffer", blank, "36") <> (getSettingValue("General", "uGridsToLoad", blank, "5") + 1)**2
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uExterior Cell Buffer setting under General section is not set to the correct value for the uGridsToLoad you currently are using. This will probably negatively affect performance/stability. Would you like to set it to the correct value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, % (getSettingValue("General", "uGridsToLoad", blank, "5") + 1)**2, %INIfolder%%gameNameINI%.ini, General, uExterior Cell Buffer
							}
					}
				if getSettingValue("General", "uInterior Cell Buffer", blank, "3") != 3
					{
						MsgBox, 4, Controversial tweak detected!, Warning! uInterior Cell Buffer setting under General section is not set to its default value. This could affect performance/stability for better or for worse. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 3, %INIfolder%%gameNameINI%.ini, General, uInterior Cell Buffer
							}
					}
				if getSettingValue("General", "iFPSClamp", blank, "0") != 0
					{
						iFPSClamp := getSettingValue("General", "iFPSClamp", blank, "0")
						MsgBox, 4, Controversial tweak detected!, Warning! iFPSClamp setting under General section is not set to its default value. This can cause the game to be bugged if you do not have a stable framerate of %iFPSClamp%. Would you like to set it to the default value (recommended)?
						IfMsgBox, Yes
							{
								IniWrite, 0, %INIfolder%%gameNameINI%.ini, General, iFPSClamp
							}
					}
				sm("Finished handling controversial settings.")
				
				sm("Correcting known harmful settings...")
				
				if getSettingValue("Archive", "sArchiveList", blank, blank) = blank
					{
						IniWrite, % "Fallout - Textures.bsa, Fallout - Meshes.bsa, Fallout - Voices.bsa, Fallout - Sound.bsa, Fallout - MenuVoices.bsa, Fallout - Misc.bsa", %INIfolder%%gameNameINI%.ini, Archive, sArchiveList
						sm("sArchiveList was the default incorrect trickery.")
					}
				if getSettingValue("Fonts", "sFontFile_2", blank, blank) = blank
					IniWrite, % "Textures\Fonts\Monofonto_Large.fnt", %INIfolder%%gameNameINI%.ini, Fonts, sFontFile_2
				if getSettingValue("Fonts", "sFontFile_7", blank, blank) = blank
					IniWrite, % "Textures\Fonts\Baked-in_Monofonto_Large.fnt", %INIfolder%%gameNameINI%.ini, Fonts, sFontFile_7
					
				sm("Known harmful settings corrected.")
			}
		;if !FileExist(scriptName . ".ini")
		if getSettingValueProject("General", "bModifyCustomINIs", "1") = 1
			{
				if FileExist(INIfolder . gameNameINI . "Custom.ini")
					FileCopy, % INIfolder . gameNameINI . ".ini", % INIfolder . gameNameINI . "Custom.ini", 1
				if FileExist(INIfolder . "Custom.ini")
					FileCopy, % INIfolder . gameNameINI . ".ini", % INIfolder . "Custom.ini", 1
			}
			
		;Workaround for JIP LN NVSE Plugin
		if gameName = Fallout New Vegas
			if (FileExist(INIfolder . gameNameINI . "Custom.ini") and getSettingValueProject("General", "bModifyCustomINIs", "1") = 1)
				{
					IntegrateINI(INIfolder . gameNameINI . Prefs . ".ini", INIfolder . gameNameINI . "Custom.ini")
				}
			else
				{
					if !FileExist(gameFolder . gameNameINI . "_default.ini.BethINIbackup")
						FileCopy, %gameFolder%%gameNameINI%_default.ini, %gameFolder%%gameNameINI%_default.ini.BethINIbackup
					FileCopy, %INIfolder%%gameNameINI%.ini, %gameFolder%%gameNameINI%_default.ini, 1
				}
		
		sm("Running the Summary() function, which helps remove nonsense from the INI files.")
		GuiControl, Summary:, GameNameINITab, %blank%
		Summary(INIfolder . shortName . " Cache\" . theTime . "\" . gameNameINI . ".ini")
		if gameName != Oblivion
			{
				GuiControl, Summary:, GameNameINIPrefsTab, %blank%
				Summary(INIfolder . shortName . " Cache\" . theTime . "\" . gameNameINI . Prefs . ".ini", Prefs)
			}
			
		GuiControlGet, GameNameINITab, Summary:, GameNameINITab
		sm("Summary of Changes for Base INI is:" . GameNameINITab)
		GuiControlGet, GameNameINIPrefsTab, Summary:, GameNameINIPrefsTab
		sm("Summary of Changes for Prefs INI is:" . GameNameINIPrefsTab)
		
		;trying to work around the delete everything bug.
		if gameName = Fallout 4
			{
				if (getSettingValue("General", "uGridsToLoad", Prefs, "NoValue") = "NoValue")
					{
						GuiControl, Disable, CustomTab
						IniWrite, 0, %scriptName%.ini, General, bDeleteInvalidSettingsOnSummary
						sm("Error! BethINI failed to safely modify your INI files! BethINI will now restore your INI files to how they were at startup.")
						MsgBox, Error! BethINI failed to safely modify your INI files! BethINI will now restore your INI files to how they were at startup. Please copy the contents of the Log tab and notify me if you get this error. Invalid settings auto-detection will be disabled on next launch, so you should be able to relaunch BethINI and safely modify your INI files.
						Restore()
						ExitApp
					}
			}
		else
			{
				if (getSettingValue("General", "uGridsToLoad", blank, "NoValue") = "NoValue")
					{
						GuiControl, Disable, CustomTab
						IniWrite, 0, %scriptName%.ini, General, bDeleteInvalidSettingsOnSummary
						sm("Error! BethINI failed to safely modify your INI files! BethINI will now restore your INI files to how they were at startup.")
						MsgBox, Error! BethINI failed to safely modify your INI files! BethINI will now restore your INI files to how they were at startup. Please copy the contents of the Log tab and notify me if you get this error. Invalid settings auto-detection will be disabled on next launch, so you should be able to relaunch BethINI and safely modify your INI files.
						Restore()
						ExitApp
					}
			}
		
		
		sm("Sorting INIs...")
		SortINI(INIfolder . gameNameINI . ".ini")
		if gameName != Oblivion
			SortINI(INIfolder . gameNameINI . Prefs . ".ini")
		if getSettingValueProject("General", "bModifyCustomINIs", "1") = 1
			{
				if FileExist(INIfolder . gameNameINI . "Custom.ini")
					SortINI(INIfolder . gameNameINI . "Custom.ini")
				if FileExist(INIfolder . "Custom.ini")
					SortINI(INIfolder . "Custom.ini")
			}
		sm("INIs sorted.")
		if RedOnly = 1
			{
				FileSetAttrib, +R, %INIfolder%%gameNameINI%.ini
				if FileExist(INIfolder . gameNameINI . "Prefs.ini")
					FileSetAttrib, +R, %INIfolder%%gameNameINI%Prefs.ini
				if FileExist(INIfolder . gameNameINI . "Custom.ini")
					FileSetAttrib, +R, %INIfolder%%gameNameINI%Custom.ini
				if FileExist(INIfolder . "Custom.ini")
					FileSetAttrib, +R, %INIfolder%Custom.ini
			}
		else
			{
				FileSetAttrib, -R, %INIfolder%%gameNameINI%.ini
				if FileExist(INIfolder . gameNameINI . "Prefs.ini")
					FileSetAttrib, -R, %INIfolder%%gameNameINI%Prefs.ini
				if FileExist(INIfolder . gameNameINI . "Custom.ini")
					FileSetAttrib, -R, %INIfolder%%gameNameINI%Custom.ini
				if FileExist(INIfolder . "Custom.ini")
					FileSetAttrib, -R, %INIfolder%Custom.ini
			}
	}