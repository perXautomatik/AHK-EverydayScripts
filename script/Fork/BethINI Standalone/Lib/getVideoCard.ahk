getVideoCard()
	{
		sm("Detecting video card information...")
		if gameName = Skyrim Special Edition
			card := getSettingValue("Launcher", "sD3DDevice", Prefs)
		else
			card := getSettingValue("Display", "sD3DDevice", Prefs)
		if (card = blank or card = "Custom")
			card := getSettingValueProject("General", "sVideoCard")
		if (card = blank and gameName != "Fallout 4")
			{
				IfExist, %INIfolder%RendererInfo.txt
					FileRead, rendererInfo, %INIfolder%RendererInfo.txt
				IfExist, %A_MyDocuments%\My Games\%gameNameReg%\RendererInfo.txt
					FileRead, rendererInfo, %A_MyDocuments%\My Games\%gameNameReg%\RendererInfo.txt
				if rendererInfo !=
					{
						StringGetPos, card1, rendererInfo, `n
						carding := card1 + 3
						StringGetPos, card2, rendererInfo, `n, , %carding%
						cardChar := card2 - carding
						StringMid, card, rendererInfo, carding, cardChar
						card := Trim(card)
					}
			}
		if card =
			card = Custom
		card = "%card%"
		IniWrite, %card%, %scriptName%.ini, General, sVideoCard
		return card
	}