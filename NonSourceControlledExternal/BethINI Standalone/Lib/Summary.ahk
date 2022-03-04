Summary(INI, IsItPrefs="")
	{		
		FileRead, SummaryBackup, % INIfolder . gameNameINI . IsItPrefs . ".ini"
			if ErrorLevel <> 0
				{
					sm("Failed to read " . INIfolder . gameNameINI . IsItPrefs . ".ini. Summary of changes cannot be refreshed.")
					return
				}
		sm("Summary Input INI:`n" . SummaryBackup)
		if !FileExist(A_ScriptDir . "\Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . IsItPrefs . ".ini")
			sm(A_ScriptDir . "\Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . IsItPrefs . ".ini does not exist!")
		sm("Default Preset Location for Invalid Settings Auto-detection: " . A_ScriptDir . "\Presets\" . gameName . "\")
		GuiControl, Disable, GameNameINI%IsItPrefs%Tab
		;SortINI(INIfolder . gameNameINI . IsItPrefs . ".ini")
		SetBatchLines -1
		IniRead, SectionNames, %INI%
		IniRead, SectionNamesCurrent, %INIfolder%%gameNameINI%%IsItPrefs%.ini
		SectionNames = %SectionNames%`n%SectionNamesCurrent%
		Sort, SectionNames, U
		StringSplit, SectionNamesArray, SectionNames, `n
		;Loop through each section
		Loop, %SectionNamesArray0%
			{
				SectionName := SectionNamesArray%a_index%
				
				;Key/Value Pairs for old INI
				IniRead, PairsFull, %INI%, %SectionName%
				StringSplit, PairsArray, PairsFull, `n
				Keys =
				Values =
				;loop through each key/value pair
				Loop, %PairsArray0%
					{
						Keys = %Keys%`n
						if Values !=
							Values := Values . "," . A_Space
						Pair := PairsArray%a_index%
						IfNotInString, Pair, =
							Pair .= "EVERYTHINGISAWESOME="
						StringSplit, KeyValueArray, Pair, =
						Loop, %KeyValueArray0%
							{
								if (Mod(a_index, 2) = 1)
									{
										Keys .= KeyValueArray%a_index%
									}
								else
									{
										keyIndex := a_index - 1
										TheValueHere := KeyValueArray%a_index%
										StringReplace, TheValueHere, TheValueHere, % """", @@@, 1
										Values .= """" . KeyValueArray%keyIndex% . """: """ . TheValueHere . """"
									}
							}
						
					}
				Sort, Keys, U
				Values = {%Values%}
				KeysOld := Keys
				ValuesOld := Values
				
				;Key/Value Pairs for current INI
				IniRead, PairsFull, %INIfolder%%gameNameINI%%IsItPrefs%.ini, %SectionName%
				StringSplit, PairsArray, PairsFull, `n
				Keys =
				Values =
				;loop through each key/value pair
				Loop, %PairsArray0%
					{
						Keys = %Keys%`n
						if Values !=
							Values := Values . "," . A_Space
						Pair := PairsArray%a_index%
						IfNotInString, Pair, =
							Pair .= "EVERYTHINGISAWESOME="
						StringSplit, KeyValueArray, Pair, =
						Loop, %KeyValueArray0%
							{
								if (Mod(a_index, 2) = 1)
									{
										Keys .= KeyValueArray%a_index%
									}
								else
									{
										keyIndex := a_index - 1
										TheValueHere := KeyValueArray%a_index%
										StringReplace, TheValueHere, TheValueHere, % """", @@@, 1
										Values .= """" . KeyValueArray%keyIndex% . """: """ . TheValueHere . """"
									}
							}
						
					}
				Sort, Keys, U
				Values = {%Values%}
				KeysCurrent := Keys
				ValuesCurrent := Values

				Values := ValuesOld
				
				Keys = %KeysOld%`n%KeysCurrent%
				Sort, Keys, U
				
				StringSplit, KeysArray, Keys, `n
				Loop, %KeysArray0%
					{
						TheKey := KeysArray%a_index%
						if TheKey !=
							{
								key = %TheKey%
								array := stringToArray(Values)
								
								if FileExist(A_ScriptDir . "\Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . IsItPrefs . ".ini")
									{
										IniRead, DefaultValue, % A_ScriptDir . "\Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . IsItPrefs . ".ini", % SectionName, % TheKey, % "Failed to retrieve a default value."
										if (DefaultValue = "Failed to retrieve a default value." and IsItPrefs = "Prefs")
											IniRead, DefaultValue, % A_ScriptDir . "\Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . ".ini", % SectionName, % TheKey, % "Failed to retrieve a default value."
										else if (DefaultValue = "Failed to retrieve a default value." and IsItPrefs <> "Prefs")
											IniRead, DefaultValue, % A_ScriptDir . "\Presets\" . gameName . "\" . gameNameINIWorkaroundForEnderalForgotten . Prefs . ".ini", % SectionName, % TheKey, % "Failed to retrieve a default value."
										if (DefaultValue = "Failed to retrieve a default value.")
											{
												if (IsItPrefs = "Prefs")
													{
														if (SectionName = "Controls" and TheKey = "bInvertYValues")
															{
																IniWrite, 0, %scriptName%.ini, General, bDeleteInvalidSettingsOnSummary
																FileDelete, % INIfolder . gameNameINI . IsItPrefs . ".ini"
																FileAppend, % SummaryBackup, % INIfolder . gameNameINI . IsItPrefs . ".ini"
																sm("Invalid settings auto-detection attempted to delete a valid setting. BethINI will now turn off auto-detection of invalid settings and restore the backup made before Summary of Changes was refreshed.")
																GuiControlGet, GameNameINIPrefsTab, Summary:, GameNameINIPrefsTab
																if GameNameINIPrefsTab contains was removed due to it being an invalid setting (not recognized by the game)
																	{
																		RefreshSummary = 1
																	}
															}
													}
												else
													{
														if (SectionName = "Archive" and TheKey = "bInvalidateOlderFiles")
															{
																IniWrite, 0, %scriptName%.ini, General, bDeleteInvalidSettingsOnSummary
																FileDelete, % INIfolder . gameNameINI . IsItPrefs . ".ini"
																FileAppend, % SummaryBackup, % INIfolder . gameNameINI . IsItPrefs . ".ini"
																sm("Invalid settings auto-detection attempted to delete a valid setting. BethINI will now turn off auto-detection of invalid settings and restore the backup made before Summary of Changes was refreshed.")
																GuiControlGet, GameNameINITab, Summary:, GameNameINITab
																if GameNameINITab contains was removed due to it being an invalid setting (not recognized by the game)
																	{
																		RefreshSummary = 1
																	}
															}
													}
												if getSettingValueProject("General", "bDeleteInvalidSettingsOnSummary", "1") = 1
													{
														IniDelete, %INIfolder%%gameNameINI%%IsItPrefs%.ini, %SectionName%, %TheKey%
														if TheKey not contains EVERYTHINGISAWESOME
															sm(TheKey . " (" . SectionName . ") was removed due to it being an invalid setting (not recognized by the game).")
													}
												else
													NoDefaultFound = 1
											}
									}
								else
									{
										DefaultValue := "Failed to retrieve a default value."
										NoDefaultFound = 1
									}
											
								if array.HasKey(key) = true
									value := array[key]
								else
									value := DefaultValue
								TheValue := value
								
								;Currently working on... SectionName, TheKey, TheValue
								
								if TheKey != EVERYTHINGISAWESOME
									{
										if TheKey contains EVERYTHINGISAWESOME
											{
												StringReplace, TheKey, TheKey, EVERYTHINGISAWESOME,, 1
												if (TheKey <> "=")
													{
														StringReplace, PairsFull, PairsFull, `n%TheKey%,, 1
														IniDelete, %INIfolder%%gameNameINI%%IsItPrefs%.ini, %SectionName%
														IniWrite, %PairsFull%, %INIfolder%%gameNameINI%%IsItPrefs%.ini, %SectionName%
														sm(TheKey . " (" . SectionName . ") was removed due to it not having an equals sign following it.")
														NoEqualsSign = 1
													}
											}
										
										StringReplace, TheValue, TheValue, @@@, % """", 1
										
										
										CurrentValue := getSettingValue(SectionName, TheKey, IsItPrefs, DefaultValue)
										if (TheValue <> CurrentValue and TheValue <> """" . CurrentValue . """")
											{
												if (CurrentValue = "Failed to retrieve a default value.") or (TheValue = "Failed to retrieve a default value.")
													{
														WhatChanged = %TheKey% was removed due to it being an invalid setting (not recognized by the game).
														if NoEqualsSign = 1
															WhatChanged = %TheKey% was removed due to it not having an equals sign following it.
														if (NoDefaultFound = 1 and CurrentValue <> "Failed to retrieve a default value.")
															WhatChanged = %TheKey% was set to %CurrentValue%. Unable to retrieve the default value.
														if (NoDefaultFound = 1 and CurrentValue = "Failed to retrieve a default value.")
															WhatChanged = %TheKey% was set to its default value, which BethINI was not able to find.
													}
												else
													WhatChanged = %TheKey% was changed from %TheValue% to %CurrentValue%
												
												if IsItPrefs =
													{
														GuiControlGet, GameNameINITab, Summary:, GameNameINITab
														if GameNameINITab not contains [%SectionName%]
															{
																if GameNameINITab !=
																	{
																		GameNameINITab = %GameNameINITab%`n`n[%SectionName%]`n%WhatChanged%
																	}
																else
																	{
																		GameNameINITab = [%SectionName%]`n%WhatChanged%
																	}
															}
														else
															{
																GameNameINITab = %GameNameINITab%`n%WhatChanged%
															}
														GuiControl, Summary:, GameNameINITab, %GameNameINITab%
													}
												else
													{
														GuiControlGet, GameNameINIPrefsTab, Summary:, GameNameINIPrefsTab
														if GameNameINIPrefsTab not contains [%SectionName%]
															{
																if GameNameINIPrefsTab !=
																	GameNameINIPrefsTab = %GameNameINIPrefsTab%`n`n[%SectionName%]`n%WhatChanged%
																else
																	GameNameINIPrefsTab = [%SectionName%]`n%WhatChanged%
															}
														else
															{
																GameNameINIPrefsTab = %GameNameINIPrefsTab%`n%WhatChanged%
															}
														GuiControl, Summary:, GameNameINIPrefsTab, %GameNameINIPrefsTab%
													}
											}
									}
							}
					}
			}
		if IsItPrefs =
			{
				global GameNameINIChanges := GameNameINITab
			}
		else
			{
				global GameNameINIPrefsChanges := GameNameINIPrefsTab
			}
		GuiControl, Enable, GameNameINI%IsItPrefs%Tab
		sm("Summary of Changes was refreshed for " . gameNameINI . IsItPrefs . ".")
		return RefreshSummary
	}