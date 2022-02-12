SortINI(INI)
	{
		sm("Sorting " . INI)
		SetBatchLines -1
		IniRead, SectionNames, %INI%
		Sort, SectionNames, U
		;SectionNamesArray := StrSplit(SectionNames,"`n")
		StringSplit, SectionNamesArray, SectionNames, `n
		Output =
		Loop, %SectionNamesArray0%
			{
				SectionName := SectionNamesArray%a_index%
				if Output !=
					Output = %Output%`n`n[%SectionName%]
				else
					Output = [%SectionName%]
				IniRead, PairsFull, %INI%, %SectionName%
				StringSplit, PairsArray, PairsFull, `n
				Keys =
				Values =
				Loop, %PairsArray0%
					{
						Keys = %Keys%`n
						if Values !=
							Values := Values . "," . A_Space
						Pair := PairsArray%a_index%
						If !InStr(Pair, "=")
						;IfNotInString, Pair, =
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
				StringSplit, KeysArray, Keys, `n
				Loop, %KeysArray0%
					{
						TheKey := KeysArray%a_index%
						if TheKey !=
							{
								if Output !=
									{
										Output = %Output%`n
									}
								key = %TheKey%
								array := stringToArray(Values)
								value := array[key]
								TheValue := value
								Output = %Output%%TheKey%=%TheValue%
							}
					}
			}
		Output := StrReplace(StrReplace(Output, "@@@", """"), "EVERYTHINGISAWESOME=")
		FileDelete, %INI%
		FileAppend, %Output%, %INI%
	}